

main()
{
	self.animTree = "";
	self.AiCoreId = "Soldier";
	self.AiAlsId = "Thug";
	self.gdt_combatrole = "";
	self.team = "axis";
	self.type = "human";
	self.accuracy = 1;
	self.health = 80;
	self.weapon = "M14_SCa";
	self.secondaryweapon = "";
	self.sidearm = "1911";
	self.grenadeWeapon = "";
	self.grenadeAmmo = 0;

	self setEngagementMinDist( 256.000000, 0.000000 );
	self setEngagementMaxDist( 768.000000, 1024.000000 );

	self maps\_new_battlechatter::init_aiBattleChatter();

	character\character_dimitrios::main();
}

spawner()
{
	self setspawnerteam("axis");
}

precache()
{
	character\character_dimitrios::precache();

	precacheItem("M14_SCa");
	precacheItem("1911");
}
