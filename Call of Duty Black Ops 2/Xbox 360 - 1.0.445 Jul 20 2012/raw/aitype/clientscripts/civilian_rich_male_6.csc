// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_civ_generic_male_11::main();
			break;
		case 1:
			character\clientscripts\c_mul_civ_generic_male_12::main();
			break;
	}

	self._aitype = "Civilian_Rich_Male_6";
}

precache(ai_index)
{
	character\clientscripts\c_mul_civ_generic_male_11::precache();
	character\clientscripts\c_mul_civ_generic_male_12::precache();

	UseFootstepTable(ai_index, "fly_step_civm");
}
