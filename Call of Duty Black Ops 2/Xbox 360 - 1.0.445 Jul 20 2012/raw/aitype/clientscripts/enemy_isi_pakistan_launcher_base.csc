// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_vtn_nva1::main();
			break;
		case 1:
			character\clientscripts\c_vtn_nva2::main();
			break;
		case 2:
			character\clientscripts\c_vtn_nva3::main();
			break;
	}

	self._aitype = "Enemy_ISI_Pakistan_Launcher_Base";
}

precache(ai_index)
{
	character\clientscripts\c_vtn_nva1::precache();
	character\clientscripts\c_vtn_nva2::precache();
	character\clientscripts\c_vtn_nva3::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
