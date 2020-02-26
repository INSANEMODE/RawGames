// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_arab_SNPR_dragunov (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
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
	self.weapon = "dragunov";
	self.secondaryweapon = "beretta";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 1250.000000, 1024.000000 );
	self setEngagementMaxDist( 1600.000000, 2400.000000 );

	switch( codescripts\character::get_random_character(6) )
	{
	case 0:
		character\character_sp_arab_regular_asad::main();
		break;
	case 1:
		character\character_sp_arab_regular_sadiq::main();
		break;
	case 2:
		character\character_sp_arab_regular_ski_mask::main();
		break;
	case 3:
		character\character_sp_arab_regular_ski_mask2::main();
		break;
	case 4:
		character\character_sp_arab_regular_suren::main();
		break;
	case 5:
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
	character\character_sp_arab_regular_ski_mask::precache();
	character\character_sp_arab_regular_ski_mask2::precache();
	character\character_sp_arab_regular_suren::precache();
	character\character_sp_arab_regular_yasir::precache();

	precacheItem("dragunov");
	precacheItem("beretta");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
