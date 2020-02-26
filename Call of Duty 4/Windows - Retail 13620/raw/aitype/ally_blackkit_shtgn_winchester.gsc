// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_blackkit_SHTGN_winchester (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="body_complete_sp_sas_ct_benjamin"
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
	self.weapon = "winchester1200";
	self.secondaryweapon = "usp";
	self.sidearm = "usp";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	switch( codescripts\character::get_random_character(5) )
	{
	case 0:
		character\character_sp_sas_ct_benjamin::main();
		break;
	case 1:
		character\character_sp_sas_ct_charles::main();
		break;
	case 2:
		character\character_sp_sas_ct_mitchel::main();
		break;
	case 3:
		character\character_sp_sas_ct_neal::main();
		break;
	case 4:
		character\character_sp_sas_ct_william::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_sp_sas_ct_benjamin::precache();
	character\character_sp_sas_ct_charles::precache();
	character\character_sp_sas_ct_mitchel::precache();
	character\character_sp_sas_ct_neal::precache();
	character\character_sp_sas_ct_william::precache();

	precacheItem("winchester1200");
	precacheItem("usp");
	precacheItem("usp");
	precacheItem("fraggrenade");
}
