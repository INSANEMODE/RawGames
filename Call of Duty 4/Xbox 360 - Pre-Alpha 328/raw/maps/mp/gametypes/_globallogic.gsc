#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	// hack to allow maps with no scripts to run correctly
	if ( !isDefined( level.tweakablesInitialized ) )
		maps\mp\gametypes\_tweakables::init();
	
	level.splitscreen = isSplitScreen();
	level.xenon = (getdvar("xenonGame") == "true");
	level.ps3 = (getdvar("ps3Game") == "true");
	level.onlineGame = getDvarInt( "onlinegame" );
	level.console = (level.xenon || level.ps3);
	
	level.rankedMatch = ( level.onlineGame && !getDvarInt( "xblive_privatematch" ) );
	/#
	if ( getdvarint( "scr_forcerankedmatch" ) == 1 )
		level.rankedMatch = true;
	#/

	level.script = toLower( getDvar( "mapname" ) );
	level.gametype = toLower( getDvar( "g_gametype" ) );

	level.otherTeam["allies"] = "axis";
	level.otherTeam["axis"] = "allies";
	
	level.teamBased = false;
	
	level.overrideTeamScore = false;
	level.overridePlayerScore = false;
	level.skipRoundEnd = false;
	level.displayHalftimeText = false;
	
	level.lastStatusTime = 0;
	level.wasWinning = "none";
	
	level.lastSlowProcessFrame = 0;
	
	level.placement["allies"] = [];
	level.placement["axis"] = [];
	level.placement["all"] = [];
	
	level.postRoundTime = 8.0;
	
	registerDvars();
	maps\mp\gametypes\_class::initPerkDvars();

	level.oldschool = (getdvarint( "scr_oldschool" ) == 1);
	
	precacheModel( "vehicle_mig29_desert" );
	precacheModel( "projectile_cbu97_clusterbomb" );
	precacheModel( "tag_origin" );	

	precacheShader( "faction_128_usmc" );
	precacheShader( "faction_128_arab" );
	precacheShader( "faction_128_ussr" );
	precacheShader( "faction_128_sas" );

	level.fx_airstrike_afterburner = loadfx ("fire/jet_afterburner");
	level.fx_airstrike_contrail = loadfx ("smoke/jet_contrail");
	
	// default value.
	setDvar( "scr_player_respawndelay", 0 );
}

registerDvars()
{
	if ( getdvar( "scr_oldschool" ) == "" )
		setdvar( "scr_oldschool", "0" );
		
	makeDvarServerInfo( "scr_oldschool" );
}

SetupCallbacks()
{
	level.spawnPlayer = ::spawnPlayer;
	level.spawnClient = ::spawnClient;
	level.spawnSpectator = ::spawnSpectator;
	level.spawnIntermission = ::spawnIntermission;
	level.updateTeamStatus = ::updateTeamStatus;
	level.onPlayerScore = ::default_onPlayerScore;
	level.onTeamScore = ::default_onTeamScore;
	
	level.onXPEvent = ::onXPEvent;
	level.waveSpawnTimer = ::waveSpawnTimer;
	
	level.onSpawnPlayer = ::blank;
	level.onSpawnSpectator = ::default_onSpawnSpectator;
	level.onSpawnIntermission = ::default_onSpawnIntermission;
	level.onRespawnDelay = ::blank;

	level.onForfeit = ::default_onForfeit;
	level.onTimeLimit = ::default_onTimeLimit;
	level.onScoreLimit = ::default_onScoreLimit;
	level.onDeadEvent = ::default_onDeadEvent;
	level.onOneLeftEvent = ::default_onOneLeftEvent;
	level.giveTeamScore = ::giveTeamScore;
	level.givePlayerScore = ::givePlayerScore;

	level._setTeamScore = ::_setTeamScore;
	level._setPlayerScore = ::_setPlayerScore;

	level._getTeamScore = ::_getTeamScore;
	level._getPlayerScore = ::_getPlayerScore;
	
	level.onPrecacheGametype = ::blank;
	level.onStartGameType = ::blank;
	level.onPlayerConnect = ::blank;
	level.onPlayerDisconnect = ::blank;
	level.onPlayerDamage = ::blank;
	level.onPlayerKilled = ::blank;

	level.autoassign = ::menuAutoAssign;
	level.spectator = ::menuSpectator;
	level.class = ::menuClass;
	level.allies = ::menuAllies;
	level.axis = ::menuAxis;
}


// to be used with things that are slow.
// unfortunately, it can only be used with things that aren't time critical.
WaitTillSlowProcessAllowed()
{
	while ( level.lastSlowProcessFrame == gettime() )
		wait .05;
	
	level.lastSlowProcessFrame = gettime();
}


blank( arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10 )
{
}

// when a team leaves completely, that team forfeited, team left wins round, ends game
default_onForfeit( team )
{
	level notify ( "forfeit in progress" ); //ends all other forfeit threads attempting to run
	level endon( "forfeit in progress" );	//end if another forfeit thread is running
	level endon( "abort forfeit" );			//end if the team is no longer in forfeit status
	
	if ( team == "allies" )
		announcement( "Allies have 10 seconds before forfeiting" );
	else if ( team == "axis" )
		announcement( "Opposition has 10 seconds before forfeiting" );
	else
		announcement( "Forfeiting in 10 seconds" );
	
	forfeit_delay = 10.0;						//forfeit wait, for switching teams and such
	wait forfeit_delay;
	
	endReason = &"MP_NULL";
	if ( team == "allies" )
	{
		announcement( &"MP_ALLIES_FORFEITED" );
		setDvar( "ui_text_endreason", &"MP_ALLIES_FORFEITED" );
		endReason = &"MP_ALLIES_FORFEITED";
		winner = "axis";
	}
	else if ( team == "axis" )
	{
		announcement( &"MP_OPFOR_FORFEITED" );
		setDvar( "ui_text_endreason", &"MP_OPFOR_FORFEITED" );
		endReason = &"MP_OPFOR_FORFEITED";
		winner = "allies";
	}
	else
	{
		//shouldn't get here
		assertEx( isdefined( team ), "Forfeited team is not defined" );
		assertEx( 0, "Forfeited team " + team + " is not allies or axis" );
		winner = "tie";
	}
	//exit game, last round, no matter if round limit reached or not
	level.forcedEnd = true;
	thread endGame( winner, endReason );
}


default_onDeadEvent( team )
{
	if ( team == "allies" )
	{
		announcement( &"MP_ALLIES_ELIMINATED" );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["allies_eliminated"] );
		setDvar( "ui_text_endreason", game["strings"]["allies_eliminated"] );

		thread endGame( "axis", game["strings"]["allies_eliminated"] );
	}
	else if ( team == "axis" )
	{
		announcement( &"MP_OPFOR_ELIMINATED" );
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["axis_eliminated"] );
		setDvar( "ui_text_endreason", game["strings"]["axis_eliminated"] );

		thread endGame( "allies", game["strings"]["axis_eliminated"] );
	}
	else
	{
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		setDvar( "ui_text_endreason", game["strings"]["tie"] );
		thread endGame( "tie", game["strings"]["tie"] );
	}
}


default_onOneLeftEvent( team )
{
	if ( !level.teamBased )
	{
		winner = getHighestScoringPlayer();
		endGame( winner, &"MP_ENEMIES_ELIMINATED" );
	}
	else
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			player = level.players[index];
			
			if ( !isAlive( player ) )
				continue;
				
			if ( !isDefined( player.pers["team"] ) || player.pers["team"] != team )
				continue;
				
			player maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "last_alive" );
		}
	}
}


default_onTimeLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
		winner = getHighestScoringPlayer();
	}
	
	iPrintLn( game["strings"]["time_limit_reached"] );
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["time_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["time_limit_reached"] );

	endGame( winner, game["strings"]["time_limit_reached"] );
}


forceEnd()
{
	if ( level.forcedEnd )
		return;

	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
		winner = getHighestScoringPlayer();
	}
	
	level.forcedEnd = true;
	makeDvarServerInfo( "ui_text_endreason", &"MP_HOST_ENDED_GAME" );
	setDvar( "ui_text_endreason", &"MP_HOST_ENDED_GAME" );
	endGame( winner, &"MP_HOST_ENDED_GAME" );
}


default_onScoreLimit()
{
	winner = undefined;
	
	if ( level.teamBased )
	{
		if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
			winner = "tie";
		else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
			winner = "axis";
		else
			winner = "allies";
	}
	else
	{
		winner = getHighestScoringPlayer();
	}
	
	iPrintLn( game["strings"]["score_limit_reached"] );
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	// this is not the right way to do this... was the end forced?  No.  So why set this to true?
	level.forcedEnd = true; // no more rounds if scorelimit is hit
	endGame( winner, game["strings"]["score_limit_reached"] );
}


updateGameEvents()
{
	if ( level.rankedMatch && !level.inGracePeriod )
	{
		// if allies disconnected, and axis still connected, axis wins round and game ends to lobby
		if ( level.everExisted["allies"] && level.playerCount["allies"] < 1 && level.playerCount["axis"] > 0 && game["state"] == "playing" )
		{
			//allies forfeited
			thread [[level.onForfeit]]( "allies" );
			return;
		}
		
		// if axis disconnected, and allies still connected, allies wins round and game ends to lobby
		if ( level.everExisted["axis"] && level.playerCount["axis"] < 1 && level.playerCount["allies"] > 0 && game["state"] == "playing" )
		{
			//axis forfeited
			thread [[level.onForfeit]]( "axis" );
			return;
		}

		if ( level.playerCount["axis"] > 0 && level.playerCount["allies"] > 0 )
			level notify( "abort forfeit" );
	}
	
	if ( !level.numLives )
		return;

	if ( level.teamBased )
	{
		// if both allies and axis were alive and now they are both dead in the same instance
		if ( level.everExisted["allies"] && !level.aliveCount["allies"] && level.everExisted["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}

		// if allies were alive and now they are not
		if ( level.everExisted["allies"] && !level.aliveCount["allies"] )
		{
			[[level.onDeadEvent]]( "allies" );
			return;
		}

		// if axis were alive and now they are not
		if ( level.everExisted["axis"] && !level.aliveCount["axis"] )
		{
			[[level.onDeadEvent]]( "axis" );
			return;
		}

		// one ally left
		if ( level.lastAliveCount["allies"] > 1 && level.aliveCount["allies"] == 1 )
		{
			[[level.onOneLeftEvent]]( "allies" );
			return;
		}

		// one axis left
		if ( level.lastAliveCount["axis"] > 1 && level.aliveCount["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "axis" );
			return;
		}
	}
	else
	{
		// everyone is dead
		if ( (level.everExisted["allies"] || level.everExisted["axis"]) && (!level.aliveCount["allies"] && !level.aliveCount["axis"]) )
		{
			[[level.onDeadEvent]]( "all" );
			return;
		}
		
		// last man standing
		if ( level.aliveCount["allies"] + level.aliveCount["axis"] == 1 )
		{
			[[level.onOneLeftEvent]]( "all" );
			return;
		}
	}
}


matchStartTimer()
{	
	visionSetNaked( "mpIntro", 0 );

	matchStartText = createServerFontString( "objective", 1.5 );
	matchStartText setPoint( "CENTER", "CENTER", 0, -40 );
	matchStartText.sort = 1001;
	matchStartText setText( &"MP_MATCH_STARTING_IN" );
	matchStartText.foreground = false;
	matchStartText.hidewheninmenu = true;

	matchStartTimer = createServerFontString( "objective", 2.2 );
	matchStartTimer setPoint( "CENTER", "CENTER", 0, 0 );
	matchStartTimer.sort = 1001;
	matchStartTimer.color = (1,1,0);
	matchStartTimer.foreground = false;
	matchStartTimer.hidewheninmenu = true;
	
	matchStartTimer maps\mp\gametypes\_hud::fontPulseInit();

	countTime = int( level.prematchPeriod );
	
	if ( countTime >= 2 )
	{
		while ( countTime > 0 && !level.gameEnded )
		{
			matchStartTimer setValue( countTime );
			matchStartTimer thread maps\mp\gametypes\_hud::fontPulse( level );
			if ( countTime == 2 )
				visionSetNaked( getDvar( "mapname" ), 3.0 );
			countTime--;
			wait ( 1.0 );
		}
	}
	else
	{
		visionSetNaked( getDvar( "mapname" ), 1.0 );
	}
	
	matchStartTimer destroyElem();
	matchStartText destroyElem();
}

matchStartTimerSkip()
{
	visionSetNaked( getDvar( "mapname" ), 0 );
}


spawnPlayer()
{
	prof_begin( "spawnPlayer_preUTS" );

	self endon("disconnect");
	self endon("joined_spectators");
	self notify("spawned");
	self notify("end_respawn");

	self setSpawnVariables();

	if ( level.teamBased )
		self.sessionteam = self.pers["team"];
	else
		self.sessionteam = "none";

	hadSpawned = self.hasSpawned;

	self.sessionstate = "playing";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.statusicon = "";
	if ( getDvarInt( "scr_csmode" ) > 0 )
		self.maxhealth = getDvarInt( "scr_csmode" );
	else
		self.maxhealth = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "maxhealth" );
	self.health = self.maxhealth;
	self.friendlydamage = undefined;
	self.hasSpawned = true;
	self.spawnTime = getTime();
	self.afk = false;
	self.pers["lives"]--;
	self.lastStand = undefined;
	
	if ( !self.wasAliveAtMatchStart )
		self.wasAliveAtMatchStart = level.inGracePeriod;
	
	//self clearPerks();

	self setClientDvar( "cg_thirdPerson", "0" );
	self setDepthOfField( 0, 0, 512, 512, 4, 0 );
	self setClientDvar( "cg_fov", "65" );
	
	[[level.onSpawnPlayer]]();
	
	self maps\mp\gametypes\_missions::playerSpawned();
	
	prof_end( "spawnPlayer_preUTS" );

	level thread [[level.updateTeamStatus]]();
	
	prof_begin( "spawnPlayer_postUTS" );
	
	if ( level.oldschool )
	{
		assert( !isDefined( self.pers["class"] ) );
		self maps\mp\gametypes\_oldschool::giveLoadout();
		self maps\mp\gametypes\_class::setClass( "oldschool" );
	}
	else
	{
		assert( isValidClass( self.pers["class"] ) );
		
		self maps\mp\gametypes\_class::setClass( self.pers["class"] );
		self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
	}
	
	if ( level.inPrematchPeriod )
	{
		self freezeControls( true );
//			self disableWeapons();
		
		self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );			

		team = self.pers["team"];
		thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team], game["music"]["spawn_" + team] );
		if ( isDefined( game["dialog"]["gametype"] ) )
		{
			self leaderDialogOnPlayer( "gametype" );
	
			/*
			if ( level.hardcoreMode )
				self leaderDialogOnPlayer( "hardcore" );
			else if ( level.oldSchool )
				self leaderDialogOnPlayer( "oldschool" );
			else
				self leaderDialogOnPlayer( "highspeed" );
			*/
		}
		thread maps\mp\gametypes\_hud::showClientScoreBar( 5.0 );
	}
	else
	{
		self freezeControls( false );
		self enableWeapons();
		if ( !hadSpawned && game["state"] == "playing" )
		{
			team = self.pers["team"];
			thread maps\mp\gametypes\_hud_message::oldNotifyMessage( game["strings"][team + "_name"], undefined, game["icons"][team], game["colors"][team], game["music"]["spawn_" + team] );
			if ( isDefined( game["dialog"]["gametype"] ) )
			{
				self leaderDialogOnPlayer( "gametype" );
				if ( team == game["attackers"] )
					self leaderDialogOnPlayer( "offense_obj", "introboost" );
				else
					self leaderDialogOnPlayer( "defense_obj", "introboost" );
				/*
				if ( level.hardcoreMode )
					self leaderDialogOnPlayer( "hardcore" );
				else if ( level.oldSchool )
					self leaderDialogOnPlayer( "oldschool" );
				else
					self leaderDialogOnPlayer( "highspeed" );
				*/
			}

//				thread maps\mp\gametypes\_hud_message::hintMessage( getObjectiveHintText( self.pers["team"] ) );
			self setClientDvar( "scr_objectiveText", getObjectiveHintText( self.pers["team"] ) );			
			thread maps\mp\gametypes\_hud::showClientScoreBar( 5.0 );
		}
	}

	if ( getdvar( "scr_showperksonspawn" ) == "" )
		setdvar( "scr_showperksonspawn", "1" );
		
	if ( !level.splitscreen && getdvarint( "scr_showperksonspawn" ) == 1 )
	{
		perks = getPerks( self );
		self showPerk( 0, perks[0], -50 );
		self showPerk( 1, perks[1], -50 );
		self showPerk( 2, perks[2], -50 );
		self thread hidePerksAfterTime( 3.0 );
		self thread hidePerksOnDeath();
	}
	
	prof_end( "spawnPlayer_postUTS" );
	
	waittillframeend;
	self notify( "spawned_player" );

	self thread maps\mp\gametypes\_hardpoints::hardpointItemWaiter();
	/#
	if ( getDvarInt( "scr_xprate" ) > 0 )
		self thread xpRateThread();
	#/
	
	//self thread testHPs();
	//self thread testShock();
	//self thread testMenu();
}

