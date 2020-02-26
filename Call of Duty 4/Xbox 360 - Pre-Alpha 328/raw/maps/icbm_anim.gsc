#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree("generic_human");

main()
{
	anims();
	patrol();
	tower_explode_anims();
	//run_anims();
	
	//Price - Haggerty, you see where Griggs landed?
	level.scr_sound[ "price" ][ "grigsby_landed" ]				= "icbm_pri_wherelanded";
	
	//SAS1 - Yeah, over by the buildings to the east. You think they got him?
	level.scr_sound[ "generic" ][ "bybuildingseast" ]				= "icbm_uk2_buildingseast";
	
	//Price - We're about to find out. Haggerty, take point
	level.scr_sound[ "price" ][ "abouttofindout" ]				= "icbm_pri_tofindout";
	
	//SAS1 - You got it sir
	level.scr_sound[ "generic" ][ "yougotit" ]				= "icbm_uk2_yougotit";
	
	//SAS1 - Contact front. Enemy vehicle.
	level.scr_sound[ "generic" ][ "enemyvehicle" ]				= "icbm_uk2_contactfront";
	
	//SAS1 - Enemy in sight
	level.scr_sound[ "generic" ][ "insight" ]				= "icbm_sas3_insight";

	
	//Price - Move
	level.scr_sound[ "price" ][ "move" ]				= "icbm_pri_move";
	
	//Price - They must have Griggs in one of those houses.
	level.scr_sound[ "price" ][ "griggsinhouses" ]				= "icbm_pri_griggsinhouses";
	
	//Price - Keep it quiet
	level.scr_sound[ "price" ][ "keepitquiet" ]				= "icbm_pri_basementdoor";
	
	//SAS1 - Room clear
	level.scr_sound[ "generic" ][ "roomclear" ]				= "icbm_uk2_roomclear";
	
	//SAS2 - Room clear
	level.scr_sound[ "generic" ][ "roomclear2" ]				= "icbm_uk2_roomclear2";
	
	//SAS2 - neutralized
	level.scr_sound[ "generic" ][ "neutralized" ]				= "icbm_sas2_neutralized";
	
	//SAS2 - One clear
	level.scr_sound[ "generic" ][ "1clear" ]				= "icbm_uk2_1clear";
	
	//SAS1 - Roger
	level.scr_sound[ "generic" ][ "roger" ]				= "icbm_uk2_roger";
	
	//SAS1 - Floor Clear
	level.scr_sound[ "generic" ][ "floorsclear" ]				= "icbm_uk2_floorsclear";
	
	//SAS1 - Proceeding upstairs
	level.scr_sound[ "generic" ][ "proceedupstairs" ]				= "icbm_uk2_proceedupstairs";
	
	//SAS2 - building1 clear
	level.scr_sound[ "generic" ][ "building1clear" ]				= "icbm_uk2_1clear";
	
	//SAS1 - Tango down
	level.scr_sound[ "generic" ][ "tangodown" ]				= "icbm_sas2_tangodown";
	
	//SAS1 - Copy that
	level.scr_sound[ "generic" ][ "copythat" ]				= "icbm_uk2_copythat";
		
	//Price - Regroup on me.
	level.scr_sound[ "price" ][ "regrouponme" ]				= "icbm_pri_regrouponme";
	
	//Price - Jackson regroup
	level.scr_sound[ "price" ][ "jacksonregroup" ]				= "icbm_pri_jacksonregroup";
		
	//Price - Lets go
	level.scr_sound[ "price" ][ "letsgo" ]				= "icbm_pri_letsgo";
	
	//Price - Move to next house
	level.scr_sound[ "price" ][ "nexthouse" ]				= "icbm_pri_nexthouse";
	
	//SAS2 - Contact
	level.scr_sound[ "generic" ][ "contact" ]				= "icbm_sas2_contact";
	
	//SAS2 - All Clear
	level.scr_sound[ "generic" ][ "allclear" ]				= "icbm_uk2_allclear";
	
	//SAS2 - Building 2 secured
	level.scr_sound[ "generic" ][ "building2secured" ]				= "icbm_sas2_2secured";
	
	
	//Mark - Leave me behind
	level.scr_sound[ "mark" ][ "leavemebehind" ]				= "icbm_grg_leavemebehind";
	
	//Price - You all right?
	level.scr_sound[ "price" ][ "youallright" ]				= "icbm_pri_youallright";
	
	//Mark - Good to go
	level.scr_sound[ "mark" ][ "goodtogo" ]				= "icbm_grg_goodtogo";
	
	//Price - That was the plan
	level.scr_sound[ "price" ][ "gotgriggs" ]				= "icbm_pri_gotgriggs";
	
	//SAS2 - Choppers
	level.scr_sound[ "generic" ][ "enemyhelicopters" ]				= "icbm_uk2_helicopters";
	
	//Price - Slicks in bound
	level.scr_sound[ "price" ][ "slicksinbound" ]				= "icbm_pri_slicksinbound";
	
	//Price - Status
	level.scr_sound[ "price" ][ "status" ]				= "icbm_pri_team2status";
	
	//Prices radio - Kill power
	level.scr_sound[ "price" ][ "killthepower" ]				= "icbm_gm4_inposition";
	
	//Price - Roger. Jackson. Plant the charges. Go
	level.scr_sound[ "price" ][ "jackgriggsplant" ]				= "icbm_pri_jacksonplant";
	 
	 //Mark - Charges set. Everyone get clear
	level.scr_sound[ "mark" ][ "chargesset" ]				= "icbm_grg_chargesset";
	
	//Price - Jackson DO IT!
	level.scr_sound[ "price" ][ "doit" ]				= "icbm_pri_doit";
	
	//Price - Team Two, the tower's down and the power's out. Twenty seconds.
	level.scr_sound[ "price" ][ "towersdown" ]				= "icbm_pri_powersout";
	
	//Price radio - Roger. We're breaching the perimeter. Standby.
	level.scr_sound[ "price" ][ "breachingperimeter" ]				= "icbm_gm4_breachperimeter";
	
	//Price radio - standby
	level.scr_sound[ "price" ][ "standby" ]				= "icbm_gm4_standby";
	
	//Mark - Backup power in ten seconds�
	level.scr_sound[ "mark" ][ "backuppower" ]				= "icbm_grg_backuppower";	
	
	//Mark - Five seconds�
	level.scr_sound[ "mark" ][ "fiveseconds" ]				= "icbm_grg_fiveseconds";
	
	//Price radio - Meet at rallypoint
	level.scr_sound[ "price" ][ "rallypoint" ]				= "icbm_gm4_rallypoint";
	
	//Price - Roger Team Two, we're on our way. Out
	level.scr_sound[ "price" ][ "onourway" ]				= "icbm_pri_onourway";
	
	//Mark - Backup power's online. Damn that was close!
	level.scr_sound[ "mark" ][ "poweronline" ]				= "icbm_grg_poweronline";
	
	//Price - Get that fence open
	level.scr_sound[ "price" ][ "getfenceopen" ]				= "icbm_pri_getfenceopen";
	
	//Mark - Gonna get real busy around here soon�
	level.scr_sound[ "mark" ][ "getbusy2" ]				= "icbm_grg_getbusy2";
	
	//Marine4 - Team One, this is Team Two.  Three trucks packed with shooters are headed your way.
	level.scr_sound[ "price" ][ "truckswithshooters" ]				= "icbm_gm5_3trucks";	
	
	//Price - Roger that
	level.scr_sound[ "price" ][ "rogerthat" ]				= "icbm_pri_rogerthat";	
	
	//Price - Copy. We're entering the old base now. Standby.
	level.scr_sound[ "price" ][ "approachingbase" ]				= "icbm_pri_oldbase";
	
	//Marine1 - I have a visual on the trucks. There's a shitload of troops sir.
	level.scr_sound[ "generic" ][ "haveavisual" ]				= "icbm_uk2_visualontrucks";
	
	//Price - All right squad, you know the drill.  Griggs, you're with Jackson. Haggerty, on me. Move.
	level.scr_sound[ "price" ][ "youknowdrill" ]				= "icbm_pri_youknowdrill";
	
	//NEW BASE LINES///////////////
	
	//Price - They�re flanking around through the buildings.
	level.scr_sound[ "price" ][ "flankingthrough" ]				= "icbm_pri_flankingthrough";
	
	//SAS1 - RPG on rooftops
	level.scr_sound[ "generic" ][ "rpgsonrooftop" ]				= "icbm_sas1_rpgsonrooftop";
	
	//SAS2 - RPG on rooftops2
	level.scr_sound[ "generic" ][ "rpgsonrooftop2" ]				= "icbm_sas2_rpgsonrooftops";
		
	//Price - Jackson grab an RPG...
	level.scr_sound[ "price" ][ "grabrpg" ]				= "icbm_pri_grabrpg";
	
	//Price - WHATCH OUT BEHIND US
	level.scr_sound[ "price" ][ "behindus" ]				= "icbm_pri_behindus";	
		
	//SAS1 - Tangos behind us
	level.scr_sound[ "generic" ][ "behindus2" ]				= "icbm_sas1_behindus";
	
	//Price - WHATCH OUT BEHIND US
	level.scr_sound[ "price" ][ "takeoutbmp" ]				= "icbm_pri_takeoutbmp";
	
	//Price - Keep moving...
	level.scr_sound[ "price" ][ "keepmoving" ]				= "icbm_pri_keepmoving";
			
	//SAS1 - Heads up, choppers inbound
	level.scr_sound[ "generic" ][ "choppersinbound" ]				= "icbm_sas1_choppersinbound";
	
	//Price - Troops dropping
	level.scr_sound[ "price" ][ "droppingin" ]				= "icbm_pri_droppingin";
	
	//NUKE LAUNCH///////////////
	
	//SAS1 - look to the south east
	level.scr_sound[ "generic" ][ "whatthe" ]				= "icbm_uk2_looksoutheast";
	
	//Mark - What the hell�
	level.scr_sound[ "mark" ][ "problemhere" ]				= "icbm_grg_problemhere";
	
	//Price - Delta One X-Ray, we have a missile launch, I repeat we have a missile
	level.scr_sound[ "price" ][ "onemissile" ]				= "icbm_pri_onemissile";
	
	//Mark - There's another one!
	level.scr_sound[ "mark" ][ "anotherone" ]				= "icbm_grg_anotherone";
	
	//Price - Delta One X-Ray - we have two missiles in the air over!
	level.scr_sound[ "price" ][ "twomissiles" ]				= "icbm_pri_twomissiles";
	
	//HQ on Price's Radio
	level.scr_sound[ "price" ][ "gettingabortcodes" ]				= "icbm_hqr_satellitestracking";
	
	//Mark - Shits hit the fan now
	level.scr_sound[ "mark" ][ "itsonnow" ]				= "icbm_grg_itsonnow";
	
	//Price - You're tellin' me�. Let's go! We gotta move!
	level.scr_sound[ "price" ][ "youretellinme" ]				= "icbm_pri_gottomove";
	
	//Marine5 - Bravo Six, Sniper Team Two. We're comin' outta the treeline to the south.
	level.scr_sound[ "gm5" ][ "treeline" ]				= "icbm_gm5_treelineS";	
	
	//Price - Hold your fire, it's one of the American teams.
	level.scr_sound[ "price" ][ "americanteams" ]				= "icbm_pri_americanteams";
	
	//Marine5 - Good to see you guys made it. We'll give you sniper cover once your inside the perime-what the hell is that?
	level.scr_sound[ "gm5" ][ "goodtosee" ]				= "icbm_gm5_whatthe";	
	
	
	//NEW LINES
	
	//Marine3 - Grigs isn't here
	level.scr_sound[ "generic" ][ "griggsnothere" ]				= "icbm_uk2_griggsisnthere";	
	
	//Price - Roger that, regroup on me downstairs.
	level.scr_sound[ "price" ][ "regroupdownstairs" ]				= "icbm_pri_regroupdownstairs";
	
	//Price - Moving to the next house, keep it quiet
	level.scr_sound[ "price" ][ "keepquiet" ]				= "icbm_pri_keepitquiet";

	//Price - Suns coming up. We�re running out of time.
	level.scr_sound[ "price" ][ "sunsup" ]				= "icbm_pri_sunscomingup";
		
	//Price - We need to blow up that power tower so second squad can breach the electric perimeter fence.
	level.scr_sound[ "price" ][ "blowuptower" ]				= "icbm_pri_knockouttower";
		
	//Price - They�re flanking around us from behind!!
	level.scr_sound[ "price" ][ "flankingbehind" ]				= "icbm_pri_flankingbehind";	
	
	//RUSSIAN INTEROGATION SECENE
	//RU1 - Where are the others?
	level.scr_sound[ "ru1" ][ "whereothers" ]				= "icbm_ru1_whereothers";
		
	//Mark - Griggs. 678-45-2056.	
	level.scr_sound[ "mark" ][ "grg_678452056" ]				= "icbm_grg_678452056";
	
	//RU1 - You know tovarisch, the Geneva Convention is a nice idea in theory, no? Why don't you save yourself the trouble and simply answer my questions?
	level.scr_sound[ "ru1" ][ "tovarisch" ]				= "icbm_ru1_tovarisch";

	//RU1 - How many others are there?
	level.scr_sound[ "ru1" ][ "howmany" ]				= "icbm_ru1_howmany";
	
	//Mark - Griggs. 678...	
	level.scr_sound[ "mark" ][ "grg_678" ]				= "icbm_grg_678";
	
	//RU1 - who is officer
	level.scr_sound[ "ru1" ][ "whoisofficer" ]				= "icbm_ru1_whoisofficer";	
	
	//Mark - Blow me
	level.scr_sound[ "mark" ][ "blowme" ]				= "icbm_grg_getbusy";
	
	//RU1 - Yuri - where's the hacksaw?
	level.scr_sound[ "ru1" ][ "whereshacksaw" ]				= "icbm_ru1_whereshacksaw";	
	
	//RU2 - Yuri - I thought you had it.
	level.scr_sound[ "ru1" ][ "youhadit" ]				= "icbm_ru2_youhadit";	
	
	//RU1 - If I had the fuckin' hacksaw I wouldn't have asked for it in the first place you dumb shit!
	level.scr_sound[ "ru1" ][ "ifihad" ]				= "icbm_ru1_ifihad";	
	
	//BREACH GIGS SCENE
	//Price - Looks like this is the place.
	level.scr_sound[ "price" ][ "thisisplace" ]				= "icbm_pri_thisisplace";	
	
	//Price - Get ready to breach
	level.scr_sound[ "price" ][ "readytobreach" ]				= "icbm_pri_readytobreach";	
	
	//Price - Go go go!!
	level.scr_sound[ "price" ][ "gogogo" ]				= "icbm_pri_gogogo";	

	//Price - Jackson, cut grigs loose.
	level.scr_sound[ "price" ][ "cutloose" ]				= "icbm_pri_cutloose";	
	
	
		
}

