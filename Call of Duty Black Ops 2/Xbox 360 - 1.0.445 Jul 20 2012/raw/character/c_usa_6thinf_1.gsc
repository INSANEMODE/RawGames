// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_usa_6thinf_1_body");
	self.headModel = "c_usa_6thinf_1_head";
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_usa_6thinf_1_body");
	precacheModel("c_usa_6thinf_1_head");
}
