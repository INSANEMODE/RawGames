#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\dev_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "string", "MP_CANNOT_LOCKON_TO_TARGET" );

#precache( "fx", "killstreaks/fx_heli_chaff" );



	
#namespace heatseekingmissile;

function init_shared()
{
	game["locking_on_sound"] = "uin_alert_lockon_start";
	game["locked_on_sound"] = "uin_alert_lockon";
	
	callback::on_spawned( &on_player_spawned );

	level.fx_flare = "killstreaks/fx_heli_chaff";

	//Dvar is used with the dev gui so as to let the player target friendly vehicles with heat-seekers.
	/#
		SetDvar("scr_freelock", "0");
	#/
}

function on_player_spawned()
{
	self endon( "disconnect" );

	self ClearIRTarget();
	thread StingerToggleLoop();
	//thread TraceConstantTest();
	self thread StingerFiredNotify();
}

function ClearIRTarget()
{
	self notify( "stop_lockon_sound" );
	self notify( "stop_locked_sound" );
	self.stingerlocksound = undefined;
	self StopRumble( "stinger_lock_rumble" );

	self.stingerLockStartTime = 0;
	self.stingerLockStarted = false;
	self.stingerLockFinalized = false;
	if( isdefined(self.stingerTarget) )
	{
		self.stingerTarget notify( "missile_unlocked" );
		LockingOn(self.stingerTarget, false);
		LockedOn(self.stingerTarget, false);
	}
	self.stingerTarget = undefined;

	self WeaponLockFree();
	self WeaponLockTargetTooClose( false );
	self WeaponLockNoClearance( false );

	self StopLocalSound( game["locking_on_sound"] );
	self StopLocalSound( game["locked_on_sound"] );

	self DestroyLockOnCanceledMessage();
}


function StingerFiredNotify()
{
	self endon( "disconnect" );
	self endon ( "death" );

	while ( true )
	{
		self waittill( "missile_fire", missile, weapon );

		if ( weapon.lockonType == "Legacy Single" )
		{
			if( isdefined(self.stingerTarget) && self.stingerLockFinalized )
			{
				self.stingerTarget notify( "stinger_fired_at_me", missile, weapon, self );
			}
		}
	}
}


function StingerToggleLoop()
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self waittill( "weapon_change", weapon );

		while ( weapon.lockonType == "Legacy Single" )
		{
			abort = false;

			while( !self PlayerStingerAds() )
			{
				{wait(.05);};

				currentWeapon = self GetCurrentWeapon();
				if ( currentWeapon.lockonType != "Legacy Single" )
				{
					abort = true;
					break;
				}
			}

			if ( abort )
			{
				break;
			}

			self thread StingerIRTLoop();

			while( self PlayerStingerAds() )
			{
				{wait(.05);};
			}

			self notify( "stinger_IRT_off" );
			self ClearIRTarget();

			weapon = self GetCurrentWeapon();
		}
	}
}

