// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_mp_arab_regular_assault");
	self attach("head_mp_arab_regular_suren", "", true);
	self.hatModel = "head_mp_arab_regular_suren_helmet";
	self attach(self.hatModel);
	self setViewmodel("viewhands_op_force");
	self.voice = "arab";
}

precache()
{
	precacheModel("body_mp_arab_regular_assault");
	precacheModel("head_mp_arab_regular_suren");
	precacheModel("head_mp_arab_regular_suren_helmet");
	precacheModel("viewhands_op_force");
}
