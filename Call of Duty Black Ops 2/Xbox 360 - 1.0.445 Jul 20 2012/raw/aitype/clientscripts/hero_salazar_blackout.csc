// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_unioninsp_salazar_cin::main();
	self._aitype = "Hero_Salazar_Blackout";
}

precache(ai_index)
{
	character\clientscripts\c_usa_unioninsp_salazar_cin::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
