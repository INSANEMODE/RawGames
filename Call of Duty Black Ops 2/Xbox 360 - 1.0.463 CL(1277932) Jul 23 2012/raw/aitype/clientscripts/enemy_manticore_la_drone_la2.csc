// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_mul_pmc_drone_1::main();
	self._aitype = "Enemy_Manticore_LA_Drone_LA2";
}

precache(ai_index)
{
	character\clientscripts\c_mul_pmc_drone_1::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
