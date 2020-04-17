#include maps\_utility;

main()
{
	flag_init( "pullup_weapon" );
	flag_init( "introscreen_complete" ); // Notify when complete	
	
	precacheshader("black");

	if (getDvar("introscreen") == "")
		setDvar("introscreen", "1");
	
	//String1 = Title of the level
	//String2 = Place, Country or just Country
	//String3 = Month Day, Year
	//String4 = Optional additional detailed information
	//Pausetime1 = length of pause in seconds after title of level
	//Pausetime2 = length of pause in seconds after Month Day, Year
	//Pausetime3 = length of pause in seconds before the level fades in 
	
	switch ( level.script )
	{
	case "bog_a":
		//precacheString(&"INTROSCREEN_TITLE");
		//precacheString(&"INTROSCREEN_PLACE");
		//precacheString(&"INTROSCREEN_DATE");
		//precacheString(&"INTROSCREEN_INFO");
		//introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 0.2, 0.2, 0.2);
//		introscreen_delay(&"INTROSCREEN_TITLE", &"INTROSCREEN_PLACE", &"INTROSCREEN_DATE", &"INTROSCREEN_INFO", 2.8, 3, 3);
		break;
	//case "digger":
	//	introscreen_delay("INTROSCREEN_TITLE", "INTROSCREEN_PLACE", "INTROSCREEN_DATE", "INTROSCREEN_INFO", 0.2, 0.2, 0.2);
	//	break;
	case "example":
		/*
		precacheString(&"INTROSCREEN_EXAMPLE_TITLE");
		precacheString(&"INTROSCREEN_EXAMPLE_PLACE");
		precacheString(&"INTROSCREEN_EXAMPLE_DATE");
		precacheString(&"INTROSCREEN_EXAMPLE_INFO");
		introscreen_delay(&"INTROSCREEN_EXAMPLE_TITLE", &"INTROSCREEN_EXAMPLE_PLACE", &"INTROSCREEN_EXAMPLE_DATE", &"INTROSCREEN_EXAMPLE_INFO");
		*/
		break;
	case "bridge":
		thread bog_intro();
		break;
	default:
		// Shouldn't do a notify without a wait statement before it, or bad things can happen when loading a save game.
		wait 0.05; 
		level notify("finished final intro screen fadein");
		wait 0.05; 
		level notify("starting final intro screen fadeout");
		wait 0.05; 
		level notify("controls_active"); // Notify when player controls have been restored
		wait 0.05; 
		flag_set("introscreen_complete"); // Do final notify when player controls have been restored
		break;
	}
}

introscreen_create_line(string)
{
	index = level.introstring.size;
	yPos = (index * 30);
	
	if (level.xenon)
		yPos -= 60;
	
	level.introstring[index] = newHudElem();
	level.introstring[index].x = 0;
	level.introstring[index].y = yPos;
	level.introstring[index].alignX = "center";
	level.introstring[index].alignY = "middle";
	level.introstring[index].horzAlign= "center";
	level.introstring[index].vertAlign = "middle";
	level.introstring[index].sort = 1; // force to draw after the background
	level.introstring[index].foreground = true;
	level.introstring[index].fontScale = 1.75;
	level.introstring[index] setText(string);
	level.introstring[index].alpha = 0;
	level.introstring[index] fadeOverTime(1.2); 
	level.introstring[index].alpha = 1;
}

introscreen_fadeOutText()
{
	for(i = 0; i < level.introstring.size; i++)
	{
		level.introstring[i] fadeOverTime(1.5);
		level.introstring[i].alpha = 0;
	}

	wait 1.5;

	for(i = 0; i < level.introstring.size; i++)
		level.introstring[i] destroy();
}

