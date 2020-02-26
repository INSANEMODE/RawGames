#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

main( gametype )
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	
	//maps\mp\gametypes\_globallogic::SetupCallbacks();
	GlobalLogic_SetupCallbacks_Zombies(gametype);
	
	menu_init();
	
	//registerRoundLimit( minValue, maxValue )
	registerRoundLimit( 1, 1 );
	
	//registerTimeLimit( minValue, maxValue )
	registerTimeLimit( 0, 0 );
	
	//registerScoreLimit( minValue, maxValue )
	registerScoreLimit( 0, 0 );
	
	//registerRoundWinLimit( minValue, maxValue )
	registerRoundWinLimit( 0, 0 );
	
	//registerNumLives( minValue, maxValue )
	registerNumLives( 1, 1 );


	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );


	level.takeLivesOnDeath = true;
	level.teamBased = true;
	level.disablePrematchMessages = true;	//NEW
	level.disableMomentum = true;			//NEW
	
	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	level.displayHalftimeText = false;
	level.displayRoundEndText = false;
	
	level.allowAnnouncer = false;
	//level.allowZmbAnnouncer = true;
	
	level.endGameOnScoreLimit = false;
	level.endGameOnTimeLimit = false;
	level.resetPlayerScoreEveryRound = true;
	
	level.doPrematch = false;
	level.noPersistence = true;
	level.scoreRoundBased = false;
	
	level.forceAutoAssign = true;
	level.dontShowEndReason = true;
	level.forceAllAllies = false;			//NEW
	
	//DISABLE TEAM SWAP
	level.allow_teamchange = false;
	SetDvar( "scr_disable_team_selection", 1 );
	makedvarserverinfo( "scr_disable_team_selection", 1 );
	
	//NO PREMATCH COUNTER
	SetDvar( "scr_game_prematchperiod", 5 );
	
	//USE ZOMBIE HUD - This sets the 'BIT_IS_ZOMBIE_GAME' which can be referenced in the .menu files
	setMatchFlag( "hud_zombie", 1 );
	
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_xpscale", 0 );
	
	level.onStartGameType = ::onStartGameType;
//	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayer = ::blank;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	//level.giveCustomLoadout = ::giveCustomLoadout;
	level.maySpawn = ::maySpawn;

	game["dialog"]["gametype"] = gametype + "_start";
	game["dialog"]["gametype_hardcore"] = gametype + "_start";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "downs", "revives", "headshots" ); 
}
  	
