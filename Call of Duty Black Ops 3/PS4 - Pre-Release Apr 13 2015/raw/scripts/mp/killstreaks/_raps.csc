#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\array_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_raps;

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;
#using scripts\mp\teams\_teams;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_airsupport;

                                            
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\weapons\_smokegrenade;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#namespace raps_mp;



#precache( "string", "KILLSTREAK_DESTROYED_RAPS_DEPLOY_SHIP");	
#precache( "string", "KILLSTREAK_EARNED_RAPS" );
#precache( "string", "KILLSTREAK_RAPS_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_RAPS_NOT_PLACEABLE" );
#precache( "string", "KILLSTREAK_RAPS_INBOUND" );
#precache( "eventstring", "mpl_killstreak_raps" );

function init()
{	
	level.raps_settings = level.scriptbundles[ "vehiclecustomsettings" ][ "rapssettings_mp" ];
	assert( isdefined( level.raps_settings ) );
	
	level.raps = [];
	level.raps_helicopters = [];
	
	level.raps_try_detonate = &TryDetonate;
	level.raps_force_get_enemies = &ForceGetEnemies;
	level.raps_get_target_position = &GetTargetPosition;
	
	killstreaks::register( "raps", "raps", "killstreak_raps", "raps_used", &ActivateRapsKillstreak, true );
	killstreaks::register_strings( "raps", &"KILLSTREAK_EARNED_RAPS", &"KILLSTREAK_RAPS_NOT_AVAILABLE", &"KILLSTREAK_RAPS_INBOUND" );
	killstreaks::register_dialog( "raps", "mpl_killstreak_raps", 20, 21, 103, 121, 103 );
	killstreaks::allow_assists( "raps", true );
	
	InitHelicopterPositions();
	
	callback::on_connect( &OnPlayerConnect );
	
	level thread RapsHelicopterDynamicAvoidance();
	
	level.raps_helicopter_drop_tag_names = [];
	level.raps_helicopter_drop_tag_names[0] = "tag_raps_drop_left";
	level.raps_helicopter_drop_tag_names[1] = "tag_raps_drop_right";
}

function OnPlayerConnect()
{
	self.entNum = self getEntityNumber();
	level.raps[ self.entNum ] = spawnstruct();
	level.raps[ self.entNum ].killstreak_id = (-1);
	level.raps[ self.entNum ].raps = [];
	level.raps[ self.entNum ].helicopter = undefined;
}

/*	RapsHelicopterDynamicAvoidance
 * 
 * 	This method supports a simple avoidance system for the RAPS Helicopter (RAPS deploy ship).
 * 
 * 	The RAPS helicopters are required to fly at the same hight. To prevent overlapping, this system checks
 * 	the helicopters relative to each other and changes driving behavior based on different distances.
 *  The system will choose another deploy point based on distance, last pick time, and other factors.
 * 
 *	Note: tuning vars in _killstreaks.gsh using RAPS_HELAV where HELAV is short for Helicopter Avoidance
 * 
 *	The RAPS helicopter avoidance has been designed to function with at most two RAPS helicopters for now.
 * 
 *	Key concepts in use:
 * 		a. Forward Reference Point	-- distances are measured relative to this forward reference point ( RAPS_HELAV_FORWARD_OFFSET )
 * 		b. Other Forward Ref Point	-- this is the reference point used when testing distances from another helicopter ( RAPS_HELAV_OTHER_FORWARD_OFFSET )
 * 		c. Stop Distance			-- the helicopter stops when another helicopter is within this distance
 * 		d. Slow Down Distance		-- the helicopter slows down when another helicopter is within this distance
 * 		e. Pick New Goal Distance	-- the helicopter selects a new drop point when the other helicopter is within this distance
 * 		f. Backing Off				-- if a helicopter stops and the other helicopter is in front of it, it will pick a random point opposite 
 * 											the direction behind it and can pick a new goal (drop point) to go to after it backs off
 * 		g. Drive Mode				-- there are four different drive modes: expedient, cautious, more cautious, and stop.
 * 											Each has different speed, acceleration, and deceleration.
 * 
 */
function RapsHelicopterDynamicAvoidance()
{
	level endon( "game_ended" );
	
	index_to_update = 0;
	
	while( true )
	{
		RapsHelicopterDynamicAvoidanceUpdate( index_to_update );
		
		index_to_update++;
		if ( index_to_update >= level.raps_helicopters.size )
			index_to_update = 0;
			
		wait( ( 0.05 ) );
	}
}