/#
xpRateThread()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	level endon ( "game_ended" );

	while ( level.inPrematchPeriod )
		wait ( 0.05 );

	for ( ;; )
	{
		wait ( 5.0 );
		if ( level.players[0].pers["team"] == "allies" || level.players[0].pers["team"] == "axis" )
			self maps\mp\gametypes\_rank::giveRankXP( "kill", int(min( getDvarInt( "scr_xprate" ), 50 )) );
	}
}
#/

hidePerksAfterTime( delay )
{
	self endon("disconnect");
	self endon("perks_hidden");
	
	wait delay;
	
	self thread hidePerk( 0, 2.0 );
	self thread hidePerk( 1, 2.0 );
	self thread hidePerk( 2, 2.0 );
	self notify("perks_hidden");
}

hidePerksOnDeath()
{
	self endon("disconnect");
	self endon("perks_hidden");

	self waittill("death");
	
	self hidePerk( 0 );
	self hidePerk( 1 );
	self hidePerk( 2 );
	self notify("perks_hidden");
}

hidePerksOnKill()
{
	self endon("disconnect");
	self endon("death");
	self endon("perks_hidden");

	self waittill( "killed_player" );
	
	self hidePerk( 0 );
	self hidePerk( 1 );
	self hidePerk( 2 );
	self notify("perks_hidden");
}


testMenu()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		wait ( 10.0 );
		
		notifyData = spawnStruct();
		notifyData.titleText = &"MP_CHALLENGE_COMPLETED";
		notifyData.notifyText = "wheee";
		notifyData.sound = "mp_challenge_complete";
	
		self thread maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	}
}

testShock()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	for ( ;; )
	{
		wait ( 3.0 );

		numShots = randomInt( 6 );
		
		for ( i = 0; i < numShots; i++ )
		{
			iPrintLnBold( numShots );
			self shellShock( "frag_grenade_mp", 0.2 );
			wait ( 0.1 );
		}
	}
}

testHPs()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	
	hps = [];
	hps[hps.size] = "radar_mp";
	hps[hps.size] = "airstrike_mp";
	hps[hps.size] = "helicopter_mp";

	for ( ;; )
	{
//		hp = hps[randomInt(hps.size)];
		hp = "radar_mp";
		if ( self thread maps\mp\gametypes\_hardpoints::giveHardpointItem( hp ) )
		{
			self thread maps\mp\gametypes\_hud_message::hintMessage( 3, level.hardpointHints[hp] );
			self playLocalSound( level.hardpointInforms[hp] );
		}

//		self thread maps\mp\gametypes\_hardpoints::upgradeHardpointItem();
		
		wait ( 20.0 );
	}
}


spawnSpectator( origin, angles )
{
	self notify("spawned");
	self notify("end_respawn");
	in_spawnSpectator( origin, angles );
}

// spawnSpectator clone without notifies for spawning between respawn delays
respawn_asSpectator( origin, angles )
{
	in_spawnSpectator( origin, angles );
}

// spawnSpectator helper
in_spawnSpectator( origin, angles )
{
	self setSpawnVariables();
	
	self.sessionstate = "spectator";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;

	if(self.pers["team"] == "spectator")
		self.statusicon = "";
	else
		self.statusicon = "hud_status_dead";

	maps\mp\gametypes\_spectating::setSpectatePermissions();

	[[level.onSpawnSpectator]]( origin, angles );
	
	if ( level.teamBased && !level.splitscreen )
	{
		self thread spectatorThirdPersonness();
	}
	
	level thread [[level.updateTeamStatus]]();
}

spectatorThirdPersonness()
{
	self endon("disconnect");
	self endon("spawned");
	
	self notify("spectator_thirdperson_thread");
	self endon("spectator_thirdperson_thread");
	
	self.spectatingThirdPerson = false;
	
	self setThirdPerson( true );
	
	// we can reenable this if we ever get a way to determine who a player is spectating.
	// self.spectatorClient is write-only so it doesn't work.
	/*
	player = getPlayerFromClientNum( self.spectatorClient );
	prevClientNum = self.spectatorClient;
	prevWeap = "none";
	hasScope = false;
	
	while(1)
	{
		if ( self.spectatorClient != prevClientNum )
		{
			player = getPlayerFromClientNum( self.spectatorClient );
			prevClientNum = self.specatorClient;
		}
		
		if ( isDefined( player ) )
		{
			weap = player getCurrentWeapon();
			if ( weap != prevWeap )
			{
				hasScope = maps\mp\gametypes\_weapons::hasScope( weap );
				prevWeap = weap;
			}
			if ( hasScope && player playerADS() == 1 )
				self setThirdPerson( false );
			else
				self setThirdPerson( true );
		}
		else
		{
			self setThirdPerson( false );
		}
		wait .05;
	}
	*/
}

getPlayerFromClientNum( clientNum )
{
	if ( clientNum < 0 )
		return undefined;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( level.players[i] getEntityNumber() == clientNum )
			return level.players[i];
	}
	return undefined;
}

setThirdPerson( value )
{
	if ( value != self.spectatingThirdPerson )
	{
		self.spectatingThirdPerson = value;
		if ( value )
		{
		self setClientDvar( "cg_thirdPerson", "1" );
		self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
		self setClientDvar( "cg_fov", "40" );
	}
		else
		{
			self setClientDvar( "cg_thirdPerson", "0" );
			self setDepthOfField( 0, 0, 512, 4000, 4, 0 );
			self setClientDvar( "cg_fov", "65" );
		}
	}
}

waveSpawnTimer()
{
	level endon( "game_ended" );

	while ( game["state"] == "playing" )
	{
		time = getTime();
		
		if ( time - level.lastWave["allies"] > (level.waveDelay["allies"] * 1000) )
		{
			level notify ( "wave_respawn_allies" );
			level.lastWave["allies"] = time;
		}

		if ( time - level.lastWave["axis"] > (level.waveDelay["axis"] * 1000) )
		{
			level notify ( "wave_respawn_axis" );
			level.lastWave["axis"] = time;
		}
		
		wait ( 0.05 );
	}
}


default_onSpawnSpectator( origin, angles)
{
	if( isDefined( origin ) && isDefined( angles ) )
	{
		self spawn(origin, angles);
		return;
	}
	
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
	assert( spawnpoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);

	self spawn(spawnpoint.origin, spawnpoint.angles);
}


spawnIntermission()
{
	self notify("spawned");
	self notify("end_respawn");
	
	self setSpawnVariables();
	
	self clearLowerMessage();
	
	self freezeControls( false );
	
	self setClientDvar( "cg_everyoneHearsEveryone", "1" );
	
	self.sessionstate = "intermission";
	self.spectatorclient = -1;
	self.archivetime = 0;
	self.psoffsettime = 0;
	self.friendlydamage = undefined;
	
	[[level.onSpawnIntermission]]();
	self setDepthOfField( 0, 128, 512, 4000, 6, 1.8 );
}


default_onSpawnIntermission()
{
	spawnpointname = "mp_global_intermission";
	spawnpoints = getentarray(spawnpointname, "classname");
//	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(spawnpoints);
	spawnpoint = spawnPoints[0];
	
	if( isDefined( spawnpoint ) )
		self spawn( spawnpoint.origin, spawnpoint.angles );
	else
		maps\mp\_utility::error("NO " + spawnpointname + " SPAWNPOINTS IN MAP");
}

// returns the best guess of the exact time until the scoreboard will be displayed and player control will be lost.
// returns undefined if time is not known
timeUntilRoundEnd()
{
	if ( level.gameEnded )
	{
		timePassed = (getTime() - level.gameEndTime) / 1000;
		timeRemaining = level.postRoundTime - timePassed;
		
		if ( timeRemaining < 0 )
			return 0;
		
		return timeRemaining;
	}
	
	if ( level.timeLimit <= 0 )
		return undefined;
	
	timePassed = (getTime() - level.startTime)/1000;
	timeRemaining = (level.timeLimit * 60) - timePassed;
	
	return timeRemaining + level.postRoundTime;
}

endGame( winner, endReasonText )
{
	// return if already ending via host quit or victory
	if ( game["state"] == "postgame" )
		return;

	visionSetNaked( "mpOutro", 2.0 );
	
	game["state"] = "postgame";
	level.gameEndTime = getTime();
	level.gameEnded = true;
	level.inGracePeriod = false;
	level notify ( "game_ended" );
	
	setGameEndTime( 0 ); // stop/hide the timers
	
	if ( level.console )
		setXenonRanks();

	updatePlacement();
	updateMatchBonusScores( winner );
	updateWinLossStats( winner );
	updateLeaderboards();
	
	// freeze players
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player clearLowerMessage();
		
		player closeMenu();
		player closeInGameMenu();
		
		player freezeControls( true );
		
		player setClientDvar( "cg_everyoneHearsEveryone", "1" );
	}
	
    // end round
    if ( level.roundLimit != 1 && !level.forcedEnd )
    {
        game["roundsplayed"]++;

		if ( !level.skipRoundEnd )
		{
			if ( level.displayHalftimeText )
			{
				notifyData = spawnStruct();
				notifyData.titleText = &"MP_HALFTIME";
				notifyData.notifyText = &"MP_SWITCHING_SIDES";
				
				for ( index = 0; index < players.size; index++ )
				{
					player = players[index];
					
					player maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
					player setClientDvar( "ui_hud_hardcore", 1 );
				}
			}
			else
			{
				for ( index = 0; index < players.size; index++ )
				{
					player = players[index];
					
					if ( level.teamBased )
						player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, endReasonText );
			
					player setClientDvar( "ui_hud_hardcore", 1 );
				}
			}

			roundEndWait( level.roundEndDelay );
			
            if ( !hitRoundLimit() )
            {
                game["state"] = "playing";    
                map_restart( true );
                return;
            }
        }
		
		updateTeamScores( "axis", "allies" );

		if ( getGameScore( "allies" ) == getGameScore( "axis" ) )
			winner = "tie";
		else if ( getGameScore( "allies" ) > getGameScore( "axis" ) )
			winner = "allies";
		else
			winner = "axis";
	}

	thread maps\mp\gametypes\_missions::roundEnd( winner );
		
	// catching gametype, since DM forceEnd sends winner as player entity, instead of string
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		if ( level.teamBased )
			player thread maps\mp\gametypes\_hud_message::teamOutcomeNotify( winner, endReasonText );
		else
			player thread maps\mp\gametypes\_hud_message::outcomeNotify( winner, endReasonText );

		player setClientDvar( "ui_hud_hardcore", 1 );
	}
	
	if ( level.teamBased )
	{
		thread announceGameWinner( winner, 4 );
		
		if ( winner == "allies" )
		{
			playSoundOnPlayers( game["music"]["victory_allies"], "allies" );
			playSoundOnPlayers( game["music"]["defeat"], "axis" );
		}
		else if ( winner == "axis" )
		{
			playSoundOnPlayers( game["music"]["victory_axis"], "axis" );
			playSoundOnPlayers( game["music"]["defeat"], "allies" );
		}
		else
		{
			playSoundOnPlayers( game["music"]["defeat"] );
		}
	}
	
	roundEndWait( level.postRoundTime );
	
	//regain players array since some might've disconnected during the wait above
	players = level.players;
	for ( index = 0; index < players.size; index++ )
	{
		player = players[index];
		
		player closeMenu();
		player closeInGameMenu();
		player notify ( "reset_outcome" );
		player thread spawnIntermission();
		player setClientDvar( "ui_hud_hardcore", 0 );
	}
	
	/*
	spawnpoints = getentarray("mp_global_intermission", "classname");
	spawnpoint = spawnPoints[0];
	coord = spawnPoint.origin + vector_scale( anglesToForward( (0,spawnPoint.angles[1],0) ), 2500 );
	thread maps\mp\gametypes\_hardpoints::planeFlyOver( coord );
	*/
	
	wait 5.0; //scoreboard time
	exitLevel( false );
}


roundEndWait( defaultDelay )
{
	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}

    wait ( defaultDelay / 2 );
	level notify ( "give_match_bonus" );
	wait ( 0.05 );

	players = level.players;
	for ( index = 0; index < players.size; index++ )
		players[index].doingOutcome = undefined;

	wait ( defaultDelay / 2 );

	notifiesDone = false;
	while ( !notifiesDone )
	{
		players = level.players;
		notifiesDone = true;
		for ( index = 0; index < players.size; index++ )
		{
			if ( !isDefined( players[index].doingNotify ) || !players[index].doingNotify )
				continue;
				
			notifiesDone = false;
		}
		wait ( 0.5 );
	}
}


updateMatchBonusScores( winner )
{
	if ( !game["timepassed"] )
		return;

	if ( !level.rankedMatch )
		return;

	if ( !level.timeLimit || level.forcedEnd )
		gameLength = getTimePassed() / 1000;
	else
		gameLength = level.timeLimit * 60;


	if ( level.teamBased )
	{
		if ( winner == "allies" )
		{
			winningTeam = "allies";
			losingTeam = "axis";
		}
		else if ( winner == "axis" )
		{
			winningTeam = "axis";
			losingTeam = "allies";
		}
		else
		{
			winningTeam = "tie";
			losingTeam = "tie";
		}

		if ( winningTeam != "tie" )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}

			spm = player maps\mp\gametypes\_rank::getSPM();				
			if ( winningTeam == "tie" )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "tie", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined( player.pers["team"] ) && player.pers["team"] == winningTeam )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else if ( isDefined(player.pers["team"] ) && player.pers["team"] == losingTeam )
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
	else
	{
		if ( isDefined( winner ) )
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "win" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "loss" );
		}
		else
		{
			winnerScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
			loserScale = maps\mp\gametypes\_rank::getScoreInfoValue( "tie" );
		}
		
		players = level.players;
		for( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( player.timePlayed["total"] < 1 || player.pers["participation"] < 1 )
			{
				player thread maps\mp\gametypes\_rank::endGameUpdate();
				continue;
			}
			
			spm = player maps\mp\gametypes\_rank::getSPM();

			isWinner = false;
			for ( pIdx = 0; pIdx < min( level.placement["all"][0].size, 3 ); pIdx++ )
			{
				if ( level.placement["all"][pIdx] != player )
					continue;
				isWinner = true;				
			}
			
			if ( isWinner )
			{
				playerScore = int( (winnerScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "win", playerScore );
				player.matchBonus = playerScore;
			}
			else
			{
				playerScore = int( (loserScale * ((gameLength/60) * spm)) * (player.timePlayed["total"] / gameLength) );
				player thread giveMatchBonus( "loss", playerScore );
				player.matchBonus = playerScore;
			}
		}
	}
}


