#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;


/*QUAKED mp_dom_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_dom_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if ( getdvar("mapname") == "mp_background" )
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "hq", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "hq", 300, 0, 500 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "hq", 0, 0, 10 );
	
	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;

	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_defend" );

	precacheShader( "waypoint_targetneutral" );
	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );
	
	if ( getdvar("koth_autodestroytime") == "" )
		setdvar("koth_autodestroytime", "90");
	level.hqAutoDestroyTime = getdvarint("koth_autodestroytime");
	
	if ( getdvar("koth_spawntime") == "" )
		setdvar("koth_spawntime", "30");
	level.hqSpawnTime = getdvarint("koth_spawntime");
	
	if ( getdvar("koth_kothmode") == "" )
		setdvar("koth_kothmode", "1");
	level.kothmode = getdvarint("koth_kothmode");
	
	level.iconoffset = (0,0,32);
	
	level.onRespawnDelay = ::getRespawnDelay;
}

updateObjectiveHintMessages( alliesObjective, axisObjective )
{
	game["strings"]["objective_hint_allies"] = alliesObjective;
	game["strings"]["objective_hint_axis"  ] = axisObjective;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player.pers["team"] ) && player.pers["team"] != "spectator" )
		{
			hintText = maps\mp\gametypes\_globallogic::getObjectiveHintText( player.pers["team"] );
			player thread maps\mp\gametypes\_hud_message::hintMessage( hintText );
		}
	}
}

getRespawnDelay()
{
	if ( level.kothmode )
		return undefined;
	
	if ( !isDefined( level.radioObject ) )
		return undefined;
	
	hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
	if ( self.pers["team"] == hqOwningTeam )
	{
		if ( !isDefined( level.hqDestroyTime ) )
			return undefined;
		
		timeRemaining = (level.hqDestroyTime - gettime()) / 1000;
		return timeRemaining;
	}
}

onStartGameType()
{
	// TODO: HQ objective text
	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DOM" );
	
	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	
	// TODO: localize, precache
	level.objectiveHintPrepareHQ = &"Control_the_headquarter_location";
	level.objectiveHintCaptureHQ = &"Capture_the_headquarters";
	level.objectiveHintDestroyHQ = &"Destroy_the_enemy_headquarters";
	level.objectiveHintDefendHQ = &"Defend_the_headquarters";
	
	if ( level.kothmode )
		level.objectiveHintDestroyHQ = &"Capture_the_enemy_headquarters";
	
	updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
	
	setClientNameMode("auto_change");
	
	// TODO: HQ spawnpoints
	level.spawnpoints = [];
	level.spawn_all = getentarray("mp_tdm_spawn", "classname");
	if ( !level.spawn_all.size )
	{
		iprintln("No mp_tdm_spawn spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	level.spawnpoints = level.spawn_all;
	
	for(i = 0; i < level.spawnpoints.size; i++)
		level.spawnpoints[i] placeSpawnpoint();
	
	allowed[0] = "hq";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	level.suppressHardpoint3DIcons = true;
	
	thread SetupRadios();
	
	thread HQMainLoop();
}


HQMainLoop()
{
	while ( level.inPrematchPeriod )
		wait ( 0.05 );
	
	wait 3;
	
	// TODO: localize
	hqSpawningInStr = &"Headquarters will spawn in ";
	hqDestroyedInFriendlyStr = &"Reinforcements arriving in ";
	hqDestroyedInEnemyStr = &"Destroy enemy headquarters within ";
	if ( level.kothmode )
		hqDestroyedInEnemyStr = &"Capture enemy headquarters within ";
	
	timerDisplay = [];
	timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	timerDisplay["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	timerDisplay["allies"].label = hqSpawningInStr;
	timerDisplay["allies"].alpha = 0;
	timerDisplay["allies"].archived = false;
	
	timerDisplay["axis"  ] = createServerTimer( "objective", 1.4, "axis" );
	timerDisplay["axis"  ] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	timerDisplay["axis"  ].label = hqSpawningInStr;
	timerDisplay["axis"  ].alpha = 0;
	timerDisplay["axis"  ].archived = false;
	
	locationObjID = maps\mp\gametypes\_gameobjects::getNextObjID();
	
	objective_add( locationObjID, "invisible", (0,0,0) );
	
	while( 1 )
	{
		radio = PickRadioToSpawn();
		
		iprintln("HQ location revealed");
		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
		
		radioObject = radio.gameobject;
		level.radioObject = radioObject;
		
		nextObjPoint = maps\mp\gametypes\_objpoints::createTeamObjpoint( "objpoint_next_hq", radio.trigorigin + level.iconoffset, "all", "waypoint_targetneutral" );
		objective_position( locationObjID, radio.trigorigin );
		objective_icon( locationObjID, "compass_waypoint_captureneutral" );
		objective_state( locationObjID, "active" );
		
		timerDisplay["allies"].label = hqSpawningInStr;
		timerDisplay["allies"] setTimer( level.hqSpawnTime );
		timerDisplay["allies"].alpha = 1;
		timerDisplay["axis"  ].label = hqSpawningInStr;
		timerDisplay["axis"  ] setTimer( level.hqSpawnTime );
		timerDisplay["axis"  ].alpha = 1;
		
		wait level.hqSpawnTime;
		
		maps\mp\gametypes\_objpoints::deleteObjPoint( nextObjPoint );
		objective_state( locationObjID, "invisible" );

		timerDisplay["allies"].alpha = 0;
		timerDisplay["axis"  ].alpha = 0;
		
		waittillframeend;
		
		// TODO: localize
		iprintln("HQ may be captured!");
		updateObjectiveHintMessages( level.objectiveHintCaptureHQ, level.objectiveHintCaptureHQ );
		
		radioObject maps\mp\gametypes\_gameobjects::enableObject();
		
		radioObject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		radioObject maps\mp\gametypes\_gameobjects::setUseTime( 10.0 );
		radioObject maps\mp\gametypes\_gameobjects::setUseText( "Capturing Headquarters" ); // TODO: localize
		
		radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" );
		radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" );
		radioObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		radioObject maps\mp\gametypes\_gameobjects::setModelVisibility( true );
		
		radioObject.onUse = ::onRadioCapture;
		radioObject.onBeginUse = ::onBeginUse;
		radioObject.onEndUse = ::onEndUse;
		
		
		level waittill( "hq_captured" );
		
		ownerTeam = radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		otherTeam = getOtherTeam( ownerTeam );
		
		thread DestroyHQAfterTime( level.hqAutoDestroyTime );
		timerDisplay[ownerTeam] setTimer( level.hqAutoDestroyTime );
		timerDisplay[otherTeam] setTimer( level.hqAutoDestroyTime );
		
		while( 1 )
		{
			ownerTeam = radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
			otherTeam = getOtherTeam( ownerTeam );
	
			if ( ownerTeam == "allies" )
				updateObjectiveHintMessages( level.objectiveHintDefendHQ, level.objectiveHintDestroyHQ );
			else
				updateObjectiveHintMessages( level.objectiveHintDestroyHQ, level.objectiveHintDefendHQ );
	
			radioObject maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
			radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
			radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
			radioObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" );
			radioObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" );
			radioObject maps\mp\gametypes\_gameobjects::setUseText( "Destroying Headquarters" ); // TODO: localize
			
			radioObject.onUse = ::onRadioDestroy;
			
			timerDisplay[ownerTeam].label = hqDestroyedInFriendlyStr;
			timerDisplay[ownerTeam].alpha = 1;
			timerDisplay[otherTeam].label = hqDestroyedInEnemyStr;
			timerDisplay[otherTeam].alpha = 1;
	
			
			level waittill( "hq_destroyed" );
			
			if ( !level.kothmode || level.hqDestroyedByTimer )
				break;
			
			radioObject maps\mp\gametypes\_gameobjects::setOwnerTeam( getOtherTeam( ownerTeam ) );
		}
		
		level notify("hq_reset");
		
		radioObject maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
		radioObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		radioObject maps\mp\gametypes\_gameobjects::disableObject();
		radioObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		
		timerDisplay["allies"].alpha = 0;
		timerDisplay["axis"  ].alpha = 0;
		
		level.radioObject = undefined;
		
		wait .05;
		
		if ( !level.kothmode )
			forceSpawnTeam( ownerTeam );
		
		wait 5;
	}
}

forceSpawnTeam( team )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( player.pers["team"] == team )
			player notify("force_spawn");
	}
}

onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	if ( ownerTeam == "neutral" )
	{
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
	}
	else
	{
		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
	}
}

onEndUse( player, success )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( ownerTeam == "neutral" )
	{
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::stopFlashing();
	}
	else
	{
		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	}
}

onRadioCapture( player )
{
	team = player.pers["team"];
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	
	otherTeam = "axis";
	if ( team == "axis" )
		otherTeam = "allies";
	
	// TODO: localize
	thread printOnTeamArg( "Headquarters captured by &&1", team, player );
	thread printOnTeamArg( "Headquarters captured by &&1", otherTeam, player );
	thread playSoundOnPlayers( "mp_war_objective_taken", team );
	thread playSoundOnPlayers( "mp_war_objective_lost", otherTeam );
	
	level thread awardHQPoints( team );
	
	level notify( "hq_captured" );
}

onRadioDestroy( player )
{
	team = player.pers["team"];
	otherTeam = "axis";
	if ( team == "axis" )
		otherTeam = "allies";
	
	// TODO: localize
	if ( level.kothmode )
	{
		thread printOnTeamArg( "Headquarters captured by &&1", team, player );
		thread printOnTeamArg( "Headquarters captured by &&1", otherTeam, player );
	}
	else
	{
		thread printOnTeamArg( "Enemy headquarters destroyed by &&1", team, player );
		thread printOnTeamArg( "Headquarters destroyed by &&1", otherTeam, player );
	}
	thread playSoundOnPlayers( "mp_war_objective_taken", team );
	thread playSoundOnPlayers( "mp_war_objective_lost", otherTeam );
	
	level notify( "hq_destroyed" );
	
	if ( level.kothmode )
		level thread awardHQPoints( team );
}

DestroyHQAfterTime( time )
{
	level endon( "game_ended" );
	level endon( "hq_reset" );
	
	level.hqDestroyTime = gettime() + time * 1000;
	level.hqDestroyedByTimer = false;
	
	wait time;
	
	// TODO: localize
	if ( !level.kothmode )
		iprintln("Headquarters successfully defended!");
	
	level.hqDestroyedByTimer = true;
	level notify( "hq_destroyed" );
}

awardHQPoints( team )
{
	level endon( "game_ended" );
	level endon( "hq_destroyed" );
	
	level notify("awardHQPointsRunning");
	level endon("awardHQPointsRunning");
	
	seconds = 5;
	
	while ( !level.gameEnded )
	{
		[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + seconds );
		
		wait seconds;
	}
}

onSpawnPlayer()
{
	spawnpoint = undefined;
	
	if ( isdefined( level.radioObject ) )
	{
		hqOwningTeam = level.radioObject maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if ( self.pers["team"] == hqOwningTeam )
		{
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radioObject.nearSpawns );
		}
		else
		{
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, level.radioObject.farSpawns );
		}
	}
	
	if ( !isDefined( spawnpoint ) )
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
	
	assert( isDefined(spawnpoint) );
	
	self spawn( spawnpoint.origin, spawnpoint.angles );
}

SetupRadios()
{
	maperrors = [];

	radios = getentarray( "hq_hardpoint", "targetname" );
	
	if ( radios.size < 2 )
	{
		maperrors[maperrors.size] = "There are not at least 2 entities with targetname \"radio\"";
	}
	
	trigs = getentarray("radiotrigger", "targetname");
	for ( i = 0; i < radios.size; i++ )
	{
		errored = false;
		
		radio = radios[i];
		radio.trig = undefined;
		for ( j = 0; j < trigs.size; j++ )
		{
			if ( radio istouching( trigs[j] ) )
			{
				if ( isdefined( radio.trig ) )
				{
					maperrors[maperrors.size] = "Radio at " + radio.origin + " is touching more than one \"radiotrigger\" trigger";
					errored = true;
					break;
				}
				radio.trig = trigs[j];
				break;
			}
		}
		
		if ( !isdefined( radio.trig ) )
		{
			if ( !errored )
			{
				maperrors[maperrors.size] = "Radio at " + radio.origin + " is not inside any \"radiotrigger\" trigger";
				continue;
			}
			
			// possible fallback (has been tested)
			//radio.trig = spawn( "trigger_radius", radio.origin, 0, 128, 128 );
			//errored = false;
		}
		
		assert( !errored );
		
		radio.trigorigin = radio.trig.origin;
		
		visuals = [];
		visuals[0] = radio;
		
		// TODO: get these other script_models in a better way
		allScriptModels = getEntArray( "script_model", "classname" );
		for ( j = 0; j < allScriptModels.size; j++ )
		{
			if ( distanceSquared( allScriptModels[j].origin, radio.origin ) < 96*96 && allScriptModels[j] != radio )
				visuals[visuals.size] = allScriptModels[j];
		}
		allScriptBrushModels = getEntArray( "script_brushmodel", "classname" );
		for ( j = 0; j < allScriptBrushModels.size; j++ )
		{
			if ( distanceSquared( allScriptBrushModels[j].origin, radio.origin ) < 96*96 && allScriptBrushModels[j] != radio )
				visuals[visuals.size] = allScriptBrushModels[j];
		}
		
		radio.gameObject = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", radio.trig, visuals, level.iconoffset );
		radio.gameObject maps\mp\gametypes\_gameobjects::disableObject();
		radio.gameObject maps\mp\gametypes\_gameobjects::setModelVisibility( false );
		
		radio setUpNearbySpawns();
	}
	
	if (maperrors.size > 0)
	{
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error("Map errors. See above");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
	
	level.radios = radios;
	
	level.prevradio = undefined;
	level.prevradio2 = undefined;
	level.prevradio3 = undefined;
	
	return true;
}

setUpNearbySpawns()
{
	spawns = level.spawn_all;
	
	for ( i = 0; i < spawns.size; i++ )
	{
		spawns[i].distsq = distanceSquared( spawns[i].origin, self.origin );
	}
	
	// sort by distsq
	for ( i = 1; i < spawns.size; i++ )
	{
		thespawn = spawns[i];
		for ( j = i - 1; j >= 0 && thespawn.distsq < spawns[j].distsq; j-- )
			spawns[j + 1] = spawns[j];
		spawns[j + 1] = thespawn;
	}
	
	closest = [];
	farthest = [];
	
	third = spawns.size / 3;
	for ( i = 0; i <= third; i++ )
	{
		closest[ closest.size ] = spawns[i];
	}
	for ( ; i < spawns.size; i++ )
	{
		farthest[ farthest.size ] = spawns[i];
	}
	
	self.gameObject.nearSpawns = closest;
	self.gameObject.farSpawns = farthest;
}

PickRadioToSpawn()
{
	// find average of positions of each team
	// (medians would be better, to get rid of outliers...)
	// and find the radio which has the least difference in distance from those two averages
	
	avgpos["allies"] = (0,0,0);
	avgpos["axis"] = (0,0,0);
	num["allies"] = 0;
	num["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isalive( player ) )
		{
			avgpos[ player.pers["team"] ] += player.origin;
			num[ player.pers["team"] ]++;
		}
	}
	
	if ( num["allies"] == 0 || num["axis"] == 0 )
	{
		radio = level.radios[ randomint( level.radios.size) ];
		while ( isDefined( level.prevradio ) && radio == level.prevradio ) // so lazy
			radio = level.radios[ randomint( level.radios.size) ];
		
		level.prevradio3 = level.prevradio2;
		level.prevradio2 = level.prevradio;
		level.prevradio = radio;
		
		return radio;
	}
	
	avgpos["allies"] = avgpos["allies"] / num["allies"];
	avgpos["axis"  ] = avgpos["axis"  ] / num["axis"  ];
	
	bestradio = undefined;
	lowestcost = undefined;
	for ( i = 0; i < level.radios.size; i++ )
	{
		radio = level.radios[i];
		
		if ( isdefined( level.prevradio ) && radio == level.prevradio )
			continue;
		
		// (purposefully using distance instead of distanceSquared)
		cost = abs( distance( radio.origin, avgpos["allies"] ) - distance( radio.origin, avgpos["axis"] ) );
		
		if ( isdefined( level.prevradio2 ) && radio == level.prevradio2 )
			cost += 512;
		if ( isdefined( level.prevradio3 ) && radio == level.prevradio3 )
			cost += 256;
		
		if ( !isdefined( lowestcost ) || cost < lowestcost )
		{
			lowestcost = cost;
			bestradio = radio;
		}
	}
	assert( isdefined( bestradio ) );
	
	level.prevradio3 = level.prevradio2;
	level.prevradio2 = level.prevradio;
	level.prevradio = bestradio;
	
	return bestradio;
}

