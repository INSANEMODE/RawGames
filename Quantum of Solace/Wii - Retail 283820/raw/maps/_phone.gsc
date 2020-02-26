
#include maps\_hud_util;

#using_animtree ("multiplayer");

setup_phone()
{






































}

monitorTaserFire()
{
	level endon ("game_ended");
	while ( 1 )
	{
		level.player waittill( "weapon_fired" );
		weapon = level.player getcurrentweapon();
		if( weapon == "taser" || weapon == "taser_mp" )
		{
			self.taserText = newHudElem();
			self.taserText.alignX = "center";
			self.taserText.alignY = "top";
			self.taserText.fontScale = 1.5;
			self.taserText.x = 0;
			self.taserText.y = 50;
			self.taserText.horzAlign = "center";
			self.taserText.vertAlign = "fullscreen";
			self.taserText setText(&"SCRIPT_TASER_RECHARGING");
			wait 5.0;
			self.taserText destroy();
		}
	}
}

setupPhoneTriggers()
{
	level.phonetriggersetup = true;

	phoneTriggers = getEntArray( "setphonecontext", "targetname" );

	for( index = 0; index < phoneTriggers.size; index++ )
	{
		phoneTriggers[index] thread monitorPhoneTrigger();
	}

	cameraTriggers = getEntArray( "camera_target", "targetname" );
	for( index = 0; index < cameraTriggers.size; index++ )
	{
		cameraTriggers[index] thread monitorCameraTrigger();
	}

	resetTriggerHints();
}

resetTriggerHints()
{
	mechtriggers = GetEntArray( "mechlockpick", "targetname" );

	for( index = 0; index < mechtriggers.size; index++ )
	{
		mechtriggers[index] setHintString( &"SCRIPT_HINT_MECHLOCK" );
		mechtriggers[index] setcursorhint("HINT_PHONE_MECHPICK");
	}

	electriggers = GetEntArray( "eleclockpick", "targetname" );

	for( index = 0; index < electriggers.size; index++ )
	{
		electriggers[index] setHintString( &"SCRIPT_HINT_ELECLOCK" );
		electriggers[index] setcursorhint("HINT_PHONE_ELECPICK");
	}

	fdtriggers = getEntArray( "flashdrive", "targetname" );
	for( index = 0; index < fdtriggers.size; index++ )
	{
		if( fdtriggers[index].script_string == "download" )
		{
			fdtriggers[index] setHintString( &"SCRIPT_HINT_DOWNLOAD" );
			fdtriggers[index] setcursorhint("HINT_PHONE_DOWNLOAD");
		}
		else
		{
			fdtriggers[index] setHintString( &"SCRIPT_HINT_UPLOAD" );
			fdtriggers[index] setcursorhint("HINT_PHONE_UPLOAD");
		}
	}
}

monitorPhoneTrigger()
{
	level endon ("game_ended");
	while ( 1 )
	{
		self waittill ( "trigger", player );

		weapon = player getCurrentWeapon();
		
		
		
		
		
		
		
		
		
		
		

		if( !isDefined( player.lastMode ) || player.lastMode != self.script_string )
		{
			player setPhoneContextMode( self.script_string );
			level.player thread waitForPhoneTriggerDelete( self );
		}
		wait 0.5;
		if( isDefined( player ) && isDefined( self ) && player isTouching( self ) )
		{
			wait 0.05;
			if( isRemovedEntity( self ) )
			{
				return;
			}
			if( self.script_string == "camera" )
			{
				
				if( player getCurrentWeapon() == "phone" &&  player getCurrentPhoneMode() == 1 )
				{
					player setClientDvar( "phone_context_available", "no" );	
				}
				else
				{
					player setClientDvar( "phone_context_available", "Camera Available" );	
				}
			}
			if( self.script_string == "eleclockpick" )
			{
				
				if( player getCurrentWeapon() == "phone" &&  player getCurrentPhoneMode() == 7 )
				{
					player setClientDvar( "phone_context_available", "no" );	
				}
				else 
				{
					player setClientDvar( "phone_context_available", "Electronic Lockpick Available" );	
				}
			}
			if( self.script_string == "mechlockpick" )
			{
				
				
				
				
				
				
				{
					player setClientDvar( "phone_context_available", "Mechanical Lockpick Available" );	
				}
			}

		}
		else 
		{
			player switchFromPhoneContextMode();
			
			player.lastMode = undefined;
			player setClientDvar( "phone_context_available", "no" );
		}
	}
}

waitForPhoneTriggerDelete( trigger )
{
	level endon ("game_ended");
	level.player.currentphonetrigger = trigger;
	level.player waittill( "delete_phone_trigger" );
	if( isdefined( level.player.currentphonetrigger ) && !isremovedentity( level.player.currentphonetrigger ) )
	{
		level.player.currentphonetrigger delete();
		level.player.currentphonetrigger = undefined;
	}
	
	phoneTriggers = getEntArray( "setphonecontext", "targetname" );

	for( index = 0; index < phoneTriggers.size; index++ )
	{
		if( level.player isTouching( phoneTriggers[index] ) )
		{
			phoneTriggers[index] delete();
		}
	}
	
	level.player switchFromPhoneContextMode();
	
	level.player setClientDvar( "phone_context_available", "no" );
}

monitorCameraTrigger()
{
	level endon ("game_ended");
	while ( 1 )
	{
		self waittill ( "trigger", player );
		player.lookat = self;
		wait 0.05;
	}
}

