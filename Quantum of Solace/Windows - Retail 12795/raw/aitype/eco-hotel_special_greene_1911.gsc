// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_eco-hotel_special_Greene_1911 (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="greene_complete"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "axis";
	self.type = "human";
	self.health = 100;
	self.weapon = "1911";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "concussion_grenade";
	self.grenadeAmmo = 0;

	//In 007 mode, override to always be 1 accuracy
	if( getdvarint( "level_gameskill" ) > 2 )
	{
		self.accuracy = 1;
	}
	else
	{
		self.accuracy = 1;
	}
	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_greene::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_greene::precache();

	precacheItem("1911");
	precacheItem("1911");
	precacheItem("concussion_grenade");
}
