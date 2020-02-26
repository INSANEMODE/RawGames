#include common_scripts\utility;
#include maps\_utility;

main()
{
	maps\_attack_heli::attack_heli_fx();
	level._effect[ "breach_price" ]										= LoadFX( "explosions/gulag_price_breach" );
	level._effect[ "water_stop" ]						 				= loadfx( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]					 				= loadfx( "misc/parabolic_water_movement" );

	//Underground Exploders
	level._effect[ "sparks_e_sound" ] 									= loadfx( "explosions/sparks_e_sound" );
	level._effect[ "welding_small_extended" ] 							= loadfx( "misc/welding_small_extended" );
	level._effect[ "grenade_wood" ] 									= loadfx( "explosions/grenadeExp_wood" );
	
	
	
	level._effect[ "hallway_collapsing" ]								= loadfx( "misc/hallway_collapsing" );
	level._effect[ "hallway_collapsing_big" ] 							= loadfx( "misc/hallway_collapsing_big" );
	level._effect[ "hallway_collapsing_huge" ] 							= loadfx( "misc/hallway_collapsing_huge" );
	level._effect[ "hallway_collapsing_chase" ] 						= loadfx( "misc/hallway_collapsing_chase" );
	level._effect[ "hallway_collapsing_cavein" ] 						= loadfx( "misc/hallway_collapsing_cavein" );
	level._effect[ "hallway_collapsing_cavein_short" ]					= loadfx( "misc/hallway_collapsing_cavein_short" );
	
	level._effect[ "hallway_collapsing_burst" ] 						= loadfx( "misc/hallway_collapsing_burst" );
	level._effect[ "hallway_collapsing_burst_no_linger" ] 				= loadfx( "misc/hallway_collapsing_burst_no_linger" );
	level._effect[ "hallway_collapsing_major" ] 						= loadfx( "misc/hallway_collapsing_major" );
	level._effect[ "hallway_collapsing_major_norocks" ] 				= loadfx( "misc/hallway_collapsing_major_norocks" );
	
	level._effect[ "hallway_collapse_smoke_runner" ] 					= loadfx( "smoke/hallway_collapse_smoke_runner" );
	level._effect[ "hallway_collapse_smoke_runner_short" ] 				= loadfx( "smoke/hallway_collapse_smoke_runner_short" );
	level._effect[ "hallway_cavein_smoke_runner_no_linger" ]			= loadfx( "smoke/hallway_cavein_smoke_runner_no_linger" );
	level._effect[ "hallway_collapse_smoke_swirl_runner" ] 				= loadfx( "smoke/hallway_collapse_smoke_swirl_runner" );
	level._effect[ "hallway_collapse_ceiling_smoke" ] 					= loadfx( "smoke/hallway_collapse_ceiling_smoke" );
	
	level._effect[ "hallway_cavein_smoke_runner" ] 						= loadfx( "smoke/hallway_cavein_smoke_runner" );

	//Player Footstep fx
	level._effect[ "footstep_snow_small" ]								= loadfx( "impacts/footstep_snow_small" );
	level._effect[ "footstep_snow" ]									= loadfx( "impacts/footstep_snow" );

//	
	
	level._effect[ "ceiling_collapse_dirt1" ] 							= loadfx( "dust/ceiling_collapse_dirt1" );
	level._effect[ "ceiling_collapse_dirt1_decal" ] 					= loadfx( "dust/ceiling_collapse_dirt1_decal" );
	level._effect[ "ceiling_rock_break" ] 								= loadfx( "misc/ceiling_rock_break" );
	level._effect[ "ceiling_rock_break_decal" ] 						= loadfx( "misc/ceiling_rock_break_decal" );
	level._effect[ "ceiling_rock_break_grow" ] 							= loadfx( "misc/ceiling_rock_break_grow" );
	level._effect[ "rock_falling_large" ] 								= loadfx( "misc/rock_falling_large" );
	level._effect[ "glass_falling" ] 									= loadfx( "misc/glass_falling" );
	
	//Center Lightshaft
	level._effect[ "falling_debris_ring" ] 								= loadfx( "misc/falling_debris_ring" );
	level._effect[ "trash_paper_dropping" ] 							= loadfx( "misc/trash_paper_dropping" );

	//Waterfall
	level._effect[ "waterfall_drainage" ] 								= loadfx( "water/waterfall_drainage" );
	level._effect[ "waterfall_drainage_short" ] 						= loadfx( "water/waterfall_drainage_short" );
	level._effect[ "waterfall_drainage_distortion" ] 					= loadfx( "water/waterfall_drainage_distortion" );
	level._effect[ "waterfall_drainage_splash" ] 						= loadfx( "water/waterfall_drainage_splash" );
	level._effect[ "waterfall_drainage_splash_falling" ] 				= loadfx( "water/waterfall_drainage_splash_falling" );

	level._effect[ "gulag_cafe_spotlight" ] 							= loadfx( "misc/gulag_cafe_spotlight" );


	level._effect[ "firelp_large_pm" ] 									= loadfx( "fire/firelp_large_pm" );
	level._effect[ "firelp_med_pm" ] 									= loadfx( "fire/firelp_med_pm" );
	level._effect[ "flare_start_gulag" ]	 							= loadfx( "misc/flare_start_gulag" );
	level._effect[ "flare_gulag" ]	 									= loadfx( "misc/flare_gulag" );
	
	level._effect[ "water_slide" ]	 									= loadfx( "water/water_slide" );
	level._effect[ "water_slide_splash" ]	 							= loadfx( "water/water_slide_splash" );
	level._effect[ "water_slide_start" ]	 							= loadfx( "water/water_slide_start" );

	//Final Room
	level._effect[ "falling_water_trickle" ]	 						= loadfx( "water/falling_water_trickle" );
	level._effect[ "wall_explosion_2" ]	 								= loadfx( "explosions/wall_explosion_2" );
	level._effect[ "wall_explosion_2_short" ]	 						= loadfx( "explosions/wall_explosion_2_short" );
	level._effect[ "wall_explosion_2_short_nosmoke" ]	 				= loadfx( "explosions/wall_explosion_2_short_nosmoke" );
	level._effect[ "building_explosion_mega_gulag" ]	 				= loadfx( "explosions/building_explosion_mega_gulag" );
	level._effect[ "fireball_gulag" ]	 								= loadfx( "explosions/fireball_gulag" );
	level._effect[ "player_cavein" ]	 								= loadfx( "smoke/player_cavein" );
	level._effect[ "debri_explosion" ]	 								= loadfx( "explosions/debri_explosion" );
	level._effect[ "falling_debrigulag_evac" ]	 						= loadfx( "misc/falling_debris_gulag_evac" );
	
	//Scripted Lights & Stuff
	level._effect[ "dlight_blue" ] 										= loadfx( "misc/dlight_blue" );
	level._effect[ "dlight_blue_flicker" ] 								= loadfx( "misc/dlight_blue_flicker" );
	level._effect[ "dlight_red" ] 										= loadfx( "misc/dlight_red" );
	level._effect[ "flesh_hit" ] 										= loadfx( "impacts/flesh_hit_body_fatal_exit" );

	//Intro Fx
	
	level._effect[ "minigun_shell_eject" ] 								= loadfx( "shellejects/20mm_mp" );
	level._effect[ "f15_missile" ] 										= loadfx( "smoke/smoke_geotrail_sidewinder" );
	
	
	
	level._effect[ "missile_brackets" ] 								= loadfx( "misc/missile_brackets" );
	level._effect[ "javelin_ignition" ] 								= loadfx( "misc/javelin_ignition_gulag" );
	level._effect[ "jet_afterburner_ignite" ] 							= loadfx( "fire/jet_afterburner_ignite" );
	level._effect[ "javelin_trail" ] 									= loadfx( "smoke/smoke_geotrail_javelin_gulag_flyin" );
	level._effect[ "tracer_incoming" ] 									= loadfx( "misc/tracer_incoming" );
	level._effect[ "smoke_swirl_runner_dual" ] 							= loadfx( "smoke/smoke_swirl_runner_dual" );
	
	level._effect[ "missile_explosion" ]								= loadfx( "explosions/vehicle_explosion_bmp" );
	level._effect[ "f15_smoke" ]										= loadfx( "smoke/smoke_trail_black_jet" );

	level._effect[ "building_explosion_gulag" ]							= loadfx( "explosions/building_explosion_gulag" );
	level._effect[ "building_explosion_gulag_blowback" ]				= loadfx( "explosions/building_explosion_gulag_blowback" );
	level._effect[ "building_explosion_huge_gulag" ]					= loadfx( "explosions/building_explosion_huge_gulag" );
	level._effect[ "building_explosion_metal_gulag" ]					= loadfx( "explosions/building_explosion_metal_gulag" );
	level._effect[ "bhd_dirt" ]											= loadfx( "impacts/bhd_dirt" );
	level._effect[ "smoke_pushed" ]										= loadfx( "smoke/smoke_pushed" );
 
	level._effect[ "jet_crash" ]										= loadfx( "explosions/jet_crash" );
	level._effect[ "jet_crash_bounce" ]									= loadfx( "explosions/jet_crash_bounce" );
	level._effect[ "jet_crash_smoke_blow_1" ]							= loadfx( "explosions/jet_crash_smoke_blow_1" );
	level._effect[ "jet_crash_smoke_blow_2" ]							= loadfx( "explosions/jet_crash_smoke_blow_2" );
	level._effect[ "jet_crash_smoke_fill" ]								= loadfx( "explosions/jet_crash_smoke_fill" );
	level._effect[ "thin_black_smoke_L" ]								= loadfx( "smoke/thin_black_smoke_L" );
	level._effect[ "thick_black_smoke_L" ]								= loadfx( "smoke/thick_black_smoke_L" );

	level._effect[ "missile_trail" ]									= loadfx( "smoke/gulag_missile_trail" );
	add_earthquake( "boat_artillery", 0.35, 0.75, 4500 );
	add_earthquake( "ceiling_collapse" , 0.4, 4, 4500 );                                        		
                                                       		
                                                       		
	//Ambient FX	

	level._effect[ "powerline_runner_10sec_line" ]						= loadfx( "explosions/powerline_runner_10sec_line" );
	level._effect[ "amb_ash" ]											= loadfx( "smoke/amb_ash" );
	level._effect[ "amb_smoke_blend" ]									= loadfx( "smoke/amb_smoke_blend" );
	level._effect[ "battlefield_smokebank_bog_a" ]						= loadfx( "smoke/battlefield_smokebank_bog_a" );
	level._effect[ "amb_smoke_add" ]									= loadfx( "smoke/amb_smoke_add" );
	level._effect[ "battlefield_smokebank_S" ]							= loadfx( "smoke/battlefield_smokebank_S" );
	level._effect[ "insect_trail_runner" ]								= loadfx( "misc/insect_trail_runner" );
	level._effect[ "moth_runner" ]										= loadfx( "misc/moth_runner" );
	level._effect[ "dust_wind_slow_broadcast" ]							= loadfx( "dust/dust_wind_slow_broadcast" );
	level._effect[ "fog_bog_a" ]										= loadfx( "weather/fog_bog_a" );
	level._effect[ "dust_ceiling_ash_small" ]			 				= loadfx( "dust/dust_ceiling_ash_small" );
	level._effect[ "hallway_smoke_light" ]								= loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "hawk" ]												= loadfx( "weather/hawk" );
	level._effect[ "dust_wind_slow_loop_gulag" ]						= loadfx( "dust/dust_wind_slow_loop_gulag" );
	level._effect[ "firelp_med_pm" ]									= loadfx( "fire/firelp_med_pm" );
	level._effect[ "firelp_small_pm" ]									= loadfx( "fire/firelp_small_pm" );
	level._effect[ "drips_slow" ]										= loadfx( "misc/drips_slow" );
	level._effect[ "drips_slow_infrequent" ]							= loadfx( "misc/drips_slow_infrequent" );
	level._effect[ "fire_falling_runner_point" ]						= loadfx( "fire/fire_falling_runner_point" );

	// Cloud FX
	level._effect[ "cloud_bank_far_gulag" ]								= loadfx( "weather/cloud_bank_far_gulag" );
	level._effect[ "cloud_bank_gulag" ]									= loadfx( "weather/cloud_bank_gulag" );
	level._effect[ "cloud_bank_gulag_z_feather" ]						= loadfx( "weather/cloud_bank_gulag_z_feather" );
	level._effect[ "cloud_bank_thick_gulag" ]							= loadfx( "weather/cloud_bank_thick_gulag" );
	level._effect[ "cloud_bank_opaque_1_gulag" ]						= loadfx( "weather/cloud_bank_opaque_1_gulag" );
	level._effect[ "cloud_bank_opaque_2_gulag" ]						= loadfx( "weather/cloud_bank_opaque_2_gulag" );
	level._effect[ "cloud_bank_opaque_oriented_gulag" ]					= loadfx( "weather/cloud_bank_opaque_oriented_gulag" );
	level._effect[ "cloud_bank_cloud_filler_gulag" ]					= loadfx( "weather/cloud_bank_cloud_filler_gulag" );
	level._effect[ "cloud_bank_cloud_filler_tight_gulag" ]				= loadfx( "weather/cloud_bank_cloud_filler_tight_gulag" );
	level._effect[ "cloud_bank_cloud_filler_tight_hazy_gulag" ]			= loadfx( "weather/cloud_bank_cloud_filler_tight_hazy_gulag" );
	level._effect[ "cloud_bank_cloud_filler_light_gulag" ]				= loadfx( "weather/cloud_bank_cloud_filler_light_gulag" );
	level._effect[ "gulag_clouds" ]										= loadfx( "weather/gulag_clouds" );

		
	if ( !isdefined( level.script ) )
		level.script = tolower( getdvar( "mapname" ) );
	
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\gulag_fx::main();
	
	thread treadfx_override();
	
	/*
	// a way to move a bunch of fx!
	
	// the old location minus the new location
	vec = ( 115877, 30087.7, -1328 ) - ( 94224, 24518.2, -1328 );
	
	foreach ( fx in level.createFxEnt )
	{
		if ( fx.v[ "origin" ][ 0 ] > 50063 )
		{
			fx.v[ "origin" ] += vec;
		}
	}
	*/
}

