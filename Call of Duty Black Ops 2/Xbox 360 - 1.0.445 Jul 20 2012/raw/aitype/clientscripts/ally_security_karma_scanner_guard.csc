// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_mul_jinan_guard_bscatter_off::main();
	self._aitype = "Ally_Security_Karma_Scanner_Guard";
}

precache(ai_index)
{
	character\clientscripts\c_mul_jinan_guard_bscatter_off::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
