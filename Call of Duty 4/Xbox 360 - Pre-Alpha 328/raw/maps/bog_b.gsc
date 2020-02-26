#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree( "generic_human" );
main()
{
	if ( getdvar( "r_reflectionProbeGenerate" ) == "1" )
		return;
	
	setdvar( "scr_dof_enable", "1" );
	
	if ( getdvar( "bog_camerashake") == "" )
		setdvar( "bog_camerashake", "1" );
		
	if ( getdvar( "bog_debug_tank") == "" )
		setdvar( "bog_debug_tank", "0" );
	
	if ( getdvar( "bog_debug_flyby") == "" )
		setdvar( "bog_debug_flyby", "0" );
	
	add_start( "arch", ::start_arch );
	add_start( "alley", ::start_alley );
	add_start( "ch46", ::start_ch46 );
	default_start( ::start_bog );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_clip";
	level.weaponClipModels[1] = "weapon_m16_clip";
	level.weaponClipModels[2] = "weapon_saw_clip";
	level.weaponClipModels[3] = "weapon_ak74u_clip";
	level.weaponClipModels[4] = "weapon_g3_clip";
	level.weaponClipModels[5] = "weapon_dragunov_clip";
	
	flag_init( "tank_clear_to_shoot" );
	flag_init( "door_idle_guy_idling" );
	flag_init( "price_at_spotter" );
	flag_init( "ok_to_do_spotting" );
	flag_init( "tank_in_final_position" );
	flag_init( "tank_turret_aimed_at_t72" );
	flag_init( "friendly_reactions_over" );
	flag_init( "t72_in_final_position" );
	flag_init( "t72_exploded" );
	flag_init( "abrams_move_shoot_t72" );
	flag_init( "abrams_advance_to_end_level" );
	flag_init( "allowTankFire" );
	
	level.radioForcedTransmissionQueue = [];
	
	precacheModel( "vehicle_av-8b_harrier_jet" );
	precacheModel( "vehicle_t72_tank_d_animated_sequence" );
	precacheItem( "m1a1_turret_blank" );
	precacheString( &"BOG_B_OBJ_ESCORT_TANK" );
	precacheString( &"BOG_B_OBJ_SEAKNIGHT" );
	precacheString( &"BOG_B_T72_MG_DEATH" );
	
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_t72::main( "vehicle_t72_tank" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\_seaknight::main( "vehicle_ch46e" );
	maps\createart\bog_b_art::main();
	maps\bog_b_fx::main();
	maps\_load::main();
	maps\bog_b_anim::main();
	maps\_compass::setupMiniMap( "compass_map_bog_b" );
	thread maps\bog_b_amb::main();
	thread maps\_mortar::bog_style_mortar();
	thread fog_adjust();
	thread teamsSplitUp();
	thread lastSequence();
	thread playerInit();
	thread alley_cleared();
	
	level.cosine = [];
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "65" ] = cos( 65 );
	level.cosine[ "80" ] = cos( 80 );
	
	level.exploderArray = [];
	level.exploderArray[ 0 ][ 0 ] = setupExploder( 105 );
	level.exploderArray[ 0 ][ 1 ] = setupExploder( 104 );
	level.exploderArray[ 0 ][ 2 ] = setupExploder( 102 );
	level.exploderArray[ 0 ][ 3 ] = setupExploder( 103 );
	level.exploderArray[ 1 ][ 0 ] = setupExploder( 100, ::killSpawner, 7 );
	level.exploderArray[ 1 ][ 1 ] = setupExploder( 101 );
	level.exploderArray[ 2 ][ 0 ] = setupExploder( 200 );
	level.exploderArray[ 2 ][ 1 ] = setupExploder( 201 );
	
	// friendly respawn init;
	flag_set( "respawn_friendlies" );
	set_promotion_order( "r", "y" );
	set_empty_promotion_order( "y" );
	set_empty_promotion_order( "g" );
	
	array_thread( getentarray( "stragglers_chase", "targetname" ), ::stragglers_chase );
	array_thread( getentarray( "flyby", "targetname" ), ::flyby );
	array_thread( getentarray( "chain_and_home", "script_noteworthy" ), ::add_spawn_function, ::chain_and_home );
	array_thread( getentarray( "rpg_tank_shooter", "script_noteworthy" ), ::add_spawn_function, ::rpg_tank_shooter );
	array_thread( getentarray( "rpg_tank_shooter_fall", "script_noteworthy" ), ::add_spawn_function, ::rpg_tank_shooter );
	array_thread( getentarray( "vehicle_path_disconnector", "targetname" ), ::vehicle_path_disconnector );
	array_thread( getentarray( "delete_ai", "targetname" ), ::delete_ai_in_zone );
	array_thread( getentarray( "autosave_when_trigger_cleared", "targetname" ), ::autosave_when_trigger_cleared );
	array_thread( getentarray( "delete_all_axis", "script_noteworthy" ), ::delete_all_axis );
	
	wait 0.05;
	
	clip = getent( "truck_clip_before", "targetname" );
	assert( isdefined( clip ) );
	clip notsolid();
	clip delete();
	
	level.abrams = getent( "abrams", "targetname" );
	if ( !isdefined( level.abrams ) )
		level.abrams = maps\_vehicle::waittill_vehiclespawn( "abrams" );
	assert( isdefined( level.abrams ) );
	level.abrams.forwardEnt = spawn( "script_origin", level.abrams getTagOrigin( "tag_flash" ) );
	level.abrams.forwardEnt linkto( level.abrams );
	assert( isdefined( level.abrams ) );
	
	level.tire_fire = getent( "tire_fire", "targetname" );
	assert( isdefined( level.tire_fire ) );
	playfxontag( level._effect["firelp_large_pm"], level.tire_fire, "tag_origin" );
	
	wait 6.5;
	getent( "player_spawn_safety_brush", "targetname" ) delete();
	wait 3.0;
	objective_add( 1, "current", &"BOG_B_OBJ_ESCORT_TANK", ( 4347, -4683, 130 ) );
}

