
main()
{
	self setModel("carlos_windbreaker_body");
	self attach("carlos_windbreaker_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("carlos_windbreaker_body");
	precacheModel("carlos_windbreaker_head");
}
