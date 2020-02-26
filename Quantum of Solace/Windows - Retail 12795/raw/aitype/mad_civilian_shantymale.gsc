// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
/*QUAKED actor_MAD_civilian_shantymale (0.5 0.5 0.5) (-16 -16 0) (16 16 72) SPAWNER FORCESPAWN UNDELETABLE ENEMYINFO
defaultmdl="shanty_thug_body_B1a_A1a"
"count" -- max AI to ever spawn from this spawner
SPAWNER -- makes this a spawner instead of a guy
FORCESPAWN -- will try to delete an AI if spawning fails from too many AI
UNDELETABLE -- this AI (or AI spawned from here) cannot be deleted to make room for FORCESPAWN guys
ENEMYINFO -- this AI when spawned will get a snapshot of perfect info about all enemies
*/
main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "neutral";
	self.type = "human";
	self.health = 100;
	self.weapon = "";
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	//In 007 mode, override to always be 1 accuracy
	if( getdvarint( "level_gameskill" ) > 2 )
	{
		self.accuracy = 1;
	}
	else
	{
		self.accuracy = 0.7;
	}
	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	if( !isdefined( level.aitypenext ) )
	{
		level.aitypenext = [];
	}

	if( !isdefined( level.aitypenext["MAD_civilian_shantymale_Head"] ) )
	{
		startIndex = randomint( 3 );
		level.aitypenext["MAD_civilian_shantymale_Head"] = startIndex;
	}
	level.aitypenext["MAD_civilian_shantymale_Head"] += 1;
	if( level.aitypenext["MAD_civilian_shantymale_Head"] >= 3 )
		level.aitypenext["MAD_civilian_shantymale_Head"] = 0;

	character = level.aitypenext["MAD_civilian_shantymale_Head"];
	if(( character >= 3 ) || (character < 0) )
		character = randomint(3);

	switch( character )
	{
	case 0:
		character\character_civ_1_shanty::main();
		break;
	case 1:
		character\character_civ_2_shanty::main();
		break;
	case 2:
		character\character_civ_3_shanty::main();
		break;
	default:
		assertmsg( "Character Head Problem, tell MikeA" );
		break;
	}
}

spawner()
{
	self setspawnerteam("neutral");
}

precache()
{
	character\character_civ_1_shanty::precache();
	character\character_civ_2_shanty::precache();
	character\character_civ_3_shanty::precache();

}
