// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_us_raid_makin_mitch (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="char_usa_marine_fullbody1"
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
	self.health = 100;
	self.weapon = "thompson";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 3;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	character\char_usa_marine_h_pow::main();
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\char_usa_marine_h_pow::precache();

	precacheItem("thompson");
	precacheItem("fraggrenade");
}