function RapsHelicopterDynamicAvoidanceUpdate( index_to_update )
{
	helicopterRefOrigin = ( 0, 0, 0 );
	otherHelicopterRefOrigin = ( 0, 0, 0 );

	ArrayRemoveValue( level.raps_helicopters, undefined );
	
	if ( index_to_update >= level.raps_helicopters.size )
		index_to_update = 0;

	if( level.raps_helicopters.size >= 2 )
	{			
		helicopter = level.raps_helicopters[index_to_update];
		/#	helicopter.__action_just_made = false; #/
			
		for( i = 0; i < level.raps_helicopters.size; i++ )
		{
			if ( i == index_to_update )
				continue;
			
			if ( helicopter.droppingRaps )
				continue;
			
			if ( !isdefined( helicopter.lastNewGoalTime ) )
				helicopter.lastNewGoalTime = GetTime();
			
			helicopterForward = AnglesToForward( helicopter GetAngles() );
			helicopterRefOrigin = helicopter.origin + ( helicopterForward * (  500 ) );
			otherHelicopterForward = AnglesToForward( level.raps_helicopters[i] GetAngles() );
			otherHelicopterRefOrigin = level.raps_helicopters[i].origin + ( otherHelicopterForward * (  100 ) );
			deltaToOther = otherHelicopterRefOrigin - helicopterRefOrigin;
			otherInFront = ( VectorDot( helicopterForward, VectorNormalize( deltaToOther ) ) > ( 0.707 ) );
			distanceSqr = Distance2DSquared( helicopterRefOrigin, otherHelicopterRefOrigin);

			if ( (distanceSqr < ( (  200 + ( 1200 ) ) * (  200 + ( 1200 ) ) ) || helicopter GetSpeed() == 0 )
					&& (GetTime() - helicopter.lastNewGoalTime) > ( 5000 ) )
			{
				//
				//	pick a new goal based on distance, speed, and the last time picked
				//
				/#	helicopter.__last_dynamic_avoidance_action = 20;	/* new goal */ #/
				/#	helicopter.__action_just_made = true; #/
					
				helicopter UpdateHelicopterSpeed();
				if ( helicopter.isLeaving )
				{
					self.leaveLocation = GetRandomHelicopterStartOrigin();
					helicopter setVehGoalPos( self.leaveLocation, 0 );
				}
				else
				{	
					self.targetDropLocation = GetRandomHelicopterPosition( self.lastDropLocation );
					helicopter setVehGoalPos( self.targetDropLocation, 1 );
				}
				helicopter.lastNewGoalTime = GetTime();
			}
			else if ( distanceSqr < ( ( 1200 ) * ( 1200 ) )
		         	&& otherInFront
		         	&& (GetTime() - helicopter.lastStopTime) > (  500 )
				)
			{
				//
				//	do a full stop if the other helicopter is in front and is too close
				//
				/#	helicopter.__last_dynamic_avoidance_action = 10;	/* stop */ #/
				/#	helicopter.__action_just_made = true; #/
					
				helicopter StopHelicopter();
			}
			else if ( helicopter GetSpeed() == 0 && otherInFront && distanceSqr < ( ( 1200 ) * ( 1200 ) ) )
			{
				//
				//	after a full stop, have the helicopter back off if the other helicopter is in front and too close
				//	and a new drop location may be picked based on the tuning vars
				//
				/#	helicopter.__last_dynamic_avoidance_action = 50;	/* back off */ #/
				/#	helicopter.__action_just_made = true; #/
			
				delta = otherHelicopterRefOrigin - helicopterRefOrigin;
				newGoalPosition = helicopter.origin -
				           	( deltaToOther[0] * RandomFloatRange( ( 0.7 ), ( 2.5 ) ),
				              deltaToOther[1] * RandomFloatRange( ( 0.7 ), ( 2.5 )), 0 );
				helicopter UpdateHelicopterSpeed();
				helicopter setVehGoalPos( newGoalPosition, 0 );
				
				// pick a new drop location for use after the "back off" goal is reached
				if ( ( true ) || (GetTime() - helicopter.lastNewGoalTime) > ( 5000 ) )
				{
					/#	helicopter.__last_dynamic_avoidance_action = 51;	/* back off + new goal */ #/
					helicopter.targetDropLocation = GetClosestRandomHelicopterPosition( newGoalPosition, 8 );
					helicopter.lastNewGoalTime = GetTime();
				}
			}
			else if ( distanceSqr < ( ( 1000 + (  200 + ( 1200 ) ) ) * ( 1000 + (  200 + ( 1200 ) ) ) ) && helicopter.driveModeSpeedScale == 1.0 )
			{
				//
				//	slow down the helicopter if within the configured distances and at full speed
				//	there is a cautious and a more cautious speed based on if the other helicopter is in front
				//
				/#	helicopter.__last_dynamic_avoidance_action = (( otherInFront ) ? 31 : 30);	/* cautious */ #/
				/#	helicopter.__action_just_made = true; #/	
					
				helicopter UpdateHelicopterSpeed( ( (otherInFront) ? 2 : 1) );
			}
			else if ( distanceSqr >= ( ( 1000 + (  200 + ( 1200 ) ) ) * ( 1000 + (  200 + ( 1200 ) ) ) ) && helicopter.driveModeSpeedScale < 1.0 )
			{
				//
				//	speed the helicopter back up if we are beyond the slow down distance and set to drive at full speed
				//
				/#	helicopter.__last_dynamic_avoidance_action = 40;	/* expedient */ #/
				/#	helicopter.__action_just_made = true; #/

				helicopter UpdateHelicopterSpeed( 0 );
			}
			else if ( helicopter GetSpeed() == 0 && (GetTime() - helicopter.lastStopTime) > (  500 ) )
			{
				//
				// resume moving -- start mmoving again if we have stopped for too long
				//
				// devblock to report last action made intentionally left out.
				
				helicopter UpdateHelicopterSpeed();
			}
		}
		
		/#
		//================================================================================================
		//
		//	this code section is meant for visual debuggingof the RAPS Helicopter dynamic avoidance system
		//
		//------------------------------------------------------------------------------------------------
		//
		if ( GetDvarInt( "scr_raps_helav_debug" ) )
		{
			if ( isdefined( helicopter ) )
			{
				server_frames_to_persist = INT( (( 0.05 ) * 2) / .05 );
				
				Sphere( helicopterRefOrigin, 		10, ( 0, 0, 1 ), 1, false, 10, server_frames_to_persist );
				Sphere( otherHelicopterRefOrigin,	10, ( 1, 0, 0 ), 1, false, 10, server_frames_to_persist );
				
				circle( helicopterRefOrigin, ( 1000 + (  200 + ( 1200 ) ) ), 	( 1, 1, 0 ), true, true, server_frames_to_persist );	
				circle( helicopterRefOrigin, (  200 + ( 1200 ) ),	( 0, 0, 0 ), true, true, server_frames_to_persist );
				circle( helicopterRefOrigin, ( 1200 ),		( 1, 0, 0 ), true, true, server_frames_to_persist );
				
				Print3d( helicopter.origin, "Speed: " + INT( helicopter GetSpeedMPH() ), (1,1,1), 1, 2.5, server_frames_to_persist );
				
				action_debug_color = ( 0.8, 0.8, 0.8 );
				debug_action_string = "";
				if ( helicopter.__action_just_made )
					action_debug_color = ( 0, 1, 0 );
					
				switch ( helicopter.__last_dynamic_avoidance_action )
				{
					case 0:		break;	// do nothing
					case 10:	debug_action_string = "stop";			break;
					case 20:	debug_action_string = "new goal";		break;
					case 30:	debug_action_string = "cautious";		break;
					case 31:	debug_action_string = "more cautious";	break;
					case 40:	debug_action_string = "expedient";		break;
					case 50:	debug_action_string = "back off";		break;
					case 51:	debug_action_string = "back off + new goal"; break;
					default:	debug_action_string = "unknown action";	break;
				}
				
				// display last action taken
				Print3d( helicopter.origin + ( 0, 0, -50 ), debug_action_string, action_debug_color, 1, 2.5, server_frames_to_persist );

			}
		}
		//
		//------------------------------------------------------------------------------------------------
		//
		//	end of visual debug section
		//
		//================================================================================================
		#/
	}
}