GlobalLogic_SetupCallbacks_Zombies( gametype )
{
	level.spawnPlayer = maps\mp\gametypes\_globallogic_spawn::spawnPlayer;
	level.spawnPlayerPrediction = maps\mp\gametypes\_globallogic_spawn::spawnPlayerPrediction;
	level.spawnClient = maps\mp\gametypes\_globallogic_spawn::spawnClient;
	level.spawnSpectator = maps\mp\gametypes\_globallogic_spawn::spawnSpectator;
	level.spawnIntermission = maps\mp\gametypes\_globallogic_spawn::spawnIntermission;
	level.onPlayerScore = ::blank;// = maps\mp\gametypes\_globallogic_score::default_onPlayerScore;
	level.onTeamScore = ::blank;// = maps\mp\gametypes\_globallogic_score::default_onTeamScore;
	
	level.waveSpawnTimer = ::waveSpawnTimer;
	
	level.onSpawnPlayer = ::blank;
	level.onSpawnPlayerUnified = ::blank;
	level.onSpawnSpectator = ::onSpawnSpectator;
	level.onSpawnIntermission = ::onSpawnIntermission;
	level.onRespawnDelay = ::blank;

	level.onForfeit = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_onForfeit;
	level.onTimeLimit = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_onTimeLimit;
	level.onScoreLimit = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_onScoreLimit;
	level.onDeadEvent = ::onDeadEvent; //maps\mp\gametypes\_globallogic_defaults::default_onDeadEvent;
	level.onOneLeftEvent = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_onOneLeftEvent;
	level.giveTeamScore = ::blank;// = maps\mp\gametypes\_globallogic_score::giveTeamScore;
	level.givePlayerScore = ::blank;

	level.getTimeLimit = maps\mp\gametypes\_globallogic_defaults::default_getTimeLimit;
	level.getTeamKillPenalty = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_getTeamKillPenalty;
	level.getTeamKillScore = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_getTeamKillScore;

	level.isKillBoosting = ::blank;// = maps\mp\gametypes\_globallogic_score::default_isKillBoosting;

	level._setTeamScore = maps\mp\gametypes\_globallogic_score::_setTeamScore;
	level._setPlayerScore = ::blank;// = maps\mp\gametypes\_globallogic_score::_setPlayerScore;

	level._getTeamScore = ::blank;// = maps\mp\gametypes\_globallogic_score::_getTeamScore;
	level._getPlayerScore = ::blank;// = maps\mp\gametypes\_globallogic_score::_getPlayerScore;
	
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;
	level.onPlayerKilledExtraUnthreadedCBs = []; ///< Array of other CB function pointers

	level.onTeamOutcomeNotify = ::blank;// = maps\mp\gametypes\_hud_message::teamOutcomeNotify;
	level.onOutcomeNotify = ::blank;// = maps\mp\gametypes\_hud_message::outcomeNotify;
	level.onTeamWagerOutcomeNotify = ::blank;// = maps\mp\gametypes\_hud_message::teamWagerOutcomeNotify;
	level.onWagerOutcomeNotify = ::blank;// = maps\mp\gametypes\_hud_message::wagerOutcomeNotify;
	level.onEndGame = ::onEndGame;
	level.onRoundEndGame = ::blank;// = maps\mp\gametypes\_globallogic_defaults::default_onRoundEndGame;
	level.onMedalAwarded = ::blank;

	//maps\mp\gametypes\_globallogic_ui::SetupCallbacks();
	level.autoassign = maps\mp\gametypes\_globallogic_ui::menuAutoAssign;
	level.spectator = maps\mp\gametypes\_globallogic_ui::menuSpectator;
	level.class = maps\mp\gametypes\_globallogic_ui::menuClass;
	level.allies = ::menuAlliesZombies;
	level.teamMenu = maps\mp\gametypes\_globallogic_ui::menuTeam;


//	level.callbackActorDamage = ::blank;
	level.callbackActorKilled = ::blank;
	level.callbackVehicleDamage = ::blank;
}

onPrecacheGameType()
{
	precacheShader("hud_zombies_meat");
}

onPlayerDisconnect()
{
	self waittill( "disconnect" ); 
	self maps\mp\zombies\_zm::checkForAllDead();
}

onDeadEvent( team )
{
	thread maps\mp\gametypes\_globallogic::endGame( "axis", "" );
}

onSpawnIntermission()
{
	spawnpointname = "info_intermission"; 
	spawnpoints = getentarray( spawnpointname, "classname" ); 
	
	// CODER_MOD: TommyK (8/5/08)
	if(spawnpoints.size < 1)
	{
	/#	println( "NO " + spawnpointname + " SPAWNPOINTS IN MAP" ); 	#/
		return;
	}	
	
	spawnpoint = spawnpoints[RandomInt(spawnpoints.size)];	
	if( isDefined( spawnpoint ) )
	{
		self spawn( spawnpoint.origin, spawnpoint.angles ); 
	}
}

onSpawnSpectator( origin, angles )
{
}


  	
maySpawn()
{
	if ( IsDefined(level.customMaySpawnLogic) )
		return self [[ level.customMaySpawnLogic ]]();

	if ( self.pers["lives"] == 0 )
	{
		level notify( "player_eliminated" );
		self notify( "player_eliminated" );
		return false;
	}
	return true;
}

onStartGameType()
{
	setClientNameMode("auto_change");

// 	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "allies", &"OBJECTIVES_ZSURVIVAL" );
// 	maps\mp\gametypes\_globallogic_ui::setObjectiveText( "axis", &"OBJECTIVES_ZSURVIVAL" );
// 	
// 	if ( level.splitscreen )
// 	{
// 		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_ZSURVIVAL" );
// 		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_ZSURVIVAL" );
// 	}
// 	else
// 	{
// 		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "allies", &"OBJECTIVES_ZSURVIVAL_SCORE" );
// 		maps\mp\gametypes\_globallogic_ui::setObjectiveScoreText( "axis", &"OBJECTIVES_ZSURVIVAL_SCORE" );
// 	}
// 	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "allies", &"OBJECTIVES_ZSURVIVAL_HINT" );
// 	maps\mp\gametypes\_globallogic_ui::setObjectiveHintText( "axis", &"OBJECTIVES_ZSURVIVAL_HINT" );
	
//	level.spawnMins = ( 0, 0, 0 );
//	level.spawnMaxs = ( 0, 0, 0 );
// 	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
// 	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
// 	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
// 	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
// 	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
// 
// 	level.spawn_axis_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_axis_start");
// 	level.spawn_allies_start= maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_allies_start");
//	
//	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
//	setMapCenter( level.mapCenter );
//
//	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
//	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	//allowed[0] = "zsurvival";
	
	level.displayRoundEndText = false;
	//maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();
	
	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}
}

