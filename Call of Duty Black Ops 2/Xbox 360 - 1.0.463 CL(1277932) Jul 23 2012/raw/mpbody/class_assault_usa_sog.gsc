// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: class_assault
// Convert Time: 03/01/2012 01:49:38
#include common_scripts\utility;

precache()
{
	PrecacheModel( "iw5_usa_sog_mp_body_standard" );
	PrecacheModel( "iw5_viewmodel_usa_sog_standard_arms" );
	PrecacheModel( "iw5_usa_sog_mp_head_1" );
	PrecacheModel( "iw5_usa_sog_mp_head_2" );
	PrecacheModel( "iw5_usa_sog_mp_head_3" );

	game["set_player_model"]["allies"]["default"] = ::set_player_model;
}

set_player_model()
{
	self SetModel( "iw5_usa_sog_mp_body_standard" );
	self SetViewModel( "iw5_viewmodel_usa_sog_standard_arms" );

	heads = [];
	heads[ 0 ] = "iw5_usa_sog_mp_head_1";
	heads[ 1 ] = "iw5_usa_sog_mp_head_2";
	heads[ 2 ] = "iw5_usa_sog_mp_head_3";

	head = random( heads );
	self Attach( head, "", true );
}

