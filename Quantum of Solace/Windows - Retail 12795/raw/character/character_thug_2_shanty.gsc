// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\obanno_henchman_bodies::getnextmodel();
	self setModel( body );
	headArray = xmodelalias\thug_heads_2_shanty::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\obanno_henchman_bodies::main());
	codescripts\character::precacheModelArray(xmodelalias\thug_heads_2_shanty::main());
}
