#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_specialops;
#include maps\_hud_util;
#include maps\_vehicle;
#include maps\so_rooftop_contingency_code;

	// Fend off three waves of enemy reinforcements.
CONST_regular_obj	 = &"SO_ROOFTOP_CONTINGENCY_OBJ_REGULAR";
	// Fend off four waves of enemy reinforcements.
CONST_hardened_obj	 = &"SO_ROOFTOP_CONTINGENCY_OBJ_HARDENED";
	// Fend off five waves of enemy reinforcements.
CONST_veteran_obj	 = &"SO_ROOFTOP_CONTINGENCY_OBJ_VETERAN";

main()
{
	level.so_compass_zoom = "far";
	
	// Optimization
	SetSavedDvar( "sm_sunShadowScale", 0.5 );
	SetSavedDvar( "r_lightGridEnableTweaks", 1 );
	SetSavedDvar( "r_lightGridIntensity", 1.5 );
	SetSavedDvar( "r_lightGridContrast", 0 );

	// LevelVars from contigency.gsc
	//level.ai_dont_glow_in_thermal = true;
	level.min_btr_fighting_range = 400;
	level.explosion_dist_sense = 1500;
	level.default_goalradius = 7200;
	level.goodFriendlyDistanceFromPlayerSquared = 250 * 250;

	level.cosine[ "60" ] = Cos( 60 );
	level.cosine[ "70" ] = Cos( 70 );

	// UAV Settings
	// min time for UAV reload
	level.min_time_between_uav_launches = 20 * 1000;
	level.visionThermalDefault = "contingency_thermal_inverted";
	level.VISION_UAV = "contingency_thermal_inverted";

	// Thermal FX Overrides
	SetThermalBodyMaterial( "thermalbody_snowlevel" );
	level.friendly_thermal_Reflector_Effect = LoadFX( "misc/thermal_tapereflect" );

	PreCacheItem( "remote_missile_not_player" );
	PreCacheModel( "com_computer_keyboard_obj" );
	PrecacheNightvisionCodeAssets();

	flag_init( "challenge_success" );
	flag_init( "wave_wiped_out" );

	flag_init( "waves_start" );
	flag_init( "wave_1_started" );
	flag_init( "wave_2_started" );
	flag_init( "wave_3_started" );
	flag_init( "wave_4_started" );
	flag_init( "wave_5_started" );

	flag_init( "uav_in_use" );
	flag_init( "wave_spawned" );

	// Press^3 [{+actionslot 4}] ^7to control the Predator Drone.
	add_hint_string( "use_uav", &"HELLFIRE_USE_DRONE" );

	// delete certain non special ops entities
	so_delete_all_by_type( ::type_vehicle_special, ::type_spawners, ::type_spawn_trigger );

	default_start( ::start_so_rooftop );
	add_start( "start_so_rooftop", ::start_so_rooftop );

	// init stuff
	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover_snow" );
	maps\_uaz::main( "vehicle_uaz_winter_destructible", "uaz_physics" );
	maps\_uaz::main( "vehicle_uaz_winter_destructible" );
	maps\_ucav::main( "vehicle_ucav" );
	maps\contingency_precache::main();
	maps\createart\contingency_fog::main();
	maps\contingency_fx::main();
	maps\contingency_anim::main_anim();

	maps\_load::main();

	maps\_load::set_player_viewhand_model( "viewhands_player_arctic_wind" );
	thread maps\contingency_amb::main();
	maps\createart\contingency_art::main();

	// finite amount of UAV
//	level.remote_detonator_weapon = "remote_missile_detonator_finite";
	level.remote_detonator_weapon = "remote_missile_detonator";
	PreCacheItem( level.remote_detonator_weapon );
	maps\_remotemissile::init();
	maps\_remotemissile::init_radio_dialogue();

	maps\_compass::setupMiniMap( "compass_map_contingency" );
}

