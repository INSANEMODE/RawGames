#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\string_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace lui;

#precache( "eventstring", "show_perk_notification" );

#precache( "lui_menu", "HudElementText" );
#precache( "lui_menu", "HudElementImage" );
#precache( "lui_menu", "HudElementTimer" );
#precache( "lui_menu", "FullScreenBlack" );
#precache( "lui_menu", "FullScreenWhite" );
#precache( "lui_menu", "ScriptMessageDialog_Compact" );

#precache( "lui_menu_data", "text" );
#precache( "lui_menu_data", "material" );
#precache( "lui_menu_data", "x" );
#precache( "lui_menu_data", "y" );
#precache( "lui_menu_data", "width" );
#precache( "lui_menu_data", "height" );
#precache( "lui_menu_data", "alpha" );
#precache( "lui_menu_data", "alignment" );
#precache( "lui_menu_data", "fadeOverTime" );
#precache( "lui_menu_data", "startAlpha" );
#precache( "lui_menu_data", "endAlpha" );
#precache( "lui_menu_data", "time" );
#precache( "lui_menu_data", "current_animation" );
#precache( "lui_menu_data", "red" );
#precache( "lui_menu_data", "green" );
#precache( "lui_menu_data", "blue" );
#precache( "lui_menu_data", "zRot" );

#precache( "lui_menu", "PiPMenu" );
#precache( "lui_menu", "FullscreenMovie" );
#precache( "lui_menu_data", "additive" );
#precache( "lui_menu_data", "movieName" );
#precache( "lui_menu_data", "showBlackScreen" );

#precache( "lui_menu_data", "title" );
#precache( "lui_menu_data", "description" );

