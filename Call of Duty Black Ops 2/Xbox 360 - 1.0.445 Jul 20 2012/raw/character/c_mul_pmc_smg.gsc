// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_mul_pmc_assault_body");
	self.headModel = "c_mul_pmc_smg_head";
	self attach(self.headModel, "", true);
	self.gearModel = "c_mul_pmc_smg_gear";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_mul_pmc_assault_body");
	precacheModel("c_mul_pmc_smg_head");
	precacheModel("c_mul_pmc_smg_gear");
}
