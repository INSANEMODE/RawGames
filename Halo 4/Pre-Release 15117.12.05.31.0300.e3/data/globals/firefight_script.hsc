//*=============================================================================================================================
//===================== GLOBAL MIDNIGHT FIREFIGHT SCRIPTS ========================================================
//*=============================================================================================================================

//debug

global boolean debug = false;

//*=============================================================================================================================
//======================== GLOBALS ==================================================================
//*=============================================================================================================================

//the variable for tracking blips and a couple other things
global ai ai_ff_all = none;

//are enemies blipped variable
global boolean b_enemies_are_blipped = false;

//variables for cycling through waves and spawning waves in the correct location (these maybe should be local)
global short wave_squads = 0;
global short wave_squad_location = 0;

//gets set to true when the end goal event gets triggered
global boolean goal_finished = false;

//gets set to true when the end wave event gets triggered (end_wave)
global boolean wave_finished = false;

//gets set to true when ALL the waves have ended in a player goal
global boolean b_all_waves_ended = false;

//controls the difficulty of the wave getting called
global wave_difficulty difficulty = Medium;

//controls when the enemies are done spawning in a wave -- for example, a drop ship is coming in
global boolean b_done_spawning_enemies = true;
global boolean b_drop_pod_complete = true;
global boolean b_pause_wave = false;

global boolean precondition = false;

//game is ended
global boolean b_game_ended = false;
global boolean b_game_won = false;
global boolean b_game_lost = false;
global long l_goal_timer = 0;

//defend player goal
global real r_defend_timer = 5.0 * 60 * 30;

//controls the objective counts in the objective destroy player goal
global short s_all_objectives = 0;
global short s_all_objectives_count = 0;

//controls whether the wait for trigger player goal is triggered
global boolean b_end_player_goal = false;

//controls when the automatic HUD markers kick off
global boolean b_wait_for_narrative_hud = false;

//boss squad definition
global ai ai_boss_objective = none;

//default mission variable
global boolean mission_is_test_debug = false;


// Ammo crate objects
//global folder eq_ammo_crates = eq_destroy_crates;
//global folder eq_ammo_crates = none;
//global object_name obj_ammo_crate0 = ammo_crate0;
//global object_name obj_ammo_crate1 = ammo_crate1;
global object_name objective_obj = none;

//variables for controlling defend objectives (might be better local)
global object_name obj_defend_1 = none;
global object_name obj_defend_2 = none;


global object_name dm_droppod_1 = dm_drop_01;
global object_name dm_droppod_2 = dm_drop_02;
global object_name dm_droppod_3 = dm_drop_03;
global object_name dm_droppod_4 = dm_drop_04;
global object_name dm_droppod_5 = dm_drop_05;

global object_name obj_drop_pod_1 = drop_pod_lg_01;
global object_name obj_drop_pod_2 = drop_pod_lg_02;
global object_name obj_drop_pod_3 = drop_pod_lg_03;
global object_name obj_drop_pod_4 = drop_pod_lg_04;
global object_name obj_drop_pod_5 = drop_pod_lg_05;

//controls blipping location
global object_name flag_0 = none;

//left in to control failing a mission -- debug currently
global cutscene_title title_lose = failed;

//take these out a little later
//=================== LOOPING SOUNDS/MUSIC MISC ======================
global looping_sound fx_misc_warning = "sound\game_sfx\firefight\gui_powercore_warning_loop.sound_looping";
global looping_sound fx_misc_warning_2 = "sound\game_sfx\firefight\gui_powercore_failure_loop.sound_looping";
global looping_sound music_start = "sound\environments\solo\m020\music\m20_music";
global looping_sound music_mid_beat = "sound\environments\solo\m020\music\gpost04";
global looping_sound music_up_beat = "sound\environments\solo\m020\music\bridge_02";


//=================== CREATION VARIABLES ======================
global short goal_index = 0;

global short current_folder_index = 0;

global short spawn_folder_index = -1;
static short crateExecutedToIndex = -1;

//=================== GOALS ======================

global boolean b_goal_ended = false;
global boolean b_capture_marker = false;



//*=============================================================================================================================
//====================== END GAME =========================================================
//*=============================================================================================================================

script dormant firefight_lost_game
	//firefight_end_game
	sleep_until (b_game_lost == true);
	print ("game lost");
	mp_round_end();
//b_game_ended
end

script dormant firefight_won_game
	sleep_until (b_game_won == true);
	print ("game won");
	mp_round_end_with_winning_team(mp_team_red);

end

script dormant end_condition_lives
	//make sure this doesn't fire before everybody spawns
	static short dead_sec = 0;
	sleep_until (firefight_players_dead() == false);
	repeat
		if firefight_players_dead() == true then
			dead_sec = dead_sec + 1;
		else
			dead_sec = 0;
		end
	until (dead_sec >= 8, 30);
	cinematic_set_title (title_lose);
	sound_impulse_start (vo_all_dead, none, 1.0);
	//insert incident for no more lives here
	b_game_lost = true;
	print ("no more lives!");
end

script dormant end_condition_time
	sleep_until (l_goal_timer == firefight_mode_get_current_goal_time_limit() * 60, 1);
	//insert incident for out of time here
	print ("out of time!");
	print ("if you are seeing this message at the beginning of a level");
	print ("you probably haven't loaded a correct game_variant");
	print ("...or there is no time limit set in your mission"); 

	b_game_lost = true;
	sleep_forever(objective_timer);
	
end


//*=========================================================================================================
//===============LIVES================================
//*=========================================================================================================

script static boolean firefight_players_dead
	list_count_not_dead(players()) <= 0;
end

script continuous respawn_dead_players_timer
	static short dead_sec = 0;
	sleep_until (firefight_players_dead() == false, 1);
	print ("starting dead players timer");
	repeat
		repeat
			if list_count_not_dead(players()) < game_coop_player_count() then
				dead_sec = dead_sec +1;
			else
				dead_sec = 0;
			end
		until (dead_sec >= 15, 30);
		firefight_mode_respawn_dead_players();
		print ("respawning dead players");
	until (b_game_won == true or b_game_lost == true, 1);
end


script static void f_add_lives
	firefight_mode_respawn_dead_players();
	firefight_mode_lives_set (firefight_mode_lives_get() + game_coop_player_count());
	print ("lives added");
end

script continuous check_goal_finished()
	print ("starting goal finished thread");
	//gmu 03/02/2012 -- commenting this out and the wake, to speed up the time it takes to end the goal
	//sleep_forever();
		sleep_until (b_goal_ended == true, 1);
		b_goal_ended = false;
	//sleep (30 * 1);
	NotifyLevel("end_goal");
	

end

//*=============================================================================================================================
//================== CREATE OBJECTIVE OBJECTS (CRATES, SCENERY, MACHINES) ====================================================================
//*=============================================================================================================================


//============= CREATE FOLDERS ===========================
//
// Add a new crate.
//
script static short f_add_crate_folder(folder crate_folder)

	print ("Registering crate folder.");

	inspect(crate_folder);

	//
	// Index 0 is reserved, pre-increment count.
	//
	current_folder_index = (current_folder_index + 1);

	if (firefight_mode_is_crate_folder_valid(current_folder_index)) then

		breakpoint("Folder index is already registered!");

	end

	//
	// Store the folder in the initial set of indicies.
	//
	firefight_mode_set_crate_folder_at(crate_folder, current_folder_index);	

	//
	// Ensure that the first block is initialized.
	//
	wake(f_ensure_initial_crate_block);

	current_folder_index;

end

