// _createart generated.  modify at your own risk. Changing values should be fine.
main()
{

	level.tweakfile = true;
 
	//* depth of field section * 

	level.dofDefault[ "nearStart" ] = 0;
	level.dofDefault[ "nearEnd" ] = 1;
	level.dofDefault[ "farStart" ] = 499;
	level.dofDefault[ "farEnd" ] = 500;
	level.dofDefault[ "nearBlur" ] = 4.5;
	level.dofDefault[ "farBlur" ] = 0.05;
	getent( "player", "classname" ) maps\_art::setdefaultdepthoffield();

	//* Fog section * 

	setdvar( "scr_fog_disable", "0" );

	setExpFog(400, 6500, 0.678352, 0.511225, 0.372533, 0);
	maps\_utility::set_vision_set( "airlift", 0 );

}
