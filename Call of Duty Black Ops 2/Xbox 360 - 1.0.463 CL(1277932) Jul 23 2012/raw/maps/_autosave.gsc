#include maps\_utility;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;

main()
{
	level.lastAutoSaveTime = 0;
	flag_init( "game_saving" );
	flag_init( "can_save", true );
}

block_save()
{
	DEFAULT( level.block_save_count, 0 );
	
	level.block_save_count++;
	flag_clear( "can_save" );
}

allow_save()
{
	DEFAULT( level.block_save_count, 0 );
	
	if ( level.block_save_count > 0 )
	{
		level.block_save_count--;
	}
	
	if ( level.block_save_count == 0 )
	{
		flag_set( "can_save" );		
	}
}

autosave_description()
{
	return( &"AUTOSAVE_AUTOSAVE" );
}

autosave_names( num )
{
	if( num == 0 )
	{
		savedescription = &"AUTOSAVE_GAME";
	}
	else
	{
		savedescription = &"AUTOSAVE_NOGAME";
	}
		
	return savedescription;
}

start_level_save()
{
	flag_wait( "all_players_connected" );

	// Wait for introscreen to start fading out, then save
	flag_wait( "starting final intro screen fadeout" );
	wait( 0.5 );

	// Make sure player has been given weapon already
	
	players = get_players();
	players[0] player_flag_wait( "loadout_given" );
	
	// MikeD: If createFX is enable do not save...
	if( level.createFX_enabled )
	{
		return;
	}

	if( level.missionfailed )
	{
		return;
	}
		
	if( flag( "game_saving" ) )
	{
		return;
	}
		
	flag_set( "game_saving" );
		
	imagename = "levelshots/autosave/autosave_" + level.script + "start";

	for( i = 0; i < players.size; i++ )
	{
		players[i].savedVisionSet = players[i] GetVisionSetNaked();
	}

/#
	auto_save_print( "start_level_save: Start of level save" );
#/

	// "levelstart" is recognized by the saveGame command as a special save game
//	if( GetDvar( "credits" ) != 1 )  // no start game autosave on credits map.  Res
	SaveGame( "levelstart", &"AUTOSAVE_LEVELSTART", imagename, true );
	SetDvar( "ui_grenade_death", "0" );
	/#println( "Saving level start saved game" );#/
	
	flag_clear( "game_saving" );
}


trigger_autosave( trigger )
{
	if( !IsDefined( trigger.script_autosave ) )
	{
		trigger.script_autosave = 0;
	}
		
	autosave_think( trigger );
}

autosave_think( trigger )
{
//	savedescription = autosave_names( trigger.script_autosave );

//	if( !( IsDefined( savedescription ) ) )
//	{
//		println( "autosave", self.script_autosave, " with no save description in _autosave.gsc!" );
//		return;
//	}

	trigger waittill( "trigger", ent );
	
	num = trigger.script_autosave;
	imagename = "levelshots/autosave/autosave_" + level.script + num;

	try_auto_save( num, /*savedescription,*/ imagename, /*undefined,*/ ent );

	if( IsDefined( trigger ) )
	{
		wait 2; // TFLAME - wait to allow triggers with multi functionality to finish their other stuff
		trigger delete();
	}
}

autosave_name_think( trigger )
{
	trigger endon( "death" );
	trigger trigger_wait();
	
	if( IsDefined( level.customautosavecheck ) )
	{
		if( ![[level.customautosavecheck]]() )
		{
			return;
		}
	}

	maps\_utility::set_breadcrumbs_player_positions();
	maps\_utility::autosave_by_name( trigger.script_autosavename );
}


trigger_autosave_immediate( trigger )
{
	trigger waittill( "trigger" );
//	saveId = saveGameNoCommit( 1, &"AUTOSAVE_LEVELSTART", "autosave_image" );
//	commitSave( saveId );
}

/#
auto_save_print( msg, msg2 )
{
	msg = "     AUTOSAVE: " + msg;

	if( GetDvar( "scr_autosave_debug" ) == "" )
	{
		SetDvar( "scr_autosave_debug", "0" );
	}

	if( getdebugdvarint( "scr_autosave_debug" ) == 1 )
	{
		if( IsDefined( msg2 ) )
		{
			println( msg + "[localized description]" );
		}
		else
		{
			println( msg );
		}
		return;
	}

	
	if( IsDefined( msg2 ) )
	{
		println( msg, msg2 );
	}
	else
	{
		println( msg );
	}
}
#/

