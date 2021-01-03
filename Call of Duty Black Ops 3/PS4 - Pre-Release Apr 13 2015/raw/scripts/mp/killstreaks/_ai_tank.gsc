#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_rewindobjects;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;

#namespace airsupport;

function planeSounds( localClientNum, spawnSound, flybySound, flybySoundLoop )
{
	self endon("delete");
	
	fake_ent_plane = spawnfakeent( 0 );
	if ( !isdefined( fake_ent_plane ) )
		return;
	playsound (0, spawnSound, (0,0,0));
	
	thread plane_position_updater ( localClientNum, fake_ent_plane, self, flybySound, flybySoundLoop );
	
}

function plane_position_updater ( localClientNum, fake_ent, plane, flybySound, flybySoundLoop )
{	
	soundid = -1;
	dx = undefined;
	lastTime = undefined;
	lastPos = undefined;
	startTime = 0;

	while(isdefined(plane))
	{
		setfakeentorg(0, fake_ent, plane.origin);
			
		if((soundid < 0) && isdefined(lastPos))
		{
			dx = plane.origin - lastPos;
			
			if(length(dx) > .01)
			{
			
				velocity = dx / (getrealtime()-lastTime);
				assert(isdefined(velocity));
				players = level.localPlayers;
				assert(isdefined(players));
				other_point = plane.origin + (velocity * 100000);
				point = closest_point_on_line_to_point(players[0].origin, plane.origin, other_point );
				assert(isdefined(point));
				dist = Distance( point, plane.origin );	
				assert(isdefined(dist));
				time = dist / length(velocity);
				assert(isdefined(time));
				
				if ( isdefined ( flybysoundloop ) && isdefined( fake_ent) )
					soundid = playloopsound(0, fake_ent, flybySoundLoop, 0 );	

				//changed to attach to plane, CDC							
				if ( isdefined ( flybySound ) )
					plane playsound (0, flybySound);
					
				startTime = getRealTime();
			}
		}
			
		lastPos = plane.origin;
		lastTime = getrealtime();
						
		wait(0.1);		
		
	}
	util::server_wait( localClientNum, 5 );
	deletefakeent(0, fake_ent);

}


function closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
 	if( t < 0.0  )
	{
		return LineStart;
	}
	else if( t > 1.0 )
	{
		return LineEnd;
	}
	else
	{
		start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
		start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
		start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
		return (start_x,start_y,start_z);
	}
}

function getPlaneModel( teamFaction )
{
	planemodel = "t5_veh_jet_f4_gearup";
	return planeModel;
}


function planeTurnRight( localClientNum,  plane, yaw, halfLife, startTime)
{
	planeTurn( localClientNum,  plane, yaw, halfLife, startTime, true );
}
	
function planeTurnLeft( localClientNum,  plane, yaw, halfLife, startTime )
{
	planeTurn( localClientNum,  plane, yaw, halfLife, startTime, false );
}
	
