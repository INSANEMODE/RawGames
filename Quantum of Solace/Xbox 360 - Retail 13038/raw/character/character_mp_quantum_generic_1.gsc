// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\mp_quantum_bodies_B2::getnextmodel();
	self setModel( body );
	headArray = xmodelalias\mp_henchman_head_masks::main();
	headIdx = codescripts\character_mp::attachFromArray(headArray);
}

precache()
{
	codescripts\character_mp::precacheModelArray(xmodelalias\mp_quantum_bodies_B2::main());
	codescripts\character_mp::precacheModelArray(xmodelalias\mp_henchman_head_masks::main());
}
