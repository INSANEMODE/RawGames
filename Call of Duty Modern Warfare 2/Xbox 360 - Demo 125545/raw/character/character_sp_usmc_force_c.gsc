// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_sp_usmc_force_c");
	self attach("head_sp_usmc_force_nomex", "", true);
	self.headModel = "head_sp_usmc_force_nomex";
	self.voice = "american";
}

precache()
{
	precacheModel("body_sp_usmc_force_c");
	precacheModel("head_sp_usmc_force_nomex");
}
