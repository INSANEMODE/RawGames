// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\lc_thug_bodies_sienna::getnextmodel();
	self setModel( body );
	self attach("lc_thug_4_head_train", "", false);
	hatModel = xmodelalias\lc_thug_4_beards::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_bodies_sienna::main());
	precacheModel("lc_thug_4_head_train");
	codescripts\character::precacheModelArray(xmodelalias\lc_thug_4_beards::main());
}
