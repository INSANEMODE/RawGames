// =================================================================================================
// =================================================================================================
// =================================================================================================
// CHECKPOINT HELPERS
// =================================================================================================
// =================================================================================================
// =================================================================================================

// -------------------------------------------------------------------------------------------------
// CHECKPOINT: GENERAL
//	Combat checkpoints manage saving during combat.
// -------------------------------------------------------------------------------------------------

script static long checkpoint_timeout( boolean b_auto_cancel, real r_time, string str_debug )
	if ( not game_safe_to_save() ) then
		thread( sys_checkpoint(b_auto_cancel, r_time, str_debug) );
	else
		checkpoint_immediate( str_debug );
		0;
	end
end

script static long checkpoint_no_timeout( boolean b_auto_cancel, string str_debug )
	if ( not game_safe_to_save() ) then
		thread( sys_checkpoint(b_auto_cancel, -1, str_debug) );
	else
		checkpoint_immediate( str_debug );
		0;
	end
end

script static void checkpoint_immediate( string str_debug )
	dprint( "SAVE START $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
	dprint( str_debug );
	game_save_immediate();
	dprint( "SAVE END $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
end

script static void sys_checkpoint( boolean b_auto_cancel, real r_time, string str_debug )
static long l_save_thread = 0;
local long l_timer = 0;

	//dprint( "SAVE WAITING START $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
	//dprint( str_debug );
	
	// store the current save thread
	l_save_thread = GetCurrentThreadId();
	
	// start the timer
	if ( r_time >= 0 ) then
		l_timer = game_tick_get() + seconds_to_frames( r_time );
	end

	// wait for safe save, thread disabled, or timer expires
	sleep_until( game_safe_to_save() or ((b_auto_cancel) and (l_save_thread != GetCurrentThreadId())) or ((l_timer != 0) and (l_timer <= game_tick_get())), 1 );
	
	// check if it's valid to save
	if ( game_safe_to_save() ) then
		checkpoint_immediate( str_debug );
	end

	//dprint( "SAVE WAITING END $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$" );
end



// -------------------------------------------------------------------------------------------------
// CHECKPOINT: COMBAT
//	Combat checkpoints manage saving during combat.
// -------------------------------------------------------------------------------------------------
// variables
global boolean 	B_combat_checkpoint_paused = FALSE;
global long 		L_combat_checkpoint_thread_ID = 0;

// functions
// === f_combat_checkpoint_start: Starts a combat checkpoint.  Combat checkpoints wait for safe 
//																times in the combat encounter to checkpoint. There are options 
//																for managing the frequency of checkpoints.  When the squad is 
//																completely dead it will automatically shut down.
//		ai_watch [ai] 						- AI (single ai, squad, etc.) the AI the combat checkpoint watches
//		s_ai_state_start [short] 	- Minimum ai state to start combat checkpoint
//																[s_ai_state_start < 0] = DEFAULT; AI must be in a combat state
//		b_safe_toggled [boolean]	- Will not start the watch check until the game_safe_to_save() has
//																has toggled false.
//		s_checkpoint_max [short]	- Maximum number of checkpoints allowed in this combat checkpoint
//																-1 = Unlimited
//		r_time_delay [real]				- Minimum seconds between checkpoints
//		r_time_out [real]					- Maximum time the combat checkpoint will run for
//																< 0 = Unlimited
//	NOTE: Currently there can only be one combat checkpoint active at a time
//				Starting a new combat checkpoint will automatically kill the previous combat checkpoint thread
script static long f_combat_checkpoint_add( ai ai_watch, short s_ai_state_start, boolean b_safe_toggled, short s_checkpoint_max, real r_time_delay, real r_time_out )

	// defaults
	if ( s_ai_state_start < 0 ) then
		s_ai_state_start = ai_combat_status_uninspected;
	end

	// make sure there's no thread to active
	f_combat_checkpoint_remove( 0 );
	
	// start the loop
	L_combat_checkpoint_thread_ID = thread( sys_combat_checkpoint(ai_watch, s_ai_state_start, b_safe_toggled, s_checkpoint_max, r_time_delay, r_time_out) );
	
	// return
	L_combat_checkpoint_thread_ID;
	
end

// === f_combat_checkpoint_kill: Kills the current running combat checkpoint thread
//		l_checkpoint_ID [long]- ID for the checkpoint to pause
//																0 = Any checkpoint
script static void f_combat_checkpoint_remove( long l_checkpoint_ID )

	if ( f_combat_checkpoint_check(l_checkpoint_ID) ) then
		kill_thread( L_combat_checkpoint_thread_ID );
		L_combat_checkpoint_thread_ID = 0;
	end

end

// === f_combat_checkpoint_pause: Pauses the combat checkpoint system from saving
//		l_checkpoint_ID [long]- ID for the checkpoint to pause
//																0 = Any checkpoint
//		b_pause [boolean] 				- Is the combat checkpoint system paused or not
//	NOTE: The purpose for this is if you want to prevent the player from saving during an event or
//				They are in a risky area, you can use this to manage the safety of the checkpoint
script static void f_combat_checkpoint_pause( long l_checkpoint_ID, boolean b_pause )
	if ( (l_checkpoint_ID == 0) or (l_checkpoint_ID == L_combat_checkpoint_thread_ID) ) then
		B_combat_checkpoint_paused = b_pause;
	end
end

// === f_combat_checkpoint_check: Checks if this is the current combat checkpoint ID
//		l_checkpoint_ID [long]- ID for the checkpoint to pause
//																0 = Any checkpoint
script static boolean f_combat_checkpoint_check( long l_checkpoint_ID )
	( L_combat_checkpoint_thread_ID != 0) and ( (l_checkpoint_ID == 0) or (l_checkpoint_ID == L_combat_checkpoint_thread_ID) );
end

// === sys_combat_checkpoint: This handles the logic for the combat checkpoint, etc.
//	NOTE: DO NOT USE THIS FUNCTION
script static void sys_combat_checkpoint( ai ai_watch, short s_ai_state_start, boolean b_safe_toggled, short s_checkpoint_max, real r_time_delay, real r_time_out )
static long l_time_delay = 0;
static long l_time_out = 0;
	
	// wait for at least one to spawn
	sleep_until( ai_spawn_count(ai_watch) > 0, 1 );
	
	// wait for AI to reach it's starting state
	sleep_until( ai_combat_status(ai_watch) >= s_ai_state_start, 1 );;
	
	// start the time out timer
	l_time_out = 0;
	if ( r_time_out >= 0.0 ) then
		l_time_out = game_tick_get() + seconds_to_frames( r_time_out );
	end
	
	repeat
	
		// set delay
		l_time_delay = 0;
		if ( r_time_delay >= 0.0 ) then
			l_time_delay = game_tick_get() + seconds_to_frames( r_time_delay );
		end
		if ( b_safe_toggled ) then
			sleep_until( (not game_safe_to_save()) or (ai_living_count(ai_watch) <= 0) or (l_time_out < game_tick_get()), 1 );
		end
	
		sleep_until(
			( 
				(
					not B_combat_checkpoint_paused
				)
				and
				(
					game_safe_to_save()
				)
				and 
				(
					( ai_living_count(ai_watch) <= 0 )
					or
					( (r_time_delay < 0.0) or (l_time_delay <= game_tick_get()) )
				)
			)
			or
			(
				(r_time_out >= 0.0) and (l_time_out < game_tick_get())
			)
		, 1 );

		// try to save		
		if ( (game_safe_to_save()) and (not B_combat_checkpoint_paused) and (l_time_out >= game_tick_get()) ) then
			checkpoint_no_timeout( FALSE, "sys_combat_checkpoint" );

			s_checkpoint_max = s_checkpoint_max - 1;
		end
		
	until( (s_checkpoint_max == 0) or (ai_living_count(ai_watch) <= 0) or (l_time_out < game_tick_get()), 1 );
	dprint( ">>>>>>>>>> COMBAT CHECKPOINT EXIT!!! >>>>>>>>>>" );

	// kill the thread identity
	L_combat_checkpoint_thread_ID = 0;

end