introscreen_delay(string1, string2, string3, string4, pausetime1, pausetime2, timebeforefade)
{
	/#
	//Chaotically wait until the frame ends twice because handle_starts waits for one frame end so that script gets to init vars
	//and this needs to wait for handle_starts to finish so that the level.start_point gets set.
	waittillframeend; 
	waittillframeend; 
	
	skipIntro = level.start_point != "default";
	if ( getdvar( "introscreen" ) == "0" )
		skipIntro = true;
		
	if ( skipIntro )
	{
		waittillframeend;
		level notify("finished final intro screen fadein");
		waittillframeend;
		level notify ("starting final intro screen fadeout");
		waittillframeend;
		level notify("controls_active"); // Notify when player controls have been restored
		waittillframeend;
		flag_set("introscreen_complete"); // Do final notify when player controls have been restored
		flag_set( "pullup_weapon" );
		return;
	}
	#/

		
	if ( level.script == "bog_a" )
	{
		bog_intro();
		return;
	}
	
	level.introblack = newHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack setShader("black", 640, 480);

	level.player freezeControls(true);
	wait .05;

	level.introstring = [];
	
	//Title of level
	
	if(isdefined(string1))
		introscreen_create_line(string1);
	
	if(isdefined(pausetime1))
	{
		wait pausetime1;
	}
	else
	{
		wait 2;	
	}
	
	//City, Country, Date
	
	if(isdefined(string2))
		introscreen_create_line(string2);
	if(isdefined(string3))
		introscreen_create_line(string3);
	
	//Optional Detailed Statement
	
	if(isdefined(string4))
	{
		if(isdefined(pausetime2))
		{
			wait pausetime2;
		}
		else
		{
			wait 2;
		}
	}
	
	if(isdefined(string4))
		introscreen_create_line(string4);
	
	//if(isdefined(string5))
		//introscreen_create_line(string5);
	
	level notify("finished final intro screen fadein");
	
	if(isdefined(timebeforefade))
	{
		wait timebeforefade;
	}
	else
	{
		wait 3;
	}

	// Fade out black
	level.introblack fadeOverTime(1.5); 
	level.introblack.alpha = 0;

	level notify ("starting final intro screen fadeout");

	// Restore player controls part way through the fade in
	level.player freezeControls(false);
	level notify("controls_active"); // Notify when player controls have been restored

	// Fade out text
	introscreen_fadeOutText();

	flag_set("introscreen_complete"); // Notify when complete
}

introscreen_corner_line( string )
{
	level.intro_offset++;
	y = ( level.intro_offset * 19 ) - 110;
	
	hudelem = newHudElem();
	hudelem.x = 20;
	hudelem.y = y;
	hudelem.alignX = "left";
	hudelem.alignY = "bottom";
	hudelem.horzAlign= "left";
	hudelem.vertAlign = "bottom";
	hudelem.sort = 1; // force to draw after the background
	hudelem.foreground = true;
	hudelem.fontScale = 1.75;
	hudelem.color = ( 0, 1, 0 );
	hudelem setText( string );
	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.2 ); 
	hudelem.alpha = 1;
	thread hudelem_destroy( hudelem );
}

hudelem_destroy( hudelem )
{
	level waittill( "destroy_hud_elements" );
	hudelem destroy();
}

bog_intro_sound()
{
	wait( 0.05 );
	level.player playsound( "ui_camera_whoosh_in" );
	setsaveddvar( "compass", 0 );
	SetSavedDvar( "ammoCounterHide", "1" );
}

