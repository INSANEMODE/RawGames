// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_secserv_swat_tactical::main();
	self._aitype = "Ally_SWAT_Assault_Intro";
}

precache(ai_index)
{
	character\clientscripts\c_usa_secserv_swat_tactical::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
