// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
// Asset: ordnance_disposal_mp
// Convert Time: 10/21/2011 14:11:18

main()
{
	level.cac_attributes[ "mobility" ][ "ordnance_disposal_mp" ] = 0;
	level.cac_attributes[ "armor_bullet" ][ "ordnance_disposal_mp" ] = 0;
	level.cac_attributes[ "armor_explosive" ][ "ordnance_disposal_mp" ] = 0;
	level.cac_attributes[ "sprint_time_total" ][ "ordnance_disposal_mp" ] = 4;
	level.cac_attributes[ "sprint_time_cooldown" ][ "ordnance_disposal_mp" ] = 0;

	level.cac_assets[ "usa_sog" ][ "ordnance_disposal_mp" ] = "iw5_usa_sog_mp_body_armor";
	level.cac_assets[ "vtn_nva" ][ "ordnance_disposal_mp" ] = "iw5_vtn_nva_mp_body_armor";
	level.cac_assets[ "usa_cia" ][ "ordnance_disposal_mp" ] = "iw5_usa_cia_mp_body_armor";
	level.cac_assets[ "usa_ciawin" ][ "ordnance_disposal_mp" ] = "iw5_usa_ciawin_mp_body_armor";
	level.cac_assets[ "rus_spet" ][ "ordnance_disposal_mp" ] = "iw5_rus_spet_mp_body_armor";
	level.cac_assets[ "rus_spetwin" ][ "ordnance_disposal_mp" ] = "iw5_rus_spetwin_mp_body_armor";
	level.cac_assets[ "cub_rebels" ][ "ordnance_disposal_mp" ] = "iw5_cub_rebels_mp_body_armor";
	level.cac_assets[ "cub_tropas" ][ "ordnance_disposal_mp" ] = "iw5_cub_tropas_mp_body_armor";
	level.cac_assets[ "usa_seals" ][ "ordnance_disposal_mp" ] = "iw5_usa_seals_mp_body_armor";
	level.cac_assets[ "rus_pmc" ][ "ordnance_disposal_mp" ] = "iw5_rus_pmc_mp_body_armor";

	level.cac_assets[ "usa_sog" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_usa_sog_armor_arms";
	level.cac_assets[ "vtn_nva" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_vtn_nva_armor_arms";
	level.cac_assets[ "usa_cia" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_usa_cia_armor_arms";
	level.cac_assets[ "usa_ciawin" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_usa_ciawin_armor_arms";
	level.cac_assets[ "rus_spet" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_rus_spet_armor_arms";
	level.cac_assets[ "rus_spetwin" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_rus_spetwin_armor_arms";
	level.cac_assets[ "cub_rebels" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_cub_rebels_armor_arms";
	level.cac_assets[ "cub_tropas" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_cub_tropas_armor_arms";
	level.cac_assets[ "usa_seals" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_usa_seals_armor_arms";
	level.cac_assets[ "rus_pmc" ][ "viewmodel" ][ "ordnance_disposal_mp" ] = "iw5_viewmodel_rus_pmc_armor_arms";

	level.cac_functions[ "precache" ][ "ordnance_disposal_mp" ] = ::precache;
	level.cac_functions[ "set_body_model" ][ "ordnance_disposal_mp" ] = ::set_body_model;
	level.cac_functions[ "set_specialties" ][ "ordnance_disposal_mp" ] = ::set_specialties;
	level.cac_functions[ "get_default_head" ][ "ordnance_disposal_mp" ] = ::get_default_head;
}

precache( faction )
{
	model = level.cac_assets[ faction ][ "ordnance_disposal_mp" ];
	PrecacheModel( model );

	viewmodel = level.cac_assets[ faction ][ "viewmodel" ][ "ordnance_disposal_mp" ];
	PrecacheModel( viewmodel );
}

set_body_model( faction )
{
	model = level.cac_assets[ faction ][ "ordnance_disposal_mp" ];
	self SetModel( model );

	viewmodel = level.cac_assets[ faction ][ "viewmodel" ][ "ordnance_disposal_mp" ];
	self SetViewModel( viewmodel );
}

set_specialties()
{
}

get_default_head()
{
	return( "head_armor_mp" );
}