function planeTurn( localClientNum,  plane, yaw, halfLife, startTime, isTurningRight )
{
	plane endon( "delete" );
	plane endon( "entityshutdown" );
	level endon( "demo_jump" + localClientNum );

	leftTurn = -1;
	rightTurn = 1;
	
	if( isTurningRight ) 
		turnDirection = rightTurn;
	else
		turnDirection = leftTurn;

	yawY = GetDvarFloat( "scr_planeyaw", -1.5 * turnDirection );
	rollZ = GetDvarFloat( "scr_planeroll", 1.5 * turnDirection );

	maxYaw = GetDvarFloat( "scr_max_planeyaw", -45.0 * turnDirection );
	minRoll = GetDvarFloat( "scr_min_planeroll", 60.0 * turnDirection );
	
	ox = GetDvarFloat( "scr_planeox", 30000.0 );
	oy = GetDvarFloat( "scr_planeoy", -30000.0 * turnDirection );
	maxoX = GetDvarFloat( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloat( "scr_maxo_planey", -1.0 );
	
	if (plane.angles[1] == 360)
		plane.angles = ( plane.angles[0], 0, plane.angles[2] );
				
	origX = plane.origin[0];
	origY = plane.origin[1];
	
	accumTurn = 0;
	looptime = 0.1;
	waitAmount = 0.1;
	waitForMoveDone = false;
	while( loopTime <= halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] >= minRoll * turnDirection )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn <= maxYaw * turnDirection )
		{
			yawY = 0.0;
		}
		angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] + rollZ);

		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		if ( waitForMoveDone )
			plane waittill( "movedone" );
		waitForMoveDone = plane rewindobjects::serverTimedMoveTo( localClientNum, plane.origin, endPoint, startTime, waitAmount );
		plane rewindobjects::serverTimedRotateTo( localClientNum, angles, startTime, waitAmount );
		loopTime += waitAmount;
		startTime += waitAmount * 1000;
	}
	
	yawY = GetDvarFloat( "scr_planeyaw2", 1.5 );
	rollZ = GetDvarFloat( "scr_planeroll2", -0.9 );
	
	ox = GetDvarFloat( "scr_planeox", 30000.0 );
	oy = GetDvarFloat( "scr_planeoy", -30000.0 * turnDirection );
	maxoX = GetDvarFloat( "scr_maxo_planex", -1.0 );
	maxoY = GetDvarFloat( "scr_maxo_planey", -1.0 );
	
	y = GetDvarFloat( "scr_planey2", 0.6 );
	z = GetDvarFloat( "scr_planez2", -1.5 );
	maxy = GetDvarFloat( "scr_max_planey2", 90);
	
	accumTurn = 0;
	
	while( loopTime < halflife + halflife )	
	{
		if (plane.angles[1] == 360)
			plane.angles = ( plane.angles[0], 0, plane.angles[2] );

		if ( minRoll != -1 && plane.angles[2] >= 0 )	
			rollZ = 0.0;
			
		accumTurn += yawY;
		
		if ( accumTurn >= maxYaw )
		{
			yawY = 0.0;
		}
		
		angles = ( plane.angles[0], plane.angles[1] + yawY, plane.angles[2] - rollZ);

		mathX = ( sin ( 45 * looptime / halflife ) ) * ox ;
		mathY = ( cos ( 45 * looptime / halflife ) ) * oy ;
		
		oldX = mathX;
		oldY = oy - mathY;

		rotatedX = Cos(yaw) * oldX - Sin(yaw) * oldY;
		rotatedY = Sin(yaw) * oldX + Cos(yaw) * oldY;
		
		endPoint = ( origX + rotatedX, origY + rotatedY, plane.origin[2]);
		
		if ( waitForMoveDone )
			plane waittill( "movedone" );
		waitForMoveDone = plane rewindobjects::serverTimedMoveTo( localClientNum, plane.origin, endPoint, startTime, waitAmount );
		plane rewindobjects::serverTimedRotateTo( localClientNum, angles, startTime, waitAmount );
		loopTime += waitAmount;
		startTime += waitAmount * 1000;
	}	
}

function doABarrelRoll( localClientNum,  plane, endPoint, flytime, startTime )
{
	plane endon( "entityshutdown" );
	plane endon("delete");
	level endon("demo_jump");

	origin = plane.origin;
	originalHeight = origin[2];

	loopWaitTime = GetDvarFloat( "scr_loopwaittime", 0.5 );
	loopHeightRand = GetDvarFloat( "scr_loopheightrand", 500 );
	loopHeight = GetDvarFloat( "scr_loopheight", 1200 );
	rollZ = GetDvarFloat( "scr_barrelroll", 10 );
	degreesToRoll = GetDvarFloat( "scr_degreesToRoll", 360 );
	unitsFromCentrePoint = 100;

	timeElapsed = 0;
	degreesRolled = 0;
	waitAmount = 0.1;

	loopHeight += randomFloatRange( 0-loopHeightRand, loopHeightRand );
	waitForMoveDone = false;
	angles = plane.angles;
	originalRoll = plane.angles[2];
	while ( timeElapsed < flytime )
	{
		timeElapsed += waitAmount; 
		if ( ( timeElapsed > loopWaitTime ) && ( degreesRolled < degreesToRoll ) )
		{
			pitch = degreesRolled / 8;
			if ( pitch > 22.5 )
				pitch = 45 - pitch;
			
			originalAngle = plane.angles[2];
			
			scr_degreesToRoll = GetDvarInt( "scr_degreesToRoll", 0 );
			if ( scr_degreesToRoll ) 
				plane.angles[1] = 0;
			angles = ( 0 - pitch, plane.angles[1], originalRoll + degreesRolled );
			degreesRolled += rollZ;
		}
		
		ratio = timeElapsed / ( flytime / 2 );

		nextPoint = rewindobjects::getPointOnLine( origin, endPoint, ratio );

		nextHeight = originalHeight + ( loopHeight - ( cos(degreesRolled/2) * loopHeight ) );
		nextPoint = ( nextPoint[0], nextPoint[1], nextHeight );

		if ( waitForMoveDone )
			plane waittill( "movedone" );
		waitForMoveDone = plane rewindobjects::serverTimedMoveTo( localClientNum, plane.origin, nextPoint, startTime, waitAmount );
		plane rewindobjects::serverTimedRotateTo( localClientNum, angles, startTime, waitAmount );
		startTime += waitAmount * 1000;
	}
}


function planeGoStraight( localClientNum, plane, startPoint, endPoint, moveTime, startTime )
{
	plane endon("delete");
	level endon("demo_jump");
	
	distanceIncreaseRatio = 2;
	
	destPoint = rewindobjects::getPointOnLine( startPoint, endPoint, distanceIncreaseRatio );
	if ( plane rewindobjects::serverTimedMoveTo( localClientNum, startPoint, destPoint, startTime, moveTime ) )
		plane waittill( "movedone" );
}

