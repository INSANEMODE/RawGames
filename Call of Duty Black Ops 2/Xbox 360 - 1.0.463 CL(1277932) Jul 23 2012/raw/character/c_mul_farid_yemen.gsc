// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_yem_houthis_medium_body");
	self.headModel = "c_mul_farid_yemen_head";
	self attach(self.headModel, "", true);
	self.hatModel = "c_yem_houthis_medium_gear";
	self attach(self.hatModel);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_yem_houthis_medium_body");
	precacheModel("c_mul_farid_yemen_head");
	precacheModel("c_yem_houthis_medium_gear");
}