type_vehicle_special()
{
	// keep all collmaps
	if ( IsDefined( self.code_classname ) && self.code_classname == "script_vehicle_collmap" )
	{
		return false;
	}

	special_case 	 = !( self transform_vehicle_by_targetname( "base_troop_transport2", "truck_1", "truck_1_guys" ) );
	special_case2	 = !( self transform_vehicle_by_targetname( "base_troop_transport1", "truck_2", "truck_2_guys" ) );
	special_case3 	 = !( self transform_vehicle_by_targetname( "base_truck1", "jeep_1", "jeep_1_guys" ) );
	special_case4 	 = !( self transform_vehicle_by_targetname( "second_uav", "second_uav", "uav_path" ) );

	original_case = self type_vehicle();

	test = 0;
	if ( original_case )
	{
		test = 0;
	}

	special_result = special_case && special_case2 && special_case3 && special_case4;
	result =  special_result && original_case;

	/#
	if ( !special_result )
	{
		thread so_debug_print( "vehicle[" + self.targetname + "] saved", 5 );
	}
	#/

	return result;
}

transform_vehicle_by_targetname( vehicle_name, targetname_string, target_string )
{
	result = IsDefined( self.targetname ) && self.targetname == vehicle_name;

	if ( result )
	{
		self.targetname = targetname_string;
		self.target = target_string;
	}

	return result;
}

init_wave( wave_num, count )
{
	if ( !IsDefined( level.wave_spawn_structs ) )
	{
		level.wave_spawn_structs = [];
	}

	temp = SpawnStruct();
	temp.hostile_count = count;
	temp.vehicles = [];

	level.wave_spawn_structs[ wave_num ] = temp;
}

add_wave_vehicle( wave_num, targetname, type, alt_node, delay )
{
	if ( !IsDefined( level.wave_spawn_structs ) )
	{
		level.wave_spawn_structs = [];
	}

	if ( !IsDefined( level.wave_spawn_structs[ wave_num ].vehicles ) )
	{
		level.wave_spawn_structs[ wave_num ].vehicles = [];
	}

	temp = SpawnStruct();
	temp.targetname = targetname;
	temp.ent = GetEnt( targetname, "targetname" );
	temp.type = type;

	temp.delay = undefined;
	if ( IsDefined( delay ) )
	{
		temp.delay = delay;
	}

	temp.alt_node = undefined;
	if ( IsDefined( alt_node ) )
	{
		temp.alt_node = alt_node;
	}

	size = level.wave_spawn_structs[ wave_num ].vehicles.size;
	level.wave_spawn_structs[ wave_num ].vehicles[ size ] = temp;
}

so_setup_regular()
{
	// Wave 1
	init_wave( 1, 15 );

	// Wave 2
	init_wave( 2, 17 );
	add_wave_vehicle( 2, "jeep_1", "uaz" );

	// Wave 3
	init_wave( 3, 19 );
	add_wave_vehicle( 3, "truck_1", "bm21" );


	level.challenge_objective 	 = CONST_regular_obj;
	level.new_hostile_accuracy	 = 1;
//	level.hostile_wave_size		= 17;
//	level.hostile_waves			= 3;
	level.wiped_out_requirement	 = 2;
	level.wave_delay 			 = 10;
	level.allowed_uav_ammo		 = 5;
	level.uav_spawn_delay		 = 15;
	level.UAV_pickup_respawn	 = false;
}

so_setup_hardened()
{
	// Wave 1
	init_wave( 1, 15 );

	// Wave 2
	init_wave( 2, 16 );
	add_wave_vehicle( 2, "jeep_1", "uaz" );

	// Wave 3
	init_wave( 3, 17 );
	add_wave_vehicle( 3, "truck_1", "bm21" );

	// Wave 4
	init_wave( 4, 18 );
	add_wave_vehicle( 4, "jeep_1", "uaz", GetVehicleNode( "jeep_1_guys_alt", "targetname" ) );

	level.challenge_objective 	 = CONST_hardened_obj;
	level.new_hostile_accuracy 	 = 1;
	level.wiped_out_requirement	 = 3;
	level.wave_delay 			 = 10;
	level.allowed_uav_ammo		 = 4;
	level.uav_spawn_delay		 = 15;
	level.UAV_pickup_respawn	 = false;
}

