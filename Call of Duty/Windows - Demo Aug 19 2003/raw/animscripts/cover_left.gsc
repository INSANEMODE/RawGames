#using_animtree ("generic_human");

// (Note that animations called right are used with left corner nodes, and vice versa.)

main()
{
    self trackScriptState( "Cover Left Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize("cover_left");

	if ( (!self isStanceAllowed("crouch")) && (!self isStanceAllowed("stand")) )
	{
		println("Cover_left: Can't stand or crouch at corner!");
		println (" Entity: " + (self getEntityNumber()) );
		println (" Origin: "+self.origin);
	}

	// If I'm wounded, I fight differently until I recover
	if (self.anim_pose == "wounded")
	{
		self animscripts\wounded::SubState_WoundedGetup("pose be wounded");
	}

	animscripts\combat_say::specific_combat("flankright");

    // 10 second idle select debounce
    if ( GetTime () - self . coverIdleSelectTime > 10000 )
    {    
        if (randomint(100) < 50)
            self.anim_idleset = "a";
        else
            self.anim_idleset = "b";
        self . coverIdleSelectTime = GetTime ();
    }

    self thread State_CoverLeft ( "From main" );
    return;
}

State_CoverLeft( changeReason )
{
    self trackScriptState( "CoverLeft", changeReason );
	self endon("killanimscript");

	// Make sure we're facing the opposite direction from the node.
	cornerAngle = animscripts\utility::GetNodeDirection();
	nodeOrigin = animscripts\utility::GetNodeOrigin();

	for (;;)
	{
		canStand        = self isStanceAllowed("stand");
		canCrouch       = self isStanceAllowed("crouch");
		if (self animscripts\utility::weaponAnims()=="panzerfaust")
			canStand = 0;
		keepPose = randomint ( 100 ) < 90;
		if (	( self.anim_pose=="stand" && keepPose && canStand ) || 
				( self.anim_pose=="crouch" && !keepPose && canStand ) || 
				(!canCrouch) )
		{
			SubState_StandingCorner("canStand && rand passed", cornerAngle, nodeOrigin);
		}
		else
		{
  			SubState_CrouchingCorner("canCrouch && rand passed", cornerAngle, nodeOrigin);
		}
	}
}

Anims_StandingPistol()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %pistol_rightstand_60left;
	animArray["anim_blend"]["middle"]		= %pistol_rightstand_15left;
	animArray["anim_blend"]["right"]		= %pistol_rightstand_30right;
	animarray["anim_alert2aim"]["left"]		= %pistol_rightstand_hide2aim_60left;
	animarray["anim_alert2aim"]["middle"]	= %pistol_rightstand_hide2aim_15left;
	animarray["anim_alert2aim"]["right"]	= %pistol_rightstand_hide2aim_30right;
	animarray["anim_aim"]["left"]			= %pistol_rightstand_aimloop_60left;
	animarray["anim_aim"]["middle"]			= %pistol_rightstand_aimloop_15left;
	animarray["anim_aim"]["right"]			= %pistol_rightstand_aimloop_30right;
	animarray["anim_semiautofire"]["left"]	= %pistol_rightstand_shoot_60left;
	animarray["anim_semiautofire"]["middle"]= %pistol_rightstand_shoot_15left;
	animarray["anim_semiautofire"]["right"]	= %pistol_rightstand_shoot_30right;
	animarray["anim_boltfire"]["left"]		= %pistol_rightstand_shoot_60left;
	animarray["anim_boltfire"]["middle"]	= %pistol_rightstand_shoot_15left;
	animarray["anim_boltfire"]["right"]		= %pistol_rightstand_shoot_30right;
	animarray["anim_aim2alert"]["left"]		= %pistol_rightstand_aim2hide_60left;    
	animarray["anim_aim2alert"]["middle"]	= %pistol_rightstand_aim2hide_15left;    
	animarray["anim_aim2alert"]["right"]	= %pistol_rightstand_aim2hide_30right;    
	animarray["anim_alert"]					= %pistol_rightstand_hide_idle;	// TODO Can also use %pistol_rightstand_hide_twitch here
	//animarray["anim_look"] - does not exist for Pistol.  Nor does rambo, autofire or corner reload.
	return animarray;
}
Anims_StandingRifleA()
{
	animArray["run2alert"]					= %corner_run2alert_right;
	animarray["hideYawOffset"]				= 180;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %corner_stand_right_60left;
	animArray["anim_blend"]["middle"]		= %corner_stand_right_15left;
	animArray["anim_blend"]["right"]		= %corner_stand_right_30right;
	animarray["anim_alert2aim"]["left"]		= %corner_stand_alert2aim_right_60left;
	animarray["anim_alert2aim"]["middle"]	= %corner_stand_alert2aim_right_15left;
	animarray["anim_alert2aim"]["right"]	= %corner_stand_alert2aim_right_30right;
	animarray["anim_aim"]["left"]			= %corner_stand_aim_right_60left;
	animarray["anim_aim"]["middle"]			= %corner_stand_aim_right_15left;
	animarray["anim_aim"]["right"]			= %corner_stand_aim_right_30right;
	animarray["anim_autofire"]["left"]		= %corner_stand_autofire_right_60left;
	animarray["anim_autofire"]["middle"]	= %corner_stand_autofire_right_15left;
	animarray["anim_autofire"]["right"]		= %corner_stand_autofire_right_30right;
	animarray["anim_semiautofire"]["left"]	= %corner_stand_semiautofire_right_60left;
	animarray["anim_semiautofire"]["middle"]= %corner_stand_semiautofire_right_15left;
	animarray["anim_semiautofire"]["right"]	= %corner_stand_semiautofire_right_30right;
	animarray["anim_boltfire"]["left"]		= %corner_stand_semiautofire_right_60left;
	animarray["anim_boltfire"]["middle"]	= %corner_stand_semiautofire_right_15left;
	animarray["anim_boltfire"]["right"]		= %corner_stand_semiautofire_right_30right;
	animarray["anim_aim2alert"]["left"]		= %corner_stand_aim2alert_right_60left;    
	animarray["anim_aim2alert"]["middle"]	= %corner_stand_aim2alert_right_15left;    
	animarray["anim_aim2alert"]["right"]	= %corner_stand_aim2alert_right_30right;    
	animarray["anim_alert"]					= %cornerstandpose_right;
	animarray["anim_alert2rambo"]			= %corner2rambo_right;
	animarray["anim_rambo2alert"]			= %rambo2corner_right;
	animarray["anim_look"]					= %cornerstandlook_right;
	animarray["anim_grenade"]				= %corner_stand_grenade_throw_right;
	animarray["offset_grenade"]				= (0,-44,42);
	animarray["gunhand_grenade"]			= "right";
	return animarray;
}
Anims_StandingRifleB()
{
	animArray["run2alert"]					= %cornerb_run2alert_right;
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %cornerb_stand_right_60left;
	animArray["anim_blend"]["middle"]		= %cornerb_stand_right_15left;
	animArray["anim_blend"]["right"]		= %cornerb_stand_right_30right;
	animarray["anim_alert2aim"]["left"]		= %cornerb_stand_alert2aim_right_60left;
	animarray["anim_alert2aim"]["middle"]	= %cornerb_stand_alert2aim_right_15left;
	animarray["anim_alert2aim"]["right"]	= %cornerb_stand_alert2aim_right_30right;
	animarray["anim_aim"]["left"]			= %cornerb_stand_aim_right_60left;
	animarray["anim_aim"]["middle"]			= %cornerb_stand_aim_right_15left;
	animarray["anim_aim"]["right"]			= %cornerb_stand_aim_right_30right;
	animarray["anim_autofire"]["left"]		= %cornerb_stand_autofire_right_60left;
	animarray["anim_autofire"]["middle"]	= %cornerb_stand_autofire_right_15left;
	animarray["anim_autofire"]["right"]		= %cornerb_stand_autofire_right_30right;
	animarray["anim_semiautofire"]["left"]	= %cornerb_stand_semiautofire_right_60left;
	animarray["anim_semiautofire"]["middle"]= %cornerb_stand_semiautofire_right_15left;
	animarray["anim_semiautofire"]["right"]	= %cornerb_stand_semiautofire_right_30right;
	animarray["anim_boltfire"]["left"]		= %cornerb_stand_semiautofire_right_60left;
	animarray["anim_boltfire"]["middle"]	= %cornerb_stand_semiautofire_right_15left;
	animarray["anim_boltfire"]["right"]		= %cornerb_stand_semiautofire_right_30right;
	animarray["anim_aim2alert"]["left"]		= %cornerb_stand_aim2alert_right_60left;    
	animarray["anim_aim2alert"]["middle"]	= %cornerb_stand_aim2alert_right_15left;    
	animarray["anim_aim2alert"]["right"]	= %cornerb_stand_aim2alert_right_30right;    
	animarray["anim_alert"]					= %cornerb_stand_alert_idle_right;
	// (There are no rambo animations for "b" idleset.)
	animarray["anim_look"]					= %cornerb_stand_alert_look_right;
	animarray["anim_reload"]				= %reload_cornerb_stand_right_rifle;
	animarray["anim_grenade"]				= %cornerb_stand_grenade_throw_right;
	animarray["offset_grenade"]				= (0,44,42);
	animarray["gunhand_grenade"]			= "right";
	return animarray;
}