//
// Begin a new crate block.
//
script static short f_add_new_crate_block()

	//
	// Skip a folder entry leaving an empty gap.
	//
	current_folder_index = (current_folder_index + 1);

	current_folder_index;

end

//
// Begin a new create block at a specified index.
//
script static short f_add_new_crate_block_at_index(short index)

	//
	// Set the folder index to the specified index.
	//
	current_folder_index = index;

	current_folder_index;

end

//
// Create all the crates in a block.
//
script static short f_create_crate_block(short index)

	local short folderIndex = index;

	if firefight_mode_is_crate_folder_valid(folderIndex) then

		repeat
			print("Creating folder index:");
			inspect(folderIndex);

			//
			// Create the folder.
			//
			object_create_folder_anew(firefight_mode_get_crate_folder_at(folderIndex));
			
			//
			// Get the next folder.
			//
			folderIndex = folderIndex + 1;

		until (firefight_mode_is_crate_folder_valid(folderIndex) == false, 0);

	end

	folderIndex;

end

//
// Ensures all crates in the inital block have been created.
//
script continuous f_ensure_initial_crate_block()

	repeat

		print ("Waking to create initial crate block.");

		if current_folder_index != 0 then

			if (crateExecutedToIndex == -1) then
				
				crateExecutedToIndex = 1;

			end

			local short newIndex = f_create_crate_block(crateExecutedToIndex);

			if (newIndex != crateExecutedToIndex) then

				print("Created crates up to index:");
				inspect(newIndex);

			end

			crateExecutedToIndex = newIndex;

		end

		sleep_forever();

	until (false, 1);

end

//
// Wait until the initial block of crates are all created.
//
script static void f_wait_for_initial_crates()

	sleep_until(crateExecutedToIndex == -1 or firefight_mode_is_crate_folder_valid(crateExecutedToIndex) == false);

end


//================ CREATE OBJECTIVE OBJECTS ===========================
//create the props based on the first objective -- change this to look through all the goals based on string ID and create them??
script static void f_firefight_create_all_objectives
	print ("creating all the objectives and crates");
	
	goal_index = 0;
	
	//
	// Ensure all the intial crates have been setup.
	//
	wake(f_ensure_initial_crate_block);

	//loop through each of the player goals
	repeat
		inspect (goal_index);
		f_firefight_create_objectives();
		goal_index = (goal_index + 1);

	until (goal_index == firefight_mode_get_goal_count(), 1);

end

script static void f_firefight_create_objectives()
	print ("creating objectives");
	local short obj_index = 0;
	local short create_objective = 0;
	
	//loop through each of the objectives in the goal and create them
	repeat
		print ("repeating creating objectives");
		create_objective = firefight_mode_get_objective(goal_index, obj_index);
		if create_objective != 0 then
			print ("creating objective");
			object_create_anew(firefight_mode_get_objective_name_at(create_objective));
			inspect (obj_index);
			//checking the health of the object for debugging
			if object_valid (firefight_mode_get_objective_name_at(create_objective)) then
				print ("object valid");
			else
				print (".....OBJECT NOT VALID.....");
			end
			
		end
	obj_index = (obj_index + 1);
	until (create_objective == 0, 1);
	//until (create_objective == 0, 1, 100);
	print ("done creating objectives");
end

//=================== CREATE SPAWN OBJECTS ===========================
script static void f_create_current_spawn_folders()
	print ("creating spawn points");
	//if it's the first goal create a spawn folder no matter what
	if firefight_mode_goal_get() == 0 then
		spawn_folder_index = firefight_mode_get_current_start_location_folder();
		object_create_folder_anew(firefight_mode_get_crate_folder_at(spawn_folder_index));
		print ("creating spawn folder because goal is 0");
		inspect (spawn_folder_index);
	
	//if it's not the first goal and the new spawn folder is different from the old spawn folder then create the new folder and destroy the old one
	elseif spawn_folder_index != firefight_mode_get_current_start_location_folder() then
			object_create_folder_anew(firefight_mode_get_crate_folder_at(firefight_mode_get_current_start_location_folder()));
			print ("creating new spawn folder because goal start location is different from the index");
			sleep(1);
			print ("destroying old spawn folder index folder");
			object_destroy_folder(firefight_mode_get_crate_folder_at(spawn_folder_index));
			spawn_folder_index = firefight_mode_get_current_start_location_folder();
			inspect (spawn_folder_index);
	//if it's not the first goal and the new spawn folder is the same as the old spawn folder then don't do anything
	elseif spawn_folder_index == firefight_mode_get_current_start_location_folder() then
		print ("not spawning a new folder or destroying the old one because the start location folders are the same");
	end

	
end

// HEY DESIGNERS USE THIS FUNCTION TO ADD NEW SPAWN POINTS MID GOAL
script static void f_create_new_spawn_folder (short spawn_folder)
	//spawn_folder_index = spawn_folder;
	print ("creating new spawn folder because designer said so");
	if spawn_folder != spawn_folder_index then
		object_create_folder_anew(firefight_mode_get_crate_folder_at(spawn_folder));
		print ("creating new spawn folder");
		inspect (spawn_folder);
		sleep(1);
		object_destroy_folder(firefight_mode_get_crate_folder_at(spawn_folder_index));
		print ("destroying old spawn folder index folder");
		spawn_folder_index = spawn_folder;
	else
		print ("WARNING - new spawn folder is the same as previous folder, no change in spawn points");
	end
end


//===================== TIMER ====================================================================
//this controls ending the game if the goal timer is up

script continuous objective_timer()
	sleep_forever();
//	sleep (30 * 5);
	print ("start timer");
//	game_engine_timer_set (firefight_mode_get_current_goal_time_limit() * 60);
//	game_engine_timer_show ("TIMER", true);
//	game_engine_timer_start();
	l_goal_timer = 0;
//	
	repeat
		l_goal_timer = l_goal_timer + 1;
	until (b_goal_ended == true, 30);
//	
end


//===================== HUD ====================================================================
//globally turn on/off HUD elements

script static void f_turn_off_ordnance_hud
//	hud_show_fanfares (false);
	hud_show_toast_commendations (false);
	hud_show_medal_posting_ui (false);
//	player_ordnance_enabled_override = 0;


end


//*=============================================================================================================================
//============ GOALS AND WAVES =========================================================
//*=============================================================================================================================


//========GOALS=================================

script static void firefight_player_goals()
	print ("::starting firefight player goals");
	wake (end_condition_lives);
	wake (end_condition_time);
	firefight_mode_start_goals(difficulty);
	firefight_set_squad_group(ai_ff_all);
	//sleep (10);
	//creating the crates for the mission
	
	//
	// Wait for all crates to spawn (blocking).
	//
	f_wait_for_initial_crates();

	//creates all the player goal objective objects
	f_firefight_create_all_objectives();
	
	thread(f_turn_off_ordnance_hud());
	
	//thread (f_firefight_ammo_crate_create());
	static short current = 0;
	
	//this is the goal looping script -- loop through the goals until all the goals are complete
	if ( firefight_mode_get_goal_count() > 0) then
		repeat
			print ("running goal");
			//creating spawn folders and deleting old spawn folders
			thread (f_create_current_spawn_folders());
			//adding lives and respawning dead players
			thread (f_add_lives());
			//commenting this out 03.02.2012 to speed up the goal ending time
			//wake the script that checks whether goals are finished
			//wake (check_goal_finished);
			goal_finished = false;
			//start the script that setups the player goal through the map script
			f_firefight_setup_goal();
			//start the wave logic if applicable for the goal
			f_firefight_run_goal(current );
			sleep_until( goal_finished, 1 );		
			current = firefight_mode_increment_player_goal(difficulty);
			print ("goal ended");
		until (current == firefight_mode_get_goal_count(), 1);
	end
