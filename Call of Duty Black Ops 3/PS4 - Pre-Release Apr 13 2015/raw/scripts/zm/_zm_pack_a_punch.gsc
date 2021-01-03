#using scripts\codescripts\struct;

#using scripts\shared\aat_shared;
#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\system_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_util;
#using scripts\zm\_zm;
#using scripts\zm\_zm_audio;
#using scripts\zm\_zm_buildables;
#using scripts\zm\_zm_equipment;
#using scripts\zm\_zm_laststand;
#using scripts\zm\_zm_magicbox;
#using scripts\zm\_zm_pers_upgrades_functions;
#using scripts\zm\_zm_pack_a_punch_util;
#using scripts\zm\_zm_power;
#using scripts\zm\_zm_score;
#using scripts\zm\_zm_stats;
#using scripts\zm\_zm_utility;
#using scripts\zm\_zm_weapons;

                                                                                       	                                
                                                                                                                               

#precache( "string", "ZOMBIE_PERK_PACKAPUNCH" );
#precache( "string", "ZOMBIE_PERK_PACKAPUNCH_ATT" );
#precache( "fx", "zombie/fx_packapunch_zmb" );





function autoexec __init__sytem__() {     system::register("zm_pack_a_punch",&__init__,&__main__,undefined);    }
	
function __init__()
{
	level._effect["packapunch_fx"] = "zombie/fx_packapunch_zmb";
	zm_pap_util::init_parameters();
}

function __main__()
{
	// Spawn models, triggers, clip, etc.
	spawn_init();
	
	vending_weapon_upgrade_trigger = zm_pap_util::get_triggers();
	
	if ( vending_weapon_upgrade_trigger.size >= 1 )
	{
		array::thread_all( vending_weapon_upgrade_trigger, &vending_weapon_upgrade );
	}
	
	// Add old style pack machines if necessary.
	old_packs = GetEntArray( "zombie_vending_upgrade", "targetname" );
	for( i = 0; i < old_packs.size; i++ )
	{
		vending_weapon_upgrade_trigger[vending_weapon_upgrade_trigger.size] = old_packs[i];
	}
	level flag::init("pack_machine_in_use");
	
	if ( IsDefined( level.pack_a_punch.custom_power_think ) )
    {
		level thread [[level.pack_a_punch.custom_power_think]]();
    }
	else
	{
		level thread toggle_think();
	}
}

function private spawn_init()
{
	structs = struct::get_array("zm_pack_a_punch", "targetname");
	
	for ( i = 0; i < structs.size; i++ )
	{
		struct = structs[i].script_noteworthy;
		if(IsDefined(struct) && IsDefined(structs[i].model))
		{
			// Create the use trigger.
			use_trigger = Spawn( "trigger_radius_use", structs[i].origin + (0, 0, 30), 0, 40, 70 );
			use_trigger.script_noteworthy = "pack_a_punch";
			use_trigger TriggerIgnoreTeam();
	
			// Create the model.
			pap_machine = Spawn("script_model", structs[i].origin);
			if( !isdefined(structs[i].angles) )
				structs[i].angles = (0,0,0);
			pap_machine.angles = structs[i].angles;
			pap_machine SetModel(structs[i].model);
				
			// Create the collision model.
			collision = Spawn("script_model", structs[i].origin, 1);
			collision.angles = structs[i].angles;
			collision SetModel("zm_collision_perks1");
			collision.script_noteworthy = "clip";
			collision DisconnectPaths();
			
			// Connect all of the pieces for easy access.
			use_trigger.clip = collision;
			use_trigger.machine = pap_machine;
			
			// Copy over parameters.
			if( IsDefined( structs[i].blocker_model ) )
				use_trigger.blocker_model = structs[i].blocker_model;
			
			if( IsDefined( structs[i].script_int ) )
				pap_machine.script_int = structs[i].script_int;
			
			if( IsDefined( structs[i].turn_on_notify ) )
				pap_machine.turn_on_notify = structs[i].turn_on_notify;
			
			// Set up sounds
			use_trigger.script_sound = "mus_perks_packa_jingle";
			use_trigger.script_label = "mus_perks_packa_sting";
			use_trigger.longJingleWait = true;
			
			// Connect the trigger to the machine.
			use_trigger.target = "vending_packapunch";
			pap_machine.targetname = "vending_packapunch";
			
			// Set up the flag.
			flag_pos = struct::get(structs[i].target, "targetname");
			if(IsDefined(flag_pos))
			{
				pap_machine_flag = Spawn("script_model", flag_pos.origin);
				pap_machine_flag.angles = flag_pos.angles;
				pap_machine_flag SetModel(flag_pos.model);			
				pap_machine_flag.targetname = "pack_flag";
				pap_machine.target = "pack_flag";
			}
			
			// Set up power interactions.
			powered_on = get_start_state();
			use_trigger.powered = zm_power::add_powered_item( &turn_on, &turn_off, &get_range, &cost_func, 0, powered_on, use_trigger );
			
			if ( !isdefined( level.pack_a_punch.triggers ) ) level.pack_a_punch.triggers = []; else if ( !IsArray( level.pack_a_punch.triggers ) ) level.pack_a_punch.triggers = array( level.pack_a_punch.triggers ); level.pack_a_punch.triggers[level.pack_a_punch.triggers.size]=use_trigger;;
		}
	}
}

