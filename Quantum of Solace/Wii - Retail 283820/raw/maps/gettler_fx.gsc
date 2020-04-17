#include maps\_utility;

main()
{
	initFXModelAnims();

	precacheFX();
	
	
	registerFXTargetName("fx_debug");
	registerFXTargetName("fx_falling_debris");
	registerFXTargetName("fx_birds_takeoff");
	registerFXTargetName("fx_dust_level1");
	registerFXTargetName("fx_dust_level2");
	registerFXTargetName("fx_water_effects_1");
	registerFXTargetName("fx_water_effects_2");
	registerFXTargetName("fx_water_effects_3");	
	registerFXTargetName("fx_elevator_sparks");
	registerFXTargetName("fx_elevator_dust");
	registerFXTargetName("fx_water_boil");
	registerFXTargetName("fx_light");
	registerFXTargetName("fx_gondola_crash");
	registerFXTargetName("fx_bell_birds");
	registerFXTargetName("fx_planks_dust1");
	registerFXTargetName("fx_planks_dust2");
	registerFXTargetName("fx_planks_dust3");
	registerFXTargetName("fx_planks_dust4");	
	
	
	maps\createfx\gettler_fx::main();
	
	
	level thread enable_lights();
	
	
	
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_elevator_fall", "targetname" );
	ent2 = getent( "fxanim_walkway_explode", "targetname" );
	ent3 = getent( "fxanim_gondola_fall", "targetname" );
	ent4 = getent( "fxanim_jump_rope", "targetname" );
	
	ent_array1 = getentarray( "fxanim_telephone_wire_1", "targetname" );
	ent_array2 = getentarray( "fxanim_telephone_wire_2", "targetname" );
	
	if (IsDefined(ent1)) { ent1 thread elevator_fall();   println("************* FX: elevator_fall *************"); }
	if (IsDefined(ent2)) { ent2 thread walkway_explode();   println("************* FX: walkway_explode *************"); }
	if (IsDefined(ent3)) { ent3 thread gondola_fall();   println("************* FX: gondola_fall *************"); }
	if (IsDefined(ent4)) { ent4 thread jump_rope();   println("************* FX: jump_rope *************"); }
	if (IsDefined(ent_array1)) { ent_array1 thread telephone_wire_1();   println("************* FX: telephone_wire_1 *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread telephone_wire_2();   println("************* FX: telephone_wire_2 *************"); }
}

#using_animtree("fxanim_elevator_fall");
elevator_fall()
{
	level waittill("elevator_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_elevator_fall", self.origin, self.angles, %fxanim_elevator_fall);
	level notify("fx_elevator_dust"); 
}

#using_animtree("fxanim_walkway_explode");
walkway_explode()
{
	level waittill("walkway_explode_start");
	self UseAnimTree(#animtree);
	self animscripted("a_walkway_explode", self.origin, self.angles, %fxanim_walkway_explode);
}

#using_animtree("fxanim_gondola_fall");
gondola_fall()
{
	level waittill("gondola_fall_start");
	
	
	aim_gondola = GetEnt("clipgondola_fall", "targetname");
	aim_gondola delete();

	self UseAnimTree(#animtree);
	self animscripted("a_gondola_fall", self.origin, self.angles, %fxanim_gondola_fall);
		
	
	if (animhasnotetrack(%fxanim_gondola_fall, "gondola_fall"))
	{
		
		self waittillmatch("a_gondola_fall", "gondola_fall");
		level notify("fx_gondola_crash");		
	}
}

#using_animtree("fxanim_jump_rope");
jump_rope()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_jump_rope", self.origin, self.angles, %fxanim_jump_rope);
}

#using_animtree("fxanim_telephone_wire_1");
telephone_wire_1()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_telephone_wire_1", self[i].origin, self[i].angles, %fxanim_telephone_wire_1);
	}
}

#using_animtree("fxanim_telephone_wire_2");
telephone_wire_2()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_telephone_wire_2", self[i].origin, self[i].angles, %fxanim_telephone_wire_2);
	}
}

enable_lights()
{
	wait(0.1);
	level notify("fx_light");
}