end



//starts the script of the goal based on the goal type set up in the tag in Bonobo
script static void f_firefight_setup_goal()
	if firefight_mode_current_player_goal_type() == object_destruction then
		setup_destroy();
	elseif firefight_mode_current_player_goal_type() == time_passed then
		setup_wait_for_trigger();
	elseif firefight_mode_current_player_goal_type() == object_delivery then
		setup_take();
	elseif firefight_mode_current_player_goal_type() == location_arrival then
		setup_atob();
	elseif firefight_mode_current_player_goal_type() == other then
		setup_capture();
	elseif firefight_mode_current_player_goal_type() == no_more_waves then
		setup_swarm();
	elseif firefight_mode_current_player_goal_type() == kill_boss then
		setup_boss();
	elseif firefight_mode_current_player_goal_type() == defense then
		setup_defend();
	end
	
end

// THIS IS THE MAIN GOAL RUNNING SCRIPT
script static void f_firefight_run_goal( short goal_index)
	static short current = 0;
	
	//have to set current to "0" because creating the variable doesn't reset it to 0
	current = 0;
	b_all_waves_ended = false;
	print ("::starting firefight_run_goal::");
	
	//start the wave spawning logic if there are waves in the goal
	if ( firefight_mode_waves_in_player_goal() > 0) then
		repeat
			print ("running wave");

			wave_finished = false;
			//respawn dead players -- when it works put in a check to see if the flag is called in the variant -- though I don't see why we would ever NOT want this
//			if firefight_mode_team_respawns_on_wave() == true then
//				firefight_mode_respawn_dead_players();
//				print ("all dead players respawned");
//			end
			//respawn dead players no matter what between waves
			firefight_mode_respawn_dead_players();
			
			//sleep until all the drop pods and phantoms are destroyed OR the player goal has been completed
			print ("---is precondition or goal finished true?---");
			f_precondition();
			
			//respawn dead players no matter what between waves
			firefight_mode_respawn_dead_players();
			
//			sleep_until (precondition or goal_finished, 1);
			//if the goal is NOT finished start a wave
			if (goal_finished == false) then
				print ("---threading f_firefight_run_wave---");
				thread (f_firefight_run_wave(goal_index, current));
				//commenting out this sleep to see if anything bad happens
				//sleep (30);
			end
			
			//sleep until the number of AI specified in the wave is killed OR the player goal has been completed
			sleep_until ( wave_finished or goal_finished, 1);	
			print ("in goal thread wave is finished or goal is finished");	
//			print ( "what is current??");
//			inspect (current);
//			inspect (goal_finished);
//			print ("what is waves in player goal - 1");
//			inspect (short(firefight_mode_waves_in_player_goal()- 1));
			//if there are more waves in the goal increment the wave ONLY if the goal isn't finished.  If the goal is finished or there are no more waves then end
			if (current != (short(firefight_mode_waves_in_player_goal() - 1)) and (goal_finished == false)) then
				current = firefight_mode_increment_wave();
				print ("increment wave");
			else
				print ("no more waves");
				current = firefight_mode_waves_in_player_goal();
			end
			print ("wave ended");
		until(current == firefight_mode_waves_in_player_goal() or goal_finished, 1);	
		print ("all waves ended in goal");
		b_all_waves_ended = true;
		
	end
end

//THIS PAUSES THE GOAL SCRIPT UNTIL CERTAIN PRECONDITIONS ARE MEANT -- CURRENTLY THE ONLY PRECONDITION IS THAT THE WAVE ISN"T PAUSED AND THE GOAL ISN'T FINISHED
script static void f_precondition

	//pause here until there are no more phantoms and drop pods OR the goal is finished
	print ("---waiting on precondition---");
	sleep_until (b_pause_wave == false or goal_finished == true, 1);
	
//	precondition = true;
	print ("---precondition is true---");
end


//WAIT UNTIL THE CODE CALLS THE EVENT "end_goal" THEN ENDS THE GOAL
script continuous end_goal()
	sleep_until(LevelEventStatus("end_goal"), 1);
	print ("goal ending");
	goal_finished = true;
	//sleep_forever(f_firefight_run_goal);

end

//===============WAVES===============================================


//this waits for the engine to call "end_wave" then unblips the enemies and says "wave_finished"
script continuous end_wave()
	//the "end wave" event comes from the engine
	sleep_until(LevelEventStatus("end_wave"), 1);
	print ( "Wave Ending");
	if (firefight_get_squad_group() != none) and b_enemies_are_blipped == true then 
		thread (f_unblip_ai_cui(firefight_get_squad_group()));
	end
	firefight_set_squad_group(none);
	wave_finished = true;
end


//squad placement scripts (dropships, monster closets, etc.
script static void f_firefight_run_wave (short goal_index, short wave_index)
	b_done_spawning_enemies = false;
	precondition = false;
	print ("---spawning enemies in a wave---");
	

	//LOOK AT REMOVING THIS put any wave squad enemies into a separate squad so they don't get teleported into vehicles or cause strange blips
//	ai_migrate_persistent(gr_ff_waves, sq_ff_remaining);
	
	if ( firefight_mode_current_wave_spawn_method() == Dropship) then
		print ("spawning with dropship");
		f_dropship_loader();
		
	elseif ( firefight_mode_current_wave_spawn_method() == Monster_Closet) then 
		print ("spawning with monster closet");
		f_spawn_squads();
		
//		if firefight_mode_get_wave_squad() == 25 then
//			cs_run_command_script (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), cs_knight_phase_spawn);
//			print ("spawn in knight effects");
//		end
		//IMMEDIATELY bring the AI out of limbo if they are valid
		if firefight_mode_get_current_squad_to_place(0) > 0 then
			ai_exit_limbo (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)));
		end
		
		if firefight_mode_get_current_squad_to_place(1) > 0 then
			ai_exit_limbo (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(1)));
		end
		
	elseif ( firefight_mode_current_wave_spawn_method()  == Drop_Pod) then
		print ("spawning with drop pod");
		f_drop_pod_loader();

	elseif ( firefight_mode_current_wave_spawn_method() == Test_Spawn) then
		print ("spawning with test spawn -- PAUSING");
		f_pause_wave();
		
	end

	//LOOK AT REMOVING THIS put all the enemies into the spawn waves squad group
//	ai_migrate_persistent(gr_ff_waves, sq_ff_remaining);

	print ("---done spawning enemies---");
	firefight_set_squad_group( ai_ff_all);
//	firefight_set_squad_group( gr_ff_all);
	b_done_spawning_enemies = true;

end


//THIS IS WHERE THE SQUADS GET SPAWNED
script static void f_spawn_squads()
	wave_squads = 0;
	
	//spawn all squads in the wave
	repeat
		wave_squad_location = (firefight_mode_get_current_squad_to_place(wave_squads));
		inspect (wave_squads);
		inspect (wave_squad_location);
		if wave_squad_location != 0 then
	//		print ("wave_squad_location doesn't = 0");
	//		ai_place_wave (firefight_mode_get_wave_squad(), firefight_mode_get_squad_at(wave_squad_location), 1);
			ai_place_wave_in_limbo (firefight_mode_get_wave_squad(), firefight_mode_get_squad_at(wave_squad_location), 1);

	//		print ("placed the waves");
		end
//		print ("wave_squad_location = 0");
		wave_squads = (wave_squads + 1);
	until (wave_squad_location == 0, 1);
	print ("done spawning squads");
end	



