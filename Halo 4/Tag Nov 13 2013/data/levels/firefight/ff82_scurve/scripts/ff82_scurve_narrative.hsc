// =============================================================================================================================
//============================================ SCURVE NARRATIVE SCRIPT ========================================================
// =============================================================================================================================


// behold, the greatest narrative script ever to pass through the halls of 343...or 550...or whatever...it will be good anyway.

global object pup_player0 = player0;
global object pup_player1 = player1;
global object pup_player2 = player2;
global object pup_player3 = player3;
global boolean b_pelican_done = false;

script startup sparops_e01_m05_main()
	
	dprint (":::  NARRATIVE SCRIPT  :::");
	
end
//
//


script static void ex1()
	//fires e1 m5 Narrative Out scene
	
//	ai_erase (squads_elite);
//	ai_erase (squads_jackal);
//	ai_place (squads_elite);
//	ai_place (squads_jackal);

	pup_play_show(e1_m5_intro_vin);
	
//	pup_play_show(e1_m5_narrative_in);
	
end


script static void ex2()
	//fires e1 m5 Narrative Out scene
	
	ai_erase (squads_1);
	ai_erase (squads_2);
	ai_erase (squads_3);
	
	pup_play_show(e1_m5_narrative_out);
	
end


script static void ex3()
	// plays e2m2 intro
	
	scene_e2m2_intro();
	
end


script static void scene_e2m2_intro()
	// scripting to control E2 M2 intro scene
	
//	fade_out (0, 0, 0, 1);
	camera_control (true);
	chud_show (false);
	camera_fov = 22;
	camera_pan (e2m2_camin_01_1, e2m2_camin_01_2, 300, 0, 1, 0, 1);
	fade_in (0, 0, 0, 90);
	
	sleep (75);
	ai_place (sq_e2m2_pelican_1);
	
	sleep (180);
	camera_fov = 22;
	camera_pan (e2m2_camin_02_1, e2m2_camin_02_2, 230, 0, 1, 0, 1);
	
	sleep (195);
	
	fade_out (0, 0, 0, 30);
	sleep (30);
	
	camera_control (false);
	camera_fov = 78;
	
	ai_erase (sq_e2m2_pelican_1);
	chud_show (true);
	//fade_in (0, 0, 0, 1);
	
end


script command_script cs_e2m2_intro()
	// e2m2 pelican fly-in
	
	cs_ignore_obstacles (TRUE);
	
	cs_fly_by (ps_e2m2_intro.p0);
	sleep (2);
	cs_vehicle_speed (.5);
 	cs_fly_to_and_face (ps_e2m2_intro.p1, ps_e2m2_intro.p2);
	
end


script command_script cs_evac()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it�s avoiding things for no reason
	
 	cs_fly_by (ps_e1m5_evac.p5);
	// cs_fly_by (ps_e1m5_evac.p6);
	
  cs_vehicle_speed (.3); 
  //Slows down the vehicle
  
  cs_fly_to_and_face (ps_e1m5_evac.p0, ps_e1m5_evac.p1);
  
  cs_vehicle_speed (.2);
  
  sleep_s (2.5);
  
  cs_fly_to_and_face (ps_e1m5_evac.p1, ps_e1m5_evac.p2);
  
  sleep_s (.5);
  b_pelican_done = true;
  
  cs_vehicle_speed (0.05);
  
//  repeat 
//		
//		dprint ("next noise loop");
//		
//		cs_fly_to_and_face  (ps_e1m5_evac.p7, ps_e1m5_evac.p2);
//		//sleep (90);
//		
//		cs_fly_to_and_face  (ps_e1m5_evac.p6, ps_e1m5_evac.p2);
//		//sleep (90);
//
//	until (1 == 0, 15); // set the time here to be whatever instead of 1/2 a second
//  
end


script command_script cs_evac_phantom()

	cs_ignore_obstacles (TRUE); 
	//This command tells the Pelican to ignore anything in its way, useful to turn on if it looks like it�s avoiding things for no reason
	
  //cs_vehicle_speed (.5); 
  //Slows down the vehicle
  
  cs_fly_by (ps_e1m5_evac.p_phantom_1);
  
end


script command_script cs_evac_leave()
	// pelican leaves in cutscene
	
	cs_vehicle_speed (1.0);
//	cs_fly_by (ps_e1m5_evac.p3);
	cs_fly_to (ps_e1m5_evac.p8);
	
end


//script startup jesse_playground_main()
//
//	//thread (m40_target_designator_main());
//
//	local long thread_id = thread(pelican_flyto_random_points());
//	sleep_s(5);
//	kill_thread(thread_id);
//
//end


script static void pelican_flyto_random_points()
	// loops flying to random points for pelican

	repeat 
	
		cs_vehicle_speed (squads_1, .01);
		
		dprint ("next noise loop");
		
		begin_random_count(1)
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p6, ps_e1m5_evac.p2);
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p7, ps_e1m5_evac.p2);
			cs_fly_to_and_face  (squads_1, 1, ps_e1m5_evac.p1, ps_e1m5_evac.p2);
		end
	until (1 == 0, 90); // set the time here to be whatever instead of 1/2 a second
	
end 


script static void scene_narrative_out()
	// set camera move for final shot
	
	ai_erase (squads_1);
	pup_play_show (e1_m5_out_vin);

// 	OLD VERSION OF THE SCENE
	
//	cs_run_command_script (squads_1, command_script_ender);
//	
//	camera_control (true);
//	camera_fov = 22;
//	camera_pan (e1m5_out_01_1, e1m5_out_01_2, 110, 0, 1, 0, 1);
//	sleep (30);
//	cs_run_command_script (squads_1, cs_evac_leave);
//	sleep (75);
//	
//	camera_fov = 55;
//	camera_pan (e1m5_out_02_1, e1m5_out_02_2, 270, 0, 1, 140, 0);
//	
//	thread (f_music_e1_m5_6_end());
//	
//	sleep (240);
//	fade_out (0, 0, 0, 30);
	
//	sleep (30);
//	camera_control (false);
//	fade_in (0, 0, 0, 1);
	
end


//script static void e3_fluttercut_knight()
//	// plays E3 Fluttercut Knight scene
//	
//	pup_play_show (e3_fluttercut_knight);
//	
//end


