#using_animtree("generic_human");

main()
{
	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	
	// It'd be nice if I had an animation to get to stand without moving...
	self.a.movement = "stop";
	
	self thread animscripts\turret\turret::main();
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------
end_script()
{
}