bog_dialog()
{
	wait 4;
	battlechatter_off( "allies" );
	
	excluders = [];
	excluders[0] = level.price;
	
	generic_marine1 = get_closest_ai_exclude ( level.player.origin ,  "allies", excluders );
	assert( isdefined( generic_marine1 ) );
	
	excluders[1] = generic_marine1;
	generic_marine2 = get_closest_ai_exclude ( level.player.origin ,  "allies", excluders );
	assert( isdefined( generic_marine2 ) );
	
	if ( !generic_marine1 isHero() )
		generic_marine1 thread magic_bullet_shield( undefined, 5.0 );
	
	if ( !generic_marine2 isHero() )
		generic_marine2 thread magic_bullet_shield( undefined, 5.0 );
	
	generic_marine1.animname = "marine1";
	generic_marine2.animname = "marine2";
	
	generic_marine1 anim_single_solo ( generic_marine1, "getyourass" );
	wait 1;
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "wereclear" ] );
	flag_wait( "evemy_helicopter_reinforcement_spawned" );
	wait 8;
	generic_marine2 anim_single_solo ( generic_marine2, "enemyair" );
	wait 0.05;
	level.price anim_single_solo ( level.price, "grabrpg" );
	wait 10;
	generic_marine1 anim_single_solo ( generic_marine1, "rightflank" );
	
	if ( !generic_marine1 isHero() )
		generic_marine1 notify( "stop magic bullet shield" );
	
	if ( !generic_marine2 isHero() )
		generic_marine2 notify( "stop magic bullet shield" );
	
	battlechatter_on( "allies" );
}

isHero()
{
	if ( !isdefined( self ) )
		return false;
	
	if ( !isdefined( self.script_noteworthy ) )
		return false;
	
	if ( self.script_noteworthy == "hero" )
		return true;
	
	return false;
}

fog_adjust()
{
	fog_in = getent( "fog_in", "targetname" );
	fog_out = getent( "fog_out", "targetname" );
	
	assert( isdefined( fog_in ) );
	assert( isdefined( fog_out ) );
	
	for(;;)
	{
		fog_in waittill( "trigger" );
		setExpFog(0, 2842, 0.642709, 0.626383, 0.5, 3.0);
		
		fog_out waittill( "trigger" );
		setExpFog(0, 3842, 0.642709, 0.626383, 0.5, 3.0);
	}
}

start_bog()
{
	spawn_starting_friendlies( "friendly_starting_spawner" );
	
	thread ignored_till_fastrope( "introchopper1" );
	thread ignored_till_fastrope( "introchopper2" );
	
	thread bog_enemies_retreat();
	
	while( !isdefined( level.abrams ) )
		wait 0.05;
	
	thread tank_advancement_bog();
	thread first_friendly_advancement_trigger();
	thread bog_dialog();
	
	level.player.ignoreme = true;
	wait 6;
	level.player.ignoreme = false;
}

first_friendly_advancement_trigger()
{
	trigger = getent( "first_friendly_advancement_trigger", "script_noteworthy" );
	assert( isdefined( trigger ) );
	trigger endon( "trigger" );
	wait 3;
	if ( !isdefined( trigger ) )
		return;
	trigger notify( "trigger" );
}

start_arch()
{
	spawn_starting_friendlies( "friendly_starting_spawner_arch" );
	
	start = getent( "playerstart_arch", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	wait 0.05;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	while( !isdefined( level.abrams ) )
		wait 0.05;
	
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	level.abrams attachPath( tank_path_2 );
	
	thread tank_advancement_arch();
}

start_alley()
{
	spawn_starting_friendlies( "friendly_starting_spawner_alley" );
	
	start = getent( "playerstart_alley", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	waittillframeend;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	// all allies now become invulnerable
	thread friendly_reinforcements_magic_bullet();
	array_thread( getaiarray( "allies" ), ::magic_bullet_shield, undefined, 5.0 );
	
	while( !isdefined( level.abrams ) )
		wait 0.05;
	
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	level.abrams attachPath( tank_path_2 );
	
	node = getvehiclenode( "stop_for_city_fight3", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	thread tank_advancement_alley();
}

start_ch46()
{
	start = getent( "seaknight_land_location", "script_noteworthy" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	waittillframeend;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	thread seaknight();
}

spawn_starting_friendlies( sTargetname )
{
	spawners = getentarray( sTargetname, "targetname" );
	for( i = 0 ; i < spawners.size ; i++ )
	{
		friend = spawners[ i ] stalingradSpawn();
		if ( spawn_failed( friend ) )
			assertMsg( "A friendly failed to spawn" );
		friend.goalradius = 32;
		
		if ( issubstr( friend.classname, "vasquez" ) )
			level.price = friend;
		
		if ( issubstr( friend.classname, "mark" ) )
			level.grigsby = friend;
		
		if ( friend isHero() )
			friend thread magic_bullet_shield( undefined, 5.0 );
	}
	
	assert( isdefined( level.price ) );
	level.price.animname = "price";
	level.price make_hero();
	
	assert( isdefined( level.grigsby ) );
	level.grigsby.animname = "grigsby";
	level.grigsby make_hero();
	level.grigsby.suppressionThreshold = 1.0;
	
	array_thread( getaiarray( "allies" ), ::replace_on_death );
}

ignored_till_fastrope( sTargetname )
{
	vehicle = undefined;
	vehicle = getent( sTargetname, "targetname" );
	if ( !isdefined( vehicle ) )
		vehicle = maps\_vehicle::waittill_vehiclespawn( sTargetname );
	
	assert( isdefined( vehicle.riders ) );
	
	for( i = 0 ; i < vehicle.riders.size ; i++ )
	{
		vehicle.riders[i].ignoreme = true;
	}
	
	vehicle waittill( "unload" );
	
	wait 5;
	
	if( !isdefined( vehicle ) )
		return;
	for( i = 0 ; i < vehicle.riders.size ; i++ )
	{
		if( !isdefined( vehicle.riders[i] ) )
			continue;
		if( !isAlive( vehicle.riders[i] ) )
			continue;
		vehicle.riders[i].ignoreme = false;
	}
}

stragglers_chase()
{
	assert( isdefined( self.target ) );
	volume = getent( self.target, "targetname" );
	assert( isdefined( volume ) );
	
	self waittill( "trigger" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( !( enemies[ i ] istouching( volume ) ) )
			continue;
		
		enemies[i].goalradius = 600;
		enemies[i] setgoalentity( level.player );
	}
}

truck_crush_tank_in_position()
{
	node = getVehicleNode( "truck_crush_node", "script_noteworthy" );
	assert( isdefined( node ) );
	node waittill( "trigger" );
	level.abrams setSpeed( 0, 999999999, 999999999 );
	flag_set( "truck_crush_tank_in_position" );
}

chain_and_home()
{
	self endon( "death" );
	
	self waittill( "reached_path_end" );
	
	newGoalRadius = distance( self.origin, level.player.origin );
	
	for(;;)
	{
		wait 5;
		self.goalradius = newGoalRadius;
			
		self setgoalentity ( level.player );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}

rpg_tank_shooter()
{
	self endon( "death" );
	
	// when this guy spawns he tries to shoot the tank with his RPG
	self waittill( "goal" );
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "rpg_tank_shooter_fall" ) )
		self thread roof_guy_fall_on_death();
	
	self setentitytarget( level.abrams );
	wait 10;
	if ( isdefined( self ) )
		self clearEnemy();
}

roof_guy_fall_on_death()
{
	self endon( "death" );
	self.health = 10;
	for(;;)
	{
		self.deathanim = %exposed_death_neckgrab;
		self.deathFunction = ::roof_guy_fall_death_function;
		wait 0.05;
	}
}

roof_guy_fall_death_function()
{
	self setanim( %exposed_death_neckgrab );
	wait 3;
	self startragdoll();
}

attack_troops()
{
	self notify( "stop_attacking_troops" );
	self endon( "stop_attacking_troops" );
	self endon( "death" );
	wait 1;
	for(;;)
	{
		wait( randomfloatrange( 2, 5 ) );
		
		eTarget = maps\_helicopter_globals::getEnemyTarget( 10000, level.cosine[ "80" ], true, false, false, true );
		if ( !isdefined( eTarget ) )
			continue;
		
		zDifference = abs( eTarget.origin[ 2 ] - self.origin[ 2 ] );
		dist = distance( eTarget.origin, self.origin );
		angle = asin( zDifference / dist );
		if ( angle > 15 )
			continue;
		
		targetLoc = eTarget.origin + ( 0, 0, 32 );
		self setTurretTargetVec( targetLoc );
		
		if ( getdvar( "bog_debug_tank") == "1" )
			thread draw_line_until_notify( level.abrams.origin + ( 0, 0, 32 ), targetLoc, 1, 0, 0, self, "stop_drawing_line" );
		
		self waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
		self clearTurretTarget();
		
		if ( getdvar( "bog_debug_tank") == "1" )
		{
			self notify( "stop_drawing_line" );
			thread draw_line_until_notify( level.abrams.origin + ( 0, 0, 32 ), targetLoc, 0, 1, 0, self, "stop_drawing_line" );
		}
		
		if ( getdvar( "bog_debug_tank") == "1" )
			self notify( "stop_drawing_line" );
	}
}

tank_turret_forward()
{	
	getent( "tank_turret_forward", "targetname" ) waittill( "trigger" );
	self notify( "stop_attacking_troops" );
	
	self setturrettargetent( self.forwardEnt );
	self waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	self clearTurretTarget();
}

ambush_ahead_dialog()
{
	battlechatter_off( "allies" );
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "possibleambush" ] );
	wait 3;
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "standclear" ] );
	
	battlechatter_on( "allies" );
	
	flag_set( "tank_clear_to_shoot" );
}

