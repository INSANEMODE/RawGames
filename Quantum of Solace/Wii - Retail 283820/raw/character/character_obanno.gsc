
main()
{
	self setModel("obanno_body");
	self attach("obanno_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("obanno_body");
	precacheModel("obanno_head");
}
