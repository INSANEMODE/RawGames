/*=============================================================================
_pegasus.gsc
-------------------------------------------------------------------------------
READ: pegasus model, tags and fx tags should be in the same order as
 		 they'd be grouped on the plane. For instance: element 0 of model array 
 		 should use element 0's tag from the tag array, and use element 0 of
 		 the fx tag array.
READ: body model should always come first since it has to call SetModel
=============================================================================*/

#include common_scripts\utility;
#include maps\_utility;

// get all the models that would be attached to the death model
_get_pegasus_death_model_array()
{
	a_models = Array( 	"veh_t6_drone_pegasus_wing_l_dead",
	                	"veh_t6_drone_pegasus_wing_r_dead" );
	return a_models;	
}

// get all the tags where the death model parts would be attached 
_get_pegasus_death_model_tag_array()
{
	a_model_tags = Array(	"tag_dead_wing_l",
							"tag_dead_wing_r" );
	return a_model_tags;
}

// get all the tags where the fx would play on the death model pieces
_get_pegasus_death_model_fx_tag_array()
{
	a_fx_tags = Array( 		//"tag_fx_dead_body_rear",
	                  		"tag_fx_dead_wing_l",
							"tag_fx_dead_wing_r" );
	return a_fx_tags;
}

precache_extra_models()
{
	a_models = _get_pegasus_death_model_array();
	
	for ( i = 0; i < a_models.size; i++ )
	{
		str_model = a_models[ i ];
		PrecacheModel( str_model );
	}
	
	// Precache Objective Model
	self.m_objective_model = "veh_t6_drone_pegasus_objective";
	PrecacheModel( self.m_objective_model );
	
	// Kinda lame
	self._vehicle_load_fx = ::precache_crash_fx;
}

precache_crash_fx()
{
	if ( !IsDefined( self.fx_crash_effects ) )
	{
		self.fx_crash_effects = [];
	}
	
	self.fx_crash_effects["fire_trail_lg"] = LoadFx( "trail/fx_trail_plane_smoke_damage" );
}

set_deathmodel( v_point, v_dir )
{
	if ( !IsDefined( self ) )
		return;
	
	// get all models, model tags and fx tags
	a_models = _get_pegasus_death_model_array();
	a_model_tags = _get_pegasus_death_model_tag_array();
	a_fx_tags = _get_pegasus_death_model_fx_tag_array();
	
	str_deathmodel = self.deathmodel;
	//iprintlnbold( str_deathmodel );

	// set body model on first run through
	if ( IsDefined( self.deathmodel ) )
	{
		str_deathmodel = self.deathmodel;
		self SetModel( str_deathmodel );
		
		//SOUND - Shawn J
		//iprintlnbold( "pegasus_death" );
		self playsound ("evt_pegasus_explo");
		self playsound ("evt_drone_explo_close");
		playsoundatposition( "evt_debris_flythrough", self.origin );
		
		//if ( !IsDefined( self.e_crash_effect_ent ) )
		//{
			//self.e_crash_effect_ent = Spawn( "script_model", self.origin );
			//self.e_crash_effect_ent SetModel( "tag_origing" );
			//self.e_crash_effect_ent LinkTo( self, "tag_fx_dead" );
			
			PlayFxOnTag( self.fx_crash_effects["fire_trail_lg"], self, "tag_origin" );
		//}
	}	
	
	self.deathmodel_pieces = [];
	
	for ( i = 0; i < a_models.size; i++ )
	{
		// get current model, model tag, and fx tag
		str_model = a_models[ i ];
		str_model_tag = a_model_tags[ i ];
		str_fx_tag = a_fx_tags[ i ];
			
		// assert if model isn't in memory
		b_is_model_in_memory = IsAssetLoaded( "xmodel", str_model );
		Assert( b_is_model_in_memory, str_model + " xmodel is not loaded in memory. Include vehicle_pegasus in your level CSV!" );
		
		// spawn model
		self.deathmodel_pieces[i] = spawn( "script_model", self GetTagOrigin( str_model_tag ) );
		self.deathmodel_pieces[i].angles = self GetTagAngles( str_model_tag );
		self.deathmodel_pieces[i] SetModel( str_model );
			
		// link model to body
		self.deathmodel_pieces[i] LinkTo( self, str_model_tag );
	}

	if ( IsDefined( self.deathmodel_pieces ) )
	{
		// sort the pieces by distance to the impact point
		self.deathmodel_pieces = get_array_of_closest( v_point, self.deathmodel_pieces );
		
		num_pieces = 1;
		if ( IsDefined( self.last_damage_mod ) )
		{
			if ( self.last_damage_mod == "MOD_PROJECTILE" )
			{
				num_pieces = 2; //RandomIntRange( 1, self.deathmodel_pieces.size );				
			}
		}
		
		for ( i = 0; i < num_pieces; i++ )
		{
			vel_dir = VectorNormalize( self.velocity );
			
			self.deathmodel_pieces[i] UnLink();
			self.deathmodel_pieces[i] PhysicsLaunch( v_point, vel_dir * 1000 );
			self.deathmodel_pieces[i].b_launched = true;
		}
	}
}

update_objective_model()
{
	self endon( "death" );
	
	self thread clear_objective_model_on_death();
	
	while ( true )
	{
		self waittill( "missileLockTurret_locked" );
		
		if ( !IsDefined( self ) || self.health <= 0 )
			return;
		
		self SetClientFlag( 15 );
		
		self waittill( "missileLockTurret_cleared" );
		
	    self ClearClientFlag( 15 );	
	}
}

clear_objective_model_on_death()
{
	self waittill( "death" );
	
	if ( IsDefined( self ) )
	{
		self ClearClientFlag( 15 );  // remove glowy outline shader
	}
}


 