function ActivateRapsKillstreak( hardpointType )
{
	player = self;
	
	if ( !player killstreakrules::isKillstreakAllowed( "raps", player.team ) )
	{
		return false;
	}
	
	if( level.raps_helicopter_positions.size <= 0 )
	{
		/# IPrintLnBold( "RAPS helicopter position error, check NavMesh." ); #/
		self iPrintLnBold( &"KILLSTREAK_RAPS_NOT_AVAILABLE" );
		return false;
	}
	
	killstreakId = player killstreakrules::killstreakStart( "raps", player.team );
	if( killstreakId == (-1) )
	{
		player iPrintLnBold( &"KILLSTREAK_RAPS_NOT_AVAILABLE" );
		return false;
	}
	
	player killstreaks::play_killstreak_start_dialog( "raps", player.team );
	
	player killstreaks::pick_pilot( "raps", 4 );
	
	player killstreaks::play_pilot_dialog( "raps", 0, true );
	
	player thread teams::WaitUntilTeamChange( player, &OnTeamChanged, player.entNum, "raps_complete" );
	level thread WatchRapsKillstreakEnd( killstreakId, player.entNum, player.team );
	
	level.raps[ player.entNum ].helicopter = player SpawnRapsHelicopter();
	if ( !isdefined( level.raps_helicopters ) ) level.raps_helicopters = []; else if ( !IsArray( level.raps_helicopters ) ) level.raps_helicopters = array( level.raps_helicopters ); level.raps_helicopters[level.raps_helicopters.size]=level.raps[ player.entNum ].helicopter;;
	level thread UpdateKillstreakOnHelicopterDeath( level.raps[ player.entNum ].helicopter, player.entNum );
	
/#
	if ( GetDvarInt( "scr_raps_debug_auto_reactivate" ) )
	{
		level thread AutoReactivateRapsKillstreak( player.entNum, player, hardpointType );
	}
#/
	
	return true;
}

/#
function AutoReactivateRapsKillstreak( ownerEntNum, player, hardpointType )
{
	while( true )
	{
		level waittill( "raps_updated_" + ownerEntNum );
		
		if( isdefined( level.raps[ ownerEntNum ].helicopter ) )
			continue;
		
		wait ( RandomFloatRange( 2.0, 5.0 ) );
		player thread ActivateRapsKillstreak( hardpointType );		
		
		return;
	}
}
#/
	
function WatchRapsKillstreakEnd( killstreakId, ownerEntNum, team )
{
	while( true )
	{
		level waittill( "raps_updated_" + ownerEntNum );
		
		if( isdefined( level.raps[ ownerEntNum ].helicopter ) )
		{
			continue;
		}
		
		killstreakrules::killstreakStop( "raps", team, killstreakId );
		return;
	}
}

function UpdateKillstreakOnHelicopterDeath( helicopter, ownerEntEnum )
{
	helicopter waittill( "death" );
	
	level notify( "raps_updated_" + ownerEntEnum );
}

function OnTeamChanged( entNum, event )
{
	DestroyAllRaps( entNum );
}

function OnEMP( attacker, ownerEntNum )
{
	DestroyAllRaps( ownerEntNum );
}

/////////////////////////////////////////////////////////////////////////////////////////////////
//HELICOPTER
/////////////////////////////////////////////////////////////////////////////////////////////////
function InitHelicopterPositions()
{
	mapCenterNode = GetClosestPointOnNavMesh( airsupport::GetMapCenter(), ( 1024 ) );
	if( !isdefined( mapCenterNode ) )
	{
		mapCenterNode = airsupport::GetMapCenter();
	}

	randomNavMeshPoints = GetNavPointsInRadius( mapCenterNode, ( 0 ), airsupport::GetMaxMapWidth(),
	                                           ( 192 ), ( 100 ), 0.01 /* hack value until we have a havok fix */);
	minFlyHeight = INT( airsupport::getMinimumFlyHeight() + ( 1000 ) );
	
	level.raps_helicopter_positions = [];
	foreach( point in randomNavMeshPoints )
	{
		spaciousPoint = GetClosestPointOnNavMesh( point, ( 192 ), ( 128 ) );
		if( isdefined( spaciousPoint ) )
		{
			TryAddPointForHelicopterPosition( spaciousPoint, minFlyHeight );
		}
	}
	
	if( level.raps_helicopter_positions.size == 0 )
	{
		/# IPrintLnBold( "Error Finding Valid RAPS Helicopter Positions, Using Default Random NavMesh Points" ); #/
		level.raps_helicopter_positions = randomNavMeshPoints;
	}
	
	/#
	if ( killstreaks::should_draw_debug( "raps" ) )
	{
		time = 9999999;
		Sphere( mapCenterNode, 20, ( 1, 1, 0 ), 1, 0, 10, time );
		Circle( mapCenterNode, airsupport::GetMaxMapWidth(), ( 0, 1, 0 ), true, true, time );
		
		foreach( point in randomNavMeshPoints )
		{
			Sphere( ( point + ( 0, 0, 950 ) ), 10, ( 0, 0, 1 ), 1, 0, 10, time );
			Circle( point, ( 128 ), ( 1, 0, 0 ), true, true, time );
		}
			
		foreach( point in level.raps_helicopter_positions )
		{
			Sphere( ( point + ( 0, 0, 1000 ) ), 10, ( 0, 1, 0 ), 1, 0, 10, time );
			Circle( point + ( 0, 0, 2 ), ( 128 ), ( 0, 1, 0 ), true, true, time );
			airsupport::debug_cylinder( point, 8, 1000, ( 0, 0.8, 0 ), 16, time );
			Box( point, (-4, -4, 0 ), ( 4, 4, 1000 ), 0, ( 0, 0.7, 0 ), 0.6, false, time );
			
			halfBoxWidth = ( 181 ) * 0.5;
			Box( point, (-halfBoxWidth, -halfBoxWidth, 2), (halfBoxWidth, halfBoxWidth, 300), 0, ( 0, 0, 0.6 ), 0.6, false, time );
		}
	}
	#/
}

