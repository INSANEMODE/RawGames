// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Ally_LAPD_Bike_Pistol_Base (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_usa_lapd_motocop_fb"
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
	self.csvInclude = "ai_anims_pistol.csv";
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
	self.precacheScript = "aitype_pistol.gsc";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.subclass = "regular";
	self.team = "allies";
	self.type = "human";
	self.weapon = "kard_semiauto_sp";

	self setEngagementMinDist( 250.000000, 0.000000 );
	self setEngagementMaxDist( 700.000000, 1000.000000 );

	character\c_usa_lapd_motocop::main();
	self SetCharacterIndex(0);
}

spawner()
{
	self setspawnerteam("allies");
}

precache(ai_index)
{
	character\c_usa_lapd_motocop::precache();

	precacheItem("kard_semiauto_sp");
	precacheItem("frag_grenade_sp");

	animscripts\aitype\aitype_pistol::precache();
}
