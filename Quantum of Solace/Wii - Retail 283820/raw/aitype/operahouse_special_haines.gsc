

main()
{
	self.animTree = "";
	self.AiCoreId = "Civilian";
	self.AiAlsId = "CivilianMale";
	self.gdt_combatrole = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "Mk3LLD_Opera_s";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_mr_white::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_mr_white::precache();

	precacheItem("Mk3LLD_Opera_s");
	precacheItem("Mk3LLD_Opera");
	precacheItem("1911");
}
