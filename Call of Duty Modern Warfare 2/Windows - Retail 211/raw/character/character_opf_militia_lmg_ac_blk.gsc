// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("body_militia_lmg_ac_blk");
	codescripts\character::attachHead( "alias_opforce_militia_heads_blk", xmodelalias\alias_opforce_militia_heads_blk::main() );
	if ( issubstr( self.headModel, "hat" ) )
	{
		self.hatModel = "hat_militia_bb_blk";
		self attach(self.hatModel);
	}
	self.voice = "portuguese";
}

precache()
{
	precacheModel("body_militia_lmg_ac_blk");
	codescripts\character::precacheModelArray(xmodelalias\alias_opforce_militia_heads_blk::main());
	precacheModel("hat_militia_bb_blk");
}