script command_script cs_e1m5_in_phantom()
	// flies-in phantom
	
	cs_ignore_obstacles (TRUE); 	
  //cs_vehicle_speed (.5); 
  
  //cs_fly_by (ps_e1m5_in_phantom.p0);
  cs_fly_by (ps_e1m5_in_phantom.p1);
  cs_fly_to_and_face  (ps_e1m5_in_phantom.p2, ps_e1m5_in_phantom.p3);
	
end

script command_script command_script_ender()
	print ("ended a command script");
end


// =============================================================================================================================
//=======RVB SCURVE Ep 01 Mission 05 VO scripts ==================================================
// =============================================================================================================================


		//Original Script:
		//PALMER (RADIO)
		//Commander Palmer to Fireteam Castle. You're on, Spartans. Dalton's got targets for you.
		//CASTLE LEADER CABOOSE (RADIO)
		//Affirmative, Commander.Um, the regular radio guy isn�t here right now. Sorry.
		//Original Script:
		//PALMER (RADIO)
		//Fireteam Castle, this is Commander Palmer! I need an ETA on clear skies!
		//CASTLE LEADER CABOOSE (RADIO)
		//It's going to take a bit longer, Commander! We're doing all we can!Seriously, the regular guy said he would be right back. He�s in the bathroom.
		//
		//Original Script:
		//PALMER (RADIO)
		//(impatient now)
		//Castle?
		//CASTLE LEADER CABOOSE (RADIO)
		//We got it, Commander!I�m just going to take a message for you.

