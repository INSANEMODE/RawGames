// Test clientside script for mp_socotra

#include clientscripts\mp\_utility;

main()
{
	// team nationality
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_socotra_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_socotra_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/# println("*** Client : mp_socotra running..."); #/
}
