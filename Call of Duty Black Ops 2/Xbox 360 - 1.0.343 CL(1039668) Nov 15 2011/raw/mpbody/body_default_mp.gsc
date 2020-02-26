// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: body_default_mp
// Convert Time: 10/21/2011 14:11:17

main()
{
	level.cac_attributes[ "mobility" ][ "body_default_mp" ] = 0;
	level.cac_attributes[ "armor_bullet" ][ "body_default_mp" ] = 0;
	level.cac_attributes[ "armor_explosive" ][ "body_default_mp" ] = 0;
	level.cac_attributes[ "sprint_time_total" ][ "body_default_mp" ] = 4;
	level.cac_attributes[ "sprint_time_cooldown" ][ "body_default_mp" ] = 0;

	level.cac_assets[ "usa_sog" ][ "body_default_mp" ] = "iw5_usa_sog_mp_body_standard";
	level.cac_assets[ "vtn_nva" ][ "body_default_mp" ] = "iw5_vtn_nva_mp_body_standard";
	level.cac_assets[ "usa_cia" ][ "body_default_mp" ] = "iw5_usa_cia_mp_body_standard";
	level.cac_assets[ "usa_ciawin" ][ "body_default_mp" ] = "iw5_usa_ciawin_mp_body_standard";
	level.cac_assets[ "rus_spet" ][ "body_default_mp" ] = "iw5_rus_spet_mp_body_standard";
	level.cac_assets[ "rus_spetwin" ][ "body_default_mp" ] = "iw5_rus_spetwin_mp_body_standard";
	level.cac_assets[ "cub_rebels" ][ "body_default_mp" ] = "iw5_cub_rebels_mp_body_standard";
	level.cac_assets[ "cub_tropas" ][ "body_default_mp" ] = "iw5_cub_tropas_mp_body_standard";
	level.cac_assets[ "usa_seals" ][ "body_default_mp" ] = "iw5_usa_seals_mp_body_standard";
	level.cac_assets[ "rus_pmc" ][ "body_default_mp" ] = "iw5_rus_pmc_mp_body_standard";

	level.cac_assets[ "usa_sog" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_usa_sog_standard_arms";
	level.cac_assets[ "vtn_nva" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_vtn_nva_standard_arms";
	level.cac_assets[ "usa_cia" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_usa_cia_standard_arms";
	level.cac_assets[ "usa_ciawin" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_usa_ciawin_standard_arms";
	level.cac_assets[ "rus_spet" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_rus_spet_standard_arms";
	level.cac_assets[ "rus_spetwin" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_rus_spetwin_standard_arms";
	level.cac_assets[ "cub_rebels" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_cub_rebels_standard_arms";
	level.cac_assets[ "cub_tropas" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_cub_tropas_standard_arms";
	level.cac_assets[ "usa_seals" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_usa_seals_standard_arms";
	level.cac_assets[ "rus_pmc" ][ "viewmodel" ][ "body_default_mp" ] = "iw5_viewmodel_rus_pmc_standard_arms";

	level.cac_functions[ "precache" ][ "body_default_mp" ] = ::precache;
	level.cac_functions[ "set_body_model" ][ "body_default_mp" ] = ::set_body_model;
	level.cac_functions[ "set_specialties" ][ "body_default_mp" ] = ::set_specialties;
	level.cac_functions[ "get_default_head" ][ "body_default_mp" ] = ::get_default_head;
}

precache( faction )
{
	model = level.cac_assets[ faction ][ "body_default_mp" ];
	PrecacheModel( model );

	viewmodel = level.cac_assets[ faction ][ "viewmodel" ][ "body_default_mp" ];
	PrecacheModel( viewmodel );
}

set_body_model( faction )
{
	model = level.cac_assets[ faction ][ "body_default_mp" ];
	self SetModel( model );

	viewmodel = level.cac_assets[ faction ][ "viewmodel" ][ "body_default_mp" ];
	self SetViewModel( viewmodel );
}

set_specialties()
{
}

get_default_head()
{
	return( "head_standard_mp" );
}