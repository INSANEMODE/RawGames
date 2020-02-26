/****************************************************************************
_breach global script

NOTE: Load \test\breach.d3dbsp to test all supported breaches

--------------------------
Currently supported breaches (sBreachType)
--------------------------
"explosive_breach_left"
"shotgunhinges_breach_left":
"flash_breach_no_door_right":


--------------------------
How to use
--------------------------

1) Add maps\_breach::main(); above _load:::main();

2) ROOM VOLUME: Create an info_volume that encompasses the room being assaulted.
				(used to stun enemies during explosive breaches, determine where AI throws flash grenades, 
				and to detect when the room is cleared)

3) DOOR: 		Have the room volume script_linkTo a door (script_model or script_brushmodel) with an origin that
				points in towards the interior of the room (all stacking/breaching anims play on this origin). 
				see model com_door_01_handleleft for an example.
				
				If you use a script_brushmodel, you will need to manually target it to a script_origin on the
				lower right corner of the door frame that points in towards the interior of the room.
				
4) NO DOOR: 	If the breach does not require a door (like for flashbang only breaches), you need to have the 
				room volume script_linkTo a script_origin on the edge of the door frame pointing in towards the room.
				
5) BLOCKER: 	The model door needs to target a script_brushmodel blocker (not necessary if you use 
				a script_brushmodel door instead)

5) EXPLODER: 	All doors must script_linkTo a script_origin in the center of the door with a 'script_exploder' key 
				of any number. Used to play default fx and will later by used by fx artists for additional
				smoke or custom effects in the room
				
--------------------------
Function arguments
--------------------------
<volume> thread breach_think(aBreachers, sBreachType, sHintString, bSpawnHostiles, bPlayDefaultFx);

<volume> 	= The room volume being breached
aBreachers	= The array of friendlies performing the breach (can not be more than 2)
sBreachType	= which breach to perform. See /test/breach to see currently supported breaches
sHintString	= Pass a hintstrig to display if you trigger the breach with a "use" trigger
bSpawnHostiles = true/false value if you want to spawn hostiles inside right before the breach is started
bPlayDefaultFx = defaults to true. Set to false and add effects to the exploder instead if you like

****************************************************************************/

#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anims_breach();
	sounds_and_fx();
	level.maxDetpackDamage = 100;	//max damage done by breach detpacks
	level.minDetpackDamage = 50;	//max damage done by breach detpacks
	level.detpackStunRadius = 250;	//how close enemies have to be to detpack to be stunned
	level.iFlashFuse = 1;			//how long before friendly-throw flashbangs detonate
	
	level.door_objmodel = "com_door_breach_left_obj";	
	precacheModel(level.door_objmodel);	
}

/****************************************************************************
    BREACH CORE FUNCTIONS
****************************************************************************/

