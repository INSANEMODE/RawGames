// Test clientside script for mp_drone

#include clientscripts\mp\_utility;

main()
{
	// ******** remove before shipping when fx are final
	// clientscripts\mp\_fx::disableAllParticleFxInLevel();
	// ******** remove before shipping when fx are final

	// team nationality
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_drone_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_drone_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	/# println("*** Client : mp_drone running..."); #/
}