precacheFX()
{
	
	
	

	level._effect["motor_boat"]					= loadfx ("maps/venice/gettler_boat_wake");
	level._effect["venice_fountain01"] 			= loadfx ("maps/venice/venice_fountain01");

	
	
	
	
	
	
	level._effect["venice_water_disturb06"] 	= loadfx ("maps/venice/venice_water_disturb06");

	level._effect["venice_cloud_whisp01"] 		= loadfx ("maps/venice/venice_cloud_whisp01");
	level._effect["venice_cloud_whisp02"] 		= loadfx ("maps/venice/venice_cloud_whisp02");
	level._effect["venice_cloud_whisp03"] 		= loadfx ("maps/venice/venice_cloud_whisp03");
	level._effect["gettler_gondola_crash"]		= loadfx ("maps/venice/gettler_gondola_crash");
	level._effect["venice_plank_dust1"] 		= loadfx ("maps/venice/venice_plank_dust1");
	
	

	level._effect["gettler_acetylene_exp"] 			= loadfx ("maps/venice/gettler_acetylene_exp");
	
	level._effect["gettler_dusty_air01"] 			= loadfx ("maps/venice/gettler_dusty_air01");
	level._effect["gettler_dusty_air02"] 			= loadfx ("maps/venice/gettler_dusty_air02");
	level._effect["gettler_dusty_air03"] 			= loadfx ("maps/venice/gettler_dusty_air03");
	level._effect["gettler_dusty_air04"] 			= loadfx ("maps/venice/gettler_dusty_air04");
	level._effect["gettler_dust_impact"] 		= loadfx ("maps/venice/gettler_dust_impact");
	level._effect["gettler_elevator_dust"] 		= loadfx ("maps/venice/gettler_elevator_dust");
	
	level._effect["gettler_exp_airbag01"] 			= loadfx ("maps/venice/gettler_exp_airbag01");
	level._effect["gettler_exp_airbag02"] 			= loadfx ("maps/venice/gettler_exp_airbag02");
	
	level._effect["gettler_falling_debris01"] 		= loadfx ("maps/venice/gettler_falling_debris01");
	level._effect["gettler_falling_debris02"] 		= loadfx ("maps/venice/gettler_falling_debris02");
	level._effect["gettler_falling_debris03"] 		= loadfx ("maps/venice/gettler_falling_debris03");
	level._effect["gettler_falling_debris04"] 		= loadfx ("maps/venice/gettler_falling_debris04");
	level._effect["gettler_falling_debris05"] 		= loadfx ("maps/venice/gettler_falling_debris05");
	level._effect["gettler_falling_debris06"] 		= loadfx ("maps/venice/gettler_falling_debris06");
	level._effect["gettler_falling_debris07"] 		= loadfx ("maps/venice/gettler_falling_debris07");
	level._effect["gettler_falling_debris08"] 		= loadfx ("maps/venice/gettler_falling_debris08");
	
	level._effect["gettler_lightbeam01"] 			= loadfx ("maps/venice/gettler_lightbeam01");
	level._effect["gettler_lightbeam02"] 			= loadfx ("maps/venice/gettler_lightbeam02");
	
	level._effect["gettler_submerge_gurgle01"] 		= loadfx ("maps/venice/gettler_submerge_gurgle01");
	level._effect["gettler_submerge_gurgle02"] 		= loadfx ("maps/venice/gettler_submerge_gurgle02");
	level._effect["gettler_submerge_gurgle03"] 		= loadfx ("maps/venice/gettler_submerge_gurgle03");
	level._effect["gettler_submerge_gurgle04"] 		= loadfx ("maps/venice/gettler_submerge_gurgle04");
	
	level._effect["gettler_work_light_vol"] 		= loadfx ("maps/venice/gettler_work_light_vol");
	level._effect["gettler_work_light_vol2"] 		= loadfx ("maps/venice/gettler_work_light_vol2");
	level._effect["gettler_work_light_vol4"] 		= loadfx ("maps/venice/gettler_work_light_vol4");
	level._effect["gettler_fountain01"] 			= loadfx ("maps/venice/gettler_fountain01");
	level._effect["gettler_fountain02"] 			= loadfx ("maps/venice/gettler_fountain02");		
	
	
	level._effect["gettler_boat_right_turn"] 	= loadfx ("maps/venice/gettler_boat_right_turn");	
	level._effect["gettler_skylight1"] 			= loadfx ("maps/venice/gettler_skylight1");
	level._effect["gettler_skylight2"] 			= loadfx ("maps/venice/gettler_skylight2");
	level._effect["gettler_elevator_sparks1"] 	= loadfx ("maps/venice/gettler_elevator_sparks1");
	level._effect["gettler_elevator_sparks2"] 	= loadfx ("maps/venice/gettler_elevator_sparks2");
	level._effect["gettler_airbag_burst1"] 		= loadfx ("maps/venice/gettler_airbag_burst1");
	level._effect["gettler_airbag_burst2"] 		= loadfx ("maps/venice/gettler_airbag_burst2");
	level._effect["gettler_airbag_venting1"] 	= loadfx ("maps/venice/gettler_airbag_venting1");	

	level._effect["gettler_water_gush1"] 		= loadfx ("maps/venice/gettler_water_gush1");
	level._effect["gettler_water_gush2"] 		= loadfx ("maps/venice/gettler_water_gush2");
	level._effect["gettler_water_gush3"] 		= loadfx ("maps/venice/gettler_water_gush3");
	level._effect["gettler_water_surface1"] 	= loadfx ("maps/venice/gettler_water_surface1");
	level._effect["gettler_water_boil1"] 		= loadfx ("maps/venice/gettler_water_boil1");
	level._effect["gettler_water_boil2"] 		= loadfx ("maps/venice/gettler_water_boil2");
	level._effect["gettler_water_boiling"] 		= loadfx ("maps/venice/gettler_water_boiling");	

	level._effect["gettler_skylight_shatter"] 	= loadfx ("breakables/gettler_skylight_shatter");
	
	level._effect["gettler_drywall_puff"] 		= loadfx ("maps/venice/gettler_drywall_puff");
	level._effect["footfall_debris"]			= loadfx ("maps/venice/gettler_balancebeam_debris");

	level._effect["watersplash_large"]			= loadfx ("misc/watersplash_large");
}
