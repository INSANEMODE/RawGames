#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\rat_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

/#
#namespace rat;

function autoexec __init__sytem__() {     system::register("rat",&__init__,undefined,undefined);    }
	
function __init__()
{
	rat_shared::init();
	
	// Set up common function for the shared rat script commands to call
	level.rat.common.gethostplayer = &util::getHostPlayer;

}
#/	



