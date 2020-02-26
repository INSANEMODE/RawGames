#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Deathmatch
	Objective: 	Score points by eliminating other players
	Map ends:	When one player reaches the score limit, or time limit is reached
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_wager_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			Because Deathmatch doesn't have teams with regard to gameplay or scoring, this effectively sets the available weapons.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 0 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onWagerAwards = ::onWagerAwards;

	game["dialog"]["gametype"] = "ss_start";
	
	level.giveCustomLoadout = ::giveCustomLoadout;
	
	//PrecacheItem( "minigun_wager_mp" );
	//PrecacheItem( "m202_flash_wager_mp" );
	
	PrecacheString( &"MP_SHRP_WEAPONS_CYCLED" );
	PrecacheString( &"MP_SHRP_PENULTIMATE_RND" );
	PrecacheString( &"MP_SHRP_PENULTIMATE_MULTIPLIER" );
	PrecacheString( &"MP_SHRP_RND" );
	PrecacheString( &"MP_SHRP_FINAL_MULTIPLIER" );
	
	PrecacheShader( "perk_times_two" );
	
	game["dialog"]["wm_weapons_cycled"] = "ssharp_cycle_01";
	game["dialog"]["wm_final_weapon"] = "ssharp_fweapon";
	game["dialog"]["wm_bonus_rnd"] = "ssharp_2multi_00";
	game["dialog"]["wm_shrp_rnd"] = "ssharp_sround";
	game["dialog"]["wm_bonus0"] = "boost_gen_05";
	game["dialog"]["wm_bonus1"] = "boost_gen_05";
	game["dialog"]["wm_bonus2"] = "boost_gen_05";
	game["dialog"]["wm_bonus3"] = "boost_gen_05";
	game["dialog"]["wm_bonus4"] = "boost_gen_05";
	game["dialog"]["wm_bonus5"] = "boost_gen_05";
	
	setscoreboardcolumns( "score", "kills", "deaths", "stabs", "x2score" ); 
}

onStartGameType()
{
	SetDvar( "scr_disable_weapondrop", 1 );
	SetDvar( "scr_xpscale", 0 );
	SetDvar( "ui_guncycle", 0 );
	makedvarserverinfo( "ui_guncycle", 0 );
	
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_SHRP" );
	setObjectiveText( "axis", &"OBJECTIVES_SHRP" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SHRP" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SHRP" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_SHRP_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_SHRP_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_SHRP_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_SHRP_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );

	newSpawns = GetEntArray( "mp_wager_spawn", "classname" );
	if (newSpawns.size > 0)
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_wager_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_wager_spawn" );
	}
	else
	{
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dm_spawn" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dm_spawn" );
	}

	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	// use the new spawn logic from the start
	level.useStartSpawns = false;
	
	allowed[0] = "shrp";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	// Fast Hands
	maps\mp\gametypes\_wager::addPowerup( "specialty_fastweaponswitch", "perk", &"PERKS_FAST_HANDS", "perk_fast_hands" );
	maps\mp\gametypes\_wager::addPowerup( "specialty_pin_back", "perk", &"PERKS_FAST_HANDS", "perk_fast_hands" );
	maps\mp\gametypes\_wager::addPowerup( "specialty_fasttoss", "perk", &"PERKS_FAST_HANDS", "perk_fast_hands" );
	maps\mp\gametypes\_wager::addPowerup( "specialty_fastequipmentuse", "perk", &"PERKS_FAST_HANDS", "perk_fast_hands" );

	// Lightweight 
	maps\mp\gametypes\_wager::addPowerup( "specialty_movefaster", "perk", &"PERKS_LIGHTWEIGHT", "perk_lightweight" );

	// Flak Jacket
	maps\mp\gametypes\_wager::addPowerup( "specialty_flakjacket", "perk", &"PERKS_FLAK_JACKET", "perk_flak_jacket" );

	// x2 Score Multiplier
	maps\mp\gametypes\_wager::addPowerup( 2, "score_multiplier", &"PERKS_SCORE_MULTIPLIER", "perk_times_two" );
	
	//addGunToProgression( "minigun_wager" );
	//addGunToProgression( "m202_flash_wager" );
	
	level.displayRoundEndText = false;
	level.QuickMessageToAll = true;
	level thread chooseRandomGuns();
}