function private fx_ent_failsafe()
{
	wait( 25 );
	self delete();
}

function private third_person_weapon_upgrade( current_weapon, upgrade_weapon, packa_rollers, pap_machine, trigger )
{
	level endon("Pack_A_Punch_off");

	trigger endon("pap_player_disconnected");
	
	rel_entity = trigger.pap_machine;
	
	origin_offset = (0,0,0);
	angles_offset = (0,0,0);
	origin_base = self.origin;
	angles_base = self.angles;
	
	if( isDefined(rel_entity) )
	{
		origin_offset = (0, 0, level.pack_a_punch.interaction_height);
		angles_offset = (0, 90, 0);
		
		origin_base = rel_entity.origin;
		angles_base = rel_entity.angles;
	}
	else
	{
		rel_entity = self;
	}
	forward = anglesToForward( angles_base+angles_offset );
	interact_offset = origin_offset+(forward*-25);
	
	if( !IsDefined( pap_machine.fx_ent ) )
	{
		pap_machine.fx_ent = Spawn( "script_model", origin_base+origin_offset+(0,1,-34) );
		pap_machine.fx_ent.angles = angles_base+angles_offset;
		pap_machine.fx_ent SetModel( "tag_origin" );	
		
		pap_machine.fx_ent Linkto( pap_machine );
	}

	if( IsDefined( level._effect["packapunch_fx"] ) )
	{
		fx = PlayFxOnTag( level._effect["packapunch_fx"], pap_machine.fx_ent, "tag_origin" );
		//PlayFx( level._effect["packapunch_fx"], origin_base+origin_offset+(0,1,-34), forward );
	}

	offsetdw = ( 3, 3, 3 );
	
	weoptions = self zm_weapons::get_pack_a_punch_weapon_options( current_weapon );	
	
	trigger.worldgun = zm_utility::spawn_weapon_model( current_weapon, undefined, origin_base+interact_offset, self.angles, weoptions); 
	
	worldgundw = undefined;
	if ( current_weapon.isDualWield )
	{
		worldgundw = zm_utility::spawn_weapon_model( current_weapon, zm_magicbox::get_left_hand_weapon_model_name( current_weapon ), origin_base+interact_offset+offsetdw, self.angles, weoptions); 
	}
	trigger.worldgun.worldgundw = worldgundw;
	
	pap_machine [[ level.pack_a_punch.move_in_func ]]( trigger, origin_offset, angles_offset );
	
	self playsound( "zmb_perks_packa_upgrade" );
	if( isDefined( pap_machine.wait_flag ) )
	{
		pap_machine.wait_flag rotateto( pap_machine.wait_flag.angles+(179, 0, 0), 0.25, 0, 0 );
	}
	wait( 0.35 );

	trigger.worldgun delete();
	if ( isdefined( worldgundw ) )
	{
		worldgundw delete();
	}

	wait( 3 );

	if ( IsDefined( self ) )
	{
		self playsound( "zmb_perks_packa_ready" );
	}
	else
	{
		return;		// player disconnected.  Get gone.
	}

	upoptions = self zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon );

	trigger.current_weapon = current_weapon;
	trigger.upgrade_weapon = upgrade_weapon;

	trigger.worldgun = zm_utility::spawn_weapon_model( upgrade_weapon, undefined, origin_base+origin_offset, angles_base+angles_offset+(0,90,0), upoptions); 
	worldgundw = undefined;
	if ( upgrade_weapon.isDualWield )
	{
		worldgundw = zm_utility::spawn_weapon_model( upgrade_weapon, zm_magicbox::get_left_hand_weapon_model_name( upgrade_weapon ), origin_base+origin_offset+offsetdw, angles_base+angles_offset+(0,90,0), upoptions);
	}
	trigger.worldgun.worldgundw = worldgundw;

	if( isDefined( pap_machine.wait_flag ) )
	{
		pap_machine.wait_flag rotateto( pap_machine.wait_flag.angles-(179, 0, 0), 0.25, 0, 0 );
	}
	
	rel_entity thread [[ level.pack_a_punch.move_out_func ]]( trigger, origin_offset, interact_offset );
	
	return trigger.worldgun;
}


