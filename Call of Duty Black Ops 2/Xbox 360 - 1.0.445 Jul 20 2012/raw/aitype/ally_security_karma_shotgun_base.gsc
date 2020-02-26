// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Ally_Security_Karma_Shotgun_Base (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_usa_jungmar_1_fb"
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
	self.accuracy = 1;
	self.animStateDef = "";
	self.animTree = "";
	self.csvInclude = "";
	self.demoLockOnHighlightDistance = 100;
	self.demoLockOnViewHeightOffset1 = 8;
	self.demoLockOnViewHeightOffset2 = 8;
	self.demoLockOnViewPitchMax1 = 60;
	self.demoLockOnViewPitchMax2 = 60;
	self.demoLockOnViewPitchMin1 = 0;
	self.demoLockOnViewPitchMin2 = 0;
	self.footstepFXTable = "";
	self.footstepPrepend = "";
	self.footstepScriptCallback = 0;
	self.grenadeAmmo = 0;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "beretta93r_sf_sp";
	self.subclass = "regular";
	self.team = "allies";
	self.type = "human";
	self.weapon = "ns2000_sp";

	self setEngagementMinDist( 50.000000, 0.000000 );
	self setEngagementMaxDist( 500.000000, 1000.000000 );

	character\c_mul_jinan_guard::main();
	self SetCharacterIndex(0);
}

spawner()
{
	self setspawnerteam("allies");
}

precache(ai_index)
{
	character\c_mul_jinan_guard::precache();

	precacheItem("ns2000_sp");
	precacheItem("beretta93r_sf_sp");
	precacheItem("frag_grenade_sp");
}