addGunToProgression( gunName, altName )
{
	if ( !IsDefined( level.gunProgression ) )
		level.gunProgression = [];
	
	newWeapon = SpawnStruct();
	newWeapon.names = [];
	newWeapon.names[newWeapon.names.size] = gunName;
	if ( IsDefined( altName ) )
		newWeapon.names[newWeapon.names.size] = altName;
	level.gunProgression[level.gunProgression.size] = newWeapon;
}

getRandomGunFromProgression()
{	
	weaponIDKeys = GetArrayKeys( level.tbl_weaponIDs );
	numWeaponIDKeys = weaponIDKeys.size;
	gunProgressionSize = 0;
	if ( isdefined( level.gunProgression ) ) 
	{
		size = level.gunProgression.size;

	}
/#
	debug_weapon =  GetDvar( "scr_shrp_debug_weapon" );
#/
	while ( true )
	{
		randomIndex = RandomInt( numWeaponIDKeys + gunProgressionSize );
		baseWeaponName = "";
		weaponName = "";
		
		if ( randomIndex < numWeaponIDKeys )
		{
			id = random( level.tbl_weaponIDs );
			if ( ( id[ "group" ] != "weapon_launcher" ) && ( id[ "group" ] != "weapon_sniper" ) && ( id[ "group" ] != "weapon_lmg" ) && ( id[ "group" ] != "weapon_assault" ) && ( id[ "group" ] != "weapon_smg" ) && ( id[ "group" ] != "weapon_pistol" ) && ( id[ "group" ] != "weapon_cqb" ) && ( id[ "group" ] != "weapon_special" ) )
				continue;
				
			if ( id[ "reference" ] == "weapon_null" )
				continue;
				
			baseWeaponName = id[ "reference" ];
			attachmentList = id[ "attachment" ];
			weaponName = addRandomAttachmentToWeaponName( baseWeaponName, attachmentList );
		}
		else
		{
			baseWeaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
			weaponName = level.gunProgression[randomIndex - numWeaponIDKeys].names[0];
		}
		
		if ( !IsDefined( level.usedBaseWeapons ) )
		{
			level.usedBaseWeapons = [];
			level.usedBaseWeapons[0] = "strela";
		}
		skipWeapon = false;
		for ( i = 0 ; i < level.usedBaseWeapons.size ; i++ )
		{
			if ( level.usedBaseWeapons[i] == baseWeaponName )
			{
				skipWeapon = true;
				break;
			}
		}
		if ( skipWeapon )
			continue;
		level.usedBaseWeapons[level.usedBaseWeapons.size] = baseWeaponName;
		weaponName = weaponName+"_mp";
/#
		if ( debug_weapon != "" )
		{
			weaponName = debug_weapon;	
		}
#/
		return weaponName;
	}
}

addRandomAttachmentToWeaponName( baseWeaponName, attachmentList )
{
	if ( !IsDefined( attachmentList ) )
		return baseWeaponName;
		
	attachments = StrTok( attachmentList, " " );
	ArrayRemoveValue( attachments, "dw" ); // dw weapon madness in the statstable
	if ( attachments.size <= 0 )
		return baseWeaponName;
		
	attachments[attachments.size] = "";
	attachment = random( attachments );
	if ( attachment == "" )
		return baseWeaponName;
		
	return baseWeaponName+"_"+attachment;
}

waitLongDurationWithHostMigrationPause( nextGunCycleTime, duration )
{
	endtime = gettime() + duration * 1000;
	totalTimePassed = 0;
	
	while ( gettime() < endtime )
	{
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationStarts( (endtime - gettime()) / 1000 );
		
		if ( isDefined( level.hostMigrationTimer ) )
		{
			SetDvar( "ui_guncycle", 0 );
			
			timePassed = maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
			
			totalTimePassed += timePassed;
			endtime += timePassed;
			
/#
			println("[SHRP] timePassed = " + timePassed);
			println("[SHRP] totatTimePassed = " + totalTimePassed);
			println("[SHRP] level.discardTime = " + level.discardTime);
#/			
			SetDvar( "ui_guncycle", nextGunCycleTime + totalTimePassed );
		}
	}
	
	maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	
	return totalTimePassed;
}


