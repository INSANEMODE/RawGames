// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_neomarx_la_heavy::main();
			break;
		case 1:
			character\clientscripts\c_vtn_nva3::main();
			break;
	}

	self._aitype = "Enemy_ISI_Pakistan_Juggernaut_LMG";
}

precache(ai_index)
{
	character\clientscripts\c_mul_neomarx_la_heavy::precache();
	character\clientscripts\c_vtn_nva3::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