playRadioSound( soundAlias )
{
	if ( !isdefined( level.radio_in_use ) )
		level.radio_in_use = false;
	
	soundPlayed = false;
	soundPlayed = playAliasOverRadio( soundAlias );
	if ( soundPlayed )
		return;
	
	level.radioForcedTransmissionQueue[ level.radioForcedTransmissionQueue.size ] = soundAlias;
	while( !soundPlayed )
	{
		if ( level.radio_in_use )
			level waittill ( "radio_not_in_use" );
		soundPlayed = playAliasOverRadio( level.radioForcedTransmissionQueue[ 0 ] );
		if ( !level.radio_in_use && !soundPlayed )
			assertMsg( "The radio wasn't in use but the sound still did not play. This should never happen." );
	}
	level.radioForcedTransmissionQueue = array_remove_index( level.radioForcedTransmissionQueue, 0 );
}

playAliasOverRadio( soundAlias )
{
	if ( level.radio_in_use )
		return false;
	
	level.radio_in_use = true;
	level.player playLocalSound( soundAlias, "playSoundOverRadio_done" );
	level.player waittill( "playSoundOverRadio_done" );
	level.radio_in_use = false;
	level.lastRadioTransmission = getTime();
	level notify ( "radio_not_in_use" );
	return true;
}

shoot_buildings( exploderGroup )
{
	self notify( "stop_attacking_troops" );
	
	flag_wait( "tank_clear_to_shoot" );
	
	for(;;)
	{
		if ( level.exploderArray[ exploderGroup ].size <= 0 )
			break;
		
		nextExploderIndex = undefined;
		nextExploderIndex = getNextExploder( exploderGroup );
		if ( !isdefined( nextExploderIndex ) )	
		{
			wait randomfloat( 2, 4 );
			continue;
		}
		
		shoot_exploder( level.exploderArray[ exploderGroup ][ nextExploderIndex ] );
		level.exploderArray[ exploderGroup ] = array_remove_index ( level.exploderArray[ exploderGroup ], nextExploderIndex );
		
		wait randomfloat( 6, 10 );
	}
	
	self notify( "abrams_shot_explodergroup" );
}

setupExploder( exploderNum, explodedFunction, parm1 )
{
	exploderStruct = spawnStruct();
	
	exploderStruct.iNumber = int( exploderNum );
	exploderStruct.sNumber = string( exploderNum );
	
	// find the related origin
	origins = getentarray( "exploder_tank_target", "targetname" );
	for( i = 0 ; i < origins.size ; i++ )
	{
		assert( isdefined( origins[ i ].script_noteworthy ) );
		if ( origins[ i ].script_noteworthy == exploderStruct.sNumber )
			exploderStruct.origin = origins[ i ].origin;
	}
	assert( isdefined( exploderStruct.origin ) );
	
	// find the area trigger if one exists
	areatrigs = getentarray( "exploder_area", "targetname" );
	for( i = 0 ; i < areatrigs.size ; i++ )
	{
		assert( isdefined( areatrigs[ i ].script_noteworthy ) );
		if ( areatrigs[ i ].script_noteworthy == exploderStruct.sNumber )
			exploderStruct.areaTrig = areatrigs[ i ];
	}
	
	exploderStruct.explodedFunction = explodedFunction;
	exploderStruct.parm1 = parm1;
	
	return exploderStruct;
}

