#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace spawnlogic;

function autoexec __init__sytem__() {     system::register("spawnlogic",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_start_gametype( &main );
}

// called once at start of game
function main()
{
	/#
	if (GetDvarString( "scr_recordspawndata") == "")
		SetDvar("scr_recordspawndata", 0);
	level.storeSpawnData = GetDvarint( "scr_recordspawndata");
	
	if (GetDvarString( "scr_killbots") == "")
		SetDvar("scr_killbots", 0);
	if (GetDvarString( "scr_killbottimer") == "")
		SetDvar("scr_killbottimer", 0.25);
	thread loopbotspawns();
	#/

	// start keeping track of deaths
	level.spawnlogic_deaths = [];
	// DEBUG
	level.spawnlogic_spawnkills = [];
	level.players = [];
	level.grenades = [];
	level.pipebombs = [];

	level.spawnMins = (0,0,0);
	level.spawnMaxs = (0,0,0);
	level.spawnMinsMaxsPrimed = false;	
	if ( isdefined( level.safespawns ) )
	{
		for( i = 0; i < level.safespawns.size; i++ )
		{
			level.safespawns[i] spawnPointInit();
		}
	}
	
	if ( GetDvarString( "scr_spawn_enemyavoiddist") == "" )
		SetDvar("scr_spawn_enemyavoiddist", "800");
	if ( GetDvarString( "scr_spawn_enemyavoidweight") == "" )
		SetDvar("scr_spawn_enemyavoidweight", "0");
	
	// DEBUG
	/#
	if (GetDvarString( "scr_spawnsimple") == "")
		SetDvar("scr_spawnsimple", "0");
	if (GetDvarString( "scr_spawnpointdebug") == "")
		SetDvar("scr_spawnpointdebug", "0");
	if (GetDvarint( "scr_spawnpointdebug") > 0)
	{
		thread showDeathsDebug();
		thread updateDeathInfoDebug();
		thread profileDebug();
	}
	if (level.storeSpawnData) {
		thread allowSpawnDataReading();
	}
	if (GetDvarString( "scr_spawnprofile") == "")
		SetDvar("scr_spawnprofile", "0");
	thread watchSpawnProfile();
	thread spawnGraphCheck();
	#/
}

function findBoxCenter( mins, maxs )
{
	center = ( 0, 0, 0 );
	center = maxs - mins;
	center = ( center[0]/2, center[1]/2, center[2]/2 ) + mins;
	return center;
}

function expandMins( mins, point )
{
	if ( mins[0] > point[0] )
		mins = ( point[0], mins[1], mins[2] );
	if ( mins[1] > point[1] )
		mins = ( mins[0], point[1], mins[2] );
	if ( mins[2] > point[2] )
		mins = ( mins[0], mins[1], point[2] );
	return mins;
}

function expandMaxs( maxs, point )
{
	if ( maxs[0] < point[0] )
		maxs = ( point[0], maxs[1], maxs[2] );
	if ( maxs[1] < point[1] )
		maxs = ( maxs[0], point[1], maxs[2] );
	if ( maxs[2] < point[2] )
		maxs = ( maxs[0], maxs[1], point[2] );
	return maxs;
}


function addSpawnPointsInternal( team, spawnPointName )
{	
	oldSpawnPoints = [];
	if ( level.teamSpawnPoints[team].size )
		oldSpawnPoints = level.teamSpawnPoints[team];
	
	level.teamSpawnPoints[team] = getSpawnpointArray( spawnPointName );
	
	if ( !isdefined( level.spawnpoints ) )
		level.spawnpoints = [];
	
	for ( index = 0; index < level.teamSpawnPoints[team].size; index++ )
	{
		spawnpoint = level.teamSpawnPoints[team][index];
		
		if ( !isdefined( spawnpoint.inited ) )
		{
			spawnpoint spawnPointInit();
			level.spawnpoints[ level.spawnpoints.size ] = spawnpoint;
		}
	}
	
	for ( index = 0; index < oldSpawnPoints.size; index++ )
	{
		origin = oldSpawnPoints[index].origin;
		
		// are these 2 lines necessary? we already did it in spawnPointInit
		level.spawnMins = expandMins( level.spawnMins, origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, origin );
		
		level.teamSpawnPoints[team][ level.teamSpawnPoints[team].size ] = oldSpawnPoints[index];
	}
	
	if ( !level.teamSpawnPoints[team].size )
	{	
	/#	println( "^1ERROR: No " + spawnPointName + " spawnpoints found in level!" );	#/
		callback::abort_level();
		wait 1; // so we don't try to abort more than once before the frame ends
		return;
	}
}

function clearSpawnPoints()
{
	foreach( team in level.teams )
	{
		level.teamSpawnPoints[team] = [];
	}
	level.spawnpoints = [];
	level.unified_spawn_points = undefined;
}

function addSpawnPoints( team, spawnPointName )
{
	addSpawnPointClassName( spawnPointName );
	addSpawnPointTeamClassName( team, spawnPointName );
	
	addSpawnPointsInternal( team, spawnPointName );
}

function rebuildSpawnPoints( team )
{
	level.teamSpawnPoints[team] = [];
	
	for ( index = 0; index < level.spawn_point_team_class_names[team].size; index++ )
	{
		addSpawnPointsInternal( team, level.spawn_point_team_class_names[team][index] );
	}
}

function placeSpawnPoints( spawnPointName )
{
	addSpawnPointClassName( spawnPointName );

	spawnPoints = getSpawnpointArray( spawnPointName );
	
	/#
	if ( !isdefined( level.extraspawnpointsused ) )
		level.extraspawnpointsused = [];
	#/
	
	if ( !spawnPoints.size )
	{
	/#	println( "^1No " + spawnPointName + " spawnpoints found in level!" );	#/
		callback::abort_level();
		wait 1; // so we don't try to abort more than once before the frame ends
		return;
	}
	
	for( index = 0; index < spawnPoints.size; index++ )
	{
		spawnPoints[index] spawnPointInit();
		// don't add this spawnpoint to level.spawnpoints,
		// because it's an unimportant one that we don't want to do sight traces to
		
		/#
		spawnPoints[index].fakeclassname = spawnPointName;
		level.extraspawnpointsused[ level.extraspawnpointsused.size ] = spawnPoints[index];
		#/
	}
}

// just drops to ground
// needed for demolition because secondary attacker points do 
// not get used until mid round and therefore dont get processed
// this was making the rendered debug boxes appear to be floating
// and causing confusion amongst the masses.  Need the points to 
// be debug friendly.  Cant use the placeSpawnPoints function because
// that does somethings that we dont want to do until they are actually used
function dropSpawnPoints( spawnPointName )
{
		spawnPoints = getSpawnpointArray( spawnPointName );
	if ( !spawnPoints.size )
	{
	/#	println( "^1No " + spawnPointName + " spawnpoints found in level!" );	#/
		return;
	}
	
	for( index = 0; index < spawnPoints.size; index++ )
	{
		spawnPoints[index] placeSpawnpoint();
	}
}

function addSpawnPointClassName( spawnPointClassName )
{
	if ( !isdefined( level.spawn_point_class_names ) )
	{
		level.spawn_point_class_names = [];
	}
	
	level.spawn_point_class_names[ level.spawn_point_class_names.size ] = spawnPointClassName;
}
	
function addSpawnPointTeamClassName( team, spawnPointClassName )
{
	level.spawn_point_team_class_names[team][ level.spawn_point_team_class_names[team].size ] = spawnPointClassName;
}

function getSpawnpointArray( classname )
{
	spawnPoints = getEntArray( classname, "classname" );
	
	if ( !isdefined( level.extraspawnpoints ) || !isdefined( level.extraspawnpoints[classname] ) )
		return spawnPoints;
	
	for ( i = 0; i < level.extraspawnpoints[classname].size; i++ )
	{
		spawnPoints[ spawnPoints.size ] = level.extraspawnpoints[classname][i];
	}
	
	return spawnPoints;
}

function spawnPointInit()
{
	spawnpoint = self;
	origin = spawnpoint.origin;
	
	// we need to properly prime the mins and maxs otherwise a level that is entirely
	// on one side of the zero line for any axis will have an invalid map center
	if ( !level.spawnMinsMaxsPrimed )
	{
		level.spawnMins = origin;
		level.spawnMaxs = origin;
		level.spawnMinsMaxsPrimed = true;
	}
	else
	{
		level.spawnMins = expandMins( level.spawnMins, origin );
		level.spawnMaxs = expandMaxs( level.spawnMaxs, origin );
	}
	
	spawnpoint placeSpawnpoint();
	spawnpoint.forward = anglesToForward( spawnpoint.angles );
	spawnpoint.sightTracePoint = spawnpoint.origin + (0,0,50);
	
	/*skyHeight = 500;
	spawnpoint.outside = true;
	if ( !bullettracepassed( spawnpoint.sightTracePoint, spawnpoint.sightTracePoint + (0,0,skyHeight), false, undefined) )
	{
		startpoint = spawnpoint.sightTracePoint + spawnpoint.forward * 100;
		if ( !bullettracepassed( startpoint, startpoint + (0,0,skyHeight), false, undefined) )
			spawnpoint.outside = false;
	}*/
	
	spawnpoint.inited = true;
}

function getTeamSpawnPoints( team )
{
	return level.teamSpawnPoints[team];
}

// selects a spawnpoint, preferring ones with heigher weights (or toward the beginning of the array if no weights).
// also does final things like setting self.lastspawnpoint to the one chosen.
// this takes care of avoiding telefragging, so it doesn't have to be considered by any other function.
function getSpawnpoint_Final( spawnpoints, useweights )
{
	
	bestspawnpoint = undefined;
	
	if ( !isdefined( spawnpoints ) || spawnpoints.size == 0 )
		return undefined;
	
	if ( !isdefined( useweights ) )
		useweights = true;
	
	if ( useweights )
	{
		// choose spawnpoint with best weight
		// (if a tie, choose randomly from the best)
		bestspawnpoint = getBestWeightedSpawnpoint( spawnpoints );
		thread spawnWeightDebug( spawnpoints );
	}
	else
	{
		// (only place we actually get here from is getSpawnpoint_Random() )
		// no weights. prefer spawnpoints toward beginning of array
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if( isdefined( self.lastspawnpoint ) && self.lastspawnpoint == spawnpoints[i] )
				continue;
			
			if ( positionWouldTelefrag( spawnpoints[i].origin ) )
				continue;
			
			bestspawnpoint = spawnpoints[i];
			break;
		}
		if ( !isdefined( bestspawnpoint ) )
		{
			// Couldn't find a useable spawnpoint. All spawnpoints either telefragged or were our last spawnpoint
			// Our only hope is our last spawnpoint - unless it too will telefrag...
			if ( isdefined( self.lastspawnpoint ) && !positionWouldTelefrag( self.lastspawnpoint.origin ) )
			{
				// (make sure our last spawnpoint is in the valid array of spawnpoints to use)
				for ( i = 0; i < spawnpoints.size; i++ )
				{
					if ( spawnpoints[i] == self.lastspawnpoint )
					{
						bestspawnpoint = spawnpoints[i];
						break;
					}
				}
			}
		}
	}
	
	if ( !isdefined( bestspawnpoint ) )
	{
		// couldn't find a useable spawnpoint! all will telefrag.
		if ( useweights )
		{
			// at this point, forget about weights. just take a random one.
			bestspawnpoint = spawnpoints[randomint(spawnpoints.size)];
		}
		else
		{
			bestspawnpoint = spawnpoints[0];
		}
	}
	
	self finalizeSpawnpointChoice( bestspawnpoint );
	
	/#
	self storeSpawnData( spawnpoints, useweights, bestspawnpoint );
	#/
	
	
	return bestspawnpoint;
}