function StingerIRTLoop()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "stinger_IRT_off" );

	lockLength = self getLockOnSpeed();

	for (;;)
	{
		{wait(.05);};

		//-------------------------
		// Four possible states:
		//      No missile in the tube, so CLU will not search for targets.
		//		CLU has a lock.
		//		CLU is locking on to a target.
		//		CLU is searching for a target to begin locking on to.
		//-------------------------

		if ( self.stingerLockFinalized )
		{
			passed = SoftSightTest();
			if ( !passed )
				continue;

			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}
			
			if ( !self.stingerTarget.locked_on )
			{
				self.stingerTarget notify( "missile_lock", self, self GetCurrentWeapon() );
			}
			
			LockingOn(self.stingerTarget, false);
			LockedOn(self.stingerTarget, true);
			thread LoopLocalLockSound( game["locked_on_sound"], 0.75 );

			
			//print3D( self.stingerTarget.origin, "* LOCKED!", (.2, 1, .3), 1, 5 );
			continue;
		}

		if ( self.stingerLockStarted )
		{
			if ( ! IsStillValidTarget( self.stingerTarget ) )
			{
				self ClearIRTarget();
				continue;
			}

			//print3D( self.stingerTarget.origin, "* locking...!", (.2, 1, .3), 1, 5 );
			
			LockingOn(self.stingerTarget, true);
			LockedOn(self.stingerTarget, false);

			passed = SoftSightTest();
			if ( !passed )
				continue;

			timePassed = getTime() - self.stingerLockStartTime;
			if ( timePassed < lockLength )
				continue;

			assert( isdefined( self.stingerTarget ) );
			self notify( "stop_lockon_sound" );
			self.stingerLockFinalized = true;
			self WeaponLockFinalize( self.stingerTarget );

			continue;
		}
		
		bestTarget = self GetBestStingerTarget();
		if ( !isdefined( bestTarget ) )
		{
			self DestroyLockOnCanceledMessage();

			continue;
		}

		if ( !( self LockSightTest( bestTarget ) ) )
		{
			self DestroyLockOnCanceledMessage();
			continue;
		}

		//check for delay allowing helicopters to enter the play area
		if( self LockSightTest( bestTarget ) && isdefined( bestTarget.lockOnDelay ) && bestTarget.lockOnDelay )
		{
			self DisplayLockOnCanceledMessage();
			continue;
		}
		
		self DestroyLockOnCanceledMessage();
		InitLockField( bestTarget );
		
		self.stingerTarget = bestTarget;
		self.stingerLockStartTime = getTime();
		self.stingerLockStarted = true;
		self.stingerLostSightlineTime = 0;

		// most likely I don't need this for the stinger.
		// level.player WeaponLockStart( bestTarget );

		self thread LoopLocalSeekSound( game["locking_on_sound"], 0.6 );
	}
}

function DestroyLockOnCanceledMessage()
{
	if( isdefined( self.LockOnCanceledMessage ) )
		self.LockOnCanceledMessage destroy();
}