autosave_game_now( suppress_print )
{
	if( flag( "game_saving" ) )
	{
		return false;
	}
		
	if( !IsAlive( get_host() ) )
	{
		return false;
	}
	
	filename = "save_now";
	descriptionString = autosave_description();
	
	players = get_players();
	for( i = 0; i < players.size; i++ )
	{
		players[i].savedVisionSet = players[i] GetVisionSetNaked();
	}
	if( IsDefined( suppress_print ) )
	{
		saveId = saveGameNoCommit( filename, descriptionString, "$default", true );
	}
	else
	{
		saveId = saveGameNoCommit( filename, descriptionString );
	}
		
	wait( 0.05 ); // code request
	if( isSaveRecentlyLoaded() )
	{
		
/#
		auto_save_print( "autosave_game_now: FAILED!!! -> save error - recently loaded." );
#/
		level.lastAutoSaveTime = GetTime();
		return false;
	}
	
/#
	auto_save_print( "autosave_game_now: Saving game " + filename + " with desc ", descriptionString );
#/
	
	if( saveId < 0 )
	{
/#
		auto_save_print( "autosave_game_now: FAILED!!! -> save error.: " + filename + " with desc ", descriptionString );
#/
		return false;
	}

	
	if( !try_to_autosave_now() )
	{
		return false;
	}
	
	flag_set( "game_saving" );
	wait 2;

	// are we still healthy 2 seconds later? k save then
	if( try_to_autosave_now() )
	{
		level notify( "save_success" );

		commitSave( saveId );
		SetDvar( "ui_grenade_death", "0" );
	}

	flag_clear( "game_saving" );
	return true;
}

autosave_now_trigger( trigger )
{
	trigger waittill( "trigger" );
	autosave_now();
}

try_to_autosave_now()
{
	if( !issavesuccessful() )
	{
		return false;
	}

	if( !autosave_health_check() )
	{
		return false;
	}
		
	if( !flag( "can_save" ) )
	{
/#
		auto_save_print( "try_to_autosave_now: Can_save flag was clear" );
#/
		return false;
	}

	return true;
}


autosave_check_simple()
{
	if( IsDefined( level.special_autosavecondition ) && ![[level.special_autosavecondition]]() )
	{
		return false;
	}
	
	if( level.missionfailed )
	{
		return false;
	}
	
	if( maps\_laststand::player_any_player_in_laststand() )
	{
	 	return false;
	}
	// safe save check for level specific gameplay conditions
	if( IsDefined( level.savehere ) && !level.savehere )
	{
		return false;
	}
	// safe save check for level specific gameplay conditions
	if( IsDefined( level.canSave ) && !level.canSave )
	{
		return false;
	}
	if( !flag( "can_save" ) )
	{
		return false;
	}
	
	return true;
}

//PARAMETER CLEANUP
try_auto_save( filename, /*description,*/ image,/* timeout, */ent )
{
	if( !flag( "all_players_connected" ) )
	{
		flag_wait( "all_players_connected" );
		wait( 3 );
	}
	
	level endon( "save_success" ); // Kill this thread if a save now occurs

	flag_waitopen( "game_saving" );
	flag_wait( "can_save" );
	flag_set( "game_saving" );
	
	descriptionString = autosave_description();
	
	if(!isdefined(ent))
	{
		ent = get_players()[0];
	}

	maps\_utility::set_breadcrumbs_player_positions();
	
	while(1)
	{
		if( isSaveRecentlyLoaded() )
		{
			level.lastAutoSaveTime = GetTime();
			break;
		}
	
		if( autosave_check() && !isSaveRecentlyLoaded() )
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				players[i].savedVisionSet = players[i] GetVisionSetNaked();
			}

			//"Checkpoint Reached" is silent in COOP per design/JB
			saveId = saveGameNoCommit( filename, descriptionString, image, coopGame() );
						
			if( !IsDefined( saveId ) || saveId < 0 )
			{
				flag_clear( "game_saving" );
				return false;
			}

			wait(6);
			retries = 0;
			while (retries < 8)
			{
				if ( autosave_check_simple() )
				{
					//if a player has died, the game will restart, and we'll have never
					//reached this point.
					commitSave( saveId );
					level.lastSaveTime = GetTime();
					SetDvar( "ui_grenade_death", "0" );
					flag_clear( "game_saving" );
					return true;
				}
				retries++;
				wait(2);
			}
			flag_clear( "game_saving" );
			return false;
		}
		wait(1);
	}
		
	flag_clear( "game_saving" );
	return false;
}