function finalizeSpawnpointChoice( spawnpoint )
{
	time = getTime();
	
	self.lastspawnpoint = spawnpoint;
	self.lastspawntime = time;
	spawnpoint.lastspawnedplayer = self;
	spawnpoint.lastspawntime = time;
}

function getBestWeightedSpawnpoint( spawnpoints )
{
	maxSightTracedSpawnpoints = 3;
	for ( try = 0; try <= maxSightTracedSpawnpoints; try++ )
	{
		bestspawnpoints = [];
		bestweight = undefined;
		bestspawnpoint = undefined;
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if ( !isdefined( bestweight ) || spawnpoints[i].weight > bestweight ) 
			{
				if ( positionWouldTelefrag( spawnpoints[i].origin ) )
					continue;
				
				bestspawnpoints = [];
				bestspawnpoints[0] = spawnpoints[i];
				bestweight = spawnpoints[i].weight;
			}
			else if ( spawnpoints[i].weight == bestweight ) 
			{
				if ( positionWouldTelefrag( spawnpoints[i].origin ) )
					continue;
				
				bestspawnpoints[bestspawnpoints.size] = spawnpoints[i];
			}
		}
		if ( bestspawnpoints.size == 0 )
			return undefined;
		
		// pick randomly from the available spawnpoints with the best weight
		bestspawnpoint = bestspawnpoints[randomint( bestspawnpoints.size )];
		
		if ( try == maxSightTracedSpawnpoints )
			return bestspawnpoint;
		
		if ( isdefined( bestspawnpoint.lastSightTraceTime ) && bestspawnpoint.lastSightTraceTime == gettime() )
			return bestspawnpoint;
		
		if ( !lastMinuteSightTraces( bestspawnpoint ) )
			return bestspawnpoint;
		
		penalty = getLosPenalty();
		/#
		if ( level.storeSpawnData || level.debugSpawning )
			bestspawnpoint.spawnData[bestspawnpoint.spawnData.size] = "Last minute sight trace: -" + penalty;
		#/
		bestspawnpoint.weight -= penalty;
		
		bestspawnpoint.lastSightTraceTime = gettime();
	}
}

/#
function checkBad( spawnpoint )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		
		if ( !isAlive( player ) || player.sessionstate != "playing" )
			continue;
		if ( level.teambased && player.team == self.team )
			continue;
		
		losExists = bullettracepassed(player.origin + (0,0,50), spawnpoint.sightTracePoint, false, undefined);
		if ( losExists )
			thread badSpawnLine( spawnpoint.sightTracePoint, player.origin + (0,0,50), self.name, player.name );
	}
}

function badSpawnLine( start, end, name1, name2 )
{
	dist = distance(start,end);
	for ( i = 0; i < 20 * 10; i++ )
	{
		line( start, end, (1,0,0) );
		print3d( start, "Bad spawn! " + name1 + ", dist = " + dist );
		print3d( end, name2 );
		
		wait .05;
	}
}
#/

/#
function storeSpawnData(spawnpoints, useweights, bestspawnpoint)
{
	if (!isdefined(level.storeSpawnData) || !level.storeSpawnData)
		return;

	level.storeSpawnData = GetDvarint( "scr_recordspawndata");
	if (!level.storeSpawnData)
		return;
	
	if (!isdefined(level.spawnID)) {
		level.spawnGameID = randomint(100);
		level.spawnID = 0;
	}

	if (bestspawnpoint.classname == "mp_global_intermission")
		return;
	
	level.spawnID++;
	
	/*
	Format:
	spawnid, numspawnpoints, name
	[for each spawnpoint
		origin, was used, weight, num data, [for each data: data], num sight checks, [for each sight check: penalty, origin]
	]
	num allies, num enemies, ally origins, enemy origins,
	num other data, [for each other data: other data origin, other data text]
	*/
	
	file = openfile("spawndata.txt", "append");
	fPrintFields(file, level.spawnGameID + "." + level.spawnID + "," + spawnpoints.size + "," + self.name);

	for (i = 0; i < spawnpoints.size; i++)
	{
		str = vectostr(spawnpoints[i].origin) + ",";
		if (spawnpoints[i] == bestspawnpoint)
			str = str + "1,";
		else
			str = str + "0,";
		
		if (!useweights)
			str += "0,";
		else
			str += spawnpoints[i].weight + ",";
		
		if (!isdefined(spawnpoints[i].spawnData))
			spawnpoints[i].spawnData = [];
		if (!isdefined(spawnpoints[i].sightChecks))
			spawnpoints[i].sightChecks = [];
		str += spawnpoints[i].spawnData.size + ",";
		for (j = 0; j < spawnpoints[i].spawnData.size; j++)
		{
			str += spawnpoints[i].spawnData[j] + ",";
		}
		str += spawnpoints[i].sightChecks.size + ",";
		for (j = 0; j < spawnpoints[i].sightChecks.size; j++)
		{
			str += spawnpoints[i].sightChecks[j].penalty + "," + vectostr(spawnpoints[i].origin) + ",";
		}
		
		fPrintFields(file, str);
	}
	
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj);
	numallies = 0;
	numenemies = 0;
	str = "";
	for (i = 0; i < obj.allies.size; i++)
	{
		if ( obj.allies[i] == self )
			continue;
		numallies++;
		str += vectostr(obj.allies[i].origin) + ",";
	}
	for (i = 0; i < obj.enemies.size; i++)
	{
		numenemies++;
		str += vectostr(obj.enemies[i].origin) + ",";
	}
	str = numallies + "," + numenemies + "," + str;
	fPrintFields(file, str);
	
	otherdata = [];
	if (isdefined(level.bombguy)) {
		index = otherdata.size;
		otherdata[index] = spawnstruct();
		otherdata[index].origin = level.bombguy.origin + (0,0,20);
		otherdata[index].text = "Bomb holder";
	}
	else if (isdefined(level.bombpos)) {
		index = otherdata.size;
		otherdata[index] = spawnstruct();
		otherdata[index].origin = level.bombpos;
		otherdata[index].text = "Bomb";
	}
	if (isdefined(level.flags)) {
		for (i = 0; i < level.flags.size; i++)
		{
			index = otherdata.size;
			otherdata[index] = spawnstruct();
			otherdata[index].origin = level.flags[i].origin;
			otherdata[index].text = level.flags[i].useObj gameobjects::get_owner_team() + " flag";
		}
	}
	str = otherdata.size + ",";
	for (i = 0; i < otherdata.size; i++)
	{
		str += vectostr(otherdata[i].origin) + "," + otherdata[i].text + ",";
	}
	fPrintFields(file, str);
	
	closefile(file);

	thisspawnid = level.spawnGameID + "." + level.spawnID;
	if (isdefined(self.thisspawnid)) {
//		self iprintln(&"MP_PREVIOUS_SPAWN_ID", self.thisspawnid);
	}