breach_think(aBreachers, sBreachType, sHintString, bSpawnHostiles, bPlayDefaultFx)
{
	//self ==> the room volume being breached
	self endon ("breach_abort");
	
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/
	self.flashthrown = false;
	self.animEnt = undefined;
	self.breached = false;
	self.breachers = 0;
	self.breachersReady = false;
	self.hasFirstBreacher = false;
	self.readyToPlayAnims = false;
	self.readyToBreach = false;
	self.AIareInTheRoom = false;
	self.aboutToBeBreached = false;
	self.cleared = false;
	self.hasDoor = true;
	self.hasFlashbangs = false;
	self.hostilesSpawned = false;
	assertEx((aBreachers.size <= 2), "You cannot send more than 2 AI to perform a breach");
	assertEx((isdefined(self.targetname)), "Room volume must have a targetname to use the breach fuctions");
	aVolumes = getentarray(self.targetname, "targetname");
	assertEx((aVolumes.size == 1), "There are multiple room volumes with the same targetname: " + self.targetname);
	sRoomName = self.targetname;
	self.sBadplaceName = "badplace_" + sRoomName;
	self.badplace = getent("badplace_" + sRoomName, "targetname");
	assertEx((isdefined(self.badplace)), "This room volume needs a script_origin with a target-named ' badplace_" + sRoomName + " ' to keep AI away from the door during the breach entrance animations");
	assertEx((self.badplace.classname == "script_origin"), "The badplace entity for volume " + self.targetname + " needs to be a script_origin");
	self.breachtrigger = getent("trigger_" + sRoomName, "targetname");
	if (!isdefined(bPlayDefaultFx))
		bPlayDefaultFx = true;
	if (isdefined(self.breachtrigger))
	{
		switch (self.breachtrigger.classname)
		{
			case "trigger_use":
				assertEx((isdefined(sHintString)), "You need to pass a hintstring to the function 'breach_think' for the trigger_use " + self.breachtrigger.targetname);
				self.triggerHintString = sHintString;
				break;
			case "trigger_use_touch":
				assertEx((isdefined(sHintString)), "You need to pass a hintstring to the function 'breach_think' for the trigger_use " + self.breachtrigger.targetname);
				self.triggerHintString = sHintString;
				break;
			case "trigger_radius":
				break;
			case "trigger_multiple":
				break;
			default:
				assertmsg("entity with targetname '" + self.breachtrigger.targetname + "' must be a trigger_multiple, trigger_radius,  trigger_use or trigger_use_touch");
				break;
		}
	}
	switch (sBreachType)
	{
		case "explosive_breach_left":
			break;
		case "shotgunhinges_breach_left":
			break;		
		case "flash_breach_no_door_right":
			self.hasDoor = false;
			self.hasFlashbangs = true;
			break;
		default:
			assertmsg(sBreachType + " is not a valid breachType");
			break;
	}
	if (self.hasDoor == true)
	{
		self.eDoor = getent(self.script_linkto, "script_linkname");
		assertEx((isdefined(self.eDoor)), "Explosive breach room volume " + self.targetname + " needs to scriptLinkto a single door");
		if (self.eDoor.classname == "script_model")
		{
			self.animEnt = spawn( "script_origin", self.eDoor.origin );
			self.animEnt.angles = self.eDoor.angles;
		}
		else if (self.eDoor.classname == "script_brushmodel")
		{
			self.animEnt = getent(self.eDoor.target, "targetname");
			assertEx((isdefined(self.animEnt)), "Room volume " + self.targetname + " needs it's script_brushmodel door door to target a script_origin in the lower right hand corner of the door frame. Make this script_origin point in towards the room being breached.");
			assertEx((self.animEnt.classname == "script_origin"), "Room volume " + self.targetname + " needs it's script_brushmodel door door to target a script_origin in the lower right hand corner of the door frame. Make this script_origin point in towards the room being breached.");	
			self.eDoor.vector = anglestoforward(self.animEnt.angles);
		}		
		self.eExploderOrigin = getent(self.eDoor.script_linkto, "script_linkname");
		assertex( isdefined(self.eExploderOrigin), "A script_brushmodel/script_model door needs to script_linkTo an exploder (script_origin) to play particles when opened. Targetname:  " + self.targetname);
		assertEx((self.eExploderOrigin.classname == "script_origin"), "The exploder for this room volume needs to be a script_origin: " + self.targetname);
		self.iExploderNum = self.eExploderOrigin.script_exploder;
		assertEx((isdefined(self.iExploderNum)), "There is no exploder number in the key 'script_exploder' for volume " + self.targetname);	
	}
	else if (self.hasDoor == false)
	{
		self.animEnt = getent(self.script_linkto, "script_linkname");
		assertEx((isdefined(self.animEnt)), "If there is no door to be breached, you must have the room volume scriptLinkTo a script_origin instead where the AI will play their idle and enter anims.");
	}
	if (self.hasFlashbangs == true)
	{
		self.grenadeOrigin = getent("flashthrow_" + sRoomName, "targetname");
		assertEx((isdefined(self.grenadeOrigin)), "Breaches that have AI throwing flashbangs need a script origin in the center of the door frame with a targetname of: flashthrow_" + sRoomName);
		self.grenadeDest = getent(self.grenadeOrigin.target, "targetname");
		assertEx((isdefined(self.grenadeDest)), "script_origin 'flashthrow_" + sRoomName + "' needs to target another script_origin where you want the flashbang to be thrown to");
	}

	/*-----------------------
	CLEANUP AND FX
	-------------------------*/
	self thread breach_abort(aBreachers);
	self thread breach_cleanup(aBreachers);
	self thread breach_play_fx(sBreachType, bPlayDefaultFx);

	/*-----------------------
	SEND EACH AI TO IDLE
	-------------------------*/
	for(i=0;i<aBreachers.size;i++)
		aBreachers[i] thread breacher_think(self, sBreachType);
	
	while (self.breachers < aBreachers.size)
		wait (0.05);
	
	/*-----------------------
	AI IS READY TO BREACH
	-------------------------*/		
	self.readyToBreach = true;
	if (isdefined(self.breachtrigger))
		self.breachtrigger thread breach_trigger_think(self);
	self waittill ("execute_the_breach");
	self.aboutToBeBreached = true;
	
	/*-----------------------
	SPAWN HOSTILES RIGHT AS ROOM IS BEING BREACHED (IF SPECIFIED IN ARGUMENT)
	-------------------------*/		
	
	if ( isdefined(bSpawnHostiles) && (bSpawnHostiles == true) )
	{
		spawners = getentarray("hostiles_" + sRoomName, "targetname");
		assertEx((isdefined(spawners)), "Could not find spawners with targetname of hostiles_" + sRoomName + " for room volume " + self.targetname);
		//wait for the AI to start breaching the room before spawning hostiles
		self waittill ("spawn_hostiles");
		spawnBreachHostiles(spawners);
		self.hostilesSpawned = true;
	}

	/*-----------------------
	GET ARRAY OF ALL HOSTILES TOUCHING THE ROOM VOLUME
	-------------------------*/	
	//badplace to get AI out of the way of the door
	badplace_cylinder(self.sBadplaceName, -1, self.badplace.origin, self.badplace.radius, 200, "axis");
	
	
	ai = getaiarray ("axis");
	aHostiles = [];
	for(i=0;i<ai.size;i++)
	{
		if (ai[i] isTouching(self))
			aHostiles[aHostiles.size] = ai[i];
	}	
	if (aHostiles.size > 0)
		maps\_utility::array_thread(aHostiles,::breach_enemies_stunned, self);
	
	/*-----------------------
	WAIT FOR ALL THE AI TO BE IN THE ROOM
	-------------------------*/
	while (!self.AIareInTheRoom)
		wait (0.05);

	self notify ("breach_complete");
	/*-----------------------
	WAIT FOR ROOM TO BE CLEARED
	-------------------------*/
	while (!self.cleared)
	{
		wait (0.05);
		for(i=0;i<aHostiles.size;i++)
		{
			if ( !isalive(aHostiles[i]) )
				aHostiles = maps\_utility::array_remove(aHostiles, aHostiles[i]);
			if (aHostiles.size == 0)
				self.cleared = true;
		}		
	}
}