function TryAddPointForHelicopterPosition( spaciousPoint, minFlyHeight )
{
	traceHeight = minFlyHeight + ( 500 );
	traceBoxHalfWidth = ( 181 ) * 0.5;
	
	if ( IsTraceSafeForRapsDroneDropFromHelicopter( spaciousPoint, traceHeight, traceBoxHalfWidth ) )
	{
		if ( !isdefined( level.raps_helicopter_positions ) ) level.raps_helicopter_positions = []; else if ( !IsArray( level.raps_helicopter_positions ) ) level.raps_helicopter_positions = array( level.raps_helicopter_positions ); level.raps_helicopter_positions[level.raps_helicopter_positions.size]=spaciousPoint;;
	}
}

function IsTraceSafeForRapsDroneDropFromHelicopter( spaciousPoint, traceHeight, traceBoxHalfWidth )
{
	start = ( spaciousPoint[0], spaciouspoint[1], traceHeight );
	end = ( spaciousPoint[0], spaciouspoint[1], spaciouspoint[2] + ( 36 ) );
	
	trace = PhysicsTrace( start, end, ( -traceBoxHalfWidth, -traceBoxHalfWidth, 0 ), ( traceBoxHalfWidth, traceBoxHalfWidth, traceBoxHalfWidth * 2.0 ), undefined, (1 << 0) );


/#
	if ( GetDvarInt( "scr_raps_nav_point_trace_debug" ) )
	{
		if (trace["fraction"] < 1.0 )
		{
			// shows the first trace hit, but from the end
			Box( end, (-traceBoxHalfWidth, -traceBoxHalfWidth, 0), (traceBoxHalfWidth, traceBoxHalfWidth, (start[2] - end[2]) * (1.0 - trace["fraction"])), 0, ( 1.0, 0, 0.0 ), 0.6, false, 9999999 );
		}
		else
		{
			// shows a small green box 
			Box( end, (-traceBoxHalfWidth, -traceBoxHalfWidth, 0), (traceBoxHalfWidth, traceBoxHalfWidth, 8.88), 0, ( 0.0, 1.0, 0.0 ), 0.6, false, 9999999 );
		}
	}
#/
		
	return ( trace["fraction"] == 1.0 && trace["surfacetype"] == "none" );
}

function GetRandomHelicopterStartOrigin()
{
	return airsupport::GetRandomHelicopterStartOrigin() + ( 0, 0, INT( airsupport::getMinimumFlyHeight() + ( 1000 ) ) );
}

function SpawnRapsHelicopter()
{
	player = self;
	
	spawnOrigin = GetRandomHelicopterStartOrigin();
	
	helicopter = SpawnHelicopter( player, spawnOrigin, ( 0, 0, 0 ), "heli_raps_mp", "veh_t7_mil_vtol_dropship_raps" );
	
	helicopter.owner = player;
	helicopter setOwner( player );
	helicopter.ownerEntNum = player.entNum;
	helicopter.droppingRaps = false;
	helicopter.isLeaving = false;
	helicopter.driveModeSpeedScale = 1.0;
	helicopter.driveModeAccel = ( 20 );
	helicopter.driveModeDecel = ( 20 );
	helicopter.lastStopTime = 0;
	helicopter.targetDropLocation = ( -9999999, -9999999, -9999999 );
	helicopter.lastDropLocation = ( -9999999, -9999999, -9999999 );
	helicopter.firstDropReferencePoint = ( player.origin[0], player.origin[1], INT( airsupport::getMinimumFlyHeight() + ( 1000 ) ));
	/#	helicopter.__last_dynamic_avoidance_action = 0;	#/
	
	helicopter.team = player.team;
	helicopter setTeam( player.team );
	helicopter clientfield::set( "enemyvehicle", 1 );
	
	helicopter.health = 99999999;
	helicopter.maxhealth = ( 3500 );
	helicopter.lowhealth = ( ( 3500 ) * 0.4 );
	
	helicopter SetCanDamage( true );
	helicopter thread killstreaks::MonitorDamage( "raps", helicopter.maxhealth, &OnDeath, helicopter.lowhealth, &OnLowHealth, 0, undefined, true );

	helicopter.rocketDamage = helicopter.maxhealth / ( 3 ) + 1;
	helicopter.remoteMissileDamage = helicopter.maxhealth / ( 1 ) + 1;
	helicopter.hackerToolDamage = helicopter.maxhealth / ( 2 ) + 1;
	helicopter.DetonateViaEMP = &raps::detonate_damage_monitored;	
	
	helicopter thread CreateRapsHelicopterInfluencer();
	
	Target_Set( helicopter, ( 0, 0, 100 ) );
	helicopter SetDrawInfrared( true );

	helicopter thread WaitForHelicopterShutdown();
	helicopter thread WatchOwnerDisconnect( player );
	helicopter thread HelicopterThink();
	helicopter thread WatchGameEnded();
/#	helicopter thread HelicopterThinkDebugVisitAll(); #/
		
	return helicopter;
}

