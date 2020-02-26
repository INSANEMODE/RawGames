main()
{
	precacheFX();
	ambientFX();	
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

precacheFX()
{
	level._effect["wood"]				= loadfx("explosions/grenadeExp_wood");
	level._effect["dust"]				= loadfx("explosions/grenadeExp_dirt_1");
	level._effect["brick"]				= loadfx("explosions/grenadeExp_concrete_1");
	level._effect["coolaidmanbrick"]	= loadfx("explosions/grenadeExp_concrete_1");
	level._effect["flak_explosion"]		= loadfx("explosions/large_vehicle_explosion");
	level._effect["rain_heavy_mist"]	= loadfx ("weather/rain_heavy_mist");
}

ambientFX()
{
	// temp world rain
	//maps\mp\_fx::loopfx("rain_heavy_mist", (1182,3721,320), .6);
	//maps\mp\_fx::loopfx("rain_heavy_mist", (507,1857,320), .6);
	//maps\mp\_fx::loopfx("rain_heavy_mist", (494,482,320), .6);
	//maps\mp\_fx::loopfx("rain_heavy_mist", (-89,-683,320), .6);
}