
main()
{
	self setModel("waiter_body");
	self attach("waiter_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("waiter_body");
	precacheModel("waiter_head");
}