function WaitForHelicopterShutdown()
{
	helicopter = self;
	helicopter waittill( "raps_helicopter_shutdown", killed );
	
	level notify( "raps_updated_" + helicopter.ownerEntNum );
	
	if ( Target_IsTarget( helicopter ) )
	{
		Target_Remove( helicopter );
	}
	
	if( killed )
	{
		helicopter thread Spin();
		GoalX = RandomFloatRange( 650, 700 );
		GoalY = RandomFloatRange( 650, 700 );
		
		if ( RandomIntRange ( 0, 2 ) > 0 )
			GoalX = -GoalX;
	
		if ( RandomIntRange ( 0, 2 ) > 0 )
			GoalY = -GoalY;
		
		helicopter setVehGoalPos( helicopter.origin + ( GoalX, GoalY, -RandomFloatRange( 285, 300 ) ), false );
		wait( RandomFloatRange( 3.0, 4.0 ) );
		
		helicopter Explode();
	}
	else
	{
		helicopter HelicopterLeave();
	}
	
	helicopter delete();
}

function WatchOwnerDisconnect( owner )
{
	helicopter = self;
	helicopter endon( "raps_helicopter_shutdown" );
	owner util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	helicopter notify( "raps_helicopter_shutdown", false );
}

function WatchGameEnded( )
{
	helicopter = self;
	helicopter endon( "raps_helicopter_shutdown" );
	helicopter endon( "death" );
	level waittill("game_ended");
	helicopter notify( "raps_helicopter_shutdown", false );
}

function OnDeath( attacker, weapon )
{
	helicopter = self;
	scoreevents::processscoreevent( "destroyed_raps_deployship", attacker );
	LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_RAPS_DEPLOY_SHIP", attacker.entnum );
	helicopter notify( "raps_helicopter_shutdown", true );
	
	if ( isdefined( helicopter.owner ) )
	{
		helicopter.owner killstreaks::play_pilot_dialog( "raps", 2 );
		helicopter.owner killstreaks::play_taacom_dialog( "raps", 2 );
	}
}

function OnLowHealth( attacker, weapon )
{
	helicopter = self;
	
	if ( isdefined( helicopter.owner ) )
	{
		helicopter.owner killstreaks::play_pilot_dialog( "raps", 1 );
	}
}

function GetRandomHelicopterPosition( avoidPoint = ( -9999999, -9999999, -9999999 ), avoidRadiusSqr = ( ( 600 ) * ( 600 ) ) )
{
	flyHeight = INT( airsupport::getMinimumFlyHeight() + ( 1000 ) );
	found = false;
	tries = 0;

	// try picking a location outside the avoid circle, if not possible, reduce the circle size and try again
	for( i = 0; i <= ( 3 ); i++ )	// intentionally using "<=" to get N+1 attemmpts
	{
		// for the very last attempt, make radius negative to make any point valid as a fail safe
		if ( i == ( 3 ) )
			avoidRadiusSqr = -1.0;
		
/#		if ( GetDvarInt( "scr_raps_hedeps_debug" ) > 0 )
		{
			server_frames_to_persist = INT( 3.0 / .05 );
			circle( avoidPoint, ( 600 ), 	( 1, 0, 0 ), true, true, server_frames_to_persist );
			circle( avoidPoint, ( 600 ) - 1, 	( 1, 0, 0 ), true, true, server_frames_to_persist );
			circle( avoidPoint, ( 600 ) - 2, 	( 1, 0, 0 ), true, true, server_frames_to_persist );
		}
#/
			
		while( !found && tries < level.raps_helicopter_positions.size )
		{
			index = RandomIntRange( 0, level.raps_helicopter_positions.size );
			randomPoint = ( level.raps_helicopter_positions[ index ][0], level.raps_helicopter_positions[ index ][1], flyHeight );
			found = ( Distance2DSquared( randomPoint, avoidPoint ) > avoidRadiusSqr );
			tries++;
		}
		
		if (!found)
		{
			avoidRadiusSqr *= 0.25;
			tries = 0;
		}
	}

	// note: the -1 avoid radius should force the selection of a point
	Assert( found, "Failed to find a RAPS deploy point!" );
	
	return randomPoint;
}

function GetClosestRandomHelicopterPosition( refPoint, pickCount, avoidPoint = ( -9999999, -9999999, -9999999 ) )
{
	bestPosition = GetRandomHelicopterPosition( avoidPoint );
	bestDistanceSqr = Distance2DSquared( bestPosition, refPoint );
	
	for ( i = 1; i < pickCount; i++ )
	{
		candidatePosition = GetRandomHelicopterPosition( avoidPoint );
		candidateDistanceSqr = Distance2DSquared( candidatePosition, refPoint );
		
		if ( candidateDistanceSqr < bestDistanceSqr )
		{
			bestPosition = candidatePosition;
			bestDistanceSqr = candidateDistanceSqr;
		}
	}
	
	return bestPosition;
}

function WaitForStoppingMoveToExpire()
{
	elapsedTimeStopping = GetTime() - self.lastStopTime;
	if ( elapsedTimeStopping < ( 2000 ) )
	{
		wait ( (( 2000 ) - elapsedTimeStopping) * 0.001 );
	}
}

