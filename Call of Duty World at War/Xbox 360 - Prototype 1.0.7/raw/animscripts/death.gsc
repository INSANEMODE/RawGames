#include common_scripts\utility;
#include animscripts\utility;
#using_animtree ("generic_human");


//
//		 Damage Yaw
//
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

main()
{
    self trackScriptState( "Death Main", "code" );
	self endon("killanimscript");
	
	if ( self.a.nodeath == true )
		return;
	
	if ( isdefined (self.deathFunction) )
	{
		self [[self.deathFunction]]();
		return;
	}
	
	// make sure the guy doesn't keep doing facial animation after death
	changeTime = 0.3;
	self clearanim( %scripted_look_left,			changeTime );
	self clearanim( %scripted_look_right,			changeTime );
	self clearanim( %scripted_look_straight,		changeTime );
	self clearanim( %scripted_talking,				changeTime );
	
	// Grab some info about the previous state before we wipe it all with Initialize()
	if( isDefined( self.isHoldingGrenade ) && self.isHoldingGrenade )
		self DropGrenade();
	
	animscripts\utility::initialize("death");
	
	// Stop any lookats that are happening and make sure no new ones occur while death animation is playing.
	self notify ("never look at anything again");
	
	// should move this to squad manager somewhere...
	removeSelfFrom_SquadLastSeenEnemyPos(self.origin);
	
	if ( isDefined(self.deathanim) )
	{
		//thread [[anim.println]]("Playing special death as set by self.deathanim");#/
		self SetFlaggedAnimKnobAll("deathanim", self.deathanim, %root, 1, .05, 1);
		self animscripts\shared::DoNoteTracks("deathanim");
		if (isDefined(self.deathanimloop))
		{
			// "Playing special dead/wounded loop animation as set by self.deathanimloop");#/
			self SetFlaggedAnimKnobAll("deathanim", self.deathanimloop, %root, 1, .05, 1);
			for (;;)
			{
				self animscripts\shared::DoNoteTracks("deathanim");
			}
		}
		
		// Added so that I can do special stuff in Level scripts on an ai
		if ( isdefined( self.deathanimscript ) )
			self [[self.deathanimscript]]();
		return;
	}
	
	if ( specialDeath( "animdone" ) )
		return;
	
	self clearanim(%root, 0.3);
	//self thread animscripts\pain::PlayHitAnimation();
	
	if ( !damageLocationIsAny( "head", "helmet" ) )
		PlayDeathSound();
	//deathFace = animscripts\face::ChooseAnimFromSet(anim.deathFace);
	//self animscripts\face::SaySpecificDialogue(deathFace, undefined, 1.0);

	if ( playExplodeDeathAnim() )
		return;

	deathAnim = getDeathAnim();

	/#
	if ( getdvarint("scr_paindebug") == 1 )
		println( "^2Playing pain: ", deathAnim, " ; pose is ", self.a.pose );
	#/
	
	playDeathAnim( deathAnim );
}


waitForRagdoll( time )
{
	wait( time );
	if ( isdefined( self ) )
		self startragdoll();
}	

playDeathAnim( deathAnim )
{
	
//	if ( !animHasNoteTrack( deathAnim, "dropgun" ) && !animHasNoteTrack( deathAnim, "fire_spray" ) && !animHasNotetrack( deathAnim, "gun keep" ) )	
	if ( !animHasNoteTrack( deathAnim, "dropgun" ) && !animHasNoteTrack( deathAnim, "fire_spray" ) )	
		self animscripts\shared::DropAIWeapon();
	
	self setAnim( %death, 1, .1 );
	self setFlaggedAnimKnobRestart( "deathanim", deathAnim, 1, .1 );

	self thread waitForRagdoll( getanimlength( deathanim ) * 0.3 );
	
	// do we really need this anymore?
	/#
	if (getdebugdvar("debug_grenadehand") == "on")
	{
		if (animhasnotetrack(deathAnim, "bodyfall large"))
			return;
		if (animhasnotetrack(deathAnim, "bodyfall small"))
			return;
			
		println ("Death animation ", deathAnim, " does not have a bodyfall notetrack");
		iprintlnbold ("Death animation needs fixing (check console and report bug in the animation to Boon)");
	}
	#/
	
	self animscripts\shared::DoNoteTracks("deathanim");
	self animscripts\shared::DropAIWeapon();
}


testPrediction()
{
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing36_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();
	self BeginPrediction();

	self animscripts\predict::start();

	self animscripts\predict::_setAnim(%balcony_stumble_forward, 1, .05, 1);
	if (self animscripts\predict::stumbleWall(1))
	{
		self animMode("nogravity");

		self animscripts\predict::_setFlaggedAnimKnobAll("deathanim", %balcony_tumble_railing44_forward, %root, 1, 0.05, 1);
		if (self animscripts\predict::tumbleWall("deathanim"))
		{
			self EndPrediction();
			return true;
		}
	}

	self EndPrediction();

	self animscripts\predict::end();

	return false;
}


// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the death for the special animation state, or false if it wants the regular 
// death function to handle it.
specialDeath(msg)
{
	if (self.a.special == "none")
		return false;
	
	switch ( self.a.special )
	{
	case "cover_right":
		if (self.a.pose == "stand")
		{
			deathArray = [];
			deathArray[0] = %corner_standr_deathA;
			deathArray[1] = %corner_standr_deathB;
			CornerDeath(deathArray);
		}
		else
		{
			assert(self.a.pose == "crouch");
			return false;
		}
		return true;
	
	case "cover_left":
		if (self.a.pose == "stand")
		{
			deathArray = [];
			deathArray[0] = %corner_standl_deathA;
			deathArray[1] = %corner_standl_deathB;
			CornerDeath(deathArray);
		}
		else
		{
			assert(self.a.pose == "crouch");
			return false;
		}
		return true;
		
	case "cover_stand":
		deathArray = [];
		deathArray[0] = %coverstand_death_left;
		deathArray[1] = %coverstand_death_right;
		CornerDeath( deathArray );
		return true;

	case "cover_crouch":
		deathArray = [];
		if ( damageLocationIsAny( "head", "neck" ) && (self.damageyaw > 135 || self.damageyaw <=-45) )	// Front/Left quadrant
			deathArray[deathArray.size] = %covercrouch_death_1;
		
		if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )	// Back quadrant
			deathArray[deathArray.size] = %covercrouch_death_3;
		
		deathArray[deathArray.size] = %covercrouch_death_2;

		CornerDeath( deathArray );
		return true;
	}
	return false;
}


CornerDeath( deathArray )
{
	deathAnim = deathArray[randomint(deathArray.size)];
	
	self setflaggedanimknob( "deathanim", deathAnim, 1, .3, 1);
	self animscripts\shared::DoNoteTracks ("deathanim");
}


PlayDeathSound()
{
//	if (self.team == "allies")
//		self playsound("allied_death"); 
//	else
//		self playsound("german_death"); 
	self animscripts\face::SayGenericDialogue("death");
}


popHelmet()
{
	if (!isdefined (self)) // removed immediately on death
		return;
	if (!removeableHat())
		return;
		
	partName = GetPartName ( self.hatModel, 0 );        
	model = spawn ("script_model", self . origin + (0,0,64) );
	model setmodel ( self.hatModel  );
	model . origin = self GetTagOrigin ( partName ); //self . origin + (0,0,64);
	model . angles = self GetTagAngles ( partName ); //(-90,0 + randomint(90),0 + randomint(90));
	model thread helmetMove ( self.damageDir );

	if (isdefined(self.helmetSideModel))
	{
		helmetSideModel = spawn ("script_model", self . origin + (0,0,64) );
		helmetSideModel setmodel ( self.helmetSideModel  );
		helmetSideModel . origin = self GetTagOrigin ( "TAG_HELMETSIDE" );
		helmetSideModel . angles = self GetTagAngles ( "TAG_HELMETSIDE" );
		helmetSideModel thread helmetMove ( self.damageDir );
	}

	helmet =  self.hatmodel;
	self.hatmodel = undefined;
	wait 0.05;
	if (!isdefined (self))
		return;
	if (isdefined(self.helmetSideModel))
	{
		self detach(self.helmetSideModel, "TAG_HELMETSIDE");
		self.helmetSideModel = undefined;
	}
	self detach ( helmet , "");
}

helmetMove ( damageDir )
{
    temp_vec = damageDir;
	temp_vec = vectorScale (temp_vec, 150 + randomint (200));

	x = temp_vec[0];
	y = temp_vec[1];
	z = 100 + randomint (200);
	if (y > 0)
		self rotatepitch((4000 + randomfloat (500)) * -1, 5,0,0);
	else
		self rotatepitch(4000 + randomfloat (500), 5,0,0);
	
//	self moveGravity ((x, y, z), 12);
    self launch ( ( x, y, z ) );
	wait (5);
	
	if (isdefined(self))
		self delete();
}


dropGrenade()
{
	grenadeOrigin = self GetTagOrigin ( "TAG_WEAPON_RIGHT" ); 
	self MagicGrenadeManual (grenadeOrigin, (0,0,10), 3);
}


removeSelfFrom_SquadLastSeenEnemyPos(org)
{
	for (i=0;i<anim.squadIndex.size;i++)
		anim.squadIndex[i] clearSightPosNear(org);
}


clearSightPosNear(org)
{
	if (!isdefined(self.sightPos))
		return;
			
	if (distance (org, self.sightPos) < 80)
	{
		self.sightPos = undefined;
		self.sightTime = gettime();
	}
}


shouldDoRunningForwardDeath()
{
	if ( self.a.movement != "run" )
		return false;
		
	if ( self getMotionAngle() > 60 || self getMotionAngle() < -60 )
		return false;
		
	if ( (self.damageyaw >= 135) || (self.damageyaw <=-135) ) // Front quadrant
		return true;

	if ( (self.damageyaw >= -45) && (self.damageyaw <= 45) ) // Back quadrant
		return true;

	return false;
}