onSpawnPlayerUnified()
{
	onSpawnPlayer(false);
}


// coop_player_spawn_placement()
// {
// 	structs = getstructarray( "initial_spawn_points", "targetname" ); 
// 
// 	temp_ent = Spawn( "script_model", (0,0,0) );
// 	for( i = 0; i < structs.size; i++ )
// 	{
// 		temp_ent.origin = structs[i].origin;
// 		temp_ent placeSpawnpoint();
// 		structs[i].origin = temp_ent.origin;
// 	}
// 	temp_ent Delete();
// 
// 	flag_wait( "start_zombie_round_logic" ); 
// 
// 	//chrisp - adding support for overriding the default spawning method
// 
// 	players = GET_PLAYERS(); 
// 
// 	for( i = 0; i < players.size; i++ )
// 	{
// 		players[i] setorigin( structs[i].origin ); 
// 		players[i] setplayerangles( structs[i].angles ); 
// 		players[i].spectator_respawn = structs[i];
// 	}
// }


onSpawnPlayer(predictedSpawn)
{
	if(!IsDefined(predictedSpawn))
	{
		predictedSpawn = false;
	}
	
	pixbeginevent("ZSURVIVAL:onSpawnPlayer");
	self.usingObj = undefined;
	
	self.is_zombie = false; 

	//For spectator respawn
	if( IsDefined( level.custom_spawnPlayer ) )
	{
		self [[level.custom_spawnPlayer]]();
		return;
	}


	if( isdefined(level.customSpawnLogic) )
	{
	/#	println( "ZM >> USE CUSTOM SPAWNING" );		#/
		self [[level.customSpawnLogic]](predictedSpawn);
		if (predictedSpawn)
			return;
	}
	else
	{
	/#	println( "ZM >> USE STANDARD SPAWNING" );	#/
		
		if(flag("begin_spawning"))
		{
			spawnPoint = maps\mp\zombies\_zm::check_for_valid_spawn_near_team( self, true );
		}	
		else
		{ 
			match_string = "";
		
			location = level.scr_zm_map_start_location;
			if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
			{
				location = level.default_start_location;
			}		
		
			match_string = level.scr_zm_ui_gametype + "_" + location;
		
			spawnPoints = [];
			structs = getstructarray("initial_spawn", "script_noteworthy");
			if(IsDefined(structs))
			{
				foreach(struct in structs)			
				{
					if(IsDefined(struct.script_string) )
					{
						
						tokens = strtok(struct.script_string," ");
						foreach(token in tokens)
						{
							if(token == match_string )
							{
								spawnPoints[spawnPoints.size] =	struct;
							}
						}
					}
					
				}			
			}
			
			if(!IsDefined(spawnPoints) || spawnPoints.size == 0) // old method, failed new method.
			{
				spawnPoints = getstructarray("initial_spawn_points", "targetname");
			}	
							
			assert(IsDefined(spawnPoints), "Could not find initial spawn points!");

			spawnPoint = maps\mp\zombies\_zm::getFreeSpawnpoint( spawnPoints, self );
		}
		
		if ( predictedSpawn )
		{
			self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
			return;
		}
		else if(flag("switchedsides"))
		{
			self setorigin(spawnPoint.origin);
			self setplayerangles (spawnPoint.angles);
			self notify( "spawned_player" ); 
			return;
		}
		else
		{
			self spawn( spawnPoint.origin, spawnPoint.angles, "zsurvival" );
		}
	}

	
	//Zombies player setup
	self.entity_num = self GetEntityNumber(); 
	self thread maps\mp\zombies\_zm::onPlayerSpawned(); 
//	self thread onPlayerDisconnect(); 
	self thread maps\mp\zombies\_zm::player_revive_monitor();
	self freezecontrols( true );
	self.spectator_respawn = spawnPoint;

	self.score = self  maps\mp\gametypes\_globallogic_score::getPersStat( "score" ); 
	//self.pers["lives"] = 1;

	self.pers["participation"] = 0;
	
		
/#
	if( GetDvarInt( "zombie_cheat" ) >= 1 )
	{
		self.score = 100000;
	}
#/


	self.score_total = self.score; 
	self.old_score = self.score; 

	self.initialized = false;
	self.zombification_time = 0;
	self.enableText = true;
	

//	self.pers["class"] = undefined;
//	self.class = undefined;
//	self.pers["weapon"] = undefined;
//	self.pers["savedmodel"] = undefined;


	// DCS 090910: now that player can destroy some barricades before set.
	self thread maps\mp\zombies\_zm_blockers::rebuild_barrier_reward_reset();

	self freeze_player_controls( false );
	self enableWeapons();
		
	pixendevent();
}
//---------------------------------------------------------------------------------------------------
// check if ent or struct valid for gametype use.
// DCS 051512
//---------------------------------------------------------------------------------------------------
get_player_spawns_for_gametype()
{
	match_string = "";

	location = level.scr_zm_map_start_location;
	if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
	{
		location = level.default_start_location;
	}		

	match_string = level.scr_zm_ui_gametype + "_" + location;

	player_spawns = [];
	structs = getstructarray("player_respawn_point", "targetname");
	foreach(struct in structs)
	{
		if(IsDefined(struct.script_string) )
		{
			tokens = strtok(struct.script_string," ");
			foreach(token in tokens)
			{
				if(token == match_string )
				{
					player_spawns[player_spawns.size] =	struct;
				}
			}
		}
		else // no gametype defining string, add to array for all locations.
		{
			player_spawns[player_spawns.size] =	struct;
		}		
	}
	return player_spawns;			
}

