// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("char_rus_guard_player_body1_1");
	self.headModel = "char_rus_guard_head2_2";
	self attach(self.headModel, "", true);
	self.hatModel = "char_rus_guard_hat";
	self attach(self.hatModel);
	self.gearModel = "char_rus_guard_body1_gear2_1";
	self attach(self.gearModel);
	self.voice = "russian";
}

precache()
{
	precacheModel("char_rus_guard_player_body1_1");
	precacheModel("char_rus_guard_head2_2");
	precacheModel("char_rus_guard_hat");
	precacheModel("char_rus_guard_body1_gear2_1");
}
