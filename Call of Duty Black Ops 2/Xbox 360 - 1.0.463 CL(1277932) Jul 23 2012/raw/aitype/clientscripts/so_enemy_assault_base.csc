// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_pmc_assault::main();
			break;
		case 1:
			character\clientscripts\c_mul_pmc_assault_2::main();
			break;
		case 2:
			character\clientscripts\c_mul_pmc_assault_3::main();
			break;
	}

	self._aitype = "So_Enemy_Assault_Base";
}

precache(ai_index)
{
	character\clientscripts\c_mul_pmc_assault::precache();
	character\clientscripts\c_mul_pmc_assault_2::precache();
	character\clientscripts\c_mul_pmc_assault_3::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
