// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("cons_welder_body");
	headArray = xmodelalias\cons_site_wrkr_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("cons_site_hands", "", false);
	hatModel = xmodelalias\cons_site_welder_helmets::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	precacheModel("cons_welder_body");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_wrkr_heads::main());
	precacheModel("cons_site_hands");
	codescripts\character::precacheModelArray(xmodelalias\cons_site_welder_helmets::main());
}
