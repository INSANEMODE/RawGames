#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_spawning;

#using scripts\shared\clientfield_shared;
#using scripts\shared\compass;
#using scripts\shared\exploder_shared;


#using scripts\mp\_load;

#using scripts\mp\mp_spire_amb;
#using scripts\mp\mp_spire_fx;

#precache( "string", "MPUI_CALLSIGN_MAPNAME_A" );
#precache( "string", "MPUI_CALLSIGN_MAPNAME_B" );
#precache( "string", "MPUI_CALLSIGN_MAPNAME_C" );
#precache( "string", "MPUI_CALLSIGN_MAPNAME_D" );
#precache( "string", "MPUI_CALLSIGN_MAPNAME_E" );





function main()
{
	clientfield::register( "world", "mpSpireExteriorBillboard", 1, 2, "int" );
	
	//needs to be first for create fx
	mp_spire_fx::main();

	load::main();

	//compass map function, uncomment when adding the minimap
	compass::setupMiniMap("compass_map_mp_spire");
	
	mp_spire_amb::main();

	// Set up the default range of the compass
	SetDvar("compassmaxrange","2100");

	// Set up some generic War Flag Names.
	// Example from COD5: CALLSIGN_SEELOW_A is the name of the 1st flag in Selow whose string is "Cottage" 
	// The string must have MPUI_CALLSIGN_ and _A. Replace Mapname with the name of your map/bsp and in the 
	// actual string enter a keyword that names the location (Roundhouse, Missle Silo, Launchpad, Guard Tower, etc)

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";
	
	level thread exterior_billboard_exploders();
}


function exterior_billboard_exploders()
{
	currentExploder = RandomInt( 4 );

	while( 1 ) 
	{
		level clientfield::set( "mpSpireExteriorBillboard", currentExploder );
		
		wait( 6 );
		
		currentExploder++;
		if ( currentExploder >= 4 ) 
		{
			currentExploder = 0;
		}
	}
}

