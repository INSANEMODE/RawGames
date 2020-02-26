// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_opforce_SMG_mp5 (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_sp_opforce_b"
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
	self.weapon = "mp5";
	self.secondaryweapon = "beretta";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 0.000000, 0.000000 );
	self setEngagementMaxDist( 256.000000, 512.000000 );

	character\character_sp_opforce_f::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_sp_opforce_f::precache();

	precacheItem("mp5");
	precacheItem("beretta");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