//*=============================================================================================================================
//===========DROPSHIPS
//*=============================================================================================================================

	
script static void f_dropship_loader()
	//spawn phantom from pre-set squad list based on the 'wave type' entered
	ai_place (firefight_mode_get_squad_at(firefight_mode_get_wave_type()));
	
	//spawn the squads
	f_spawn_squads();
	
	//exit limbo and place the AI into a drop ship (if there really is a squad to place)
	if firefight_mode_get_current_squad_to_place(0) > 0 then
		ai_exit_limbo (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)));
		f_load_dropship (ai_vehicle_get_from_squad (firefight_mode_get_squad_at(firefight_mode_get_wave_type()), 0), firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)));

	end
		
	if firefight_mode_get_current_squad_to_place(1) > 0 then
		ai_exit_limbo (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(1)));
		f_load_dropship (ai_vehicle_get_from_squad (firefight_mode_get_squad_at(firefight_mode_get_wave_type()), 0), firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(1)));

	end
//	f_load_dropship (	ai_vehicle_get_from_spawn_point (object_get_ai(list_get (ai_actors(firefight_mode_get_squad_at(firefight_mode_get_wave_type())), 0))), firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)));
//	f_load_dropship (ai_vehicle_get_from_squad (firefight_mode_get_squad_at(firefight_mode_get_wave_type()), 0), firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)));


end

script static void f_load_dropship (vehicle dropship, ai squad)
//load phantoms in both sets of seats
	print ("load phantom dual...");
	if (vehicle_test_seat (dropship, "phantom_p_lf") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_lf");
		print ("ai placed in seat1");
	else
		print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_rf") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_rf");
		print ("ai placed in seat2");
	else
		print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_lb") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_lb");
		print ("ai placed in seat3");
	else
		print ("seat taken");
	end
	if (vehicle_test_seat (dropship, "phantom_p_rb") == false) then
		ai_vehicle_enter_immediate (squad, dropship, "phantom_p_rb");
		print ("ai placed in seat4");
	else
		print ("seat taken");
	end
	print ("loaded side dual");

end



//*=============================================================================================================================
//================DROP PODS
//*=============================================================================================================================



script static void f_drop_pod_loader
	//sleep (30 * 3);
	//if drop ships and waves go crazy -- blame this
	//b_drop_pod_complete = false;
	
	//spawn the appropriate squad
	f_spawn_squads();
	print ("drop pod squads spawned");
	
	//if ai_living_count (ai_ff_wave_spawns) > 8 then
	
	//if the pod is alive, then blow it up -- this might need to change when we have the real drop pod
//	if object_valid (drop_pod_lg) == true then
//		effect_new_on_object_marker (fx\reach\fx_library\explosions\human_explosion_aerial\human_explosion_aerial.effect, drop_pod_lg, "chud_nav_point");
//		object_destroy(drop_pod_lg);
//		print ("drop pod destroyed");
//	end
//		object_create (drop_pod_lg);
		
	//place the squad into the correct pod
	//tells the pod where to drop
	if firefight_mode_get_wave_type() == 1 then
		thread (f_load_drop_pod (dm_droppod_1, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_1, true));
		print ("drop pod falling onto spot 1");
	elseif
		firefight_mode_get_wave_type() == 2 then
		thread (f_load_drop_pod (dm_droppod_2, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_2, true));
		print ("drop pod falling onto spot 2");
	elseif
		firefight_mode_get_wave_type() == 3 then
		thread (f_load_drop_pod (dm_droppod_3, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_3, true));
		print ("drop pod falling onto spot 3");
	elseif
		firefight_mode_get_wave_type() == 4 then
//		object_create_anew (obj_drop_pod_4);
		thread (f_load_drop_pod (dm_droppod_4, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_4, true));
		print ("drop pod falling onto spot 4");
	elseif
		firefight_mode_get_wave_type() == 5 then
		thread (f_load_drop_pod (dm_droppod_5, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_5, true));
		print ("drop pod falling onto spot 5");
	else
		//if the number to drop isn't specified then drop it randomly
		print ("drop pod falling randomly");
			begin_random_count (1)
				thread (f_load_drop_pod (dm_droppod_1, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_1, true));
				thread (f_load_drop_pod (dm_droppod_2, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_2, true));
				thread (f_load_drop_pod (dm_droppod_3, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_3, true));
				thread (f_load_drop_pod (dm_droppod_4, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_4, true));
				thread (f_load_drop_pod (dm_droppod_5, firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(0)), obj_drop_pod_5, true));
			end
	end
	

	sleep_until (b_drop_pod_complete == true, 1);
end

//add variables for the effects

//loads the drop pod
script static void f_load_drop_pod (object_name dm_drop, ai squad, object_name pod, boolean waves)
	
	//wait until the pod is not around (in case this pod was just used)
	sleep_until (object_valid (pod) == false, 1);
	//sleep_until (b_done_spawning_enemies == true);

	//f_spawn_squads();
	//print ("drop pod squads spawned");

	print ("drop pod ready to be created");
	object_create_anew (pod);
	object_hide (pod, true);
	// make sure the thrusters are off (I think this is unnecessary, but never hurts to be sure)
	SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.0);
	print ("drop pod created");
	//if AI act weird put this back in
	//ai_set_objective (squad, obj_drop_pod);
		//AI exiting limbo
	
	//check to see if the AI squad has valid, living actors	
	//if firefight_mode_get_current_squad_to_place(0) == 0 then
	if ai_living_count (squad) == 0 then	
		print ("there are no living actors in the squad put in to the drop pod");
		print ("the script is not calling ai_exit_limbo on the squad");
	else
	
	//place the squad into the drop pod, checking to see if they really get put in	
	//if firefight_mode_get_current_squad_to_place(0) > 0 then
		ai_exit_limbo (squad);
//		ai_set_objective (squad, obj_drop_pod);
		if vehicle_test_seat (vehicle(pod), "") == false then
			print ("no seats taken before placing squads in drop pod");
		end

		ai_vehicle_enter_immediate (squad, vehicle(pod));
		if vehicle_test_seat (vehicle(pod), "") == false then
			print ("no seats taken, the squad didn't get put into the drop pod :(");
		else
			print ("squad teleported into drop pod");
		end
	end
	
	//put second squad into drop pods if they exist
	if waves == true and firefight_mode_get_current_squad_to_place(1) > 0 then
		ai_exit_limbo (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(1)));
		ai_set_objective (squad, obj_drop_pod);
		ai_vehicle_enter_immediate (firefight_mode_get_squad_at(firefight_mode_get_current_squad_to_place(1)), vehicle(pod));
		print ("squad 1 teleported into drop pod");
	end
	
//	ai_vehicle_enter_immediate (squad, vehicle(pod));
//	print ("squad 0 teleported into drop pod");
	sleep (1);

	object_create_anew (dm_drop);
	print ("drop rail created");
	//object_create (pod);
	device_set_position (device(dm_drop), 1);
	objects_attach (dm_drop, "", vehicle(pod), "");
	
	object_set_scale (pod, 0.1, 1);
	
	sleep (2);
	
	object_hide (pod, false);
	
	object_set_scale (pod, 1.0, 60);
	
	sleep (10);
	//ai_ff_wave_spawns = sq_ff_drop_01;
	//ai_place_wave (firefight_mode_get_wave_squad(), squad, 1);

	//ai_place (squad);
	//ai_exit_limbo (squad);
	//ai_vehicle_enter_immediate (squad, vehicle(pod));
//	sleep_until (device_get_position (device(dm_drop)) >= 0.85, 1);
	//f_blip_object (pod, "enemy_vehicle");
		//wait until the players have spawned to show HUD items
	if b_wait_for_narrative_hud == false then
		//f_blip_object_cui (pod, "navpoint_enemy_vehicle");
		print ("narrative hud is false, calling blip drop pod");
		thread (f_blip_drop_pods(pod, dm_drop));
	end

