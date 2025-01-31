//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//										
// *** SPOPS_COV_WATCHTOWER ***
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// INIT
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// TOP
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// VARIABLES ---------------------------------------------------------------------------------------
instanced object OBJ_top = 								NONE;

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void top_object( object obj_top_new )

	if ( OBJ_top != obj_top_new ) then
		dprint( "SPOPS_COV_WATCHTOWER: top_set" );
		
		OBJ_top = obj_top_new;
		if ( object_get_health(OBJ_top) > 0.0 ) then
			thread( sys_top_manage(OBJ_top) );
		end
		
	end
	
end

script static instanced object top_object()
	OBJ_top;
end

script static instanced void sys_top_manage( object obj_top_manage )
local boolean b_enabled = TRUE;

	repeat

		sleep_until( ((object_get_health(obj_top_manage) > 0.0) and (objects_distance_to_object(obj_top_manage, this) <= 3) and (OBJ_top == obj_top_manage)) != b_enabled, 10 );
		b_enabled = ( (object_get_health(obj_top_manage) > 0.0) and (objects_distance_to_object(obj_top_manage, this) <= 3) and (OBJ_top == obj_top_manage) );
		lift_enable( b_enabled );
	
	until( ((not b_enabled) and (object_get_health(obj_top_manage) <= 0.0)) or (OBJ_top != obj_top_manage), 1 );

end



// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// LIFT
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------

// FUNCTIONS ---------------------------------------------------------------------------------------
script static instanced void lift_enable( boolean b_enable )
	object_set_phantom_power( this, b_enable ); 
end
script static instanced void lift_enable()
	lift_enable( TRUE );
end

script static instanced void lift_disable( boolean b_disable )
	lift_enable( not b_disable );
end
script static instanced void lift_disable()
	lift_disable( TRUE );
end