gunCycleWaiter( nextGunCycleTime, waitTime )
{
	continueCycling = true;
	SetDvar( "ui_guncycle", nextGunCycleTime );
		
	// Initial wait
	timePassed = waitLongDurationWithHostMigrationPause ( nextGunCycleTime, ( nextGunCycleTime - GetTime() ) / 1000 - 6 );
	nextGunCycleTime += timePassed;

	// Last 6 seconds countdown
	for ( i = 6 ; i > 1 ; i-- )
	{
		for ( j = 0 ; j < level.players.size ; j++ )
			level.players[j] playLocalSound( "uin_timer_wager_beep" );
		timePassed = waitLongDurationWithHostMigrationPause ( nextGunCycleTime, ( nextGunCycleTime - GetTime() ) / 1000 / i );
		nextGunCycleTime += timePassed;
	}
	
	for ( i = 0 ; i < level.players.size ; i++ )
	{
		level.players[i] playLocalSound( "uin_timer_wager_last_beep" );
	}
	if ( ( nextGunCycleTime - GetTime() ) > 0 )
		wait ( ( nextGunCycleTime - GetTime() ) / 1000 );
	
	// Next weapon
	level.shrpRandomWeapon = getRandomGunFromProgression();
	
	for ( i = 0 ; i < level.players.size ; i++ )
	{			
		level.players[i] notify( "remove_planted_weapons" );
		level.players[i] giveCustomLoadout( false, true );
	}
	
	return continueCycling;
}

chooseRandomGuns()
{
	level endon( "game_ended" );
	
	waitTime = 45;
	lightningWaitTime = 15;
	
	level.shrpRandomWeapon = getRandomGunFromProgression();
	
	if ( level.inPrematchPeriod )
		level waittill( "prematch_over" );
		
	gunCycle = 1;
	numGunCycles = int( level.timeLimit * 60 / waitTime + 0.5 );
		
	while( true )
	{
		nextGunCycleTime = gettime() + waitTime * 1000;
		isPenultimateRound = false;
		isSharpshooterRound = ( gunCycle == numGunCycles-1 );
		gunCycleWaiter( nextGunCycleTime, waitTime );
		for ( i = 0 ; i < level.players.size ; i++ )
		{
			if ( gunCycle + 1 == numGunCycles )
				level.players[i] maps\mp\gametypes\_wager::wagerAnnouncer( "wm_final_weapon" );
			else
				level.players[i] maps\mp\gametypes\_wager::wagerAnnouncer( "wm_weapons_cycled" );
		}
		if ( isPenultimateRound )
		{
			level.sharpshooterMultiplier = 2;
			for ( i = 0 ; i < level.players.size ; i++ )
				level.players[i] thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_SHRP_PENULTIMATE_RND", 0, &"MP_SHRP_PENULTIMATE_MULTIPLIER", "wm_bonus_rnd" );
		}
		else if ( isSharpshooterRound )
		{
			lastMultiplier = level.sharpshooterMultiplier;
			if ( !IsDefined( lastMultiplier ) )
				lastMultiplier = 1;
			level.sharpshooterMultiplier = 2;
			SetDvar( "ui_guncycle", 0 );
			for ( i = 0 ; i < level.players.size ; i++ )
				level.players[i] thread maps\mp\gametypes\_wager::queueWagerPopup( &"MP_SHRP_RND", 0, &"MP_SHRP_FINAL_MULTIPLIER", "wm_shrp_rnd" );
			break;
		}
		else
		{
			level.sharpshooterMultiplier = 1;
		}
		gunCycle++;
	}
}

giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	chooseRandomBody = false;
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		chooseRandomBody = true;
	self maps\mp\gametypes\_wager::setupBlankRandomPlayer( takeAllWeapons, chooseRandomBody, level.shrpRandomWeapon );
	self DisableWeaponCycling();
	
	self giveWeapon( level.shrpRandomWeapon );
	self switchToWeapon( level.shrpRandomWeapon );
	self giveWeapon( "knife_mp" );
	
	if ( !IsDefined( alreadySpawned ) || !alreadySpawned )
		self setSpawnWeapon( level.shrpRandomWeapon );
	
	if ( IsDefined( takeAllWeapons ) && !takeAllWeapons )
		self thread takeOldWeapons();
	else
		self EnableWeaponCycling();
		
	return level.shrpRandomWeapon;
}

