// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	codescripts\character::setModelFromArray(xmodelalias\c_mul_civ_club_female_lt10_als::main());
	self.headModel = codescripts\character::randomElement(xmodelalias\c_mul_civ_club_female_lt_head_als::main());
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\c_mul_civ_club_female_lt10_als::main());
	codescripts\character::precacheModelArray(xmodelalias\c_mul_civ_club_female_lt_head_als::main());
}
