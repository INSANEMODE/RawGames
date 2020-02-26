// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_Civilian_Rich_Male_1 (0.5 0.5 0.5) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_usa_pent_male_worker_body"
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
	self.accuracy = 0.2;
	self.animTree = "generic_human.atr";
	self.csvInclude = "common_civilians.csv";
	self.grenadeAmmo = 0;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.subclass = "regular";
	self.team = "neutral";
	self.type = "human";
	self.weapon = "";

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	switch( codescripts\character::get_random_character(2) )
	{
	case 0:
		character\c_mul_civ_generic_male_1::main();
		break;
	case 1:
		character\c_mul_civ_generic_male_2::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\c_mul_civ_generic_male_1::precache();
	character\c_mul_civ_generic_male_2::precache();

	precacheItem("frag_grenade_sp");
}