getNextExploder( exploderGroup )
{
	// try to find one that the player is looking at
	
	// if the exploder has an area trigger make sure the player isn't touching it
	validIndicies = [];
	for( i = 0 ; i < level.exploderArray[ exploderGroup ].size ; i++ )
	{
		if ( isdefined( level.exploderArray[ exploderGroup ][ i ].areaTrig ) && level.player isTouching( level.exploderArray[ exploderGroup ][ i ].areaTrig ) )
			continue;
		validIndicies[ validIndicies.size ] = i;
	}
	if ( validIndicies.size == 0 )
		return undefined;
	
	// if the player is looking at one of the valid exploders then use that one
	for( i = 0 ; i < validIndicies.size ; i++ )
	{
		qInFOV = within_fov( level.player getEye(), level.player getPlayerAngles(), level.exploderArray[ exploderGroup ][ validIndicies[ i ] ].origin, level.cosine[ "35" ] );
		if ( qInFOV )
			return validIndicies[ i ];
	}
	return validIndicies[ 0 ];
}

shoot_exploder( exploderStruct )
{
	level.abrams thread tank_shooting_exploder_dialog( exploderStruct.iNumber );		
	
	level.abrams waittill( "target_aquired" );
	level.abrams setTurretTargetVec( exploderStruct.origin );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
	level.abrams clearTurretTarget();
	level.abrams.readyToFire = true;
	
	flag_wait( "allowTankFire" );
	level.abrams.readyToFire = undefined;
	level.abrams notify( "turret_fire" );
	flag_clear( "allowTankFire" );
	wait 0.2;
	
	//blow up the wall now
	exploder( exploderStruct.iNumber );
	
	if ( isdefined( exploderStruct.explodedFunction ) )
	{
		if ( isdefined( exploderStruct.parm1 ) )
			level thread [[ exploderStruct.explodedFunction ]]( exploderStruct.parm1 );
		else
			level thread [[ exploderStruct.explodedFunction ]]();
	}
	
	wait 0.05;
	SetPlayerIgnoreRadiusDamage( true );
	radiusDamage( exploderStruct.origin, 300, 5000, 1000 );
	badplace_cylinder( exploderStruct.sNumber, 7.0, exploderStruct.origin, 200, 300, "axis" );
	wait 0.2;
	SetPlayerIgnoreRadiusDamage( false );
}

tank_shooting_exploder_dialog( exploderNum )
{
	assert( isdefined( exploderNum ) );
	
	if ( exploderNum == 105 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "2story1_ground" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else if ( exploderNum == 104 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "2story1_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 102 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up3" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story11_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired3" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire3" ] );
	}
	else if ( exploderNum == 103 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up4" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story1130_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else if ( exploderNum == 100 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story1230_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 101 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story11_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 200 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 201 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up3" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else
	{
		wait 0.05;
		self notify( "target_aquired" );
		wait 0.05;
	}
	
	self.readyToFire = true;
	flag_set( "allowTankFire" );
}

killSpawner( num )
{
	thread maps\_spawner::kill_spawnerNum( num );
}

alley_cleared()
{
	waittill_aigroupcleared( "0" );
	
	alley_trig_to_delete = getent( "alley_color_trigger", "script_noteworthy" );
	if ( isdefined( alley_trig_to_delete ) )
		alley_trig_to_delete delete();
	getent( "alley_protect_door_breech_color_trigger", "targetname" ) notify( "trigger" );
	
	alleyFriends = get_force_color_guys( "allies", "r" );
	assert( alleyFriends.size >= 1 );
	alley_door_kick( alleyFriends[ 0 ] );
	thread advanceAlleyFriendliesToEnd( alleyFriends[ 0 ], alleyFriends[ 1 ] );
}

alley_door_kick( guy )
{
	assert( isdefined( guy ) );
	
	guys[ 0 ] = guy;
	guys[ 1 ] = level.price;
	
	guys[ 0 ].animname = "alley_door_kicker_left";
	guys[ 1 ].animname = "alley_door_kicker_right";
	
	alley_door_scripted_node = getent( "alley_door_scripted_node", "targetname" );
	assert( isdefined( alley_door_scripted_node ) );
	
	// guy1 waits at the door until guy2 arrives
	thread alley_door_guy1_idle( alley_door_scripted_node, guys[ 0 ] );
	wait 1;
	alley_door_scripted_node anim_reach_solo ( guys[ 1 ], "enter" );
	flag_wait( "door_idle_guy_idling" );
	guys[ 0 ] notify( "stop_door_idle" );
	alley_door_scripted_node anim_single( guys, "enter" );
	
	getent( "last_color_order_trigger", "targetname" ) notify( "trigger" );
	thread alley_door_remove_player_clip();
}

alley_door_remove_player_clip( fDelay )
{
	if ( isdefined( fDelay ) )
		wait fDelay;
	getent( "alley_door_player_clip", "targetname" ) delete();
}

alley_door_guy1_idle( node, guy )
{
	node anim_reach_and_idle_solo( guy, "idle_reach", "idle", "stop_door_idle" );
	flag_set( "door_idle_guy_idling" );
}

alley_doorOpen( guy )
{
	// called from a notetrack
	alley_door = getent( "alley_door", "targetname" );
	assert( isdefined( alley_door ) );
	alley_door connectPaths();
	alley_door rotateYaw( -140, 0.5, 0, 0 );
	wait 0.5;
	alley_door disconnectPaths();
}

flyby()
{
	assert( isdefined( self.target ) );
	origins = getentarray( self.target, "targetname" );
	assert( origins.size > 0 );
	for( i = 0 ; i < origins.size ; i++ )
		self thread flyby_go( origins[ i ] );
}