function HelicopterThink()
{
/#
	if ( GetDvarInt( "scr_raps_debug_visit_all" ) )
	return;
#/

	self endon( "raps_helicopter_shutdown" );

	for( i = 0; i < ( 3 ); i++ )
	{
		self.targetDropLocation = ( ( i == 0 ) ? GetClosestRandomHelicopterPosition( self.firstDropReferencePoint, INT(level.raps_helicopter_positions.size * (( 66.6 ) / 100.0) + 1))
											   : 	    GetRandomHelicopterPosition( self.lastDropLocation ) );
		
		while ( Distance2DSquared( self.origin, self.targetDropLocation ) > ( 5 * 5 ) )
		{
			self WaitForStoppingMoveToExpire();
			self UpdateHelicopterSpeed();
			self setVehGoalPos( self.targetDropLocation, 1 );
			self waittill( "goal" );
		}
		
		if ( isdefined( self.owner ) )
		{
			if ( ( i + 1 ) < ( 3 ) )
			{
				self.owner killstreaks::play_pilot_dialog( "raps", 12 );
			}
			else
			{
				self.owner killstreaks::play_pilot_dialog( "raps", 13 );
			}
		}
		
		self DropRaps();
		
		wait( ( i + 1 >= ( 3 ) )
		     		? ( 2.0 ) + RandomFloatRange( -( 1.0 ), ( 1.0 ) )
		     		: ( 10.0 )		 + RandomFloatRange( -( 2.0 )	  , ( 2.0 )		 ) );
	}

	self notify( "raps_helicopter_shutdown", false );
}

/#
function HelicopterThinkDebugVisitAll()
{
	if ( GetDvarInt( "scr_raps_debug_visit_all" ) == 0 )
		return;

	for( i = 0; i < 100; i++ )
	{
		for( j = 0; j < level.raps_helicopter_positions.size; j++ )
		{
			self.targetDropLocation = ( level.raps_helicopter_positions[ j ][0], level.raps_helicopter_positions[ j ][1],  airsupport::getMinimumFlyHeight() + ( 1000 ) );
			
			while ( Distance2DSquared( self.origin, self.targetDropLocation ) > ( 5 * 5 ) )
			{
				self WaitForStoppingMoveToExpire();
				self UpdateHelicopterSpeed();
				self setVehGoalPos( self.targetDropLocation, 1 );
				self waittill( "goal" );
			}
			
			self DropRaps();
			
			wait( 1.0 );
			
			if ( GetDvarInt( "scr_raps_debug_visit_all_fake_leave" ) > 0 )
			{
				if ( (j+1) % 3 == 0 )
				{
					
					// fake a leave and then return
					self.targetDropLocation = GetRandomHelicopterStartOrigin();
					while ( Distance2DSquared( self.origin, self.targetDropLocation ) > ( 5 * 5 ) )
					{
						self WaitForStoppingMoveToExpire();
						self UpdateHelicopterSpeed();
						self setVehGoalPos( self.targetDropLocation, 1 );
						self waittill( "goal" );
					}					
				}
			}
		}
	}
		
	self notify( "raps_helicopter_shutdown", false );
}
#/

function DropRaps()
{
	level endon( "game_ended" );

	self.droppingRaps = true;
	self.lastDropLocation = self.origin;

	// reposition raps to a more precise drap location
	preciseDropLocation = 0.5 * ( self GetTagOrigin( level.raps_helicopter_drop_tag_names[0] ) + self GetTagOrigin( level.raps_helicopter_drop_tag_names[1] ) );
	preciseGoalLocation = self.targetDropLocation + (self.targetDropLocation - preciseDropLocation);
	preciseGoalLocation = ( preciseGoalLocation[0], preciseGoalLocation[1], self.targetDropLocation[2] );
	self setVehGoalPos( preciseGoalLocation, 1 );
	self waittill( "goal" );	
	
	for( i = 0; i < level.raps_settings.spawn_count; i++ )
	{
		spawn_tag = level.raps_helicopter_drop_tag_names[ i % level.raps_helicopter_drop_tag_names.size ];
		
		origin = self GetTagOrigin( spawn_tag );
		angles = self GetTagAngles( spawn_tag );
		
		if ( !isdefined( origin ) || !isdefined( angles ) )
		{
			origin = self.origin;
			angles = self.angles;			
		}
		
		self.owner thread SpawnRaps( origin, angles );
		self playsound( "veh_raps_launch" );
		wait( ( 1 ) );
	}
	
	self.droppingRaps = false;
}

function Spin()
{
	self endon( "explode" );
	
	speed = RandomIntRange( 180, 220 );
	self setyawspeed( speed, speed * 0.25, speed );	
	
	if ( RandomIntRange ( 0, 2 ) > 0 )
		speed = -speed;

	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.4) );
		wait ( 1 );
	}
}

function Explode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	self playSound( level.heli_sound["crash"] );
	self notify( "explode" );
}

function HelicopterLeave()
{
	self.isLeaving = true;
	
	if ( isdefined( self.owner ) )
	{
		self.owner killstreaks::play_pilot_dialog( "raps", 5 );
		
		self.owner killstreaks::play_taacom_dialog_response( "raps", 6 );
	}
	
	self.leaveLocation = GetRandomHelicopterStartOrigin();
	while ( Distance2DSquared( self.origin, self.leaveLocation ) > ( 600 * 600 ) )
	{
		self UpdateHelicopterSpeed();
		self setVehGoalPos( self.leaveLocation, 0 );
		self waittill( "goal" );
	}
}
	