giveMatchBonus( scoreType, score )
{
	self endon ( "disconnect" );

	level waittill ( "give_match_bonus" );
	
	self maps\mp\gametypes\_rank::giveRankXP( scoreType, score );
	self maps\mp\gametypes\_rank::endGameUpdate();
}


setXenonRanks()
{
	players = level.players;
	highscore = undefined;

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if(!isdefined(player.score))
			continue;

		if(!isdefined(highscore) || player.score > highscore)
			highscore = player.score;
	}

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if(!isdefined(player.score))
			continue;

		if(highscore <= 0)
		{
			rank = 0;
		}
		else
		{
			rank = int(player.score * 10 / highscore);
			if(rank < 0)
				rank = 0;
		}

		if( player.pers["team"] == "allies" )
			setPlayerTeamRank(player, 0, rank);
		else if( player.pers["team"] == "axis" )
			setPlayerTeamRank(player, 1, rank);
		else if( player.pers["team"] == "spectator" )
			setPlayerTeamRank(player, 2, rank);
	}
	sendranks();
}


getHighestScoringPlayer()
{
	players = level.players;
	winner = undefined;
	tie = false;
	
	for( i = 0; i < players.size; i++ )
	{
		if ( !isDefined( players[i].score ) )
			continue;
			
		if ( players[i].score < 1 )
			continue;
			
		if ( !isDefined( winner ) || players[i].score > winner.score )
		{
			winner = players[i];
			tie = false;
		}
		else if ( players[i].score == winner.score )
		{
			tie = true;
		}
	}
	
	if ( tie || !isDefined( winner ) )
		return undefined;
	else
		return winner;
}


checkTimeLimit()
{
	if ( isDefined( level.timeLimitOverride ) && level.timeLimitOverride )
		return;
	
	if ( game["state"] != "playing" )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.timeLimit <= 0 )
	{
		setGameEndTime( 0 );
		return;
	}
		
	if ( level.inPrematchPeriod )
	{
		setGameEndTime( 0 );
		return;
	}
	
	if ( !isdefined( level.startTime ) )
		return;
	
	
	timePassed = getTimePassed();
	
	timeLeft = level.timeLimit * 60 * 1000 - timePassed;
	
	// want this accurate to the millisecond
	setGameEndTime( getTime() + int(timeLeft) );
	
	
	if ( timePassed < (level.timeLimit * 60 * 1000) )
		return;
	
	[[level.onTimeLimit]]();
}


checkScoreLimit()
{
	if ( game["state"] != "playing" )
		return;

	if( level.scoreLimit <= 0 )
		return;

	if ( level.teamBased )
	{
		if( game["teamScores"]["allies"] < level.scoreLimit && game["teamScores"]["axis"] < level.scoreLimit )
			return;
	}
	else
	{
		if ( !isPlayer( self ) )
			return;

		if ( self.score < level.scoreLimit )
			return;
	}

	[[level.onScoreLimit]]();
}


hitRoundLimit()
{
	if( level.roundLimit <= 0 )
		return ( false );

	return ( game["roundsplayed"] >= level.roundLimit );
}

registerRoundSwitchDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundswitch");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundswitchDvar = dvarString;
	level.roundswitchMin = minValue;
	level.roundswitchMax = maxValue;
	level.roundswitch = getDvarInt( level.roundswitchDvar );
}

registerRoundLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_roundlimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	
	level.roundLimitDvar = dvarString;
	level.roundlimitMin = minValue;
	level.roundlimitMax = maxValue;
	level.roundLimit = getDvarInt( level.roundLimitDvar );
}


registerScoreLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_scorelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.scoreLimitDvar = dvarString;	
	level.scorelimitMin = minValue;
	level.scorelimitMax = maxValue;
	level.scoreLimit = getDvarInt( level.scoreLimitDvar );
	
	setDvar( "ui_scorelimit", level.scoreLimit );
}


registerTimeLimitDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_timelimit");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarFloat( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarFloat( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.timeLimitDvar = dvarString;	
	level.timelimitMin = minValue;
	level.timelimitMax = maxValue;
	level.timelimit = getDvarFloat( level.timeLimitDvar );
	
	setDvar( "ui_timelimit", level.timelimit );
}


registerNumLivesDvar( dvarString, defaultValue, minValue, maxValue )
{
	dvarString = ("scr_" + dvarString + "_numlives");
	if ( getDvar( dvarString ) == "" )
		setDvar( dvarString, defaultValue );
		
	if ( getDvarInt( dvarString ) > maxValue )
		setDvar( dvarString, maxValue );
	else if ( getDvarInt( dvarString ) < minValue )
		setDvar( dvarString, minValue );
		
	level.numLivesDvar = dvarString;	
	level.numLivesMin = minValue;
	level.numLivesMax = maxValue;
	level.numLives = getDvarInt( level.numLivesDvar );
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "numlives" ) )
		level.numLives = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "numlives" );
}


getValueInRange( value, minValue, maxValue )
{
	if ( value > maxValue )
		return maxValue;
	else if ( value < minValue )
		return minValue;
	else
		return value;
}

updateGameTypeDvars()
{
	level endon ( "game_ended" );
	
	while ( game["state"] == "playing" )
	{
		roundlimit = getValueInRange( getDvarInt( level.roundLimitDvar ), level.roundLimitMin, level.roundLimitMax );
		if ( roundlimit != level.roundlimit )
		{
			level.roundlimit = roundlimit;
			level notify ( "update_roundlimit" );
		}

		timeLimit = getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
		if ( timeLimit != level.timeLimit )
		{
			level.timeLimit = timeLimit;
			setDvar( "ui_timelimit", level.timeLimit );
			level notify ( "update_timelimit" );
		}
		thread checkTimeLimit();

		scoreLimit = getValueInRange( getDvarInt( level.scoreLimitDvar ), level.scoreLimitMin, level.scoreLimitMax );
		if ( scoreLimit != level.scoreLimit )
		{
			level.scoreLimit = scoreLimit;
			setDvar( "ui_scorelimit", level.scoreLimit );
			level notify ( "update_scorelimit" );
		}
		thread checkScoreLimit();
		
		// make sure we check time limit right when game ends
		if ( isdefined( level.startTime ) )
		{
			timeLeft = level.timeLimit * 60 - getTimePassed() / 1000;
			if ( timeLeft < 3.0 )
			{
				wait .1;
				continue;
			}
		}
		wait 1;
	}
}


menuAutoAssign()
{
	teams[0] = "allies";
	teams[1] = "axis";
	assignment = teams[randomInt(2)];
	
	self closeMenus();

	if ( level.teamBased )
	{
		if ( getDvarInt( "party_autoteams" ) == 1 )
		{
			teamNum = getAssignedTeam( self );
			switch ( teamNum )
			{			
				case 1:
					assignment = teams[1];
					break;
					
				case 2:
					assignment = teams[0];
					break;
					
				default:
					assignment = "";
			}
		}
		
		if ( assignment == "" || getDvarInt( "party_autoteams" ) == 0 )
		{	
			playerCounts = maps\mp\gametypes\_teams::CountPlayers();
		
			// if teams are equal return the team with the lowest score
			if ( playerCounts["allies"] == playerCounts["axis"] )
			{
				if( getTeamScore( "allies" ) == getTeamScore( "axis" ) )
					assignment = teams[randomInt(2)];
				else if ( getTeamScore( "allies" ) < getTeamScore( "axis" ) )
					assignment = "allies";
				else
					assignment = "axis";
			}
			else if( playerCounts["allies"] < playerCounts["axis"] )
			{
				assignment = "allies";
			}
			else
			{
				assignment = "axis";
			}
		}
		
		if ( assignment == self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
		{
			self beginClassChoice();
			return;
		}
	}

	if ( assignment != self.pers["team"] && (self.sessionstate == "playing" || self.sessionstate == "dead") )
	{
		self.switching_teams = true;
		self.joining_team = assignment;
		self.leaving_team = self.pers["team"];
		self suicide();
	}

	self.pers["team"] = assignment;
	self.pers["class"] = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
		self.sessionteam = "none";
	
	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";
	
	self notify("joined_team");
	self notify("end_respawn");
	
	self beginClassChoice();
	
	self setclientdvar( "g_scriptMainMenu", game[ "menu_class_" + self.pers["team"] ] );
}


updateObjectiveText()
{
	if ( self.pers["team"] == "spectator" )
	{
		self setClientDvar( "cg_objectiveText", "" );
		return;
	}

	if( level.scorelimit > 0 )
	{
		if ( level.splitScreen )
			self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ) );
		else
			self setclientdvar( "cg_objectiveText", getObjectiveScoreText( self.pers["team"] ), level.scorelimit );
	}
	else
	{
		self setclientdvar( "cg_objectiveText", getObjectiveText( self.pers["team"] ) );
	}
}

closeMenus()
{
	self closeMenu();
	self closeInGameMenu();
}

beginClassChoice( forceNewChoice )
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	if ( level.oldschool )
	{
		// skip class choice and just spawn.
		
		self.pers["class"] = undefined;

		if ( self.sessionstate != "playing" && game["state"] == "playing" )
			self thread [[level.spawnClient]]();
		level thread [[level.updateTeamStatus]]();
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
		
		return;
	}
	
	self setclientdvar("ui_allow_classchange", "1");
	
	team = self.pers["team"];
	
	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	self openMenu( game[ "menu_changeclass_" + team ] );
	
	//if ( level.rankedMatch )
	//	self openMenu( game[ "menu_changeclass_" + team ] );
	//else
	//	self openMenu( game[ "menu_class_" + team ] );
}

showMainMenuForTeam()
{
	assert( self.pers["team"] == "axis" || self.pers["team"] == "allies" );
	
	team = self.pers["team"];
	
	// menu_changeclass_team is the one where you choose one of the n classes to play as.
	// menu_class_team is where you can choose to change your team, class, controls, or leave game.
	
	self openMenu( game[ "menu_class_" + team ] );
}

menuAllies()
{
	self closeMenus();
	
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
		self.pers["class"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "allies";
		else
			self.sessionteam = "none";

		self setclientdvar("ui_allow_classchange", "1");
		self setclientdvar("g_scriptMainMenu", game["menu_class_allies"]);

		self notify("joined_team");
		self notify("end_respawn");
	}
	
	self beginClassChoice();
}


menuAxis()
{
	self closeMenus();
	
	if(self.pers["team"] != "axis")
	{
		// allow respawn when switching teams during grace period.
		if ( level.inGracePeriod && (!isdefined(self.hasDoneCombat) || !self.hasDoneCombat) )
			self.hasSpawned = false;

		if(self.sessionstate == "playing")
		{
			self.switching_teams = true;
			self.joining_team = "axis";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "axis";
		self.pers["class"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		if ( level.teamBased )
			self.sessionteam = "axis";
		else
			self.sessionteam = "none";

		self setclientdvar("ui_allow_classchange", "1");
		self setclientdvar("g_scriptMainMenu", game["menu_class_axis"]);

		self notify("joined_team");
		self notify("end_respawn");
	}
	
	self beginClassChoice();
}


menuSpectator()
{
	self closeMenus();
	
	if(self.pers["team"] != "spectator")
	{
		if(isAlive(self))
		{
			self.switching_teams = true;
			self.joining_team = "spectator";
			self.leaving_team = self.pers["team"];
			self suicide();
		}

		self.pers["team"] = "spectator";
		self.pers["class"] = undefined;
		self.pers["weapon"] = undefined;
		self.pers["savedmodel"] = undefined;

		self updateObjectiveText();

		self.sessionteam = "spectator";
		self setclientdvar("ui_allow_classchange", "0");
		[[level.spawnSpectator]]();

		self setclientdvar("g_scriptMainMenu", game["menu_team"]);

		self notify("joined_spectators");
	}
}


menuClass( response )
{
	self closeMenus();
	
	if ( game["state"] == "postgame" )
		return;
	
	// clears new status of unlocked classes
	if ( response == "custom4,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) ) ) != 1 )
		self setstat( int( tablelookup( "mp/statstable.csv", 4, "feature_demolitions", 1 ) ), 1 );
	if ( response == "custom5,0" && self getstat( int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) ) ) != 1 )
		self setstat( int( tablelookup( "mp/statstable.csv", 4, "feature_sniper", 1 ) ), 1 );
	
	assert( !level.oldschool );
	
	// this should probably be an assert
	if(!isDefined(self.pers["team"]) || (self.pers["team"] != "allies" && self.pers["team"] != "axis"))
		return;

	class = self maps\mp\gametypes\_class::getClassChoice( response );
	primary = self maps\mp\gametypes\_class::getWeaponChoice( response );

	if ( class == "restricted" )
	{
		self beginClassChoice();
		return;
	}

	if( (isDefined( self.pers["class"] ) && self.pers["class"] == class) && 
		(isDefined( self.pers["primary"] ) && self.pers["primary"] == primary) )
		return;

	if ( self.sessionstate == "playing" )
	{
		self.pers["class"] = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( level.inGracePeriod && !self.hasDoneCombat ) // used weapons check?
		{
			self maps\mp\gametypes\_class::setClass( self.pers["class"] );
			self.tag_stowed_back = undefined;
			self.tag_stowed_hip = undefined;
			self maps\mp\gametypes\_class::giveLoadout( self.pers["team"], self.pers["class"] );
		}
	}
	else
	{
//		if ( !isValidClass( self.pers["class"] ) )
//			self thread maps\mp\_utility::printJoinedTeam(self.pers["team"]);
			
		self.pers["class"] = class;
		self.pers["primary"] = primary;
		self.pers["weapon"] = undefined;

		if ( game["state"] == "playing" )
			self thread [[level.spawnClient]]();
	}

	level thread [[level.updateTeamStatus]]();

	self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
}


playerIsAhead( playerA, playerB )
{
	// must match code's rank calculations.
	// see SortRanks in g_main_mp.cpp.
	if ( playerA.pers["score"] > playerB.pers["score"] )
	{
		return true;
	}
	else if ( playerA.pers["score"] == playerB.pers["score"] )
	{
		if ( playerA.pers["deaths"] < playerB.pers["deaths"] )
			return true;
	}
	
	return false;
}

updatePlacement()
{
	level.placement["all"] = [];
	level.placement["allies"] = [];
	level.placement["axis"] = [];

	if ( !level.players.size )
		return;
	
	placementAll = level.players;
	
	for ( i = 1; i < placementAll.size; i++ )
	{
		player = placementAll[i];
		for ( j = i - 1; j >= 0 && playerIsAhead( player, placementAll[j] ); j-- )
			placementAll[j + 1] = placementAll[j];
		placementAll[j + 1] = player;
	}
	
	if ( level.teamBased )
	{
		for( i = 0; i < placementAll.size; i++ )
		{
			team = placementAll[i].pers["team"];
			if ( !isDefined( level.placement[team] ) )
				continue;
			
			level.placement[team][level.placement[team].size] = placementAll[i];
		}
	}
	
	level.placement["all"] = placementAll;
}


onXPEvent( event )
{
	self maps\mp\gametypes\_rank::giveRankXP( event );
}


givePlayerScore( event, player, victim )
{
	if ( level.overridePlayerScore )
		return;

	score = player.pers["score"];
	[[level.onPlayerScore]]( event, player, victim );
	
	if ( score == player.pers["score"] )
		return;
	
	player.score = player.pers["score"];
	
	thread sendUpdatedScores();
	
	updatePlacement();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


default_onPlayerScore( event, player, victim )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );
	
	assert( isDefined( score ) );
	/*
	if ( event == "assist" )
		player.pers["score"] += 2;
	else
		player.pers["score"] += 10;
	*/
	
	player.pers["score"] += score;
}