flyby_go( origin1 )
{
	assert( isdefined( origin1 ) );
	assert( isdefined( origin1.target ) );
	origin2 = getent( origin1.target, "targetname" );
	assert( isdefined( origin2 ) );
	
	// Get starting and ending point for the plane
	center = ( ( ( origin1.origin[ 0 ] + origin2.origin[ 0 ] ) / 2 ), ( ( origin1.origin[ 1 ] + origin2.origin[ 1 ] ) / 2 ), 0 );
	angle = VectorToAngles( origin2.origin - origin1.origin );
	
	direction = ( 0, angle[ 1 ], 0 );
	planeStartingDistance = -20000;
	planeEndingDistance = 20000;
	planeFlySpeed = 4000;
	
	startPoint = center + vector_multiply( anglestoforward( direction ), planeStartingDistance );
	startPoint += ( 0, 0, origin1.origin[ 2 ] );
	endPoint = center + vector_multiply( anglestoforward( direction ), planeEndingDistance );
	endPoint += ( 0, 0, origin2.origin[ 2 ] );
	
	self waittill( "trigger" );
	
	// Spawn the plane
	plane = spawn( "script_model", startPoint );
	plane setModel( "vehicle_av-8b_harrier_jet" );
	plane.angles = direction;
	
	// Make the plane fly by
	d = abs( planeStartingDistance - planeEndingDistance );
	flyTime = ( d / planeFlySpeed );
	
	// Draw some debug lines of the plane's path
	if ( getdvar( "bog_debug_flyby") == "1" )
	{
		thread draw_line_for_time( center, center + ( 0, 0, 200 ), 0, 0, 1, flyTime );
		thread draw_line_for_time( origin1.origin, origin2.origin, .1, .2, .4, flyTime );
		thread draw_line_for_time( center, startPoint, 0, .4, 0, flyTime );
		thread draw_line_for_time( center, endPoint, 0, .8, 0, flyTime );
		thread draw_line_to_ent_for_time( center, plane, 1, 0, 0, flyTime );
	}
	
	plane moveTo( endPoint, flyTime, 0, 0 );
	thread flyby_planeSound( plane );
	
	// Delete the plane after it's flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

flyby_afterburner( plane )
{
	plane endon( "delete" );
	wait randomfloatrange( 0.5, 2.5 );
	for (;;)
	{
		playfxontag( level._effect["afterburner"], plane, "tag_engine_right" );
		playfxontag( level._effect["afterburner"], plane, "tag_engine_left" );
		wait 0.1;
	}
}

flyby_planeSound( plane )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !maps\_mig29::playerisclose( plane ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( maps\_mig29::playerisinfront( plane ) )
		wait .05;
	wait .5;
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	thread flyby_afterburner( plane );
	while( maps\_mig29::playerisclose( plane ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

teamsSplitUp()
{
	getent( "teams_split_up", "script_noteworthy" ) waittill( "trigger" );
	
	area = getent( "price_inside_split_up_house", "targetname" );
	for(;;)
	{
		area waittill( "trigger", ent );
		if ( !isdefined( ent ) )
			continue;
		if ( ent == level.price )
			break;
	}
	
	anim_single_solo( level.price, "keeppinned" );
	if ( isdefined( level.grigsby ) )
	{
		level.grigsby.animname = "grigsby";
		thread anim_single_solo( level.grigsby, "staysharp" );
	}
	
	// all allies now become invulnerable
	thread friendly_reinforcements_magic_bullet();
	array_thread( getaiarray( "allies" ), ::magic_bullet_shield, undefined, 5.0 );
}

lastSequence()
{
	thread t72_kill_player_trigger();
	thread t72_in_final_position();
	
	flag_wait( "price_at_spotter" );
	flag_wait( "ok_to_do_spotting" );
	
	priceNode = getnode( "price_last_node", "targetname" );
	level.price.animname = "price";
	level.price anim_single_solo( level.price, "casual_2_spot" );
	level.price thread anim_loop_solo( level.price, "spot", undefined, "stop_idle" );
	level.price thread anim_single_solo( level.price, "t72behind" );
	wait 3;
	flag_set( "abrams_move_shoot_t72" );
	wait 1.5;
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "switchmanual" ] );
	
	thread finalGenericDialog();
	
	//wait for the tank to be in position and turret aligned
	flag_wait( "tank_in_final_position" );
	flag_wait( "tank_turret_aimed_at_t72" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "takeshot" ] );
	
	//-------------------------------------
	// tank should be shot and explode here
	//-------------------------------------
	level.abrams clearTurretTarget();
	level.abrams setVehWeapon( "m1a1_turret_blank" );
	wait 0.05;
	level.t72 notify( "exploding" );
	level.t72 maps\_vehicle::mgOff();
	level.abrams notify( "turret_fire" );
	level notify( "t72_exploded" );
	exploder( 400 );
	
	end_sequence_physics_explosion = getentarray( "end_sequence_physics_explosion", "targetname" );
	for( i = 0 ; i < end_sequence_physics_explosion.size ; i++ )
		physicsExplosionSphere( end_sequence_physics_explosion[ i ].origin, 550, 100, 1.2 );
	
	wait .2;
	level thread t72_explosion_explode();
	level thread enemies_fall_back();
	//-------------------------------------
	//-------------------------------------
	//-------------------------------------
	
	flag_wait( "friendly_reactions_over" );
	
	anim_single_solo( level.price, "niceshootingpig" );
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "comingthrough" ] );
	
	flag_set( "abrams_advance_to_end_level" );
	
	wait 2;
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "wethereyet" ] );
	level.player playRadioSound( level.scr_sound[ "hq_radio" ][ "statusover" ] );
	anim_single_solo( level.price, "cargo" );
	
	thread seaknight();
}

t72_kill_player_trigger()
{
	level endon( "t72_exploded" );
	
	trigger = getent( "t72_kill_player_trigger", "targetname" );
	
	for(;;)
	{
		trigger waittill( "trigger", ent );
		if ( ent != level.player )
			continue;
		
		// kill the player!
		dmgAmount = ( level.player.health / 3 );
		while( isalive( level.player ) )
		{
			wait randomfloatrange( 0.05, 0.3 );
			if ( isdefined( level.t72 ) )
				level.player doDamage ( dmgAmount, level.t72.origin );
			else
				level.player doDamage ( dmgAmount, level.player.origin );
		}
		level notify( "new_quote_string" );
		setdvar( "ui_deadquote", "@BOG_B_T72_MG_DEATH" );
	}
}

t72_explosion_explode()
{
	level.t72 thread t72_explosionFX();

	level.t72 useAnimTree( level.scr_animtree[ "tank_explosion" ] );
	level.t72 setFlaggedAnim( "tank_explosion_anim", level.scr_anim[ "tank" ][ "explosion" ], 1, 0.1, 1 );
	level.t72 setmodel( "vehicle_t72_tank_d_animated_sequence" );
	
	level.t72 waittillmatch( "tank_explosion_anim", "turret_explosion" );
	level.t72 thread play_sound_in_space( "bog_scn_tankturret_exp" );
	wait 0.8;
	level.t72 thread play_sound_in_space( "bog_scn_tankturret_crash" );
}

t72_explosionFX()
{
	playfxontag( level._effect[ "t72_explosion" ], level.t72, "tag_deathfx" );
	level.t72 thread play_sound_in_space( "explo_metal_rand" );
	physicsExplosionSphere( level.t72.origin, 1000, 20, 2 );
	playfxontag( level._effect[ "t72_ammo_breach" ], level.t72, "tag_deathfx" );
	wait 3.5;
	thread friendlyReactionAnims();
	flag_set( "t72_exploded" );
	playfxontag( level._effect[ "t72_ammo_explosion" ], level.t72, "tag_deathfx" );
	playfxontag( level._effect[ "firelp_large_pm" ], level.t72, "tag_deathfx" );
	wait .15;
	physicsExplosionSphere( level.t72.origin, 1000, 100, 2 );
}