//	self iprintln(&"MP_THIS_SPAWN_ID", thisspawnid);
	self.thisspawnid = thisspawnid;
}

function readSpawnData( desiredID, relativepos )
{
	file = openfile("spawndata.txt", "read");
	if (file < 0)
		return;
	
	oldspawndata = level.curspawndata;
	level.curspawndata = undefined;

	prev = undefined;
	prevThisPlayer = undefined;
	lookingForNextThisPlayer = false;
	lookingForNext = false;
	
	if ( isdefined( relativepos ) && !isdefined( oldspawndata ) )
		return;
	
	while(1)
	{
		if (freadln(file) <= 0)
			break;
		data = spawnstruct();
		
		data.id = fgetarg(file, 0);
		numspawns = int(fgetarg(file, 1));
		if (numspawns > 256)
			break;
		data.playername = fgetarg(file, 2);
		
		data.spawnpoints = [];
		data.friends = [];
		data.enemies = [];
		data.otherdata = [];
		
		for (i = 0; i < numspawns; i++)
		{
			if (freadln(file) <= 0)
				break;
			
			spawnpoint = spawnstruct();
			
			spawnpoint.origin = strtovec(fgetarg(file, 0));
			spawnpoint.winner = int(fgetarg(file, 1));
			spawnpoint.weight = int(fgetarg(file, 2));
			spawnpoint.data = [];
			spawnpoint.sightchecks = [];
			
			if (i == 0) {
				data.minweight = spawnpoint.weight;
				data.maxweight = spawnpoint.weight;
			}
			else {
				if (spawnpoint.weight < data.minweight)
					data.minweight = spawnpoint.weight;
				if (spawnpoint.weight > data.maxweight)
					data.maxweight = spawnpoint.weight;
			}
			
			argnum = 4;

			numdata = int(fgetarg(file, 3));
			if (numdata > 256)
				break;
			for (j = 0; j < numdata; j++)
			{
				spawnpoint.data[spawnpoint.data.size] = fgetarg(file, argnum);
				argnum++;
			}
			numsightchecks = int(fgetarg(file, argnum));
			argnum++;
			if (numsightchecks > 256)
				break;
			for (j = 0; j < numsightchecks; j++)
			{
				index = spawnpoint.sightchecks.size;
				spawnpoint.sightchecks[index] = spawnstruct();
				spawnpoint.sightchecks[index].penalty = int(fgetarg(file, argnum));
				argnum++;
				spawnpoint.sightchecks[index].origin = strtovec(fgetarg(file, argnum));
				argnum++;
			}
			
			data.spawnpoints[data.spawnpoints.size] = spawnpoint;
		}
		
		if (!isdefined(data.minweight)) {
			data.minweight = -1;
			data.maxweight = 0;
		}
		if (data.minweight == data.maxweight)
			data.minweight = data.minweight - 1;
		
		if (freadln(file) <= 0)
			break;
		numfriends = int(fgetarg(file, 0));
		numenemies = int(fgetarg(file, 1));
		if (numfriends > 32 || numenemies > 32)
			break;
		argnum = 2;
		for (i = 0; i < numfriends; i++)
		{
			data.friends[data.friends.size] = strtovec(fgetarg(file, argnum));
			argnum++;
		}
		for (i = 0; i < numenemies; i++)
		{
			data.enemies[data.enemies.size] = strtovec(fgetarg(file, argnum));
			argnum++;
		}

		if (freadln(file) <= 0)
			break;
		numotherdata = int(fgetarg(file, 0));
		argnum = 1;
		for (i = 0; i < numotherdata; i++)
		{
			otherdata = spawnstruct();
			otherdata.origin = strtovec(fgetarg(file, argnum));
			argnum++;
			otherdata.text = fgetarg(file, argnum);
			argnum++;
			
			data.otherdata[data.otherdata.size] = otherdata;
		}
		
		if ( isdefined( relativepos ) )
		{
			if ( relativepos == "prevthisplayer" )
			{
				if ( data.id == oldspawndata.id )
				{
					level.curspawndata = prevThisPlayer;
					break;
				}
			}
			else if ( relativepos == "prev" )
			{
				if ( data.id == oldspawndata.id )
				{
					level.curspawndata = prev;
					break;
				}
			}
			else if ( relativepos == "nextthisplayer" )
			{
				if ( lookingForNextThisPlayer )
				{
					level.curspawndata = data;
					break;
				}
				else if ( data.id == oldspawndata.id )
				{
					lookingForNextThisPlayer = true;
				}
			}
			else if ( relativepos == "next" )
			{
				if ( lookingForNext )
				{
					level.curspawndata = data;
					break;
				}
				else if ( data.id == oldspawndata.id )
				{
					lookingForNext = true;
				}
			}
		}
		else
		{
			if ( data.id == desiredID )
			{
				level.curspawndata = data;
				break;
			}
		}
		
		prev = data;
		if ( isdefined( oldspawndata ) && data.playername == oldspawndata.playername )
			prevThisPlayer = data;
	}
	closefile(file);
}
function drawSpawnData()
{
	level notify("drawing_spawn_data");
	level endon("drawing_spawn_data");
	
	textoffset = (0,0,-12);
	while(1)
	{
		if (!isdefined(level.curspawndata)) {
			wait .5;
			continue;
		}
		
		for (i = 0; i < level.curspawndata.friends.size; i++)
		{
			print3d(level.curspawndata.friends[i], "=)", (.5,1,.5), 1, 5);
		}
		for (i = 0; i < level.curspawndata.enemies.size; i++)
		{
			print3d(level.curspawndata.enemies[i], "=(", (1,.5,.5), 1, 5);
		}
		
		for (i = 0; i < level.curspawndata.otherdata.size; i++)
		{
			print3d(level.curspawndata.otherdata[i].origin, level.curspawndata.otherdata[i].text, (.5,.75,1), 1, 2);
		}

		for (i = 0; i < level.curspawndata.spawnpoints.size; i++)
		{
			sp = level.curspawndata.spawnpoints[i];
			orig = sp.sightTracePoint;
			if (sp.winner) {
				print3d(orig, level.curspawndata.playername + " spawned here", (.5,.5,1), 1, 2);
				orig += textoffset;
			}
			amnt = (sp.weight - level.curspawndata.minweight) / (level.curspawndata.maxweight - level.curspawndata.minweight);
			print3d(orig, "Weight: " + sp.weight, (1-amnt,amnt,.5));
			orig += textoffset;
			for (j = 0; j < sp.data.size; j++)
			{
				print3d(orig, sp.data[j], (1,1,1));
				orig += textoffset;
			}
			for (j = 0; j < sp.sightchecks.size; j++)
			{
				//line(sp.origin, sp.sightchecks[j].origin, (1,0,0));
				print3d(orig, "Sightchecks: -" + sp.sightchecks[j].penalty, (1,.5,.5));
				orig += textoffset;
			}
		}

		wait .05;
	}
}

function vectostr(vec)
{
	return int(vec[0]) + "/" + int(vec[1]) + "/" + int(vec[2]);
}
function strtovec(str)
{
	parts = strtok(str, "/");
	if (parts.size != 3)
		return (0,0,0);
	return (int(parts[0]), int(parts[1]), int(parts[2]));
}
#/

function getSpawnpoint_Random(spawnpoints)
{
//	level endon("game_ended");

	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;

	// randomize order
	for(i = 0; i < spawnpoints.size; i++)
	{
		j = randomInt(spawnpoints.size);
		spawnpoint = spawnpoints[i];
		spawnpoints[i] = spawnpoints[j];
		spawnpoints[j] = spawnpoint;
	}
	
	return getSpawnpoint_Final(spawnpoints, false);
}

function getAllOtherPlayers()
{
	aliveplayers = [];

	// Make a list of fully connected, non-spectating, alive players
	for(i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		player = level.players[i];
		
		if ( player.sessionstate != "playing" || player == self )
			continue;
		if ( IsDefined(level.customAliveCheck) )
			if ( ! [[level.customAliveCheck]]( player ) )
				continue;
		
		aliveplayers[aliveplayers.size] = player;
	}
	return aliveplayers;
}