so_setup_veteran()
{
	// Wave 1
	init_wave( 1, 15 );

	// Wave 2
	init_wave( 2, 16 );
	add_wave_vehicle( 2, "jeep_1", "uaz" );

	// Wave 3
	init_wave( 3, 17 );
	add_wave_vehicle( 3, "truck_1", "bm21" );

	// Wave 4
	init_wave( 4, 20 );
	add_wave_vehicle( 4, "jeep_1", "uaz", GetVehicleNode( "jeep_1_guys_alt", "targetname" ) );

	// Wave 5
	init_wave( 5, 20 );
	add_wave_vehicle( 5, "truck_2", "bm21" );
	add_wave_vehicle( 5, "jeep_1", "uaz", GetVehicleNode( "jeep_1_guys_alt2", "targetname" ) );

	level.challenge_objective 	 = CONST_veteran_obj;
	level.new_hostile_accuracy	 = 1;
	level.wiped_out_requirement	 = 3;
	level.wave_delay 			 = 10;
	level.allowed_uav_ammo		 = 3;
	level.uav_spawn_delay		 = 20;
	level.UAV_pickup_respawn	 = false;
}

so_rooftop_init()
{
	level.so_uav_picked_up = false;
	level.hostile_count = 0;
	level.wave_spawn_structs = [];

	Assert( IsDefined( level.gameskill ) );
	switch( level.gameSkill )
	{
		case 0:								// Easy
		case 1:	so_setup_Regular();	break;	// Regular
		case 2:	so_setup_hardened();break;	// Hardened
		case 3:	so_setup_veteran();	break;	// Veteran
	}

	// wave move in delay time multiplier depending on if player is on roof or not
	level.roof_factor = 1;

	// setup all attack line script origins
	all_attack_lines = GetEntArray( "attack_line", "targetname" );
	foreach ( attack_line in all_attack_lines )
	{
		attack_line.times_used = 0;
	}

	spawner_setup();
	spawn_functions();

	Objective_Add( 1, "current", level.challenge_objective );
	
	thread enable_escape_warning();
	thread enable_escape_failure();
	thread fade_challenge_out( "challenge_success" );

	thread player_on_roof_think();
//	thread vehicles_think();
//	thread challenge_complete();
	thread wave_wiped_out();
	thread wave_spawn_think();
	thread uav_pickup_setup();
	thread uav();

	// Add the players to the remotemissled targets, but as friendly.
	foreach ( player in level.players )
	{
		player thread maps\_remotemissile::setup_remote_missile_target();
	}
}

spawner_setup()
{
	// Setup the Spawners
	wave_size = get_wave_count();
	for ( i = 1; i < wave_size + 1; i++ )
	{
		new_array = [];
		foreach ( member in GetEntArray( "wave_guys", "script_noteworthy" ) )
		{
			new_array[ new_array.size ] = member;
			if ( new_array.size >= get_wave_ai_count( i ) )
			{
				break;
			}
		}

		level.wave_spawn_structs[ i ].spawners = array_randomize( new_array );
	}

	// We don't want the failsafe spawners to be included in the Setting up of spawners.
	foreach ( spawner in GetEntArray( "failsafe_spawners", "targetname" ) )
	{
		spawner.script_noteworthy = "wave_guys";
	}
}

spawn_functions()
{
	level.current_wave = 1;

	add_global_spawn_function( "axis", ::so_rooftop_ai_postspawn );

	array_spawn_function_noteworthy( "wave_guys", 			::wave_closing_in );
	array_spawn_function_targetname( "truck_1_guys", 		::wave_closing_in, "attack_line_med" );
	array_spawn_function_targetname( "truck_2_guys", 		::wave_closing_in, "attack_line_med" );
	array_spawn_function_targetname( "jeep_1_guys", 		::wave_closing_in, "attack_line_close" );
	array_spawn_function_targetname( "jeep_1_guys_alt", 	::wave_closing_in, "attack_line_close" );
	array_spawn_function_targetname( "jeep_1_guys_alt2", 	::wave_closing_in, "attack_line_med" );

	GetEnt( "truck_1", "targetname" ) 	add_spawn_function( ::setup_base_vehicles );
	GetEnt( "truck_2", "targetname" ) 	add_spawn_function( ::setup_base_vehicles );
	GetEnt( "jeep_1", "targetname" ) 	add_spawn_function( ::setup_base_vehicles );
}

