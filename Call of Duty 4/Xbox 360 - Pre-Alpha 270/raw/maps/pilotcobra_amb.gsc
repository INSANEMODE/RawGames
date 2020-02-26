#include maps\_ambient;

main()
{
	// Set the underlying ambient track
	level.ambient_track ["interior"] = "ambient_pilotcobra_int1";
	thread maps\_utility::set_ambient("interior");
		
	ambientDelay("interior", 5.0, 20.0); // Trackname, min and max delay between ambient events
	ambientEvent("interior", "elm_ac130_rattles",		4.0);
	ambientEvent("interior", "elm_ac130_beeps",		0.5);
	ambientEvent("interior", "elm_ac130_hydraulics",	1.0);
	ambientEvent("interior", "null",			1.0);	

	
	ambientEventStart("interior");

	level waittill ("action moment");

	ambientEventStart("action ambient");
}	
	
	