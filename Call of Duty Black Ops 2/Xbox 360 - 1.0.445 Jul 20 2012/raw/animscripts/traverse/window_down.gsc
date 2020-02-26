#include common_scripts\utility;
#include animscripts\traverse\shared;
#include animscripts\anims;

#using_animtree ("generic_human");

main()
{
	PrepareForTraverse();

	traverseAnim = animArray("window_climb_start", "move");
	landAnim = animArray("window_climb_end", "move");
	const normalHeight = 35;

	// do not do code prone in this script
	self.desired_anim_pose = "crouch";
	animscripts\utility::UpdateAnimPose();
	
	self.old_anim_movement = self.a.movement;
		
	self endon("killanimscript");
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	
	// orient to the Negotiation start node
	startnode = self getnegotiationstartnode();
	assert( IsDefined( startnode ) );
	self OrientMode( "face angle", startnode.angles[1] );
	realHeight = startnode.traverse_height - startnode.origin[2];
	
	self SetFlaggedAnimKnobAllRestart("traverse", traverseAnim, %body, 1, 0.15, 1);
	thread animscripts\shared::DoNoteTracksForever("traverse", "stop_traverse_notetracks");


	// keeps the actor from sinking in to the ground or from levitating to some extent.
	wait 1.5;
	angles = (0,startnode.angles[1],0);
	forward = AnglesToForward(angles);
	forward = VectorScale(forward, 85);
	trace = bullettrace(startnode.origin + forward, startnode.origin + forward + (0,0,-500), false, undefined);
//	thread showLine(startnode.origin + forward, trace["position"]);
	endheight = trace["position"][2];
	
	finaldif = startnode.origin[2] - endheight;
	heightChange = 0;
	for (i=0;i<level.window_down_height.size;i++)
	{
		if (finaldif < level.window_down_height[i])
			continue;
		heightChange = finaldif - level.window_down_height[i];
	}
	assert(heightChange > 0, "window_jump at " + startnode.origin + " is too high off the ground");
//	heightChange -= 0;
	self thread teleportThread(heightChange * -1);
	
//	thread printerdebugger(heightchange, trace["position"]);
	
	oldheight = self.origin[2];
	change = 0;
	level.traverseFall = [];
	for (;;)
	{
		/*
		/#
		thread printer(self.origin);	
		#/
		*/
		change = oldheight - self.origin[2];
		if (self.origin[2] - change < endheight) // predict when he's about to hit the ground
		{
			break;
		}
		oldheight = self.origin[2];
		wait (0.05);
	}
	if (IsDefined (self.groundtype))
		self PlaySound ("Land_" + self.groundtype);

	self notify ("stop_traverse_notetracks");
	self SetFlaggedAnimKnobAllRestart("traverse", landAnim, %body, 1, 0.15, 1);
//	self waittillmatch("traverse", "gravity on");
	self traverseMode("gravity");
	self animscripts\shared::DoNoteTracks("traverse");
//	wait 0.9;

	
	self.a.movement = self.old_anim_movement;
	self SetAnimKnobAllRestart( animscripts\run::GetRunAnim(), %body, 1, 0.2, 1 );
}

printer(org)
{
	level notify ("print_this_"+org);
	level endon ("print_this_"+org);
	for (;;)
	{	
		/#Print3d(org, ".", (1,1,1),5);#/
		wait (0.05);
	}
}

showline(start, end)
{
	for (;;)
	{
		/#line (start, end + (-1,-1,-1), (1,0,0));#/
		wait (0.05);
	}
}

printerdebugger(msg, org)
{
	level notify ("prrint_this_"+org);
	level endon ("prrint_this_"+org);
	for (;;)
	{	
		/#Print3d(org, msg, (1,1,1),5);#/
		wait (0.05);
	}
}

		/*
		/#
		dif = startNode.origin[2] - self.origin[2];
		included = false;
		for (i=0;i<level.traverseFall.size;i++)
		{
			if (level.traverseFall[i] != dif)
				continue;
			included = true;
			break;
		}
		if (!includeD)
			level.traverseFall[level.traverseFall.size] = dif;
		if (GetDebugDvar("debug_traversefall") != "")
		{
			SetDvar("debug_traversefall", "");
			for (i=0;i<level.traverseFall.size;i++)
				println ("	level.window_down_height[", i, "] = ", level.traverseFall[i], ";");
		}
		#/
		*/