// AI -----------------------------------------------------

so_rooftop_ai_postspawn()
{
	level.hostile_count++;

	self thread hostile_nerf();
	self thread set_wave_id();
	self thread maps\contingency::setup_remote_missile_target_guy();
	self thread death_think();
}

death_think()
{
	self waittill( "death" );
	level.hostile_count--;
}

hostile_nerf()
{
	self.baseaccuracy = level.new_hostile_accuracy;
}

set_wave_id()
{
	if ( !isdefined( level.wave_spawn_structs[ level.current_wave ].wave_members ) )
	{
		level.wave_spawn_structs[ level.current_wave ].wave_members = [];
	}

	members_size = level.wave_spawn_structs[ level.current_wave ].wave_members.size;
	level.wave_spawn_structs[ level.current_wave ].wave_members[ members_size ] = self;
}

getaiarray_by_wave_id()
{
	Assert( IsDefined( level.current_wave ) );
	Assert( IsDefined( level.wave_spawn_structs ) );

	members = level.wave_spawn_structs[ level.current_wave1 ].wave_members;

	Assert( IsDefined( members ) );
	return members;
}

challenge_complete()
{
//	while( level.current_wave > get_wave_count() )
//	{
//		level waittill( "wave_wiped_out" );
//	}

	flag_set( "challenge_success" );
	music_stop();

	level.challenge_end_time = GetTime();
}

start_so_rooftop()
{
	so_rooftop_init();

	thread fade_challenge_in();
	music_loop( "contingency_stealth", 174 );

/#
	test_vehicles();
#/

	wait so_standard_wait();

	enable_challenge_timer( "waves_start", "challenge_success" );
	thread enable_countdown_timer( level.wave_delay );
	wait 2;
	hud_wave_splash( 1, level.wave_delay - 2 );
	flag_set( "waves_start" );
}

// Waves --------------------------------------------------

wave_wiped_out()
{
	level endon( "special_op_terminated" );

	flag_wait( "waves_start" );
	while ( 1 )
	{
		flag_wait( "wave_spawned" );

		population = 0;
		ai_wave = GetAIArray( "axis" );
		foreach ( guy in ai_wave )
		{
			if ( IsAlive( guy ) )
			{
				population++;
			}
		}

		if ( population <= level.wiped_out_requirement )
		{
			// send the remaining guys back to med attack line
			array_thread( ai_wave, ::wave_closing_in, "attack_line_med" );
			//foreach ( guy in ai_wave ) { guy ignore_all_till_goal(); }

			// Wait for everyone to be dead before starting next wave.
			enemies = GetAIArray( "bad_guys" );
			while ( enemies.size > 0 )
			{
				wait( 0.5 );
				enemies = GetAIArray( "bad_guys" );
			}

			//level.wave_spawn_structs[level.current_wave].wave_members = undefined;
			/# so_debug_print( "wave [" + level.current_wave + "] wiped out" ); #/

			flag_clear( "wave_spawned" );
			flag_set( "wave_wiped_out" );

			// sounds
			level.player PlaySound( "arcademode_extralife" );
			if ( IsAlive( level.player2 ) )
			{
				level.player2 PlaySound( "arcademode_extralife" );
			}
		}

		wait( 1 );
	}
}

ignore_all_till_goal()
{
	self endon( "death" );
	self.pathenemyfightdist = 32;
	self waittill( "goal" );
	self.pathenemyfightdist = 192;
}

