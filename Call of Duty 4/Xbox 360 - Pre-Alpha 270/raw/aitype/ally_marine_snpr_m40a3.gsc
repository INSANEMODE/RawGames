// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_marine_SNPR_m40a3 (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_complete_sp_usmc_zach"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.team = "allies";
	self.type = "human";
	self.accuracy = 0.2;
	self.health = 150;
	self.weapon = "m40a3";
	self.secondaryweapon = "colt45";
	self.sidearm = "colt45";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	character\character_sp_usmc_zach::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_sp_usmc_zach::precache();

	precacheItem("m40a3");
	precacheItem("colt45");
	precacheItem("colt45");
	precacheItem("fraggrenade");
}
