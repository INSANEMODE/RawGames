// =============================================================================================================================
// ============================================ HILLSIDE SCRIPT ========================================================
// =============================================================================================================================

//debug

//Scenario scripts should only be used for pointing the variables to named Sapien folders, map bug fixes and map polish.  NO GENERAL SCRIPTS should be copy and pasted
//into the map scripts
// =============================================================================================================================
// ================================================== LEVEL SCRIPT ==================================================================
// =============================================================================================================================

// =============================================================================================================================
// ==================== GLOBALS ==================================================================
// =============================================================================================================================
// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
global long DEF_HILLSIDE_ZONESET_INDEX_EMPTY = 							0;
global long DEF_HILLSIDE_ZONESET_INDEX_ALL = 								1;
global long DEF_HILLSIDE_ZONESET_INDEX_E7M1_START = 				1;
global long DEF_HILLSIDE_ZONESET_INDEX_E9M3 = 							6;

// ======== TITLES ==================================================================
//	global cutscene_title title_destroy = destroy;
//	global cutscene_title title_destroy_1 = destroy_1;
//	global cutscene_title title_destroy_2 = destroy_2;
//	global cutscene_title title_destroy_obj_1 = destroy_obj_1;
//	global cutscene_title title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	global cutscene_title title_destroy_obj_complete_2 = power_core_destroyed;
//	global cutscene_title title_destroy_obj_2 = shields_down;
//	
//	// =================== CINEMATIC TITLES DEFEND ======================
//	
//	global cutscene_title title_defend = defend;
//	global cutscene_title title_defend_1 = defend_1;
//	global cutscene_title title_defend_2 = defend_2;
//	global cutscene_title title_defend_obj_1 = defend_obj_1;
//	global cutscene_title title_defend_obj_complete_1 = defend_obj_complete_1;
//	
//	// =================== CINEMATIC TITLES SWARM ======================
//	
//	global cutscene_title title_swarm = swarm;
//	global cutscene_title title_good_work = good_work;
//	global cutscene_title title_lz_clear = lz_clear;
//	global cutscene_title title_switch_obj_1 = switch_obj_1;
//	global cutscene_title title_swarm_1 = swarm_1;
//	global cutscene_title title_lz_end = lz_end;
//	global cutscene_title title_lz_go_to = lz_go_to;
//	global cutscene_title	title_more_enemies = more_enemies;
//	global cutscene_title	title_not_many_left = not_many_left;
//	//global cutscene_title title_defend_base_safe = defend_base_safe;
//	global cutscene_title title_power_cut = power_cut;
//	global cutscene_title title_objective_3 = objective_3;
//	global cutscene_title title_shut_down_comm = shut_down_comm;
//	global cutscene_title title_shut_down_comm_2 = shut_down_comm_2;
//	global cutscene_title title_first_tower_down = first_tower_down;
//	global cutscene_title title_both_tower_down = both_tower_down;
//	global cutscene_title title_drop_shields = drop_shields;
//	global cutscene_title title_shields_down = shields_down;
//	global cutscene_title title_clear_base = clear_base;
//	global cutscene_title title_clear_base_2 = clear_base_2;
//	global cutscene_title title_get_artifact = get_artifact;
//	global cutscene_title title_got_artifact = got_artifact;
//	global cutscene_title title_secure = secure;
//	global cutscene_title title_get_shard_1 = get_shard_1;
//	global cutscene_title title_get_shard_2 = get_shard_2;
//	global cutscene_title title_get_shard_3 = get_shard_3;
//	global cutscene_title title_got_shard = got_shard;
//	
//	global ai ai_ff_allies_1 = gr_ff_allies_1;
//	global ai ai_ff_allies_2 = gr_ff_allies_2;
//	
//	global boolean mission_is_e1_m5 = false;
//	global boolean mission_is_e2_m2 = false;
//	global boolean mission_is_e4_m4 = false;
//	global boolean b_wait_for_narrative = false;
//player variables for puppeteer
//global object pup_player0 = player0;
//global object pup_player1 = player1;
//global object pup_player2 = player2;
//global object pup_player3 = player3;

script startup f_hillside_startup()
	//Start the intro