breacher_think(eVolume, sBreachType)
{
	//self ==> the AI doing the breaching
	self.breaching = true;
	//self maps\_utility::disable_ai_color();
	self breach_set_animname("frnd");
	self.pushplayer = true;
	self thread give_infinite_ammo();
	
	eVolume endon ("breach_abort");
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/
	self.ender = "stop_idle_" + self getentitynumber();
	AInumber = undefined;
	sAnimStart = undefined;
	sAnimIdle = undefined;
	sAnimBreach = undefined;
	sAnimFlash = undefined;
	if (eVolume.hasFirstBreacher)
		AInumber = "02";
	else
	{
		AInumber = "01";
		eVolume.hasFirstBreacher = true;
	}
	
	switch (sBreachType)
	{
		case "explosive_breach_left":
			sAnimStart = "detcord_stack_left_start_" + AInumber;
			sAnimIdle = "detcord_stack_leftidle_" + AInumber;
			sAnimBreach = "detcord_stack_leftbreach_" + AInumber;
			break;		
		case "shotgunhinges_breach_left":
			sAnimStart = "shotgunhinges_breach_left_stack_start_" + AInumber;
			sAnimIdle = "shotgunhinges_breach_left_stack_idle_" + AInumber;
			sAnimBreach = "shotgunhinges_breach_left_stack_breach_" + AInumber;
			break;
		case "flash_breach_no_door_right":
			sAnimStart = "flash_stack_right_start_" + AInumber;
			sAnimIdle = "flash_stack_right_idle_" + AInumber;
			sAnimBreach = "flash_stack_right_breach_" + AInumber;
			if (AInumber == "01")
				sAnimFlash = "flash_stack_right_flash";
			break;
		default:
			assertmsg(sBreachType + " is not a valid breachType");
			break;
	}
	
	/*-----------------------
	AI TO BREACH IDLE
	-------------------------*/
	self breach_set_goaladius (64);
	eVolume.animEnt anim_reach_solo (self, sAnimStart);
	eVolume.animEnt thread anim_loop_solo (self, sAnimIdle, undefined, self.ender);
	self.setGoalPos = self.origin;
	eVolume.breachers ++;
	
	eVolume waittill ("execute_the_breach");
	
	/*-----------------------
	AI FLASHES THE ROOM
	-------------------------*/
	if ( (AInumber == "01") && (isdefined(sAnimFlash)) )
	{
		if (!eVolume.flashthrown)
		{
			eVolume.animEnt notify (self.ender);
			oldGrenadeWeapon = self.grenadeWeapon;
			self.grenadeWeapon = "flash_grenade";
			self.grenadeAmmo++;
			eVolume.animEnt thread anim_single_solo(self, sAnimFlash);
			wait(1);
			self magicgrenade(eVolume.grenadeOrigin.origin, eVolume.grenadeDest.origin, level.iFlashFuse);
			self.grenadeWeapon = oldGrenadeWeapon;
			self.grenadeAmmo = 0;
			self waittillmatch("single anim", "end");
			eVolume.animEnt thread anim_loop_solo (self, sAnimIdle, undefined, self.ender);
			wait (.1);			
		}

		eVolume.readyToPlayAnims = true;
	}

	/*-----------------------
	SECOND AI MUST WAIT FOR SIGNAL TO GO IN
	-------------------------*/	
	if (AInumber == "02")
	{
		while (!eVolume.readyToPlayAnims)
			wait (0.05);
	}	
	/*-----------------------
	PLAY BREACH ANIMS ON BOTH AI
	-------------------------*/	
	eVolume.readyToPlayAnims = true;
	eVolume.animEnt notify (self.ender);
	eVolume.animEnt thread anim_single_solo(self, sAnimBreach);	
	//eVolume.animEnt anim_single_solo(self, sAnimBreach);	
	/*-----------------------
	CONDITIONAL: EXPLOSIVE BREACH
	-------------------------*/	
	if (sBreachType == "explosive_breach_left")
	{
		/*-----------------------
		BLOW THE DOOR
		-------------------------*/		
		if (AInumber == "01")
		{
			self waittillmatch("single anim", "pull fuse");
			wait (1);
			eVolume notify ("spawn_hostiles");
			self waittillmatch("single anim", "explosion");
			eVolume notify ("detpack_detonated");
			eVolume.breached = true;
			eVolume.eDoor thread door_open("explosive", eVolume);
			eVolume notify ("play_breach_fx");
		}
	}

	/*-----------------------
	CONDITIONAL: SHOTGUN BREACH A
	-------------------------*/	
	else if (sBreachType == "shotgunhinges_breach_left")
	{
		/*-----------------------
		SHOOT THE DOOR
		-------------------------*/		
		if (AInumber == "01")
		{
			eVolume notify ("spawn_hostiles");
			self waittillmatch("single anim", "kick");
			eVolume.eDoor thread door_open("shotgun", eVolume);
			eVolume notify ("play_breach_fx");
		}
	}
		
	/*-----------------------
	CONDITIONAL: SHACK BREACH
	-------------------------*/		
	else if (sBreachType == "flash_breach_no_door_right")
	{
		//Nothing conditional to do for this breach yet
	}

	/*-----------------------
	AI FINISHES ENTERING
	-------------------------*/		
	self waittillmatch("single anim", "end");
	eVolume.AIareInTheRoom = true;
	//self setgoalvolume(eVolume);
	self.pushplayer = false;
	self breach_reset_animname();
	
	while (!eVolume.cleared)
		wait (0.05);
	
	self.breaching = false;
}