_setPlayerScore( player, score )
{
	if ( score == player.pers["score"] )
		return;

	player.pers["score"] = score;
	player.score = player.pers["score"];

	updatePlacement();
	player notify ( "update_playerscore_hud" );
	player thread checkScoreLimit();
}


_getPlayerScore( player )
{
	return player.pers["score"];
}


giveTeamScore( event, team, player, victim )
{
	if ( level.overrideTeamScore )
		return;
		
	teamScore = game["teamScores"][team];
	[[level.onTeamScore]]( event, team, player, victim );
	
	if ( teamScore == game["teamScores"][team] )
		return;
	
	updateTeamScores( team );

	thread checkScoreLimit();
}

_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	updateTeamScores( team );
	
	thread checkScoreLimit();
}

updateTeamScores( team1, team2 )
{
	setTeamScore( team1, getGameScore( team1 ) );
	if ( isdefined( team2 ) )
		setTeamScore( team2, getGameScore( team2 ) );
	
	thread sendUpdatedScores();
}


_getTeamScore( team )
{
	return game["teamScores"][team];
}


default_onTeamScore( event, team, player, victim )
{
	score = maps\mp\gametypes\_rank::getScoreInfoValue( event );
	
	assert( isDefined( score ) );
	
	otherTeam = level.otherTeam[team];
	
	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		level.wasWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		level.wasWinning = otherTeam;
		
	game["teamScores"][team] += score;

	isWinning = "none";
	if ( game["teamScores"][team] > game["teamScores"][otherTeam] )
		isWinning = team;
	else if ( game["teamScores"][otherTeam] > game["teamScores"][team] )
		isWinning = otherTeam;

	if ( !level.splitScreen && isWinning != "none" && isWinning != level.wasWinning && getTime() - level.lastStatusTime  > 5000 )
	{
		level.lastStatusTime = getTime();
		leaderDialog( "lead_taken", isWinning, "status" );
		if ( level.wasWinning != "none")
			leaderDialog( "lead_lost", level.wasWinning, "status" );		
	}

	if ( isWinning != "none" )
		level.wasWinning = isWinning;
}


sendUpdatedScores()
{
	level notify("updating_scores");
	level endon("updating_scores");
	wait .05;
	
	WaitTillSlowProcessAllowed();

	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] updateScores();
	}
}

initPersStat( dataName )
{
	if( !isDefined( self.pers[dataName] ) )
		self.pers[dataName] = 0;
}


getPersStat( dataName )
{
	return self.pers[dataName];
}


incPersStat( dataName, increment )
{
	self.pers[dataName] += increment;
	self maps\mp\gametypes\_persistence::statAdd( dataName, increment );
}


updatePersRatio( ratio, num, denom )
{
	numValue = self maps\mp\gametypes\_persistence::statGet( num );
	denomValue = self maps\mp\gametypes\_persistence::statGet( denom );
	if ( denomValue == 0 )
		denomValue = 1;
		
	self maps\mp\gametypes\_persistence::statSet( ratio, int( (numValue * 1000) / denomValue ) );		
}


updateTeamStatus()
{
	// run only once per frame, at the end of the frame.
	level notify("updating_team_status");
	level endon("updating_team_status");
	level endon ( "game_ended" );
	waittillframeend;
	
	wait 0;	// Required for Callback_PlayerDisconnect to complete before updateTeamStatus can execute

	if ( game["state"] == "postgame" )
		return;

	resetTimeout();
	
	prof_begin( "updateTeamStatus" );
	
	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	
	level.lastAliveCount["allies"] = level.aliveCount["allies"];
	level.lastAliveCount["axis"] = level.aliveCount["axis"];
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		
		if ( level.splitscreen && !isDefined( player ) )
			continue;
		
		team = player.pers["team"];
		class = player.pers["class"];
		
		if ( isDefined( team ) && team != "spectator" && isValidClass( class ) )
		{
			level.playerCount[team]++;
			
			if ( player.sessionstate == "playing" )
				level.aliveCount[team]++;
		}
	}
	
	if ( level.aliveCount["allies"] )
		level.everExisted["allies"] = true;
	if ( level.aliveCount["axis"] )
		level.everExisted["axis"] = true;
	
	prof_end( "updateTeamStatus" );
	
	level updateGameEvents();
}

isValidClass( class )
{
	if ( level.oldschool )
	{
		assert( !isdefined( class ) );
		return true;
	}
	return isdefined( class ) && class != "";
}

playTickingSound()
{
	self endon("death");
	self endon("stop_ticking");
	
	while(1)
	{
		self playSound( "ui_mp_timer_countdown" );
		wait 1.0;
	}
}

stopTickingSound()
{
	self notify("stop_ticking");
}

timeLimitClock()
{
	level endon ( "game_ended" );
	
	wait .05;
	
	clockObject = spawn( "script_origin", (0,0,0) );
	
	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped && level.timeLimit )
		{
			timeLeft = (level.timeLimit * 60) - getTimePassed() / 1000;
			timeLeftInt = int(timeLeft + 0.5); // adding .5 and flooring rounds it.
			
			if ( timeLeftInt >= 30 && timeLeftInt <= 60 )
				level notify ( "match_ending_soon" );
				
			if ( timeLeftInt <= 10 || (timeLeftInt <= 30 && timeLeftInt % 2 == 0) )
			{
				level notify ( "match_ending_very_soon" );
				// don't play a tick at exactly 0 seconds, that's when something should be happening!
				if ( timeLeftInt == 0 )
					break;
				
				clockObject playSound( "ui_mp_timer_countdown" );
			}
			
			// synchronize to be exactly on the second
			if ( timeLeft - floor(timeLeft) >= .05 )
				wait timeLeft - floor(timeLeft);
		}

		wait ( 1.0 );
	}
}


gameTimer()
{
	level endon ( "game_ended" );
	
	level waittill("prematch_over");
	
	level.startTime = getTime();
	
	prevtime = gettime();
	
	while ( game["state"] == "playing" )
	{
		if ( !level.timerStopped )
		{
			// the wait isn't always exactly 1 second. dunno why.
			game["timepassed"] += gettime() - prevtime;
		}
		prevtime = gettime();
		wait ( 1.0 );
	}
}

getTimePassed()
{
	return gettime() - level.startTime;
}


startGame()
{
	thread gameTimer();
	level.timerStopped = false;
	thread maps\mp\gametypes\_spawnlogic::spawnSightChecks();

	prematchPeriod();
	level notify("prematch_over");

	thread timeLimitClock();
	thread gracePeriod();

	thread musicController();
	thread maps\mp\gametypes\_missions::roundBegin();	
}


musicController()
{
	level endon ( "game_ended" );
	
	thread suspenseMusic();
	
	level waittill ( "match_ending_soon" );

	if ( game["teamScores"]["allies"] > game["teamScores"]["axis"] )
	{
		playSoundOnPlayers( game["music"]["winning"], "allies" );
		playSoundOnPlayers( game["music"]["losing"], "axis" );

		leaderDialog( "winning", "allies" );
		leaderDialog( "losing", "axis" );
	}
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
	{
		playSoundOnPlayers( game["music"]["winning"], "axis" );
		playSoundOnPlayers( game["music"]["losing"], "allies" );

		leaderDialog( "winning", "axis" );
		leaderDialog( "losing", "allies" );
	}
	else
	{
		playSoundOnPlayers( game["music"]["losing"] );
		leaderDialog( "timesup" );
	}

	level waittill ( "match_ending_very_soon" );
	leaderDialog( "timesup" );
}


suspenseMusic()
{
	level endon ( "game_ended" );
	level endon ( "match_ending_soon" );
	
	numTracks = game["music"]["suspense"].size;
	for ( ;; )
	{
		wait ( randomFloatRange( 60, 120 ) );
		
		playSoundOnPlayers( game["music"]["suspense"][randomInt(numTracks)] ); 
	}
}


prematchPeriod()
{
	makeDvarServerInfo( "ui_hud_hardcore", 1 );
	setDvar( "ui_hud_hardcore", 1 );
	level endon( "game_ended" );
	
	if ( level.prematchPeriod > 0 )
	{
		thread matchStartTimer();
		wait ( level.prematchPeriod );
	}
	else
	{
		matchStartTimerSkip();
	}
	
	level.inPrematchPeriod = false;
	
	for ( index = 0; index < level.players.size; index++ )
	{
		level.players[index] freezeControls( false );
		level.players[index] enableWeapons();

		hintMessage = getObjectiveHintText( level.players[index].pers["team"] );
		if ( !isDefined( hintMessage ) || !level.players[index].hasSpawned )
			continue;

		level.players[index] setClientDvar( "scr_objectiveText", hintMessage );
		level.players[index] thread maps\mp\gametypes\_hud_message::hintMessage( hintMessage );

	}

	leaderDialog( "offense_obj", game["attackers"], "introboost" );
	leaderDialog( "defense_obj", game["defenders"], "introboost" );

	if ( game["state"] != "playing" )
		return;

	setDvar( "ui_hud_hardcore", level.hardcoreMode );
}


gracePeriod()
{
	level endon("game_ended");
	
	wait ( level.gracePeriod );
	
	level notify ( "grace_period_ending" );
	wait ( 0.05 );
	
	level.inGracePeriod = false;
	
	if ( game["state"] != "playing" )
		return;
	
	if ( level.numLives )
	{
		// Players on a team but without a weapon show as dead since they can not get in this round
		players = level.players;
		
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if ( !player.hasSpawned && player.sessionteam != "spectator" && !isAlive( player ) )
				player.statusicon = "hud_status_dead";
		}
	}
	
	level thread [[level.updateTeamStatus]]();
	wait ( 0.05 );
	
	// if both allies and axis were alive and now they are both dead in the same instance
	if ( level.numLives == 1 && !level.aliveCount["allies"] && !level.aliveCount["axis"] )
	{
		makeDvarServerInfo( "ui_text_endreason", game["strings"]["tie"] );
		setDvar( "ui_text_endreason", game["strings"]["tie"] );
		thread endGame( "tie", game["strings"]["tie"] );
	}
}

lockPlayersUntilFadeInComplete()
{
	level endon("fade_in_complete");
	
	players = level.players;
	for (i = 0; i < players.size; i++) {
		players[i] thread lockPlayerUntilFadeInComplete();
	}
	
	while(1)
	{
		level waittill("connected", player);
		player thread lockPlayerUntilFadeInComplete();
	}
}


lockPlayerUntilFadeInComplete()
{
	if (self.sessionstate != "playing") {
		self waittill("spawned_player");
		if (isdefined(level.fadeInComplete))
			return;
	}
	assert(!isdefined(level.fadeInComplete));
	
	origin = spawn("script_origin", self.origin);
	self linkto(origin);
	
	//self disableWeapons();
	
	level waittill("fade_in_complete");
	
	if (isdefined(self))
		self unlink();
	
	origin delete();

	/*if (!isdefined(self))
		return;

	wait .05;

	self enableWeapons();*/
}


fadeOut(startFade, fadeTime)
{
	fader = newHudElem();
	fader.x = 0;
	fader.y = 0;
	fader setshader ("black", 640, 480);
	fader.alignX = "left";
	fader.alignY = "top";
	fader.horzAlign = "fullscreen";
	fader.vertAlign = "fullscreen";
	fader.sort = 1000; // on top of everything except "match starting"
	
	fader.alpha = 0;
	fader fadeOverTime(fadeTime);
	fader.alpha = 1;
}
fadeIn(preFadeTime, fadeTime)
{
	fader = newHudElem();
	fader.x = 0;
	fader.y = 0;
	fader setshader ("black", 640, 480);
	fader.alignX = "left";
	fader.alignY = "top";
	fader.horzAlign = "fullscreen";
	fader.vertAlign = "fullscreen";
	fader.sort = 1000; // on top of everything except "match starting"
	
	fader.alpha = 1;
	
	wait preFadeTime;
	
	fader fadeOverTime(fadeTime);
	fader.alpha = 0;
}


announceRoundWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["round_draw"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win_round"] );
		// removed success/failure dialog at end of rounds because it gets repetative, especially when the game ends right afterwards
		//playSoundOnPlayers( game["voice"]["allies"]+game["dialog"]["mission_success"], "allies" );
		//playSoundOnPlayers( game["voice"]["axis"]+game["dialog"]["mission_failure"], "axis" );
	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win_round"] );
		//playSoundOnPlayers( game["voice"]["axis"]+game["dialog"]["mission_success"], "axis" );
		//playSoundOnPlayers( game["voice"]["allies"]+game["dialog"]["mission_failure"], "allies" );
	}
	else
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["round_draw"] );
	}
}

announceGameWinner( winner, delay )
{
	if ( delay > 0 )
		wait delay;

	if ( !isDefined( winner ) )
	{
//		playSoundOnPlayers( "AB_mpc_mission_draw", "axis" );
//		playSoundOnPlayers( "US_mpc_mission_draw", "allies" );
		announcement( game["strings"]["tie"] );
	}
	else if ( isPlayer( winner ) )
	{
	}
	else if ( winner == "allies" )
	{
		announcement( game["strings"]["allies_win"] );
		leaderDialog( "mission_success", "allies" );
		if ( !level.splitScreen )
			leaderDialog( "mission_failure", "axis" );
	}
	else if ( winner == "axis" )
	{
		announcement( game["strings"]["axis_win"] );
		leaderDialog( "mission_success", "axis" );
		if ( !level.splitScreen )
			leaderDialog( "mission_failure", "allies" );
	}
	else
	{
		if ( level.splitScreen )
			leaderDialog( "mission_draw", "allies" );
		else
			leaderDialog( "mission_draw" );

		announcement( game["strings"]["tie"] );
	}
}


updateWinStats( winner )
{
	println( "setting winner: " + winner maps\mp\gametypes\_persistence::statGet( "wins" ) );
	winner maps\mp\gametypes\_persistence::statAdd( "wins", 1 );
	winner updatePersRatio( "wlratio", "wins", "losses" );
	winner maps\mp\gametypes\_persistence::statAdd( "cur_win_streak", 1 );
	
	cur_win_streak = winner maps\mp\gametypes\_persistence::statGet( "cur_win_streak" );
	if ( cur_win_streak > winner maps\mp\gametypes\_persistence::statGet( "win_streak" ) )
		winner maps\mp\gametypes\_persistence::statSet( "win_streak", cur_win_streak );
}


updateLossStats( loser )
{	
	loser maps\mp\gametypes\_persistence::statAdd( "losses", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );	
}


updateTieStats( loser )
{	
	loser maps\mp\gametypes\_persistence::statAdd( "ties", 1 );
	loser updatePersRatio( "wlratio", "wins", "losses" );
	loser maps\mp\gametypes\_persistence::statSet( "cur_win_streak", 0 );	
}


updateWinLossStats( winner )
{
	if ( level.roundLimit > 1 && !hitRoundLimit() )
		return;
		
	players = level.players;

	if ( !isDefined( winner ) || ( isDefined( winner ) && !isPlayer( winner ) && winner == "tie" ) )
	{
		return;
	} 
	else if ( isPlayer( winner ) )
	{

		updateWinStats( winner );
		
		for ( i = 0; i < players.size; i++ )
		{
			if ( players[i] == winner )
				continue;
			updateLossStats( players[i] );
		}		
	}
	else
	{
		for ( i = 0; i < players.size; i++ )
		{
			if ( !isDefined( players[i].pers["team"] ) )
				continue;
			else if ( winner == "tie" )
				updateTieStats( players[i] );
			else if ( players[i].pers["team"] == winner )
				updateWinStats( players[i] );
			else
				updateLossStats( players[i] );
		}
	}
}


