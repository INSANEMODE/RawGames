#using scripts\shared\ai\archetype_utility;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
   	     	                                                                                                                                                                                                                                                                                                                                                                                                                                                             	                                                                                                                	    	                                                                                                  

#namespace AnimationStateNetworkUtility;

// ------------------- Functions to be updated and maintained after the integration in T7 --------------------------------------//

function RequestState( entity, stateName )
{
	assert( IsDefined( entity ) );
	entity ASMRequestSubState( stateName );
}

function SearchAnimationMap( entity, aliasName )
{
	if ( IsDefined( entity ) && IsDefined( aliasName ) )
	{
		animationName = entity AnimMappingSearch( IString( aliasName ));
		
		if ( IsDefined( animationName ) )
			return FindAnimByName( "generic", animationName );
	}
}