breach_enemies_stunned(eRoomVolume)
{
	//self ==> the room volume being breached
	self endon ("death");
	eRoomVolume endon ("breach_aborted");
	
	eRoomVolume waittill ("detpack_detonated");
	if ( distance(self.origin, eRoomVolume.animEnt.origin) <= level.detpackStunRadius )
		self setFlashBanged(true, 0.75);
}

breach_trigger_think(eRoomVolume)
{
	//self ==> the trigger 
	eRoomVolume endon ("execute_the_breach");
	eRoomVolume endon ("breach_aborted");
	
	self thread breach_trigger_cleanup(eRoomVolume);
	self maps\_utility::trigger_on();
	if ( (self.classname == "trigger_use") || (self.classname == "trigger_use_touch") )
	{
		self setHintString(eRoomVolume.triggerHintString);
		if (isdefined(eRoomVolume.eDoor))
		{
			//spawn a flashing objective on door frame
			eRoomVolume.eBreachmodel = spawn("script_model", eRoomVolume.eDoor.origin);
			eRoomVolume.eBreachmodel.angles = eRoomVolume.eDoor.angles;
			eRoomVolume.eBreachmodel setmodel(level.door_objmodel);				
		}
	}
	self waittill("trigger");
	eRoomVolume notify ("execute_the_breach");
}