updateLeaderboards()
{
	if ( !level.rankedMatch )
		return;

	players = level.players;
	for ( index = 0; index < players.size; index++ )
		players[index] sendleaderboards();
}


TimeUntilWaveSpawn( minimumWait )
{
	// the time we'll spawn if we only wait the minimum wait.
	earliestSpawnTime = gettime() + minimumWait * 1000;
	
	// the number of waves that will have passed since the last wave happened, when the minimum wait is over.
	numWavesPassedEarliestSpawnTime = (earliestSpawnTime - level.lastWave[self.pers["team"]]) / (level.waveDelay[self.pers["team"]] * 1000);
	// rounded up
	numWaves = ceil( numWavesPassedEarliestSpawnTime );
	
	timeOfSpawn = level.lastWave[self.pers["team"]] + numWaves * level.waveDelay[self.pers["team"]] * 1000;
	
	return (timeOfSpawn - gettime()) / 1000;
}

TeamKillDelay()
{
	teamkills = self.pers["teamkills"];
	if ( teamkills <= level.minimumAllowedTeamKills )
		return 0;
	exceeded = (teamkills - level.minimumAllowedTeamKills);
	return maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillspawndelay" ) * exceeded;
}

TimeUntilSpawn( includeTeamkillDelay )
{
	if ( level.inGracePeriod && !self.hasSpawned )
		return 0;
	
	respawnDelay = 0;
	if ( self.hasSpawned )
	{
		result = self [[level.onRespawnDelay]]();		
		if ( isDefined( result ) )
			respawnDelay = result;
		else
		respawnDelay = maps\mp\gametypes\_tweakables::getTweakableValue( "player", "respawndelay" );
			
		if ( includeTeamkillDelay && self.teamKillPunish )
			respawnDelay += TeamKillDelay();
	}

	waveBased = (maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" ) > 0);

	if ( waveBased )
		return self TimeUntilWaveSpawn( respawnDelay );
	
	return respawnDelay;
}

maySpawn()
{
	if ( level.numLives )
	{
		if ( !self.pers["lives"] )
		{
			return false;
		}
		else
		{
			gameHasStarted = ((level.aliveCount[ "axis" ] > 0) && (level.aliveCount[ "allies" ] > 0));
			if ( gameHasStarted )
			{
				// disallow spawning for late comers
				if ( !level.inGracePeriod && !self.hasSpawned )
					return false;
			}
		}
	}
	return true;
}

spawnClient( timeAlreadyPassed )
{
	assert(	isDefined( self.pers["team"] ) );
	assert(	isValidClass( self.pers["class"] ) );
	
	if ( !self maySpawn() )
	{
		currentorigin =	self.origin;
		currentangles =	self.angles;
		
		if ( level.roundLimit > 1 && game["roundsplayed"] < (level.roundLimit - 1) )
		{
			setLowerMessage( &"MP_SPAWN_NEXT_ROUND" );
			self thread removeSpawnMessageShortly( 3 );
		}
		self thread	[[level.spawnSpectator]]( currentorigin	+ (0, 0, 60), currentangles	);
		return;
	}
	
	if ( self.waitingToSpawn )
		return;
	self.waitingToSpawn = true;
	
	self waitAndSpawnClient( timeAlreadyPassed );
	
	if ( isdefined( self ) )
		self.waitingToSpawn = false;
}

waitAndSpawnClient( timeAlreadyPassed )
{
	self endon ( "disconnect" );
	self endon ( "end_respawn" );
	self endon ( "game_ended" );
	
	if ( !isdefined( timeAlreadyPassed ) )
		timeAlreadyPassed = 0;
	
	spawnedAsSpectator = false;
	
	if ( self.teamKillPunish )
	{
		teamKillDelay = TeamKillDelay();
		if ( teamKillDelay > timeAlreadyPassed )
		{
			teamKillDelay -= timeAlreadyPassed;
			timeAlreadyPassed = 0;
		}
		else
		{
			timeAlreadyPassed -= teamKillDelay;
			teamKillDelay = 0;
		}
		
		if ( teamKillDelay > 0 )
		{
			setLowerMessage( &"MP_FRIENDLY_FIRE_WILL_NOT", teamKillDelay );
			
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
			spawnedAsSpectator = true;
			
			wait( teamKillDelay );
		}
		
		self.teamKillPunish = false;
	}
	
	timeUntilSpawn = TimeUntilSpawn( false );
	if ( timeUntilSpawn > timeAlreadyPassed )
	{
		timeUntilSpawn -= timeAlreadyPassed;
		timeAlreadyPassed = 0;
	}
	else
	{
		timeAlreadyPassed -= timeUntilSpawn;
		timeUntilSpawn = 0;
	}
	
	if ( timeUntilSpawn > 0 )
	{
		// spawn player into spectator on death during respawn delay, if he switches teams during this time, he will respawn next round
		setLowerMessage( &"MP_WAITING_TO_SPAWN", timeUntilSpawn );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitForTimeOrNotify( timeUntilSpawn, "force_spawn" );
	}
	
	waveBased = (maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" ) > 0);
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "player", "forcerespawn" ) == 0 && self.hasSpawned && !waveBased )
	{
		setLowerMessage( &"PLATFORM_PRESS_TO_SPAWN" );
		
		if ( !spawnedAsSpectator )
			self thread	respawn_asSpectator( self.origin + (0, 0, 60), self.angles );
		spawnedAsSpectator = true;
		
		self waitRespawnButton();
	}
	
	self.waitingToSpawn = false;
	
	self clearLowerMessage();
	
	self thread	[[level.spawnPlayer]]();
}


waitForTimeOrNotify( time, notifyname )
{
	self endon( notifyname );
	wait time;
}


removeSpawnMessageShortly( delay )
{
	self endon("disconnect");
	
	waittillframeend; // so we don't endon the end_respawn from spawning as a spectator
	
	self endon("end_respawn");
	
	wait delay;
	
	self clearLowerMessage( 2.0 );
}


Callback_StartGameType()
{
	level.prematchPeriod = 0;

	if ( !isDefined( game["gamestarted"] ) )
	{
		// defaults if not defined in level script
		if ( !isDefined( game["allies"] ) )
			game["allies"] = "marines";
		if ( !isDefined( game["axis"] ) )
			game["axis"] = "opfor";
		if ( !isDefined( game["attackers"] ) )
			game["attackers"] = "allies";
		if (  !isDefined( game["defenders"] ) )
			game["defenders"] = "axis";
				
		if ( !isDefined( game["state"] ) )
			game["state"] = "playing";
	
		precacheStatusIcon( "hud_status_dead" );
		precacheStatusIcon( "hud_status_connecting" );
		
		precacheRumble( "damage_heavy" );

		precacheString( &"PLATFORM_PRESS_TO_SPAWN" );
		precacheString( &"MP_WAITING_MATCH" );
		precacheString( &"MP_WAITING_FOR_TEAMS" );
		precacheString( &"MP_MATCH_STARTING_IN" );
		precacheString( &"MP_SPAWN_NEXT_ROUND" );
		precacheString( &"MP_WAITING_TO_SPAWN" );
		precacheString( &"MP_ALLIES_FORFEITED");
		precacheString( &"MP_AXIS_FORFEITED");
	
		precacheShader( "white" );
		precacheShader( "black" );
		
		makeDvarServerInfo( "scr_allies", "usmc" );
		makeDvarServerInfo( "scr_axis", "arab" );
		
		makeDvarServerInfo( "cg_thirdPersonAngle", 345 );

		setDvar( "cg_thirdPersonAngle", 345 );

		
		game["strings"]["allies_win"] = &"MP_ALLIES_WIN_MATCH";
		game["strings"]["axis_win"] = &"MP_OPFOR_WIN_MATCH";
		game["strings"]["allies_win_round"] = &"MP_ALLIES_WIN_ROUND";
		game["strings"]["axis_win_round"] = &"MP_OPFOR_WIN_ROUND";
		game["strings"]["tie"] = &"MP_MATCH_TIE";
		game["strings"]["round_draw"] = &"MP_ROUND_DRAW";

		game["strings"]["waiting_for_teams"] = &"MP_WAITING_FOR_TEAMS";
		game["strings"]["match_starting"] = &"MP_MATCH_STARTING";
		game["strings"]["allies_mission_accomplished"] = &"MP_ALLIES_MISSION_ACCOMPLISHED";
		game["strings"]["axis_mission_accomplished"] = &"MP_OPFOR_MISSION_ACCOMPLISHED";
		game["strings"]["allies_eliminated"] = &"MP_ALLIES_ELIMINATED";
		game["strings"]["axis_eliminated"] = &"MP_OPFOR_ELIMINATED";
		game["strings"]["enemies_eliminated"] = &"MP_ENEMIES_ELIMINATED";
		game["strings"]["score_limit_reached"] = &"MP_SCORE_LIMIT_REACHED";
		game["strings"]["round_limit_reached"] = &"MP_ROUND_LIMIT_REACHED";
		game["strings"]["time_limit_reached"] = &"MP_TIME_LIMIT_REACHED";

		game["sounds"]["allies_last_alive"] = "us_mpc_inform_last_alive";
		game["sounds"]["axis_last_alive"] = "ab_mpc_inform_last_alive";

		switch ( game["allies"] )
		{
			case "sas":
				game["music"]["spawn_allies"] = "mp_spawn_sas";
				game["music"]["victory_allies"] = "mp_victory_sas";
				game["icons"]["allies"] = "faction_128_sas";
				game["strings"]["allies_name"] = "S.A.S.";
				game["colors"]["allies"] = (0.6,0.64,0.69);
				game["voice"]["allies"] = "UK_1mc_";
				setDvar( "scr_allies", "sas" );
				break;
			case "marines":
			default:
				game["music"]["spawn_allies"] = "mp_spawn_usa";
				game["music"]["victory_allies"] = "mp_victory_usa";
				game["icons"]["allies"] = "faction_128_usmc";
				game["strings"]["allies_name"] = "Marine Force Recon";
				game["colors"]["allies"] = (0,0,0);
				game["voice"]["allies"] = "US_1mc_";
				setDvar( "scr_allies", "usmc" );
				break;
		}
		switch ( game["axis"] )
		{
			case "russian":
				game["music"]["spawn_axis"] = "mp_spawn_soviet";
				game["music"]["victory_axis"] = "mp_victory_soviet";
				game["icons"]["axis"] = "faction_128_ussr";
				game["strings"]["axis_name"] = "Spetsnaz";
				game["colors"]["axis"] = (0.52,0.28,0.28);
				game["voice"]["axis"] = "RU_1mc_";
				setDvar( "scr_axis", "ussr" );
				break;
			case "arab":
			case "opfor":
			default:
				game["music"]["spawn_axis"] = "mp_spawn_opfor";
				game["music"]["victory_axis"] = "mp_victory_opfor";
				game["icons"]["axis"] = "faction_128_arab";
				game["strings"]["axis_name"] = "OpFor";
				game["colors"]["axis"] = (0.65,0.57,0.41);
				game["voice"]["axis"] = "AB_1mc_";
				setDvar( "scr_axis", "arab" );
				break;
		}
		game["music"]["defeat"] = "mp_defeat";
		game["music"]["winning"] = "mp_time_running_out_winning";
		game["music"]["losing"] = "mp_time_running_out_losing";
		game["music"]["victory_tie"] = "mp_defeat";
		
		game["music"]["suspense"] = [];
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_01";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_02";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_03";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_04";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_05";
		game["music"]["suspense"][game["music"]["suspense"].size] = "mp_suspense_06";
		
		game["dialog"]["mission_success"] = "mission_success";
		game["dialog"]["mission_failure"] = "mission_fail";
		game["dialog"]["mission_draw"] = "draw";
		
		// status
		game["dialog"]["timesup"] = "timesup";
		game["dialog"]["winning"] = "winning";
		game["dialog"]["losing"] = "losing";
		game["dialog"]["lead_lost"] = "lead_lost";
		game["dialog"]["lead_taken"] = "lead_taken";
		game["dialog"]["last_alive"] = "lastalive";

		game["dialog"]["boost"] = "boost";

		if ( !isDefined( game["dialog"]["offense_obj"] ) )
			game["dialog"]["offense_obj"] = "boost";
		if ( !isDefined( game["dialog"]["defense_obj"] ) )
			game["dialog"]["defense_obj"] = "boost";
		
		game["dialog"]["hardcore"] = "hardcore";
		game["dialog"]["oldschool"] = "oldschool";
		game["dialog"]["highspeed"] = "highspeed";
		game["dialog"]["tactical"] = "tactical";

		game["dialog"]["challenge"] = "challengecomplete";
		game["dialog"]["promotion"] = "promotion";

		game["dialog"]["bomb_taken"] = "bomb_taken";
		game["dialog"]["bomb_lost"] = "bomb_lost";
		game["dialog"]["bomb_defused"] = "bomb_defused";
		game["dialog"]["bomb_planted"] = "bomb_planted";

		game["dialog"]["obj_taken"] = "securedobj";
		game["dialog"]["obj_lost"] = "lostobj";

		game["dialog"]["obj_defend"] = "obj_defend";
		game["dialog"]["obj_destroy"] = "obj_destroy";

		game["dialog"]["attack"] = "attack";
		game["dialog"]["defend"] = "defend";
		game["dialog"]["offense"] = "offense";
		game["dialog"]["defense"] = "defense";

		game["dialog"]["flag_taken"] = "ourflag";
		game["dialog"]["flag_dropped"] = "ourflag_drop";
		game["dialog"]["flag_returned"] = "ourflag_return";
		game["dialog"]["flag_captured"] = "ourflag_capt";
		game["dialog"]["enemy_flag_taken"] = "enemyflag";
		game["dialog"]["enemy_flag_dropped"] = "enemyflag_drop";
		game["dialog"]["enemy_flag_returned"] = "enemyflag_return";
		game["dialog"]["enemy_flag_captured"] = "enemyflag_capt";

		precacheString( game["strings"]["allies_win"] );
		precacheString( game["strings"]["axis_win"] );
		precacheString( game["strings"]["allies_win_round"] );
		precacheString( game["strings"]["axis_win_round"] );
		precacheString( game["strings"]["tie"] );
		precacheString( game["strings"]["round_draw"] );
		precacheString( game["strings"]["waiting_for_teams"] );
		precacheString( game["strings"]["match_starting"] );
		precacheString( game["strings"]["allies_mission_accomplished"] );
		precacheString( game["strings"]["axis_mission_accomplished"] );
		precacheString( game["strings"]["allies_eliminated"] );
		precacheString( game["strings"]["axis_eliminated"] );
		precacheString( game["strings"]["enemies_eliminated"] );

		[[level.onPrecacheGameType]]();
		
		game["gamestarted"] = true;
		
		game["teamScores"]["allies"] = 0;
		game["teamScores"]["axis"] = 0;
		
		if ( !level.splitscreen )
			level.prematchPeriod = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "graceperiod" ); // TODO rename to prematch and update files to match
	}

	if(!isdefined(game["timepassed"]))
		game["timepassed"] = 0;

	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;
	
	level.skipVote = false;
	level.gameEnded = false;
	level.teamSpawnPoints["axis"] = [];
	level.teamSpawnPoints["allies"] = [];

	level.objIDStart = 0;
	level.forcedEnd = false;

	level.hardcoreMode = getDvarInt( "scr_hardcore" );

	// this gets set to false when someone takes damage or a gametype-specific event happens.
	level.useStartSpawns = true;
	
	level.minimumAllowedTeamKills = 2; // punishment starts at the next one
	
	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	thread maps\mp\gametypes\_persistence::init();
	thread maps\mp\gametypes\_menus::init();
	thread maps\mp\gametypes\_hud::init();
	thread maps\mp\gametypes\_serversettings::init();
	thread maps\mp\gametypes\_clientids::init();
	thread maps\mp\gametypes\_teams::init();
	thread maps\mp\gametypes\_weapons::init();
	thread maps\mp\gametypes\_scoreboard::init();
	thread maps\mp\gametypes\_killcam::init();
	thread maps\mp\gametypes\_shellshock::init();
	thread maps\mp\gametypes\_deathicons::init();
	thread maps\mp\gametypes\_damagefeedback::init();
	thread maps\mp\gametypes\_healthoverlay::init();
	thread maps\mp\gametypes\_spectating::init();
	thread maps\mp\gametypes\_objpoints::init();
	thread maps\mp\gametypes\_gameobjects::init();
	thread maps\mp\gametypes\_spawnlogic::init();
	thread maps\mp\gametypes\_oldschool::init();
	thread maps\mp\gametypes\_battlechatter_mp::init();

	thread maps\mp\gametypes\_hardpoints::init();

	if ( level.teamBased )
		thread maps\mp\gametypes\_friendicons::init();
		
	thread maps\mp\gametypes\_hud_message::init();

	if ( !level.console )
		thread maps\mp\gametypes\_quickmessages::init();

	level.playerCount["allies"] = 0;
	level.playerCount["axis"] = 0;
	level.aliveCount["allies"] = 0;
	level.aliveCount["axis"] = 0;
	level.lastAliveCount["allies"] = 0;
	level.lastAliveCount["axis"] = 0;
	level.everExisted["allies"] = false;
	level.everExisted["axis"] = false;
	level.waveDelay["allies"] = 0;
	level.waveDelay["axis"] = 0;
	level.lastWave["allies"] = 0;
	level.lastWave["axis"] = 0;
	
	if ( level.teamBased )
	{
		setObjectiveText( "allies", &"OBJECTIVES_WAR" );
		setObjectiveText( "axis", &"OBJECTIVES_WAR" );
		
		if ( level.splitscreen )
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
		}
		else
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
		}
		setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
		setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );
	}
	else
	{
		setObjectiveText( "allies", &"OBJECTIVES_DM" );
		setObjectiveText( "axis", &"OBJECTIVES_DM" );

		if ( level.splitscreen )
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_DM" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_DM" );
		}
		else
		{
			setObjectiveScoreText( "allies", &"OBJECTIVES_DM_SCORE" );
			setObjectiveScoreText( "axis", &"OBJECTIVES_DM_SCORE" );
		}
		setObjectiveHintText( "allies", &"OBJECTIVES_DM_HINT" );
		setObjectiveHintText( "axis", &"OBJECTIVES_DM_HINT" );
	}

	if ( !isDefined( level.timeLimit ) )
		registerTimeLimitDvar( "default", 20, 1, 1440 );
		
	if ( !isDefined( level.scoreLimit ) )
		registerScoreLimitDvar( "default", 100, 1, 500 );

	if ( !isDefined( level.roundLimit ) )
		registerRoundLimitDvar( "default", 1, 0, 10 );
	
	makeDvarServerInfo( "ui_scorelimit" );
	makeDvarServerInfo( "ui_timelimit" );

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" ) )
	{
		level.waveDelay["allies"] = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
		level.waveDelay["axis"] = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "respawntime" );
		level.lastWave["allies"] = 0;
		level.lastWave["axis"] = 0;
		
		level thread [[level.waveSpawnTimer]]();
	}
	
	level.inPrematchPeriod = true;
	
	if ( level.prematchPeriod > 2.0 )
		level.prematchPeriod = level.prematchPeriod + (randomFloat( 4 ) - 2); // live host obfuscation

	if ( level.numLives || level.waveDelay["allies"] || level.waveDelay["axis"] )
		level.gracePeriod = 15;
	else
		level.gracePeriod = 5;
		
	level.inGracePeriod = true;
	
	level.roundEndDelay = 8;
	
	updateTeamScores( "axis", "allies" );
	
	checkRoundSwitch();

	[[level.onStartGameType]]();
	
	// this must be after onstartgametype for scr_showspawns to work when set at start of game
	thread maps\mp\gametypes\_dev::init();
	
	thread startGame();
	level thread updateGameTypeDvars();
}

