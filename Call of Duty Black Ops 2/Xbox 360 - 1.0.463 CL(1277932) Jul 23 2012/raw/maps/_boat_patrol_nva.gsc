#include maps\_vehicle;
#include maps\_utility;


#using_animtree ("vehicles");
main()
{
	
	if(IsDefined(self.script_string) && self.script_string == "sink_me")
	{
		level._effect["sink_fx" + self.vehicletype] = LoadFX("vehicle/vexplosion/fx_vexp_nvaboat_machinegun");
		level._effect["explo_fx" + self.vehicletype] = LoadFX("vehicle/vexplosion/fx_vexp_nvaboat");
		level.vehicle_death_thread[self.vehicletype] = ::delete_and_sink_fx;
	}
}

delete_and_sink_fx()
{
	self notify( "nodeath_thread" );
	
	if(!IsDefined(self.weapon_last_damage))
	{
		self.weapon_last_damage = "hind_rockets";
	}
	
	if(self.weapon_last_damage == "hind_rockets")
	{
		PlayFX(level._effect["explo_fx" + self.vehicletype], self.origin, AnglesToForward(self.angles));
				
		//C. Ayers - changing sound call
		self PlaySound("exp_nva_boat_second");
	}
	else //if(self.weapon_last_damage == "hind_minigun_pilot")
	{
		PlayFX(level._effect["sink_fx" + self.vehicletype], self.origin, AnglesToForward(self.angles));
		
		//C. Ayers - changing sound call
		self PlaySound("exp_nva_boat");
	}

	if ( IsDefined( self.riders ) && self.riders.size > 0 )
	{
		maps\_vehicle_aianim::blowup_riders();
	}

	
	waittillframeend;
	self Delete();
}