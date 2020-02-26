// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_villain_sonofzakhaev (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_complete_sp_sonofzakhaev"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 0.2;
	self.health = 150;
	self.weapon = "uzi_sd";
	self.secondaryweapon = "colt45";
	self.sidearm = "colt45";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 128.000000, 0.000000 );
	self setEngagementMaxDist( 512.000000, 1024.000000 );

	character\character_sp_zakhaevs_son::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_sp_zakhaevs_son::precache();

	precacheItem("uzi_sd");
	precacheItem("colt45");
	precacheItem("colt45");
	precacheItem("fraggrenade");
}