function autoexec __init__sytem__() {     system::register("lui_shared",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned(&refresh_menu_values);
}

// Refresh all global lui variables for connecting players.
//
function private refresh_menu_values()
{
	if ( !isdefined( level.lui_script_globals ) )
	{
		return;
	}
	
	a_str_menus = GetArrayKeys( level.lui_script_globals );
	for ( i = 0; i < a_str_menus.size; i++ )
	{
		str_menu = a_str_menus[i];
		a_str_vars = GetArrayKeys( level.lui_script_globals[str_menu] );
		for ( j = 0; j < a_str_vars.size; j++ )
		{
			str_var = a_str_vars[j];
			value = level.lui_script_globals[str_menu][str_var];
			self set_value_for_player( str_menu, str_var, value );
		}
	}
}

/@
"Name: play_animation( menu, str_anim )"
"Summary: Play an animation clip on a lui menu (create the animation in the  UI Editor)."
"CallOn: N/A"
"MandatoryArg: menu : the menu."
"MandatoryArg: str_anim : the clip name."
"Example: play_animation( menu, "on_focus_cool_anim" );"
@/
function play_animation( menu, str_anim )
{
	str_curr_anim = self GetLUIMenuData( menu, "current_animation" );
	str_new_anim = str_anim;
	
	// This is because if we set the anim name again to what it was before, it will not trigger the model subscription 
	// which will in turn not play the animation. This case is handled specially in lua, to check if its an empty string,
	// if so, play the same anim again.
	if ( isdefined( str_curr_anim ) && ( str_curr_anim == str_anim ) )
	{
		str_new_anim = "";	
	}
	
	self SetLUIMenuData( menu, "current_animation", str_new_anim ); 	
}

function set_color( menu, color )
{
	self SetLUIMenuData( menu, "red", color[ 0 ] );
	self SetLUIMenuData( menu, "green", color[ 1 ] );
	self SetLUIMenuData( menu, "blue", color[ 2 ] );
}

// Set a LUI data model value for a specific player.
//
// Self == player
//
// Note: be sure to precache the lui_menu and the lui_menu_data for str_menu_id and str_variable_id respectively.
//
function set_value_for_player( str_menu_id, str_variable_id, value )
{
	if(!isdefined(self.lui_script_menus))self.lui_script_menus=[];
	if(!isdefined(self.lui_script_menus[str_menu_id]))self.lui_script_menus[str_menu_id]=self OpenLuiMenu( str_menu_id );
		self SetLuiMenuData( self.lui_script_menus[str_menu_id], str_variable_id, value );
	}

// Set a LUI data model value for all players.
//
// Note: be sure to precache the lui_menu and the lui_menu_data for str_menu_id and str_variable_id respectively.
//
function set_global( str_menu_id, str_variable_id, value )
{
	if(!isdefined(level.lui_script_globals))level.lui_script_globals=[];
	if(!isdefined(level.lui_script_globals[str_menu_id]))level.lui_script_globals[str_menu_id]=[];
	
	level.lui_script_globals[ str_menu_id ][ str_variable_id ] = value;

	// If there are no players now, no worries--it'll automagically get assigned when they connect.
	//	
	if ( isdefined( level.players ) )
	{
		foreach( player in level.players )
		{
			player set_value_for_player( str_menu_id, str_variable_id, value );
		}
	}
}

/@
"Name: timer( n_time, str_endon, x, y, height )"
"Summary: Throw up a quick debug/blockout timer. Returns when the time is up."
"CallOn: player"
"MandatoryArg: n_time : the amount of time."
"OptionalArg: str_endon: kill notify."
"OptionalArg: x: the x position of the UI."
"OptionalArg: y: the y position of the UI."
"OptionalArg: height: the size of the UI."
"Example: level.players[0] timer( 10 );"
@/
function timer( n_time, str_endon, x, y, height )
{
	if(!isdefined(x))x=1280 - 200;
	if(!isdefined(y))y=200;
	if(!isdefined(height))height=60;
	
	lui = self OpenLUIMenu( "HudElementTimer" );
    self SetLUIMenuData( lui, "x", x );
    self SetLUIMenuData( lui, "y", y );
    self SetLUIMenuData( lui, "height", height );
    self SetLUIMenuData( lui, "time", GetTime() + ( n_time * 1000 ) );
    
    if ( isdefined( str_endon ) )
    {
    	self util::waittill_notify_or_timeout( str_endon, n_time );
    }
    else
    {
    	wait n_time;
    }
    
    self CloseLUIMenu( lui );
}

/@
"Name: play_movie( str_movie, str_type )"
"Summary: Play a movie.  Currently supports fullscreen or PIP formats."
"CallOn: player or level (for all players)"
"MandatoryArg: str_movie: the movie name."
"MandatoryArg: str_type: "pip", "fullscreen", "fullscreen_additive" (defaults to fullscreen)."
"OptionalArg: show_black_screen: this shows a black screen behind the movie till the movie finishes streaming and starts playing"
"Example: level lui::play_movie( "cairotroops", "pip" );"
@/
function play_movie( str_movie, str_type, show_black_screen = false )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player thread _play_movie_for_player( str_movie, str_type, show_black_screen );
		}
		
		array::wait_till( level.players, "movie_done" );
	}
	else
	{
		_play_movie_for_player( str_movie, str_type );
	}
	
	level notify( "movie_done", str_type );
}

function private _play_movie_for_player( str_movie, str_type, show_black_screen )
{
	str_menu = undefined;
	
	switch ( str_type )
	{
		case "fullscreen":
		case "fullscreen_additive":
			str_menu = "FullscreenMovie";
			break;
			
		case "pip":
			str_menu = "PiPMenu";
			break;
			
		default: AssertMsg( "Invalid movie type '" + str_type + "'." );
	}
	
	if( str_type == "pip" )
	{
		self playsoundtoplayer( "uin_pip_open", self );
	}
	
	lui_menu = self OpenLUIMenu( str_menu );			
	self SetLUIMenuData( lui_menu, "movieName", str_movie );
	self SetLUIMenuData( lui_menu, "showBlackScreen", show_black_screen );
	
	if ( IsSubStr( str_type, "additive" ) )
	{
		self SetLUIMenuData( lui_menu, "additive", 1 );
	}
	
	while ( true )
	{
		self waittill( "menuresponse", menu, response );
	                                
		if ( ( menu == str_menu ) && ( response == "finished_movie_playback" ) )
		{
			if( str_type == "pip" )
			{
				self playsoundtoplayer( "uin_pip_close", self );
			}
			
			self CloseLUIMenu( lui_menu );
			self notify( "movie_done" );
		}
	}
}