breach_trigger_cleanup(eRoomVolume)
{
	eRoomVolume waittill ("execute_the_breach");
	self maps\_utility::trigger_off();
	if ( isdefined (eRoomVolume.eBreachmodel) )
		eRoomVolume.eBreachmodel delete();
	
}
breach_abort(aBreachers)
{
	//self ==> the room volume being breached
	self endon ("breach_complete");
	self waittill ("breach_abort");
	
	self.cleared = true;
	self thread breach_cleanup(aBreachers);	
}

breach_cleanup(aBreachers)
{
	//self ==> the room volume being breached
	while (!self.cleared)
		wait (0.05);
	
	badplace_delete(self.sBadplaceName);	
	
	while (!self.cleared)
		wait (0.05);

	maps\_utility::array_thread(aBreachers, ::breach_AI_reset, self);
}

breach_AI_reset(eVolume)
{
	self endon ("death");
	
	self breach_reset_animname();
	self breach_reset_goaladius();
	eVolume.animEnt notify (self.ender);
	self notify ("stop_infinite_ammo");
	self.pushplayer = false;
}

breach_play_fx(sBreachType, bPlayDefaultFx)
{
	//self ==> the room volume being breached
	self endon ("breach_aborted");
	self endon ("breach_complete");

	switch (sBreachType)
	{
		case "explosive_breach_left":
			self waittill ("play_breach_fx");
			maps\_utility::exploder(self.iExploderNum);
			thread maps\_utility::play_sound_in_space(level.scr_sound["breach_wooden_door"], self.eExploderOrigin.origin);
			if (bPlayDefaultFx)
				playfx(level._effect["_breach_doorbreach_detpack"], self.eExploderOrigin.origin, anglestoforward(self.eExploderOrigin.angles));
			break;
		case "shotgunhinges_breach_left":
			self waittill ("play_breach_fx");
			maps\_utility::exploder(self.iExploderNum);
			if (bPlayDefaultFx)
				playfx(level._effect["_breach_doorbreach_kick"], self.eExploderOrigin.origin, anglestoforward(self.eExploderOrigin.angles));			
			break;		
		case "flash_breach_no_door_right":
			//no effects since there is no door
			break;
		default:
			assertmsg(sBreachType + " is not a valid breachType");
			break;
	}
}