//	sleep (30 * 5);

		// wait till we're close to the bottom
		sleep_until (device_get_position (device(dm_drop)) >= 0.75, 1);
		// turn on the thrusters at half power to hover
		SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 0.5);

sleep_until (device_get_position (device(dm_drop)) == 1, 1);

	//(wake drop_blip_01)

device_set_power (device(dm_drop), 0);

	unit_open (vehicle(pod));
//	sleep (30);
//	sleep (60);
	print ("kicking ai out of pod...");
	
//	vehicle_unload (vehicle(pod), "");
	
ai_vehicle_exit (squad);

//	ai_set_objective (squad, obj_test);
//	ai_force_active (squad, 1);
	//ai_set_objective (squad, obj_survival);
//	sleep_until (device_get_position (dm_drop) >= 0.97, 1);
//	(effect_new_on_object_marker fx\reach\fx_library\pod_impacts\dirt\pod_impact_dirt_large.effect dm_drop_01 "fx_impact")
//	sleep_until (device_get_position (dm_drop) >= 1, 1);
	
	sleep (30 * 3);
	
device_set_power (device(dm_drop), 1);
	
	sleep (1);
	
		// turn on the thrusters at full power
		SetObjectRealVariable(pod, VAR_OBJ_LOCAL_A, 1.0);
	
	device_set_position (device(dm_drop), 0);
	
sleep_until (device_get_position (device(dm_drop)) == 0, 1, (30 * 5));
	
	object_set_scale (pod, 0.01, 30);
	
	sleep (60);
	
	objects_detach (dm_drop, vehicle(pod));
	object_destroy (dm_drop);
	//f_unblip_object_cui (pod);
	object_destroy (pod);
	print ("done with drop pod");
//	sleep (30 * 5);
//	object_destroy (pod_name);


	b_drop_pod_complete = true;
end

script static void f_blip_drop_pods (object_name pod_2, object_name dm_drop_2)
	if
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0 then
		print ("player is alive blipping drop pod");
		sound_impulse_start (sfx_blip, NONE, 1);
		
		//f_blip_object_cui (dropship, "navpoint_enemy_vehicle");
		navpoint_track_object_named (pod_2, "navpoint_enemy_vehicle");
		sleep_until (object_valid (dm_drop_2) == false, 1);
	//chud_track_object (dropship, false);
		//f_unblip_object_cui (dropship);
		//navpoint_track_object (pod_2, false);
	else
		print ("player is not alive NOT blipping drop pod");
	end

end


//==================WAVE PAUSE=======================================

script static void f_pause_wave
	//pauses for the the amount of seconds set in the "wave type" field in the mission variant tag
	b_pause_wave = true;
	print ("pausing for some seconds");
	inspect (short(firefight_mode_get_wave_type()));
	sleep_until (goal_finished, 1, firefight_mode_get_wave_type() * 30);
	print ("done pausing");
	b_pause_wave = false;
end



//script static void f_firefight_script_drop(short goal_index, short wave_index)
//	sleep(0);
//end


//================blips


script continuous check_need_blips()
	sleep_until(LevelEventStatus("blip_remaining_enemies"),1);
	sleep (30);
	sleep_until(b_done_spawning_enemies == true, 1);
	print ("attempting to blip enemies");
	sleep_until (b_wait_for_narrative_hud == false or wave_finished, 1);
	if wave_finished then
		print ("wave is finished, resetting check_need_blips");
	else
		print ("blipping enemies");
		f_blip_ai_cui(firefight_get_squad_group(), "navpoint_enemy");
		f_blip_ai_cui(gr_ff_remaining, "navpoint_enemy");
		b_enemies_are_blipped = true;
	end
end



//*===================================================================================
//*=====================================PELICANS=======================================
//*===================================================================================










//* ================================================================================================================
//================== OBJECT DESTRUCTION -- DESTROY OBJECTIVE SCRIPTS ====================================
//* ================================================================================================================

script continuous objective_destroy
	//sleep until woken	
	sleep_forever();
	b_goal_ended = false;
	print ("------objective destroy started------");

	//this is where the main script starts