checkRoundSwitch()
{
	if ( !isdefined( level.roundswitch ) )
		return;
	
	if ( isDefined( game["alt_count"] ) )
	{
		if ( ( game["alt_count"] >= level.roundswitch ) && ( game["alt_count"] < level.roundswitch*2 ) )
		{
			if ( isdefined( level.onRoundSwitch ) )
				[[level.onRoundSwitch]]();
		}
	}
	else
	{
		game["alt_count"] = 0;
	}

	if ( game["alt_count"] == level.roundswitch*2 )
		game["alt_count"] = 1;
	else
		game["alt_count"]++;
}


getGameScore( team )
{
	return game["teamScores"][team];
}


fakeLag()
{
	self endon ( "disconnect" );
	self.fakeLag = randomIntRange( 50, 150 );
	
	for ( ;; )
	{
		self setClientDvar( "fakelag_target", self.fakeLag );
		wait ( randomFloatRange( 5.0, 15.0 ) );
	}
}

Callback_PlayerConnect()
{
	thread notifyConnecting();

	self.statusicon = "hud_status_connecting";
	self waittill( "begin" );
	waittillframeend;
	self.statusicon = "";

	level notify( "connected", self );
	
	// set show/hide for Create-a-class in game UI properties
	self setClientDvar( "ui_cac_ingame", "0" );
	
//	self thread fakeLag();

	// only print that we connected if we haven't connected in a previous round
	if( !level.splitscreen && !isdefined( self.pers["score"] ) )
		iPrintLn(&"MP_CONNECTED", self);

	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("J;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");

	// dvars used by hardcore
	self setClientDvars( "cg_drawCrosshair", getDvar( "cg_drawCrosshair" ), 
						 "cg_drawCrosshairNames", getDvar( "cg_drawCrosshairNames" ),
						 "ui_hud_hardcore", getDvar( "ui_hud_hardcore" ) );

	if ( level.splitScreen )
	{
		self setClientDvars("cg_hudGrenadeIconHeight", "37.5", 
							"cg_hudGrenadeIconWidth", "37.5", 
							"cg_hudGrenadeIconOffset", "75", 
							"cg_hudGrenadePointerHeight", "18", 
							"cg_hudGrenadePointerWidth", "37.5", 
							"cg_hudGrenadePointerPivot", "18 40.5", 
							"cg_fovscale", "1" );
	}
	else
	{
		self setClientDvars("cg_hudGrenadeIconHeight", "25", 
							"cg_hudGrenadeIconWidth", "25", 
							"cg_hudGrenadeIconOffset", "50", 
							"cg_hudGrenadePointerHeight", "12", 
							"cg_hudGrenadePointerWidth", "25", 
							"cg_hudGrenadePointerPivot", "12 27", 
							"cg_fovscale", "1");
	}

	self.pers["score"] = 0;
	self.score = self.pers["score"];

	self initPersStat( "deaths" );
	self.deaths = self getPersStat( "deaths" );

	self initPersStat( "suicides" );
	self.suicides = self getPersStat( "suicides" );

	self initPersStat( "kills" );
	self.kills = self getPersStat( "kills" );

	self initPersStat( "headshots" );
	self.headshots = self getPersStat( "headshots" );

	self initPersStat( "assists" );
	self.assists = self getPersStat( "assists" );
	
	self initPersStat( "teamkills" );
	self.teamKillPunish = false;
	if ( self.pers["teamkills"] > level.minimumAllowedTeamKills )
		self thread reduceTeamKillsOverTime();
	
	if( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		level waittill( "eternity" );

	self.killedPlayers = [];
	self.killedPlayersCurrent = [];
	self.killedBy = [];
	
	self.leaderDialogQueue = [];
	self.leaderDialogActive = false;
	self.leaderDialogGroups = [];
	self.leaderDialogGroup = "";

	self.cur_kill_streak = 0;
	self.cur_death_streak = 0;
	self.death_streak = self maps\mp\gametypes\_persistence::statGet( "death_streak" );
	self.kill_streak = self maps\mp\gametypes\_persistence::statGet( "kill_streak" );
	self.lastGrenadeSuicideTime = -1;

	self.teamkillsThisRound = 0;
	
	self.pers["lives"] = level.numLives;
	
	self.hasSpawned = false;
	self.waitingToSpawn = false;
	
	self.wasAliveAtMatchStart = false;

	if ( level.numLives )
	{
		self setClientDvars("cg_deadChatWithDead", "1",
							"cg_deadChatWithTeam", "0",
							"cg_deadHearTeamLiving", "0",
							"cg_deadHearAllLiving", "0",
							"cg_everyoneHearsEveryone", "0" );
	}
	else
	{
		self setClientDvars("cg_deadChatWithDead", "0",
							"cg_deadChatWithTeam", "1",
							"cg_deadHearTeamLiving", "1",
							"cg_deadHearAllLiving", "0",
							"cg_everyoneHearsEveryone", "0" );
	}
	
	level.players[level.players.size] = self;
	
	if( level.splitscreen )
		setdvar( "splitscreen_playerNum", level.players.size );
		
	// When joining a game in progress, if the game is at the post game state (scoreboard) the connecting player should spawn into intermission
	if ( game["state"] == "postgame" )
	{
		[[level.spawnIntermission]]();
		self closeMenu();
		self closeInGameMenu();
		return;
	}

	level endon( "game_ended" );
	
	if ( level.oldschool )
		self.pers["class"] = undefined;
	
	if ( !isDefined( self.pers["team"] ) )
	{
		self.pers["team"] = "spectator";
		self.sessionteam = "spectator";
		self.sessionstate = "dead";

		self updateObjectiveText();

		[[level.spawnSpectator]]();
		
		if ( level.rankedMatch )
		{
			[[level.autoassign]]();
			
			//self thread forceSpawn();
			self thread kickIfDontSpawn();
		}
		else if ( !level.teamBased )
		{
			[[level.autoassign]]();
		}
		else
		{		
			self setclientdvar( "g_scriptMainMenu", game["menu_team"] );
			self openMenu( game["menu_team"] );
		}
		
		// skips if playing none team based gametypes
		if( level.teamBased )
		{
			// set team and spectate permissions so the map shows waypoint info on connect
			self.sessionteam = self.pers["team"];
			if ( !isAlive( self ) )
				self.statusicon = "hud_status_dead";
			self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
		}
	}
	else if ( self.pers["team"] != "spectator" )
	{
		self.sessionteam = self.pers["team"];
		self.sessionstate = "dead";

		self updateObjectiveText();

		self setClientDvar( "ui_allow_classchange", "1" );
		if ( isValidClass( self.pers["class"] ) )
		{
			[[level.spawnSpectator]](); // spawn them as a spectator in case spawnClient doesn't spawn them immediately (perhaps at the start of a prematch round)
			self thread [[level.spawnClient]]();			
		}
		else
		{
			self showMainMenuForTeam();
		}
		
		self thread maps\mp\gametypes\_spectating::setSpectatePermissions();
	}
}


forceSpawn()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );

	wait ( 60.0 );

	if ( self.hasSpawned )
		return;
	
	if ( self.pers["team"] == "spectator" )
		return;
	
	if ( !isValidClass( self.pers["class"] ) )
	{
		if ( getDvarInt( "onlinegame" ) )
			self.pers["class"] = "CLASS_CUSTOM1";
		else
			self.pers["class"] = "CLASS_ASSAULT";
	}
	
	self closeMenus();
	self thread [[level.spawnClient]]();
}

kickIfDontSpawn()
{
	self kickIfIDontSpawnInternal();
	// clear any client dvars here,
	// like if we set anything to change the menu appearance to warn them of kickness
}

kickIfIDontSpawnInternal()
{
	self endon ( "death" );
	self endon ( "disconnect" );
	self endon ( "spawned" );
	
	wait 90;
	
	if ( self.hasSpawned )
		return;
	
	if ( self.pers["team"] == "spectator" )
		return;
	
	kick( self getEntityNumber() );
}

Callback_PlayerDisconnect()
{
	self removePlayerOnDisconnect();
	
	if( !level.splitscreen )
	{
		iPrintLn( &"MP_DISCONNECTED", self );
	}
	else
	{
		players = level.players;
		
		if ( players.size <= 1 )
			level thread maps\mp\gametypes\_globallogic::forceEnd();
			
		// passing number of players to menus in splitscreen to display leave or end game option
		setdvar( "splitscreen_playerNum", players.size );
	}

	if( isDefined( self.pers["team"] ) )
	{
		if( self.pers["team"] == "allies" )
			setPlayerTeamRank( self, 0, 0 );
		else if( self.pers["team"] == "axis" )
			setPlayerTeamRank( self, 1, 0 );
		else if( self.pers["team"] == "spectator" )
			setPlayerTeamRank( self, 2, 0 );
	}
	
	[[level.onPlayerDisconnect]]();
	
	lpselfnum = self getEntityNumber();
	lpGuid = self getGuid();
	logPrint("Q;" + lpGuid + ";" + lpselfnum + ";" + self.name + "\n");
	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}	
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( isDefined( level.players[entry].killedPlayers[self.name] ) )
			level.players[entry].killedPlayers[self.name] = undefined;

		if ( isDefined( level.players[entry].killedPlayersCurrent[self.name] ) )
			level.players[entry].killedPlayersCurrent[self.name] = undefined;

		if ( isDefined( level.players[entry].killedBy[self.name] ) )
			level.players[entry].killedBy[self.name] = undefined;
	}
	
	level thread [[level.updateTeamStatus]]();	
}


removePlayerOnDisconnect()
{
	for ( entry = 0; entry < level.players.size; entry++ )
	{
		if ( level.players[entry] == self )
		{
			while ( entry < level.players.size-1 )
			{
				level.players[entry] = level.players[entry+1];
				entry++;
			}
			level.players[entry] = undefined;
			break;
		}
	}
}