patrol()
{
	level.scr_anim[ "generic" ][ "patrol_walk" ]			= %patrol_bored_patrolwalk;
	level.scr_anim[ "generic" ][ "patrol_walk_twitch" ]		= %patrol_bored_patrolwalk_twitch;
	level.scr_anim[ "generic" ][ "patrol_stop" ]			= %patrol_bored_walk_2_bored;
	level.scr_anim[ "generic" ][ "patrol_start" ]			= %patrol_bored_2_walk;
	level.scr_anim[ "generic" ][ "patrol_turn180" ]			= %patrol_bored_2_walk_180turn;
	
	level.scr_anim[ "generic" ][ "patrol_idle_1" ]			= %patrol_bored_idle;
	level.scr_anim[ "generic" ][ "patrol_idle_2" ]			= %patrol_bored_idle_smoke;
	level.scr_anim[ "generic" ][ "patrol_idle_3" ]			= %patrol_bored_idle_cellphone;
	level.scr_anim[ "generic" ][ "patrol_idle_4" ]			= %patrol_bored_twitch_bug;
	level.scr_anim[ "generic" ][ "patrol_idle_5" ]			= %patrol_bored_twitch_checkphone;
	level.scr_anim[ "generic" ][ "patrol_idle_6" ]			= %patrol_bored_twitch_stretch;	
}