script static void vo_e1m5_rvb1()
	print ("start rvb1");
	print ("Affirmative, Commander.Um, the regular radio guy isn�t here right now. Sorry.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_moreknights_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_moreknights_00600'));
	print ("end rvb1");
end

script static void vo_e1m5_rvb2()
	print ("start rvb2");
	print ("Affirmative, Commander.Um, the regular radio guy isn�t here right now. Sorry.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_nextarea_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_nextarea_00500'));
	print ("end rvb2");
end

//script static void vo_e1m5_rvb3()
//	print ("start rvb1");
//	print ("Affirmative, Commander.Um, the regular radio guy isn�t here right now. Sorry.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200'));
//	print ("end rvb1");
//end



// =============================================================================================================================
//======================================= SCURVE Ep 01 Mission 05 VO scripts ==================================================
// =============================================================================================================================

global boolean b_dialog_playing = false;

script static void vo_e1m5_intro()
	// play over intro
	
//	//might should not play this line
//	// Miller : Crimson comms are open, Commander Palmer.
//	dprint ("Miller: Crimson comms are open, Commander Palmer.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00100'));

	sleep (30);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Okay, Crimson.  The data you pulled out of the jungle ties into some earlier info on Covenant archaeological teams.
	dprint ("Palmer: Okay, Crimson.  The data you pulled out of the jungle ties into some earlier info on Covenant archaeological teams.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00200'));
	
	sleep (30);

	// Palmer : The Covies have found a needle in the Requiem haystack, and you're going to stop them from retrieving it.
	dprint ("Palmer: The Covies have found a needle in the Requiem haystack, and you're going to stop them from retrieving it.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_intro_00300'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_playstart()
	// as gameplay starts

	sleep (41);
	
	start_radio_transmission( "palmer_transmission_name" );
	
	hud_play_pip_from_tag (bink\spops\ep1_m5_1_60);
	thread (pip_e1m5_1_subtitles());
	
	// Palmer : First things first, Crimson: eliminate anything that moves.
	dprint ("Palmer: First things first, Crimson: eliminate anything that moves.");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100_pip'));
	
	end_radio_transmission();
	
end

script static void pip_e1m5_1_subtitles()
	sleep_s (1.03);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100');
end

script static void vo_e1m5_playstart_test(short time)
	// as gameplay starts
	
	// Palmer : First things first, Crimson: eliminate anything that moves.
	dprint ("Palmer: First things first, Crimson: eliminate anything that moves.");
	
	
//	800_00A_3_QV0A01_()_00001275b (cut 2) Time � 12:19:32:21 � 12:19:38:24
//	e1m5_playstart_00100
//	1:07
	sleep (time);
	
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100', NONE, 1);
	
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_playstart_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_waypoint01()
	// bring up waypoint
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Enemy spotted at following waypoint, Crimson.
	dprint ("Miller: Enemy spotted at following waypoint, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_waypoint01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_waypoint01_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_turret1()
	// warn about first turret
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, advise you keep an eye on that turret.
	dprint ("Miller: Crimson, advise you keep an eye on that turret.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_turret01_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_turret01_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_doorspowerup()
	// if you went to doors first
	
	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Miller, find Crimson a way through those doors.
	dprint ("Palmer: Miller, find Crimson a way through those doors.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : There appears to be a power source here.  Activating waypoint now.
	dprint ("Miller: There appears to be a power source here.  Activating waypoint now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_doorsfirstswitch()
	// fires near switch if you went to doors first

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Power it up, Crimson.
	dprint ("Palmer: Power it up, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_doorsfirstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_doorsfirstswitch_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_ifswitchfirst()
	// if you go to switch first

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : No idea what that switch does, Crimson.
	dprint ("Miller: No idea what that switch does, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifswitchfirst_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifswitchfirst_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_switchbeforedoors()
	// at the switch before going to doors	

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Crimson, pressing buttons at random might be bad for your health.
	dprint ("Palmer: Crimson, pressing buttons at random might be bad for your health.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Actually, Commander,  I think Crimson's found a way to clear the path ahead of them.
	dprint ("Miller: Actually, Commander,  I think Crimson's found a way to clear the path ahead of them.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_switchbeforedoors_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_spire1()
	// mention of first spire

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Structural movement, Commander.
	dprint ("Miller: Structural movement, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spirelifts_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spirelifts_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_switchesid()
	// mark location of switches

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Crimson, I'm marking a pair of power sources that just appeared.  Activating them should clear the path between you and our Covenant archaeologists.
	dprint ("Miller: Crimson, I'm marking a pair of power sources that just appeared.  Activating them should clear the path between you and our Covenant archaeologists.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_powerid_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_powerid_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_switch1()
	// first switch done

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : That's one.
	dprint ("Miller: That's one.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_firstswitch_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_switch2()
	// second switch done

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Got 'em both.  Miller?
	dprint ("Palmer: Got 'em both.  Miller?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : I was right.  Door's opening, Commander.
	dprint ("Miller: I was right.  Door's opening, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Move ahead to the next area, Crimson.
	dprint ("Palmer: Move ahead to the next area, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_secondswitch_00300'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_moveon()
	// tell players to move on
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	//take out the first 2 lines if it's getting too busy

	start_radio_transmission( "dalton_transmission_name" );
		
	// Dalton : Commander?
	dprint ("Dalton: Commander?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Go ahead, Dalton.
	dprint ("Palmer: Go ahead, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : There's some serious anti-air activity happening in the area around Crimson.  We can't guarantee any kind of extraction.
	dprint ("Dalton: There's some serious anti-air activity happening in the area around Crimson.  We can't guarantee any kind of extraction.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Commander Palmer to Fireteam Castle.  You're on, Spartans.  Dalton's got targets for you.
	dprint ("Palmer: Commander Palmer to Fireteam Castle.  You're on, Spartans.  Dalton's got targets for you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00400'));


//if the players have found the rvb secret play the rvb dialog, else play regular dialog
	if b_rvb_interact == true then
		
		vo_e1m5_rvb2();
		
	else
	
		cui_hud_hide_radio_transmission_hud();
		sleep (10);
		cui_hud_show_radio_transmission_hud( "castle_transmission_name" );
		
		// Castle Leader : Affirmative, Commander.
		dprint ("Castle Leader: Affirmative, Commander.");
		sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00500', NONE, 1);
		sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_nextarea_00500'));
	
	end
	
	end_radio_transmission();
	
	b_dialog_playing = false;
	
end


script static void vo_e1m5_moreshields()
	// more shields come up
	
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : More shields.
	dprint ("Miller: More shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	hud_play_pip_from_tag (bink\spops\ep1_m5_2_60);
	thread (pip_e1m5_2_subtitles());

	// Palmer : Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.
	dprint ("Palmer: Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200_pip'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end

script static void pip_e1m5_2_subtitles()
	sleep_s (1.16);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200');
end


script static void vo_e1m5_moreshields_test(short time)
	// more shields come up

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : More shields.
	dprint ("Miller: More shields.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.
	dprint ("Palmer: Find a way to bring them down.  I don't like the Coveneant working this hard to guard a dig.");
	
//	800_00B_2_QV0A01_()_00001277b � Time � 12:28:06:29 to 12:28:12:15
//	e1m5_covshields_00200
//	1:17
	sleep (time);
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_covshields_00200'));
	
	end_radio_transmission();

end

script static void vo_e1m5_hackcontrols()
	// hack controls to take down shields
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : There's the shield controls.
	dprint ("Miller: There's the shield controls.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_hackcontrols_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_hackcontrols_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_didntwork()
	// that didnt work on the shields
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Huh.  That should have worked.  Let me try...
	dprint ("Miller: Huh.  That should have worked.  Let me try...");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Commander, I can't crack the shields electronically.
	dprint ("Miller: Commander, I can't crack the shields electronically.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson, give it a Spartan Hack.
	dprint ("Palmer: Crimson, give it a Spartan Hack.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_notworking_00300'));
	
	end_radio_transmission();

end


script static void vo_e1m5_spartanhack()
	// after "spartan hack"

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Works every time.
	dprint ("Palmer: Works every time.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spartanhack_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_spartanhack_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_crawlers()
	//intro to crawlers

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Those aren't archaeologists, Miller.
	dprint ("Palmer: Those aren't archaeologists, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : No, Commander.  Those are Crawlers.
	dprint ("Miller: No, Commander.  Those are Crawlers.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Shut them down, Crimson.
	dprint ("Palmer: Shut them down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_morecrawlers()
	//when more crawlers show up

	start_radio_transmission( "palmer_transmission_name" );
		
	// Palmer : Be careful Crimson!
	dprint ("Palmer: Be careful Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morecrawlers_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morecrawlers_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_knights()
	//first knights

	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : Commander Palmer!  Something new!
	dprint ("Miller: Commander Palmer!  Something new!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Promethean Knights.  Crimson, hese guys are a lot tougher than the Crawlers.  Concentrate your fire on single targets.  Take them down quick.
	dprint ("Palmer: Promethean Knights.  Crimson, hese guys are a lot tougher than the Crawlers.  Concentrate your fire on single targets.  Take them down quick.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_knights_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_foundcrew()
	// when you find the archaeologists

	start_radio_transmission( "palmer_transmission_name" );
		
		// Palmer : Shut them down, Crimson.
	dprint ("Palmer: Shut them down, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_crawlers_00300'));
	
	end_radio_transmission();
	
	// Palmer : There's our archaeologists.  Shut them down, Crimson.
//	dprint ("Palmer: There's our archaeologists.  Shut them down, Crimson.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_foundcrew_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_foundcrew_00100'));
//	
end


script static void vo_e1m5_allclear()
	// when the archaeologists are taken out

	start_radio_transmission( "palmer_transmission_name" );
	
	hud_play_pip_from_tag (bink\spops\ep1_m5_3_60);
	thread (pip_e1m5_3_subtitles());
	
	// Palmer : Promethean Knights are working alongside Covenant?  I don't like this.  Get a look at what they were guarding.
	dprint ("Palmer: Promethean Knights are working alongside Covenant?  I don't like this.  Get a look at what they were guarding.");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100_pip'));
	
	end_radio_transmission();
	
end

script static void pip_e1m5_3_subtitles()
	sleep_s (1.23);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100');
end

script static void vo_e1m5_allclear_test(real time)
	// when the archaeologists are taken out
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.
	dprint ("Palmer: Promethean Knights are working alongside Covenant.  That's bad news.  Get a look at what they were guarding.");
	
//	800_00C_1_QV0A01_()_00001278b (last cut) Time � 12:30:26:00 to 12:30:35:00
//	e1m5_allclear_00100
//	1:23
	sleep (time);

	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_allclear_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e1m5_artifact()
	// about the artifact
	
	sleep (120);

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : What is that?
	dprint ("Miller: What is that?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : I don't care.  If the Covies wanted it this badly, I'm happy to get it first.
	dprint ("Palmer: I don't care.  If the Covies wanted it this badly, I'm happy to get it first.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00200'));
	
	end_radio_transmission();

end


script static void vo_e1m5_moreknights()
	//more Knights
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Miller : Watch out!
	dprint ("Miller: Watch out!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Defend the artifact, Crimson!
	dprint ("Palmer: Defend the artifact, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200'));
	
	sleep (10);

	// Palmer : Dalton!  Crimson needs immediate evac!
	dprint ("Palmer: Dalton!  Crimson needs immediate evac!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : Still working with Castle to take down air defenses, Commander!
	dprint ("Dalton: Still working with Castle to take down air defenses, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!
	dprint ("Palmer: Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00500'));
	
	// Castle Leader : It's gonna take a little bit longer, Commander!  We're doing all we can!
//	dprint ("Castle Leader: It's gonna take a little bit longer, Commander!  We're doing all we can!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00600', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00600'));
	
	if b_rvb_interact == true then
		vo_e1m5_rvb1();
		
	else
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "castle_transmission_name" );
	
	//	Castle Leader : It's gonna take a little bit longer, Commander!  We're doing all we can!
	dprint ("Castle Leader: It's gonna take a little bit longer, Commander!  We're doing all we can!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00600'));
	
	end
	
	end_radio_transmission();
	
end

script static void vo_e1m5_artifact2()

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Defend the artifact, Crimson!
	dprint ("Palmer: Defend the artifact, Crimson!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00200'));
	
	sleep (10);

	// Palmer : Dalton!  Crimson needs immediate evac!
	dprint ("Palmer: Dalton!  Crimson needs immediate evac!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_moreknights_00300'));
	
	end_radio_transmission();

//	// Dalton : Still working with Castle to take down air defenses, Commander!
//	dprint ("Dalton: Still working with Castle to take down air defenses, Commander!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00600', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00600'));
//
//	// Palmer : Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!
//	dprint ("Palmer: Fireteam Castle, this is Commander Palmer!  I need an ETA on clear skies!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00700', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00700'));
//
//	// Castle Leader : It's going to take a bit longer, Commander!  We're doing all we can!
//	dprint ("Castle Leader: It's going to take a bit longer, Commander!  We're doing all we can!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00800', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_artifact_00800'));
//	
end


script static void vo_e1m5_morebads()
	// more bad guys show up
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : More bad guys, Commander!
	dprint ("Miller: More bad guys, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Castle?
	dprint ("Palmer: Castle?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "castle_transmission_name" );
	
	// Castle Leader : We got it, Commander!
	dprint ("Castle Leader: We got it, Commander!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00300'));
	
	sleep (10);
	
	// Castle Leader : Fireteam Castle to Crimson.  The skies are clear.  Your ride is on the way.
	dprint ("Castle Leader: Fireteam Castle to Crimson.  The skies are clear.  Your ride is on the way.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton?  ETA on the Pelican?
	dprint ("Palmer: Dalton?  ETA on the Pelican?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );
	
	// Dalton : Fast as they can, Commander.
	dprint ("Dalton: Fast as they can, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_morebaddies_00600'));
	
	end_radio_transmission();

end


script static void vo_e1m5_aircraftinbound()
	//warning of inbound aircraft
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, there's a LOT of Covenant aircraft inbound!
	dprint ("Miller: Commander, there's a LOT of Covenant aircraft inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Dalton!  Where the hell is that ride?!
	dprint ("Palmer: Dalton!  Where the hell is that ride?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_aircraftinbound_00200'));
	
	end_radio_transmission();
		
end


script static void vo_e1m5_pelican()
	// pelican onsite
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : She's at the LZ, Commander.
	dprint ("Dalton: She's at the LZ, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	hud_play_pip_from_tag (bink\spops\ep1_m5_4_60);
	thread (pip_e1m5_4_subtitles());

	// Palmer : About time!  Crimson!  Grab that artifact and get on the Pelican!
	dprint ("Palmer: About time!  Crimson!  Grab that artifact and get on the Pelican!");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00200_pip'));
	
	end_radio_transmission();
	
end

script static void pip_e1m5_4_subtitles()
	sleep_s (1.23);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_pelicanarrive_00200');
end


script static void vo_e1m5_takeoff()
	// as pelican takes off
	
	start_radio_transmission( "e1m5_pilot_transmission_name" );
	
	// e1m5_Pilot : Crimson and artifact are onboard, and we are Infinity bound.
	dprint ("e1m5_Pilot: Crimson and artifact are onboard, and we are Infinity bound.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Nice work, Crimson.  Come on home.
	dprint ("Palmer: Nice work, Crimson.  Come on home.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_outro_00200'));
	
	end_radio_transmission();
	
end

script static void vo_e1m5_rvb()

	// RvB_Caboose : Um, the regular radio guy isn't here right now.  Uhm... sorry.
	dprint ("RvB_Caboose: Um, the regular radio guy isn't here right now.  Uhm... sorry.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_nextarea_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_nextarea_00500'));
	
	sleep (10);
	
	// RvB_Caboose : Seriously, the regular guy said he would be right back.  He's in the bathroom.
	dprint ("RvB_Caboose: Seriously, the regular guy said he would be right back.  He's in the bathroom.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_moreknights_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\rvb_e1m5_moreknights_00600'));
	
	end_radio_transmission();

end
// =============================================================================================================================
//====== SCURVE Ep 02 Mission 02 VO scripts ==================================================
// =============================================================================================================================


script static void vo_e2m2_intro()
	// during narrative in
	
	sleep (75);
	
	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Telemetry -- online.  Spartan tags -- online.  Comms -- online.
	dprint ("Miller: Telemetry -- online.  Spartan tags -- online.  Comms -- online.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00100'));
	
	sleep (10);

	// Miller : The Op is live, Commander Palmer.  Crimson is approaching deployment zone.
	dprint ("Miller: The Op is live, Commander Palmer.  Crimson is approaching deployment zone.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00200'));

	sleep (15);

	// Palmer : Any word from the science team?
	dprint ("Palmer: Any word from the science team?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00300'));
	
	sleep (15);

	// Miller : Not since their distress call.
	dprint ("Miller: Not since their distress call.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_in_00400'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_clearhill()
	// instruct to clear hill
	
	// PIP
	start_radio_transmission( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep2_m2_1_60);
	thread (pip_e2m2_1_subtitles());
	
	// Palmer : Crimson, secure the area.  Miller, try to raise the geeks.  If they're still alive, tell them help's on the way.
	dprint ("Palmer: Crimson, secure the area.  Miller, try to raise the geeks.  If they're still alive, tell them help's on the way.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_clearhill_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_clearhill_00100_pip'));
	
	end_radio_transmission();
	// end PIP
end

script static void pip_e2m2_1_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_clearhill_00100');
end


script static void vo_e2m2_hillcleared()
	// when hill has been cleared

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Still no word from the science team, Commander.
	dprint ("Miller: Still no word from the science team, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (15);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Keep looking, Miller.
	dprint ("Palmer: Keep looking, Miller.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hillcleared_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_hitcomms()
	// instruct to take out Comms
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, I'm painting some targets for you.  Covie comm equipment.  Take it out.
	dprint ("Palmer: Crimson, I'm painting some targets for you.  Covie comm equipment.  Take it out.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hitcomms_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_hitcomms_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_commsdown()
	// when comms are taken out

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Commander, I've got a bead on the science team's last location.  Not seeing any movement, but there's UNSC gear nearby.
	dprint ("Miller: Commander, I've got a bead on the science team's last location.  Not seeing any movement, but there's UNSC gear nearby.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Get moving, Crimson.
	dprint ("Palmer: Get moving, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_seeunscgear()
	// when you see the UNSC gear
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : There's the UNSC gear.  You're getting close.
	dprint ("Palmer: There's the UNSC gear.  You're getting close.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_seeunscgear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_seeunscgear_00100'));
	
	end_radio_transmission();
	
end

//probably not going to use this line
script static void vo_e2m2_baddies()
	// bad guys show up

	start_radio_transmission( "palmer_transmission_name" );
	
	// Miller : There's an IFF tag nearby, but you�ve got enemies inbound!
	dprint ("Miller: There's an IFF tag nearby, but you�ve got enemies inbound!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_baddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_baddies_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_nobodyhere

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Nobody's here.
	dprint ("Miller: Nobody's here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100'));
	
	end_radio_transmission();
end


script static void vo_e2m2_secure
//I'm using some lines from e4_m4 to make the mission flow better


//// Miller : Commander, we should secure the--
//	dprint ("Miller: Commander, we should secure the--");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_00100'));

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Yeah, I took Tactics 101, Miller. Secure the area, Spartans.
	dprint ("Palmer: Yeah, I took Tactics 101, Miller. Secure the area, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_0050', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_0050'));
	
	end_radio_transmission();
end


script static void vo_e2m2_collectiff

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, collect that IFF tag and see what it recorded.
	dprint ("Palmer: Crimson, collect that IFF tag and see what it recorded.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_nothere()
	// they're not here

	start_radio_transmission( "miller_transmission_name" );
	
	// Miller : Nobody's here.
	dprint ("Miller: Nobody's here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00100'));
	
//	// Miller : there's a body!
//	dprint ("Miller: there's a body!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00400'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Crimson, collect that IFF tag and see what it recorded.
	dprint ("Palmer: Crimson, collect that IFF tag and see what it recorded.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_nothere_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_ifftag()
	// play the IFF tag's recording_kill
	
	start_radio_transmission( "e2m2_scientist_transmission_name" );
	
	// e2m2_Scientist : They're coming this way!  Leave the gear and run!  Run!
	dprint ("e2m2_Scientist: They're coming this way!  Leave the gear and run!  Run!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_ifftag_00100_soundstory', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_ifftag_00100_soundstory'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_overthere()
	// instruct on next destination
	
	start_radio_transmission( "dalton_transmission_name" );
	
	// Dalton : Commander Palmer, pardon the interruption.
	dprint ("Dalton: Commander Palmer, pardon the interruption.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Go ahead, Dalton.
	dprint ("Palmer: Go ahead, Dalton.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

	// Dalton : I've got some eggheads on the resupply channel calling for help.  Transferring them over to you.
	dprint ("Dalton: I've got some eggheads on the resupply channel calling for help.  Transferring them over to you.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00300'));

//	// Rivera : Hello?!
//	dprint ("Rivera: Hello?!");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00400', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00400'));
//
//	// Palmer : Doctor --?
//	dprint ("Palmer: Doctor --?");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00500', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00500'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "rivera_transmission_name" );

	// Rivera : Yes, Doctor Rivera here, Infinity Science. Thank God you've arrived!
	dprint ("Rivera: Yes, Doctor Rivera here, Infinity Science. Thank God you've arrived!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00600'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : We're not there yet, Doctor.
	dprint ("Palmer: We're not there yet, Doctor.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00700'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Miller, get Crimson a loc on the Doc Rivera's signal.
	dprint ("Palmer: Miller, get Crimson a loc on the Doc Rivera's signal.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00800', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00800'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : Already painting the waypoint for them, Commander.
	dprint ("Miller: Already painting the waypoint for them, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00900', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_overthere_00900'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_shieldsblock()
	// shields blocking path
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Crimson, have a look around.  The shield generator should be near by.
	dprint ("Palmer: Crimson, have a look around.  The shield generator should be near by.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shieldsblock_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shieldsblock_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_closer()
	// getting closer

	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Doctor Rivera?  Status?
	dprint ("Palmer: Doctor Rivera?  Status?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "rivera_transmission_name" );

	// Rivera : We're holed up.  Turned some of their own shields against them.  But I can't imagine we're safe for too long.
	dprint ("Rivera: We're holed up.  Turned some of their own shields against them.  But I can't imagine we're safe for too long.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_closer_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	//stealing this line from a previous line
	// Palmer : Get moving, Crimson.
	dprint ("Palmer: Get moving, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_commsdown_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_lava()
	// watch your step
	
	start_radio_transmission( "palmer_transmission_name" );
	
	// Palmer : Watch your step, Crimson.
	dprint ("Palmer: Watch your step, Crimson.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_lava_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_lava_00100'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_keepbarrier()
	// tell scientists to keep up barrier
	
	start_radio_transmission( "rivera_transmission_name" );
	
	// Rivera : I see Spartans!
	dprint ("Rivera: I see Spartans!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Stay put Doctor.  Let the professionals clear the area.
	dprint ("Palmer: Stay put Doctor.  Let the professionals clear the area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_keepbarrier_00200'));
	
	end_radio_transmission();
	
end


script static void vo_e2m2_allclear()
	// all clear

	// PIP
	start_radio_transmission( "miller_transmission_name" );
	// Miller : That's the last of them, Commander.
	dprint ("Miller: That's the last of them, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00100', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	// end PIP
	
	sleep (10);
	
	hud_play_pip_from_tag (bink\spops\ep2_m2_2_60);
	thread (pip_e2m2_2_subtitles());
	// palmer dialog is not part of the PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	// Palmer : Nice work, Crimson.  Doctor Rivera, you can take the shields down now.
	dprint ("Palmer: Nice work, Crimson.  Doctor Rivera, you can take the shields down now.");
	//sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00200', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00200_pip'));
	
	end_radio_transmission();
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);

	// Rivera : Umm.  Yes.  Hang on.  We were rather lucky to figure out how to turn them on in the first place.  Hrmmm.
//	dprint ("Rivera: Umm.  Yes.  Hang on.  We were rather lucky to figure out how to turn them on in the first place.  Hrmmm.");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00300', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00300'));
//	
end

script static void pip_e2m2_2_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_allclear_00200');
end


script static void vo_e2m2_allclear2()

	start_radio_transmission( "rivera_transmission_name" );

	// Rivera : Ah there we go. Hello, Spartans! Thanks so much.
	dprint ("Rivera: Ah there we go. Hello, Spartans! Thanks so much.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shield_off_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shield_off_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Well done, Crimson. Time to head home.
	dprint ("Palmer: Well done, Crimson. Time to head home.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shield_off_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_02_mission_02\e2m2_shield_off_00200'));
	
	end_radio_transmission();
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);

end

// =============================================================================================================================
//====== SCURVE Ep 04 Mission 04 VO scripts ==================================================
// =============================================================================================================================


script static void vo_e4m4_playstart()
	// Make sure blank hud works ?
	// PIP

	hud_play_pip_from_tag (bink\spops\ep4_m4_1_60);
	thread (pip_e4m4_1_subtitles());
	thread (pip_e4m4_1_radiohud());

	// Miller : Roland?  Did you follow them that time?
	dprint ("Miller: Roland?  Did you follow them that time?");
	dprint ("Roland: Yep.  A few more jumps like this and I might be able to extrapolate how the whole system works.");
	dprint ("Palmer: Extrapolate later.  Give Miller their loc now.  We've got an Op to run.");

	// Subtitles!
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00100', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00200', NONE, 1);
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00300', NONE, 1);
	
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00100_pip'));
	end_radio_transmission();
	// end PIP
end

script static void pip_e4m4_1_subtitles()
	sleep_s (1.16);
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00100');
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00200');
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00300');
end

script static void pip_e4m4_1_radiohud()
	sleep_s (1.16);
	dprint ("START RADIO HUD FUNCTION");
	start_radio_transmission( "miller_transmission_name" );
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00100'));
	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00200'));
	cui_hud_hide_radio_transmission_hud();
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_playstart_00300'));
end


script static void vo_e4m4_portalin()

//breathing room between pips
sleep_s (2);
start_radio_transmission( "palmer_transmission_name" );

// Palmer : Miller, get me a marker on 'Mdama.  I want to know what he's got with his Didact's Gift thing, and where he's got it.
dprint ("Palmer: Miller, get me a marker on 'Mdama.  I want to know what he's got with his Didact's Gift thing, and where he's got it.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (60);
cui_hud_show_radio_transmission_hud( "roland_transmission_name" );

// Roland : I've found him!  There you go.  I tell ya, I don't know why I run a starship when running Ops is so much more fun.
dprint ("Roland: I've found him!  There you go.  I tell ya, I don't know why I run a starship when running Ops is so much more fun.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Roland, clear the line, please.  Let the Spartans talk.
dprint ("Palmer: Roland, clear the line, please.  Let the Spartans talk.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_portalin_00300'));

end_radio_transmission();

end


script static void vo_e4m4_encounterdoor()   												// tjp - hacked together from different sources

start_radio_transmission( "miller_transmission_name" );

// Miller : Mdama's through there. 
dprint ("Miller: Mdama's through there.  Just a second�okay.  Found the controls for the door.  Marking them now.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_encounterdoor_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_encounterdoor_00100'));

cui_hud_hide_radio_transmission_hud();
sleep(10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Miller, find Crimson a way through those doors.
dprint ("Palmer: Miller, find Crimson a way through those doors.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_01_mission_05\e1m5_ifdoorsfirst_00100'));

cui_hud_hide_radio_transmission_hud();

sleep (10);

cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Working on it, Commander.
dprint ("Miller: Working on it, Commander.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\global_dialog\spops_global_stalling_2_00200'));
	
end_radio_transmission();

end

script static void vo_e4m4_markingcontrols()

start_radio_transmission( "miller_transmission_name" );

// Miller: Just a second�okay.  Found the controls for the door.  Marking them now.
dprint ("Miller: Just a second�okay.  Found the controls for the door.  Marking them now.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_encounterdoor_00150', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_encounterdoor_00150'));

end_radio_transmission();
end

script static void vo_e4m4_oneswitch()

start_radio_transmission( "miller_transmission_name" );

// Miller : That's one switch.  Hit the other to open the door.
dprint ("Miller: That's one switch.  Hit the other to open the door.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_oneswitch_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_oneswitch_00100'));

end_radio_transmission();

end


script static void vo_e4m4_doorisopen()

start_radio_transmission( "miller_transmission_name" );

// Miller : Door's open.
dprint ("Miller: Door's open.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_doorisopen_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_doorisopen_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Move it, Crimson!  Do not let 'Mdama get away!
dprint ("Palmer: Move it, Crimson!  Do not let 'Mdama get away!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_doorisopen_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_doorisopen_00200'));

end_radio_transmission();

end


script static void vo_e4m4_watcherturrets()

start_radio_transmission( "miller_transmission_name" );

// Miller : Watchers deploying turrets!
dprint ("Miller: Watchers deploying turrets!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_watcherturrets_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_watcherturrets_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Dammit!  Do not let them slow you down!
dprint ("Palmer: Dammit!  Do not let them slow you down!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_watcherturrets_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_watcherturrets_00200'));

end_radio_transmission();

end


script static void vo_e4m4_almostgothim()

start_radio_transmission( "miller_transmission_name" );

// Miller : We've almost got him, Commander!
dprint ("Miller: We've almost got him, Commander!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_almostgothim_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_almostgothim_00100'));

end_radio_transmission();

end


script static void vo_e4m4_tunnels()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Dalton!
dprint ("Palmer: Dalton!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (30);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : Commander?
dprint ("Dalton: Commander?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : I need some targeted air strikes, preferably that I can fire at will.
dprint ("Palmer: I need some targeted air strikes, preferably that I can fire at will.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (20);
cui_hud_show_radio_transmission_hud( "dalton_transmission_name" );

// Dalton : That can be arranged.  Suppressive Fire Drone 10-56 is all yours.
dprint ("Dalton: That can be arranged.  Suppressive Fire Drone 10-56 is all yours.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00400', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_tunnels_00400'));

end_radio_transmission();

end


script static void vo_e4m4_fromabove()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Crimson, keep up pursuit.  I'm going to encourage our hinge head to slow his pace a bit.
dprint ("Palmer: Crimson, keep up pursuit.  I'm going to encourage our hinge head to slow his pace a bit.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_fromabove_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_fromabove_00100'));

end_radio_transmission();

end


script static void vo_e4m4_explosions1()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : How the hell did he survive that?
dprint ("Palmer: How the hell did he survive that?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions1_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions1_00100'));

end_radio_transmission();

end


script static void vo_e4m4_explosions2()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Slippery son of a--
dprint ("Palmer: Slippery son of a--");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions2_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions2_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Slipspace signature!  He's opening a portal, Commander!
dprint ("Miller: Slipspace signature!  He's opening a portal, Commander!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions2_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_explosions2_00200'));

end_radio_transmission();

end


script static void vo_e4m4_escaped()

start_radio_transmission( "miller_transmission_name" );

// Miller : He got through the portal.
dprint ("Miller: He got through the portal.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00100'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : In one piece?
dprint ("Palmer: In one piece?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00200'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

// Miller : Unclear.  But he dropped something�
dprint ("Miller: Unclear.  But he dropped something�");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00300', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_escaped_00300'));

cui_hud_hide_radio_transmission_hud();
sleep (10);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

// Palmer : Crimson, have a look.
dprint ("Palmer: Crimson, have a look.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00100'));

end_radio_transmission();

end


script static void vo_e4m4_brain()

start_radio_transmission( "miller_transmission_name" );

// Miller : Is that it?  Is that the Didact's gift?
dprint ("Miller: Is that it?  Is that the Didact's gift?");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00200', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00200'));

cui_hud_hide_radio_transmission_hud();

end

script static void vo_e4m4_touchit()

start_radio_transmission( "palmer_transmission_name" );

// Palmer : Don't touch it!
dprint ("Palmer: Don't touch it!");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00300', NONE, 1);
cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_brain_00300'));

end_radio_transmission();

end


script static void vo_e4m4_lockdown()
	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Commander Palmer to Galileo Base.
	dprint ("Palmer: Commander Palmer to Galileo Base.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : Owen here.  Go ahead, Commander.
	dprint ("Doctor Owen: Owen here.  Go ahead, Commander.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00200'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );

	// Palmer : Crimson's bringing a package your way.  Prep your labs.  I want a good look at it before I let it onboard Infinity.
	dprint ("Palmer: Crimson's bringing a package your way.  Prep your labs.  I want a good look at it before I let it onboard Infinity.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00300'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "owen_transmission_name" );

	// Doctor Owen : Um�okay?
	dprint ("Doctor Owen: Um�okay?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00400'));

	cui_hud_hide_radio_transmission_hud();
	
	sleep(10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep4_m4_2_60);
	thread (pip_e4m4_2_subtitles());
	
	// Palmer : Good work, Crimson.  Hang tight.  We'll have you a ride to Galileo Base shortly.
	dprint ("Palmer: Good work, Crimson.  Hang tight.  We'll have you a ride to Galileo Base shortly.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00500', NONE, 1);
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00500_pip'));

	end_radio_transmission();
	// end PIP
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	
end

script static void pip_e4m4_2_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_lockdown_00500');
end


script static void vo_e4m4_secure()

	start_radio_transmission( "palmer_transmission_name" );

	// Palmer : Crimson, secure the area. I don't want any surprises. Miller, confirm Roland found 'Mdama.
	dprint ("Palmer: Crimson, secure the area. I don't want any surprises. Miller, confirm Roland found 'Mdama.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_opendoor_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_opendoor_00100'));
	
	// Miller : Commander, we should secure the--
//	dprint ("Miller: Commander, we should secure the--");
//	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_00100', NONE, 1);
//	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_00100'));

	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "palmer_transmission_name" );
	
	// Palmer : Yeah, I took Tactics 101, Miller. Secure the area, Spartans.
	dprint ("Palmer: Yeah, I took Tactics 101, Miller. Secure the area, Spartans.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_0050', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_04_mission_04\e4m4_julescape_0050'));
	
	end_radio_transmission();
end

// =============================================================================================================================
//==============SCURVE Ep 05 Mission 04 VO scripts ==================================================
// =============================================================================================================================


script static void vo_e5m4_intro()

	start_radio_transmission( "roland_transmission_name" );

	// Roland : Hello, Crimson!  Roland here.
	dprint ("Roland: Hello, Crimson!  Roland here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00100'));
	
	sleep (10);
	
	// Roland : How've you been? Well, enough chit chat.  There's a UNSC base under attack and they need your help.
	dprint ("Roland: How've you been? Well, enough chit chat.  There's a UNSC base under attack and they need your help.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00200'));
	
	sleep (30);
	
	// Roland : This really is your whole life, isn't it?
	dprint ("Roland: This really is your whole life, isn't it?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00300'));
	
	// Miller : Roland, get off the line.  Crimson, you're coming in hot.  Help the Marines defend the outpost.  I'll see what I can line up by way of support.
	dprint ("Miller: Roland, get off the line.  Crimson, you're coming in hot.  Help the Marines defend the outpost.  I'll see what I can line up by way of support.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_intro_00500'));
	
	end_radio_transmission();

end


script static void vo_e5m4_marines()

	//no pickup line for this -- might need to cut -- play this line when players get in the mantis
	
	start_radio_transmission( "e5m4_marine_1_transmission_name" );
	
	// e5m4_marine1 : Hell yeah!  Backup!
	dprint ("e5m4_marine1: Hell yeah!  Backup!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_marines_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_marines_00100'));
	
	end_radio_transmission();
end
	

script static void vo_e5m4_marines2()

	start_radio_transmission( "miller_transmission_name" );

	//don't play this if the mantis is spawned
	// Miller : Grab a Warthog and let's go.
	dprint ("Miller: Grab a Warthog and let's go.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_marines_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_marines_00200'));
	
	end_radio_transmission();

end


script static void vo_e5m4_nonpip_baddies()
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "e5m4_marine_1_transmission_name" );

	// e5m4_marine1 : Where'd they come from?!
	dprint ("e5m4_marine1: Where'd they come from?!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_baddies_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_baddies_00100'));
	
	end_radio_transmission();
	
	b_dialog_playing = false;
end

script static void vo_e5m4_pip_baddies()
	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m4_1_60);
	thread (pip_e5m4_1_subtitles());
		
	// Miller : Crimson, these guys aren't your main objective.  There's a forward base up the road that needs your help.
	dprint ("Miller: Crimson, these guys aren't your main objective.  There's a forward base up the road that needs your help.");
	// subtitle
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_baddies_00200', NONE, 1);
	
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_baddies_00200_pip'));

	end_radio_transmission();
	b_dialog_playing = false;
end

script static void pip_e5m4_1_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_baddies_00200');
end


script static void vo_e5m4_needhelp()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Hey, it's real nice of you to kill every Covenant that you see, but the Marines at the Forward base need your help, NOW.
	dprint ("Miller: Hey, it's real nice of you to kill every Covenant that you see, but the Marines at the Forward base need your help, NOW.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_needhelp_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_needhelp_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_overachieve()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Crimson, you're the definition of overachiever.
	dprint ("Miller: Crimson, you're the definition of overachiever.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_overachieve_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_overachieve_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_atbase()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Forward Base Magma, the Spartans are here.
	dprint ("Miller: Forward Base Magma, the Spartans are here.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atbase_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atbase_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_straighthere()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "e5m4_marine_2_transmission_name" );

	// e5m4_marine2 : Oh hell yeah!
	dprint ("e5m4_marine2: Oh hell yeah!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_straighthere_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_straighthere_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_tooklong()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "e5m4_marine_2_transmission_name" );

	// e5m4_marine2 : About damn time!
	dprint ("e5m4_marine2: About damn time!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_tooklong_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_tooklong_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_defendgens()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "e5m4_marine_2_transmission_name" );

	// e5m4_marine2 : The Covies are hell-bent on taking out our generators.  We lose those, we lose the base.
	dprint ("e5m4_marine2: The Covies are hell-bent on taking out our generators.  We lose those, we lose the base.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_defendgens_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_defendgens_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : There it is, Crimson.  Defend the generators from the Covenant attack.
	dprint ("Miller: There it is, Crimson.  Defend the generators from the Covenant attack.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_defendgens_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_defendgens_00200'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_unscturrets()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m4_2_60);
	thread (pip_e5m4_2_subtitles());
	
	// Miller : Crimson, I see some turrets our Marine friends have yet to activate.  If you power them up, your lives should be considerably easier.
	dprint ("Miller: Crimson, I see some turrets our Marine friends have yet to activate.  If you power them up, your lives should be considerably easier.");
	// sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_unscturrets_00100', NONE, 1);

	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_unscturrets_00100_pip'));
	end_radio_transmission();

	b_dialog_playing = false;
end

script static void pip_e5m4_2_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_unscturrets_00100');
end


script static void vo_e5m4_turretsonline()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );

	// Miller : Turrets are online!  Nice!
	dprint ("Miller: Turrets are online!  Nice!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_turretsonline_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_turretsonline_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_turretremind()

start_radio_transmission( "miller_transmission_name" );

// Miller : Crimson, just a friendly reminder that those turrets aren't online yet.
dprint ("Miller: Crimson, just a friendly reminder that those turrets aren't online yet.");
sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_turretremind_00100', NONE, 1);
sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_turretremind_00100'));

end_radio_transmission();

end


script static void vo_e5m4_1genfail()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Crimson!  You've lost a generator!
	dprint ("Miller: Crimson!  You've lost a generator!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_1genfail_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_1genfail_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_allgenfail()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "miller_transmission_name" );

	// Miller : Damn it!  Both generators are offline!
	dprint ("Miller: Damn it!  Both generators are offline!");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allgenfail_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allgenfail_00100'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_allclear()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;

	start_radio_transmission( "roland_transmission_name" );
	
	// Roland : Spartan Miller, emergency.
	dprint ("Roland: Spartan Miller, emergency.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : What isn't an emergency today, Roland?
	dprint ("Miller: What isn't an emergency today, Roland?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	
	// Roland : Spartan Thorne's IFF tag is within Crimson's operational area.
	dprint ("Roland: Spartan Thorne's IFF tag is within Crimson's operational area.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	
	// Miller : Thorne -- from Majestic?
	dprint ("Miller: Thorne -- from Majestic?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00400', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00400'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	
	// Roland : Yes, that Thorne.
	dprint ("Roland: Yes, that Thorne.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00500', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00500'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );

	// Miller : What is he doing there?
	dprint ("Miller: What is he doing there?");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00600', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00600'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	
	// Roland : No idea.  The rest of Majestic are still onboard Infinity.  I'm sending the waypoint to Crimson now.
	dprint ("Roland: No idea.  The rest of Majestic are still onboard Infinity.  I'm sending the waypoint to Crimson now.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00700', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_allclear_00700'));
	
	end_radio_transmission();

	b_dialog_playing = false;

end


script static void vo_e5m4_atifftag()

	sleep_until (b_dialog_playing == false, 1);
	b_dialog_playing = true;
	
	start_radio_transmission( "miller_transmission_name" );
		
	// Miller : There's no Spartan here, Roland.
	dprint ("Miller: There's no Spartan here, Roland.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00100', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00100'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	
	// Roland : No, but there are signs of a battle.  One moment.  Analyzing.
	dprint ("Roland: No, but there are signs of a battle.  One moment.  Analyzing.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00200', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00200'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (90);
	cui_hud_show_radio_transmission_hud( "roland_transmission_name" );
	
	// Roland : These tracks predate Crimson's arrival in the area.  I have a direction for movement out of this area, but it's faint.
	dprint ("Roland: These tracks predate Crimson's arrival in the area.  I have a direction for movement out of this area, but it's faint.");
	sound_impulse_start ('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00300', NONE, 1);
	sleep (sound_impulse_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00300'));
	
	cui_hud_hide_radio_transmission_hud();
	sleep (10);
	
	// PIP
	cui_hud_show_radio_transmission_hud( "miller_transmission_name" );
	hud_play_pip_from_tag (bink\spops\ep5_m4_3_60);
	thread(pip_e5m4_3_subtitles());
	
	// Miller : Crimson, follow Roland's directions.  I'll try and get Commander Palmer on the line.
	dprint ("Miller: Crimson, follow Roland's directions.  I'll try and get Commander Palmer on the line.");
	sleep (sound_max_time('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00100_pip'));
	
	end_radio_transmission();
	// end PIP
	
	sound_impulse_start ('sound\storm\multiplayer\pve\events\mp_pve_all_end_stinger', NONE, 1);
	
	b_dialog_playing = false;

end

script static void pip_e5m4_3_subtitles()
	dialog_play_subtitle('sound\dialog\storm_multiplayer\pve\ep_05_mission_04\e5m4_atifftag_00400');
end