// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_smg
// Convert Time: 11/11/2011 00:10:55
#include common_scripts\utility;

precache()
{
	PrecacheModel( "c_mul_mp_manticore_smg_body" );
	PrecacheModel( "iw5_viewmodel_usa_sog_standard_arms" );
	PrecacheModel( "c_mul_mp_manticore_smg_head" );

	game["set_player_model"]["axis"]["smg"] = ::set_player_model;
}

set_player_model()
{
	self SetModel( "c_mul_mp_manticore_smg_body" );
	self SetViewModel( "iw5_viewmodel_usa_sog_standard_arms" );

	heads = [];
	heads[ 0 ] = "c_mul_mp_manticore_smg_head";

	head = random( heads );
	self Attach( head, "", true );
}