function UpdateHelicopterSpeed( driveMode )
{	
	if ( isdefined( driveMode ) )
	{
		switch ( driveMode )
		{
			case 0:
				self.driveModeSpeedScale = 1.0;
				self.driveModeAccel = ( 20 );
				self.driveModeDecel = ( 20 );
				break;
			
			case 1:
			case 2:
				self.driveModeSpeedScale = ((driveMode == 2) ? (  0.2 ) : (  0.5 ));
				self.driveModeAccel = ( 12 );
				self.driveModeDecel = ( 100 );
				break;
		}
	}

	desiredSpeed = (self GetMaxSpeed() / 17.6) * self.driveModeSpeedScale;
	
	// use Decel as Accel when the desired speed is less than the current speed; (it's a side effect of the system)
	if ( desiredspeed < self GetSpeedMPH() )
	{
		self SetSpeed( desiredSpeed, self.driveModeDecel, self.driveModeDecel );
	}
	else
	{
		self SetSpeed( desiredSpeed, self.driveModeAccel, self.driveModeDecel );		
	}
}

function StopHelicopter()
{
	//self SetSpeed( 0, RAPS_HELAV_FULL_STOP_MODE_ACCEL, RAPS_HELAV_FULL_STOP_MODE_DECEL );
	self SetSpeed( 0, ( 500 ), ( 500 ) ); // using DECEL as accel due to way the current system works
	self.lastStopTime = GetTime();
}

/////////////////////////////////////////////////////////////////////////////////////////////////
// RAPS
/////////////////////////////////////////////////////////////////////////////////////////////////
function SpawnRaps( origin, angles )
{
	player = self;
	ownerEntNum = player.entNum;
	
	raps = SpawnVehicle( "spawner_bo3_raps_mp", origin, angles, "dynamic_spawn_ai" );
	
/#
	if ( !isdefined( raps ) )
		return;
#/
			
	if ( !isdefined( level.raps[ ownerEntNum ].raps ) ) level.raps[ ownerEntNum ].raps = []; else if ( !IsArray( level.raps[ ownerEntNum ].raps ) ) level.raps[ ownerEntNum ].raps = array( level.raps[ ownerEntNum ].raps ); level.raps[ ownerEntNum ].raps[level.raps[ ownerEntNum ].raps.size]=raps;;
	
	raps.owner = player;
	raps.team = player.team;
	raps SetTeam( player.team );
	raps SetOwner( player );
	raps clientfield::set( "enemyvehicle", 1 );
	raps SetInvisibleToAll();
	raps thread AutoSetVisibleToAll();

	raps thread sndWaitUntilLanding(player);
	raps thread CreateRapsInfluencer();
	raps thread InitEnemySelection( player );
	raps thread WatchRapsKills( player );
	raps thread WatchRapsDeath( player );
	raps thread WatchRapsGameEnd( player );
	raps thread WatchRapsTippedOver( player );
	raps thread killstreaks::WaitForTimeout( "raps", raps.settings.max_duration * 1000, &OnRapsTimeout, "death" );
}

function AutoSetVisibleToAll()
{
	self endon( "death" );

	// intent: hide the visual glitches when first spawning raps mid air
	
	{wait(.05);};
	{wait(.05);};
	
	self SetVisibleToAll();
}

function OnRapsTimeout()
{
	SelfDestruct( self, self.owner );
}

function SelfDestruct( raps, owner )
{
	raps raps::detonate( owner );
}

function WatchRapsKills( owner )
{
	owner endon( "raps_complete" );
	self endon( "death" );
	
	if( self.settings.max_kill_count == 0 )
	{
		return;
	}
	
	while( true )
	{
		self waittill( "killed", victim );
	
		if( isdefined( victim ) && IsPlayer( victim ) )
		{
			if( !isdefined( self.killCount ) )
			{
				self.killCount = 0;	
			}
			
			self.killCount++;
			if( self.killCount >= self.settings.max_kill_count )
			{
				self raps::detonate( owner );
			}
		}
	}
}

function WatchRapsTippedOver( owner )
{
	owner endon( "disconnect" );
	self endon( "death" );

	// if the raps manage to tip over and get stuck, it should detonate
	while( true )
	{
		wait 3.5;
		
		if ( Abs( self.angles[2] ) > 75 )
		{
			self raps::detonate( owner );			
		}
	}
}

function WatchRapsDeath( owner )
{
	ownerEntNum = owner.entNum;
	
	self waittill( "death", attacker );
	
	if( isdefined( attacker ) && isPlayer( attacker ) )
	{
		if( isdefined( owner ) && owner != attacker )
		{
			scoreevents::processScoreEvent( "killed_raps", attacker );
			
			if( isdefined( self.attackers ) )
			{
				foreach( player in self.attackers )
				{
					if( isPlayer( player ) && ( player != attacker ) && ( player != owner ) )
					{
						scoreevents::processScoreEvent( "killed_raps_assist", player );
					}
				}
			}
		}
	}
	
	ArrayRemoveValue( level.raps[ ownerEntNum ].raps, self );
}

function WatchRapsGameEnd( owner )
{
	self endon ( "death" );	

	level waittill( "game_ended" );
	
	if( IsAlive( self ) )
	{
		self.owner = undefined;
		self raps::detonate( self );	
	}
}