/@
"Name: screen_flash( <n_fadein_time>, <n_hold_time>, <n_fadeout_time>, [n_target_alpha = 1], [str_color = "black"], [b_force_close_menu = false] )"
"Summary: fade the screen to the given color, hold for a moment, then fade back in"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"MandatoryArg: n_hold_time: hold time (at target alpha)"
"MandatoryArg: n_fadeout_time: fade back out time"
"OptionalArg: n_target_alpha: end alpha (defaults to 1)"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"OptionalArg: b_force_close_menu: close the fade menu when done even if the alpha isn't 0."
"Example: level lui::screen_flash( 0.2, 0.1, .5, 1.0, "white" ); // fade to 1.0 alpha white over 0.2s, hold for 0.5s, and fade back in over 1.0s"
@/
function screen_flash( n_fadein_time, n_hold_time, n_fadeout_time, n_target_alpha = 1, str_color = "black", b_force_close_menu = false )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player _screen_fade( n_fadein_time, n_target_alpha, 0, str_color, b_force_close_menu );
			wait n_hold_time;
			player _screen_fade( n_fadeout_time, 0, n_target_alpha, str_color, b_force_close_menu );
		}
	}
	else
	{
		self _screen_fade( n_fadein_time, n_target_alpha, 0, str_color, b_force_close_menu );
		wait n_hold_time;
		self _screen_fade( n_fadeout_time, 0, n_target_alpha, str_color, b_force_close_menu );
	}
}

/@
"Name: screen_fade( <n_time>, [n_target_alpha = 1], [str_color = "black"], [b_force_close_menu = false] )"
"Summary: fade the screen in/out"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: n_target_alpha: end alpha (defaults to 1)"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"OptionalArg: b_force_close_menu: close the fade menu when done even if the alpha isn't 0."
"Example: level lui::screen_fade( 3, .5, "black" ); // fade to .5 alpha over 3 sec"
@/
function screen_fade( n_time, n_target_alpha = 1, n_start_alpha = 0, str_color = "black", b_force_close_menu = false )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player thread _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu );
		}
	}
	else
	{
		self thread _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu );
	}
}

/@
"Name: screen_fade_out( <n_time>, [str_color] )"
"Summary: fade the screen out"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"Example: level lui::screen_fade_out( 3 ); // fade out over 3 sec"
@/
function screen_fade_out( n_time, str_color )
{
	screen_fade( n_time, 1, 0, str_color, false );
	wait n_time;
}

/@
"Name: screen_fade_in( <n_time>, [str_color] )"
"Summary: fade the screen in"
"CallOn: player or level (for all players)"
"MandatoryArg: n_time: fade time"
"OptionalArg: str_color: "white" or "black" (defaults to black)."
"Example: level lui::screen_fade_in( 3 ); // fade in over 3 sec"
@/
function screen_fade_in( n_time, str_color )
{
	screen_fade( n_time, 0, 1, str_color, true );
	wait n_time;
}

/@
"Name: screen_close_menu()"
"Summary: foce closes the menu regardless of the current alpha value"
"CallOn: player or level (for all players)"
@/	
function screen_close_menu()
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			player thread _screen_close_menu();
		}
	}
	else
	{
		self thread _screen_close_menu();
	}
}

function private _screen_close_menu()
{
	self notify( "_screen_fade" );
	self endon( "_screen_fade" );
	self endon( "disconnect" );
	
	if(isdefined(self.screen_fade_menus))
	{
		str_menu = "FullScreenBlack";
		
		if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
		{
			self CloseLUIMenu( self.screen_fade_menus[ str_menu ].lui_menu );
			self.screen_fade_menus[ str_menu ] = undefined;
		}
		
		str_menu = "FullScreenWhite";
		
		if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
		{
			self CloseLUIMenu( self.screen_fade_menus[ str_menu ].lui_menu );
			self.screen_fade_menus[ str_menu ] = undefined;
		}
	}
}