function private can_pack_weapon( weapon )
{
	if ( level.weaponRiotshield == weapon )
	{
		return false;
	}

	if ( level flag::get("pack_machine_in_use") )
	{
		return true;
	}

	weapon = self zm_weapons::get_nonalternate_weapon( weapon );
	if ( !zm_weapons::is_weapon_or_base_included( weapon ) )
	{
		return false;
	}

	if ( !self zm_weapons::can_upgrade_weapon( weapon ) )
	{
		return false;
	}

	return true;
}

function private player_use_can_pack_now()
{
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) || self isThrowingGrenade() )
	{
		return false;
	}

	if( !self zm_magicbox::can_buy_weapon() )
	{
		return false;
	}

	if( self zm_equipment::hacker_active() )
	{
		return false;
	}

	if ( !self can_pack_weapon( self GetCurrentWeapon() ) )
	{
		return false;
	}

	return true;
}

function private pack_a_punch_machine_trigger_think()
{
	self endon("death");
	self endon("Pack_A_Punch_off");
	
	while(1)
	{
		players = GetPlayers();
		
		for(i = 0; i < players.size; i ++)
		{
			if ( ( IsDefined( self.pack_player ) && self.pack_player != players[i] ) ||
			     !players[i] player_use_can_pack_now() )
			{
				self SetInvisibleToPlayer( players[i], true );
			}
			else
			{
				self SetInvisibleToPlayer( players[i], false );
			}		
		}
		wait(0.1);
	}
}

