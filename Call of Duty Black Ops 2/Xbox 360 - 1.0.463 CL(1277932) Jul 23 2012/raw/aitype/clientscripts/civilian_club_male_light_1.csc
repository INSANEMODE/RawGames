// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_civ_club_male_light1::main();
			break;
		case 1:
			character\clientscripts\c_mul_civ_club_male_light4::main();
			break;
		case 2:
			character\clientscripts\c_mul_civ_club_male_light5::main();
			break;
	}

	self._aitype = "Civilian_Club_Male_Light_1";
}

precache(ai_index)
{
	character\clientscripts\c_mul_civ_club_male_light1::precache();
	character\clientscripts\c_mul_civ_club_male_light4::precache();
	character\clientscripts\c_mul_civ_club_male_light5::precache();

	UseFootstepTable(ai_index, "fly_step_civm");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
