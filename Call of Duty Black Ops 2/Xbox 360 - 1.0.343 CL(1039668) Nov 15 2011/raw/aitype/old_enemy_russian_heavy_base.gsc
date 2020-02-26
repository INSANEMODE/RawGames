// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_OLD_Enemy_Russian_Heavy_Base (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_rus_spetznaz_assault_fb"
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
	self.accuracy = 1;
	self.animTree = "";
	self.csvInclude = "";
	self.grenadeAmmo = 2;
	self.grenadeWeapon = "frag_grenade_sp";
	self.health = 150;
	self.precacheScript = "";
	self.secondaryweapon = "ak47_sp";
	self.sidearm = "makarov_sp";
	self.team = "axis";
	self.type = "human";
	self.weapon = "rpg_sp";

	self setEngagementMinDist( 700.000000, 500.000000 );
	self setEngagementMaxDist( 1000.000000, 1500.000000 );

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\c_rus_military1_char::main();
		break;
	case 1:
		character\c_rus_military2_char::main();
		break;
	case 2:
		character\c_rus_military3_char::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\c_rus_military1_char::precache();
	character\c_rus_military2_char::precache();
	character\c_rus_military3_char::precache();

	precacheItem("rpg_sp");
	precacheItem("ak47_sp");
	precacheItem("makarov_sp");
	precacheItem("frag_grenade_sp");
}