takeOldWeapons()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "weapon_change", newWeapon );
		if ( newWeapon != "none" )
			break;
	}
	
	weaponsList = self GetWeaponsList();
	for ( i = 0 ; i < weaponsList.size ; i++ )
	{
		if ( ( weaponsList[i] != level.shrpRandomWeapon ) && ( weaponsList[i] != "knife_mp" ) )
			self TakeWeapon( weaponsList[i] );
	}
	
	self EnableWeaponCycling();
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{		
	if ( IsDefined( attacker ) && IsPlayer( attacker ) && ( attacker != self ) )
	{		
		// Track Sharpshooter kills
		if ( IsDefined( level.sharpshooterMultiplier ) && ( level.sharpshooterMultiplier == 2 ) )
		{
			if ( !IsDefined( attacker.pers["x2kills"] ) )
				attacker.pers["x2kills"] = 1;
			else
				attacker.pers["x2kills"]++;
			attacker.x2Kills = attacker.pers["x2kills"];
		}
		else if ( IsDefined( level.sharpshooterMultiplier ) && ( level.sharpshooterMultiplier == 3 ) )
		{
			if ( !IsDefined( attacker.pers["x3kills"] ) )
				attacker.pers["x3kills"] = 1;
			else
				attacker.pers["x3kills"]++;
			attacker.x2Kills = attacker.pers["x3kills"];
		}
		
		// Give next bonus
		currentBonus = attacker.currentBonus;
		if ( !IsDefined( currentBonus ) )
			currentBonus = 0;
		if ( currentBonus < level.powerupList.size )
		{
			attacker maps\mp\gametypes\_wager::givePowerup( level.powerupList[currentBonus] );
			attacker thread maps\mp\gametypes\_wager::wagerAnnouncer( "wm_bonus"+currentBonus );
			currentBonus++;
			attacker.currentBonus = currentBonus;
		}
		
		if ( currentBonus >= level.powerupList.size ) // Play FX for kills with max bonus
		{
			if ( IsDefined( attacker.powerups ) && IsDefined( attacker.powerups.size ) && ( attacker.powerups.size > 0 ) )
			{
				attacker thread maps\mp\gametypes\_wager::pulsePowerupIcon( attacker.powerups.size-1 );
			}
		}
		
		// Give score with multiplier
		scoreMultiplier = 1;
		if ( IsDefined( attacker.scoreMultiplier ) )
			scoreMultiplier = attacker.scoreMultiplier;
			
		scoreIncrease = attacker.score;
		for ( i = 1 ; i <= scoreMultiplier ; i++ )
		{
			if ( sMeansOfDeath == "MOD_MELEE" )
				attacker thread maps\mp\_scoreevents::processScoreEvent( "melee_kill", attacker, self );
			else
				attacker thread maps\mp\_scoreevents::processScoreEvent( "kill", attacker, self );
		}
		scoreIncrease = attacker.score - scoreIncrease;
		if ( scoreMultiplier > 1 || ( IsDefined( level.sharpshooterMultiplier ) && level.sharpshooterMultiplier > 1 ) )
		{
			attacker playLocalSound( "uin_alert_cash_register" );
			attacker.pers["x2score"] += scoreIncrease;
			attacker.x2score = attacker.pers["x2score"];
		}
	}
	
	self.currentBonus = 0;
	self.scoreMultiplier = 1;
	self maps\mp\gametypes\_wager::clearPowerups();
}

onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
	self thread infiniteAmmo();
}

onSpawnPlayer(predictedSpawn)
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "shrp" );
		self thread infiniteAmmo();
	}
}

infiniteAmmo()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	for ( ;; )
	{
		wait( 0.1 );
		
		weapon = self GetCurrentWeapon();
		
		self GiveMaxAmmo( weapon );
	}
}

onWagerAwards()
{
	x2kills = self maps\mp\gametypes\_globallogic_score::getPersStat( "x2kills" );
	if ( !IsDefined( x2kills ) )
		x2kills = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", x2kills, 0 );
	
	headshots = self maps\mp\gametypes\_globallogic_score::getPersStat( "headshots" );
	if ( !IsDefined( headshots ) )
		headshots = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", headshots, 1 );
	
	bestKillstreak = self maps\mp\gametypes\_globallogic_score::getPersStat( "best_kill_streak" );
	if ( !IsDefined( bestKillstreak ) )
		bestKillstreak = 0;
	self maps\mp\gametypes\_persistence::setAfterActionReportStat( "wagerAwards", bestKillstreak, 2 );
}
