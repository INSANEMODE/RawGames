// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_cia_combat_harper_cin::main();
	self._aitype = "Hero_Harper_Blackout";
}

precache(ai_index)
{
	character\clientscripts\c_usa_cia_combat_harper_cin::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