monitorCameraClear()
{
	level endon ("game_ended");
	while ( 1 )
	{
		level.player waittill ( "trigger_clear_lookat" );
		level.player.lookat = undefined;
		wait 0.10;
	}
}

monitorPhoneSwitch()
{
	level endon ("game_ended");
	while ( 1 )
	{
	    prevweapon = level.player getCurrentWeapon();
	
	    while (prevweapon == "phone")
	    {
			
			wait(0.2);
			prevweapon = level.player getCurrentWeapon();
	    }
	    
	    if( level.player usebuttonpressed() && (getdvar("phone_context_available") != "no"))
	    {
			self notify( "phone_activated");
			level.player waittill( "phone_is_done" );
		    wait 0.1;
		    level.player switchtoweapon(prevweapon);
		}
		wait 0.05;
	}
}

monitorPhoneActivation()
{
	level endon ("game_ended");
	while ( 1 )
	{
		self waittill ( "phone_activated" );

        mode = getdvar("phone_context_available");

        if( mode == "no")
            continue;
            
        else if( mode == "Camera Available")    
		{
			self cameraActivated();
			continue;
		}	
		
		else if( mode == "Flash Drive Available")    
		{
			self flashDriveActivated();
			continue;
		}	
		
        else        
		{
			iPrintLn( "Error: No activation script exists for mode " + mode + "." );
	        level.player notify( "phone_is_done" );
	    }
	    
		wait 0.05;
	}
}

cameraActivated()
{
	level.player freezecontrols(true);
	level.player animrelative( "ignore", level.player getorigin(), level.player getplayerangles(), %fp_phone_take_photo); 
	level.player setClientDvar( "phone_context_available", "no" );	
	pictureSuccess = false;
	if( isDefined( self.lookat ) )
	{
		if( isDefined( self.lookat.onPictureTaken ) )
		{
			self.lookat [[self.lookat.onPictureTaken]]( self );
			pictureSuccess = true;
			level.player notify( "delete_phone_trigger" );
			level.player notify( "phone_is_done" );
		}
	}
	if( pictureSuccess == false )
	{
		level.player freezecontrols(false);
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "INVALID PICTURE" );
		wait 0.25;
		self.cameraText destroy();
		wait 0.25;
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "INVALID PICTURE" );
		wait 0.25;
		self.cameraText destroy();
		wait 0.25;
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "INVALID PICTURE" );
		wait 0.25;
		self.cameraText destroy();
		level.player notify( "phone_is_done" );
	}
	else
	{
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "UPLOADING" );
		wait 0.25;
		self.cameraText destroy();
		wait 0.25;
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "UPLOADING" );
		wait 0.25;
		self.cameraText destroy();
		wait 0.25;
		self.cameraText = newHudElem();
		self.cameraText.alignX = "center";
		self.cameraText.alignY = "top";
		self.cameraText.fontScale = 1.5;
		self.cameraText.x = 0;
		self.cameraText.y = 50;
		self.cameraText.horzAlign = "center";
		self.cameraText.vertAlign = "fullscreen";
		self.cameraText setText( "UPLOADING" );
		wait 0.25;
		self.cameraText destroy();
		level.player freezecontrols(false);
	}
}

flashDriveActivated()
{
	fdtriggers = getEntArray( "flashdrive", "targetname" );
	
	for( index = 0; index < fdtriggers.size; index++ )
	{
		if( self isTouching( fdtriggers[index] ) )
		{
			
			fdtriggers[index] notify( "trigger_phone", self );
			fdtriggers[index] setHintString( "" );
		}
	}
}


playPhoneMovie( movieName )
{
	iprintLn("Now playing the movie named " + movieName + " on your phone's screen." );
	level.player playmovieonphone( movieName );
	wait 2.0;
	iprintLn("Finished playing the movie named " + movieName + " on your phone's screen." );
}

setPhoneContextMode( newMode )
{
	if( isDefined( self.lastMode ) )
	{
		if( self.lastMode == newMode )
		{
			return;
		}
	}
	self.lastMode = newMode;	
	if( newMode == "camera" || newMode == "boommic" || newMode == "flashdrive" || newMode == "eleclockpick" || newMode == "mechlockpick" || newMode == "none" )
	{
		if( newMode == "none" )
		{
			
			level.player setClientDvar( "phone_context_available", "no" );
		}
		else
		{
			
			switch( newMode )
			{
			case "camera":
				level.player setClientDvar( "phone_context_available", "Camera Available" );
				break;
			case "flashdrive":
				level.player setClientDvar( "phone_context_available", "Flash Drive Available" );
				break;
			case "eleclockpick":
				level.player setClientDvar( "phone_context_available", "Electronic Lockpick Available" );
				break;
			case "mechlockpick":
				level.player setClientDvar( "phone_context_available", "Mechanical Lockpick Available" );
				break;
			}
		}
		if( !isDefined( self.defaultPhoneContext ) )
		{
			self.defaultPhoneContext = newMode;
		}
	}
	else
	{
		assertEx( false, "ERROR: Trying to set phone context mode to an invalid mode. (" + newMode + ")" );
	}
}

resetPhoneContextMode()
{
	if( isDefined( level.player.defaultPhoneContext ) )
	{
		level.player setPhoneContextMode( level.player.defaultPhoneContext );
	}
	else
	{
		assertex( false, "ERROR: Trying to reset phone context but default was not set!" );
	}
}


