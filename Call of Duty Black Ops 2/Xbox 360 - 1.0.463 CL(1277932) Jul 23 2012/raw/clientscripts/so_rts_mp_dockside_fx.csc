//
// file: so_rts_mp_dockside_fx.gsc
// description: clientside fx script for mp_dockside: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- FX'S SECTION ---//
precache_createfx_fx()
{
	level._effect["fx_war_heli_dust_concrete"]								= loadfx("vehicle/treadfx/fx_war_heli_dust_concrete");
	level._effect["fx_mp_light_dust_motes_md"]								= loadfx("maps/mp_maps/fx_mp_light_dust_motes_md");
	
	level._effect["fx_light_flour_dbl_oval_street_wrm"]				= loadfx("light/fx_light_flour_dbl_oval_street_wrm");
	level._effect["fx_light_floodlight_sqr_wrm"]							= loadfx("light/fx_light_floodlight_sqr_wrm");	
	level._effect["fx_light_floodlight_sqr_cool_xlg"]					= loadfx("light/fx_light_floodlight_sqr_cool_xlg");
	level._effect["fx_light_floodlight_rnd_cool_glw_add"]			= loadfx("light/fx_light_floodlight_rnd_cool_glw_add");	
	level._effect["fx_light_floodlight_rnd_cool_glw"]					= loadfx("light/fx_light_floodlight_rnd_cool_glw");
	level._effect["fx_light_floodlight_rnd_cool_glw_dim"]			= loadfx("light/fx_light_floodlight_rnd_cool_glw_dim");
	level._effect["fx_light_floodlight_rnd_cool_glw_lg"]			= loadfx("light/fx_light_floodlight_rnd_cool_glw_lg");	
	level._effect["fx_light_floodlight_rnd_red_md"]						= loadfx("light/fx_light_floodlight_rnd_red_md");		
	level._effect["fx_la2_light_beacon_red_blink"]						= loadfx("light/fx_light_beacon_red_blink_fst");	
	level._effect["fx_light_spotlight_sm_cool"]								= loadfx("light/fx_light_spotlight_sm_cool");
	level._effect["fx_light_spotlight_sm_yellow"]							= loadfx("light/fx_light_spotlight_sm_yellow");
	level._effect["fx_light_flourescent_glow_cool"]						= loadfx("light/fx_light_flourescent_glow_cool");	
	level._effect["fx_light_flour_glow_wrm_dbl_md"]						= loadfx("light/fx_light_flour_glow_wrm_dbl_md");		
	level._effect["fx_light_floodlight_sqr_wrm_vista_lg"]			= loadfx("light/fx_light_floodlight_sqr_wrm_vista_lg");	
	level._effect["fx_light_beacon_white_static"]							= loadfx("light/fx_light_beacon_white_static");	
	level._effect["fx_light_beacon_green_static"]							= loadfx("light/fx_light_beacon_green_static");	
	level._effect["fx_light_buoy_red_blink"]									= loadfx("light/fx_light_buoy_red_blink");
	level._effect["fx_light_flourescent_ceiling_panel"]				= loadfx("light/fx_light_flourescent_ceiling_panel");
	level._effect["fx_light_bridge_accent_vista"]							= loadfx("light/fx_light_bridge_accent_vista");	

	level._effect["fx_fog_lit_spotlight_cool_lg"]							= loadfx("fog/fx_fog_lit_spotlight_cool_lg");
	level._effect["fx_fog_lit_overhead_wrm_lg"]								= loadfx("fog/fx_fog_lit_overhead_wrm_lg");
	level._effect["fx_fog_lit_overhead_wrm_xlg"]							= loadfx("fog/fx_fog_lit_overhead_wrm_xlg");	
	level._effect["fx_fog_street_cool_slw_sm_md"]							= loadfx("fog/fx_fog_street_cool_slw_md");
	level._effect["fx_fog_street_red_slw_md"]									= loadfx("fog/fx_fog_street_red_slw_md");	

	level._effect["fx_paper_ext_narrow_slw"]									= loadfx("debris/fx_paper_ext_narrow_slw");		
	level._effect["fx_paper_interior_short_slw_flat"]					= loadfx("debris/fx_paper_interior_short_slw_flat");	
	level._effect["fx_mp_steam_pipe_md"]											= loadfx("maps/mp_maps/fx_mp_steam_pipe_md");	
	level._effect["fx_mp_steam_pipe_roof_lg"]									= loadfx("maps/mp_maps/fx_mp_steam_pipe_roof_lg");	
	level._effect["fx_mp_water_drip_light_long"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_long");
	level._effect["fx_mp_water_drip_light_shrt"]							= loadfx("maps/mp_maps/fx_mp_water_drip_light_shrt");
	
	level._effect["fx_mp_sun_flare_dockside"]									= loadfx("maps/mp_maps/fx_mp_sun_flare_dockside");
	
}


main()
{
	clientscripts\createfx\so_rts_mp_dockside_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();

	wind_initial_setting();

	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

wind_initial_setting()
{
SetSavedDvar( "enable_global_wind", 1); // enable wind for your level
SetSavedDvar( "wind_global_vector", "-120 -115 -120" );    // change "0 0 0" to your wind vector
SetSavedDvar( "wind_global_low_altitude", -175);    // change 0 to your wind's lower bound
SetSavedDvar( "wind_global_hi_altitude", 4000);    // change 10000 to your wind's upper bound
SetSavedDvar( "wind_global_low_strength_percent", .5);    // change 0.5 to your desired wind strength percentage
}

