// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_usa_secserv_body");
	self.headModel = "c_usa_secserv_head_light";
	self attach(self.headModel, "", true);
	self.gearModel = "c_usa_secserv_gear_light";
	self attach(self.gearModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_usa_secserv_body");
	precacheModel("c_usa_secserv_head_light");
	precacheModel("c_usa_secserv_gear_light");
}
