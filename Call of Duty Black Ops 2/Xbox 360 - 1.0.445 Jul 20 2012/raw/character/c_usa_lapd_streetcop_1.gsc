// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_usa_lapd_streetcop_body");
	self.headModel = "c_usa_lapd_streetcop_head1";
	self attach(self.headModel, "", true);
	self.hatModel = "c_usa_lapd_streetcop_head1_gear";
	self attach(self.hatModel);
	self.gearModel = "c_usa_lapd_streetcop_gear";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_usa_lapd_streetcop_body");
	precacheModel("c_usa_lapd_streetcop_head1");
	precacheModel("c_usa_lapd_streetcop_head1_gear");
	precacheModel("c_usa_lapd_streetcop_gear");
}
