// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_rus_afghan_spetsnaz::main();
			break;
		case 1:
			character\clientscripts\c_rus_afghan_spetsnaz_2::main();
			break;
	}

	self._aitype = "Enemy_Soviet_Afghan_Sniper_Base";
}

precache(ai_index)
{
	character\clientscripts\c_rus_afghan_spetsnaz::precache();
	character\clientscripts\c_rus_afghan_spetsnaz_2::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