abrams_setup_t72()
{
	assert( isdefined( level.t72 ) );
	thread abrams_moveto_t72();
	thread abrams_aimat_t72();
}

abrams_moveto_t72()
{
	level.abrams resumeSpeed( 3 );
	level.abrams setWaitNode( getvehiclenode( "tank_shoots_t72_node", "script_noteworthy" ) );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 1000, 1000 );
	flag_set( "tank_in_final_position" );
}

abrams_aimat_t72()
{
	flag_wait( "t72_in_final_position" );
	flag_set( "tank_in_final_position" );
	level.abrams setTurretTargetVec( level.t72.origin + ( 0, 0, 50 ) );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
	flag_set( "tank_turret_aimed_at_t72" );
}

enemies_fall_back()
{
	thread killSpawner( 8 );
	
	// make axis ignore allies so they run away without shooting
	setignoremegroup( "allies", "axis" );
	
	node = getnode( "enemy_fallback_node", "targetname" );
	array_thread( getaiarray( "axis" ), ::enemies_fall_back_thread, node );
}

enemies_fall_back_thread( node )
{
	self.ignoreme = true;
	self.goalradius = 16;
	self setgoalnode( node );
	self waittill( "goal" );
	self delete();
}

friendly_reinforcements_magic_bullet()
{
	for(;;)
	{
		level waittill( "reinforcement_spawned", reinforcement );
		
		if ( !isdefined( reinforcement ) )
			continue;
		
		if ( !isalive( reinforcement ) )
			continue;
		
		reinforcement thread magic_bullet_shield( undefined, 5.0 );
	}
}

getFiveFriendliesTimeout( timeout )
{
	level endon( "got 5 friendlies" );
	wait timeout;
	assertMsg( "Failed to get 5 alive friendlies for a scripted sequence" );
}

finalGenericDialog()
{
	// get 5 friendlies excluding price
	allies = getaiarray( "allies" );
	friendsToSpeak = [];
	for( i = 0 ; i < allies.size ; i++ )
	{
		if ( allies[ i ] == level.price )
			continue;
		friendsToSpeak[ friendsToSpeak.size ] = allies[ i ];
	}
	
	// friendlies could be dead when this is called so we have to wait until reinforcements have spawned till we have 5 guys
	// dont try for too long though, time out after say 8 seconds.
	level thread getFiveFriendliesTimeout( 8.0 );
	for(;;)
	{
		if ( friendsToSpeak.size >= 5 )
			break;
		
		level waittill( "reinforcement_spawned", reinforcement );
		
		if ( !isdefined( reinforcement ) )
			continue;
		
		if ( !isalive( reinforcement ) )
			continue;
		
		friendsToSpeak[ friendsToSpeak.size ] = reinforcement;
	}
	assert( friendsToSpeak.size >= 5 );
	level notify( "got 5 friendlies" );
	
	friendsToSpeak[ 0 ].animname = "gm1";
	friendsToSpeak[ 1 ].animname = "gm2";
	friendsToSpeak[ 2 ].animname = "gm3";
	friendsToSpeak[ 3 ].animname = "gm4";
	friendsToSpeak[ 4 ].animname = "gm5";
	
	flag_wait( "t72_exploded" );
	
	wait 2;
	
	friendsToSpeak[ 0 ].animname = "gm1";
	friendsToSpeak[ 1 ].animname = "gm2";
	friendsToSpeak[ 2 ].animname = "gm3";
	friendsToSpeak[ 3 ].animname = "gm4";
	friendsToSpeak[ 4 ].animname = "gm5";
	
	thread anim_single_solo( friendsToSpeak[ 0 ], "wooyeah" );
	wait 1.5;
	thread anim_single_solo( friendsToSpeak[ 1 ], "holyshit" );
	wait 1.75;
	thread anim_single_solo( friendsToSpeak[ 2 ], "hellyeah" );
	wait 2.1;
	thread anim_single_solo( friendsToSpeak[ 3 ], "yeahwoo" );
	wait 1.5;
	thread anim_single_solo( friendsToSpeak[ 4 ], "talkinabout" );
	wait 2.3;
	
	flag_set( "friendly_reactions_over" );
}

friendlyReactionAnims()
{
	allies = getAIArray( "allies" );
	for( i = 0 ; i < allies.size ; i++ )
	{
		if ( !isAlive( allies[ i ] ) )
			continue;
		
		if ( allies[ i ] == level.price )
		{
			allies[ i ] thread price_react_and_loop();
		}
		else if ( ( isdefined( allies[ i ].script_noteworthy ) ) && ( allies[ i ].script_noteworthy == "doorblocker" ) )
		{
			allies[ i ] thread guard_react_and_celebrate();
		}
		else
		{
			allies[ i ].animname = "casualcrouch";
			allies[ i ] thread anim_single_solo( allies[ i ], "react" );
		}
	}
}

guard_react_and_celebrate()
{
	self.animname = "guard";
	self anim_single_solo( self, "react" );
	wait 1.0;
	self thread anim_single_solo( self, "celebrate" );
}

price_react_and_loop()
{
	self notify( "stop_idle" );
	self anim_single_solo( self, "react" );
	self thread anim_loop_solo( self, "spot", undefined, "stop_idle" );
}

advanceAlleyFriendliesToEnd( guy1, guy2 )
{
	doorblocker = undefined;
	if ( guy1 != level.price )
		doorblocker = guy1;
	else if ( guy2 != level.price )
		doorblocker = guy2;
	assert( isdefined( doorblocker ) );
	guy1 = undefined;
	guy2 = undefined;
	
	doorblocker set_force_color( "b" );
	doorblocker.goalradius = 16;
	doorblocker_node = getnode( "door_blocker_node", "targetname" );
	doorblocker setGoalNode( doorblocker_node );
	doorblocker thread doorblocker_anim_on_trigger( doorblocker_node );
	doorblocker.script_noteworthy = "doorblocker";
	
	level.price set_force_color( "o" );
	level.price.goalradius = 16;
	level.price setGoalNode( getnode( "price_last_node", "targetname" ) );
	
	level.price waittill( "goal" );
	flag_set( "price_at_spotter" );
}

