// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_rus_kravchenko_jacket_bandolier::main();
	self._aitype = "Hero_Farid_Blackout";
}

precache(ai_index)
{
	character\clientscripts\c_rus_kravchenko_jacket_bandolier::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