//
//	Pack-A-Punch Weapon Upgrade
//
function private vending_weapon_upgrade()
{
	level endon("Pack_A_Punch_off");

	// TODO: This hack allows the thread to start after the gametype init has had a chance to run (needed to set up the buildables) 
	wait 0.01;	
	
	pap_machine = GetEnt( self.target, "targetname" );
	self.pap_machine = pap_machine;
	pap_machine_sound = GetEntarray ( "perksacola", "targetname");
	packa_rollers = spawn("script_origin", self.origin);
	packa_timer = spawn("script_origin", self.origin);
	packa_rollers LinkTo( self );
	packa_timer LinkTo( self );
	
	if( isDefined( pap_machine.target ) )
	{
		pap_machine.wait_flag = GetEnt( pap_machine.target, "targetname" );
	}

	//DCS TO DO: pap_is_buildable = self zm_buildables::is_buildable();
	pap_is_buildable = false;		
	if ( pap_is_buildable )
	{
		self TriggerEnable( false );
		pap_machine Hide();
		
		if ( IsDefined( pap_machine.wait_flag ) )
		{
			pap_machine.wait_flag Hide();
		}
		
		zm_buildables::wait_for_buildable( "pap" );

		//build_trig = GetEnt( "pap_buildable_trigger", "targetname" );
		//playerWhoBuilt = build_trig zm_buildables::buildable_think( "pap" ); // Waits for it to be built
		
		self TriggerEnable( true );
		pap_machine Show();
		
		if ( IsDefined( pap_machine.wait_flag ) )
		{
			pap_machine.wait_flag Show();
		}
		
		//build_trig Delete();
	}

	self UseTriggerRequireLookAt();
	self SetHintString( &"ZOMBIE_NEED_POWER" );
	self SetCursorHint( "HINT_NOICON" );
	
	power_off = !self is_on();

	if ( power_off )
	{
		pap_array = [];
		pap_array[0] = pap_machine;
		level waittill("Pack_A_Punch_on");
	}
	
	self TriggerEnable( true );
	
	if( IsDefined( level.pack_a_punch.power_on_callback ) )
	{
		pap_machine thread [[ level.pack_a_punch.power_on_callback ]]();
	}
	
	self thread pack_a_punch_machine_trigger_think();
	
	//self thread zm_magicbox::decide_hide_show_hint("Pack_A_Punch_off");
	
	pap_machine playloopsound("zmb_perks_packa_loop");
	self thread shutOffPAPSounds( pap_machine, packa_rollers, packa_timer );

	self thread vending_weapon_upgrade_cost();
	
	for( ;; )
	{
		self.pack_player = undefined;
		
		self waittill( "trigger", player );		
				
		index = zm_weapons::get_player_index(player);	

		current_weapon = player getCurrentWeapon();

		current_weapon = player zm_weapons::switch_from_alt_weapon( current_weapon );
		
		if( IsDefined( level.pack_a_punch.custom_validation ) )
 		{
 			valid = self [[ level.pack_a_punch.custom_validation ]]( player );
 			if( !valid )
 			{
 				continue;
 			}
 		}
		
		if( !player zm_magicbox::can_buy_weapon() ||
			player laststand::player_is_in_laststand() ||
			( isdefined( player.intermission ) && player.intermission ) ||
			player isThrowingGrenade() ||
			!player zm_weapons::can_upgrade_weapon( current_weapon ) )
		{
			wait( 0.1 );
			continue;
		}

 		if( player isSwitchingWeapons() )
 		{		
			wait( 0.1 );
	 		if( player isSwitchingWeapons() )
	 			continue;
 		}

 		if ( !zm_weapons::is_weapon_or_base_included( current_weapon ) )
 		{
			continue;
 		}

 		current_cost = self.cost;
 		player.restore_ammo = undefined;
 		player.restore_clip = undefined;
 		player.restore_stock = undefined;
		player_restore_clip_size = undefined;
 		player.restore_max = undefined; 
 		
 		upgrade_as_attachment = zm_weapons::will_upgrade_weapon_as_attachment( current_weapon );
 		if (upgrade_as_attachment)
 		{
	 		current_cost = self.attachment_cost;
	 		player.restore_ammo = true;
	 		player.restore_clip = player GetWeaponAmmoClip( current_weapon );
	 		player.restore_clip_size = current_weapon.clipSize;
	 		player.restore_stock = player Getweaponammostock( current_weapon );
	 		player.restore_max = current_weapon.maxAmmo;
 		}

		// If the persistent upgrade "double_points" is active, the cost is halved
		if( player zm_pers_upgrades_functions::is_pers_double_points_active() )
		{
			current_cost = player zm_pers_upgrades_functions::pers_upgrade_double_points_cost( current_cost );
		}
				
		if( player.score < current_cost )
		{
			self playsound("deny");
			if(isDefined(level.pack_a_punch.custom_deny_func))
			{
				player [[level.pack_a_punch.custom_deny_func]]();
			}
			else
			{
				player zm_audio::create_and_play_dialog( "general", "outofmoney", 0 );
			}
			continue;
		}
		
		self.pack_player = player;
		level flag::set("pack_machine_in_use");
		
		demo::bookmark( "zm_player_use_packapunch", gettime(), player );

		//stat tracking
		player zm_stats::increment_client_stat( "use_pap" );
		player zm_stats::increment_player_stat( "use_pap" );
		
		self thread destroy_weapon_in_blackout(player);
		self thread destroy_weapon_on_disconnect( player );

		player zm_score::minus_to_player_score( current_cost, true ); 
		sound = "evt_bottle_dispense";
		playsoundatposition(sound, self.origin);
		
		self thread zm_audio::sndPerksJingles_Player(1);
		player zm_audio::create_and_play_dialog( "general", "pap_wait" );
		
		self TriggerEnable( false );
		
		player thread do_knuckle_crack();

		// Remember what weapon we have.  This is needed to check unique weapon counts.
		self.current_weapon = current_weapon;
		
		upgrade_weapon = zm_weapons::get_upgrade_weapon( current_weapon, upgrade_as_attachment );
											
		player third_person_weapon_upgrade( current_weapon, upgrade_weapon, packa_rollers, pap_machine, self );
		
		self TriggerEnable( true );
		self SetCursorHint("HINT_WEAPON", upgrade_weapon);
		self SetHintString( &"ZOMBIE_GET_UPGRADED_FILL" );
		if ( IsDefined( player ) )
		{
			self setinvisibletoall();
			self setvisibletoplayer( player );
		
			self thread wait_for_player_to_take( player, current_weapon, packa_timer, upgrade_as_attachment );
		}
		self thread wait_for_timeout( current_weapon, packa_timer,player );
		
		self util::waittill_any( "pap_timeout", "pap_taken", "pap_player_disconnected" );

		self.current_weapon = level.weaponNone;
		if ( isdefined(self.worldgun) && isdefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		if(isdefined(self.worldgun))
		{
			self.worldgun delete();
		}
		
		self SetCursorHint("HINT_NOICON");
		self zm_pap_util::update_hint_string();
		self setvisibletoall();

		self.pack_player = undefined;
		level flag::clear("pack_machine_in_use");

	}
}

function private shutOffPAPSounds( ent1, ent2, ent3 )
{
	while(1)
	{
		level waittill( "Pack_A_Punch_off" );
		level thread turnOnPAPSounds( ent1 );
		ent1 stoploopsound( .1 );
		ent2 stoploopsound( .1 );
		ent3 stoploopsound( .1 );
	}
}

function private turnOnPAPSounds( ent )
{
	level waittill( "Pack_A_Punch_on" );
	ent playloopsound( "zmb_perks_packa_loop" );
}

function private vending_weapon_upgrade_cost()
{
	level endon("Pack_A_Punch_off");
	while ( 1 )
	{
		self.cost = 5000;
		self.attachment_cost = 2000;
		self zm_pap_util::update_hint_string();

		level waittill( "powerup bonfire sale" );

		self.cost = 1000;
		self.attachment_cost = 1000;
		self zm_pap_util::update_hint_string();

		level waittill( "bonfire_sale_off" );
	}
}


//	
//
function private wait_for_player_to_take( player, weapon, packa_timer, upgrade_as_attachment )
{
	current_weapon = self.current_weapon;
	upgrade_weapon = self.upgrade_weapon;
	Assert( IsDefined( current_weapon ), "wait_for_player_to_take: weapon does not exist" );
	Assert( IsDefined( upgrade_weapon ), "wait_for_player_to_take: upgrade_weapon does not exist" );

	self endon( "pap_timeout" );
	level endon( "Pack_A_Punch_off" );
	while( true )
	{
		packa_timer playloopsound( "zmb_perks_packa_ticktock" );
		self waittill( "trigger", trigger_player );
		if ( level.pack_a_punch.grabbable_by_anyone )
		{
			player = trigger_player;
		}
		
		packa_timer stoploopsound(.05);
		if( trigger_player == player ) 
		{

			player zm_stats::increment_client_stat( "pap_weapon_grabbed" );
			player zm_stats::increment_player_stat( "pap_weapon_grabbed" );

			current_weapon = player GetCurrentWeapon();
/#
if ( level.weaponNone == current_weapon )
{
	iprintlnbold( "WEAPON IS NONE, PACKAPUNCH RETRIEVAL DENIED" );
}
#/
			if( zm_utility::is_player_valid( player ) && !( player.is_drinking > 0 ) && !zm_utility::is_placeable_mine( current_weapon )  && !zm_equipment::is_equipment( current_weapon ) && level.weaponReviveTool != current_weapon && level.weaponNone!= current_weapon  && !player zm_equipment::hacker_active())
			{
				demo::bookmark( "zm_player_grabbed_packapunch", gettime(), player );

				self notify( "pap_taken" );
				player notify( "pap_taken" );
				player.pap_used = true;

				weapon_limit = zm_utility::get_player_weapon_limit( player );

				player zm_weapons::take_fallback_weapon();

				primaries = player GetWeaponsListPrimaries();
				if( isDefined( primaries ) && primaries.size >= weapon_limit )
				{
					player zm_weapons::weapon_give( upgrade_weapon );
				}
				else
				{
					player GiveWeapon( upgrade_weapon, player zm_weapons::get_pack_a_punch_weapon_options( upgrade_weapon ) );
					player GiveStartAmmo( upgrade_weapon );
				}

				if ( ( isdefined( level.aat_in_use ) && level.aat_in_use ) )
				{
					player thread aat::acquire( upgrade_weapon );
				}

				player SwitchToWeapon( upgrade_weapon );

				if (( isdefined( player.restore_ammo ) && player.restore_ammo ))
				{
					new_clip = player.restore_clip + ( upgrade_weapon.clipSize - player.restore_clip_size );
					new_stock = player.restore_stock + ( upgrade_weapon.maxAmmo - player.restore_max );
					player SetWeaponAmmoStock( upgrade_weapon, new_stock );
					player SetWeaponAmmoClip( upgrade_weapon, new_clip );
				}
		 		player.restore_ammo = undefined;
		 		player.restore_clip = undefined;
		 		player.restore_stock = undefined;
 				player.restore_max = undefined;
		 		player.restore_clip_size = undefined;
		 		
				player zm_weapons::play_weapon_vo(upgrade_weapon);
				return;
			}
		}
		{wait(.05);};
	}
}


//	Waiting for the weapon to be taken
//
function private wait_for_timeout( weapon, packa_timer,player )
{
	self endon( "pap_taken" );
	self endon( "pap_player_disconnected" );
	
	self thread wait_for_disconnect( player );
	
	wait( level.pack_a_punch.timeout );
	
	self notify( "pap_timeout" );
	packa_timer stoploopsound(.05);
	packa_timer playsound( "zmb_perks_packa_deny" );

	//stat tracking
	if(isDefined(player))
	{
		player zm_stats::increment_client_stat( "pap_weapon_not_grabbed" );
		player zm_stats::increment_player_stat( "pap_weapon_not_grabbed" );
	}
}

function private wait_for_disconnect( player )
{
	self endon( "pap_taken" );
	self endon( "pap_timeout" );
	
	while(isdefined(player))
	{
		wait(0.1);
	}
	
	/#	println("*** PAP : User disconnected."); #/
	
	self notify( "pap_player_disconnected" );
}

function private destroy_weapon_on_disconnect( player )
{
	self endon( "pap_timeout" );
	self endon( "pap_taken" );
	level endon( "Pack_A_Punch_off" );
	
	player waittill("disconnect");
	
	if ( isdefined( self.worldgun ) )
	{
		if ( isdefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		self.worldgun delete();
	}
}

function private destroy_weapon_in_blackout( player )
{		
	self endon( "pap_timeout" );
	self endon( "pap_taken" );
	self endon ("pap_player_disconnected" );

	level waittill("Pack_A_Punch_off");

	if ( isdefined( self.worldgun ) )
	{
		self.worldgun rotateto( self.worldgun.angles+(randomint(90)-45,0,randomint(360)-180), 1.5, 0, 0 );
		
		player playlocalsound( level.zmb_laugh_alias );	

		wait( 1.5 );

		if ( isdefined( self.worldgun.worldgundw ) )
		{
			self.worldgun.worldgundw delete();
		}
		self.worldgun delete();
	}

}



//	Weapon has been inserted, crack knuckles while waiting
//
function private do_knuckle_crack()
{
	self endon("disconnect");
	self upgrade_knuckle_crack_begin();
	
	self util::waittill_any( "fake_death", "death", "player_downed", "weapon_change_complete" );
	
	self upgrade_knuckle_crack_end();
	
}


//	Switch to the knuckles
//
function private upgrade_knuckle_crack_begin()
{
	self zm_utility::increment_is_drinking();
	
	self zm_utility::disable_player_move_states(true);

	primaries = self GetWeaponsListPrimaries();

	original_weapon = self GetCurrentWeapon();
	weapon = GetWeapon( "zombie_knuckle_crack" );
	
	if ( original_weapon != level.weaponNone && !zm_utility::is_placeable_mine( original_weapon ) && !zm_equipment::is_equipment( original_weapon ) )
	{
		self notify( "zmb_lost_knife" );
		self TakeWeapon( original_weapon );
	}
	else
	{
		return;
	}

	self GiveWeapon( weapon );
	self SwitchToWeapon( weapon );
}

//	Anim has ended, now switch back to something
//
function private upgrade_knuckle_crack_end()
{
	self zm_utility::enable_player_move_states();
	
	weapon = GetWeapon( "zombie_knuckle_crack" );

	// TODO: race condition?
	if ( self laststand::player_is_in_laststand() || ( isdefined( self.intermission ) && self.intermission ) )
	{
		self TakeWeapon(weapon);
		return;
	}

	self zm_utility::decrement_is_drinking();

	self TakeWeapon(weapon);
	primaries = self GetWeaponsListPrimaries();
	if( ( self.is_drinking > 0 ) )
	{
		return;
	}
	else if( isDefined( primaries ) && primaries.size > 0 )
	{
		self SwitchToWeapon( primaries[0] );
	}
	else if ( self HasWeapon( level.laststandpistol ) )
	{
		self SwitchToWeapon( level.laststandpistol );
	}
	else
	{
		self zm_weapons::give_fallback_weapon();
	}
}

function private get_range( delta, origin, radius )
{
	if (IsDefined(self.target))
	{
		paporigin = self.target.origin; 
		if( ( isdefined( self.target.trigger_off ) && self.target.trigger_off ) )
			paporigin = self.target.realorigin;
		else if( ( isdefined( self.target.disabled ) && self.target.disabled ) )
			paporigin = paporigin + ( 0, 0, 10000 );
	
		if ( DistanceSquared( paporigin, origin ) < radius * radius )
			return true;
	}
	return false;
}

function private turn_on( origin, radius )
{
	/#	println( "^1ZM POWER: PaP on\n" );	#/
	level notify( "Pack_A_Punch_on" );
}

function private turn_off( origin, radius )
{
	/#	println( "^1ZM POWER: PaP off\n" );	#/

	// NOTE: This will cause problems if there is more than one pack-a-punch machine in the level
	level notify( "Pack_A_Punch_off" );
	self.target notify( "death" );
	self.target thread vending_weapon_upgrade();
}

function private is_on() // self == PaP trigger
{
	if (isdefined(self.powered))
		return self.powered.power;
	return false;
}

function private get_start_state()
{
	if ( ( isdefined( level.vending_machines_powered_on_at_start ) && level.vending_machines_powered_on_at_start ) )
	{
		return true;
	}

	return false;
}

function private cost_func()
{
	if (isdefined(self.one_time_cost))
	{
		cost = self.one_time_cost;
		self.one_time_cost=undefined;
		return cost;
	}
	if (( isdefined( level._power_global ) && level._power_global ))
		return 0;
	if (( isdefined( self.self_powered ) && self.self_powered ))
		return 0;
	return 1;
}

// PI_CHANGE_BEGIN
//	NOTE:  In the .map, you'll have to make sure that each Pack-A-Punch machine has a unique targetname
function private toggle_think()
{
	vending_weapon_upgrade_trigger = zm_pap_util::get_triggers();

	for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
	{
		machine_trigger = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
		if(isDefined(machine_trigger))
		{
			machine_trigger SetModel( "p7_zm_vending_packapunch" );
		}
	}

	for (;;)
	{
		level waittill("Pack_A_Punch_on");

		for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
		{
			machine_trigger = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
			if(isDefined(machine_trigger))
			{
				machine_trigger thread activate_PackAPunch();
			}
		}

		level waittill("Pack_A_Punch_off");
			
		for(i=0; i<vending_weapon_upgrade_trigger.size; i++ )
		{
			machine_trigger = getent(vending_weapon_upgrade_trigger[i].target, "targetname");
			if(isDefined(machine_trigger))
			{
				machine_trigger thread deactivate_PackAPunch();
			}
		}
	}
}

function private activate_PackAPunch()
{
	//self SetModel("zombie_vending_packapunch_on");
	self SetModel("p7_zm_vending_packapunch");
	self playsound("zmb_perks_power_on");
	self vibrate((0,-100,0), 0.3, 0.4, 3);
	/*
	self.flag = spawn( "script_model", machine GetTagOrigin( "tag_flag" ) );
	self.angles = machine GetTagAngles( "tag_flag" );
	self.flag setModel( "p7_zm_vending_packapunch_sign_wait" );
	self.flag linkto( machine );
	self.flag.origin = (0, 40, 40);
	self.flag.angles = (0, 0, 0);
	*/
	timer = 0;
	duration = 0.05;
	//level notify( "Carpenter_On" );
}

function private deactivate_PackAPunch()
{
	//self SetModel("zombie_vending_packapunch");
	self SetModel( "p7_zm_vending_packapunch" );
	//self playsound("zmb_perks_power_on");
	//self vibrate((0,-100,0), 0.3, 0.4, 3);
}
// PI_CHANGE_END