doorblocker_anim_on_trigger( node )
{
	assert( isdefined( node ) );
	
	trigger = getent( "door_block_trigger", "targetname" );
	assert( isdefined( trigger ) );
	trigger waittill( "trigger" );
	
	self.animname = "guard";
	node anim_reach_solo( self, "stop" );
	node anim_single_solo( self, "stop" );
	
	getent( "last_color_order_trigger2", "targetname" ) notify( "trigger" );
	
	flag_set( "ok_to_do_spotting" );
}

t72_in_final_position()
{
	level.t72 = maps\_vehicle::waittill_vehiclespawn( "t72" );
	assert( isdefined( level.t72 ) );
	level.t72 waittill( "reached_end_node" );
	flag_set( "t72_in_final_position" );
	
	level.t72 endon( "exploding" );
	
	exploder_300_target = getent( "exploder_300_target", "targetname" );
	level.t72 setTurretTargetEnt( exploder_300_target );
	level.t72 waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	level.t72 clearTurretTarget();
	level.t72 notify( "turret_fire" );
	exploder( 300 );
	
	wait 2.0;
	aim_location = getent( "t72_aim_at_final_building_location", "targetname" );
	level.t72 setTurretTargetEnt( aim_location );
	level.t72 waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	level.t72 clearTurretTarget();
}

vehicle_path_disconnector()
{
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	zone notsolid();
	zone.origin -= ( 0, 0, 1024 );
	badplaceName = "tank_bad_place_brush_" + zone getEntityNumber();
	
	for(;;)
	{
		self waittill( "trigger", tank );
		
		assert( isdefined( tank ) );
		assert( isdefined( level.abrams ) );
		prof_begin( "tank_path_disconnect" );
		if ( tank getSpeedMPH() == 0 )
		{
			prof_end( "tank_path_disconnect" );
			continue;
		}
		prof_end( "tank_path_disconnect" );
		
		if ( !isdefined( zone.pathsDisconnected ) )
		{
			zone solid();
			
			if ( tank == level.abrams )
				badplace_brush( badplaceName, 0, zone, "allies" );
			else if ( ( isdefined( level.t72 ) ) && ( tank == level.t72 ) )
				badplace_brush( badplaceName, 0, zone, "allies", "axis" );
			else
			{
				assertMsg( "entity " + self getEntityNumber() + " tank path disconnect trigger at " + self.origin + " was hit by something other than the abrams or t72!" );
				continue;
			}
			
			zone notsolid();
			zone.pathsDisconnected = true;
		}
		
		thread vehicle_reconnects_paths( zone, badplaceName );
	}
}

vehicle_reconnects_paths( zone, badplaceName )
{
	assert( isdefined( zone ) );
	assert( isdefined( badplaceName ) );
	zone notify( "waiting_for_path_reconnection" );
	zone endon( "waiting_for_path_reconnection" );
	wait 0.5;
	
	zone solid();
	badplace_delete( badplaceName );
	zone notsolid();
	zone.pathsDisconnected = undefined;
}

playerInit()
{	
    level.player DisableWeapons();
	flag_wait( "pullup_weapon" );
    level.player EnableWeapons();
	level.player switchToWeapon( "m4_grenadier" );
}

delete_ai_in_zone()
{
	assert( isdefined( self.target ) );
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	
	self waittill( "trigger" );
	
	axis = getaiarray( "axis" );
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( axis[ i ] isTouching( zone ) )
			axis[ i ] delete();
	}
}

delete_all_axis()
{
	self waittill( "trigger" );
	// delete all axis
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
}

autosave_when_trigger_cleared()
{
	assert( isdefined( self.script_noteworthy ) );
	for(;;)
	{
		self waittill( "trigger" );
		if( !ai_touching_area( self ) )
			break;
		wait 3;
	}
	thread dosavegame( self.script_noteworthy );
}

dosavegame( savename )
{
	if ( isdefined( level.lastSaveTime ) )
	{
		if ( level.lastSaveTime + 10000 > getTime() )
		{
			println( "aborting autosave because an autosave just happened" );
			return;
		}
	}
	
	level.lastSaveTime = getTime();
	
	autosave_by_name( savename );
}

waittill_zone_clear( sTargetname )
{
	assert( isdefined( sTargetname ) );
	zone = getent( sTargetname, "targetname" );
	assert( isdefined( zone ) );
	
	while( ai_touching_area( zone ) )
	{
		wait 2;
	}
}

ai_touching_area( zone )
{
	assert( isdefined( zone ) );
	axis = getaiarray( "axis" );
	for( i = 0 ; i < axis.size ; i++ )
	{
		if( axis[ i ] isTouching( zone ) )
			return true;
	}
	return false;
}

tank_advancement_bog()
{
	//--------------
	// Bog Area
	//--------------
	
	flag_init( "truck_crush_tank_in_position" );
	thread truck_crush_tank_in_position();
	
	// puts the tank turret forward when it hits a trigger just before the tank crush sequence
	level.abrams thread tank_turret_forward();
	
	// abrams shoots at enemies in the bog
	level.abrams thread attack_troops();
	
	// wait till the tank is in tank crush position
	flag_wait( "truck_crush_tank_in_position" );
	
	// wait until the player hits the tank crush trigger
	flag_wait( "truck_crush_player_in_position" );
	
	thread dosavegame( "tank_crush" );
	
	truck = getent( "crunch_truck_1", "targetname" );
	
	// player and tank in position, wait to see if player is looking at the tank
	// if player doesn't look at tank soon then timeout and do the sequence anyways
	timeoutTime = 10;
	for( i = 0 ; i < timeoutTime * 20 ; i++ )
	{
		if ( within_fov( level.player getEye(), level.player getPlayerAngles(), truck.origin, level.cosine[ "65" ] ) )
			break;
		wait 0.05;
	}
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	level.abrams resumeSpeed( 5 );
	//getent( "truck_clip_before", "targetname" ) delete();
	level.abrams maps\_vehicle::tank_crush( truck,
											tank_path_2,
											level.scr_anim[ "tank" ][ "tank_crush" ],
											level.scr_anim[ "truck" ][ "tank_crush" ],
											level.scr_animtree[ "tank_crush" ],
											level.scr_sound[ "tank_crush" ] );
	
	thread tank_advancement_arch();
}

