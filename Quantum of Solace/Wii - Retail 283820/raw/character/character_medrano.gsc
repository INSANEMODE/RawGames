
main()
{
	self setModel("gen_medrano_body");
	self attach("gen_medrano_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("gen_medrano_body");
	precacheModel("gen_medrano_head");
}
