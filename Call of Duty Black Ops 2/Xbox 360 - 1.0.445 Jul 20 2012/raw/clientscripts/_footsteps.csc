#define NUM_FRAMES_FOR_CLAW_SPARKS 15

init()
{
	SetAIFootstepPrepend ("fly_step_run_npc_");

	level.vehicleFootStepCallbacks = [];
}	

playerJump(client_num, player, ground_type, firstperson, quiet)
{
	// in cod4 and WAW the jump just played the run footstep sound
	sound_alias = buildMovementSoundAliasName("step_run", ground_type, firstperson, quiet );

	player playsound( client_num, sound_alias );
}

playerLand(client_num, player, ground_type, firstperson, quiet, damagePlayer)
{
	sound_alias = buildMovementSoundAliasName("land", ground_type, firstperson, quiet );

	player playsound( client_num, sound_alias );
	// play step sound for landings if one exists
	if ( IsDefined( player.step_sound ) && (!quiet) && (player.step_sound) != "none" )
	{
		volume = clientscripts\_audio::get_vol_from_speed (player);
	
		//iprintlnbold ("step sound " + player.step_sound + " Volume " + volume);	
 		player playsound (client_num, player.step_sound, player.origin, volume);				
	}
	if ( damagePlayer )
	{
		sound_alias = "fly_land_damage_npc";
		if ( firstperson )
		{
			sound_alias = "fly_land_damage_plr";
			player playsound( client_num, sound_alias );
				
		}
	}
}

playerFoliage(client_num, player, firstperson, quiet)
{
	sound_alias = "fly_movement_foliage_npc";
	if ( firstperson )
	{
		sound_alias = "fly_movement_foliage_plr";
	}
	
	player playsound( client_num, sound_alias );
}

SetAIFootstepPrepend( prepend )
{
  level.footstepPrepend = prepend;
}

getAiBoneOrigin( note )
{
	assert( IsDefined(level.footstepBones) );

	boneOrigin = (0,0,0);

	boneName = level.footstepBones[ note ];

	if( IsDefined(boneName) )
		boneOrigin = self GetTagOrigin( boneName );

	// bone not found
	if( !IsDefined(boneOrigin) )
		boneOrigin = self.origin;

	return boneOrigin;
}

missing_ai_footstep_callback()
{
	/#
	type = self._aitype;
	
	if(!IsDefined(type))
	{
		type = "unknown";
	}
	
	PrintLn("*** Ai type : " + type + " has a client-script footstep script callback specified, but has no callback specified.  Call _footsteps::RegisterAITypeFootstepCB(\""+self._aitype+"\", ::yourcbfunc); in your level main .csc file.");
	#/
}

RegisterAITypeFootstepCB(aiType, func)
{
	if(!IsDefined(level._footstepCBFuncs))
	{
		level._footstepCBFuncs = [];
	}
	
	if(IsDefined(level._footstepCBFuncs[aiType]))
	{
		/#PrintLn("Attempting to register footstep callback function for ai type " + aiType + " multiple times.");#/
		return;
	}
	
	level._footstepCBFuncs[aiType] = func;
}

BigDogFootstepCBFunc(client_num, pos, surface, notetrack, bone)
{
	sound_alias = undefined;	
	
	if( IsSubStr( notetrack, "small" ) )
	{
		sound_alias = "fly_step_walk_bigdog_" + surface;
	}
	else if( IsSubStr( notetrack, "shuffle" ) )
	{
		sound_alias = "fly_step_turn_bigdog_" + surface;
	}
	else if( IsSubStr( notetrack, "scrape" ) )
	{
		sound_alias = "fly_step_scrape_bigdog_" + surface;
		
		// load the effect the first time
		if( !IsDefined( level._effect[self.species] ) || !IsDefined( level._effect[self.species]["step_sparks"] ) )
			clientscripts\_utility::setFootstepEffect( "sparks", LoadFx( "destructibles/fx_claw_metal_scrape_sparks" ), "bigdog" );
		
		if( IsDefined( level._effect[self.species]["step_sparks"] ) )
		{
			self thread PlayScrapeForFrames( client_num, level._effect[self.species]["step_sparks"], bone, NUM_FRAMES_FOR_CLAW_SPARKS );
		}
	}	
	else
	{
		sound_alias = "fly_step_run_bigdog_" + surface;
	}
	
	if( IsDefined( sound_alias ) )
	{
		PlaySound( client_num, sound_alias, pos);
	}	
	
	FootstepDoFootstepFX(); // Indicate we've handled the sound - code should only do surface effects.
}

