// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Civilian_Club_Female_Light_1 (0.5 0.5 0.5) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_usa_hillaryclinton_g20_fb"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
MAKEROOM -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for MAKEROOM guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
SCRIPT_FORCESPAWN -- this AI will spawned even if players can see him spawning.
SM_PRIORITY -- Make the Spawn Manager spawn from this spawner before other spawners.
*/
main()
{
	self.accuracy = 0.2;
	self.animStateDef = "";
	self.animTree = "generic_human.atr";
	self.csvInclude = "common_civilians.csv";
	self.demoLockOnHighlightDistance = 100;
	self.demoLockOnViewHeightOffset1 = 8;
	self.demoLockOnViewHeightOffset2 = 8;
	self.demoLockOnViewPitchMax1 = 60;
	self.demoLockOnViewPitchMax2 = 60;
	self.demoLockOnViewPitchMin1 = 0;
	self.demoLockOnViewPitchMin2 = 0;
	self.footstepFXTable = "";
	self.footstepPrepend = "fly_step_civf";
	self.footstepScriptCallback = 0;
	self.grenadeAmmo = 0;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.subclass = "regular";
	self.team = "neutral";
	self.type = "human";
	self.weapon = "";

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	randChar = codescripts\character::get_random_character(2);

	switch( randChar )
	{
		case 0:
			character\c_mul_civ_club_female_light1::main();
			break;
		case 1:
			character\c_mul_civ_club_female_light10::main();
			break;
	}
	self SetCharacterIndex( randChar );
}

spawner()
{
	self setspawnerteam("neutral");
}

precache(ai_index)
{
	character\c_mul_civ_club_female_light1::precache();
	character\c_mul_civ_club_female_light10::precache();

	precacheItem("frag_grenade_sp");
}
