// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Enemy_Manticore_LA_SMG_Base (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_rus_spetznaz_assault_fb"
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
	self.accuracy = 0.5;
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
	self.grenadeAmmo = 2;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "fiveseven_sp";
	self.subclass = "regular";
	self.team = "axis";
	self.type = "human";
	self.weapon = "vector_sp";

	self setEngagementMinDist( 250.000000, 0.000000 );
	self setEngagementMaxDist( 700.000000, 1000.000000 );

	character\c_mul_pmc_1::main();
	self SetCharacterIndex(0);
}

spawner()
{
	self setspawnerteam("axis");
}

precache(ai_index)
{
	character\c_mul_pmc_1::precache();

	precacheItem("vector_sp");
	precacheItem("fiveseven_sp");
	precacheItem("frag_grenade_sp");
}