getDeathAnim()
{
	if ( self.a.pose == "stand" )
	{
		if ( shouldDoRunningForwardDeath() )
			return getRunningForwardDeathAnim();
		
		return getStandDeathAnim();
	}
	else if ( self.a.pose == "crouch" )
	{
		return getCrouchDeathAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		return getProneDeathAnim();
	}
	else
	{
		assert( self.a.pose == "back" );
		return getBackDeathAnim();
	}
}


getRunningForwardDeathAnim()
{
	deathArray = [];
	deathArray[deathArray.size] = tryAddDeathAnim( %run_death_facedown );
	deathArray[deathArray.size] = tryAddDeathAnim( %run_death_roll );
	
	if ( (self.damageyaw >= 135) || (self.damageyaw <=-135) ) // Front quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_fallonback );
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_fallonback_02 );
	}
	else if ( (self.damageyaw >= -45) && (self.damageyaw <= 45) ) // Back quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_roll );
		deathArray[deathArray.size] = tryAddDeathAnim( %run_death_facedown );
	}

	deathArray = tempClean( deathArray );
	return deathArray[ randomint( deathArray.size ) ];
}

// temp fix for arrays containing undefined
tempClean( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		if ( !isDefined( array[index] ) )
			continue;
			
		newArray[newArray.size] = array[index];
	}
	return newArray;
}

// TODO: proper location damage tracking
getStandDeathAnim()
{
	deathArray = [];
	
	deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death );
	deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_firing_02 );

	// torso or legs
	if ( damageLocationIsAny( "torso_lower", "left_leg_upper", "left_leg_lower", "right_leg_lower", "right_leg_lower" )	)
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_groin );
		
	if ( damageLocationIsAny( "head", "neck", "helmet" ) )
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_headshot );
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_headtwist );
	}

	// neck torso
	if ( damageLocationIsAny( "torso_upper", "neck" ) )
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_nerve );
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_neckgrab );
	}
	
	if ( (self.damageyaw > 135) || (self.damageyaw <=-135) ) // Front quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_02 );
		// chest or shoulder
		if ( damageLocationIsAny( "torso_upper", "left_arm_upper", "right_arm_upper" ) )	
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_firing );
	}
	else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) ) // Right quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
	}
	else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) ) // Back quadrant
	{
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees );
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
	}
	else // Left quadrant
	{
		if ( damageLocationIsAny( "torso_upper", "left_arm_upper", "head" ) )	
			deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_twist );

		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_death_falltoknees_02 );
	}
		
	deathArray = tempClean( deathArray );
	assertex( deathArray.size > 0, deathArray.size );
	return deathArray[ randomint( deathArray.size ) ];
}


getCrouchDeathAnim()
{
	deathArray = [];

	if ( damageLocationIsAny( "head", "neck" ) )	// Front/Left quadrant
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_fetal );
		
	if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_flip );
	
	if ( deathArray.size < 2 )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_twist );
	if ( deathArray.size < 2 )
		deathArray[deathArray.size] = tryAddDeathAnim( %exposed_crouch_death_flip );
	
	deathArray = tempClean( deathArray );
	assertex( deathArray.size > 0, deathArray.size );
	return deathArray[ randomint( deathArray.size ) ];
}


getProneDeathAnim()
{
	return %prone_death_quickdeath;
}


getBackDeathAnim()
{
	deathArray = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
	return deathArray[ randomint( deathArray.size ) ];
}


tryAddDeathAnim( animName )
{
	if ( !animHasNoteTrack( animName, "fire" ) && !animHasNoteTrack( animName, "fire_spray" ) )
		return animName;

	if ( self.a.weaponPos["right"] == "none" )
		return undefined;

	if ( weaponIsSemiAuto( self.weapon ) )
		return;
		
	if ( weaponClass( self.weapon ) == "pistol" || weaponClass( self.weapon ) == "rocketlauncher" )
		return undefined;
		
	return animName;
}


playExplodeDeathAnim()
{
	if ( weaponClass( self.damageWeapon ) != "rocketlauncher" && weaponClass( self.damageWeapon ) != "grenade" && self.damageWeapon != "fraggrenade" )
		return false;

	if ( self.damageLocation != "none" || self.damageTaken < 160 )
		return false;
	
	if (self.damageTaken > 300 && getTime() > anim.lastUpwardsDeathTime + 2000)
	{
		anim.lastUpwardsDeathTime = getTime();
		deathAnim = %death_explosion_up10;
	}
	else
	{
		if ( (self.damageyaw > 135) || (self.damageyaw <=-135) )	// Front quadrant
			deathAnim = %death_explosion_back13;
		else if ( (self.damageyaw > 45) && (self.damageyaw <= 135) )		// Right quadrant
			deathAnim = %death_explosion_left11;
		else if ( (self.damageyaw > -45) && (self.damageyaw <= 45) )		// Back quadrant
			deathAnim = %death_explosion_forward13;
		else															// Left quadrant
			deathAnim = %death_explosion_right13;
	}

	localDeltaVector = getMoveDelta ( deathAnim, 0, 1 );
	endPoint = self localToWorldCoords( localDeltaVector );
	
	if ( !self mayMoveToPoint( endPoint ) )
		return false;

	// this should really be in the notetracks
	self animMode ("nogravity");

	playDeathAnim( deathAnim );
	return true;
}
