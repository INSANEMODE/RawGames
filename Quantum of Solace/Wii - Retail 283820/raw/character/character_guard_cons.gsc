
main()
{
	self setModel("cons_site_guard_body");
	headArray = xmodelalias\cons_site_wrkr_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("cons_site_hands", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("cons_site_guard_body");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_heads::main());
	precacheModel("cons_site_hands");
}
