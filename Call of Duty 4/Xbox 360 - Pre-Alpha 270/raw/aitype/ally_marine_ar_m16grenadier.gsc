// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_marine_AR_m16grenadier (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
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
	self.weapon = "m16_grenadier";
	self.secondaryweapon = "colt45";
	self.sidearm = "colt45";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	switch(randomint(3))
	{
	case 0:
		character\character_sp_usmc_at4::main();
		break;
	case 1:
		character\character_sp_usmc_sami::main();
		break;
	case 2:
		character\character_sp_usmc_zach_goggles::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_sp_usmc_at4::precache();
	character\character_sp_usmc_sami::precache();
	character\character_sp_usmc_zach_goggles::precache();

	precacheItem("m16_grenadier");
	precacheItem("colt45");
	precacheItem("colt45");
	precacheItem("fraggrenade");
}