anims()
{
	// First house
	level.scr_anim[ "price" ][ "hunted_open_barndoor" ] =			%hunted_open_barndoor;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_stop" ] =		%hunted_open_barndoor_stop;
	level.scr_anim[ "price" ][ "hunted_open_barndoor_idle" ][0] =	%hunted_open_barndoor_idle;
	
	level.scr_anim["hostile"]["patrol_twitch"]					= %patrolstand_twitch;
	
	level.scr_anim["hostile"]["phoneguy_idle_start"]			= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_idle"][0]				= %parabolic_phoneguy_idle;
	level.scr_anim["hostile"]["phoneguy_alerted"]				= %parabolic_phoneguy_reaction;
	level.scr_anim["hostile"][ "phoneguy_death" ]				= %ICBM_patrol_knifekill_looser;

	/*-----------------------
	KNIFE KILL SEQUENCE
	-------------------------*/	
	level.scr_anim[ "price" ][ "knifekill_price" ]			= %ICBM_patrol_knifekill_winner;
	level.scr_anim[ "price" ][ "knifekill_altending_mark" ]	= %parabolic_knifekill_altending_mark;
	
	
	level.scr_anim[ "price" ][ "signal_assault_coverstand" ]		= %coverstand_hide_idle_wave02;
	level.scr_anim[ "price" ][ "signal_forward_coverstand" ]		= %coverstand_hide_idle_wave01;
	
	//griggs scene
	level.scr_anim[ "mark" ][ "grigsby_rescue" ]			= %grigsby_rescue;
	level.scr_anim[ "mark" ][ "grigsby_rescue_idle" ][0]	= %grigsby_rescue_idle;
	
	level.scr_anim[ "generic" ][ "icbm_fence_cutting_guys" ]		= %icbm_fence_cutting_guy1;
	level.scr_anim[ "mark" ][ "icbm_fence_cutting_guys" ]		= %icbm_fence_cutting_guy2;	
	
	
	

	//end scene
	level.scr_anim[ "price" ][ "icbm_end_price" ]			= %icbm_end_price;
	level.scr_anim[ "gm5" ][ "icbm_end_sniper" ]	= %icbm_end_sniper;
	
	
			
			
	
	
}

