// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_OLD_Hero_Reznov_POW (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_rus_reznov_combat_fb"
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
	self.animTree = "";
	self.csvInclude = "char_reznov.csv";
	self.grenadeAmmo = 2;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 150;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "makarov_sp";
	self.team = "allies";
	self.type = "human";
	self.weapon = "ak47_sp";

	self setEngagementMinDist( 250.000000, 0.000000 );
	self setEngagementMaxDist( 700.000000, 1000.000000 );

	character\c_rus_jungmar_pow_reznov::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\c_rus_jungmar_pow_reznov::precache();

	precacheItem("ak47_sp");
	precacheItem("makarov_sp");
	precacheItem("frag_grenade_sp");
}