// commenting out the sleep to remove dead spots, we'll see if this breaks anything
//	sleep (30 * 3);
	s_all_objectives = 0;
	s_all_objectives_count = 0;
	wake (objective_timer);
	
	//set the objective to whatever is in the objective field in the player goal
	//objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	//sleep (30 * 6);
	
		//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	//if there is an objective set in the objective 0 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(0) > 0 then
		print ("objective 0 is active");
		s_all_objectives = s_all_objectives + 1;
		//set the objective to whatever is in the objective field in the player goal and watch for it to be destroyed
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0))));
	else
		print ("NOTHING is set in objective 0");
	end
	
	//if there is an objective set in the objective 1 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(1) > 0 then
		print ("objective 1 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(1))));
	else
		print ("NOTHING is set in objective 1");
	end
	
	//if there is an objective set in the objective 2 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(2) > 0 then
		print ("objective 2 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(2))));
	else
		print ("NOTHING is set in objective 2");
	end
	
		//if there is an objective set in the objective 3 spot in the tag then wait for it to be switched or destroyed
	if firefight_mode_get_current_objective(3) > 0 then
		print ("objective 3 is active");
		s_all_objectives = s_all_objectives + 1;
		thread (objective_destroy_watch (firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(3))));
	else
		print ("NOTHING is set in objective 3");
	end
	
	//sleep until all the objectives are destroyed/switches flipped
	sleep_until (s_all_objectives == s_all_objectives_count, 1);
	
	//old code to know what I did before
//	//sleeps the script until the object is destroyed or turned on/off
//	//if the object is a device then it has a health of 0 when it is created, so sleep until it's turned on/off - else sleep until it is destroyed
//	if object_get_health(objective_obj) == 0 then
//		if device_get_position(device(objective_obj)) == 0 and device_get_power(device(objective_obj)) == 0 then
//			print ("---destroy goal is a device machine that is currently off");
//			//f_blip_object (objective_obj, "activate");
//			f_blip_object_cui (objective_obj, "navpoint_activate");
//			sleep_until (device_get_power(device(objective_obj)) > 0, 1);
//			print ("an object was turned on");
//		elseif device_get_position(device(objective_obj)) == 0 and device_get_power(device(objective_obj)) == 1 then
//			print ("---destroy goal is a device machine that is currently on or a device control that is currently off");
//			f_blip_object_cui (objective_obj, "navpoint_activate");
//			sleep_until (device_get_power(device(objective_obj)) < 1 or device_get_position(device(objective_obj)) > 0, 1);
//			print ("an object was turned on or off");		
//		else
//			//f_blip_object (objective_obj, "activate");
//			print ("---destroy goal is a device control that is currently on");
//			f_blip_object_cui (objective_obj, "navpoint_deactivate");
//			sleep_until (device_get_position(device(objective_obj)) < 1, 1);
//			print ("an object was turned off");
//		end
//		//f_unblip_object (objective_obj);
//		f_unblip_object_cui (objective_obj);
//	else
//		print ("---destroy goal is a destructible object");
//		//turns on the HUD pointers and HUD health marker
//		//f_blip_object (objective_obj, "neutralize");
//		f_blip_object_cui (objective_obj, "navpoint_healthbar_neutralize");
//		sleep_until (object_get_health(objective_obj) <= 0, 1);
//		print ("an object was destroyed");
//	end


	print ("------objective destroy ended------");
	b_goal_ended = true;
	
end

script static void objective_destroy_watch (object_name objective_obj)
	//watch for a switch to be pulled or object to be destroyed and add 1 to the count once it is true
	print ("objective destroy watch started with object named...");
	if object_valid (objective_obj) == false then
		print ("objective object is NOT valid -- goal is blocked because it ");
	end
	inspect (objective_obj);
	if object_get_health(objective_obj) == 0 then
		if device_get_position(device(objective_obj)) == 0 and device_get_power(device(objective_obj)) == 0 then
			print ("---destroy goal is currently off and needs to get turned on and switched on");
			//f_blip_object (objective_obj, "activate");
			thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
			sleep_until (device_get_power(device(objective_obj)) > 0 and device_get_position(device(objective_obj)) > 0, 1);
			print ("an object was turned on");
		elseif device_get_position(device(objective_obj)) == 0 and device_get_power(device(objective_obj)) == 1 then
			print ("---destroy goal is a device machine that is currently on or a device control that is currently off");
			thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
			sleep_until (device_get_power(device(objective_obj)) < 1 or device_get_position(device(objective_obj)) > 0, 1);
			print ("an object was turned on or off");		
		else
			//f_blip_object (objective_obj, "activate");
			print ("---destroy goal is a device control that is currently on");
			thread (f_blip_object_cui (objective_obj, "navpoint_deactivate"));
			sleep_until (device_get_position(device(objective_obj)) < 1, 1);
			print ("an object was turned off");
		end
		//f_unblip_object (objective_obj);
		f_unblip_object_cui (objective_obj);
	else
		print ("---destroy goal is a destructible object");
		//turns on the HUD pointers and HUD health marker
		//f_blip_object (objective_obj, "neutralize");
		thread (f_blip_object_cui (objective_obj, "navpoint_healthbar_neutralize"));
		sleep_until (object_get_health(objective_obj) <= 0, 1);
		print ("an object was destroyed");
	end
	print ("s_all_objectives_count is now +1");
	s_all_objectives_count = s_all_objectives_count + 1;
end


// ================================================================================================================
//========= (DEFENSE) DEFEND OBJECTIVE SCRIPTS ====================================
// ================================================================================================================


script continuous objective_defend
	sleep_forever();
	print ("------objective defend started------");
	b_goal_ended = false;
	
	//set the objective objects
	//these are set in the game variant tag under "objective 1 - 4"
	if firefight_mode_get_current_objective(0) == 0 then
		print ("no objective set in tag for objective 0 :(");
	else
		obj_defend_1 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
		print ("objective 0 is set");
		inspect (obj_defend_1);
	end
	
	if firefight_mode_get_current_objective(1) == 0 then
		print ("no objective set in tag for objective 1 :(");
	else
		obj_defend_2 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(1));
		print ("objective 1 is set");
		inspect (obj_defend_2);
	end
	
	//set the timer variable to the user data field then translate that to minutes
	r_defend_timer = firefight_mode_get_current_user_data() * 60 * 30;
	
	//make sure the defend timer is never set to 0.  Default it to 5 minutes
	if r_defend_timer == 0 then
		print ("-----WARNING---- no defend timer is set in the tag -- defaulting time to 5 minutes");
		r_defend_timer = 10.0 * 60 * 30;
	else
		print ("---defend timer is set for...");
		inspect (r_defend_timer);
	end
			
	//prep generators
	ai_object_set_team (obj_defend_1, player);
	object_set_allegiance (obj_defend_1, player);
	object_immune_to_friendly_damage (obj_defend_1, true);
	ai_object_set_team (obj_defend_2, player);
	object_set_allegiance (obj_defend_2, player);
	object_immune_to_friendly_damage (obj_defend_2, true);
	
	//place the AI
	//ai_place (sq_ff_marines);
	ai_allegiance (human, player);
	ai_allegiance (player, human);
	thread (defend_ai());
	thread (defend_lose_condition());
	
	//this sleep might be unneccesary now
//	sleep (30 * 8);
	print ("DEFEND!!");

	wake (objective_timer);
	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	
	//turns on the HUD pointers and HUD health marker

//	f_blip_object (obj_defend_1, "a");
//	f_blip_object (obj_defend_2, "b");
	
	thread (f_blip_object_cui (obj_defend_1, "navpoint_healthbar_defend"));
	thread (f_blip_object_cui (obj_defend_2, "navpoint_healthbar_defend"));


		//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	print ("defend 1/5th time");
	NotifyLevel("defend_1/5");
	f_add_lives();
	
	//wake the turrets -- this should probably be in it's own script