function getAllAlliedAndEnemyPlayers( obj )
{
	if ( level.teambased )
	{
		assert( isdefined( level.teams[self.team] ) );
		
		obj.allies = [];
		obj.enemies = [];
		
		for(i = 0; i < level.players.size; i++)
		{
			if ( !isdefined( level.players[i] ) )
				continue;
			player = level.players[i];
			
			if ( player.sessionstate != "playing" || player == self )
				continue;
			if ( IsDefined(level.customAliveCheck) )
				if ( ! [[level.customAliveCheck]]( player ) )
					continue;

			if (player.team == self.team)
				obj.allies[obj.allies.size] = player;
			else
				obj.enemies[obj.enemies.size] = player;

		}
		
/*		
		obj.allies = level.alivePlayers[self.team];
		
		obj.enemies = undefined;
		foreach( team in level.teams )
		{
			if ( team == self.team )
				continue;
			
			if ( !isdefined( obj.enemies ) )
			{
				obj.enemies = level.alivePlayers[team];
			}
			else
			{
				foreach( player in level.alivePlayers[team] )
				{
					obj.enemies[obj.enemies.size] = player;
				}
			}
		}
*/		
	}
	else
	{
		obj.allies = [];
		obj.enemies = level.activePlayers;
	}
}

// weight array manipulation code
function initWeights(spawnpoints)
{
	for (i = 0; i < spawnpoints.size; i++)
		spawnpoints[i].weight = 0;
	
	/#
	if ( level.storeSpawnData  || level.debugSpawning )
	{
		for (i = 0; i < spawnpoints.size; i++) {
			spawnpoints[i].spawnData = [];
			spawnpoints[i].sightChecks = [];
		}
	}
	#/
}


function spawnPointUpdate_zm( spawnpoint )
{
	foreach( team in level.teams )
	{
		spawnpoint.distSum[ team ]=0;
		spawnpoint.enemyDistSum[ team ]=0;
	}
	players = GetPlayers();
	spawnpoint.numPlayersAtLastUpdate = players.size;
	foreach(player in players)
	{
		if ( !isdefined( player ) )
			continue;
		if ( player.sessionstate != "playing" )
			continue;
		if ( IsDefined(level.customAliveCheck) )
			if ( ! [[level.customAliveCheck]]( player ) )
				continue;
		dist = distance( spawnpoint.origin, player.origin );
		spawnpoint.distSum[ player.team ]+=dist;
		foreach( team in level.teams )
		{
			if (team != player.team )
				spawnpoint.enemyDistSum[ team ]+=dist;
		}
	}
}

// ================================================


function getSpawnpoint_NearTeam( spawnpoints, favoredspawnpoints, forceAllyDistanceWeight, forceEnemyDistanceWeight )
{
//	level endon("game_ended");

	/*if ( self.wantSafeSpawn )
	{
		return getSpawnpoint_SafeSpawn( spawnpoints );
	}*/
	
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;
	
	/#
	if ( GetDvarString( "scr_spawn_randomly") == "" )
		SetDvar("scr_spawn_randomly", "0");
	if ( GetDvarString( "scr_spawn_randomly") == "1" )
		return getSpawnpoint_Random( spawnpoints );
	#/
		
	
	if ( GetDvarint( "scr_spawnsimple") > 0 )
		return getSpawnpoint_Random( spawnpoints );
	
	Spawnlogic_Begin();
	
	k_favored_spawn_point_bonus= 25000;
	
	initWeights(spawnpoints);
	
	obj = spawnstruct();
	getAllAlliedAndEnemyPlayers(obj);
	
	numplayers = obj.allies.size + obj.enemies.size;
	
	alliedDistanceWeight = 2;
	if (IsDefined(forceAllyDistanceWeight))
		alliedDistanceWeight = forceAllyDistanceWeight;
	
	enemyDistanceWeight = 1;
	if (IsDefined(forceEnemyDistanceWeight))
		enemyDistanceWeight = forceEnemyDistanceWeight;
	
	myTeam = self.team;
	for (i = 0; i < spawnpoints.size; i++)
	{
		spawnpoint = spawnpoints[i];
		
		spawnPointUpdate_zm( spawnpoint );
		
		if (!IsDefined(spawnpoint.numPlayersAtLastUpdate))
		{
			spawnpoint.numPlayersAtLastUpdate= 0;
		}
		
		if ( spawnpoint.numPlayersAtLastUpdate > 0 )
		{
			allyDistSum = spawnpoint.distSum[ myTeam ];
			enemyDistSum = spawnpoint.enemyDistSum[ myTeam ];
			
			// high enemy distance is good, high ally distance is bad
			spawnpoint.weight = (enemyDistanceWeight*enemyDistSum - alliedDistanceWeight*allyDistSum) / spawnpoint.numPlayersAtLastUpdate;
			
			/#
			if ( level.storeSpawnData  || level.debugSpawning )
				spawnpoint.spawnData[spawnpoint.spawnData.size] = "Base weight: " + int(spawnpoint.weight) + " = (" + enemyDistanceWeight + "*"  + int(enemyDistSum) + " - " + alliedDistanceWeight + "*" + int(allyDistSum) + ") / " + spawnpoint.numPlayersAtLastUpdate;
			#/
		}
		else
		{
			spawnpoint.weight = 0;

			/#
			if ( level.storeSpawnData  || level.debugSpawning )
				spawnpoint.spawnData[spawnpoint.spawnData.size] = "Base weight: 0";
			#/
		}
	}
	
	if (isdefined(favoredspawnpoints))
	{
		for (i= 0; i < favoredspawnpoints.size; i++)
		{
			if (isdefined(favoredspawnpoints[i].weight))
			{
				favoredspawnpoints[i].weight+= k_favored_spawn_point_bonus;
			}
			else
			{
				favoredspawnpoints[i].weight= k_favored_spawn_point_bonus;
			}
		}
	}
	
	
	
	avoidSameSpawn(spawnpoints);
	avoidSpawnReuse(spawnpoints, true);
	// not avoiding spawning near recent deaths for team-based modes. kills the fast pace.
	//avoidDangerousSpawns(spawnpoints, true);
	avoidWeaponDamage(spawnpoints);
	avoidVisibleEnemies(spawnpoints, true);
	
	
	result = getSpawnpoint_Final(spawnpoints);
	
	/#
	if ( GetDvarString( "scr_spawn_showbad") == "" )
		SetDvar("scr_spawn_showbad", "0");
	if ( GetDvarString( "scr_spawn_showbad") == "1" )
		checkBad( result );
	#/
	
	return result;
}

/////////////////////////////////////////////////////////////////////////