//	sleep_until (LevelEventStatus("e1_m5"), 1);
//	print ("******************STARTING E1 M5*********************");
//	designer_zone_activate (e1_m5_palette);
//	mission_is_e1_m5 = true;
//	b_wait_for_narrative = true;
//	ai_ff_all = e1_m5_gr_ff_all;
//	thread(f_start_player_intro());
//
//
//================================================== AI ==================================================================
//
//	ai_ff_phantom_01 = sq_ff_phantom_01;
//	ai_ff_phantom_02 = sq_ff_phantom_02;
//	ai_ff_sq_marines = sq_ff_marines_3;
//
//	
//================================================== OBJECTS ==================================================================
//set crate names
//	f_add_crate_folder(cr_destroy_unsc_cover); //UNSC crates and barriers around the main spawn area
//	f_add_crate_folder(cr_destroy_cov_cover); //cov crates all around the main area
//	//f_add_crate_folder(cr_destroy_shields); //barriers that prevent getting to the top of the ziggurat
//	f_add_crate_folder(dm_destroy_shields); //barriers that prevent getting to the very back
//	f_add_crate_folder(cr_power_core); //crates that blow up at the very back right
//	f_add_crate_folder(cr_defend_unsc_cover);  //UNSC barriers in and around the front middle base
//	f_add_crate_folder(cr_capture); //Cov crates at the very back on the right
//	f_add_crate_folder(sc_destroy_unsc); //UNSC scenery in the main starting area
//	f_add_crate_folder(sc_defend_unsc); //UNSC scenery in the front middle area
//	f_add_crate_folder(v_ff_mac_cannon, 9); //mac cannons in the very back on the right
//	f_add_crate_folder(wp_power_weapons); //power weapons spawns aroung the main front area
//	f_add_crate_folder(cr_base_shields, 11); //shield walls that block in the middle back area
//	f_add_crate_folder(cr_barriers, 12); //shield walls that block the left side walkway
//	f_add_crate_folder(cr_powercore_extras); //powercore fluff objects surrounding it
//	f_add_crate_folder(cr_meadow_cov_cover); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(sc_defend_unsc_2); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_forerunner_cover); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_forerunner_cover_2); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(dm_cave_shields); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(dm_bridge_shields); //Cov Cover and fluff in the meadow
//	f_add_crate_folder(cr_bridge_cov_cover); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_defend_junk); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(eq_defend_junk); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(v_ff_unsc_vehicles); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(cr_bridge_cov_cover_2); //Cov Cover and fluff on the back bridge
//	f_add_crate_folder(dm_destroy_1); //prop objects like covenant computers
//	f_add_crate_folder(cr_unsc_intro_weapons); //gun racks by the intro
//	f_add_crate_folder(sc_cov_cover); //energy barrier shields
//	
//
//	//set ammo crate names
//	f_add_crate_folder(eq_destroy_crates); //ammo crates in main spawn area
//	f_add_crate_folder(eq_defend_1_crates); //ammo crates in front middle area
//	f_add_crate_folder(eq_capture_crates); //ammo crates in the very back right
//	f_add_crate_folder(eq_defend_2_crates); //ammo crates in back middle area
//	
//	
//set spawn folder names
//	firefight_mode_set_crate_folder_at(spawn_points_0, 90); //spawns in the main starting area
//	firefight_mode_set_crate_folder_at(spawn_points_1, 91); //spawns in the front building
//	firefight_mode_set_crate_folder_at(spawn_points_2, 92); //spawns in the back building
//	firefight_mode_set_crate_folder_at(spawn_points_3, 93); //spawns by the left building
//	firefight_mode_set_crate_folder_at(spawn_points_4, 94); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_5, 95); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_6, 96); //spawns in the right side in the way back
//	firefight_mode_set_crate_folder_at(spawn_points_7, 97); //spawns in the back on the hill (facing the back)
//	firefight_mode_set_crate_folder_at(spawn_points_8, 98); //spawns in the very back facing down the hill
//	
//set objective names
//	firefight_mode_set_objective_name_at(destroy_obj_1, 1); //objective in the left building
//	firefight_mode_set_objective_name_at(defend_obj_1, 2); //objective in the front building
//	firefight_mode_set_objective_name_at(defend_obj_2, 3); //objective in the front building
//	firefight_mode_set_objective_name_at(capture_obj_0, 4); //objective in the back middle building
//	firefight_mode_set_objective_name_at(v_mac_cannon_1, 5); //in right side in the WAY back
//	firefight_mode_set_objective_name_at(power_core, 6); //in right side in the WAY back
//	firefight_mode_set_objective_name_at(destroy_obj_2, 7);  //objective on the back middle building
//	firefight_mode_set_objective_name_at(destroy_obj_3, 8);  //objective in the front building
//	firefight_mode_set_objective_name_at(capture_obj_1, 9); //objective in the main starting area
//	firefight_mode_set_objective_name_at(objective_switch_1, 10); //touchscreen switch in the back middle base
//	firefight_mode_set_objective_name_at(defend_obj_3, 11); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_4, 12); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_5, 13); //objective in the middle back building
//	firefight_mode_set_objective_name_at(defend_obj_6, 14); //objective in the middle back building
//	firefight_mode_set_objective_name_at(power_core_meadow, 15); //objective in the meadow
//	firefight_mode_set_objective_name_at(dc_object_1, 16); //covenant computer terminal switch on the close end of the bridge
//	firefight_mode_set_objective_name_at(dm_object_1, 17); //covenant computer terminal on the close end of the bridge
//	
//	firefight_mode_set_objective_name_at(capture_obj_2, 18); //objective in the way back on the right
//	firefight_mode_set_objective_name_at(objective_switch_2, 19); //touchscreen switch in the left building
//	firefight_mode_set_objective_name_at(objective_switch_3, 20); //touchscreen switch in the front building
//	firefight_mode_set_objective_name_at(fore_switch_0, 21); //touchscreen switch in the very back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal, 22); //computer terminal in the very back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal_2, 23); //computer terminal in the  back building
//	firefight_mode_set_objective_name_at(fore_cpu_terminal_3, 24); //computer terminal in the left side building
//	firefight_mode_set_objective_name_at(fore_switch_1, 25); //touchscreen switch in the middle of the bridge
//	firefight_mode_set_objective_name_at(door_switch_1, 26); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(door_switch_2, 27); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(shield_switch_1, 28); //touchscreen switch on the overlooks of the bridge
//	firefight_mode_set_objective_name_at(inv_hack_panel, 29); //touchscreen switch on the overlooks of the bridge
//	
//	
//	firefight_mode_set_objective_name_at(lz_0, 50); //objective in the main spawn area
//	firefight_mode_set_objective_name_at(lz_1, 51); //objective in the middle front building
//	firefight_mode_set_objective_name_at(lz_2, 52); //objective in the middle back building
//	firefight_mode_set_objective_name_at(lz_3, 53); //objective in the left back area
//	firefight_mode_set_objective_name_at(lz_4, 54); //objective in the right in the way back
//	firefight_mode_set_objective_name_at(lz_5, 55); //objective in the back on the forerunner structure
//	firefight_mode_set_objective_name_at(lz_6, 56); //objective in the back on the smooth platform
//	firefight_mode_set_objective_name_at(lz_7, 57); //objective right by the tunnel entrance
//	firefight_mode_set_objective_name_at(lz_8, 58); //objective right by the tunnel entrance
//		
//set squad group names
//
//	firefight_mode_set_squad_at(gr_ff_guards_1, 1);	//left building
//	firefight_mode_set_squad_at(gr_ff_guards_2, 2);	//front by the main start area
//	firefight_mode_set_squad_at(gr_ff_guards_3, 3);	//back middle building
//	firefight_mode_set_squad_at(gr_ff_guards_4, 4); //in the main start area
//	firefight_mode_set_squad_at(gr_ff_guards_5, 5); //right side in the back
//	firefight_mode_set_squad_at(gr_ff_guards_6, 6); //right side in the back at the back structure
//	firefight_mode_set_squad_at(gr_ff_guards_7, 7); //middle building at the front
//	firefight_mode_set_squad_at(gr_ff_guards_8, 8); //on the bridge
//	firefight_mode_set_squad_at(gr_ff_allies_1, 9); //front building
//	firefight_mode_set_squad_at(gr_ff_allies_2, 10); //back middle building
//	firefight_mode_set_squad_at(gr_ff_waves, 11);
//	firefight_mode_set_squad_at(gr_ff_phantom_attack, 12); //phantoms -- doesn't seem to work
//	firefight_mode_set_squad_at(gr_ff_guards_13, 13); //in the tunnel
//	firefight_mode_set_squad_at(gr_ff_guards_14, 14); //bottom of the bridge by the start
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_1, 15); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_guards_2, 16); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_tunnel_fodder, 17); //back of the area by the tunnels
//	firefight_mode_set_squad_at(gr_ff_guards_18, 18); //guarding tightly the back of the bridge
//
//	
//	firefight_mode_set_squad_at(sq_ff_phantom_01, 20); //phantom 1
//	firefight_mode_set_squad_at(sq_ff_phantom_02, 21); //phantom 1