#using_animtree( "icbm" );
tower_explode_anims()
{
	level.scr_animtree[ "tower" ]		= #animtree;
	level.scr_anim[ "tower" ][ "explosion" ]		= %ICBM_power_tower_crash;
	
	level.scr_animtree[ "wire" ]		= #animtree;
	
	level.scr_anim[ "wire" ][ "idle0" ][0]			= %ICBM_power_tower_wire_idle_LE1;
	level.scr_anim[ "wire" ][ "idle1" ][0]			= %ICBM_power_tower_wire_idle_LE2;
	level.scr_anim[ "wire" ][ "idle2" ][0]			= %ICBM_power_tower_wire_idle_LE3;
	
	level.scr_anim[ "wire" ][ "idle3" ][0]			= %ICBM_power_tower_wire_idle_RI1;
	level.scr_anim[ "wire" ][ "idle4" ][0]			= %ICBM_power_tower_wire_idle_RI2;
	level.scr_anim[ "wire" ][ "idle5" ][0]			= %ICBM_power_tower_wire_idle_RI3;
	
	level.scr_anim[ "wire" ][ "idle6" ][0]			= %ICBM_power_tower_wire_idle_LE4;
	level.scr_anim[ "wire" ][ "idle7" ][0]			= %ICBM_power_tower_wire_idle_LE5;
	level.scr_anim[ "wire" ][ "idle8" ][0]			= %ICBM_power_tower_wire_idle_LE6;	
	
	level.scr_anim[ "wire" ][ "idle9" ][0]			= %ICBM_power_tower_wire_idle_RI4;
	level.scr_anim[ "wire" ][ "idle10" ][0]			= %ICBM_power_tower_wire_idle_RI5;
	level.scr_anim[ "wire" ][ "idle11" ][0]			= %ICBM_power_tower_wire_idle_RI6;
	
	
	level.scr_anim[ "wire" ][ "explosion0" ]			= %ICBM_power_tower_wire_LE1;
	level.scr_anim[ "wire" ][ "explosion1" ]			= %ICBM_power_tower_wire_LE2;
	level.scr_anim[ "wire" ][ "explosion2" ]			= %ICBM_power_tower_wire_LE3;
	
	level.scr_anim[ "wire" ][ "explosion3" ]			= %ICBM_power_tower_wire_RI1;
	level.scr_anim[ "wire" ][ "explosion4" ]			= %ICBM_power_tower_wire_RI2;
	level.scr_anim[ "wire" ][ "explosion5" ]			= %ICBM_power_tower_wire_RI3;
	
	level.scr_anim[ "wire" ][ "explosion6" ]			= %ICBM_power_tower_wire_LE4;
	level.scr_anim[ "wire" ][ "explosion7" ]			= %ICBM_power_tower_wire_LE5;
	level.scr_anim[ "wire" ][ "explosion8" ]			= %ICBM_power_tower_wire_LE6;	
	
	level.scr_anim[ "wire" ][ "explosion9" ]			= %ICBM_power_tower_wire_RI4;
	level.scr_anim[ "wire" ][ "explosion10" ]			= %ICBM_power_tower_wire_RI5;
	level.scr_anim[ "wire" ][ "explosion11" ]			= %ICBM_power_tower_wire_RI6;
	
		
	addNotetrack_customFunction( "tower", "powertower_break", maps\icbm::tower_legBreak_fx, "explosion" );
	addNotetrack_customFunction( "tower", "powertower_sparks", maps\icbm::tower_spark_fx, "explosion" );
	addNotetrack_customFunction( "tower", "powertower_crash", maps\icbm::tower_impact_fx, "explosion" );
	
	level.scr_animtree[ "fence" ]		= #animtree;
	
	level.scr_anim[ "fence" ][ "model_cut" ]			= %icbm_fence_cutting_guy1_fence;
	
	
	
}
