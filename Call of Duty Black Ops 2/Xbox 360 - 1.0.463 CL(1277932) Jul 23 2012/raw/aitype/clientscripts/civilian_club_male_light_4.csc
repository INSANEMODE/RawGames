// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_civ_club_male_light11::main();
			break;
		case 1:
			character\clientscripts\c_mul_civ_club_male_light12::main();
			break;
	}

	self._aitype = "Civilian_Club_Male_Light_4";
}

precache(ai_index)
{
	character\clientscripts\c_mul_civ_club_male_light11::precache();
	character\clientscripts\c_mul_civ_club_male_light12::precache();

	UseFootstepTable(ai_index, "fly_step_civm");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