/****************************************************************************
    BREACH UTILITY FUNCTIONS
****************************************************************************/

sounds_and_fx()
{
	level._effect["_breach_doorbreach_detpack"] 	= loadfx ("explosions/exp_pack_doorbreach");
	level._effect["_breach_doorbreach_kick"] 		= loadfx ("explosions/grenadeExp_wood");
	
	level.scr_sound["breach_wooden_door"] 		= "detpack_explo_main";
	level.scr_sound["breach_wood_door_kick"] 	= "wood_door_kick";	
}

spawnHostile(eEntToSpawn)
{
	spawnedGuy = eEntToSpawn dospawn();
	maps\_utility::spawn_failed( spawnedGuy );
	assert( isDefined( spawnedGuy ) );
	return spawnedGuy;
}

spawnBreachHostiles(arrayToSpawn)
{
	assertEx((arrayToSpawn.size > 0), "The array passed to spawnBreachHostiles function is empty");
	spawnedGuys = [];
	for (i=0;i<arrayToSpawn.size;i++)
	{
		guy = spawnHostile(arrayToSpawn[i]);
		spawnedGuys[spawnedGuys.size] = guy;
		
	}
	//check to ensure all the guys were spawned
	assertEx((arrayToSpawn.size == spawnedGuys.size), "Not all guys were spawned successfully from spawnBreachHostiles");
	
	//Return an array containing all the spawned guys
	return spawnedGuys;
}

give_infinite_ammo()
{
	self endon ("death");
	self endon ("stop_infinite_ammo");
	while (true)
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
		wait(.5);
	}
}

door_open(sType, eVolume, bPlaySound)
{
	if (!isDefined(bPlaySound))
		bPlaySound = true;
		
	if (bPlaysound == true)
		self playsound (level.scr_sound["breach_wood_door_kick"]);

	
	switch(sType)
	{
		case "explosive":
			self thread door_fall_over(eVolume.animEnt);
			self door_connectpaths();
			self playsound (level.scr_sound["breach_wooden_door"]);
			earthquake (0.4, 1, self.origin, 1000);
			radiusdamage(self.origin, 56, level.maxDetpackDamage, level.minDetpackDamage);
			break;
		case "shotgun":
			self thread door_fall_over(eVolume.animEnt);
			self door_connectpaths();
			self playsound (level.scr_sound["breach_wooden_door"]);
			break;
	}
}

door_connectpaths()
{

	if (self.classname == "script_brushmodel")
		self connectpaths();
	else
	{
		blocker = getent(self.target, "targetname");
		assertex( isdefined(blocker), "A script_model door needs to target a script_brushmodel that blocks the door.");
		blocker hide();
		blocker notsolid();
		blocker connectpaths();	
	}
}

door_fall_over(animEnt)
{
	assert(isdefined(animEnt));
	vector = undefined;
	if (self.classname == "script_model")
		vector = anglestoforward(self.angles);
	else if (self.classname == "script_brushmodel")
		vector = self.vector;
	else
		assertmsg("door needs to be either a script_model or a script_brushmodel");
	dist = (vector[0] * 20, vector[1] * 20, vector[2] * 20);

	self moveto(self.origin + dist, .5, 0 , .5);
	
	rotationDummy = spawn( "script_origin", ( 0, 0, 0 ) );
	rotationDummy.angles = animEnt.angles;
	rotationDummy.origin = ( self.origin[0], self.origin[1], animEnt.origin[2] );
	
	self linkTo( rotationDummy );
	
	rotationDummy rotatepitch(90, 0.45, 0.40);
	wait 0.449;
	rotationDummy rotatepitch(-4, 0.2, 0, 0.2);
	wait 0.2;
	rotationDummy rotatepitch(4, 0.15, 0.15);
	wait 0.15;
	self unlink();
	rotationDummy delete();
}