isHeadShot( sHitLoc, sMeansOfDeath )
{
	return (sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE";
}

Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	// create a class specialty checks; CAC:bulletdamage, CAC:armorvest
	iDamage = maps\mp\gametypes\_class::cac_modified_damage( self, eAttacker, iDamage, sMeansOfDeath );
	self.iDFlags = iDFlags;
	self.iDFlagsTime = getTime();
	
	if ( game["state"] == "postgame" )
		return;
	
	if ( self.sessionteam == "spectator" )
		return;
	
	if ( isDefined( self.canDoCombat ) && !self.canDoCombat )
		return;
	
	if ( isDefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( eAttacker.canDoCombat ) && !eAttacker.canDoCombat )
		return;
	
	prof_begin( "Callback_PlayerDamage flags/tweaks" );
	
	// Don't do knockback if the damage direction was not specified
	if( !isDefined( vDir ) )
		iDFlags |= level.iDFLAGS_NO_KNOCKBACK;
	
	friendly = false;

	if ( (level.teamBased && (self.health == self.maxhealth)) || !isDefined( self.attackers ) )
	{
		self.attackers = [];
		self.attackerData = [];
	}

	if ( isHeadShot( sHitLoc, sMeansOfDeath ) )
		sMeansOfDeath = "MOD_HEAD_SHOT";
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "game", "onlyheadshots" ) )
	{
		if ( sMeansOfDeath != "MOD_HEAD_SHOT" )
			return;
		iDamage = 150;
	}

	// explosive barrel/car detection
	if ( sWeapon == "none" && isDefined( eInflictor ) )
	{
		if ( isDefined( eInflictor.targetname ) && eInflictor.targetname == "explodable_barrel" )
			sWeapon = "explodable_barrel";
		else if ( isDefined( eInflictor.destructible_type ) && isSubStr( eInflictor.destructible_type, "vehicle_" ) )
			sWeapon = "destructible_car";
	}

	prof_end( "Callback_PlayerDamage flags/tweaks" );

	// check for completely getting out of the damage
	if( !(iDFlags & level.iDFLAGS_NO_PROTECTION) )
	{
		// return if helicopter friendly fire is on
		if ( level.teamBased && isdefined( level.chopper ) && isdefined( eAttacker ) && eAttacker == level.chopper && eAttacker.team == self.pers["team"] )
		{
			if( level.friendlyfire == 0 )
			{
				prof_end( "Callback_PlayerDamage player" );
				return;
			}
		}
		
		if ( (isSubStr( sMeansOfDeath, "MOD_GRENADE" ) || isSubStr( sMeansOfDeath, "MOD_EXPLOSIVE" ) || isSubStr( sMeansOfDeath, "MOD_PROJECTILE" )) && isDefined( eInflictor ) )
		{
			self.explosiveInfo = [];
			self.explosiveInfo["damageTime"] = getTime();
			self.explosiveInfo["damageId"] = eInflictor getEntityNumber();
			self.explosiveInfo["returnToSender"] = false;
			self.explosiveInfo["counterKill"] = false;
			self.explosiveInfo["chainKill"] = false;
			self.explosiveInfo["cookedKill"] = false;
			self.explosiveInfo["weapon"] = sWeapon;
			
			isFrag = isSubStr( sWeapon, "frag_" );

			if ( eAttacker != self )
			{
				if ( (isSubStr( sWeapon, "c4_" ) || isSubStr( sWeapon, "claymore_" )) && isDefined( eAttacker ) && isDefined( eInflictor.owner ) )
				{
					self.explosiveInfo["returnToSender"] = (eInflictor.owner == self);
					self.explosiveInfo["counterKill"] = isDefined( eInflictor.wasDamaged );
					self.explosiveInfo["chainKill"] = isDefined( eInflictor.wasChained );
					self.explosiveInfo["bulletPenetrationKill"] = isDefined( eInflictor.wasDamagedFromBulletPenetration );
					self.explosiveInfo["cookedKill"] = false;
				}
				if ( isDefined( eAttacker.lastGrenadeSuicideTime ) && eAttacker.lastGrenadeSuicideTime >= gettime() - 50 && isFrag )
				{
					self.explosiveInfo["suicideGrenadeKill"] = true;
				}
				else
				{
					self.explosiveInfo["suicideGrenadeKill"] = false;
				}
			}
			
			if ( isFrag )
			{
				self.explosiveInfo["cookedKill"] = isDefined( eInflictor.isCooked );
				self.explosiveInfo["throwbackKill"] = isDefined( eInflictor.threwBack );
			}
		}

		if ( !issubstr( sMeansOfDeath, "MOD_GRENADE" ) && isPlayer( eAttacker ) )
			eAttacker.pers["participation"]++;
		
		prevHealthRatio = self.health / self.maxhealth;
		
		if ( level.teamBased && isPlayer( eAttacker ) && (self != eAttacker) && (self.pers["team"] == eAttacker.pers["team"]) )
		{
			prof_begin( "Callback_PlayerDamage player" ); // profs automatically end when the function returns
			if ( level.friendlyfire == 0 ) // no one takes damage
			{
				if ( sWeapon == "artillery_mp" )
					self damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage );
				return;
			}
			else if ( level.friendlyfire == 1 ) // the friendly takes damage
			{
				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				
				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
			}
			else if ( level.friendlyfire == 2 ) // only the attacker takes damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if(iDamage < 1)
					iDamage = 1;
				
				eAttacker.lastDamageWasFromEnemy = false;
				
				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			else if ( level.friendlyfire == 3 ) // both friendly and attacker take damage
			{
				iDamage = int(iDamage * .5);

				// Make sure at least one point of damage is done
				if ( iDamage < 1 )
					iDamage = 1;
				
				self.lastDamageWasFromEnemy = false;
				eAttacker.lastDamageWasFromEnemy = false;
				
				self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = true;
				eAttacker finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);
				eAttacker.friendlydamage = undefined;
			}
			
			friendly = true;
		}
		else
		{
			prof_begin( "Callback_PlayerDamage world" );
			// Make sure at least one point of damage is done
			if(iDamage < 1)
				iDamage = 1;

			if ( level.teamBased && isDefined( eAttacker ) && isPlayer( eAttacker ) )
			{
				if ( !isdefined( self.attackerData[eAttacker.clientid] ) )
				{
					self.attackers[ self.attackers.size ] = eAttacker;
					// we keep an array of attackers by their client ID so we can easily tell
					// if they're already one of the existing attackers in the above if().
					// we store in this array data that is useful for other things, like challenges
					self.attackerData[eAttacker.clientid] = false;
				}
				if ( maps\mp\gametypes\_weapons::isPrimaryWeapon( sWeapon ) )
					self.attackerData[eAttacker.clientid] = true;
			}
			
			if ( isdefined( eAttacker ) )
				level.lastLegitimateAttacker = eAttacker;

			if ( isdefined( eAttacker ) && isPlayer( eAttacker ) && isDefined( sWeapon ) )
				eAttacker maps\mp\gametypes\_weapons::checkHit( sWeapon );

			/*			
			if ( isPlayer( eInflictor ) )
				eInflictor maps\mp\gametypes\_persistence::statAdd( "hits", 1 );
			*/

			if ( issubstr( sMeansOfDeath, "MOD_GRENADE" ) && isDefined( eInflictor.isCooked ) )
				self.wasCooked = getTime();
			else
				self.wasCooked = undefined;
			
			self.lastDamageWasFromEnemy = (isDefined( eAttacker ) && (eAttacker != self));
			
			self finishPlayerDamageWrapper(eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime);

			self thread maps\mp\gametypes\_missions::playerDamaged(eInflictor, eAttacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );

			prof_end( "Callback_PlayerDamage world" );
		}

		if ( isdefined(eAttacker) && eAttacker != self )
		{
			hasBodyArmor = false;
			if ( self hasPerk( "specialty_armorvest" ) )
			{
				damageScalar = level.cac_armorvest_data / 100;
				if ( prevHealthRatio > damageScalar )
					hasBodyArmor = true;
			}
			eAttacker thread maps\mp\gametypes\_damagefeedback::updateDamageFeedback( hasBodyArmor );
		}
		
		self.hasDoneCombat = true;
	}

	if ( isdefined( eAttacker ) && eAttacker != self && !friendly )
		level.useStartSpawns = false;

	prof_begin( "Callback_PlayerDamage log" );

	// Do debug print if it's enabled
	if(getDvarInt("g_debugDamage"))
		println("client:" + self getEntityNumber() + " health:" + self.health + " attacker:" + eAttacker.clientid + " inflictor is player:" + isPlayer(eInflictor) + " damage:" + iDamage + " hitLoc:" + sHitLoc);

	if(self.sessionstate != "dead")
	{
		lpselfnum = self getEntityNumber();
		lpselfname = self.name;
		lpselfteam = self.pers["team"];
		lpselfGuid = self getGuid();
		lpattackerteam = "";

		if(isPlayer(eAttacker))
		{
			lpattacknum = eAttacker getEntityNumber();
			lpattackGuid = eAttacker getGuid();
			lpattackname = eAttacker.name;
			lpattackerteam = eAttacker.pers["team"];
		}
		else
		{
			lpattacknum = -1;
			lpattackGuid = "";
			lpattackname = "";
			lpattackerteam = "world";
		}

		logPrint("D;" + lpselfGuid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackGuid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n");
	}

	prof_end( "Callback_PlayerDamage log" );
}

finishPlayerDamageWrapper( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime )
{
	self finishPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, psOffsetTime );
	
	if ( getDvar( "scr_csmode" ) != "" )
		self shellShock( "damage_mp", 0.2 );
	
	self damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage );
}

damageShellshockAndRumble( eInflictor, sWeapon, sMeansOfDeath, iDamage )
{
	self thread maps\mp\gametypes\_weapons::onWeaponDamage( eInflictor, sWeapon, sMeansOfDeath, iDamage );
	self PlayRumbleOnEntity( "damage_heavy" );
}


Callback_PlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	self endon( "spawned" );
	self notify( "killed_player" );

	if(self.sessionteam == "spectator")
		return;

	if ( game["state"] == "postgame" )
		return;

	prof_begin( "PlayerKilled pre constants" );

	deathTimeOffset = 0;
	if ( isdefined( self.useLastStandParams ) )
	{
		self.useLastStandParams = undefined;
		
		assert( isdefined( self.lastStandParams ) );
		
		eInflictor = self.lastStandParams.eInflictor;
		attacker = self.lastStandParams.attacker;
		iDamage = self.lastStandParams.iDamage;
		sMeansOfDeath = self.lastStandParams.sMeansOfDeath;
		sWeapon = self.lastStandParams.sWeapon;
		vDir = self.lastStandParams.vDir;
		sHitLoc = self.lastStandParams.sHitLoc;
		
		deathTimeOffset = (gettime() - self.lastStandParams.lastStandStartTime) / 1000;
		
		self.lastStandParams = undefined;
	}
	
	// If the player was killed by a head shot, let players know it was a head shot kill
	if((sHitLoc == "head" || sHitLoc == "helmet") && sMeansOfDeath != "MOD_MELEE")
		sMeansOfDeath = "MOD_HEAD_SHOT";

	if( attacker.classname == "script_vehicle" && isDefined( attacker.owner ) )
		attacker = attacker.owner;

	// send out an obituary message to all clients about the kill
	if( level.teamBased && isDefined( attacker.pers ) && self.pers["team"] == attacker.pers["team"] && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
		obituary(self, self, sWeapon, sMeansOfDeath);
	else
		obituary(self, attacker, sWeapon, sMeansOfDeath);

//	self maps\mp\gametypes\_weapons::updateWeaponUsageStats();
	self maps\mp\gametypes\_weapons::dropWeaponForDeath( attacker );
	self maps\mp\gametypes\_weapons::dropOffhand();

	maps\mp\gametypes\_spawnlogic::deathOccured(self, attacker);

	self.sessionstate = "dead";
	self.statusicon = "hud_status_dead";

	self.pers["weapon"] = undefined;
	
	self.killedPlayersCurrent = [];

	if( !isDefined( self.switching_teams ) )
	{
		// if team killed we reset kill streak, but dont count death and death streak
		if ( isPlayer( attacker ) && level.teamBased && ( attacker != self ) && ( self.pers["team"] == attacker.pers["team"] ) )
		{
			self.cur_kill_streak = 0;
		}
		else
		{		
			self incPersStat( "deaths", 1 );
			self.deaths = self getPersStat( "deaths" );	
			self updatePersRatio( "kdratio", "kills", "deaths" );
			
			self.cur_kill_streak = 0;
			self.cur_death_streak++;
			
			if ( self.cur_death_streak > self.death_streak )
			{
				self maps\mp\gametypes\_persistence::statSet( "death_streak", self.cur_death_streak );
				self.death_streak = self.cur_death_streak;
			}
		}
	}
	
	lpselfnum = self getEntityNumber();
	lpselfname = self.name;
	lpattackGuid = "";
	lpattackname = "";
	lpselfteam = "";
	lpselfguid = self getGuid();
	lpattackerteam = "";

	lpattacknum = -1;
	
	prof_end( "PlayerKilled pre constants" );

	if( isPlayer( attacker ) )
	{
		lpattackGuid = attacker getGuid();
		lpattackname = attacker.name;

		if ( attacker == self ) // killed himself
		{
			prof_begin( "PlayerKilled suicide" );

			doKillcam = false;

			// switching teams
			if ( isDefined( self.switching_teams ) )
			{
				if ( !level.teamBased && ((self.leaving_team == "allies" && self.joining_team == "axis") || (self.leaving_team == "axis" && self.joining_team == "allies")) )
				{
					playerCounts = maps\mp\gametypes\_teams::CountPlayers();
					playerCounts[self.leaving_team]--;
					playerCounts[self.joining_team]++;
				
					if( (playerCounts[self.joining_team] - playerCounts[self.leaving_team]) > 1 )
					{
						self thread [[level.onXPEvent]]( "suicide" );
						self incPersStat( "suicides", 1 );
						self.suicides = self getPersStat( "suicides" );
					}
				}
			}
			else
			{
				self thread [[level.onXPEvent]]( "suicide" );
				self incPersStat( "suicides", 1 );
				self.suicides = self getPersStat( "suicides" );

				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "suicidepointloss" );
				_setPlayerScore( self, _getPlayerScore( self ) - scoreSub );

				if ( sMeansOfDeath == "MOD_SUICIDE" && sHitLoc == "none" && self.throwingGrenade )
				{
					self.lastGrenadeSuicideTime = gettime();
				}
			}
			
			if( isDefined( self.friendlydamage ) )
				self iPrintLn(&"MP_FRIENDLY_FIRE_WILL_NOT");

			prof_end( "PlayerKilled suicide" );
		}
		else
		{
			prof_begin( "PlayerKilled attacker" );

			lpattacknum = attacker getEntityNumber();

			doKillcam = true;

			if( level.teamBased && self.pers["team"] == attacker.pers["team"] && sMeansOfDeath == "MOD_GRENADE" && level.friendlyfire == 0 )
			{		
			}
			else if( level.teamBased && self.pers["team"] == attacker.pers["team"] ) // killed by a friendly
			{
				attacker thread [[level.onXPEvent]]( "teamkill" );

				attacker.pers["teamkills"] += 1.0;
				
				attacker.teamkillsThisRound++;

				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "team", "teamkillpointloss" );
				_setPlayerScore( attacker, _getPlayerScore( attacker ) - scoreSub );
				
				teamKillDelay = attacker TeamKillDelay();
				if ( teamKillDelay > 0 )
				{
					attacker.teamKillPunish = true;
					attacker suicide();
					attacker thread reduceTeamKillsOverTime();
				}
			}
			else
			{
				prof_begin( "PlayerKilled stats1" );
				if ( sMeansOfDeath == "MOD_HEAD_SHOT" )
				{
					attacker incPersStat( "headshots", 1 );
					attacker.headshots = attacker getPersStat( "headshots" );

					if ( isDefined( attacker.lastStand ) )
						value = maps\mp\gametypes\_rank::getScoreInfoValue( "headshot" ) * 2;
					else
						value = undefined;

					attacker thread maps\mp\gametypes\_rank::giveRankXP( "headshot", value );
					attacker playLocalSound( "bullet_impact_headshot_2" );
				}
				else
				{
					if ( isDefined( attacker.lastStand ) )
						value = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) * 2;
					else
						value = undefined;

					attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", value );
				}
				prof_end( "PlayerKilled stats1" );
				
				prof_begin( "PlayerKilled stats2" );
				
				attacker incPersStat( "kills", 1 );
				attacker.kills = attacker getPersStat( "kills" );
				attacker updatePersRatio( "kdratio", "kills", "deaths" );
				
				attacker.cur_kill_streak++;
				
				if ( isDefined( level.hardpointItems ) && isAlive( attacker ) )
					attacker thread maps\mp\gametypes\_hardpoints::giveHardpointItemForStreak();

				prof_end( "PlayerKilled stats2" );
				
				prof_begin( "PlayerKilled stats3" );
				
				attacker.cur_death_streak = 0;
				
				if ( attacker.cur_kill_streak > attacker.kill_streak )
				{
					attacker maps\mp\gametypes\_persistence::statSet( "kill_streak", attacker.cur_kill_streak );
					attacker.kill_streak = attacker.cur_kill_streak;
				}
				
				givePlayerScore( "kill", attacker, self );
				if ( !isDefined( attacker.killedPlayers[self.name] ) )
					attacker.killedPlayers[self.name] = 0;

				if ( !isDefined( attacker.killedPlayersCurrent[self.name] ) )
					attacker.killedPlayersCurrent[self.name] = 0;
					
				attacker.killedPlayers[self.name]++;
				attacker.killedPlayersCurrent[self.name]++;
				
				if ( !isDefined( self.killedBy[attacker.name] ) )
					self.killedBy[attacker.name] = 0;
					
				self.killedBy[attacker.name]++;
				
				// helicopter score for team
				if( level.teamBased && isdefined( level.chopper ) && isdefined( Attacker ) && Attacker == level.chopper )
					giveTeamScore( "kill", attacker.team,  attacker, self );
				
				// to prevent spectator gain score for team-spectator after throwing a granade and killing someone before he switched
				if ( level.teamBased && attacker.pers["team"] != "spectator")
					giveTeamScore( "kill", attacker.pers["team"],  attacker, self );
				
				scoreSub = maps\mp\gametypes\_tweakables::getTweakableValue( "game", "deathpointloss" );
				_setPlayerScore( self, _getPlayerScore( self ) - scoreSub );
				
				level thread maps\mp\gametypes\_battlechatter_mp::sayLocalSoundDelayed( attacker, "kill", 0.75 );
				prof_end( "PlayerKilled stats3" );
				
				if ( level.teamBased )
				{
					prof_begin( "PlayerKilled assists" );
					
					if ( isdefined( self.attackers ) )
					{
						for ( j = 0; j < self.attackers.size; j++ )
						{
							player = self.attackers[j];
							
							if ( !isDefined( player ) )
								continue;
							
							if ( player == attacker )
								continue;
							
							player thread processAssist( self );
						}
						self.attackers = [];
					}
					
					prof_begin( "PlayerKilled assists" );
				}
			}
			
			prof_end( "PlayerKilled attacker" );
		}
	}
	else
	{
		prof_begin( "PlayerKilled world" );
		doKillcam = false;
		killedByEnemy = false;

		lpattacknum = -1;
		lpattackguid = "";
		lpattackname = "";
		lpattackerteam = "world";

		// even if the attacker isn't a player, it might be on a team
		if ( isDefined( attacker ) && isDefined( attacker.team ) && (attacker.team == "axis" || attacker.team == "allies") )
		{
			if ( attacker.team != self.pers["team"] ) 
			{
				killedByEnemy = true;
				if ( level.teamBased )
					giveTeamScore( "kill", attacker.team, attacker, self );
			}
		}
		prof_end( "PlayerKilled world" );
	}			
			
	prof_begin( "PlayerKilled post constants" );

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker != self && (!level.teambased || attacker.pers["team"] != self.pers["team"]) )
		self thread maps\mp\gametypes\_missions::playerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, sHitLoc );
	else
		self notify("playerKilledChallengesProcessed");
	
	logPrint( "K;" + lpselfguid + ";" + lpselfnum + ";" + lpselfteam + ";" + lpselfname + ";" + lpattackguid + ";" + lpattacknum + ";" + lpattackerteam + ";" + lpattackname + ";" + sWeapon + ";" + iDamage + ";" + sMeansOfDeath + ";" + sHitLoc + "\n" );

	level thread [[level.updateTeamStatus]]();

	body = self clonePlayer( deathAnimDuration );
	thread delayStartRagdoll( body );

	self.body = body;
	if ( !isDefined( self.switching_teams ) )
		thread maps\mp\gametypes\_deathicons::addDeathicon( body, self, self.pers["team"], 7.0 );
	
	self.switching_teams = undefined;
	self.joining_team = undefined;
	self.leaving_team = undefined;

	self thread [[level.onPlayerKilled]](eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration);

	if ( sWeapon == "artillery_mp" || sWeapon == "claymore_mp" || sWeapon == "none" || isSubStr( sWeapon, "cobra" ) )
		doKillcam = false;
	
	// let the player watch themselves die
	postDeathDelay = waitForTimeOrNotifies( 2 );
	
	if ( game["state"] != "playing" )
		return;
	
	respawnTimerStartTime = gettime();
	
	if ( doKillcam && level.killcam && !level.splitscreen )
	{
		livesLeft = !(level.numLives && !self.pers["lives"]);
		timeUntilSpawn = TimeUntilSpawn( true );
		willRespawnImmediately = livesLeft && (timeUntilSpawn <= 0);
		
		perks = getPerks( attacker );
		
		self maps\mp\gametypes\_killcam::killcam( lpattacknum, sWeapon, postDeathDelay + deathTimeOffset, psOffsetTime, willRespawnImmediately, timeUntilRoundEnd(), perks );
	}
	
	prof_end( "PlayerKilled post constants" );
	
	// class may be undefined if we have changed teams
	if ( isValidClass( self.pers["class"] ) )
	{
		timePassed = (gettime() - respawnTimerStartTime) / 1000;
		self thread [[level.spawnClient]]( timePassed );
	}
}

