#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	level thread snd_dmg_chant();
}
function snd_dmg_chant()
{
	trigger = getent("snd_chant", "targetname" );
    if (!isdefined (trigger))
    {
    	return;
    }
    while(1)
    {
        trigger waittill( "trigger", who );
        if( isplayer(who) )
        {
        	trigger playsound ("amb_monk_chant");
        	wait (120);
        }
    }	
}