breach_set_goaladius(fRadius)
{
	if ( !isdefined( self.old_goalradius ) )
		self.old_goalradius = self.goalradius;
	self.goalradius = fRadius;
}

breach_reset_goaladius()
{
	if ( isdefined( self.old_goalradius ) )
		self.goalradius = self.old_goalradius;
	self.old_goalradius = undefined;
}


breach_set_animname(animname)
{
		if ( !isdefined( self.old_animname ) )
			self.old_animname = self.animname;
		self.animname = animname;
}

breach_reset_animname()
{
		if ( isdefined( self.old_animname ) )
			self.animname = self.old_animname;
		self.old_animname = undefined;
}

anims_breach()
{
	/*-----------------------
	EXPLOSIVE BREACH (LEFT SIDE)
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "detcord_stack_left_start_01" ]		= %explosivebreach_v1_detcord_idle;
	level.scr_anim[ "frnd" ][ "detcord_stack_left_start_02" ]		= %explosivebreach_v1_stackL_idle;	
	
	level.scr_anim[ "frnd" ][ "detcord_stack_leftidle_01" ][0]		= %explosivebreach_v1_detcord_idle;
	level.scr_anim[ "frnd" ][ "detcord_stack_leftidle_02" ][0]		= %explosivebreach_v1_stackL_idle;
	
	level.scr_anim[ "frnd" ][ "detcord_stack_leftbreach_01" ]		= %explosivebreach_v1_detcord;
	level.scr_anim[ "frnd" ][ "detcord_stack_leftbreach_02" ]		= %explosivebreach_v1_stackL;

	// animated door breach ==> shotgunbreach_v1_shoot_hinge_door
	
	/*-----------------------
	SHOTGUN BREACH A (HINGE SHOOT #1)
	-------------------------*/	
	
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_start_01" ]			= %breach_sh_breacherL1_idle;
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_start_02" ]			= %breach_sh_stackR1_idle;	
	
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_idle_01" ][0]			= %breach_sh_breacherL1_idle;
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_idle_02" ][0]			= %breach_sh_stackR1_idle;
	
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_breach_01" ]			= %breach_sh_breacherL1_enter;
	level.scr_anim[ "frnd" ][ "shotgunhinges_breach_left_stack_breach_02" ]			= %breach_sh_stackR1_enter;

	// animated door breach ==> breach_sh_door
	
	/*-----------------------
	NO DOOR, FLASH ONLY BREACH (RIGHT SIDE)
	-------------------------*/	
	level.scr_anim[ "frnd" ][ "flash_stack_right_start_01" ]		= %test_breach_R_idle;
	level.scr_anim[ "frnd" ][ "flash_stack_right_start_02" ]		= %test_breach_R2_idle;	
	
	level.scr_anim[ "frnd" ][ "flash_stack_right_idle_01" ][0]		= %test_breach_R_idle;
	level.scr_anim[ "frnd" ][ "flash_stack_right_idle_02" ][0]		= %test_breach_R2_idle;
	
	level.scr_anim[ "frnd" ][ "flash_stack_right_flash" ]			= %test_breach_R_flashbang;
	
	level.scr_anim[ "frnd" ][ "flash_stack_right_breach_01" ]		= %test_breach_R_enter;
	level.scr_anim[ "frnd" ][ "flash_stack_right_breach_02" ]		= %test_breach_R2_enter;

}

//#using_animtree( "door" );
//anims_door()
//{
//	level.scr_anim[ "door" ][ "door_breach" ] = 	%shotgunbreach_v1_shoot_hinge_door;
//	level.scr_animtree[ "door" ] = #animtree;	
//	level.scr_model[ "door" ] = "com_door_01_handleright";
//	precachemodel( level.scr_model[ "door" ] );
//}