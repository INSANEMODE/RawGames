// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_jungmar_hudson::main();
	self._aitype = "Hero_Hudson_Angola";
}

precache(ai_index)
{
	character\clientscripts\c_usa_jungmar_hudson::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
