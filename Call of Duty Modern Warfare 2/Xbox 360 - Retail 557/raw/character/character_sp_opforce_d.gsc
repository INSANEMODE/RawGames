// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_sp_opforce_d");
	self attach("head_sp_opforce_fullwrap_body_d", "", true);
	self.headModel = "head_sp_opforce_fullwrap_body_d";
	self.voice = "russian";
}

precache()
{
	precacheModel("body_sp_opforce_d");
	precacheModel("head_sp_opforce_fullwrap_body_d");
}