//	NotifyLevel("start_turrets");
//	cinematic_set_title (turret_active);
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 2/5th time");
		NotifyLevel("defend_2/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 3/5th time");
		NotifyLevel("defend_3/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 4/5th time");
		NotifyLevel("defend_4/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end
	
	//sleep for 1/5 the alloted time
	sleep_until (b_goal_ended == true or b_all_waves_ended == true, 1, r_defend_timer / 5.0);
	if (b_goal_ended == false and b_all_waves_ended == false) then
		print ("defend 5/5th time -- all done");
		NotifyLevel("defend_5/5");
		f_add_lives();
	else
		print ("objective defend ended because of lives or all the waves have ended");
	end

//unblip the objects once the objective is complete
	if (object_get_health (obj_defend_1) > 0) then
		f_unblip_object_cui (obj_defend_1);
	end
	if (object_get_health (obj_defend_2) > 0) then
		f_unblip_object_cui (obj_defend_2);
	end
	
//stop any audio warnings
	sound_looping_stop (fx_misc_warning);
	sound_looping_stop (fx_misc_warning_2);	
	
	print ("------objective defend completed------");
	
	b_goal_ended = true;
	
end

script static void defend_ai

	repeat
		sleep_until (ai_living_count (ai_ff_all) > 0);
		ai_set_objective (ai_ff_all, objective_defend);
	//	ai_set_objective (ai_ff_all, obj_defend);
		
		//AI wants to kill the defend objects
		if (object_get_health (obj_defend_1) > 0) then
			ai_magically_see_object (ai_ff_all, obj_defend_1);
			ai_object_set_targeting_bias (obj_defend_1, 0.85);
			print ("--AI fighting object 1");
		elseif (object_get_health (obj_defend_2) > 0) then
			ai_magically_see_object (ai_ff_all, obj_defend_2);
			ai_object_set_targeting_bias (obj_defend_2, 0.85);
			print ("--AI fighting object 2");
		
		end
		sleep (30 * 5);
		//	(ai_living_count (ai_ff_all) <= 0) or
		//	(object_get_health (obj_defend_1) <= 0);
	until (b_goal_ended == true or
				(object_get_health(obj_defend_1) + object_get_health(obj_defend_2) <= 0), 1);
				print ("--both defend objects destroyed");
	
	//reset all the AI objectives after the player goal is done
	ai_set_objective (ai_ff_all, obj_survival);
end

script static void defend_lose_condition
	sleep_until (object_get_health (obj_defend_1) >= 0 and object_get_health (obj_defend_2) >= 0);
	
	sleep_until (object_get_health (obj_defend_1) <= 0.5 or object_get_health (obj_defend_2) <= 0.5);
	sound_looping_start (fx_misc_warning, NONE, 1.0);
	
	sleep_until (object_get_health (obj_defend_1) <= 0 or object_get_health (obj_defend_2) <= 0);
	sound_looping_stop (fx_misc_warning);
	cinematic_set_title (defend_object_destroyed);
	
	sleep_until (object_get_health (obj_defend_1) <= 0.5 and object_get_health (obj_defend_2) <= 0.5);
	sound_looping_start (fx_misc_warning_2, NONE, 1.0);
	
	sleep_until (object_get_health (obj_defend_1) <= 0 and object_get_health (obj_defend_2) <= 0);
		cinematic_set_title (failed);
		
	b_goal_ended = true;
	print ("------objective defend LOST!!------");
	sound_looping_stop (fx_misc_warning_2);

end

// ================================================================================================================
//============== (NO MORE WAVES) SWARM OBJECTIVE SCRIPTS ====================================
// ================================================================================================================



script continuous objective_swarm
	sleep_forever();
	print ("------objective swarm (NO MORE WAVES) started------");
	b_goal_ended = false;

//	sleep (30 * 5);
	//turn all AI into follow/kill the player AI
	//commenting this out so that we have more control per goal.  Don't think we always want the AI to kill the player
//	ai_set_objective (ai_ff_all, obj_survival);

	wake (objective_timer);
	
	//wait until the players have spawned to show HUD items and start the logic
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
	
	//set a 'goto' marker if there is a variable in the objective field
	if firefight_mode_get_current_objective(0) > 0 then
		flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
		//put a HUD marker on the spot players should go
		//f_blip_object (flag_0, "recon");
		thread (f_blip_object_cui (flag_0, "navpoint_generic"));
		print ("Swarm area blipped at flag");
		inspect (flag_0);		
	end
	
	//this is the squad group that this goal is looking force_debugger_not_present
	
	
	//sleep until the final wave
	sleep_until (firefight_mode_wave_get() == firefight_mode_waves_in_player_goal() - 1, 1);
	
//	sleep (30 * 5);
	//sleep until the final wave is finished
	sleep_until (b_all_waves_ended, 1);
	
	//turn off the marker if one was set
	if firefight_mode_get_current_objective(0) != 0 then
		f_unblip_object_cui (flag_0);
	end
	
	print ("------objective swarm ended------");
	b_goal_ended = true;
end


// ================================================================================================================
//================= (OTHER) CAPTURE OBJECTIVE SCRIPTS ====================================
// ================================================================================================================

script continuous objective_capture
	sleep_forever();
	b_goal_ended = false;
	print ("......objective capture started.......");
	b_capture_marker = false;
	wake (objective_timer);
	objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (objective_obj);
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
		//chud_track_object_with_priority (objective_obj, 4);
	//f_blip_object (objective_obj, "recon");
	//thread (f_blip_object_cui (objective_obj, "navpoint_goto"));
	
//	//wait until the power module is picked up
//	sleep_until
//		(
//			unit_has_equipment ((player0), equipment_capture) or
//			unit_has_equipment ((player1), equipment_capture) or
//			unit_has_equipment ((player2), equipment_capture) or
//			unit_has_equipment ((player3), equipment_capture)
//		);
//		
		
	if device_get_position(device(objective_obj)) == 0 then
		print ("---capture object is a device control that is currently off");
		thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
		sleep_until (device_get_position(device(objective_obj)) > 0, 1);
		print ("capture object has been picked up");
		
	elseif
		device_get_position(device(objective_obj)) == 1 then
		print ("---destroy goal is a device control that is currently on");
		thread (f_blip_object_cui (objective_obj, "navpoint_activate"));
		sleep_until (device_get_position(device(objective_obj)) < 1, 1);
		print ("capture object has been picked up");
		
	end	
	
	//call HUD marker here.  It should stay up until the the mission is over
	cinematic_set_title (got_artifact);
	b_capture_marker = true;
	
	//f_unblip_object (objective_obj);
	f_unblip_object_cui (objective_obj);
	//objective is complete
		print ("------objective capture ended------");
	b_goal_ended = true;
	//end event

end

// ================================================================================================================
//============= (OBJECT DELIVERY) DEPOSIT OBJECTIVE SCRIPTS (TAKE)====================================
// ================================================================================================================

script continuous objective_take
	sleep_forever();
	b_goal_ended = false;
	print ("......objective take started.......");
	wake (objective_timer);
	//set the objectives to the objectives set in Bonobo
	//objective_obj = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (flag_0);
	//tv_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(2));
	
	//create the object that players are taking the object - not necessary because the game_engine creates all objectives at the beginning of the match
	//object_create (flag_0);
	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	print ("------player(s) are alive------");
	
	
	//call HUD marker if not already called
	if b_capture_marker == false then
//		call HUD marker
		cinematic_set_title (got_artifact);
		b_capture_marker = true;
		print ("players have been 'given' the capture object or artifact");
	else
		print ("players already have the capture object or artifact");
	end
	
	//put a HUD marker on the drop off spot
	//f_blip_object (flag_0, "recon");
	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	sleep (1);
	

	
	//change the radius of detecting the players
	local short objectDistance = 5;
	if firefight_mode_get_current_user_data() > 0 then
		objectDistance = firefight_mode_get_current_user_data();
	end
	
	print ("The radius of the marker is...");
	inspect (objectDistance);
	
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ), 1);	
	
	print ("------player(s) made it to the drop off spot------");
	cinematic_set_title (artifact_returned);
	
	//turn off the hud markers for the drop off spot and the object
	//turn off HUD marker
	b_capture_marker = false;
	//f_unblip_object (objective_obj);
	//f_unblip_object_cui (objective_obj);
	
	sleep (1);
	//f_unblip_object (flag_0);
	f_unblip_object_cui (flag_0);	
	
	//end the goal
	print ("------objective take ended------");
	b_goal_ended = true;
end

// ================================================================================================================
//========== LOCATION ARRIVAL OBJECTIVE SCRIPTS (A to B)====================================
// ================================================================================================================
script continuous objective_atob
sleep_forever();
	b_goal_ended = false;
	print ("------objective AtoB started------");
	wake (objective_timer);
	flag_0 = firefight_mode_get_objective_name_at(firefight_mode_get_current_objective(0));
	inspect (flag_0);
	print ("------objective AtoB sleeping------");
	sleep_s (1);
	
	//sleep until they have gotten to the right spot on the map
	
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
		
	print ("------player0 is alive------");
	
	//print out if there is not a proper flag created
	if objects_distance_to_object ((player0), flag_0) == -1 then
		print ("there is no object set to check the distance");
	end

	//put a HUD marker on the spot players should go
	//f_blip_object (flag_0, "recon");
	thread (f_blip_object_cui (flag_0, "navpoint_goto"));
	
	//change the radius of detecting the players
	local short objectDistance = 5;
	if firefight_mode_get_current_user_data() > 0 then
		objectDistance = firefight_mode_get_current_user_data();
	end
	
	print ("The radius of the marker is...");
	inspect (objectDistance);
	//sleep until they have gotten to the right spot on the map
	sleep_until (
		(objects_distance_to_object ((player0), flag_0) <= objectDistance and objects_distance_to_object ((player0), flag_0) > 0 ) or
		(objects_distance_to_object ((player1), flag_0) <= objectDistance and objects_distance_to_object ((player1), flag_0) > 0 ) or
		(objects_distance_to_object ((player2), flag_0) <= objectDistance and objects_distance_to_object ((player2), flag_0) > 0 ) or
		(objects_distance_to_object ((player3), flag_0) <= objectDistance and objects_distance_to_object ((player3), flag_0) > 0 ), 1);	
	print ("------player(s) made it to the location------");
	
	//f_unblip_object (flag_0);
	f_unblip_object_cui (flag_0);
	
	print ("------objective AtoB ended------");
	b_goal_ended = true;
end


