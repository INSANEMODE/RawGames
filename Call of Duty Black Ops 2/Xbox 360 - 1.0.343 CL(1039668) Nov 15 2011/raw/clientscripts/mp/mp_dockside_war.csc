// Test clientside script for mp_dockside

#include clientscripts\mp\_utility;

main()
{
	// team nationality
	clientscripts\mp\_teamset_junglemarines::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_dockside_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_dockside_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : mp_dockside_war running...");
}
