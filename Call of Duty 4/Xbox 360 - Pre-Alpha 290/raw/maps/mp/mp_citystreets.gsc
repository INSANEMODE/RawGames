main()
{
	maps\mp\_load::main();
	maps\mp\_compass::setupMiniMap("compass_map_mp_citystreets");

	setExpFog(1500, 5000, 0.72, 0.83, 1, 0);
//	setcullfog (128, 8000, 1, .8, .4, 0);
	ambientPlay("ambient_citystreets_day");
	VisionSetNaked( "mp_citystreets" );

	game["allies"] = "marines";
	game["axis"] = "opfor";
	game["attackers"] = "axis";
	game["defenders"] = "allies";
	game["allies_soldiertype"] = "desert";
	game["axis_soldiertype"] = "desert";


	setdvar("r_glowbloomintensity0",".1");
	setdvar("r_glowbloomintensity1",".1");
	setdvar("r_glowskybleedintensity0",".1");

	maps\mp\_explosive_barrels::main();
}