wave_spawn_think()
{
	level endon( "special_op_terminated" );

	array_thread( level.players, ::hud_hostile_count );

	flag_wait( "waves_start" );
	for ( i = 1; i < level.wave_spawn_structs.size + 1; i++ )
	{
		flag_clear( "wave_wiped_out" );
		level.current_wave = i;

		// Spawn in AI
		// We may want to think of a better mechanism of spawning AI in.
		// Rather than all at once, do something of a short period of time
		// If we do, we'll have to address how the Hostiles counter logic is done.
		spawn_failed_count = 0;
		foreach ( spawner in level.wave_spawn_structs[ i ].spawners )
		{
			spawner set_count( 1 );
			guy = spawner spawn_ai();

			if ( !IsDefined( guy ) )
			{
				spawn_failed_count++;
				so_debug_print( "wave_spawn_think() -- SPAWN FAILED COUNT = " + spawn_failed_count );
			}
		}

		// If an AI does not spawn, try again until one does.
		failsafe_spawners = GetEntArray( "failsafe_spawners", "targetname" );
		for ( q = 0; q < spawn_failed_count; q++ )
		{
			spawner = failsafe_spawners[ RandomInt( failsafe_spawners.size ) ];
			spawner set_count( 1 );
			guy = spawner spawn_ai();

			if ( !IsDefined( guy ) )
			{
				q--;
			}
		}

		so_debug_print( "wave_spawn_think(), Current wave = " + level.current_wave );

		// Spawn in Vehicles
		vehicles = get_wave_vehicles( level.current_wave );
		foreach ( vehicle in vehicles )
		{
			thread spawn_vehicle_and_go( vehicle );
		}

		flag_set( "wave_" + ( level.current_wave ) + "_started" );
		level notify( "new_wave_started" );

		if ( IsDefined( level.so_uav_player ) )
		{
			level.so_uav_player maps\_remotemissile::enable_uav( level.so_uav_picked_up, level.remote_detonator_weapon );
		}

		wait( 1 );// give some time for all AI to spawn into map before monitoring population
		flag_set( "wave_spawned" );

		/# so_debug_print( "wave [" + ( level.current_wave + 1 ) + "] spawn complete" ); #/

		flag_wait( "wave_wiped_out" );

		if ( i == level.wave_spawn_structs.size )
		{
			thread challenge_complete();
			return;
		}

		if ( IsDefined( level.so_uav_player ) )
		{
			level.so_uav_player maps\_remotemissile::disable_uav( level.so_uav_picked_up, true );
		}
		
		foreach ( player in level.players )
		{
			player notify( "force_out_of_uav" );
		}

		hud_new_wave();
	}
}

wave_closing_in( start_with )
{
	self endon( "death" );

	if ( !isalive( self ) )
	{
		return;
	}

	self notify( "wave_closing_in_called" );
	self endon( "wave_closing_in_called" );

	// vehicle riders are to wait till they have unloaded to continue this spawn function
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "vehicle_guys" )
	{
		self waittill( "jumpedout" );
	}

	far_delay 		 = 0;
	med_delay 		 = RandomFloatRange( 15, 20 );
	close_delay 	 = RandomFloatRange( 30, 35 );
	player_delay	 = RandomFloatRange( 15, 25 );
	factor			 = ( 100 - ( ( level.current_wave - 1 ) * 10 ) ) / 100 * level.roof_factor;

	if ( self.classname != "actor_enemy_arctic_SNIPER" )
	{
		factor *= 0.75;
	}

	// shotgun dudes rushes towards player
	if ( self.classname == "actor_enemy_arctic_SHOTGUN" )
	{
		factor *= 0.25;
	}

	if ( IsDefined( start_with ) && start_with != "attack_line_far" )
	{
		AssertEx( start_with == "attack_line_med" || start_with == "attack_line_close", "wave_closing_in() is misused, " + start_with + " attack line does not exist." );

		if ( start_with == "attack_line_med" )
		{
			wave_closing_in_at_line( factor * med_delay, "attack_line_med" );
		}
		wave_closing_in_at_line( factor * close_delay, "attack_line_close" );
	}
	else
	{
		wave_closing_in_at_line( factor * far_delay, "attack_line_far" );
		wave_closing_in_at_line( factor * med_delay, "attack_line_med" );
		wave_closing_in_at_line( factor * close_delay, "attack_line_close" );
	}

	wave_goto_player( factor * player_delay );
}

