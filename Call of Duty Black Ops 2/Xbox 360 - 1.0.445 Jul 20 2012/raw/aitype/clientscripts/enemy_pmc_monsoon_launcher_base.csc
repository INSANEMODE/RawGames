// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_mul_pmc_assault_frst::main();
	self._aitype = "Enemy_PMC_Monsoon_Launcher_Base";
}

precache(ai_index)
{
	character\clientscripts\c_mul_pmc_assault_frst::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
