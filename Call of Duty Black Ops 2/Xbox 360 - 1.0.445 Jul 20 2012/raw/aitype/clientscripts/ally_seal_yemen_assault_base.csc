// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_usa_future_seal_1::main();
			break;
		case 1:
			character\clientscripts\c_usa_future_seal_2::main();
			break;
	}

	self._aitype = "Ally_SEAL_Yemen_Assault_Base";
}

precache(ai_index)
{
	character\clientscripts\c_usa_future_seal_1::precache();
	character\clientscripts\c_usa_future_seal_2::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
