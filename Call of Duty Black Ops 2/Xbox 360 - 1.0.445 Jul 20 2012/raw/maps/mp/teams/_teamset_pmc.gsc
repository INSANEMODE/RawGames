main()
{
	init( "axis" );

	maps\mp\teams\_teamset::customteam_init();
	precache();
}

init( team )
{
	maps\mp\teams\_teamset::init();

	game[team] = "pmc";
	game["defenders"] = team;

	// head icons
	PrecacheShader( "faction_pmc" );
	game["entity_headicon_" + team] = "faction_pmc";
	game["headicon_" + team] = "faction_pmc";
	
	// battle chatter
	level.teamPrefix[team] = "vox_pm";
	level.teamPostfix[team] = "pmc";

	// scoreboard
	SetDvar("g_TeamName_" + team, &"MPUI_PMC_SHORT");
	SetDvar("g_TeamColor_" + team, "0.65 0.57 0.41");		
	SetDvar("g_ScoresColor_" + team, "0.65 0.57 0.41");
	SetDvar("g_FactionName_" + team, "rus_pmc" );
	
	game["strings"][team + "_win"] = &"MP_PMC_WIN_MATCH";
	game["strings"][team + "_win_round"] = &"MP_PMC_WIN_ROUND";
	game["strings"][team + "_mission_accomplished"] = &"MP_PMC_MISSION_ACCOMPLISHED";
	game["strings"][team + "_eliminated"] = &"MP_PMC_ELIMINATED";
	game["strings"][team + "_forfeited"] = &"MP_PMC_FORFEITED";
	game["strings"][team + "_name"] = &"MP_PMC_NAME";
	
	game["music"]["spawn_" + team] = "SPAWN_PMC";
	game["music"]["victory_" + team] = "mus_victory_soviet";
	game["icons"][team] = "faction_pmc";
	game["voice"][team] = "vox_pmc_";
	SetDvar( "scr_" + team, "ussr" );

	level.heli_vo[team]["hit"] = "vox_rus_0_kls_attackheli_hit";

	// flag assets
	game["flagmodels"][team] = "mp_flag_axis_2";
	game["carry_flagmodels"][team] = "mp_flag_axis_2_carry";
	game["carry_icon"][team] = "hudicon_spetsnaz_ctf_flag_carry";
}

precache()
{
	mpbody\class_assault_rus_pmc::precache();
	mpbody\class_lmg_rus_pmc::precache();
	mpbody\class_shotgun_rus_pmc::precache();
	mpbody\class_smg_rus_pmc::precache();
	mpbody\class_sniper_rus_pmc::precache();
}