onEndGame( winningTeam )
{
	//Clean up this players crap
}

onRoundEndGame( roundWinner )
{
	if ( game["roundswon"]["allies"] == game["roundswon"]["axis"] )
		winner = "tie";
	else if ( game["roundswon"]["axis"] > game["roundswon"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	
	return winner;
}

// giveCustomLoadout( takeAllWeapons, alreadySpawned )
// {
// 	self TakeAllWeapons();
// 	self giveWeapon( "knife_zm" );
// 	self giveWeapon( "frag_grenade_zm" );
//	self give_start_weapon( true );
// }

menu_init()
{
	game["menu_team"] = "team_marinesopfor";
	game["menu_changeclass_allies"] = "changeclass";
	game["menu_initteam_allies"] = "initteam_marines";
	game["menu_changeclass_axis"] = "changeclass";
	game["menu_initteam_axis"] = "initteam_opfor";
	game["menu_class"] = "class";
	game["menu_changeclass"] = "changeclass";
	game["menu_changeclass_offline"] = "changeclass";
	game["menu_wager_side_bet"] = "sidebet";
	game["menu_wager_side_bet_player"] = "sidebet_player";
	game["menu_changeclass_wager"] = "changeclass_wager";
	game["menu_changeclass_custom"] = "changeclass_custom";
	game["menu_changeclass_barebones"] = "changeclass_barebones";

	game["menu_controls"] = "ingame_controls";
	game["menu_options"] = "ingame_options";
	game["menu_leavegame"] = "popup_leavegame";

	precacheMenu(game["menu_controls"]);
	precacheMenu(game["menu_options"]);
	precacheMenu(game["menu_leavegame"]);

	precacheMenu("scoreboard");
	precacheMenu(game["menu_team"]);
	precacheMenu(game["menu_changeclass_allies"]);
	precacheMenu(game["menu_initteam_allies"]);
	precacheMenu(game["menu_changeclass_axis"]);
	precacheMenu(game["menu_class"]);
	precacheMenu(game["menu_changeclass"]);
	precacheMenu(game["menu_initteam_axis"]);
	precacheMenu(game["menu_changeclass_offline"]);
	precacheMenu(game["menu_changeclass_wager"]);
	precacheMenu(game["menu_changeclass_custom"]);
	precacheMenu(game["menu_changeclass_barebones"]);
	precacheMenu(game["menu_wager_side_bet"]);
	precacheMenu(game["menu_wager_side_bet_player"]);
	precacheString( &"MP_HOST_ENDED_GAME" );
	precacheString( &"MP_HOST_ENDGAME_RESPONSE" );

	level thread menu_onPlayerConnect();
}

menu_onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);		
		player thread menu_onMenuResponse();
	}
}

