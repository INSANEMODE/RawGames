//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343
//
// Mission: 					m10_crash_end
// script for the device machine
//										
//343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343

// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// === f_init: init function
script startup instanced init()

	//dprint_door( "init" );
	
	// set it's base overlay animation to 'any:idle'
	device_set_position_track( this, 'any:idle', 0 );
	
	// initialize variables
	speed_set_open( DEF_SPEED_FAST );
	speed_set_close( DEF_SPEED_FAST );
	
	sound_open_set( 'sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_weapon_rack_open' );
	sound_close_set( 'sound\environments\solo\m010\placeholder\doors\m_m10_placeholder_weapon_rack_close' );

//	set_jittering( FALSE );
	
	weaponpickup_set( 0.666, 1.0 );
	
	chain_delay_set( DEF_SPEED_FAST / 8 );
	
//	animate( 0.0, R_door_start_position );

end