f15_smoke()
{
	self endon( "death" );
	smoke = getfx( "f15_smoke" );

	for ( ;; )
	{
		playFxOnTag( smoke, self, "tag_engine_left" );
		StopFXOnTag( smoke, self, "tag_engine_right" );
		wait( 0.01 );
	}
}

treadfx_override()
{
	
	flying_tread_fx = "treadfx/heli_snow_default";
	
	maps\_treadfx::setvehiclefx( "littlebird", "brick", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "bark", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "carpet", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "cloth", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "concrete", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "dirt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "flesh", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "foliage", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "glass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "grass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "gravel", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "ice", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "metal", undefined );
 	maps\_treadfx::setvehiclefx( "littlebird", "mud", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "paper", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "plaster", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "rock", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "sand", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "snow", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "slush", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "water", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "wood", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "asphalt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "ceramic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "plastic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "rubber", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "cushion", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "fruit", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "painted metal", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird", "default", flying_tread_fx );
	maps\_treadfx::setvehiclefx( "littlebird", "none", flying_tread_fx );

	maps\_treadfx::setvehiclefx( "littlebird_player", "brick", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "bark", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "carpet", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "cloth", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "concrete", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "dirt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "flesh", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "foliage", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "glass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "grass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "gravel", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "ice", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "metal", undefined );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "mud", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "paper", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "plaster", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "rock", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "sand", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "snow", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "slush", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "water", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "wood", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "asphalt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "ceramic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "plastic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "rubber", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "cushion", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "fruit", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "painted metal", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "littlebird_player", "default", flying_tread_fx );
	maps\_treadfx::setvehiclefx( "littlebird_player", "none", flying_tread_fx );

	maps\_treadfx::setvehiclefx( "pavelow", "brick", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "bark", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "carpet", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "cloth", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "concrete", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "dirt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "flesh", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "foliage", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "glass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "grass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "gravel", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "ice", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "metal", undefined );
 	maps\_treadfx::setvehiclefx( "pavelow", "mud", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "paper", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "plaster", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "rock", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "sand", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "snow", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "slush", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "water", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "wood", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "asphalt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "ceramic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "plastic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "rubber", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "cushion", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "fruit", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "painted metal", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "pavelow", "default", flying_tread_fx );
	maps\_treadfx::setvehiclefx( "pavelow", "none", flying_tread_fx );

	maps\_treadfx::setvehiclefx( "f15", "brick", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "bark", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "carpet", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "cloth", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "concrete", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "dirt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "flesh", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "foliage", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "glass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "grass", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "gravel", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "ice", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "metal", undefined );
 	maps\_treadfx::setvehiclefx( "f15", "mud", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "paper", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "plaster", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "rock", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "sand", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "snow", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "slush", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "water", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "wood", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "asphalt", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "ceramic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "plastic", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "rubber", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "cushion", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "fruit", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "painted metal", flying_tread_fx );
 	maps\_treadfx::setvehiclefx( "f15", "default", flying_tread_fx );
	maps\_treadfx::setvehiclefx( "f15", "none", flying_tread_fx );

}
