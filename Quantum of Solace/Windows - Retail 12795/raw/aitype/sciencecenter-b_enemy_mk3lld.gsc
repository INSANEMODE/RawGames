// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_sciencecenter-b_enemy_MK3LLD (1.0 0.25 0.0) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="henchman_b1_h1_complete"
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
	self.weapon = "Mk3LLD_SCb";
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
		self.accuracy = 0.75;
	}
	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	if( !isdefined( level.aitypenext ) )
	{
		level.aitypenext = [];
	}

	if( !isdefined( level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"] ) )
	{
		startIndex = randomint( 4 );
		level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"] = startIndex;
	}
	level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"] += 1;
	if( level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"] >= 4 )
		level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"] = 0;

	character = level.aitypenext["sciencecenter-b_enemy_MK3LLD_Head"];
	if(( character >= 4 ) || (character < 0) )
		character = randomint(4);

	switch( character )
	{
	case 0:
		character\character_thug_1_SC_B::main();
		break;
	case 1:
		character\character_thug_2_SC_B::main();
		break;
	case 2:
		character\character_thug_3_SC_B::main();
		break;
	case 3:
		character\character_thug_4_SC_B::main();
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
	character\character_thug_1_SC_B::precache();
	character\character_thug_2_SC_B::precache();
	character\character_thug_3_SC_B::precache();
	character\character_thug_4_SC_B::precache();

	precacheItem("Mk3LLD_SCb");
	precacheItem("1911");
	precacheItem("concussion_grenade");
}
