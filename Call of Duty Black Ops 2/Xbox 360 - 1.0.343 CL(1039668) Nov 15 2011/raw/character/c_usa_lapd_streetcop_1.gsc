// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_usa_lapd_streetcop_body");
	self.headModel = "c_usa_lapd_streetcop_head1";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_usa_lapd_streetcop_body");
	precacheModel("c_usa_lapd_streetcop_head1");
}
