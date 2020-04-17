// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_eco-hotel_enemy_A3Raker (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="fisher_complete"
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
	self.weapon = "A3Raker_Eco";
	self.secondaryweapon = "";
	self.sidearm = "p99";
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

	if( !isdefined( level.aitypenext ) )
	{
		level.aitypenext = [];
	}

	if( !isdefined( level.aitypenext["eco-hotel_enemy_A3Raker_Head"] ) )
	{
		startIndex = randomint( 4 );
		level.aitypenext["eco-hotel_enemy_A3Raker_Head"] = startIndex;
	}
	level.aitypenext["eco-hotel_enemy_A3Raker_Head"] += 1;
	if( level.aitypenext["eco-hotel_enemy_A3Raker_Head"] >= 4 )
		level.aitypenext["eco-hotel_enemy_A3Raker_Head"] = 0;

	character = level.aitypenext["eco-hotel_enemy_A3Raker_Head"];
	if(( character >= 4 ) || (character < 0) )
		character = randomint(4);

	switch( character )
	{
	case 0:
		character\character_soldier_1_eco::main();
		break;
	case 1:
		character\character_soldier_2_eco::main();
		break;
	case 2:
		character\character_soldier_3_eco::main();
		break;
	case 3:
		character\character_soldier_4_eco::main();
		break;
	default:
		assertmsg( "Character Head Problem, tell MikeA" );
		break;
	}
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_soldier_1_eco::precache();
	character\character_soldier_2_eco::precache();
	character\character_soldier_3_eco::precache();
	character\character_soldier_4_eco::precache();

	precacheItem("A3Raker_Eco");
	precacheItem("p99");
	precacheItem("concussion_grenade");
}