SubState_StandingCorner(changeReason, cornerAngle, nodeOrigin)
{
    entryState = self . scriptState;
    self trackScriptState( "StandingCornerLeft", changeReason );    

	[[anim.PutGunInHand]]("left");

 	// Set up the animations to use
	animarray = GoToCover(cornerAngle);

	// Make sure we're standing
	if ( (self.anim_pose == "crouch") || (self.anim_pose == "prone") )	// TODO: Prone should have its own animation.
	{
		self ExitProne(0.5);
		if (self.anim_idleset == "a")
		{
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornercrouch2stand_right, "stand", "stop", 0, 1);
		}
		else
		{
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornerb_crouch2stand_right, "stand", "stop", 0, 1);
		}
	}

 	// Now do the behavior
	animscripts\corner::CornerBehavior( nodeOrigin, cornerAngle, animarray );

    self trackScriptState( entryState, "Standing done" );
}


Anims_CrouchingPanzerfaust()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %panzerfaust_cornercrouch_right_60left;
	animArray["anim_blend"]["middle"]		= %panzerfaust_cornercrouch_right_15left;
	animArray["anim_blend"]["right"]		= %panzerfaust_cornercrouch_right_30right;
	animarray["anim_alert2aim"]["left"]		= %panzerfaust_cornercrouch_alert2aim_right_60left;
	animarray["anim_alert2aim"]["middle"]	= %panzerfaust_cornercrouch_alert2aim_right_15left;
	animarray["anim_alert2aim"]["right"]	= %panzerfaust_cornercrouch_alert2aim_right_30right;
	animarray["anim_aim"]["left"]			= %panzerfaust_cornercrouchaim_right_60left;
	animarray["anim_aim"]["middle"]			= %panzerfaust_cornercrouchaim_right_15left;
	animarray["anim_aim"]["right"]			= %panzerfaust_cornercrouchaim_right_30right;
	animarray["anim_semiautofire"]["left"]	= %panzerfaust_cornercrouchaim_right_60left;
	animarray["anim_semiautofire"]["middle"]= %panzerfaust_cornercrouchaim_right_15left;
	animarray["anim_semiautofire"]["right"]	= %panzerfaust_cornercrouchaim_right_30right;
	animarray["anim_boltfire"]["left"]		= %panzerfaust_cornercrouchaim_right_60left;
	animarray["anim_boltfire"]["middle"]	= %panzerfaust_cornercrouchaim_right_15left;
	animarray["anim_boltfire"]["right"]		= %panzerfaust_cornercrouchaim_right_30right;
	animarray["anim_aim2alert"]["left"]		= %panzerfaust_cornercrouchaim2alert_right_60left;    
	animarray["anim_aim2alert"]["middle"]	= %panzerfaust_cornercrouchaim2alert_right_15left;    
	animarray["anim_aim2alert"]["right"]	= %panzerfaust_cornercrouchaim2alert_right_30right;    
	animarray["anim_alert"]					= %panzerfaust_cornercrouchaimdown_right;		// FIXME!  Is this the right anim?
	//animarray["anim_look"] - does not exist for Panzerfaust.  Nor does rambo or autofire.
	return animarray;
}
Anims_CrouchingPistol()
{
    animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %pistol_rightcrouch_60left;
	animArray["anim_blend"]["middle"]		= %pistol_rightcrouch_15left;
	animArray["anim_blend"]["right"]		= %pistol_rightcrouch_30right;
	animarray["anim_alert2aim"]["left"]		= %pistol_rightcrouch_hide2aim_60left;
	animarray["anim_alert2aim"]["middle"]	= %pistol_rightcrouch_hide2aim_15left;
	animarray["anim_alert2aim"]["right"]	= %pistol_rightcrouch_hide2aim_30right;
	animarray["anim_aim"]["left"]			= %pistol_rightcrouch_aimloop_60left;
	animarray["anim_aim"]["middle"]			= %pistol_rightcrouch_aimloop_15left;
	animarray["anim_aim"]["right"]			= %pistol_rightcrouch_aimloop_30right;
	animarray["anim_semiautofire"]["left"]	= %pistol_rightcrouch_shoot_60left;
	animarray["anim_semiautofire"]["middle"]= %pistol_rightcrouch_shoot_15left;
	animarray["anim_semiautofire"]["right"]	= %pistol_rightcrouch_shoot_30right;
	animarray["anim_boltfire"]["left"]		= %pistol_rightcrouch_shoot_60left;
	animarray["anim_boltfire"]["middle"]	= %pistol_rightcrouch_shoot_15left;
	animarray["anim_boltfire"]["right"]		= %pistol_rightcrouch_shoot_30right;
	animarray["anim_aim2alert"]["left"]		= %pistol_rightcrouch_aim2hide_60left;    
	animarray["anim_aim2alert"]["middle"]	= %pistol_rightcrouch_aim2hide_15left;    
	animarray["anim_aim2alert"]["right"]	= %pistol_rightcrouch_aim2hide_30right;    
	animarray["anim_alert"]					= %pistol_rightcrouch_hide_idle;	// TODO Can also use %pistol_rightcrouch_hide_twitch here
	//animarray["anim_look"] - does not exist for Pistol.  Nor does rambo or autofire.
	return animarray;
}
Anims_CrouchingRifleA()
{
	animarray["hideYawOffset"]				= 180;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %corner_crouch_right_60left;
	animArray["anim_blend"]["middle"]		= %corner_crouch_right_15left;
	animArray["anim_blend"]["right"]		= %corner_crouch_right_30right;
	animarray["anim_alert2aim"]["left"]		= %corner_crouch_alert2aim_right_60left;
	animarray["anim_alert2aim"]["middle"]	= %corner_crouch_alert2aim_right_15left;
	animarray["anim_alert2aim"]["right"]	= %corner_crouch_alert2aim_right_30right;
	animarray["anim_aim"]["left"]			= %corner_crouch_aim_right_60left;
	animarray["anim_aim"]["middle"]			= %corner_crouch_aim_right_15left;
	animarray["anim_aim"]["right"]			= %corner_crouch_aim_right_30right;
	animarray["anim_autofire"]["left"]		= %corner_crouch_autofire_right_60left;
	animarray["anim_autofire"]["middle"]	= %corner_crouch_autofire_right_15left;
	animarray["anim_autofire"]["right"]		= %corner_crouch_autofire_right_30right;
	animarray["anim_semiautofire"]["left"]	= %corner_crouch_semiautofire_right_60left;
	animarray["anim_semiautofire"]["middle"]= %corner_crouch_semiautofire_right_15left;
	animarray["anim_semiautofire"]["right"]	= %corner_crouch_semiautofire_right_30right;
	animarray["anim_boltfire"]["left"]		= %corner_crouch_semiautofire_right_60left;
	animarray["anim_boltfire"]["middle"]	= %corner_crouch_semiautofire_right_15left;
	animarray["anim_boltfire"]["right"]		= %corner_crouch_semiautofire_right_30right;
	animarray["anim_aim2alert"]["left"]		= %corner_crouch_aim2alert_right_60left;    
	animarray["anim_aim2alert"]["middle"]	= %corner_crouch_aim2alert_right_15left;    
	animarray["anim_aim2alert"]["right"]	= %corner_crouch_aim2alert_right_30right;    
	animarray["anim_alert"]					= %cornercrouchpose_right;
	//animarray["anim_look"] - does not exist for crouching corner set a
	animarray["anim_reload"]				= %reload_cornera_crouch_right_rifle;
	animarray["anim_grenade"]				= %corner_stand_grenade_throw_right;
	animarray["offset_grenade"]				= (0,-40,33);
	animarray["gunhand_grenade"]			= "right";
	return animarray;
}
Anims_CrouchingRifleB()
{
	animarray["hideYawOffset"]				= 0;
	animarray["angle_aim"]["left"]			= -60;
	animarray["angle_aim"]["middle"]		= -15;
	animarray["angle_aim"]["right"]			= 30;
	animArray["anim_blend"]["left"]			= %cornerb_crouch_right_60left;
	animArray["anim_blend"]["middle"]		= %cornerb_crouch_right_15left;
	animArray["anim_blend"]["right"]		= %cornerb_crouch_right_30right;
	animarray["anim_alert2aim"]["left"]		= %cornerb_crouch_alert2aim_right_60left;
	animarray["anim_alert2aim"]["middle"]	= %cornerb_crouch_alert2aim_right_15left;
	animarray["anim_alert2aim"]["right"]	= %cornerb_crouch_alert2aim_right_30right;
	animarray["anim_aim"]["left"]			= %cornerb_crouch_aim_right_60left;
	animarray["anim_aim"]["middle"]			= %cornerb_crouch_aim_right_15left;
	animarray["anim_aim"]["right"]			= %cornerb_crouch_aim_right_30right;
	animarray["anim_autofire"]["left"]		= %cornerb_crouch_autofire_right_60left;
	animarray["anim_autofire"]["middle"]	= %cornerb_crouch_autofire_right_15left;
	animarray["anim_autofire"]["right"]		= %cornerb_crouch_autofire_right_30right;
	animarray["anim_semiautofire"]["left"]	= %cornerb_crouch_semiautofire_right_60left;
	animarray["anim_semiautofire"]["middle"]= %cornerb_crouch_semiautofire_right_15left;
	animarray["anim_semiautofire"]["right"]	= %cornerb_crouch_semiautofire_right_30right;
	animarray["anim_boltfire"]["left"]		= %cornerb_crouch_semiautofire_right_60left;
	animarray["anim_boltfire"]["middle"]	= %cornerb_crouch_semiautofire_right_15left;
	animarray["anim_boltfire"]["right"]		= %cornerb_crouch_semiautofire_right_30right;
	animarray["anim_aim2alert"]["left"]		= %cornerb_crouch_aim2alert_right_60left;    
	animarray["anim_aim2alert"]["middle"]	= %cornerb_crouch_aim2alert_right_15left;    
	animarray["anim_aim2alert"]["right"]	= %cornerb_crouch_aim2alert_right_30right;    
	animarray["anim_alert"]					= %cornerb_crouch_alert_idle_right;
	animarray["anim_look"]					= %cornerb_crouch_alert_look_right;
	animarray["anim_reload"]				= %reload_cornerb_crouch_right_rifle;
	animarray["anim_grenade"]				= %cornerb_crouch_grenade_throw_right;
	animarray["offset_grenade"]				= (0,40,33);
	animarray["gunhand_grenade"]			= "right";
	return animarray;
}

