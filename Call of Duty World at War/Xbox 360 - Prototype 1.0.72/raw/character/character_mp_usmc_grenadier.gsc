// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_mp_usmc_grenadier");
	self attach("head_mp_usmc_tactical_mich", "", true);
	self setViewmodel("viewmodel_base_viewhands");
	self.voice = "american";
}

precache()
{
	precacheModel("body_mp_usmc_grenadier");
	precacheModel("head_mp_usmc_tactical_mich");
	precacheModel("viewmodel_base_viewhands");
}