bog_intro()
{
	thread bog_intro_sound();
	cinematicingame("fade_bog_a");
	level.player freezeControls( true );
//	wait( 0.1 );
//	wait( 2.5 );
//	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	level.intro_offset = 0;
	lines = [];
	lines[ lines.size ] = "The Bog";
	lines[ lines.size ] = "Day 1 - 0400hrs - Republic of Arabia";
	lines[ lines.size ] = "PFC Michael Carver";
	lines[ lines.size ] = "1st Battalion, 7th Marines";

	for ( i=0; i < lines.size; i++ )
	{
		introscreen_corner_line( lines[ i ] );
	}

	origin = level.player.origin;
	level.player.origin = origin + ( 0, 0, 16000 );
	ent = spawn( "script_model", (69,69,69) );
	ent.origin = level.player.origin;
	
	ent setmodel( "tag_origin" );
	ent.angles = level.player.angles;
	level.player linkto( ent );
	ent.angles = ( ent.angles[ 0 ] + 89, ent.angles[ 1 ], 0 );
	
	ent moveto ( origin + (0,0,0), 2, 0, 2 );
	wait ( 1.5 );
	ent rotateto( ( ent.angles[ 0 ] - 89, ent.angles[ 1 ], 0 ), 0.5, 0.3, 0.2 );
	wait ( 0.5 );
	flag_set( "pullup_weapon" );

	wait( 0.5 );
	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
//	VisionSetNaked( "introscreen", 0.2 );
	wait( 0.2 );
	
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
//	VisionSetNaked( "bog", 0.2 );
	wait( 0.2 );
	level.player unlink();

	level notify("introscreen_complete"); // Do final notify when player controls have been restored
	level.player freezeControls( false );
	level.intro_offset = undefined;
	wait( 2 );
	level notify( "destroy_hud_elements" );
	setsaveddvar( "compass", 1 );
	SetSavedDvar( "ammoCounterHide", "0" );
	
	ent delete();


//	wait( 1.5 );
//	level notify("finished final intro screen fadein");

	maps\_autosave::autosave_by_name( "levelstart" );
	/*
	level.introblack = newHudElem();
	level.introblack.x = 0;
	level.introblack.y = 0;
	level.introblack.horzAlign = "fullscreen";
	level.introblack.vertAlign = "fullscreen";
	level.introblack.foreground = true;
	level.introblack setShader("black", 640, 480);

	level.introblack fadeOverTime(1.5); 
	level.introblack.alpha = 0;
	VisionSetNaked( "introscreen", 0.2 );
	level.player freezeControls( true );
	wait( 0.1 );
	setsaveddvar( "compass", 0 );
	wait( 2.5 );
//	thread play_sound_in_space( "ui_screen_trans_in", level.player.origin );
	
	level.intro_offset = 0;
	lines = [];
	lines[ lines.size ] = "The Bog";
	lines[ lines.size ] = "Day 1 - 0400hrs - Republic of Arabia";
	lines[ lines.size ] = "PFC Michael Carver";
	lines[ lines.size ] = "1st Battalion, 7th Marines";

	for ( i=0; i < lines.size; i++ )
	{
		introscreen_corner_line( lines[ i ] );
		wait( 1 );
	}


	wait( 2 );
	level notify( "destroy_hud_elements" );

	VisionSetNaked( "bog", 0.2 );
	thread play_sound_in_space( "ui_screen_trans_out", level.player.origin );
	wait( 0.2 );

	level notify("introscreen_complete"); // Do final notify when player controls have been restored
	level.player freezeControls( false );
	level.intro_offset = undefined;

	setsaveddvar( "compass", 1 );

//	wait( 1.5 );
//	level notify("finished final intro screen fadein");
	saveGame( "levelstart", &"AUTOSAVE_LEVELSTART", "autosave_image" );
	*/	
}

introscreen_chyron( title, location, time )
{

	if (!IsDefined(level.hud_intro))
	{
		level.hud_intro = newHudElem();
		//level.hud_intro.x = -250;
		level.hud_intro.y = 100;
		level.hud_intro.horzAlign = "left";
		level.hud_intro.vertAlign = "middle";
		level.hud_intro.foreground = true;
		level.hud_intro.fontScale = 2;
		level.hud_intro.alpha = 0;
	}
	if (!IsDefined(level.hud_intro2))
	{
		level.hud_intro2 = newHudElem();
		//level.hud_intro2.x = -250;
		level.hud_intro2.y = 120;
		level.hud_intro2.horzAlign = "left";
		level.hud_intro2.vertAlign = "middle";
		level.hud_intro2.foreground = true;
		level.hud_intro2.fontScale = 2;
		level.hud_intro2.alpha = 0;
	}
	if (!IsDefined(level.hud_date))
	{
		level.hud_date = newHudElem();
		//level.hud_date.x = -250;
		level.hud_date.y = 140;
		level.hud_date.horzAlign = "left";
		level.hud_date.vertAlign = "middle";
		level.hud_date.foreground = true;
		level.hud_date.fontScale = 1.75;
		level.hud_date.alpha = 0;
	}


	if(isDefined(title))
	{
		level.hud_intro settext(title);
		level.hud_intro fadeOverTime( 1.0 );
		level.hud_intro.alpha = 1;
		wait(1.5);
	}

	if(isDefined(location))
	{
		level.hud_intro2 settext(location);
		level.hud_intro2 fadeOverTime( 1.0 );
		level.hud_intro2.alpha = 1;
		wait(1.5);
	}

	if(isDefined(time))
	{
		level.hud_date settext(time);
		level.hud_date fadeOverTime( 1.0 );
		level.hud_date.alpha = 1;
		wait(1.5);
	}

	wait( 1.0 );

	level.hud_intro fadeOverTime( 1.0 );
	level.hud_intro.alpha = 0;
	level.hud_intro2 fadeOverTime( 1.0 );
	level.hud_intro2.alpha = 0;
	level.hud_date fadeOverTime( 1.0 );
	level.hud_date.alpha = 0;

	wait(1.0);
}