autosave_check( doPickyChecks )
{
	if( IsDefined( level.special_autosavecondition ) && ![[level.special_autosavecondition]]() )
	{
		return false;
	}
	
	if( level.missionfailed )
	{
		return false;
	}
	
	// player in last stand
	if( maps\_laststand::player_any_player_in_laststand() )
	{
	 	return false;
	}
		
	if( !IsDefined( doPickyChecks ) )
	{
		doPickyChecks = true;
	}
		
	// health check
	if( !autosave_health_check() )
	{
		return false;
	}
		
	// ammo check
//	if( doPickyChecks && !autosave_ammo_check() )
//	{
//		return false;
//	}
		
	// ai/tank threat check
	if( !autosave_threat_check( doPickyChecks ) )
	{
		return false;
	}
	
	// player state check
	if( !autosave_player_check() )
	{
		return false;
	}
	
	// safe save check for level specific gameplay conditions
	if( IsDefined( level.dont_save_now ) && level.dont_save_now )
	{
		return false;
	}
	
	if ( !flag( "can_save" ) )
	{
		return false;
	}
	
	// save was unsuccessful for internal reasons, such as lack of memory
	if( !IsSaveSuccessful() )
	{
/#
		auto_save_print( "autosave_check: FAILED!!! -> save call was unsuccessful" );
#/
		return false;
	}
	
	return true;
}

autosave_player_check()
{
	host = get_host();
	if( host IsMeleeing() )
	{
/#
		auto_save_print( "autosave_player_check: FAILED!!! -> host is meleeing" );
#/
		return false;
	}
	
	if( host IsThrowingGrenade() && host GetCurrentOffHand() != "molotov" )
	{
/#
		auto_save_print( "autosave_player_check: FAILED!!! -> host is throwing a grenade" );
#/
		return false;
	}

	if( host IsFiring() )
	{
/#
		auto_save_print( "autosave_player_check: FAILED!!! -> host is firing" );
#/
		return false;
	}

	if( IsDefined( host.shellshocked ) && host.shellshocked )
	{
/#
		auto_save_print( "autosave_player_check: FAILED!!! -> host is in shellshock" );
#/
		return false;
	}

	return true;
}

autosave_health_check()
{
	players = get_players();

	if( players.size > 1 )
	{
		// We only need to check the clients as the host is checked below
		
		for( i = 1; i < players.size; i ++ )
		{
			if( players[i] player_flag( "player_has_red_flashing_overlay" ) )
			{
		/#
				auto_save_print( "autosave_health_check: FAILED!!! -> player " + i + " has red flashing overlay" );
		#/
				return false;
			}
		}
	}

	host = get_host();
	healthFraction = host.health / host.maxhealth;
			
	if( healthFraction < 0.5 )
	{
/#
		auto_save_print( "autosave_health_check: FAILED!!! -> host health too low" );
#/
		return false;
	}
	
	if( host player_flag( "player_has_red_flashing_overlay" ) )
	{
/#
		auto_save_print( "autosave_health_check: FAILED!!! -> host has red flashing overlay" );
#/
		return false;
	}
	
	return true;
}

autosave_threat_check( doPickyChecks )
{
	if( level.script == "see2" )
	{
		return true;
	}

	host = get_host();
	enemies = GetAISpeciesArray( "axis", "all" );
	for( i = 0; i < enemies.size; i++ )
	{
		if( !IsDefined( enemies[i].enemy ) )
		{
			continue;
		}
		
		if( enemies[i].enemy != host )
		{
			continue;
		}

		if( enemies[i].isdog )
		{
			if( DistanceSquared( enemies[i].origin, host.origin ) < ( 384 * 384 ) )
			{
/#
				auto_save_print( "autosave_threat_check: FAILED!!! -> dog near player" );
#/
				return false;
			}

			continue;
		}
			
		// recently shot at the player
		if( enemies[i].a.lastShootTime > GetTime() - 500 )
		{
			if( doPickyChecks || enemies[i] canShootEnemy(0) )
			{
/#
				auto_save_print( "autosave_threat_check: FAILED!!! -> AI firing on player" );
#/
				return false;
			}
		}
		
		if( IS_TRUE(enemies[i].a.isAiming) || IS_TRUE( enemies[i].cornerAiming ) )
		{
			if( enemies[i] animscripts\utility::canSeeEnemy() && enemies[i] canShootEnemy(0) )
			{
/#
				auto_save_print( "autosave_threat_check: FAILED!!! -> AI aiming at player" );
#/
				return false;
			}
		}
			
		// is trying to melee the player
		if( IsDefined( enemies[i].a.personImMeleeing ) && enemies[i].a.personImMeleeing == host )
		{
/#
			auto_save_print( "autosave_threat_check: FAILED!!! -> AI meleeing player" );
#/
			return false;
		}
	}
	
	if( player_is_near_live_grenade() )
	{
		return false;
	}
		
	return true;
}