function private _screen_fade( n_time, n_target_alpha, n_start_alpha, str_color, b_force_close_menu )
{
	self notify( "_screen_fade_" + str_color );
	self endon( "_screen_fade_" + str_color );
	self endon( "disconnect" );
	
	if(!isdefined(self.screen_fade_menus))self.screen_fade_menus=[];
	if(!isdefined(level.screen_fade_network_frame))level.screen_fade_network_frame=0;
	
	n_time_ms = int( n_time * 1000 );
		
	lui_menu = "";
	switch ( str_color )
	{
		case "black":
			
			str_menu = "FullScreenBlack";
			break;
			
		case "white":
			
			str_menu = "FullScreenWhite";
			break;
			
		default: AssertMsg( "Unsupported color for screen fade." );
	}
	
	_one_screen_fade_per_network_frame(); // menu commands can't run on the same network frame
	
	if ( isdefined( self.screen_fade_menus[ str_menu ] ) )
	{
		/* Use current menu */
		
		s_menu = self.screen_fade_menus[ str_menu ];		
		lui_menu = s_menu.lui_menu;
		
		/* Calculate the current alpha since we can't get it directly from the menu */
						
		n_start_alpha = LerpFloat( s_menu.n_start_alpha, s_menu.n_target_alpha, GetTime() - s_menu.n_start_time );
	}
	else
	{
		lui_menu = self OpenLUIMenu( str_menu );
		
		self.screen_fade_menus[ str_menu ] = SpawnStruct();
		self.screen_fade_menus[ str_menu ].lui_menu = lui_menu;
	}
	
	self.screen_fade_menus[ str_menu ].n_start_alpha = n_start_alpha;	
	self.screen_fade_menus[ str_menu ].n_target_alpha = n_target_alpha;
	self.screen_fade_menus[ str_menu ].n_target_time = n_time_ms;
	self.screen_fade_menus[ str_menu ].n_start_time = GetTime();
		
	self SetLUIMenuData( lui_menu, "startAlpha", n_start_alpha );
	self SetLUIMenuData( lui_menu, "endAlpha", n_target_alpha );
	self SetLUIMenuData( lui_menu, "fadeOverTime", n_time_ms );
	
	/# 
		PrintTopRightln( str_menu + ": " + n_start_alpha + " -> " + n_target_alpha + "" + string::rfill( n_time, 4 ) + " sec", ( 1, 1, 1 ) );
	#/
	
	wait n_time;
		
	if ( b_force_close_menu || ( n_target_alpha == 0 ) )
	{
		self CloseLUIMenu( self.screen_fade_menus[ str_menu ].lui_menu );
		self.screen_fade_menus[ str_menu ] = undefined;
	}
}

function private _one_screen_fade_per_network_frame()
{
	while ( level.screen_fade_network_frame == level.network_frame )
	{
		util::wait_network_frame();
	}
	
	level.screen_fade_network_frame = level.network_frame;
}

/@
"Name: open_generic_script_dialog( title, description )"
"Summary: Opens up a generic script dialog."
"CallOn: player"
"MandatoryArg: title: the precached title of the popup."
"MandatoryArg: description: the precached description of the popup"
"Example: player lui::open_generic_script_dialog( &"MENU_GENERIC_TITLE", &"MENU_GENERIC_DESCRIPTION" );"
@/
function open_generic_script_dialog( title, description )
{
	self endon( "disconnect" );
	
	dialog = self OpenLUIMenu( "ScriptMessageDialog_Compact" );
	self SetLUIMenuData( dialog, "title", title );
	self SetLUIMenuData( dialog, "description", description );
	
	do
	{
		self waittill( "menuresponse", menu, response );
	}
	while( menu != "ScriptMessageDialog_Compact" || response != "close" );
	
	self CloseLUIMenu( dialog );
}

/@
"Name: open_script_dialog( dialog_name )"
"Summary: Opens up a specific script dialog."
"CallOn: player"
"MandatoryArg: dialog_name: the precached menu_name of the overlay."
"Example: player lui::open_script_dialog( "MyCustomDialog" );"
@/
function open_script_dialog( dialog_name )
{
	self endon( "disconnect" );
	
	dialog = self OpenLUIMenu( dialog_name );
	
	do
	{
		self waittill( "menuresponse", menu, response );
	}
	while( menu != dialog_name || response != "close" );
	
	self CloseLUIMenu( dialog );
}