SubState_CrouchingCorner(changeReason, cornerAngle, nodeOrigin)
{
    entryState = self.scriptState;
    self trackScriptState( "CrouchingCornerLeft", changeReason );

	[[anim.PutGunInHand]]("left");

	// Set up the animations to use
	animarray = GoToCover(cornerAngle);

	// Make sure we're crouching
	self.anim_movement = "stop";
	weaponAnims = anim.AIWeapon[self.weapon]["anims"];
	if (weaponAnims=="panzerfaust")
	{
		self [[anim.SetPoseMovement]]("crouch","stop");
	}
	else if ( (self.anim_pose == "stand") || (self.anim_pose == "prone") )	// TODO: Prone should have its own animation.
	{
		self ExitProne(0.5);
		if (self.anim_idleset == "a")
			animscripts\SetPoseMovement::PlayBlendTransition(%cornercrouchpose_right, 0.5, "crouch", "stop", 0);
		else
			animscripts\SetPoseMovement::PlayTransitionAnimation(%cornerb_stand2crouch_right, "crouch", "stop", 0, 1);
	}

	// Now do the behavior
	animscripts\corner::CornerBehavior( nodeOrigin, cornerAngle, animarray );

    self trackScriptState( entryState, "CrouchingCorner returns" );
}


GoToCover(cornerAngle)
{
	weaponAnims = anim.AIWeapon[self.weapon]["anims"];
	if (self.anim_special == "cover_left")
	{
		// We're already in position.  Just check for error conditions before continuing.
		if (weaponAnims == "panzerfaust")
		{
			animarray = Anims_CrouchingPanzerfaust();
		}
		else if (weaponAnims == "pistol")
		{
			if (self.anim_pose == "stand")
			{
				animarray = Anims_StandingPistol();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				animarray = Anims_CrouchingPistol();
			}
		}
		else if (self.anim_idleSet=="a")
		{
			if (self.anim_pose == "stand")
			{
				animarray = Anims_StandingRifleA();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				animarray = Anims_CrouchingRifleA();
			}
		}
		else if (self.anim_idleSet=="b")
		{
			if (self.anim_pose == "stand")
			{
				animarray = Anims_StandingRifleB();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				animarray = Anims_CrouchingRifleB();
			}
		}
		else
		{
			println ("cover_left::GoToCover : Invalid self.anim_idleSet "+self.anim_idleSet+" for cover_left character ("+self.anim_pose+", "+self.anim_movement+")");
			self.anim_idleSet = "a";
			if (self.anim_pose == "stand")
			{
				animarray = Anims_StandingRifleA();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				animarray = Anims_CrouchingRifleA();
			}
		}
		// Otherwise, there's nothing to do - we're ready to go.
		playTransitionAnim = false;
	}
	else
	{
		// Decide which idle animation to do.  Subtract a bit from the angle difference so that if we're close to 0 
		// difference, we use set b, and if we're close to 180, we use set a. 
		angleDifference = animscripts\utility::AngleClamp( cornerAngle-self.angles[1]-15);
		if (weaponAnims == "panzerfaust")
		{
			animarray = Anims_CrouchingPanzerfaust();
		}
		else if (weaponAnims == "pistol")
		{
			if (self.anim_pose == "stand")
			{
				animarray = Anims_StandingPistol();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				animarray = Anims_CrouchingPistol();
			}
		}
		else if ( angleDifference <= 180 )
		{
			self.anim_idleset = "a";
			if (self.anim_pose == "stand")
			{
				[[anim.println]]("cover_left stand - picked set a, playing run2corner anim");
				animarray = Anims_StandingRifleA();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				[[anim.println]]("cover_left crouch - picked set a, playing run2corner anim");
				animarray = Anims_CrouchingRifleA();
			}
		}
		else
		{
			self.anim_idleset = "b";
			if (self.anim_pose == "stand")
			{
				[[anim.println]]("cover_left stand - picked set b, playing run2corner anim");
				animarray = Anims_StandingRifleB();
			}
			else
			{
				self ExitProne(0.5); // In case we were in Prone.
				self.anim_pose = "crouch";
				[[anim.println]]("cover_left crouch - picked set b, playing run2corner anim");
				animarray = Anims_CrouchingRifleB();
			}
		}
		playTransitionAnim = true;
	}
	self OrientMode( "face angle", cornerAngle+animarray["hideYawOffset"] );
	if ( playTransitionAnim && isDefined(animarray["run2alert"]) )
	{
		self setFlaggedAnimKnobAllRestart("run2alert",animarray["run2alert"], %body, 1, .25, self.animplaybackrate);
		self animscripts\shared::DoNoteTracks ("run2alert");
	}
	self.anim_special = "stop";
	self.anim_special = "cover_left";
	return animarray;
}
