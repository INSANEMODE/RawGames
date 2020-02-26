// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_arab_AR_ak47 (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_complete_sp_arab_regular_asad"
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
	self.weapon = "ak47";
	self.secondaryweapon = "beretta";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	switch(randomint(5))
	{
	case 0:
		character\character_sp_arab_regular_asad::main();
		break;
	case 1:
		character\character_sp_arab_regular_sadiq::main();
		break;
	case 2:
		character\character_sp_arab_regular_suren::main();
		break;
	case 3:
		character\character_sp_arab_regular_tariq::main();
		break;
	case 4:
		character\character_sp_arab_regular_yasir::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_sp_arab_regular_asad::precache();
	character\character_sp_arab_regular_sadiq::precache();
	character\character_sp_arab_regular_suren::precache();
	character\character_sp_arab_regular_tariq::precache();
	character\character_sp_arab_regular_yasir::precache();

	precacheItem("ak47");
	precacheItem("beretta");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