function getSpawnpoint_DM(spawnpoints)
{
//	level endon("game_ended");

	/*if ( self.wantSafeSpawn )
	{
		return getSpawnpoint_SafeSpawn( spawnpoints );
	}*/
	
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;
	
	Spawnlogic_Begin();

	initWeights(spawnpoints);
	
	aliveplayers = getAllOtherPlayers();
	
	// new logic: we want most players near idealDist units away.
	// players closer than badDist units will be considered negatively
	idealDist = 1600;
	badDist = 1200;
	
	if (aliveplayers.size > 0)
	{
		for (i = 0; i < spawnpoints.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for (j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(spawnpoints[i].origin, aliveplayers[j].origin);
				
				if (dist < badDist )
					nearbyBadAmount += (badDist - dist) / badDist;
				
				distfromideal = abs(dist - idealDist);
				totalDistFromIdeal += distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			
			wellDistancedAmount = (idealDist - avgDistFromIdeal) / idealDist;
			// if (wellDistancedAmount < 0) wellDistancedAmount = 0;
			
			// wellDistancedAmount is between -inf and 1, 1 being best (likely around 0 to 1)
			// nearbyBadAmount is between 0 and inf,
			// and it is very important that we get a bad weight if we have a high nearbyBadAmount.
			
			spawnpoints[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + randomfloat(.2);
		}
	}
	
	avoidSameSpawn(spawnpoints);
	avoidSpawnReuse(spawnpoints, false);
	//avoidDangerousSpawns(spawnpoints, false);
	avoidWeaponDamage(spawnpoints);
	avoidVisibleEnemies(spawnpoints, false);
	
	return getSpawnpoint_Final(spawnpoints);
}

/////////////////////////////////////////////////////////////////////////
//
// Hybrid of NearTeam and DM 
//


function getSpawnpoint_Turned( spawnpoints, idealDist, badDist, idealDistTeam, badDistTeam )
{
//	level endon("game_ended");

	/*if ( self.wantSafeSpawn )
	{
		return getSpawnpoint_SafeSpawn( spawnpoints );
	}*/
	
	// There are no valid spawnpoints in the map
	if(!isdefined(spawnpoints))
		return undefined;
	
	Spawnlogic_Begin();

	initWeights(spawnpoints);
	
	aliveplayers = getAllOtherPlayers();
	
	// new logic: we want most players near idealDist units away.
	// players closer than badDist units will be considered negatively
	if (!isDefined(idealDist))
		idealDist = 1600;
	if (!isDefined(idealDistTeam))
		idealDistTeam = 1200;
	if (!isDefined(badDist))
		badDist = 1200;
	if (!isDefined(badDistTeam))
		badDistTeam = 600;
	
	myTeam = self.team;
	if (aliveplayers.size > 0)
	{
		for (i = 0; i < spawnpoints.size; i++)
		{
			totalDistFromIdeal = 0;
			nearbyBadAmount = 0;
			for (j = 0; j < aliveplayers.size; j++)
			{
				dist = distance(spawnpoints[i].origin, aliveplayers[j].origin);
				distfromideal = 0;
				
				if ( aliveplayers[j].team == myTeam )
				{
					if (dist < badDistTeam )
						nearbyBadAmount += (badDistTeam - dist) / badDistTeam;
					distfromideal = abs(dist - idealDistTeam);
				}
				else
				{
					if (dist < badDist )
						nearbyBadAmount += (badDist - dist) / badDist;
					distfromideal = abs(dist - idealDist);
				}
				
				totalDistFromIdeal += distfromideal;
			}
			avgDistFromIdeal = totalDistFromIdeal / aliveplayers.size;
			
			wellDistancedAmount = (idealDist - avgDistFromIdeal) / idealDist;
			// if (wellDistancedAmount < 0) wellDistancedAmount = 0;
			
			// wellDistancedAmount is between -inf and 1, 1 being best (likely around 0 to 1)
			// nearbyBadAmount is between 0 and inf,
			// and it is very important that we get a bad weight if we have a high nearbyBadAmount.
			
			spawnpoints[i].weight = wellDistancedAmount - nearbyBadAmount * 2 + randomfloat(.2);
		}
	}
	
	avoidSameSpawn(spawnpoints);
	avoidSpawnReuse(spawnpoints, false);
	//avoidDangerousSpawns(spawnpoints, false);
	avoidWeaponDamage(spawnpoints);
	avoidVisibleEnemies(spawnpoints, false);
	
	return getSpawnpoint_Final(spawnpoints);
}

// =============================================

// called at the start of every spawn
function Spawnlogic_Begin()
{
	//updateDeathInfo();

	/#
	level.storeSpawnData = GetDvarint( "scr_recordspawndata");
	level.debugSpawning = (GetDvarint( "scr_spawnpointdebug") > 0);
	#/
}

/#

function watchSpawnProfile()
{
	while(1)
	{
		while(1)
		{
			if (GetDvarint( "scr_spawnprofile") > 0)
				break;
			wait .05;
		}
		
		thread spawnProfile();
		
		while(1)
		{
			if (GetDvarint( "scr_spawnprofile") <= 0)
				break;
			wait .05;
		}
		
		level notify("stop_spawn_profile");
	}
}

function spawnProfile()
{
	level endon("stop_spawn_profile");
	while(1)
	{
		if ( level.players.size > 0 && level.spawnpoints.size > 0 )
		{
			playerNum = randomint(level.players.size);
			player = level.players[playerNum];
			attempt = 1;
			while ( !isdefined( player ) && attempt < level.players.size )
			{
				playerNum = ( playerNum + 1 ) % level.players.size;
				attempt++;
				player = level.players[playerNum];
			}
			
			player getSpawnpoint_NearTeam(level.spawnpoints);
		}
		wait .05;
	}
}

function spawnGraphCheck()
{
	while(1)
	{
		if ( GetDvarint( "scr_spawngraph") < 1 )
		{
			wait 3;
			continue;
		}
		thread spawnGraph();
		return;
	}
}

function spawnGraph()
{
	w = 20;
	h = 20;
	weightscale = .1;
	fakespawnpoints = [];
	
	corners = getentarray("minimap_corner", "targetname");
	if ( corners.size != 2 )
	{
		println("^1 can't spawn graph: no minimap corners");
		return;
	}
	min = corners[0].origin;
	max = corners[0].origin;
	if ( corners[1].origin[0] > max[0] )
		max = (corners[1].origin[0], max[1], max[2]);
	else
		min = (corners[1].origin[0], min[1], min[2]);
	if ( corners[1].origin[1] > max[1] )
		max = (max[0], corners[1].origin[1], max[2]);
	else
		min = (min[0], corners[1].origin[1], min[2]);
	
	i = 0;
	for ( y = 0; y < h; y++ )
	{
		yamnt = y / (h - 1);
		for ( x = 0; x < w; x++ )
		{
			xamnt = x / (w - 1);
			fakespawnpoints[i] = spawnstruct();
			fakespawnpoints[i].origin = (min[0] * xamnt + max[0] * (1-xamnt), min[1] * yamnt + max[1] * (1-yamnt), min[2]);
			fakespawnpoints[i].angles = (0,0,0);
			
			fakespawnpoints[i].forward = anglesToForward( fakespawnpoints[i].angles );
			fakespawnpoints[i].sightTracePoint = fakespawnpoints[i].origin;
			
			i++;
		}
	}
	
	didweights = false;
	
	while(1)
	{
		spawni = 0;
		numiters = 5;
		for ( i = 0; i < numiters; i++ )
		{
			if ( !level.players.size || !isdefined( level.players[0].team ) || level.players[0].team == "spectator" || !isdefined( level.players[0].curClass ) )
				break;
			
			endspawni = spawni + fakespawnpoints.size / numiters;
			if ( i == numiters - 1 )
				endspawni = fakespawnpoints.size;
			
			for ( ; spawni < endspawni; spawni++ )
			{
				spawnPointUpdate( fakespawnpoints[spawni] );
			}
			
			if ( didweights )
				level.players[0] drawSpawnGraph( fakespawnpoints, w, h, weightscale );
			
			wait .05;
		}
		
		if ( !level.players.size || !isdefined( level.players[0].team ) || level.players[0].team == "spectator" || !isdefined( level.players[0].curClass ) )
		{
			wait 1;
			continue;
		}
		
		level.players[0] getSpawnpoint_NearTeam( fakespawnpoints );
		
		for ( i = 0; i < fakespawnpoints.size; i++ )
			setupSpawnGraphPoint( fakespawnpoints[i], weightscale );
		
		didweights = true;
		
		level.players[0] drawSpawnGraph( fakespawnpoints, w, h, weightscale );
		
		wait .05;
	}
}

function drawSpawnGraph( fakespawnpoints, w, h, weightscale )
{
	i = 0;
	for ( y = 0; y < h; y++ )
	{
		yamnt = y / (h - 1);
		for ( x = 0; x < w; x++ )
		{
			xamnt = x / (w - 1);
			
			if ( y > 0 )
			{
				spawnGraphLine( fakespawnpoints[i], fakespawnpoints[i-w], weightscale );
			}
			if ( x > 0 )
			{
				spawnGraphLine( fakespawnpoints[i], fakespawnpoints[i-1], weightscale );
			}
			i++;
		}
	}
}

function setupSpawnGraphPoint( s1, weightscale )
{
	s1.visible = true;
	if ( s1.weight < -1000/weightscale )
	{
		s1.visible = false;
	}
}

function spawnGraphLine( s1, s2, weightscale )
{
	if ( !s1.visible || !s2.visible )
		return;
	
	p1 = s1.origin + (0,0,s1.weight*weightscale + 100);
	p2 = s2.origin + (0,0,s2.weight*weightscale + 100);
	
	line( p1, p2, (1,1,1) );
}

// DEBUG
function loopbotspawns()
{
	while(1)
	{
		if ( GetDvarint( "scr_killbots") < 1 )
		{
			wait 3;
			continue;
		}
		if ( !isdefined( level.players ) )
		{
			wait .05;
			continue;
		}
		
		bots = [];
		for (i = 0; i < level.players.size; i++)
		{
			if ( !isdefined( level.players[i] ) )
				continue;

			if ( level.players[i].sessionstate == "playing" && issubstr(level.players[i].name, "bot") )
			{
				bots[bots.size] = level.players[i];
			}
		}
		if ( bots.size > 0 )
		{
			if ( GetDvarint( "scr_killbots" ) == 1 )
			{
				killer = bots[randomint(bots.size)];
				victim = bots[randomint(bots.size)];
				
				victim thread [[level.callbackPlayerDamage]] (
					killer, // eInflictor The entity that causes the damage.(e.g. a turret)
					killer, // eAttacker The entity that is attacking.
					1000, // iDamage Integer specifying the amount of damage done
					0, // iDFlags Integer specifying flags that are to be applied to the damage
					"MOD_RIFLE_BULLET", // sMeansOfDeath Integer specifying the method of death
					level.weaponNone, // weapon The weapon used to inflict the damage
					(0,0,0), // vPoint The point the damage is from?
					(0,0,0), // vDir The direction of the damage
					"none", // sHitLoc The location of the hit
					0, // psOffsetTime The time offset for the damage
					0 // boneIndex
				);
			}
			else
			{
				numKills = GetDvarint( "scr_killbots" );
				lastVictim = undefined;
				for ( index = 0; index < numKills; index++ )
				{
					killer = bots[randomint(bots.size)];
					victim = bots[randomint(bots.size)];
					
					while ( isdefined( lastVictim ) && victim == lastVictim )
						victim = bots[randomint(bots.size)];
					
					victim thread [[level.callbackPlayerDamage]] (
						killer, // eInflictor The entity that causes the damage.(e.g. a turret)
						killer, // eAttacker The entity that is attacking.
						1000, // iDamage Integer specifying the amount of damage done
						0, // iDFlags Integer specifying flags that are to be applied to the damage
						"MOD_RIFLE_BULLET", // sMeansOfDeath Integer specifying the method of death
						level.weaponNone, // weapon The weapon used to inflict the damage
						(0,0,0), // vPoint The point the damage is from?
						(0,0,0), // vDir The direction of the damage
						"none", // sHitLoc The location of the hit
						0, // psOffsetTime The time offset for the damage
						0  // boneIndex
					);
					
					lastVictim = victim;
				}
			}
		}
		
		if ( GetDvarString( "scr_killbottimer") != "" )
			wait GetDvarfloat( "scr_killbottimer");
		else
			wait .05;
	}
}

// DEBUG
function allowSpawnDataReading()
{
	SetDvar("scr_showspawnid", "");
	prevval = GetDvarString( "scr_showspawnid");
	
	prevrelval = GetDvarString( "scr_spawnidcycle");
	
	readthistime = false;
	
	while(1)
	{
		val = GetDvarString( "scr_showspawnid");
		relval = undefined;
		if (!isdefined(val) || val == prevval)
		{
			relval = GetDvarString( "scr_spawnidcycle");
			if ( isdefined( relval ) && relval != "" )
			{
				SetDvar("scr_spawnidcycle", "");
			}
			else
			{
				wait(.5);
				continue;
			}
		}
		prevval = val;
		
		readthistime = false;
		
		readSpawnData( val, relval );
		
		if ( !isdefined( level.curspawndata ) )
		{
			println( "No spawn data to draw." );
		}
		else
		{
			println( "Drawing spawn ID " + level.curspawndata.id );
		}
		
		thread drawSpawnData();
	}
}
#/
// DEBUG
function showDeathsDebug()
{
	/#
	while(1)
	{
		if (GetDvarString( "scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}

		time = getTime();
		
		for (i = 0; i < level.spawnlogic_deaths.size; i++)
		{
			if (isdefined(level.spawnlogic_deaths[i].los))
				line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1,0,0)); // line-of-sights are shown in red
			else
				line(level.spawnlogic_deaths[i].org, level.spawnlogic_deaths[i].killOrg, (1,1,1));
			killer = level.spawnlogic_deaths[i].killer;
			if (isdefined(killer) && isalive(killer))
				line(level.spawnlogic_deaths[i].killOrg, killer.origin, (.4,.4,.8));
		}
		
		for (p = 0; p < level.players.size; p++)
		{
			if ( !isdefined( level.players[p] ) )
				continue;
			if (isdefined(level.players[p].spawnlogic_killdist))
				print3d(level.players[p].origin + (0,0,64), level.players[p].spawnlogic_killdist, (1,1,1));
		}
		
		oldspawnkills = level.spawnlogic_spawnkills;
		level.spawnlogic_spawnkills = [];
		for (i = 0; i < oldspawnkills.size; i++)
		{
			spawnkill = oldspawnkills[i];
			
			/*spawnkill.dierwasspawner = true;
			spawnkill.dierorigin = dier.origin;
			spawnkill.killerorigin = killer.origin;
			spawnkill.spawnpointorigin = dier.lastspawnpoint.origin;
			spawnkill.time = time;*/
			
			if (spawnkill.dierwasspawner) {
				line(spawnkill.spawnpointorigin, spawnkill.dierorigin, (.4,.5,.4));
				line(spawnkill.dierorigin, spawnkill.killerorigin, (0,1,1));
				print3d(spawnkill.dierorigin + (0,0,32), "SPAWNKILLED!", (0,1,1));
			}
			else {
				line(spawnkill.spawnpointorigin, spawnkill.killerorigin, (.4,.5,.4));
				line(spawnkill.killerorigin, spawnkill.dierorigin, (0,1,1));
				print3d(spawnkill.dierorigin + (0,0,32), "SPAWNDIED!", (0,1,1));
			}
			
			if (time - spawnkill.time < 60*1000)
				level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = oldspawnkills[i];
		}
		wait(.05);
	}
	#/
}
// DEBUG
function updateDeathInfoDebug()
{
	while(1)
	{
		if (GetDvarString( "scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}
		updateDeathInfo();
		wait(3);
	}
}
// DEBUG
function spawnWeightDebug(spawnpoints)
{
	level notify("stop_spawn_weight_debug");
	level endon("stop_spawn_weight_debug");
	/#
	while(1)
	{
		if (GetDvarString( "scr_spawnpointdebug") == "0") {
			wait(3);
			continue;
		}
		textoffset = (0,0,-12);
		for (i = 0; i < spawnpoints.size; i++)
		{
			amnt = 1 * (1 - spawnpoints[i].weight / (-100000));
			if (amnt < 0) amnt = 0;
			if (amnt > 1) amnt = 1;
			
			orig = spawnpoints[i].origin + (0,0,80);
			
			print3d(orig, int(spawnpoints[i].weight), (1,amnt,.5));
			orig += textoffset;
			
			if (isdefined(spawnpoints[i].spawnData))
			{
				for (j = 0; j < spawnpoints[i].spawnData.size; j++)
				{
					print3d(orig, spawnpoints[i].spawnData[j], (.5,.5,.5));
					orig += textoffset;
				}
			}
			if (isdefined(spawnpoints[i].sightChecks))
			{
				for (j = 0; j < spawnpoints[i].sightChecks.size; j++)
				{
					if ( spawnpoints[i].sightChecks[j].penalty == 0 )
						continue;
					print3d(orig, "Sight to enemy: -" + spawnpoints[i].sightChecks[j].penalty, (.5,.5,.5));
					orig += textoffset;
				}
			}
		}
		wait(.05);
	}
	#/
}
// DEBUG
function profileDebug()
{
	while(1)
	{
		if (GetDvarString( "scr_spawnpointprofile") != "1") {
			wait(3);
			continue;
		}
		
		for (i = 0; i < level.spawnpoints.size; i++)
			level.spawnpoints[i].weight = randomint(10000);
		if (level.players.size > 0)
			level.players[randomint(level.players.size)] getSpawnpoint_NearTeam(level.spawnpoints);
		
		wait(.05);
	}
}
// DEBUG
function debugNearbyPlayers(players, origin)
{
	/#
	if (GetDvarString( "scr_spawnpointdebug") == "0") {
		return;
	}
	starttime = gettime();
	while(1)
	{
		for (i = 0; i < players.size; i++)
			line(players[i].origin, origin, (.5,1,.5));
		if (gettime() - starttime > 5000)
			return;
		wait .05;
	}
	#/
}

function deathOccured(dier, killer)
{
	/*if (!isdefined(killer) || !isdefined(dier) || !isplayer(killer) || !isplayer(dier) || killer == dier)
		return;
	
	time = getTime();
	
	// DEBUG
	// check if there was a spawn kill
	if (time - dier.lastspawntime < 5*1000 && distance(dier.origin, dier.lastspawnpoint.origin) < 300)
	{
		spawnkill = spawnstruct();
		spawnkill.dierwasspawner = true;
		spawnkill.dierorigin = dier.origin;
		spawnkill.killerorigin = killer.origin;
		spawnkill.spawnpointorigin = dier.lastspawnpoint.origin;
		spawnkill.time = time;
		level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = spawnkill;
	}
	else if (time - killer.lastspawntime < 5*1000 && distance(killer.origin, killer.lastspawnpoint.origin) < 300)
	{
		spawnkill = spawnstruct();
		spawnkill.dierwasspawner = false;
		spawnkill.dierorigin = dier.origin;
		spawnkill.killerorigin = killer.origin;
		spawnkill.spawnpointorigin = killer.lastspawnpoint.origin;
		spawnkill.time = time;
		level.spawnlogic_spawnkills[level.spawnlogic_spawnkills.size] = spawnkill;
	}
	
	// record kill information
	deathInfo = spawnstruct();
	
	deathInfo.time = time;
	deathInfo.org = dier.origin;
	deathInfo.killOrg = killer.origin;
	deathInfo.killer = killer;
	
	checkForSimilarDeaths(deathInfo);
	level.spawnlogic_deaths[level.spawnlogic_deaths.size] = deathInfo;
	
	// keep track of the most dangerous players in terms of how far they have killed people recently
	dist = distance(dier.origin, killer.origin);
	if (!isdefined(killer.spawnlogic_killdist) || time - killer.spawnlogic_killtime > 1000*30 || dist > killer.spawnlogic_killdist)
	{
		killer.spawnlogic_killdist = dist;
		killer.spawnlogic_killtime = time;
	}*/
}
function checkForSimilarDeaths(deathInfo)
{
	// check if this is really similar to any old deaths, and if so, mark them for removal later
	for (i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		if (level.spawnlogic_deaths[i].killer == deathInfo.killer)
		{
			dist = distance(level.spawnlogic_deaths[i].org, deathInfo.org);
			if (dist > 200) continue;
			dist = distance(level.spawnlogic_deaths[i].killOrg, deathInfo.killOrg);
			if (dist > 200) continue;
			
			level.spawnlogic_deaths[i].remove = true;
		}
	}
}

function updateDeathInfo()
{
	
	time = getTime();
	for (i = 0; i < level.spawnlogic_deaths.size; i++)
	{
		// if the killer has walked away or enough time has passed, get rid of this death information
		deathInfo = level.spawnlogic_deaths[i];
		
		if (time - deathInfo.time > 1000*90 || // if 90 seconds have passed
			!isdefined(deathInfo.killer) ||
			!isalive(deathInfo.killer) ||
			(!isdefined( level.teams[deathInfo.killer.team] )) ||
			distance(deathInfo.killer.origin, deathInfo.killOrg) > 400) {
			level.spawnlogic_deaths[i].remove = true;
		}
	}
	
	// remove all deaths with remove set
	oldarray = level.spawnlogic_deaths;
	level.spawnlogic_deaths = [];
	
	// never keep more than the 1024 most recent entries in the array
	start = 0;
	if (oldarray.size - 1024 > 0) start = oldarray.size - 1024;
	
	for (i = start; i < oldarray.size; i++)
	{
		if (!isdefined(oldarray[i].remove))
			level.spawnlogic_deaths[level.spawnlogic_deaths.size] = oldarray[i];
	}

}	

/*
// uses death information to reduce the weights of spawns that might cause spawn kills
function avoidDangerousSpawns(spawnpoints, teambased) // (assign weights to the return value of this)
{
	// DEBUG
	if (GetDvarString( "scr_spawnpointnewlogic") == "0") {
		return;
	}

	// DEBUG
	
	deathpenalty = 100000;
	if (GetDvarString( "scr_spawnpointdeathpenalty") != "" && GetDvarString( "scr_spawnpointdeathpenalty") != "0")
		deathpenalty = GetDvarfloat( "scr_spawnpointdeathpenalty");
	
	maxDist = 200;
	if (GetDvarString( "scr_spawnpointmaxdist") != "" && GetDvarString( "scr_spawnpointmaxdist") != "0")
		maxdist = GetDvarfloat( "scr_spawnpointmaxdist");
	
	maxDistSquared = maxDist*maxDist;
	for (i = 0; i < spawnpoints.size; i++)
	{
		for (d = 0; d < level.spawnlogic_deaths.size; d++)
		{
			// (we've got a lotta checks to do, want to rule them out quickly)
			distSqrd = distanceSquared(spawnpoints[i].origin, level.spawnlogic_deaths[d].org);
			if (distSqrd > maxDistSquared)
				continue;
			
			// make sure the killer in question is on the opposing team
			player = level.spawnlogic_deaths[d].killer;
			if (!isalive(player)) continue;
			if (player == self) continue;
			if (teambased && player.team == self.team) continue;
			
			// (no sqrt, must recalculate distance)
			dist = distance(spawnpoints[i].origin, level.spawnlogic_deaths[d].org);
			spawnpoints[i].weight -= (1 - dist/maxDist) * deathpenalty; // possible spawn kills are *really* bad
		}
	}
	
	// DEBUG
}	
*/


// used by spawning; needs to be fast.
function isPointVulnerable(playerorigin)
{
	pos = self.origin + level.bettymodelcenteroffset;
	playerpos = playerorigin + (0,0,32);
	distsqrd = distancesquared(pos, playerpos);
	
	forward = anglestoforward(self.angles);
	
	if (distsqrd < level.bettyDetectionRadius*level.bettyDetectionRadius)
	{
		playerdir = vectornormalize(playerpos - pos);
		angle = acos(vectordot(playerdir, forward));
		if (angle < level.bettyDetectionConeAngle) {
			return true;
		}
	}
	return false;
}


function avoidWeaponDamage(spawnpoints)
{
	if (GetDvarString( "scr_spawnpointnewlogic") == "0") 
	{
		return;
	}
	
	
	weaponDamagePenalty = 100000;
	if (GetDvarString( "scr_spawnpointweaponpenalty") != "" && GetDvarString( "scr_spawnpointweaponpenalty") != "0")
		weaponDamagePenalty = GetDvarfloat( "scr_spawnpointweaponpenalty");

	mingrenadedistsquared = 250*250; // (actual grenade radius is 220, 250 includes a safety area of 30 units)

	for (i = 0; i < spawnpoints.size; i++)
	{
		for (j = 0; j < level.grenades.size; j++)
		{
			if ( !isdefined( level.grenades[j] ) )
				continue;

			// could also do a sight check to see if it's really dangerous.
			if (distancesquared(spawnpoints[i].origin, level.grenades[j].origin) < mingrenadedistsquared)
			{
				spawnpoints[i].weight -= weaponDamagePenalty;
				/#
				if ( level.storeSpawnData  || level.debugSpawning )
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was near grenade: -" + int(weaponDamagePenalty);
				#/
			}
		}
	}

}	

function spawnPerFrameUpdate()
{
	spawnpointindex = 0;
		
	// each frame, do sight checks against a spawnpoint
	
	while(1)
	{
		wait .05;
		
		
		//time = gettime();
		
		if ( !isdefined( level.spawnPoints ) )
			return;
		
		spawnpointindex = (spawnpointindex + 1) % level.spawnPoints.size;
		spawnpoint = level.spawnPoints[spawnpointindex];
		
		spawnPointUpdate( spawnpoint );
		
	}	
}

function getNonTeamSum( skip_team, sums )
{
	value = 0;
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		value += sums[team];
	}
	
	return value;
}

function getNonTeamMinDist( skip_team, minDists )
{
	dist = 9999999;
	foreach( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		if ( dist > minDists[team] )
			dist = minDists[team];
	}
	
	return dist;
}


function spawnPointUpdate( spawnpoint )
{
	if ( level.teambased )
	{
		sights = [];
		foreach( team in level.teams )
		{
			spawnpoint.enemySights[team] = 0;
			sights[team] = 0;
			spawnpoint.nearbyPlayers[team] = [];
		}
	}
	else
	{
		spawnpoint.enemySights = 0;
		
		spawnpoint.nearbyPlayers["all"] = [];
	}
	
	spawnpointdir = spawnpoint.forward;
	
	debug = false;
	/#
	debug = (GetDvarint( "scr_spawnpointdebug") > 0);
	#/
	
	minDist = [];
	distSum = [];
	
	if ( !level.teambased )
	{
		minDist["all"] = 9999999;
	}

	foreach( team in level.teams )
	{
		spawnpoint.distSum[team] = 0;
		spawnpoint.enemyDistSum[team] = 0;
		spawnpoint.minEnemyDist[team] = 9999999;
		minDist[team] = 9999999;
	}
	
	spawnpoint.numPlayersAtLastUpdate = 0;
		
	for (i = 0; i < level.players.size; i++)
	{
		player = level.players[i];
		
		if ( player.sessionstate != "playing" )
			continue;
		
		diff = player.origin - spawnpoint.origin;
		diff = (diff[0], diff[1], 0);
		dist = length( diff ); // needs to be actual distance for distSum value
		
		team = "all";
		if ( level.teambased )
			team = player.team;
		
		if ( dist < 1024 )
		{
			spawnpoint.nearbyPlayers[team][spawnpoint.nearbyPlayers[team].size] = player;
		}
		
		if ( dist < minDist[team] )
			minDist[team] = dist;
	
		distSum[ team ] += dist;
		spawnpoint.numPlayersAtLastUpdate++;
		
		pdir = anglestoforward(player.angles);
		if (vectordot(spawnpointdir, diff) < 0 && vectordot(pdir, diff) > 0)
			continue; // player and spawnpoint are looking in opposite directions
		
		// do sight check
		losExists = bullettracepassed(player.origin + (0,0,50), spawnpoint.sightTracePoint, false, undefined);
		
		spawnpoint.lastSightTraceTime = gettime();
		
		if (losExists)
		{
			if ( level.teamBased )
				sights[player.team]++;
			else
				spawnpoint.enemySights++;
			
			// DEBUG
			//println("Sight check succeeded!");
			
			/*
			death info stuff is disabled right now
			// pretend this player killed a person at this spawnpoint, so we don't try to use it again any time soon.
			deathInfo = spawnstruct();
			
			deathInfo.time = time;
			deathInfo.org = spawnpoint.origin;
			deathInfo.killOrg = player.origin;
			deathInfo.killer = player;
			deathInfo.los = true;
			
			checkForSimilarDeaths(deathInfo);
			level.spawnlogic_deaths[level.spawnlogic_deaths.size] = deathInfo;
			*/
			
			/#
			if ( debug )
				line(player.origin + (0,0,50), spawnpoint.sightTracePoint, (.5,1,.5));
			#/
		}
		//else
		//	line(player.origin + (0,0,50), spawnpoint.sightTracePoint, (1,.5,.5));
	}
	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			spawnpoint.enemySights[team] = getNonTeamSum( team, sights );
			spawnpoint.minEnemyDist[team] = getNonTeamMinDist( team, minDist );
			spawnpoint.distSum[team] = distSum[team];
			spawnpoint.enemyDistSum[team] = getNonTeamSum( team, distSum);
		}
	}
	else
	{
		spawnpoint.distSum["all"] = distSum["all"];
		spawnpoint.enemyDistSum["all"] = distSum["all"];
		spawnpoint.minEnemyDist["all"] = minDist["all"];
	}	

}

function getLosPenalty()
{
	if (GetDvarString( "scr_spawnpointlospenalty") != "" && GetDvarString( "scr_spawnpointlospenalty") != "0")
		return GetDvarfloat( "scr_spawnpointlospenalty");
	return 100000;
}

function lastMinuteSightTraces( spawnpoint )
{	
	if ( !isdefined( spawnpoint.nearbyPlayers ) )
		return false;
	
	closest = undefined;
	closestDistsq = undefined;
	secondClosest = undefined;
	secondClosestDistsq = undefined;
	
	foreach( team in spawnpoint.nearbyPlayers )
	{
		if ( team == self.team )
			continue;
			
		for ( i = 0; i < spawnpoint.nearbyPlayers[team].size; i++ )
		{
			player = spawnpoint.nearbyPlayers[team][i];
			
			if ( !isdefined( player ) )
				continue;
			if ( player.sessionstate != "playing" )
				continue;
			if ( player == self )
				continue;
			
			distsq = distanceSquared( spawnpoint.origin, player.origin );
			if ( !isdefined( closest ) || distsq < closestDistsq )
			{
				secondClosest = closest;
				secondClosestDistsq = closestDistsq;
				
				closest = player;
				closestDistSq = distsq;
			}
			else if ( !isdefined( secondClosest ) || distsq < secondClosestDistSq )
			{
				secondClosest = player;
				secondClosestDistSq = distsq;
			}
		}
	}
	
	if ( isdefined( closest ) )
	{
		if ( bullettracepassed( closest.origin       + (0,0,50), spawnpoint.sightTracePoint, false, undefined) )
			return true;
	}
	if ( isdefined( secondClosest ) )
	{
		if ( bullettracepassed( secondClosest.origin + (0,0,50), spawnpoint.sightTracePoint, false, undefined) )
			return true;
	}
	
	return false;
}



function avoidVisibleEnemies(spawnpoints, teambased)
{
	if (GetDvarString( "scr_spawnpointnewlogic") == "0") 
	{
		return;
	}

	// DEBUG
	
	lospenalty = getLosPenalty();
	
	minDistTeam = self.team;
	
	if ( teambased )
	{
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if ( !isdefined(spawnpoints[i].enemySights) )
				continue;
			
			penalty = lospenalty * spawnpoints[i].enemySights[self.team];
			spawnpoints[i].weight -= penalty;
			
			/#
			if ( level.storeSpawnData  || level.debugSpawning ) {
				index = spawnpoints[i].sightChecks.size;
				spawnpoints[i].sightChecks[index] = spawnstruct();
				spawnpoints[i].sightChecks[index].penalty = penalty;
			}
			#/
		}
	}
	else
	{
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			if ( !isdefined(spawnpoints[i].enemySights) )
				continue;

			penalty = lospenalty * spawnpoints[i].enemySights;
			spawnpoints[i].weight -= penalty;

			/#
			if ( level.storeSpawnData  || level.debugSpawning ) {
				index = spawnpoints[i].sightChecks.size;
				spawnpoints[i].sightChecks[index] = spawnstruct();
				spawnpoints[i].sightChecks[index].penalty = penalty;
			}
			#/
		}
		
		minDistTeam = "all";
	}
	
	avoidWeight = GetDvarfloat( "scr_spawn_enemyavoidweight");
	if ( avoidWeight != 0 )
	{
		nearbyEnemyOuterRange = GetDvarfloat( "scr_spawn_enemyavoiddist");
		nearbyEnemyOuterRangeSq = nearbyEnemyOuterRange * nearbyEnemyOuterRange;
		nearbyEnemyPenalty = 1500 * avoidWeight; // typical base weights tend to peak around 1500 or so. this is large enough to upset that while only locally dominating it.
		nearbyEnemyMinorPenalty = 800 * avoidWeight; // additional negative weight for distances up to 2 * nearbyEnemyOuterRange
		
		lastAttackerOrigin = (-99999,-99999,-99999);
		lastDeathPos = (-99999,-99999,-99999);
		if ( isAlive( self.lastAttacker ) )
			lastAttackerOrigin = self.lastAttacker.origin;
		if ( isdefined( self.lastDeathPos ) )
			lastDeathPos = self.lastDeathPos;
		
		for ( i = 0; i < spawnpoints.size; i++ )
		{
			// penalty for nearby enemies
			mindist = spawnpoints[i].minEnemyDist[minDistTeam];
			if ( mindist < nearbyEnemyOuterRange*2 )
			{
				penalty = nearbyEnemyMinorPenalty * (1 - mindist / (nearbyEnemyOuterRange*2));
				if ( mindist < nearbyEnemyOuterRange )
					penalty += nearbyEnemyPenalty * (1 - mindist / nearbyEnemyOuterRange);
				if ( penalty > 0 )
				{
					spawnpoints[i].weight -= penalty;
					/#
					if ( level.storeSpawnData  || level.debugSpawning )
						spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Nearest enemy at " + int(spawnpoints[i].minEnemyDist[minDistTeam]) + " units: -" + int(penalty);
					#/
				}
			}
			
			/*
			// additional penalty for being near the guy who just killed me
			distSq = distanceSquared( lastAttackerOrigin, spawnpoints[i].origin );
			if ( distSq < nearbyEnemyOuterRangeSq )
			{
				penalty = nearbyEnemyPenalty * (1 - sqrt( distSq ) / nearbyEnemyOuterRange);
				assert( penalty > 0 );
				spawnpoints[i].weight -= penalty;
				/#
				if ( level.storeSpawnData  || level.debugSpawning )
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Nearby killer at " + int(sqrt( distSq )) + " units: -" + int(penalty);
				#/
			}
			*/
			
			/*
			// penalty for being near where i just died
			distSq = distanceSquared( lastDeathPos, spawnpoints[i].origin );
			if ( distSq < nearbyEnemyOuterRangeSq )
			{
				penalty = nearbyEnemyPenalty * (1 - sqrt( distSq ) / nearbyEnemyOuterRange);
				assert( penalty > 0 );
				spawnpoints[i].weight -= penalty;
				/#
				if ( level.storeSpawnData || level.debugSpawning )
					spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Died nearby at " + int(sqrt( distSq )) + " units: -" + int(penalty);
				#/
			}
			*/
		}
	}
				
	// DEBUG
}	

