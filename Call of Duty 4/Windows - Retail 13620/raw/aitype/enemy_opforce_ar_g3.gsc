// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_opforce_AR_g3 (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
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
	self.weapon = "g3";
	self.secondaryweapon = "beretta";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 128.000000, 0.000000 );
	self setEngagementMaxDist( 512.000000, 1024.000000 );

	switch( codescripts\character::get_random_character(8) )
	{
	case 0:
		character\character_sp_opforce_b::main();
		break;
	case 1:
		character\character_sp_opforce_c::main();
		break;
	case 2:
		character\character_sp_opforce_d::main();
		break;
	case 3:
		character\character_sp_opforce_e::main();
		break;
	case 4:
		character\character_sp_opforce_f::main();
		break;
	case 5:
		character\character_sp_opforce_collins::main();
		break;
	case 6:
		character\character_sp_opforce_geoff::main();
		break;
	case 7:
		character\character_sp_opforce_derik::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_sp_opforce_b::precache();
	character\character_sp_opforce_c::precache();
	character\character_sp_opforce_d::precache();
	character\character_sp_opforce_e::precache();
	character\character_sp_opforce_f::precache();
	character\character_sp_opforce_collins::precache();
	character\character_sp_opforce_geoff::precache();
	character\character_sp_opforce_derik::precache();

	precacheItem("g3");
	precacheItem("beretta");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