//	title_destroy_1 = destroy_1;
//	title_destroy_2 = destroy_2;
//	title_destroy_obj_1 = destroy_obj_1;
//	title_destroy_obj_complete_1 = destroy_obj_complete_1;
//	title_lz_end = lz_end;
//	title_switch_obj_1 = switch_obj_1;

//============ MAIN SCRIPT STARTS ==================================================================

	// setup defaults
	f_spops_mission_startup_defaults();

// hiding global lich
	object_hide( lichy, true );
	object_set_physics( lichy, false );
	
	// track mission flow
	f_spops_mission_flow();

end





/*
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// *** HILLSIDE: TURRETS ***
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------------------------------------------------------------

// DEFINES --------------------------------------------------------------------------------------------------------------------------------------------------
static real DEF_HILLSIDE_AI_TURRETS_RANGE = 							20.0;
static real DEF_HILLSIDE_AI_TURRETS_USE_ENGAGE = 					0.75;
static real DEF_HILLSIDE_AI_TURRETS_USE_DISENGAGE = 			3.0;
static real DEF_HILLSIDE_AI_TURRETS_ACTIVE_MIN = 					7.5;

// VARIABLES ------------------------------------------------------------------------------------------------------------------------------------------------
static short S_hillside_ai_turrets_active_players = 			0;

// FUNCTIONS ------------------------------------------------------------------------------------------------------------------------------------------------
// === f_hillside_ai_turrets_init::: Init
script dormant f_hillside_ai_turrets_init()
	//dprint( "f_hillside_ai_turrets_init" );

	ai_place_in_limbo( gr_hillside_turrets );
	
	// setup player watches
	thread( f_hillside_ai_turrets_player_watch(Player0) );
	thread( f_hillside_ai_turrets_player_watch(Player1) );
	thread( f_hillside_ai_turrets_player_watch(Player2) );
	thread( f_hillside_ai_turrets_player_watch(Player3) );
	
end

script static void f_hillside_ai_turrets_player_watch( player p_player )
local long l_timer = 0;
	//dprint( "f_hillside_ai_turrets_player_watch" );
	
	repeat
	
		// wait for a active jetpack
		sleep_until( f_hillside_ai_turrets_player_jetpacking(p_player), 1 );
		l_timer = timer_stamp( DEF_HILLSIDE_AI_TURRETS_USE_ENGAGE );
		//dprint( "f_hillside_ai_turrets_player_watch: WATCHING" );
		
		// make sure they jetpack for the min time
		sleep_until( timer_expired(l_timer) or (not f_hillside_ai_turrets_player_jetpacking(p_player)), 1 );
		if ( f_hillside_ai_turrets_player_jetpacking(p_player) ) then
			
			// inc active player cnt
			S_hillside_ai_turrets_active_players = S_hillside_ai_turrets_active_players + 1;
			//dprint( "f_hillside_ai_turrets_player_watch: ENGAGED" );
			
			repeat
			
				// wait for the player to stop loop
				sleep_until( not f_hillside_ai_turrets_player_jetpacking(p_player), 1 );
				
				// start the disengage timer
				l_timer = timer_stamp( DEF_HILLSIDE_AI_TURRETS_USE_DISENGAGE );
				
				// wait for disengage timer or player to engage their jetpack again
				sleep_until( timer_expired(l_timer) or f_hillside_ai_turrets_player_jetpacking(p_player), 1 );
			
			until( not f_hillside_ai_turrets_player_jetpacking(p_player), 1 );
			
			// inc active player cnt
			S_hillside_ai_turrets_active_players = S_hillside_ai_turrets_active_players - 1;
			//dprint( "f_hillside_ai_turrets_player_watch: DISENGAGED" );
			
		end
	
	until( FALSE, 1 );
	
end

// === f_hillside_ai_turrets_player_jetpacking::: Checks if a player is jetpacking
script static boolean f_hillside_ai_turrets_player_jetpacking( player p_player )
	// reset action test
	unit_action_test_reset( p_player );
	
	// check
	( unit_get_health(p_player) > 0.0 )
	and
	unit_has_equipment( p_player, 'objects\equipment\storm_jet_pack\storm_jet_pack.equipment' )
	and
	unit_action_test_equipment( p_player );
end

// === f_hillside_ai_turrets_init::: xxx
script static void f_hillside_ai_turret_manage( ai ai_turret, vehicle vh_turret )
local long l_timer = 0;
	//dprint( "f_hillside_ai_turret_manage" );

	// basic setup
	ai_cannot_die( ai_turret, TRUE );
	object_cannot_die( vh_turret, TRUE );
	ai_magically_see_object( ai_turret, player0 );
	ai_magically_see_object( ai_turret, player1 );
	ai_magically_see_object( ai_turret, player2 );
	ai_magically_see_object( ai_turret, player3 );
	
	repeat

		// deactivate
		object_set_physics( vh_turret, FALSE );
		object_hide( vh_turret, TRUE );
		ai_braindead( ai_turret, TRUE );
	
		// check to activate
		sleep_until(
			( S_hillside_ai_turrets_active_players > 0 )
			and
			timer_expired( l_timer )
			and
			(
				(
					f_hillside_ai_turrets_player_jetpacking( Player0 )
					and
					( objects_distance_to_object(vh_turret,Player0) <= DEF_HILLSIDE_AI_TURRETS_RANGE )
				)
				or
				(
					f_hillside_ai_turrets_player_jetpacking( Player1 )
					and
					( objects_distance_to_object(vh_turret,Player1) <= DEF_HILLSIDE_AI_TURRETS_RANGE )
				)
				or
				(
					f_hillside_ai_turrets_player_jetpacking( Player2 )
					and
					( objects_distance_to_object(vh_turret,Player2) <= DEF_HILLSIDE_AI_TURRETS_RANGE )
				)
				or
				(
					f_hillside_ai_turrets_player_jetpacking( Player3 )
					and
					( objects_distance_to_object(vh_turret,Player3) <= DEF_HILLSIDE_AI_TURRETS_RANGE )
				)
			)
		, 1 );
		l_timer = timer_stamp( DEF_HILLSIDE_AI_TURRETS_ACTIVE_MIN );

		// activate
		object_set_physics( vh_turret, TRUE );
		object_hide( vh_turret, FALSE );
		ai_braindead( ai_turret, FALSE );
		cs_stationary_face_player( ai_turret, TRUE );
		
		// wait to deactivate
		sleep_until(
			(
				timer_expired( l_timer )
				and
				( S_hillside_ai_turrets_active_players <= 0 )
			)
//			or
//			( unit_get_health(vh_turret) <= 0.01 )
		, 1 );
	
	//unit_get_health <unit>
	// if health is set timer so it takes longer to come back
	
	until( FALSE, 1 );
	
	//object_dissolve_from_marker( vh_turret, 'soft_kill', 'control_marker' );
end

script static boolean f_hillside_ai_turrets_damaged_player( short s_ticks )
	players_damaged_by_ai( Players(), gr_hillside_turrets, s_ticks );
end
script static boolean f_hillside_ai_turrets_damaged_player()
	f_hillside_ai_turrets_damaged_player( 10 );
end

// COMMAND_SCRIPTS ------------------------------------------------------------------------------------------------------------------------------------------
// === cs_e7m1_ai_turret::: xxx
script command_script cs_hillside_ai_turret()
	//dprint( "cs_e7m1_ai_turret" );
	
	thread( f_hillside_ai_turret_manage(ai_current_actor, ai_vehicle_get(ai_current_actor)) );

end
*/