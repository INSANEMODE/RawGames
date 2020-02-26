// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_ally_tf_141_arctic_AR (0.0 0.25 1.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE PERFECTENEMYINFO DONTSHAREENEMYINFO
defaultmdl="body_tf141_assault_a"
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
	self.team = "allies";
	self.type = "human";
	self.subclass = "regular";
	self.accuracy = 0.2;
	self.health = 100;
	self.secondaryweapon = "";
	self.sidearm = "beretta";
	self.grenadeWeapon = "fraggrenade";
	self.grenadeAmmo = 0;

	if ( isAI( self ) )
	{
		self setEngagementMinDist( 256.000000, 0.000000 );
		self setEngagementMaxDist( 768.000000, 1024.000000 );
	}

	switch( codescripts\character::get_random_weapon(17) )
	{
	case 0:
		self.weapon = "m4_grenadier";
		break;
	case 1:
		self.weapon = "m4_grunt";
		break;
	case 2:
		self.weapon = "m4m203_acog";
		break;
	case 3:
		self.weapon = "m4m203_eotech";
		break;
	case 4:
		self.weapon = "m4m203_reflex";
		break;
	case 5:
		self.weapon = "tavor_acog";
		break;
	case 6:
		self.weapon = "tavor_mars";
		break;
	case 7:
		self.weapon = "m16_acog";
		break;
	case 8:
		self.weapon = "m16_grenadier";
		break;
	case 9:
		self.weapon = "m16_reflex";
		break;
	case 10:
		self.weapon = "masada";
		break;
	case 11:
		self.weapon = "masada_acog";
		break;
	case 12:
		self.weapon = "masada_reflex";
		break;
	case 13:
		self.weapon = "scar_h";
		break;
	case 14:
		self.weapon = "scar_h_acog";
		break;
	case 15:
		self.weapon = "scar_h_reflex";
		break;
	case 16:
		self.weapon = "scar_h_shotgun";
		break;
	}

	switch( codescripts\character::get_random_character(3) )
	{
	case 0:
		character\character_tf_141_arctic_assault_a::main();
		break;
	case 1:
		character\character_tf_141_arctic_assault_b::main();
		break;
	case 2:
		character\character_tf_141_arctic_shotgun::main();
		break;
	}
}

spawner()
{
	self setspawnerteam("allies");
}

precache()
{
	character\character_tf_141_arctic_assault_a::precache();
	character\character_tf_141_arctic_assault_b::precache();
	character\character_tf_141_arctic_shotgun::precache();

	precacheItem("m4_grenadier");
	precacheItem("m203_m4");
	precacheItem("m4_grunt");
	precacheItem("m4m203_acog");
	precacheItem("m203_m4_acog");
	precacheItem("m4m203_eotech");
	precacheItem("m203_m4_eotech");
	precacheItem("m4m203_reflex");
	precacheItem("m203_m4_reflex");
	precacheItem("tavor_acog");
	precacheItem("tavor_mars");
	precacheItem("m16_acog");
	precacheItem("m16_grenadier");
	precacheItem("m203");
	precacheItem("m16_reflex");
	precacheItem("masada");
	precacheItem("masada_acog");
	precacheItem("masada_reflex");
	precacheItem("scar_h");
	precacheItem("scar_h_acog");
	precacheItem("scar_h_reflex");
	precacheItem("scar_h_shotgun");
	precacheItem("scar_h_shotgun_attach");
	precacheItem("beretta");
	precacheItem("fraggrenade");
}
