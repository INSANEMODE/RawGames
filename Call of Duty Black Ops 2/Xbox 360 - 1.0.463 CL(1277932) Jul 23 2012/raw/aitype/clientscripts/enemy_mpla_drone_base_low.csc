// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_afr_mpla_rigid_drone::main();
	self._aitype = "Enemy_MPLA_Drone_Base_Low";
}

precache(ai_index)
{
	character\clientscripts\c_afr_mpla_rigid_drone::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}