function InitEnemySelection( owner ) //self == raps
{
	owner endon( "disconnect" );
	self endon( "death" );

	self vehicle_ai::set_state( "off" );
	util::wait_network_frame(); // wait needed to get drop deploy mode to work
	util::wait_network_frame(); // need two to make sure fast forward works
	self SetVehicleForDropDeploy();
	wait( ( 3 ) );
	if ( self InitialWaitUntilSettled() )
	{
		self ResetVehicleFromDropDeploy();
		self vehicle_ai::set_state( "combat" );
		
		// try not to target the same enemy
		for( i = 0; i < level.raps[ owner.entNum ].raps.size; i++ )
		{
			raps = level.raps[ owner.entNum ].raps[ i ];
			if( isdefined( raps ) && isdefined( raps.enemy ) && isdefined( self ) && isdefined( self.enemy ) && ( raps != self ) && ( raps.enemy == self.enemy ) )
			{
				self SetPersonalThreatBias( self.enemy, -2000, 5.0 );
			}
		}
	}
	else
	{
		// could not settle, then self destruct
		SelfDestruct( self, self.owner );
	}
}






	
function InitialWaitUntilSettled()
{
	// settle z speed first	
	waitTime = 0;
	while ( Abs( self.velocity[2] ) > ( 0.1 ) && waitTime < ( 5.0 ) )
	{
		wait ( 0.2 );
		waitTime += ( 0.2 );
	}

	// wait until settled on nav mesh
	while( ( !IsPointOnMesh( self.origin ) || Abs( self.velocity[2] ) > ( 0.1 ) ) && waitTime < ( ( 5.0 ) + 5.0 ) )
	{
		wait ( 0.2 );
		waitTime += ( 0.2 );
	}

/#
	if ( ( false ) )
		waitTime += ( ( 5.0 ) + 5.0 );
#/
	
	// return true if raps settled without timing out
	return ( waitTime < ( ( 5.0 ) + 5.0 ) );
}


function DestroyAllRaps( entNum )
{
	foreach( raps in level.raps[ entNum ].raps )
	{
		if( IsAlive( raps ) )
		{
			raps.owner = undefined;
			raps raps::detonate( raps );	
		}
	}
}

//Override for scripts/shared/vehicles/_raps.gsc:force_get_enemies()
function ForceGetEnemies()
{
	foreach( player in level.players )
	{
		if( isdefined( self.owner ) && self.owner util::IsEnemyPlayer( player ) && ( !player smokegrenade::IsInSmokeGrenade() ) )
		{
			self GetPerfectInfo( player );
			return;
		}
	}
}

//Override for scripts/shared/vehicles/_raps.gsc:tryDetonate()
function TryDetonate()
{
	if( self killstreaks::EMP_IsEMPd() )
	{
		self raps::detonate( self.owner );
		return true;
	}
		
	if( isdefined( self.enemy ) && IsAlive( self.enemy ) )
	{
		/#
			recordLine( self.enemy.origin, self.origin, ( 1, .5, 0 ), "Animscript", self );
			Record3dText( "" + distance( self.enemy.origin, self.origin ), self.enemy.origin + ( 0, 0, 20 ), ( 0, 1, 0 ), "Animscript" );
		#/	
		
		if( distanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.detonation_distance) * (self.settings.detonation_distance) ) )
		{
			trace = BulletTrace( self.origin + (0,0,self.radius), self.enemy.origin + (0,0,self.radius), true, self );
			if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
			{
				self raps::detonate();
				return true;
			}
		}
	}
	
	foreach( player in level.players )
	{
		if( isdefined( self.owner ) && self.owner util::IsEnemyPlayer( player ) && ( !isdefined( self.enemy ) || player != self.enemy ) )
		{
			if( player IsNoTarget() || !IsAlive( player ) )
			{
				continue;
			}
			
			if( distanceSquared( player.origin, self.origin ) < ( (self.settings.detonation_distance) * (self.settings.detonation_distance) ) )
			{
				trace = BulletTrace( self.origin + (0,0,self.radius), player.origin + (0,0,self.radius), true, self );
				if ( trace["fraction"] === 1.0 || isdefined( trace["entity"] ) )
				{
					self raps::detonate();
					return true;
				}
			}
		}
	}
	
	return false;
}

//Override for scripts/shared/vehicles/_raps.gsc:raps_get_target_position()
function GetTargetPosition()
{
	if( self killstreaks::EMP_IsEMPd() )
	{
		return self.origin;
	}
	
	if( isdefined( self.settings.all_knowing ) )
	{
		if( isdefined( self.enemy ) && ( !self.enemy smokegrenade::IsInSmokeGrenade() ) )
		{
			return self.enemy.origin;
		}
		else
		{
			return undefined;
		}
	}
	else
	{
		return vehicle_ai::GetTargetPos( vehicle_ai::GetEnemyTarget() );
	}
}

function CreateRapsHelicopterInfluencer()
{
	helicopter = self;
	helicopter.influencerEnt = spawn( "script_model", helicopter.origin + ( 0, 0, -( airsupport::getMinimumFlyHeight() + ( 1000 ) ) ) );
	helicopter.influencerEnt.angles = ( 0, 0, 0 );
	helicopter.influencerEnt LinkTo( helicopter );
	
	preset = GetInfluencerPreset( "helicopter" );
	if( !IsDefined( preset ) )
	{
		return;
	}
		
	enemy_team_mask = helicopter spawning::get_enemy_team_mask( helicopter.team );
	helicopter.influencerEnt spawning::create_entity_influencer( "helicopter", enemy_team_mask );
	
	helicopter waittill( "death" );
	helicopter.influencerEnt Delete();
}

function CreateRapsInfluencer()
{
	raps = self;
	
	preset = GetInfluencerPreset( "raps" );
	if( !IsDefined( preset ) )
	{
		return;
	}
		
	enemy_team_mask = raps spawning::get_enemy_team_mask( raps.team );
	raps spawning::create_entity_influencer( "raps", enemy_team_mask );
}

function sndWaitUntilLanding(owner)
{
	owner endon( "raps_complete" );
	self endon( "death" );
	
	self vehicle::toggle_sounds( 0 );
	
	a_trace = BulletTrace( self.origin + (25,25,0), self.origin + ( 25, 25, -3000 ), false, undefined, true );
	v_ground = a_trace[ "position" ];
	
	if( isdefined( v_ground ) )
	{
		while( Distance( self.origin, v_ground + (-25,-25,0) ) > 400 )
		{
			wait(.1);
		}
		self playsound( "veh_raps_first_land" );
	}
	
	self vehicle::toggle_sounds( 1 );
}