wave_goto_player( delay )
{
	self endon( "death" );

	wait( delay );
	target_ent = level.player;
	if ( level.players.size > 1 )
	{
		if ( cointoss() )
		{
			target_ent = level.player2;
		}
	}
	self set_goal_entity( target_ent );
}

player_on_roof_think()
{
	// if player on roof, challenge is easier
	while ( 1 )
	{
		level waittill( "player_on_roof" );

		if ( flag( "player_on_roof" ) )
		{
			foreach ( guy in GetAIArray( "axis" ) )
			{
				guy set_goal_radius( 512 );
				level.roof_factor = 1;
				guy hostile_nerf();
			}
			set_grenade_frequency( 1 );
			/# so_debug_print( "player on roof" ); #/
		}
		else
		{
			foreach ( guy in GetAIArray( "axis" ) )
			{
				guy set_goal_radius( 220 );
				level.roof_factor = 0.7;// waves move in faster when player on ground
				guy.baseaccuracy = 2;
			}
			set_grenade_frequency( 0.5 );
			/# so_debug_print( "player off roof" ); #/
		}

		wait( 2 );
	}
}

set_grenade_frequency( fraction )
{
	if ( !isdefined( fraction ) )
		fraction = 1;

	maps\_gameskill::add_fractional_data_point( "playerGrenadeBaseTime", 0.25, 40000 * fraction );// original easy
	maps\_gameskill::add_fractional_data_point( "playerGrenadeBaseTime", 0.75, 35000 * fraction );// original normal
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "hardened" ] = 25000 * fraction;
	level.difficultySettings[ "playerGrenadeBaseTime" ][ "veteran" ] = 25000 * fraction;

	maps\_gameskill::updateGameSkill();
	maps\_gameskill::updateAllDifficulty();
}

wave_closing_in_at_line( delay, attack_line )
{
	self endon( "death" );
	wait delay;
	self set_attack_line( attack_line );
	self waittill( "goal" );
}

set_attack_line( line_position )
{
	attack_line = GetEntArray( line_position, "script_noteworthy" );
	AssertEx( IsDefined( attack_line ), "There is no " + line_position + " attack line in level." );

	// use all attack lines evenly
	to_ent = attack_line[ RandomInt( attack_line.size ) ];
	foreach ( ent in attack_line )
	{
		if ( ent.times_used < to_ent.times_used )
		{
			to_ent = ent;
		}
	}

	self set_goal_radius( to_ent.radius );
	self set_goal_pos( to_ent.origin );
	to_ent.times_used++;

/#
	so_debug_print( "AI[" + self GetEntNum() + "] going to [" + line_position + "]" );
#/
}

test_vehicles()
{
	// TESTING!!!
//	add_wave_vehicle( 2, "jeep_1", "uaz" );
//	add_wave_vehicle( 3, "truck_1", "bm21" );
//	add_wave_vehicle( 4, "jeep_1", "uaz", GetVehicleNode( "jeep_1_guys_alt", "targetname" ) );
//	add_wave_vehicle( 5, "truck_2", "bm21" );
//	add_wave_vehicle( 5, "jeep_1", "uaz", GetVehicleNode( "jeep_1_guys_alt2", "targetname" ) );

//	wait( 5 );
//	temp = SpawnStruct();
//	temp.alt_node = undefined;

// JEEP 1
//	temp.ent = GetEnt( "jeep_1", "targetname" );

// JEEP 1 ALT
//	temp.ent = GetEnt( "jeep_1", "targetname" );
//	temp.alt_node = GetVehicleNode( "jeep_1_guys_alt", "targetname" );

// TRUCK 1
//	temp.ent = GetEnt( "truck_1", "targetname" );

// TRUCK 2
//	temp.ent = GetEnt( "truck_2", "targetname" );

// JEEP 1 ALT2
//	temp.ent = GetEnt( "jeep_1", "targetname" );
//	temp.alt_node = GetVehicleNode( "jeep_1_guys_alt2", "targetname" );

//	spawn_vehicle_and_go( temp );

//	level waittill( "never" );
}