menu_onMenuResponse()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("menuresponse", menu, response);
		
		//println( self getEntityNumber() + " menuresponse: " + menu + " " + response );
		
		//iprintln("^6", response);
			
		if ( response == "back" )
		{
			self closeMenu();
			self closeInGameMenu();

			if ( level.console )
			{
				if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_team"] || menu == game["menu_controls"] )
				{
//					assert(self.pers["team"] == "allies" || self.pers["team"] == "axis");
	
					if( self.pers["team"] == "allies" )
						self openMenu( game["menu_class"] );
					if( self.pers["team"] == "axis" )
						self openMenu( game["menu_class"] );
				}
			}
			continue;
		}
		
		if(response == "changeteam" && level.allow_teamchange == "1")
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu(game["menu_team"]);
		}
	
		if(response == "changeclass_marines" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_allies"] );
			continue;
		}

		if(response == "changeclass_opfor" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_axis"] );
			continue;
		}

		if(response == "changeclass_wager" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_wager"] );
			continue;
		}

		if(response == "changeclass_custom" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_custom"] );
			continue;
		}

		if(response == "changeclass_barebones" )
		{
			self closeMenu();
			self closeInGameMenu();
			self openMenu( game["menu_changeclass_barebones"] );
			continue;
		}

		if(response == "changeclass_marines_splitscreen" )
			self openMenu( "changeclass_marines_splitscreen" );

		if(response == "changeclass_opfor_splitscreen" )
			self openMenu( "changeclass_opfor_splitscreen" );
							
		if(response == "endgame")
		{
			// TODO: replace with onSomethingEvent call 
			if(level.splitscreen)
			{
				//if ( level.console )
				//	endparty();
				level.skipVote = true;

				if ( !level.gameEnded )
				{
					level thread maps\mp\gametypes\_globallogic::forceEnd();
				}
			}
				
			continue;
		}
		
		if(response == "killserverpc")
		{
			level thread maps\mp\gametypes\_globallogic::killserverPc();
				
			continue;
		}

		if ( response == "endround" )
		{
			if ( !level.gameEnded )
			{
				level.skipGameEnd = 1; // disable the intermission flyout
				level thread maps\mp\gametypes\_globallogic::forceEnd();
			}
			else
			{
				self closeMenu();
				self closeInGameMenu();
				self iprintln( &"MP_HOST_ENDGAME_RESPONSE" );
			}			
			continue;
		}

		if(menu == game["menu_team"] && level.allow_teamchange == "1")
		{
			switch(response)
			{
			case "allies":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.allies]]();
				break;

			case "axis":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.teamMenu]](response);
				break;

			case "autoassign":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.autoassign]]( true );
				break;

			case "spectator":
				//self closeMenu();
				//self closeInGameMenu();
				self [[level.spectator]]();
				break;
			}
		}	// the only responses remain are change class events
		else if( menu == game["menu_changeclass"] || menu == game["menu_changeclass_offline"] || menu == game["menu_changeclass_wager"] || menu == game["menu_changeclass_custom"] || menu == game["menu_changeclass_barebones"] )
		{
			self closeMenu();
			self closeInGameMenu();
			
			if(  level.rankedMatch && isSubstr(response, "custom") )
			{
				if ( self IsItemLocked( maps\mp\gametypes\_rank::GetItemIndex( "feature_cac" ) ) )
				kick( self getEntityNumber() );
			}

			self.selectedClass = true;
			self [[level.class]](response);
		}
	}
}

menuAlliesZombies()
{
	self maps\mp\gametypes\_globallogic_ui::closeMenus();
	
	if ( !level.console && level.allow_teamchange == "0" && (isdefined(self.hasDoneCombat) && self.hasDoneCombat) )
	{
			return;
	}
	
	if(self.pers["team"] != "allies")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;
			
		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "allies";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "allies";
		self.team = "allies";
		self.pers["class"] = undefined;
		self.class = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "allies";
		else
		{
			self.sessionteam = "none";
			self.ffateam = "allies";
		}

		self SetClientScriptMainMenu( game["menu_class"] );

		self notify("joined_team");
		level notify( "joined_team" );
		self notify("end_respawn");
	}
	
	//self beginClassChoice();
}