playAIFootstep(client_num, pos, surface, notetrack, bone)
{	
	if(!IsDefined(self._aitype))
	{
		/#PrintLn("*** Client script footstep callback on an entity that doesn't have an _aitype defined.  Ignoring.");#/
		FootstepDoEverything();		
		return;
	}
	
	if(!IsDefined(level._footstepCBFuncs) || !IsDefined(level._footstepCBFuncs[self._aitype]))
	{
		self missing_ai_footstep_callback();
		FootstepDoEverything();
		return;
	}
	
	[[level._footstepCBFuncs[self._aitype]]](client_num, pos, surface, notetrack, bone);
	
/*	if( IsDefined( self.footsteps ) )
	{
		for( i=0; i < self.footsteps.size; i++ )
		{
			notetrack = self.footsteps[i];

			pos = self getAiBoneOrigin( notetrack );

			/#
			if( GetDvarInt( "cg_footprintsDebug" ) > 0 )
			{
				DebugStar( pos, 30, (1,0,0) );
			}
			#/

			// find the surface type
			offsetVec = (0,0,15);
			surfaceTrace = TracePoint( pos + offsetVec, pos - offsetVec );
			surfaceType = surfaceTrace["surfacetype"];

			sound_alias = undefined;

			if(IsDefined(self.footstepPrepend))
			{
				sound_alias = self.footstepPrepend + surfaceType;	
			}
			else if ( self IsAI() && self.isdog )
			{
				sound_alias = "fly_dog_step_run_default";
			}
			else if ( self IsAI() && self.isbigdog )
			{
				if( IsSubStr( notetrack, "small" ) )
				{
					sound_alias = "fly_step_walk_bigdog_" + surfaceType;
				}
				else if( IsSubStr( notetrack, "shuffle" ) )
				{
					sound_alias = "fly_step_turn_bigdog_" + surfaceType;
				}
				else if( IsSubStr( notetrack, "scrape" ) )
				{
					sound_alias = "fly_step_scrape_bigdog_" + surfaceType;
					
					// load the effect the first time
					if( !IsDefined( level._effect[self.species] ) || !IsDefined( level._effect[self.species]["step_sparks"] ) )
						clientscripts\_utility::setFootstepEffect( "sparks", LoadFx( "destructibles/fx_claw_metal_scrape_sparks" ), "bigdog" );
					
					if( IsDefined( level._effect[self.species]["step_sparks"] ) )
					{
						self thread PlayScrapeForFrames( client_num, level._effect[self.species]["step_sparks"], level.footstepBones[ notetrack ], NUM_FRAMES_FOR_CLAW_SPARKS );
					}
				}
				else
				{
					sound_alias = "fly_step_run_bigdog_" + surfaceType;
				}
			}
			else if( isdefined( level.footstepPrepend ) )
			{
				sound_alias = level.footstepPrepend + surfaceType;
			}
			
			/#
			if( GetDvarInt( "cg_footprintsDebug" ) > 0 )
			{
				println( sound_alias );
			}
			#/

			if( IsDefined( sound_alias ) )
			{
				PlaySound( client_num, sound_alias, pos);
			}

			if ( IsDefined( self.step_sound ) && (self.step_sound) != "null" )
			{
				volume = clientscripts\_audio::get_vol_from_speed(self);

				//iprintlnbold ("step sound " + self.step_sound + " Volume " + volume);	
				self PlaySound(client_num, self.step_sound, self.origin, volume);				
			}

			// fx
			self do_foot_effect( client_num, surfaceType, pos, on_fire );
		}

		// clear out the array
		self.footsteps = [];
	} */
}

PlayScrapeForFrames( client_num, effect, tag, frames )
{
	self endon("death");
	
	offsetVec = ( 0, 0, 30 );
	
	prevOrigin = self.origin;
	forward = AnglesToForward( self.angles );
	forward = VectorScale( forward, -1 );
	
	for( i=0; IsDefined( self ) && i < frames; i++ )
	{
		boneOrigin = self GetTagOrigin( tag );
		
		// play the effect on the ground
		surfaceTrace = TracePoint( boneOrigin, boneOrigin - offsetVec );
		groundPos = surfaceTrace["position"];
			
		PlayFX( client_num, effect, groundPos, forward, ( 0, 0, 1 ) );
		wait(0.01);
		
		// calculate the vector for the fx so they fly backwards
		if( IsDefined( self ) && DistanceSquared( self.origin, prevOrigin ) > 1 )
		{
			forward = VectorNormalize( self.origin - prevOrigin );
			forward = VectorScale( forward, -1 );
			
			prevOrigin = self.origin;
		}
	}
}

buildMovementSoundAliasName( movementtype, ground_type, firstperson, quiet )
{
  if(firstperson && isdefined(level.snd_footstep_override_plr) && (level.snd_footstep_override_plr != ""))
  {
  	return level.snd_footstep_override_plr;
  }
  
  if((!firstperson) && isdefined(level.snd_footstep_override_npc) && (level.snd_footstep_override_npc != ""))
  {
  	return level.snd_footstep_override_npc;
  }
  
	sound_alias = "fly_";
	if ( quiet )
	{
		sound_alias = sound_alias + "q";
	}
	
	sound_alias = sound_alias + movementtype;

	if ( firstperson )
	{
		sound_alias = sound_alias + "_plr_";
	}
	else
	{
		sound_alias = sound_alias + "_npc_";
	}
	
	sound_alias = sound_alias + ground_type; 
	
	return sound_alias;
}

do_foot_effect(client_num, ground_type, foot_pos, on_fire)
{
	if( on_fire )
	{
		ground_type = "fire";
	} 
	
	/#	
	if( GetDvarInt( "debug_surface_type" ) )
	{
		print3d( foot_pos, ground_type, (0.5, 0.5, 0.8), 1, 3, 30 ) ;
	}	
	#/

	effectName = "step_" + ground_type;
	
	if( IsDefined( level._effect ) )
	{
		effect = undefined;

		if( self.type == "actor" && IsDefined( level._effect[self.species] ) && IsDefined( level._effect[self.species][effectName] ) )
		{
			effect = level._effect[self.species][effectName];
		}
		else if( IsDefined( level._effect["human"] ) && IsDefined( level._effect["human"][effectName] ) ) // default
		{
			effect = level._effect["human"][effectName];
		}

		if( IsDefined(effect) )
		{
			PlayFX( client_num, effect, foot_pos, foot_pos + (0,0,100) );
		}
	}
}

registerVehicleFootStepCallback( type, callback )
{
	level.vehicleFootStepCallbacks[ type ] = callback;
}

playVehicleFootStep( client_num, note, ground_type )
{
	if( IsDefined( level.vehicleFootStepCallbacks[ self.vehicletype ] ) )
	{
		self thread [[ level.vehicleFootStepCallbacks[ self.vehicletype ] ]]( client_num, note, ground_type );
	}
}
