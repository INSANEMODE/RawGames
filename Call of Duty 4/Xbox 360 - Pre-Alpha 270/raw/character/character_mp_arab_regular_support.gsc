// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_mp_arab_regular_support");
	self attach("head_mp_arab_regular_asad", "", true);
	self.hatModel = "head_mp_arab_regular_asad_beret";
	self attach(self.hatModel);
	self setViewmodel("viewhands_op_force");
	self.voice = "arab";
}

precache()
{
	precacheModel("body_mp_arab_regular_support");
	precacheModel("head_mp_arab_regular_asad");
	precacheModel("head_mp_arab_regular_asad_beret");
	precacheModel("viewhands_op_force");
}