// ================================================================================================================
//=========== KILL BOSS OBJECTIVE SCRIPTS ====================================
// ================================================================================================================
script continuous objective_kill_boss
	sleep_forever();
	print ("------objective kill boss started------");
	b_goal_ended = false;
	ai_boss_objective = firefight_mode_get_squad_at(firefight_mode_get_current_objective(0));
	ai_place (ai_boss_objective);
	sleep (60);
	
	//wait until the players have spawned to show HUD items
	sleep_until (
		object_get_health(player0) > 0 or
		object_get_health(player1) > 0 or
		object_get_health(player2) > 0 or
		object_get_health(player3) > 0, 1);
	
	sleep_until (b_wait_for_narrative_hud == false or ai_living_count (ai_boss_objective) <= 0, 1);
	if ai_living_count (ai_boss_objective) <= 0 then
		print ("AI BOSS DEAD, not blipping them");
	else
		print ("blipping Boss");
		f_blip_ai_cui (ai_boss_objective, "navpoint_enemy");
//	f_blip_ai (firefight_mode_get_squad_at(firefight_mode_get_current_objective(0)), "enemy");
//	think about putting in triggers for half health, etc.
		sleep_until(ai_living_count (ai_boss_objective) <= 0, 1);
	end
	print ("------objective kill boss ended------");
	b_goal_ended = true;

end


// ================================================================================================================
//========= WAIT FOR TRIGGER (TIME PASSED) OBJECTIVE SCRIPTS ====================================
// ================================================================================================================

script continuous objective_wait_for_trigger
	sleep_forever();
	print ("------objective wait for trigger started------");
	b_goal_ended = false;
	b_end_player_goal = false;
	
	sleep_until(b_end_player_goal == true, 1);
	print ("------b_end_player goal is true------");
	print ("------objective wait for trigger ended------");
	b_goal_ended = true;
	
end

// ================================================================================================================
//======== BLIP SCRIPTS ====================================
// ================================================================================================================


// ===== THESE ARE TEST SCRIPTS TO TEST OUT THE NEW CUI NAV MARKERS -- THESE NEED TO GO INTO THE GLOBAL SCRIPTS ONCE CAMPAIGN IS READY -- SEPT 27, 2011 -- GMURPHY
// blip an object temporarily
script static void f_blip_object_cui (object obj, string_id type)
	//chud_track_object_with_priority (obj, f_return_blip_type (type));
	//wait for the narrative to get done before turning on HUD
	sleep_until (b_wait_for_narrative_hud == false, 1);
	navpoint_track_object_named (obj, type);
end

script static void f_unblip_object_cui (object obj)
	//chud_track_object (obj, false);
	//turn off the narrative HUD tracking and turn off the HUD markers
	kill_script (f_blip_object_cui );
	//b_wait_for_narrative_hud = false;
	navpoint_track_object (obj, false);
	
end	


script static void f_blip_ai_cui (ai group, string_id blip_type)
	sleep_until( (b_blip_list_locked == false), 1);
	print ("blipping ai");
	b_blip_list_locked = true;
	s_blip_list_index = 0;
	
	l_blip_list = ai_actors (group);
	repeat
		print ("repeating BLIPPING finding the health of the actors");
			if ( object_get_health (list_get (l_blip_list, s_blip_list_index) )> 0) then
				//f_blip_object_cui (list_get (l_blip_list, s_blip_list_index), blip_type);
				navpoint_track_object_named (list_get (l_blip_list, s_blip_list_index), blip_type);
			end	
			
			s_blip_list_index = (s_blip_list_index + 1);
		until ( s_blip_list_index >= list_count (l_blip_list), 1);
	print ("done blipping ai");
	b_blip_list_locked = false;
end


script static void f_unblip_ai_cui (ai group)
	sleep_until( (b_blip_list_locked == false ), 1);
	print ("unblipping ai");
	b_blip_list_locked = true;
	s_blip_list_index = 0;
	
	l_blip_list = ai_actors (group);
	repeat
		print ("repeating finding the health of the actors");
			if ( object_get_health (list_get (l_blip_list, s_blip_list_index)) > 0) then
				//f_unblip_object_cui (list_get (l_blip_list, s_blip_list_index));
				navpoint_track_object (list_get (l_blip_list, s_blip_list_index), false);
			end	
			s_blip_list_index = (s_blip_list_index + 1);
	until ( s_blip_list_index >= list_count (l_blip_list), 1);
	print ("done unblipping ai");
	b_blip_list_locked = false;
	b_enemies_are_blipped == false;
end


//==================OBJECTIVE TEXT ON SCREEN================================================

//global cutscene_title objective_text = dashes;


//new objective script
//script static void f_new_objective (cutscene_title objective_text)
script static void f_new_objective (string_id objective_text)

//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
//	cinematic_set_title (dashes);
//	
//	sleep (30 * 1);
//	
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
//	cinematic_set_title (dashes_2);
//	
//	sleep (30 * 1);
//	
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
//	cinematic_set_title (new_obj);
//	
//	sleep (30 * 4);
//	
//	sound_impulse_start (sound\game_sfx\ui\transition_beeps, NONE, 1);
	if editor_mode() then
		cinematic_set_title (new_obj);
	end
	print ("new objective HUD");
	cui_hud_set_new_objective (objective_text);

end

//objective complete script
script static void f_objective_complete
//	sleep (30 * 1);
//	cinematic_set_title (dashes);
//	
//	sleep (30 * 1);
//	cinematic_set_title (dashes_2);
//	
//	sleep (30 * 1);
//	cinematic_set_title (obj_complete_text);
//	
//	sleep (30 * 3);
	if editor_mode() then
		cinematic_set_title (obj_complete_text);
	end
	print ("objective complete HUD");
	cui_hud_set_objective_complete (obj_complete_text);
end


//==================WAVE START EVENTS================================================
script continuous f_start_events_waves_incoming
	sleep_until (LevelEventStatus("incoming"), 1);
	cinematic_set_title (incoming);
	sound_impulse_start (vo_misc_incoming, none, 1.0);
end

script continuous f_start_events_waves_invading
	sleep_until (LevelEventStatus("invading"), 1);
	cinematic_set_title (invading);
	sound_impulse_start (vo_misc_invading, none, 1.0);
	sound_looping_start (fx_misc_warning, NONE, 1.0);
	sleep (30 * 20);
	sound_looping_stop (fx_misc_warning);
end

//script continuous f_start_events_waves_weapon_drop
//	sleep_until (LevelEventStatus("weapon_drop"), 1);
//	cinematic_set_title (weapon_drop);
//	sound_impulse_start (vo_misc_weapon_drop, none, 1.0);
//	f_weapon_drop();
//end


//*========================================================
//===============MISC START EVENTS================================================
//*========================================================

script continuous f_misc_set_objective_attack
	sleep_until (LevelEventStatus ("attack_players"), 1);
	print ("attack players");
	ai_set_objective (ai_ff_all, obj_survival);
	
end

//======MISC END EVENTS================================================

script continuous f_end_events_misc_good_work
	sleep_until (LevelEventStatus("good_work"), 1);
	cinematic_set_title (good_work);
	sound_impulse_start (vo_misc_good_work, none, 1.0);
end




// ================================================================================================================
//==================== TEST SCRIPTS ====================================
// ================================================================================================================


script continuous f_default_mission
	sleep_until (LevelEventStatus("test_debug"), 1);
	mission_is_test_debug = true;
	
	switch_zone_set (empty);
	
	firefight_mode_set_crate_folder_at(spawn_points_0, 90);
	
	firefight_mode_set_objective_name_at(lz_0, 	50);
	
	print ("mission is the test_debug mission");
	print ("only 1 spawn folder is active, nothing more -- have fun running around the map");
	sleep_forever();
end