function DisplayLockOnCanceledMessage()
{
	if( isdefined( self.LockOnCanceledMessage ) )
		return;

	self.LockOnCanceledMessage = newclienthudelem( self );
	self.LockOnCanceledMessage.fontScale = 1.25;
	self.LockOnCanceledMessage.x = 0;
	self.LockOnCanceledMessage.y = 50; 
	self.LockOnCanceledMessage.alignX = "center";
	self.LockOnCanceledMessage.alignY = "top";
	self.LockOnCanceledMessage.horzAlign = "center";
	self.LockOnCanceledMessage.vertAlign = "top";
	self.LockOnCanceledMessage.foreground = true;
	self.LockOnCanceledMessage.hidewhendead = false;
	self.LockOnCanceledMessage.hidewheninmenu = true;
	self.LockOnCanceledMessage.archived = false;
	self.LockOnCanceledMessage.alpha = 1.0;
	self.LockOnCanceledMessage SetText( &"MP_CANNOT_LOCKON_TO_TARGET" );
}
function GetBestStingerTarget()
{
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		/#
		//This variable is set and managed by the 'dev_friendly_lock' function, which works with the dev_gui
		if( GetDvarString( "scr_freelock") == "1" )
		{
			//If the dev_gui dvar is set, only check if the target is in the reticule. 
			if( self InsideStingerReticleNoLock( targetsAll[idx] ) )
			{
				targetsValid[targetsValid.size] = targetsAll[idx];
			}
			continue;
		}
		#/

		if ( level.teamBased ) //team based game modes
		{
			if ( isdefined(targetsAll[idx].team) && targetsAll[idx].team != self.team) 
			{
				if ( self InsideStingerReticleNoLock( targetsAll[idx] ) )
				{
						targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}		
		else 
		{
			if( self InsideStingerReticleNoLock( targetsAll[idx] ) ) //Free for all
			{
				if( isdefined( targetsAll[idx].owner ) && self != targetsAll[idx].owner )
				{
					targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	chosenEnt = targetsValid[0];
	if ( targetsValid.size > 1 )
	{

		//TODO: find the closest
	}
	
	return chosenEnt;
}

function InsideStingerReticleNoLock( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

function InsideStingerReticleLocked( target )
{
	radius = self getLockOnLossRadius();
	return target_isincircle( target, self, 65, radius );
}

function IsStillValidTarget( ent )
{
	if ( ! isdefined( ent ) )
		return false;
	if ( ! target_isTarget( ent ) && !( isdefined( ent.allowContinuedLockonAfterInvis ) && ent.allowContinuedLockonAfterInvis ) )
		return false;
	if ( ! InsideStingerReticleLocked( ent ) )
		return false;

	return true;
}

function PlayerStingerAds()
{
	return ( self PlayerAds() == 1.0 );
}

function LoopLocalSeekSound( alias, interval )
{
	self endon ( "stop_lockon_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );

		wait interval/2;
	}
}

function LoopLocalLockSound( alias, interval )
{
	self endon ( "stop_locked_sound" );
	self endon( "disconnect" );
	self endon ( "death" );
	
	if ( isdefined( self.stingerlocksound ) )
		return;

	self.stingerlocksound = true;
	

	for (;;)
	{
		// TODO make lock loop audio work correctly  CDC
		
		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/6;

		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/6;

		self playLocalSound( alias );
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		wait interval/6;

		self StopRumble( "stinger_lock_rumble" );
	}
	self.stingerlocksound = undefined;
}
	
function LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isdefined( target ) ) //targets can disapear during targeting.
		return false;
	
	if( isdefined( target.parent ) )
		passed = BulletTracePassed( eyePos, target.origin, false, target, target.parent );
	else
		passed = BulletTracePassed( eyePos, target.origin, false, target );
	if ( passed )
		return true;

	front = target GetPointInBounds( 1, 0, 0 );
	if( isdefined( target.parent ) )
		passed = BulletTracePassed( eyePos, front, false, target, target.parent );
	else
		passed = BulletTracePassed( eyePos, front, false, target );
	if ( passed )
		return true;

	back = target GetPointInBounds( -1, 0, 0 );
	if( isdefined( target.parent ) )
		passed = BulletTracePassed( eyePos, back, false, target, target.parent );
	else
		passed = BulletTracePassed( eyePos, back, false, target );
	if ( passed )
		return true;

	return false;
}

function SoftSightTest()
{
	LOST_SIGHT_LIMIT = 500;

	if ( self LockSightTest( self.stingerTarget ) )
	{
		self.stingerLostSightlineTime = 0;
		return true;
	}

	if ( self.stingerLostSightlineTime == 0 )
		self.stingerLostSightlineTime = getTime();

	timePassed = GetTime() - self.stingerLostSightlineTime;
	//PrintLn( "Losing sight of target [", timePassed, "]..." );

	if ( timePassed >= LOST_SIGHT_LIMIT )
	{
		//PrintLn( "Lost sight of target." );
		self ClearIRTarget();
		return false;
	}
	
	return true;
}

function InitLockField( target )
{
	if ( isdefined( target.locking_on ) )
		return;
		
	target.locking_on = 0;
	target.locked_on = 0;
}

function LockingOn( target, lock )
{
	Assert( isdefined( target.locking_on ) );
	
	clientNum = self getEntityNumber();
	if ( lock )
	{
		target notify( "locking on" );
		target.locking_on |= ( 1 << clientNum );
		
		self thread watchClearLockingOn( target, clientNum );
	}
	else
	{
		self notify( "locking_on_cleared" );
		target.locking_on &= ~( 1 << clientNum );
	}
}

function watchClearLockingOn( target, clientNum )
{
	target endon("death");
	self endon( "locking_on_cleared" );
	
	self util::waittill_any( "death", "disconnect" );
	
	target.locking_on &= ~( 1 << clientNum );
}

function LockedOn( target, lock )
{
	Assert( isdefined( target.locked_on ) );
	
	clientNum = self getEntityNumber();
	if ( lock )
	{
		target.locked_on |= ( 1 << clientNum );
		
		self thread watchClearLockedOn( target, clientNum );
	}
	else
	{
		self notify( "locked_on_cleared" );
		target.locked_on &= ~( 1 << clientNum );
	}
}

function watchClearLockedOn( target, clientNum )
{
	self endon( "locked_on_cleared" );
	
	self util::waittill_any( "death", "disconnect" );

	if ( isdefined( target ) )
	{
		target.locked_on &= ~( 1 << clientNum );
	}
}

function MissileTarget_LockOnMonitor( player, endon1, endon2 )
{
	self endon( "death" );
	
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );

	for( ;; )
	{

		if( target_isTarget( self ) )
		{	
			if ( self MissileTarget_isMissileIncoming() )
			{
				self clientfield::set( "heli_warn_fired", 1 );
				self clientfield::set( "heli_warn_locked", 0 );
				self clientfield::set( "heli_warn_targeted", 0 );
			}	
			else if( isdefined(self.locked_on) && self.locked_on )
			{
				self clientfield::set( "heli_warn_locked", 1 );
				self clientfield::set( "heli_warn_fired", 0 );
				self clientfield::set( "heli_warn_targeted", 0 );
			}
			else if( isdefined(self.locking_on) && self.locking_on )
			{
				self clientfield::set( "heli_warn_targeted", 1 );
				self clientfield::set( "heli_warn_fired", 0 );
				self clientfield::set( "heli_warn_locked", 0 );
			}
			else
			{
				self clientfield::set( "heli_warn_fired", 0 );
				self clientfield::set( "heli_warn_targeted", 0 );
				self clientfield::set( "heli_warn_locked", 0 );
			}
		}
		
		wait( 0.1 );
	}
}

function _incomingMissile( missile )
{
	if ( !isdefined(self.incoming_missile) )
	{
		self.incoming_missile = 0;
	}
	
	self.incoming_missile++;
	
	self thread _incomingMissileTracker( missile );
}

function _incomingMissileTracker( missile )
{
	self endon("death");
	
	missile waittill("death");
	
	self.incoming_missile--;
	
	assert( self.incoming_missile >= 0 );
}

function MissileTarget_isMissileIncoming()
{
	if ( !isdefined(self.incoming_missile) )
		return false;
		
	if ( self.incoming_missile )
		return true;
	
	return false;
}

function MissileTarget_HandleIncomingMissile(responseFunc, endon1, endon2)
{
	level endon( "game_ended" );
	self endon( "death" );
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );

	for( ;; )
	{
		self waittill( "stinger_fired_at_me", missile, weapon, attacker );
			
		_incomingMissile(missile);
		
		if ( isdefined(responseFunc) )
			[[responseFunc]]( missile, attacker, weapon, endon1, endon2 );
	}
}

function MissileTarget_ProximityDetonateIncomingMissile( endon1, endon2 )
{
	MissileTarget_HandleIncomingMissile(&MissileTarget_ProximityDetonate, endon1, endon2 );
}

function _missileDetonate( attacker, weapon, range, minDamage, maxDamage )
{
	origin = self.origin;
	
	self detonate();
	
	radiusDamage( origin, range, minDamage, maxDamage, attacker, "MOD_PROJECTILE_SPLASH", weapon );
}

function MissileTarget_ProximityDetonate( missile, attacker, weapon, endon1, endon2 )
{
	level endon( "game_ended" );
	missile endon ( "death" );
	if ( isdefined(endon1) )
		self endon( endon1 );
	if ( isdefined(endon2) )
		self endon( endon2 );
	
	minDist = DistanceSquared( missile.origin, self.origin );
	lastCenter = self.origin;

	missile Missile_SetTarget( self );

	missedDistanceSq = 500 * 500;
	flareDistanceSq = 3500 * 3500;
	
	for ( ;; )
	{
		// target already destroyed
		if ( !isdefined( self ) )
			center = lastCenter;
		else
			center = self.origin;
			
		lastCenter = center;		
		
		curDist = DistanceSquared( missile.origin, center );
		
		if( curDist < flareDistanceSq && isdefined(self.numFlares) && self.numFlares > 0 )
		{
			self.numFlares--;			

			self thread MissileTarget_PlayFlareFx();
			self challenges::trackAssists( attacker, 0, true );
			newTarget = self MissileTarget_DeployFlares(missile.origin, missile.angles);

			missile Missile_SetTarget( newTarget );
			missileTarget = newTarget;
			
			return;
		}		
		
		if ( curDist < minDist )
			minDist = curDist;
		
		if ( curDist > minDist )
		{			
			if ( curDist > missedDistanceSq )
				return;
				
			missile thread _missileDetonate( attacker, weapon, 500, 600, 600 );
			return;
		}
		
		{wait(.05);};
	}	
}

function MissileTarget_PlayFlareFx()
{
	if ( !isdefined( self ) )
		return;
	
	flare_fx = level.fx_flare;
	
	if ( isdefined( self.fx_flare ) )
	{
		flare_fx = self.fx_flare;
	}
	if( isdefined( self.flare_ent ) )
	{
		PlayFXOnTag( flare_fx, self.flare_ent, "tag_origin" );
	}
	else
	{
		PlayFXOnTag( flare_fx, self, "tag_origin" );
	}
	
	if ( isdefined( self.owner ) )
	{
		self playsoundtoplayer ( "veh_huey_chaff_drop_plr", self.owner );
	}
	self PlaySound ( "veh_huey_chaff_explo_npc" );
}

function MissileTarget_DeployFlares(origin, angles) // self == missile target
{
	vec_toForward = anglesToForward( self.angles );
	vec_toRight = AnglesToRight( self.angles );
	
	vec_toMissileForward = anglesToForward( angles );

	delta = self.origin - origin;
	dot = VectorDot(vec_toMissileForward,vec_toRight);
	
	sign = 1;
	if ( dot > 0 ) 
		sign = -1;
		
	// out to one side or the other slightly backwards
	flare_dir = VectorNormalize(VectorScale( vec_toForward, -0.5 ) + VectorScale( vec_toRight, sign ));
	velocity = VectorScale( flare_dir, RandomIntRange(200, 400));
	velocity = (velocity[0], velocity[1], velocity[2] - RandomIntRange(10, 100) );

	flareOrigin = self.origin;
	if( isdefined( self.useVTOL ) && self.useVTOL )
		flareOrigin = flareOrigin + VectorScale( flare_dir, RandomIntRange(700, 1000));
	else
		flareOrigin = flareOrigin + VectorScale( flare_dir, RandomIntRange(500, 700));
	
	// some height will allow a missle going twards a low hovering plane to 
	// have enough radius to turn to the new target
	flareOrigin = flareOrigin + ( 0, 0, 500 );
	
	if ( isdefined( self.flareOffset ) )
		flareOrigin = flareOrigin + self.flareOffset;
	
	flareObject = spawn( "script_origin", flareOrigin );
	flareObject.angles = self.angles;
	
	flareObject SetModel( "tag_origin" );
	flareObject MoveGravity( velocity, 5.0 );
	
	flareObject thread util::deleteAfterTime( 5.0 );
/#
	self thread debug_tracker( flareObject );
#/
	return flareObject;
}

/#
function debug_tracker( target )
{
	target endon( "death");
	
	while(1)
	{
		dev::debug_sphere( target.origin, 10, (1,0,0), 1, 1 );
		{wait(.05);};
	}
}
#/