tank_advancement_arch()
{
	//--------------
	// Archway Road
	//--------------
	
	// price warns about guys on rooftops
	level.price thread anim_single_solo( level.price, "watchrooftops" );
	
	// tank moves up path and stops at it's stop node where it will shoot exploder group 0
	node = getvehiclenode( "stop_for_city_fight1", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank says possible ambush positions up ahead
	level.abrams thread ambush_ahead_dialog();
	
	// tank in position, shoot exploder group 0
	level.abrams thread shoot_buildings( 0 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// abrams shoots at enemies until it's clear to move up
	level.abrams thread attack_troops();
	waittill_zone_clear( "tank_zone_1" );
	
	// tank and price talk about it being clear to move up a bit
	battlechatter_off( "allies" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "movingup" ] );
	wait 0.1;
	level.price.animname = "price";
	level.price thread anim_single_solo( level.price, "roger" );
	battlechatter_on( "allies" );
	
	// tank moves up a bit and stops to shoot at exploder group 1
	level.abrams resumeSpeed( 3 );
	node = getvehiclenode( "stop_for_city_fight2", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank in position, shoot exploder group 1
	level.abrams thread shoot_buildings( 1 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// abrams shoots at enemies until it's clear to move up again
	level.abrams thread attack_troops();
	waittill_zone_clear( "tank_zone_2" );
	
	// tank tells price it's moving up to the corner
	thread dosavegame( "tank_progress_corner" );
	battlechatter_off( "allies" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "cleartoadvance" ] );
	wait 0.1;
	level.price.animname = "price";
	level.price anim_single_solo( level.price, "rogermoveup" );
	wait 0.1;
	level.player thread playRadioSound( level.scr_sound[ "tank_commander" ][ "rogermoving" ] );
	battlechatter_on( "allies" );
	
	// tank moves up to corner and stops to shoot at exploder group 2
	level.abrams resumeSpeed( 3 );
	node = getvehiclenode( "stop_for_city_fight3", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank in position, shoot exploder group 2
	level.abrams thread shoot_buildings( 2 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// shoot at enemies with the MG now
	level.abrams thread attack_troops();
	
	thread tank_advancement_alley();
}

tank_advancement_alley()
{
	flag_wait( "abrams_move_shoot_t72" );
	thread abrams_setup_t72();
	
	/*
	advancementTrigger = getent( "tank_advance_to_corner", "targetname" );
	advancementTrigger waittill( "trigger" );
	
	advancementTrigger = getent( "tank_advance_to_end", "targetname" );
	advancementTrigger waittill( "trigger" );
	*/
	
	
	flag_wait( "abrams_advance_to_end_level" );
	
	crushNode = getvehiclenode( "tank_crush_truck2", "script_noteworthy" );
	crunch_truck_2 = getent( "crunch_truck_2", "targetname" );
	tank_path_4 = getVehicleNode( "tank_path_4", "targetname" );
	
	level.abrams setturrettargetent( level.abrams.forwardEnt );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	level.abrams clearTurretTarget();
	
	level.abrams resumeSpeed( 3 );
	level.abrams setWaitNode( crushNode );
	level.abrams waittill( "reached_wait_node" );
	level.abrams maps\_vehicle::tank_crush( crunch_truck_2,
													tank_path_4,
													level.scr_anim[ "tank" ][ "tank_crush" ],
													level.scr_anim[ "truck" ][ "tank_crush" ],
													level.scr_animtree[ "tank_crush" ],
													level.scr_sound[ "tank_crush2" ] );
	level.abrams resumeSpeed( 3 );
	level.abrams setturrettargetent( getent( "final_abrams_aim_spot", "targetname" ) );
	wait 7;
	level.abrams clearTurretTarget();
	wait 3;
	level.abrams setturrettargetent( getent( "final_abrams_aim_spot", "targetname" ) );
	wait 3;
	level.abrams clearTurretTarget();
}

seaknight()
{
	seaknight_path = getent( "seaknight_path", "targetname" );
	seaknight_land_location = getent( "seaknight_land_location", "script_noteworthy" );
	
	objective_state( 1, "done" );
	wait 1.0;
	objective_add( 2, "current", &"BOG_B_OBJ_SEAKNIGHT", seaknight_land_location.origin );
	
	// disconnect nodes where tank is driving
	clip = getent( "final_alley_path_disconnector", "targetname" );
	clip.origin -= ( 0, 0, 512 );
	clip disconnectpaths();
	
	// make friends go to seaknight
	friends = getaiarray( "allies" );
	for ( i = 0 ; i < friends.size ; i++ )
		friends[ i ] set_force_color( "c" );
	getent( "seaknight_friendly_trigger", "targetname" ) notify( "trigger" );
	
	// spawn the helicopter
	level.seaknight = maps\_vehicle::spawn_vehicle_from_targetname_and_drive( "seaknight" );
	assert( isdefined( level.seaknight ) );
	
	wait 0.05;
	
	// make riders only crouch so their anims look good when they unload
	seaknightRiders = level.seaknight.riders;
	assert( seaknightRiders.size == 5 );
	for ( i = 0 ; i < seaknightRiders.size ; i++ )
		seaknightRiders[ i ] thread seaknightRiders_standInPlace();
	
	seaknight_land_location waittill( "trigger", helicopter );
	
	helicopter.dontDisconnectPaths = true;
	helicopter vehicle_detachfrompath();
	helicopter vehicle_land();
	helicopter setHoverParams( 0, 0, 0 );
	wait 3.0;
	
	helicopter notify( "unload" );
	
	getent( "player_in_seaknight", "targetname" ) waittill( "trigger" );
	
	helicopter notify( "load", seaknightRiders );
	
	wait 5.0;
	
	missionsuccess( "airlift", false );
}

seaknightRiders_standInPlace()
{
	if ( !isAI( self ) )
		return;
	self allowedStances( "crouch" );
	self waittill( "jumpedout" );
	self allowedStances( "crouch" );
	waittillframeend;
	self allowedStances( "crouch" );
	self.goalradius = 16;
	self setGoalPos( self.origin );
	self.ignoreall = true;
}

bog_enemies_retreat()
{
	getent( "bog_enemies_retreat", "targetname" ) waittill( "trigger" );
	
	axis = getaiarray( "axis" );
	nodes = getnodearray( "bog_enemies_retreat_node", "targetname" );
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( !isdefined( axis[ i ] ) )
			continue;
		if ( !isalive( axis[ i ] ) )
			continue;
		goalnode = nodes[ randomint( nodes.size ) ];
		axis[ i ] thread go_to_node_delayed( goalnode, goalnode.radius, randomfloat( 5.0 ) );
	}
}

go_to_node_delayed( node, goalradius, fDelay )
{
	wait fDelay;
	
	if ( !isdefined( self ) )
		return;
	if ( !isalive( self ) )
		return;
	
	self.goalradius = goalradius;
	self setGoalNode( node );
}