function avoidSpawnReuse(spawnpoints, teambased)
{
	// DEBUG
	if (GetDvarString( "scr_spawnpointnewlogic") == "0") {
		return;
	}
	
	
	time = getTime();
	
	maxtime = 10*1000;
	maxdistSq = 1024 * 1024;

	for (i = 0; i < spawnpoints.size; i++)
	{
		spawnpoint = spawnpoints[i];
		
		if (!isdefined(spawnpoint.lastspawnedplayer) || !isdefined(spawnpoint.lastspawntime) ||
			!isalive(spawnpoint.lastspawnedplayer))
			continue;

		if (spawnpoint.lastspawnedplayer == self) 
			continue;
		if (teambased && spawnpoint.lastspawnedplayer.team == self.team) 
			continue;
		
		timepassed = time - spawnpoint.lastspawntime;
		if (timepassed < maxtime)
		{
			distSq = distanceSquared(spawnpoint.lastspawnedplayer.origin, spawnpoint.origin);
			if (distSq < maxdistSq)
			{
				worsen = 5000 * (1 - distSq/maxdistSq) * (1 - timepassed/maxtime);
				spawnpoint.weight -= worsen;
				/#
				if ( level.storeSpawnData  || level.debugSpawning )
					spawnpoint.spawnData[spawnpoint.spawnData.size] = "Was recently used: -" + worsen;
				#/
			}
			else
				spawnpoint.lastspawnedplayer = undefined; // don't worry any more about this spawnpoint
		}
		else
			spawnpoint.lastspawnedplayer = undefined; // don't worry any more about this spawnpoint
	}

}	

function avoidSameSpawn(spawnpoints)
{
	// DEBUG
	if (GetDvarString( "scr_spawnpointnewlogic") == "0") {
		return;
	}
	
	
	if (!isdefined(self.lastspawnpoint))
		return;
	
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (spawnpoints[i] == self.lastspawnpoint) 
		{
			spawnpoints[i].weight -= 50000; // (half as bad as a likely spawn kill)
			/#
			if ( level.storeSpawnData  || level.debugSpawning )
				spawnpoints[i].spawnData[spawnpoints[i].spawnData.size] = "Was last spawnpoint: -50000";
			#/
			break;
		}
	}
	
}	

function getRandomIntermissionPoint()
{
		spawnpoints = getentarray("mp_global_intermission", "classname");
		if ( !spawnpoints.size )
		{
			spawnpoints = getentarray("info_player_start", "classname");
		}
		assert( spawnpoints.size );
		spawnpoint = spawnlogic::getSpawnpoint_Random(spawnpoints);
	
		return spawnpoint;
}
