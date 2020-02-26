// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_So_Enemy_Easy (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER MAKEROOM UNDELETABLE ENEMYINFO SCRIPT_FORCESPAWN SM_PRIORITY
defaultmdl="c_vtn_vc1_body"
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
	self.health = 100;
	self.precacheScript = "";
	self.secondaryweapon = "";
	self.sidearm = "makarov_sp";
	self.subclass = "regular";
	self.team = "axis";
	self.type = "human";
	self.weapon = "spas_sp";

	self setEngagementMinDist( 250.000000, 0.000000 );
	self setEngagementMaxDist( 700.000000, 1000.000000 );

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\c_pan_pdf_light::main();
		break;
	case 1:
		character\c_pan_pdf_medium::main();
		break;
	case 2:
		character\c_pan_pdf_heavy::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\c_pan_pdf_light::precache();
	character\c_pan_pdf_medium::precache();
	character\c_pan_pdf_heavy::precache();

	precacheItem("spas_sp");
	precacheItem("makarov_sp");
	precacheItem("frag_grenade_sp");
}