waitForTimeOrNotifies( desiredDelay )
{
	startedWaiting = getTime();
	
	while( self.doingNotify )
		wait ( 0.05 );

	waitedTime = (getTime() - startedWaiting)/1000;
	
	if ( waitedTime < desiredDelay )
	{
		wait desiredDelay - waitedTime;
		return desiredDelay;
	}
	else
	{
		return waitedTime;
	}
}

reduceTeamKillsOverTime()
{
	timePerOneTeamkillReduction = 20.0;
	reductionPerSecond = 1.0 / timePerOneTeamkillReduction;
	
	while(1)
	{
		if ( isAlive( self ) )
		{
			self.pers["teamkills"] -= reductionPerSecond;
			if ( self.pers["teamkills"] < level.minimumAllowedTeamKills )
			{
				self.pers["teamkills"] = level.minimumAllowedTeamKills;
				break;
			}
		}
		wait 1;
	}
}

getPerks( player )
{
	perks[0] = "specialty_null";
	perks[1] = "specialty_null";
	perks[2] = "specialty_null";
	
	if ( isPlayer( player ) && !level.oldschool )
	{
		if ( level.onlineGame && !isdefined( player.isBot ) )
		{
			class_num = player.class_num;
			if ( isDefined( player.custom_class[class_num]["specialty1"] ) )
				perks[0] = player.custom_class[class_num]["specialty1"];
			if ( isDefined( player.custom_class[class_num]["specialty2"] ) )
				perks[1] = player.custom_class[class_num]["specialty2"];
			if ( isDefined( player.custom_class[class_num]["specialty3"] ) )
				perks[2] = player.custom_class[class_num]["specialty3"];
		}
		else
		{
			if ( isDefined( level.default_perk[player.curClass][0] ) )
				perks[0] = level.default_perk[player.curClass][0];
			if ( isDefined( level.default_perk[player.curClass][1] ) )
				perks[1] = level.default_perk[player.curClass][1];
			if ( isDefined( level.default_perk[player.curClass][2] ) )
				perks[2] = level.default_perk[player.curClass][2];
		}
	}
	
	return perks;
}

processAssist( killedplayer )
{
	self endon("disconnect");
	killedplayer endon("disconnect");
	
	wait .05; // don't ever run on the same frame as the playerkilled callback.
	WaitTillSlowProcessAllowed();
	
	if ( self.pers["team"] != "axis" && self.pers["team"] != "allies" )
		return;
	
	if ( self.pers["team"] == killedplayer.pers["team"] )
		return;
	
	self thread [[level.onXPEvent]]( "assist" );
	self incPersStat( "assists", 1 );
	self.assists = self getPersStat( "assists" );
	
	givePlayerScore( "assist", self, killedplayer );
	giveTeamScore( "assist", self.pers["team"], self, killedplayer );
	
	self thread maps\mp\gametypes\_missions::playerAssist();
}

Callback_PlayerLastStand( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	self.health = 1;
	
	self.lastStandParams = spawnstruct();
	self.lastStandParams.eInflictor = eInflictor;
	self.lastStandParams.attacker = attacker;
	self.lastStandParams.iDamage = iDamage;
	self.lastStandParams.sMeansOfDeath = sMeansOfDeath;
	self.lastStandParams.sWeapon = sWeapon;
	self.lastStandParams.vDir = vDir;
	self.lastStandParams.sHitLoc = sHitLoc;
	self.lastStandParams.lastStandStartTime = gettime();
	
	mayDoLastStand = mayDoLastStand( sMeansOfDeath, sHitLoc );
	/#
	if ( getdvar("scr_forcelaststand" ) == "1" )
		mayDoLastStand = true;
	#/
	if ( !mayDoLastStand )
	{
		self.useLastStandParams = true;
		self suicide();
		return;
	}
	
	weaponslist = self getweaponslist();
	assertex( isdefined( weaponslist ) && weaponslist.size > 0, "Player's weapon(s) missing before dying -=Last Stand=-" );

	self thread maps\mp\gametypes\_gameobjects::onPlayerLastStand();
	
	self maps\mp\gametypes\_weapons::dropWeaponForDeath( attacker );

	self thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "Last Stand!", undefined, "specialty_pistoldeath", (1,0,0), "mp_last_stand" );

	grenadeTypePrimary = "frag_grenade_mp";

	// check if player has pistol
	for( i = 0; i < weaponslist.size; i++ )
	{
		weapon = weaponslist[i];
		if ( maps\mp\gametypes\_weapons::isPistol( weapon ) )
		{
			// take away all weapon and leave this pistol
			self takeallweapons();
			self giveweapon( weapon );
			self giveMaxAmmo( weapon );
			self switchToWeapon( weapon );
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
			self SwitchToOffhand( grenadeTypePrimary );
			self thread lastStandTimer( 10 );
			return;
		}
	}
	self takeallweapons();
	self giveWeapon( "beretta_mp" );
	self giveMaxAmmo( "beretta_mp" );
	self switchToWeapon( "beretta_mp" );
	self GiveWeapon( grenadeTypePrimary );
	self SetWeaponAmmoClip( grenadeTypePrimary, 0 );
	self SwitchToOffhand( grenadeTypePrimary );
	self thread lastStandTimer( 10 );
}


lastStandTimer( delay )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );
	
	self thread lastStandWaittillDeath();
	
	self.lastStand = true;
	self setLowerMessage( &"PLATFORM_COWARDS_WAY_OUT" );
	
	self thread lastStandAllowSuicide();

	wait delay;
	
	self thread LastStandBleedOut();
}

LastStandBleedOut()
{
	self.useLastStandParams = true;
	self suicide();
}

lastStandAllowSuicide()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "game_ended" );
	
	while(1)
	{
		if ( self useButtonPressed() )
		{
			pressStartTime = gettime();
			while ( self useButtonPressed() )
			{
				wait .05;
				if ( gettime() - pressStartTime > 700 )
					break;
			}
			if ( gettime() - pressStartTime > 700 )
				break;
		}
		wait .05;
	}
	
	self thread LastStandBleedOut();
}

lastStandWaittillDeath()
{
	self endon( "disconnect" );
	
	self waittill( "death" );
	
	self clearLowerMessage();
	self.lastStand = undefined;
}

mayDoLastStand( sMeansOfDeath, sHitLoc )
{
	if ( sMeansOfDeath != "MOD_PISTOL_BULLET" && sMeansOfDeath != "MOD_RIFLE_BULLET" )
		return false;
	
	if ( isHeadShot( sHitLoc, sMeansOfDeath ) )
		return false;
	
	return true;
}

setSpawnVariables()
{
	resetTimeout();

	// Stop shellshock and rumble
	self StopShellshock();
	self StopRumble( "damage_heavy" );
}

notifyConnecting()
{
	waittillframeend;

	if( isDefined( self ) )
		level notify( "connecting", self );
}


setObjectiveText( team, text )
{
	game["strings"]["objective_"+team] = text;
	precacheString( text );
}

setObjectiveScoreText( team, text )
{
	game["strings"]["objective_score_"+team] = text;
	precacheString( text );
}

setObjectiveHintText( team, text )
{
	game["strings"]["objective_hint_"+team] = text;
	precacheString( text );
}

getObjectiveText( team )
{
	return game["strings"]["objective_"+team];
}

getObjectiveScoreText( team )
{
	return game["strings"]["objective_score_"+team];
}

getObjectiveHintText( team )
{
	return game["strings"]["objective_hint_"+team];
}

delayStartRagdoll( ent )
{
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();
		if ( animhasnotetrack( deathAnim, "ignore_ragdoll" ) )
			return;
	}

	wait( 0.2 );
	
	if ( isDefined( ent ) )
	{
		deathAnim = ent getcorpseanim();

		startFrac = 0.35;

		if ( animhasnotetrack( deathAnim, "start_ragdoll" ) )
		{
			times = getnotetracktimes( deathAnim, "start_ragdoll" );
			if ( isDefined( times ) )
				startFrac = times[0];
		}

		waitTime = startFrac * getanimlength( deathAnim );
		wait( waitTime );

		if ( isDefined( ent ) )
		{
			println( "Ragdolling after " + waitTime + " seconds" );
			ent startragdoll( 1 );
		}
	}
}


leaderDialog( dialog, team, group )
{
	assert( isdefined( level.players ) );
	
	if ( level.splitscreen )
	{
		if ( level.players.size )
			level.players[0] leaderDialogOnPlayer( dialog, group );
		return;
	}

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( !isDefined( team ) || (isDefined( player.pers["team"] ) && (player.pers["team"] == team )) )
			player leaderDialogOnPlayer( dialog, group );
	}
}


leaderDialogOnPlayer( dialog, group )
{
	team = self.pers["team"];
	
	if ( team != "allies" && team != "axis" )
		return;

	if ( isDefined( group ) )
	{
		// ignore the message if one from the same group is already playing
		if ( self.leaderDialogGroup == group )
			return;
			
		self.leaderDialogGroups[group] = dialog;
		dialog = group;
	}

	if ( !self.leaderDialogActive )
		self thread playLeaderDialogOnPlayer( dialog, team );
	else
		self.leaderDialogQueue[self.leaderDialogQueue.size] = dialog;
}


playLeaderDialogOnPlayer( dialog, team )
{
	self endon ( "disconnect" );
	
	self.leaderDialogActive = true;
	if ( isDefined( self.leaderDialogGroups[dialog] ) )
	{
		group = dialog;
		dialog = self.leaderDialogGroups[group];
		self.leaderDialogGroups[group] = undefined;
		self.leaderDialogGroup = group;
	}

	self playLocalSound( game["voice"][team]+game["dialog"][dialog] );

	wait ( 3.0 );
	self.leaderDialogActive = false;
	self.leaderDialogGroup = "";

	if ( self.leaderDialogQueue.size > 0 )
	{
		nextDialog = self.leaderDialogQueue[0];
		
		for ( i = 1; i < self.leaderDialogQueue.size; i++ )
			self.leaderDialogQueue[i-1] = self.leaderDialogQueue[i];
		self.leaderDialogQueue[i-1] = undefined;
		
		self thread playLeaderDialogOnPlayer( nextDialog, team );
	}
}


getMostKilledBy()
{
	mostKilledBy = "";
	killCount = 0;
	
	killedByNames = getArrayKeys( self.killedBy );
	
	for ( index = 0; index < killedByNames.size; index++ )
	{
		killedByName = killedByNames[index];
		if ( self.killedBy[killedByName] <= killCount )
			continue;
		
		killCount = self.killedBy[killedByName];
		mostKilleBy = killedByName;
	}
	
	return mostKilledBy;
}


getMostKilled()
{
	mostKilled = "";
	killCount = 0;
	
	killedNames = getArrayKeys( self.killedPlayers );
	
	for ( index = 0; index < killedNames.size; index++ )
	{
		killedName = killedNames[index];
		if ( self.killedPlayers[killedName] <= killCount )
			continue;
		
		killCount = self.killedPlayers[killedName];
		mostKilled = killedName;
	}
	
	return mostKilled;
}