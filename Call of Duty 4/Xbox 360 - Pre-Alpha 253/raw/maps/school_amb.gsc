#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["exterior"] = "ambient_school_ext5";

	//level.ambient_reverb["exterior"] = [];
	//level.ambient_reverb["exterior"]["priority"] = "snd_enveffectsprio_level";
	//level.ambient_reverb["exterior"]["roomtype"] = "alley";
	//level.ambient_reverb["exterior"]["drylevel"] = .9;
	//level.ambient_reverb["exterior"]["wetlevel"] = .1;
	//level.ambient_reverb["exterior"]["fadetime"] = 2;
		
	thread maps\_utility::set_ambient("exterior");

	ambientDelay("exterior", 2.0, 8.0); // Trackname, min and max delay between ambient events
	ambientEvent("exterior", "elm_wind_leafy",	12.0);
	ambientEvent("exterior", "elm_insect_fly", 6.0);
	ambientEvent("exterior", "elm_explosions_dist",	3.0);
	ambientEvent("exterior", "elm_explosions_med",	3.0);
	ambientEvent("exterior", "elm_artillery_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_50cal_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_50cal_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_ak47_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_ak47_med",	3.0);
	ambientEvent("exterior", "elm_gunfire_m16_dist",	3.0);
	ambientEvent("exterior", "elm_gunfire_m16_med",	3.0);
	ambientEvent("exterior", "elm_jet_flyover_med",	2.0);
	ambientEvent("exterior", "elm_jet_flyover_dist",	2.0);

	ambientEvent("exterior", "null",			0.3);
	
	ambientEventStart("exterior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	