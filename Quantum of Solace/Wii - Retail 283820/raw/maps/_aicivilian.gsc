










#include common_scripts\utility;
#include maps\_utility;




cower()
{
	
	self endon( "death" );

	
	if( IsDefined( self.script_pacifist ) && (self.script_pacifist == 0) )
	{
		return;
	}

	
	if( !IsDefined( self.cower_active ) )
	{
		self.cower_active = false;
	}
	
	
	while( true )
	{
		
		if( !sightTracePassed( self.origin + (0, 0, 32), level.player GetEye(), false, undefined ) )
		{
			self.cower_active = false;
			sWpn = undefined;
			wait( 1 );
			continue;
		}

		
		sWpn = level.player GetCurrentWeapon();
		if( !IsDefined( sWpn ) || (sWpn == "")  || (sWpn == "phone")  || (sWpn == "none"))
		{
			self.cower_active = false;
		}
		else
		{
			if( !self.cower_active )
			{
				self thread cower_anim();
			}
			self.cower_active = true;
		}
		wait( 1 );
	}
}

cower_anim()
{
	
	self endon( "death" );
	wait( 0.05 );
	
	while( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
	{
		self CmdAction( "Flinch", true, 3 );
		wait( 3 );
	}
}





bump()
{
	
	self endon( "death" );

	
	if( IsDefined( self.script_cheap ) && (self.script_cheap == 0) )
	{
		return;
	}

	
	self PushPlayer( true );

	
	while( true )
	{
		
		if( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
		{	
			wait( 0.1 );
			continue;
		}

		
		if( (Distance(self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40) )
		{
			self CmdAction( "pain" );
			wait( 3 );
		}
		else
		{
			wait( 0.1 );
		}
	}
}
