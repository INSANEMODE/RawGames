// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_enemy_merc_AR (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_airborne_assault_a"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
PERFECTENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
DONTSHAREENEMYINFO -- do not get shared info about enemies at spawn time from teammates
*/
main()
{
	self.animTree = "";
	self.additionalAssets = "";
	self.team = "axis";
	self.type = "human";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 150;
	self.secondaryweapon = "";
	self.sidearm = "glock";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	switch( codescripts\character::get_random_weapon(15) )
	{
	case 0:
		self.weapon = "ak47_woodland";
		break;
	case 1:
		self.weapon = "ak47_digital_reflex";
		break;
	case 2:
		self.weapon = "ak47_woodland_grenadier";
		break;
	case 3:
		self.weapon = "ak47_digital_acog";
		break;
	case 4:
		self.weapon = "ak47_woodland_eotech";
		break;
	case 5:
		self.weapon = "famas_woodland";
		break;
	case 6:
		self.weapon = "tavor_woodland_acog";
		break;
	case 7:
		self.weapon = "tavor_mars";
		break;
	case 8:
		self.weapon = "tavor_woodland_eotech";
		break;
	case 9:
		self.weapon = "tavor_reflex";
		break;
	case 10:
		self.weapon = "fn2000_eotech";
		break;
	case 11:
		self.weapon = "famas_woodland_reflex";
		break;
	case 12:
		self.weapon = "fn2000_reflex";
		break;
	case 13:
		self.weapon = "famas_woodland_eotech";
		break;
	case 14:
		self.weapon = "fn2000_acog";
		break;
	}

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\character_opforce_merc_assault_a::main();
		break;
	case 1:
		character\character_opforce_merc_assault_b::main();
		break;
	case 2:
		character\character_opforce_merc_assault_c::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_opforce_merc_assault_a::precache();
	character\character_opforce_merc_assault_b::precache();
	character\character_opforce_merc_assault_c::precache();

	precacheItem("ak47_woodland");
	precacheItem("ak47_digital_reflex");
	precacheItem("ak47_woodland_grenadier");
	precacheItem("gl_ak47_woodland");
	precacheItem("ak47_digital_acog");
	precacheItem("ak47_woodland_eotech");
	precacheItem("famas_woodland");
	precacheItem("tavor_woodland_acog");
	precacheItem("tavor_mars");
	precacheItem("tavor_woodland_eotech");
	precacheItem("tavor_reflex");
	precacheItem("fn2000_eotech");
	precacheItem("famas_woodland_reflex");
	precacheItem("fn2000_reflex");
	precacheItem("famas_woodland_eotech");
	precacheItem("fn2000_acog");
	precacheItem("glock");
	precacheItem("fraggrenade");
}
