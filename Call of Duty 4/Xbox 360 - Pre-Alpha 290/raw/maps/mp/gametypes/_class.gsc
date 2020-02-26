#include common_scripts\utility;
// check if below includes are removable
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

init()
{
	precacheString(&"CLASS_CLOSEQUARTERS");
	precacheString(&"CLASS_ASSAULT");
	precacheString(&"CLASS_SNIPER");
	precacheString(&"CLASS_ENGINEER");
	precacheString(&"CLASS_ANTIARMOR");
	precacheString(&"CLASS_SUPPORT");
	precacheString(&"CLASS_NEWPROF");
	precacheString(&"CLASS_PROFICIENCY_MARKSMAN");
	precacheString(&"CLASS_PROFICIENCY_SHARPSHOOTER");
	precacheString(&"CLASS_PROFICIENCY_EXPERT");
	precacheString(&"CLASS_CUSTOM1");
	precacheString(&"CLASS_CUSTOM2");
	precacheString(&"CLASS_CUSTOM3");
	precacheString(&"CLASS_CUSTOM4");
	precacheString(&"CLASS_CUSTOM5");
	
	level.classList = [];
	level.classList[level.classList.size] = "CLASS_CLOSEQUARTERS";
	level.classList[level.classList.size] = "CLASS_ASSAULT";
	level.classList[level.classList.size] = "CLASS_SNIPER";
	level.classList[level.classList.size] = "CLASS_ENGINEER";
	level.classList[level.classList.size] = "CLASS_ANTIARMOR";
	level.classList[level.classList.size] = "CLASS_SUPPORT";
	
	// custom classes added to the list
	level.classList[level.classList.size] = "CLASS_CUSTOM1";
	level.classList[level.classList.size] = "CLASS_CUSTOM2";
	level.classList[level.classList.size] = "CLASS_CUSTOM3";
	level.classList[level.classList.size] = "CLASS_CUSTOM4";
	level.classList[level.classList.size] = "CLASS_CUSTOM5";

	level.classes["CLASS_CLOSEQUARTERS"] = &"CLASS_CLOSEQUARTERS";
	level.classes["CLASS_ASSAULT"] = &"CLASS_ASSAULT";
	level.classes["CLASS_SNIPER"] = &"CLASS_SNIPER";
	level.classes["CLASS_ENGINEER"] = &"CLASS_ENGINEER";
	level.classes["CLASS_ANTIARMOR"] = &"CLASS_ANTIARMOR";
	level.classes["CLASS_SUPPORT"] = &"CLASS_SUPPORT";
	
	level.classes["CLASS_CUSTOM1"] = &"CLASS_CUSTOM1";	// assault
	level.classes["CLASS_CUSTOM2"] = &"CLASS_CUSTOM2";	// spec ops
	level.classes["CLASS_CUSTOM3"] = &"CLASS_CUSTOM3";	// heavy gunner
	level.classes["CLASS_CUSTOM4"] = &"CLASS_CUSTOM4";	// demolition
	level.classes["CLASS_CUSTOM5"] = &"CLASS_CUSTOM5";	// sniper
	
	level.classMap["demolition_mp"] = "CLASS_CLOSEQUARTERS";		
	level.classMap["stealth_mp"] = "CLASS_ASSAULT";
	level.classMap["recon_mp"] = "CLASS_SNIPER";
	level.classMap["survivalist_mp"] = "CLASS_ENGINEER";
	level.classMap["antiarmor_mp"] = "CLASS_ANTIARMOR";
	level.classMap["warfighter_mp"] = "CLASS_SUPPORT";
	
	/* multimapping
	
	CLASS_CLOSEQUARTERS: 	Demolitions
	CLASS_ASSAULT:			Sniper
	CLASS_SNIPER:			Spec Ops
	CLASS_ENGINEER			Heavy Gunner	
	CLASS_SUPPORT			Assault
	
	demolition_mp			Demolitions
	stealth_mp				Sniper
	recon_mp				Spec Ops
	survivalist_mp			Heavy Gunner
	warfighter_mp			Assault
	
	*/
	
	level.classMap["custom1"] = "CLASS_CUSTOM1";
	level.classMap["custom2"] = "CLASS_CUSTOM2";
	level.classMap["custom3"] = "CLASS_CUSTOM3";
	level.classMap["custom4"] = "CLASS_CUSTOM4";
	level.classMap["custom5"] = "CLASS_CUSTOM5";
	
	// default classes' specialties
	level.default_class[level.classMap["demolition_mp"]] = [];
	level.default_class[level.classMap["stealth_mp"]] = [];
	level.default_class[level.classMap["recon_mp"]] = [];
	level.default_class[level.classMap["survivalist_mp"]] = [];
	level.default_class[level.classMap["warfighter_mp"]] = [];
	
	// ============================= SET DEFAULT CLASS SPECIALTIES =====================================
	level.default_class[level.classMap["demolition_mp"]][0] = "specialty_extraammo";
	level.default_class[level.classMap["demolition_mp"]][1] = "specialty_explosivedamage";
	level.default_class[level.classMap["stealth_mp"]][0] = "specialty_gpsjammer";
	level.default_class[level.classMap["stealth_mp"]][1] = "specialty_bulletpenetration";
	level.default_class[level.classMap["stealth_mp"]][2] = "specialty_holdbreath";
	level.default_class[level.classMap["recon_mp"]][0] = "specialty_bulletaccuracy";
	level.default_class[level.classMap["recon_mp"]][1] = "specialty_longersprint";
	level.default_class[level.classMap["survivalist_mp"]][0] = "specialty_armorvest";
	level.default_class[level.classMap["survivalist_mp"]][1] = "specialty_grenadepulldeath";
	level.default_class[level.classMap["warfighter_mp"]][0] = "specialty_bulletdamage";
	level.default_class[level.classMap["warfighter_mp"]][1] = "specialty_pistoldeath";
	
	level.proficiencies["PROFICIENCY_MARKSMAN"] = &"CLASS_PROFICIENCY_MARKSMAN";
	level.proficiencies["PROFICIENCY_SHARPSHOOTER"] = &"CLASS_PROFICIENCY_SHARPSHOOTER";
	level.proficiencies["PROFICIENCY_EXPERT"] = &"CLASS_PROFICIENCY_EXPERT";
	
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowfrag" ) )
		level.weapons["frag"] = "frag_grenade_mp";
	else	
		level.weapons["frag"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowsmoke" ) )
		level.weapons["smoke"] = "smoke_grenade_mp";
	else	
		level.weapons["smoke"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowflash" ) )
		level.weapons["flash"] = "flash_grenade_mp";
	else	
		level.weapons["flash"] = "";

	level.weapons["concussion"] = "concussion_grenade_mp";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowc4" ) )
		level.weapons["c4"] = "c4_mp";
	else	
		level.weapons["c4"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowclaymores" ) )
		level.weapons["claymore"] = "claymore_mp";
	else	
		level.weapons["claymore"] = "";

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "weapon", "allowrpgs" ) )
	{
		level.weapons["rpg"] = "rpg_mp";
		level.weapons["at4"] = "at4_mp";
	}
	else	
	{
		level.weapons["rpg"] = "";
		level.weapons["at4"] = "";
	}
	
	// default class weapon loadout for offline mode
	level.classWeapons["allies"]["CLASS_CLOSEQUARTERS"][0] = "winchester1200_mp";
	level.classWeapons["allies"]["CLASS_ASSAULT"][0] = "m14_scoped_mp";
	level.classWeapons["allies"]["CLASS_SNIPER"][0] = "mp5_mp";
	level.classWeapons["allies"]["CLASS_ENGINEER"][0] = "saw_mp";
	level.classWeapons["allies"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["allies"]["CLASS_SUPPORT"][0] = "m16_gl_mp";
	
	level.classWeapons["axis"]["CLASS_CLOSEQUARTERS"][0] = "winchester1200_mp";
	level.classWeapons["axis"]["CLASS_ASSAULT"][0] = "m14_scoped_mp";
	level.classWeapons["axis"]["CLASS_SNIPER"][0] = "mp5_mp";
	level.classWeapons["axis"]["CLASS_ENGINEER"][0] = "saw_mp";
	level.classWeapons["axis"]["CLASS_ANTIARMOR"][0] = "m4_mp";
	level.classWeapons["axis"]["CLASS_SUPPORT"][0] = "m16_gl_mp";

	level.classSidearm["allies"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ASSAULT"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SNIPER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["allies"]["CLASS_SUPPORT"]		= "beretta_mp";
	
	level.classSidearm["axis"]["CLASS_CLOSEQUARTERS"]	= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ASSAULT"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SNIPER"]			= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ENGINEER"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_ANTIARMOR"]		= "beretta_mp";
	level.classSidearm["axis"]["CLASS_SUPPORT"]			= "beretta_mp";
	
	/* multimapping
	
	CLASS_CLOSEQUARTERS: 	Demolitions
	CLASS_ASSAULT:			Sniper
	CLASS_SNIPER:			Spec Ops
	CLASS_ENGINEER			Heavy Gunner	
	CLASS_SUPPORT			Assault
	
	*/
	
	// default class grenade loadout for offline mode
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_CLOSEQUARTERS"]	["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ASSAULT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["type"]	= level.weapons["concussion"];
	level.classGrenades["CLASS_ASSAULT"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SNIPER"]			["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_SNIPER"]			["secondary"]	["count"]	= 3;
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ENGINEER"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["type"]	= level.weapons["smoke"];
	level.classGrenades["CLASS_ENGINEER"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_ANTIARMOR"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_ANTIARMOR"]		["secondary"]	["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["type"]	= level.weapons["frag"];
	level.classGrenades["CLASS_SUPPORT"]		["primary"]		["count"]	= 1;
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["type"]	= level.weapons["flash"];
	level.classGrenades["CLASS_SUPPORT"]		["secondary"]	["count"]	= 1;
	
	// TODO: allow more than 1 C4 when it's harder to throw & detonate immediately?
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["allies"]	["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["allies"]	["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["allies"]	["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["allies"]	["CLASS_SNIPER"]["type"]			= "";
	level.classItem["allies"]	["CLASS_SNIPER"]["count"]			= 0;
	level.classItem["allies"]	["CLASS_ENGINEER"]["type"]			= level.weapons["rpg"];
	level.classItem["allies"]	["CLASS_ENGINEER"]["count"]			= 2;
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["allies"]	["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["allies"]	["CLASS_SUPPORT"]["type"]			= "";
	level.classItem["allies"]	["CLASS_SUPPORT"]["count"]			= 0;
	
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["type"]		= level.weapons["c4"];
	level.classItem["axis"]		["CLASS_CLOSEQUARTERS"]["count"]	= 2;
	level.classItem["axis"]		["CLASS_ASSAULT"]["type"]			= "";
	level.classItem["axis"]		["CLASS_ASSAULT"]["count"]			= 0;
	level.classItem["axis"]		["CLASS_SNIPER"]["type"]			= "";
	level.classItem["axis"]		["CLASS_SNIPER"]["count"]			= 0;
	level.classItem["axis"]		["CLASS_ENGINEER"]["type"]			= level.weapons["rpg"];
	level.classItem["axis"]		["CLASS_ENGINEER"]["count"]			= 2;
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["type"]			= level.weapons["at4"];
	//level.classItem["axis"]		["CLASS_ANTIARMOR"]["count"]		= 1;
	level.classItem["axis"]		["CLASS_SUPPORT"]["type"]			= "";
	level.classItem["axis"]		["CLASS_SUPPORT"]["count"]			= 0;
	
	level.initc4ammo = 2; // initial ammo for c4 and claymore
	level.initclaymoreammo = 2;
	
	// initializes create a class settings
	cac_init();
	
	// generating weapon type arrays which classifies the weapon as primary (back stow), pistol, or inventory (side pack stow)
	// using mp/statstable.csv's weapon grouping data ( numbering 0 - 149 )
	level.primary_weapon_array = [];
	level.side_arm_array = [];
	level.grenade_array = [];
	level.inventory_array = [];
	max_weapon_num = 149;
	for( i = 0; i < max_weapon_num; i++ )
	{
		//statstablelookup( get_col, with_col, with_data )
		weapon_type = statstablelookup( level.cac_cgroup, level.cac_cstat, i );
		weapon = statstablelookup( level.cac_creference, level.cac_cstat, i );
		attachment = statstablelookup( level.cac_cstring, level.cac_cstat, i );
				
		if( !isdefined( weapon_type ) || weapon_type == "" )
			continue;
		if( !isdefined( weapon ) || weapon == "" )
			continue;		
		
		weapon_class_register( weapon+"_mp", weapon_type );	
		
		if( isdefined( attachment ) && attachment != "" )
		{	
			attachment_tokens = strtok( attachment, " " );
			if( isdefined( attachment_tokens ) )
			{
				if( attachment_tokens.size == 0 )
					weapon_class_register( weapon+"_"+attachment+"_mp", weapon_type );	
				else
				{
					// multiple attachmen options
					for( k = 0; k < attachment_tokens.size; k++ )
						weapon_class_register( weapon+"_"+attachment_tokens[k]+"_mp", weapon_type );
				}
			}
		}
	}
	
	level.perkNames = [];
	level.perkIcons = [];

	for ( i = 1; i <= 10; i++ )
	{
		tableName = "mp/statsTable.csv";

		idx = 150;
		// unlocks all the challenges in this tier
		for ( idx = 150; idx < 200; idx++ )
		{
			refString = tableLookup( tableName, 0, idx, 4 );
			if ( !isDefined( refString ) || refString == "" )
				continue;

			perkIcon = tableLookup( tableName, 0, idx, 6 );
			perkName = tableLookup( tableName, 0, idx, 3 );
			
			level.perkNames[refString] = perkName;
			level.perkIcons[refString] = perkIcon;
			precacheShader( perkIcon );
		}
	}
	
	level thread onPlayerConnecting();
}

weapon_class_register( weapon, weapon_type )
{
	if( isSubstr( "weapon_smg weapon_assault weapon_projectile weapon_sniper weapon_shotgun weapon_lmg", weapon_type ) )
		level.primary_weapon_array[weapon] = 1;	
	else if( weapon_type == "weapon_pistol" )
		level.side_arm_array[weapon] = 1;
	else if( weapon_type == "weapon_grenade" )
		level.grenade_array[weapon] = 1;
	else if( weapon_type == "weapon_explosive" )
		level.inventory_array[weapon] = 1;
	else
		assertex( false, "Weapon group info is missing from statsTable for: " + weapon_type );
}

// create a class init
cac_init()
{
	// max create a class "class" allowed
	level.cac_size = 5;
	
	// init cac data table column definitions
	level.cac_numbering = 0;	// unique unsigned int - general numbering of all items
	level.cac_cstat = 1;		// unique unsigned int - stat number assigned
	level.cac_cgroup = 2;		// string - item group name, "primary" "secondary" "inventory" "specialty" "grenades" "special grenades" "stow back" "stow side" "attachment"
	level.cac_cname = 3;		// string - name of the item, "Extreme Conditioning"
	level.cac_creference = 4;	// string - reference string of the item, "m203" "m16" "bulletdamage" "c4"
	level.cac_ccount = 5;		// signed int - item count, if exists, -1 = has no count
	level.cac_cimage = 6;		// string - item's image file name
	level.cac_cdesc = 7;		// long string - item's description
	level.cac_cstring = 8;		// long string - item's other string data, reserved
	level.cac_cint = 9;			// signed int - item's other number data, used for attachment number representations
	level.cac_cunlock = 10;		// unsigned int - represents if item is unlocked by default
	level.cac_cint2 = 11;		// signed int - item's other number data, used for primary weapon camo skin number representations
}

getClassChoice( response )
{
	tokens = strtok( response, "," );
	return ( level.classMap[tokens[0]] );
}

getWeaponChoice( response )
{
	tokens = strtok( response, "," );
	if ( tokens.size > 1 )
		return int(tokens[1]);
	else
		return 0;
}

// ============================================================================
// obtains custom class setup from stat values
cac_getdata()
{
	/* custom class stat allocation order, example of custom class slot 1
	201  weapon_primary    
	202  weapon_primary attachment    
	203  weapon_secondary    
	204  weapon_secondary attachment    
	205  weapon_specialty1    
	206  weapon_specialty2    
	207  weapon_specialty3  
	208  weapon_special_grenade_type
	209	 weapon_primary_camo_style
	*/
	
	// if class slot is not initialized, exp( stat(200) == 0 ), then we need to initialize statset(200, 1) and set the default class loadout stat data
	// classes should only be initialized once in a player's profile life-time
	for( k = 0; k < 5; k ++ )
	{
		stat_num = k*10+200;
		// if stat_num has been initialized already we skip, else we initialize the default stat data for loadout
		if ( self getstat( stat_num ) > 0 )
			continue;
		else
		{
			println( "Class "+(k+1)+": stat-loadout-initalizing" );
			println( "=================================" );
			
			// iterate to copy the presets for the class from classTable.csv
			for( l = 0; l < 10; l++ )
			{
				// set player's loadout slots equal to the preset values obtained from the tablelookup, looking up data-int using stat-num
				stat_to = int( classtablelookup( level.cac_cint, level.cac_cstat, stat_num + l ) );
				self setstat( stat_num+l, stat_to ); 
				println( "Slot "+(stat_num+l)+" -> "+stat_to );
			}
		}
	}

	for( i = 0; i < 5; i ++ )
	{
		assertex( self getstat ( i*10+200 ) == 1, "Custom class not initialized!" );
			
		// do not change the allocation and assignment of 0-299 stat bytes, or data will be misinterpreted by this function!
		primary_num = self getstat ( 200+(i*10)+1 );				// returns weapon number (also the unlock stat number from data table)
		primary_attachment_flag = self getstat ( 200+(i*10)+2 ); 	// returns attachment number (from data table)
		secondary_num = self getstat ( 200+(i*10)+3 );				// returns weapon number (also the unlock stat number from data table)
		secondary_attachment_flag = self getstat ( 200+(i*10)+4 ); 	// returns attachment number (from data table)
		specialty1 = self getstat ( 200+(i*10)+5 ); 				// returns specialty number (from data table)
		specialty2 = self getstat ( 200+(i*10)+6 ); 				// returns specialty number (from data table)
		specialty3 = self getstat ( 200+(i*10)+7 ); 				// returns specialty number (from data table)
		special_grenade = self getstat ( 200+(i*10)+8 );			// returns special grenade type as single special grenade items (from data table)
		camo_num = self getstat ( 200+(i*10)+9 );					// returns camo number (from data table)
		
		// apply attachment to primary weapon, getting weapon reference strings
		attachment_string = attachmenttablelookup( level.cac_creference, level.cac_cint, primary_attachment_flag );
		isAttachment = isSubstr( attachmenttablelookup( level.cac_cgroup, level.cac_cint, primary_attachment_flag ), "attachment" );
		if( primary_attachment_flag != 0 && isAttachment && attachment_string != "" )
			self.custom_class[i]["primary"] = statstablelookup( level.cac_creference, level.cac_numbering, primary_num ) + "_" + attachment_string + "_mp";
		else
			self.custom_class[i]["primary"] = statstablelookup( level.cac_creference, level.cac_numbering, primary_num ) + "_mp";
		
		// apply attachment to secondary weapon, getting weapon reference strings
		attachment_string = attachmenttablelookup( level.cac_creference, level.cac_cint, secondary_attachment_flag );
		isAttachment = isSubstr( attachmenttablelookup( level.cac_cgroup, level.cac_cint, secondary_attachment_flag ), "attachment" );
		if( secondary_attachment_flag != 0 && isAttachment && attachment_string != "" )
			self.custom_class[i]["secondary"] = statstablelookup( level.cac_creference, level.cac_numbering, secondary_num ) + "_" + attachment_string + "_mp";
		else
			self.custom_class[i]["secondary"] = statstablelookup( level.cac_creference, level.cac_numbering, secondary_num ) + "_mp";	
		
		// obtaining specialties, getting specialty reference strings
		self.custom_class[i]["specialty1"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty1 );
		self.custom_class[i]["specialty1_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty1 ) );
		self.custom_class[i]["specialty1_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty1 );
		
		self.custom_class[i]["specialty2"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty2 );
		self.custom_class[i]["specialty2_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty2 ) );
		self.custom_class[i]["specialty2_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty2 );
		
		self.custom_class[i]["specialty3"] = statstablelookup( level.cac_creference, level.cac_cstat, specialty3 );
		self.custom_class[i]["specialty3_count"] = int( statstablelookup( level.cac_ccount, level.cac_cstat, specialty3 ) );
		self.custom_class[i]["specialty3_group"] = statstablelookup( level.cac_cgroup, level.cac_cstat, specialty3 );
		
		// builds the full special grenade reference string
		self.custom_class[i]["special_grenade"] = statstablelookup( level.cac_creference, level.cac_numbering, special_grenade ) + "_mp";
		self.custom_class[i]["special_grenade_count"] = int( statstablelookup( level.cac_ccount, level.cac_numbering, special_grenade ) );
		
		// camo selection, default 0 = no camo skin
		self.custom_class[i]["camo_num"] = camo_num;
		
		// debug
		println( "\n ========== CLASS DEBUG INFO ========== \n" );
		println( "Primary: "+self.custom_class[i]["primary"] );
		println( "Secondary: "+self.custom_class[i]["secondary"] );
		println( "Specialty1: "+self.custom_class[i]["specialty1"]+" - Group: "+self.custom_class[i]["specialty1_group"]+" - Count: "+self.custom_class[i]["specialty1_count"] );
		println( "Specialty2: "+self.custom_class[i]["specialty2"] );
		println( "Specialty3: "+self.custom_class[i]["specialty3"] );
		println( "Special Grenade: "+self.custom_class[i]["special_grenade"]+" - Count: "+self.custom_class[i]["special_grenade_count"] );
		println( "Primary Camo: "+attachmenttablelookup( level.cac_cname, level.cac_cint2, camo_num ) );
	}
}

// distributes the specialties into the corrent slots; inventory, grenades, special grenades, generic specialties
get_specialtydata( class_num, specialty )
{
	cac_reference = self.custom_class[class_num][specialty];
	cac_group = self.custom_class[class_num][specialty+"_group"];
	cac_count = self.custom_class[class_num][specialty+"_count"];
		
	assertex( isdefined( cac_group ), "Missing "+specialty+"'s group name" );
	
	// grenade classification and distribution ==================
	if( specialty == "specialty1" )
	{
		if( isSubstr( cac_group, "grenade" ) )
		{
			// if user selected 3 frags, then give 3 count, else always give 1
			if( cac_reference == "specialty_fraggrenade" )
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["grenades"] = level.weapons["frag"];
				self.custom_class[class_num]["grenades_count"] = 1;
			}
			
			// if user selected 3 special grenades, then give 3 count to the selected special grenade type, else always give 1
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ) && isdefined( self.custom_class[class_num]["special_grenade_count"] ), "Special grenade missing from custom class loadout" );
			if( cac_reference == "specialty_specialgrenade" )
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = cac_count;
			}
			else
			{
				self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
				self.custom_class[class_num]["specialgrenades_count"] = 1;
			}
			return;
		}
		else
		{
			assertex( isdefined( self.custom_class[class_num]["special_grenade"] ), "Special grenade missing from custom class loadout" );
			self.custom_class[class_num]["grenades"] = level.weapons["frag"];
			self.custom_class[class_num]["grenades_count"] = 1;
			self.custom_class[class_num]["specialgrenades"] = self.custom_class[class_num]["special_grenade"];
			self.custom_class[class_num]["specialgrenades_count"] = 1;
		}
	}
			
	// if user selected inventory items
	if( cac_group == "inventory" )
	{
		// inventory distribution to action slot 3 - unique per class
		assertex( isdefined( cac_count ) && isdefined( cac_reference ), "Missing "+specialty+"'s reference or count data" );
		self.custom_class[class_num]["inventory"] = cac_reference;		// loads inventory into action slot 3
		self.custom_class[class_num]["inventory_count"] = cac_count;	// loads ammo count
	}
	else if( cac_group == "specialty" )
	{
		// building player's specialty, variable size array with size 3 max
		if( self.custom_class[class_num][specialty] != "" )
			self.specialty[self.specialty.size] = self.custom_class[class_num][specialty];
	}
}

// interface function for code table lookup using class table data
classtablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/classtable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}

// interface function for code table lookup using weapon attachment table data
attachmenttablelookup( get_col, with_col, with_data )
{
	return_value = tablelookup( "mp/attachmenttable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;	
}

// interface function for code table lookup using weapon stats table data
statstablelookup( get_col, with_col, with_data )
{
	// with_data = the data from the table
	// with_col = look in this column for the data
	// get_col = once data found, return the value of get_col in the same row	
	return_value = tablelookup( "mp/statstable.csv", with_col, with_data, get_col );
	assertex( isdefined( return_value ), "Data not found: "+get_col+" column, using "+with_data+" in the "+with_col+"th column. ");
	return return_value;
}

// clears all player's custom class variables, prepare for update with new stat data
reset_specialty_slots( class_num )
{
	self.specialty = [];		// clear all specialties
	self.custom_class[class_num]["inventory"] = "";
	self.custom_class[class_num]["inventory_count"] = 0;
	self.custom_class[class_num]["inventory_group"] = "";
	self.custom_class[class_num]["grenades"] = ""; 
	self.custom_class[class_num]["grenades_count"] = 0;
	self.custom_class[class_num]["grenades_group"] = "";
	self.custom_class[class_num]["specialgrenades"] = "";
	self.custom_class[class_num]["specialgrenades_count"] = 0;
	self.custom_class[class_num]["specialgrenades_group"] = "";
}

giveLoadout( team, class )
{
	self takeAllWeapons();
	
	/*
	if ( level.splitscreen )
		primaryIndex = 0;
	else
		primaryIndex = self.pers["primary"];
	*/
	
	primaryIndex = 0;
	
	// initialize specialty array
	self.specialty = [];

	primaryWeapon = undefined;
	
	// ============= custom class selected ==============
	if( isSubstr( class, "CLASS_CUSTOM" ) )
	{	
		// gets custom class data from stat bytes
		self cac_getdata();
	
		// obtains the custom class number
		class_num = int( class[class.size-1] )-1;
		self.class_num = class_num;
		
		assertex( isdefined( self.custom_class[class_num]["primary"] ), "Custom class "+class_num+": primary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["secondary"] ), "Custom class "+class_num+": secondary weapon setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty1"] ), "Custom class "+class_num+": specialty1 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty2"] ), "Custom class "+class_num+": specialty2 setting missing" );
		assertex( isdefined( self.custom_class[class_num]["specialty3"] ), "Custom class "+class_num+": specialty3 setting missing" );
		
		// clear of specialty slots, repopulate the current selected class' setup
		self reset_specialty_slots( class_num );
		self get_specialtydata( class_num, "specialty1" );
		self get_specialtydata( class_num, "specialty2" );
		self get_specialtydata( class_num, "specialty3" );
		// at this stage, the specialties are loaded into the correct weapon slots, and special slots
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = self.custom_class[class_num]["primary"];
		
		sidearm = self.custom_class[class_num]["secondary"];
			
		// give primary weapon
		primaryWeapon = weapon;
		
		assertex( isdefined( self.custom_class[class_num]["camo_num"] ), "Player's camo skin is not defined, it should be at least initialized to 0" );

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		if ( self.pers["primaryWeapon"] == "m14" )
			self.pers["primaryWeapon"] = "m14_scoped";
	
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );
		
		self GiveWeapon( weapon, self.custom_class[class_num]["camo_num"] );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		else
			self givestartAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		self GiveWeapon( sidearm );
		self giveMaxAmmo( sidearm );
	
		self SetActionSlot( 1, "nightvision" );

		secondaryWeapon = self.custom_class[class_num]["inventory"];
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, self.custom_class[class_num]["inventory_count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "altMode" );
			self SetActionSlot( 4, "" );
		}
		
		// give frag for all no matter what
		grenadeTypePrimary = self.custom_class[class_num]["grenades"]; 
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = self.custom_class[class_num]["grenades_count"]; 
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		// give special grenade
		grenadeTypeSecondary = self.custom_class[class_num]["specialgrenades"]; 
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = self.custom_class[class_num]["specialgrenades_count"]; 
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
	}
	else
	{	
		// ============= selected one of the default classes ==============
				
		// load the selected default class's specialties
		assertex( isdefined(self.pers["class"]), "Player during spawn and loadout got no class!" );
		selected_class = self.pers["class"];
		specialty_size = level.default_class[selected_class].size;
		
		for( i = 0; i < specialty_size; i++ )
		{
			if( isdefined( level.default_class[selected_class][i] ) && level.default_class[selected_class][i] != "" )
				self.specialty[self.specialty.size] = level.default_class[selected_class][i];
		}
		assertex( isdefined( self.specialty ) && self.specialty.size > 0, "Default class: " + self.pers["class"] + " is missing specialties " );
		
		// weapon override for round based gametypes
		// TODO: if they switched to a sidearm, we shouldn't give them that as their primary!
		if ( isDefined( self.pers["weapon"] ) && self.pers["weapon"] != "none" )
			weapon = self.pers["weapon"];
		else
			weapon = level.classWeapons[team][class][primaryIndex];
		
		sidearm = level.classSidearm[team][class];
		
		// give primary weapon
		primaryWeapon = weapon;

		primaryTokens = strtok( primaryWeapon, "_" );
		self.pers["primaryWeapon"] = primaryTokens[0];
		
		if ( self.pers["primaryWeapon"] == "m14" )
			self.pers["primaryWeapon"] = "m14_scoped";
	
		self maps\mp\gametypes\_teams::playerModelForWeapon( self.pers["primaryWeapon"] );		

		self GiveWeapon( weapon );
		if( self cac_hasSpecialty( "specialty_extraammo" ) )
			self giveMaxAmmo( weapon );
		else
			self givestartAmmo( weapon );
		self setSpawnWeapon( weapon );
		
		// give secondary weapon
		self GiveWeapon( sidearm );
		self giveMaxAmmo( sidearm );
	
		self SetActionSlot( 1, "nightvision" );
	
		secondaryWeapon = level.classItem[team][class]["type"];	
		if ( secondaryWeapon != "" )
		{
			self GiveWeapon( secondaryWeapon );
			
			self setWeaponAmmoOverall( secondaryWeapon, level.classItem[team][class]["count"] );
			
			self SetActionSlot( 3, "weapon", secondaryWeapon );
			self SetActionSlot( 4, "" );
		}
		else
		{
			self SetActionSlot( 3, "altMode" );
			self SetActionSlot( 4, "" );
		}
		
		grenadeTypePrimary = level.classGrenades[class]["primary"]["type"];
		if ( grenadeTypePrimary != "" )
		{
			grenadeCount = level.classGrenades[class]["primary"]["count"];
	
			self GiveWeapon( grenadeTypePrimary );
			self SetWeaponAmmoClip( grenadeTypePrimary, grenadeCount );
			self SwitchToOffhand( grenadeTypePrimary );
		}
		
		grenadeTypeSecondary = level.classGrenades[class]["secondary"]["type"];
		if ( grenadeTypeSecondary != "" )
		{
			grenadeCount = level.classGrenades[class]["secondary"]["count"];
	
			if ( grenadeTypeSecondary == level.weapons["flash"])
				self setOffhandSecondaryClass("flash");
			else
				self setOffhandSecondaryClass("smoke");
			
			self giveWeapon( grenadeTypeSecondary );
			self SetWeaponAmmoClip( grenadeTypeSecondary, grenadeCount );
		}
	}

	switch ( weaponClass( primaryWeapon ) )
	{
		case "rifle":
			self setMoveSpeedScale( 0.9 );
			break;
		case "pistol":
			self setMoveSpeedScale( 1.0 );
			break;
		case "mg":
			self setMoveSpeedScale( 0.8 );
			break;
		case "smg":
			self setMoveSpeedScale( 1.0 );
			break;
		case "spread":
			self setMoveSpeedScale( 1.0 );
			break;
		default:
			self setMoveSpeedScale( 1.0 );
			break;
	}
	
	// initializes cac specialties that require loop threads
	self cac_selector();
}

// sets the amount of ammo in the gun.
// if the clip maxs out, the rest goes into the stock.
setWeaponAmmoOverall( weaponname, amount )
{
	if ( isWeaponClipOnly( weaponname ) )
	{
		self setWeaponAmmoClip( weaponname, amount );
	}
	else
	{
		self setWeaponAmmoClip( weaponname, amount );
		diff = amount - self getWeaponAmmoClip( weaponname );
		assert( diff >= 0 );
		self setWeaponAmmoStock( weaponname, diff );
	}
}

replenishLoadout() // used by ammo hardpoint.
{
	team = self.pers["team"];
	class = self getClass();

    weaponsList = self GetWeaponsList();
    for( idx = 0; idx < weaponsList.size; idx++ )
    {
		weapon = weaponsList[idx];

		self giveMaxAmmo( weapon );
		self SetWeaponAmmoClip( weapon, 9999 );

		if ( weapon == "claymore_mp" || weapon == "claymore_detonator_mp" )
			self setWeaponAmmoStock( weapon, level.initclaymoreammo );
    }
	
	if ( self getAmmoCount( level.classGrenades[class]["primary"]["type"] ) < level.classGrenades[class]["primary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["primary"]["type"], level.classGrenades[class]["primary"]["count"] );

	if ( self getAmmoCount( level.classGrenades[class]["secondary"]["type"] ) < level.classGrenades[class]["secondary"]["count"] )
 		self SetWeaponAmmoClip( level.classGrenades[class]["secondary"]["type"], level.classGrenades[class]["secondary"]["count"] );	
}

onPlayerConnecting()
{
	for(;;)
	{
		level waittill( "connecting", player );

		if ( !isDefined( player.pers["class"] ) )
		{
			player initClassXP(); //temp
			player.pers["class"] = "";
			player.pers["proficiency"] = 0;
		}

		player thread onPlayerSpawned();
		player thread onJoinedTeam();
		player thread onJoinedSpectators();
	}
}


onJoinedTeam()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_team");
		self thread removeClassHUD();
	}
}


onJoinedSpectators()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("joined_spectators");
		self thread removeClassHUD();
	}
}


onPlayerSpawned()
{
	self endon("disconnect");

	for(;;)
	{
		self waittill("spawned_player");

		if(!isdefined(self.hud_class))
		{
		    self.hud_class = newClientHudElem(self);
		    self.hud_class.horzAlign = "right";
		    self.hud_class.vertAlign = "top";
			self.hud_class.alignX = "right";
 			self.hud_class.x = -16;
			self.hud_class.y = 44;
		    self.hud_class.font = "default";
		    self.hud_class.fontscale = 2;
		    self.hud_class.archived = false;
		    self.hud_class.alpha = 0; // hide class display for now...
		}

		if(!isdefined(self.hud_profannounce))
		{
			self.hud_profannounce = newClientHudElem(self);
			self.hud_profannounce.x = 0;
			self.hud_profannounce.y = 40;
			self.hud_profannounce.alignX = "center";
			self.hud_profannounce.alignY = "top";
			self.hud_profannounce.horzAlign = "center_safearea";
			self.hud_profannounce.vertAlign = "top";
			self.hud_profannounce.archived = false;
			self.hud_profannounce.font = "default";
			self.hud_profannounce.fontscale = 2;
		}

		if(!isdefined(self.hud_newprof))
		{
			self.hud_newprof = newClientHudElem(self);
			self.hud_newprof.x = 0;
			self.hud_newprof.y = 64;
			self.hud_newprof.alignX = "center";
			self.hud_newprof.alignY = "top";
			self.hud_newprof.horzAlign = "center_safearea";
			self.hud_newprof.vertAlign = "top";
			self.hud_newprof.archived = false;
			self.hud_newprof.font = "default";
			self.hud_newprof.fontscale = 2;
		}

		self updateClassHUD();
	}
}


giveClassXP( amount )
{
	xp = self getClassXP( self getClass() );
	self setClassXP( self getClass(), xp + amount );

	self thread updateProfAnnounceHUD();
}


updateProfAnnounceHUD()
{
	self endon("disconnect");

	self notify("update_prof");
	self endon("update_prof");

	if ( self getProficiency( self getClass() ) != self.pers["proficiency"] )
	{
		if ( isDefined( self.hud_newprof ) && isDefined( self.hud_rankannounce ) )
		{
			self.pers["proficiency"] = self getProficiency( self getClass() );
			self.hud_profannounce.alpha = 1;
			self.hud_profannounce setText( &"CLASS_NEWPROF" );
			self.hud_newprof.alpha = 1;
			self.hud_newprof setText( level.proficiencies[self.pers["proficiency"]] );

			self.hud_profannounce thread fadeAway( 3.0, 1.0 );
			self.hud_newprof thread fadeAway( 3.0, 2.0 );
		}
	}
}

fadeAway( waitDelay, fadeDelay )
{
	wait waitDelay;
	
	self fadeOverTime( fadeDelay );
	self.alpha = 0;
}

updateClassHUD()
{
	if(isDefined(self.hud_class))
		self.hud_class setText( level.classes[self getClass()] );
}


removeClassHUD()
{
	if(isDefined(self.hud_class))
		self.hud_class destroy();
}


getProficiency( class )
{
	xp = self getClassXP( class );
	
	if ( xp < 1000 )
		return ("PROFICIENCY_MARKSMAN");
	else if ( xp < 5000 )
		return ("PROFICIENCY_SHARPSHOOTER");
	else
		return ("PROFICIENCY_EXPERT");
}


setClass( newClass )
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	switch( newClass )
	{
	case "CLASS_CLOSEQUARTERS":
	case "CLASS_ASSAULT":
	case "CLASS_SNIPER":
	case "CLASS_ENGINEER":
	case "CLASS_ANTIARMOR":
	case "CLASS_SUPPORT":
		self.pers["code"]["class"] = newClass;
		break;
	default:
		self.pers["code"]["class"] = "CLASS_CLOSEQUARTERS";
		break;
	}
	
	self.curClass = self.pers["code"]["class"];
	self notify ( "set_class", self.curClass );
}

getClass()
{
	return ( self.pers["code"]["class"] );
}

getClassXP( className )
{
	return( self.pers["code"][self.pers["code"]["class"]] );
}

setClassXP( className, amount )
{
	self.pers["code"][className] = amount;
}

initClassXP()
{
	if ( !isDefined( self.pers["code"] ) )
		self.pers["code"] = [];

	self.pers["code"]["CLASS_CLOSEQUARTERS"] = 999;
	self.pers["code"]["CLASS_ASSAULT"] = 999;
	self.pers["code"]["CLASS_SNIPER"] = 999;
	self.pers["code"]["CLASS_ENGINEER"] = 999;
	self.pers["code"]["CLASS_ANTIARMOR"] = 999;
	self.pers["code"]["CLASS_SUPPORT"] = 999;
}

// ============================================================================================
// =======																				=======
// =======						 Create a Class Specialties 							=======
// =======																				=======
// ============================================================================================

// CAC: Selector function, calls the individual cac features according to player's class settings
// Info: Called every time player spawns during loadout stage
cac_selector()
{
	level.cac_bulletdamage_data = cac_get_dvar_int( "perk_bulletDamage", "25" );		// increased bullet damage by this %
	level.cac_armorvest_data = cac_get_dvar_int( "perk_armorVest", "75" );				// increased health by this %
	level.cac_explosivedamage_data = cac_get_dvar_int( "perk_explosiveDamage", "25" );	// increased explosive damage by this %
	
	perks = self.specialty;
	
	// register perks to code for 32bit player perk info exchange (Max unique perks is 32)
	self clearPerks();	// reset and re-register
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if ( !isdefined( perk ) )
			continue;
		self setPerk( perk );
		
		// run scripted perk that thread loops
		if( perk == "specialty_detectexplosive" )
		{
			self thread perk_detectexplosive();
		}
	}
}

// returns dvar value in int
cac_get_dvar_int( dvar, def )
{
	return int( cac_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
cac_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
		return getdvarfloat( dvar );
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

// setup 20 slots for displaying explosives
generate_icon_array()
{
	// self is observing player
	
	// if player already had this perk that set the iconarray, then reset the array
	if( isdefined( self.iconarray ) && self.iconarray.size == 20 )
	{
		for( i=0; i<20; i++ )
		{
			// if an explosive icon is still displaying, reset it
			if( self.iconarray[i].alpha != 0 )
				self.iconarray[i].alpha = 0;
		}
		return;
	}
	
	// if player using this perk for the first time, we create the hudclientelems
	self.iconarray = [];
	for( idx = 0; idx < 20; idx++ )
	{
		iconarray = newClientHudElem( self );
		iconarray.x = 0;
		iconarray.y = 0;
		iconarray.z = 0;
		iconarray.alpha = 0;
		iconarray.archived = true;
		iconarray setShader("white", 7, 7);
		iconarray setwaypoint(false);
		
		self.iconarray[self.iconarray.size] = iconarray;
	}
}

// display the explosive array
// this should only change a particular client hudelem when an explosive is planted or destroyed 
// to ensure minimal network traffic
display_explosive_icons()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	while( isdefined( self ) )
	{
		// ====== if an explosive no longer exists, clear out its icon from the icon array ======
		// loop through player's icon array
		for( i=0; i<20; i++ )
		{
			if( self.iconarray[i].alpha == 0 )
				continue;
				
			found = false;
			// loop through player's detected explosive entity array
			if( isdefined( self.draw_explosive_array ) && self.draw_explosive_array.size > 0 )
			{
				for( k=0; k<self.draw_explosive_array.size; k++ )
				{
					explosive = self.draw_explosive_array[k];
					// if an explosive exists in the icon array, then found
					if( isdefined( explosive ) && self.iconarray[i].x == explosive.origin[0] && self.iconarray[i].y == explosive.origin[1] && ( self.iconarray[i].z == explosive.origin[2] + 16 || self.iconarray[i].z == explosive.origin[2] - 16 ) )
						found = true;
				}
			}
			// if not found, then we clear this icon out
			if( !found )
				self.iconarray[i].alpha = 0;
		}		
		
		if( !isdefined( self.draw_explosive_array ) || self.draw_explosive_array.size == 0 )
		{
			self waittill( "explosive detected" );
			continue;
		}
		
		// ====== check if explosive is in icon array, if not, add to array ======
		// loop through player's detected explosive entity array
		for( i=0; i< self.draw_explosive_array.size; i++ )
		{
			explosive = self.draw_explosive_array[i];
			
			// if the explosive disappeared during the last wait interval, we skip
			if( !isdefined( explosive ) )
				continue;
			
			// build the new hudelem's settings
			hudelem_x = explosive.origin[0];
			hudelem_y = explosive.origin[1];
			hudelem_z = explosive.origin[2];
			if( isdefined( explosive.owner.pers["team"] ) && explosive.owner.pers["team"] == "allies" )
				hudelem_shader = game["entity_headicon_allies_enemy"];
			else
				hudelem_shader = game["entity_headicon_axis_enemy"];
				
		
			// check if the explosive entity in question is already in the player's icon array, if so, skip
			already_in_icon_array = false;
			for( idx = 0; idx < 20; idx++ )
			{
				if( self.iconarray[idx].x == hudelem_x && self.iconarray[idx].y == hudelem_y && ( self.iconarray[idx].z == hudelem_z + 16 || self.iconarray[idx].z == hudelem_z - 16 ) && self.iconarray[idx].alpha > 0 )
					already_in_icon_array = true;
			}
			if( already_in_icon_array )
				continue;
			
			// add the icon into the next open slot
			slot_full = true;
			for( idx = 0; idx < 20; idx++ )
			{
				// skip the current icon slot if is in-use
				if( self.iconarray[idx].alpha > 0 )
					continue;
				
				slot_full = false;
				// found empty slot to add icon
				self.iconarray[idx].alpha = 1;
				self.iconarray[idx].x = hudelem_x;
				self.iconarray[idx].y = hudelem_y;
				if( bullettracepassed( ( hudelem_x, hudelem_y, hudelem_z ), ( hudelem_x, hudelem_y, hudelem_z ) - ( 0, 0, 16 ), false, explosive ) )
					self.iconarray[idx].z = hudelem_z - 16;
				else
					self.iconarray[idx].z = hudelem_z + 16;
				self.iconarray[idx] setShader( hudelem_shader, 10, 10);
				self.iconarray[idx] setwaypoint(false);
				break;
			}
			// we shouldnt have more than 20 explosive icons at one time...
			assertex( !slot_full, "There are more than 20 (max) explosive icons to be displayed at once" );
		}
		wait 0.05;
	}
}

perk_detectexplosive()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	// setup 20 slots for displaying explosives, closest first
	self generate_icon_array();
	self.draw_explosive_array = [];
	self thread display_explosive_icons();
	
	// display hudelem for the perk carrier of claymore/c4 threats
	while( isdefined( self ) )
	{
		assertex( isdefined( level.players ) && level.players.size > 0 , "No players exist but somehow someone is running a perk!" );
		
		// scan every player for planted explosives
		for( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			
			if ( !isdefined( player.pers["team"] ) || player.sessionstate != "playing" || player.pers["team"] == "spectator" || player.pers["team"] == self.pers["team"] )
				continue;
						
			// if player has planted claymores
			claymores = player.claymorearray;
			if( isdefined( claymores ) && claymores.size > 0 )
			{
				// mark all the claymore(s) this player plantted
				for( k = 0; k < claymores.size; k++ )
				{
					self waittill_explosive_rest( claymores[k] );
				}
			}
			// if player has planted c4s
			c4s = player.c4array;
			if( isdefined( c4s ) && c4s.size > 0 )
			{
				for( j = 0; j < c4s.size; j++ )
				{
					self waittill_explosive_rest( c4s[j] );
				}
			}
		}
		wait 0.05;
	}
}

// only add explosive planted when its at rest, to optimize network traffic
waittill_explosive_rest( explosive )
{
	// waittill this claymore has stopped
	exp_last_pos = ( 0, 0, 0 );
	while( isdefined( explosive ) && exp_last_pos != explosive.origin )
	{
		exp_last_pos = explosive.origin;
		wait 0.05;
	}

	if( !isdefined( explosive ) )
		return;

	addto_explosive_array( explosive );
}

// add to explosives array if the new entry is not in the array
addto_explosive_array( explosive )
{
	if( isdefined( self.draw_explosive_array ) )
	{
		found = false;
		for( p = 0; p<self.draw_explosive_array.size; p++ )
		{
			if( self.draw_explosive_array[p] == explosive )
			{
				found = true;
				break;
			}
		}
		
		// if explosive not found in the list, we insert it into the first avaliable slot
		if( !found )
		{
			for( p = 0; p<self.draw_explosive_array.size; p++ )
			{
				if( !isdefined( self.draw_explosive_array[p] ) )
				{
					self.draw_explosive_array[p] = explosive;
					self notify( "explosive detected" );
					return;
				}
			}
			// else insert it to the last
			self.draw_explosive_array[self.draw_explosive_array.size] = explosive;
			self notify( "explosive detected" );
		}
	}
}

// CAC: Selected feature check function, returns boolean if a specialty is selected by the current class
// Info: Called on "player" as self, "feature" parameter is a string reference of the specialty in question
cac_hasSpecialty( perk_reference )
{
	return_value = self hasPerk( perk_reference );
	return return_value;
	
	/*
	perks = self.specialty;
	for( i=0; i<perks.size; i++ )
	{
		perk = perks[i];
		if( perk == perk_reference )
			return true;
	}
	return false;
	*/
}

// CAC: Weapon Specialty: Increased bullet damage feature
// CAC: Weapon Specialty: Armor Vest feature
// CAC: Ability: Increased explosive damage feature
cac_modified_damage( victim, attacker, damage, meansofdeath )
{
	// skip conditions
	if( !isdefined( victim) || !isdefined( attacker ) || !isplayer( attacker ) || !isplayer( victim ) )
		return damage;
	if( attacker.sessionstate != "playing" || !isdefined( damage ) || !isdefined( meansofdeath ) )
		return damage;
	if( meansofdeath == "" )
		return damage;
		
	old_damage = damage;
	final_damage = damage;
	
	/* Cases =======================
	attacker - bullet damage
		victim - none
		victim - armor
	attacker - explosive damage
		victim - none
		victim - armor
	attacker - none
		victim - none
		victim - armor
	===============================*/
	
	// if attacker has bullet damage then increase bullet damage
	if( attacker cac_hasSpecialty( "specialty_bulletdamage" ) && isPrimaryDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased bullet damage" );
		}
		else
		{
			final_damage = damage*(100+level.cac_bulletdamage_data)/100;
			println( "Perk/> " + attacker.name + "'s bullet damage did extra damage to " + victim.name );
		}
	}
	else if( attacker cac_hasSpecialty( "specialty_explosivedamage" ) && isExplosiveDamage( meansofdeath ) )
	{
		// if victim has armor then do not change damage, it is cancelled out, else damage is increased

		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage;
			println( "Perk/> " + victim.name + "'s armor countered " + attacker.name + "'s increased explosive damage" );
		}
		else
		{
			final_damage = damage*(100+level.cac_explosivedamage_data)/100;
			println( "Perk/> " + attacker.name + "'s explosive damage did extra damage to " + victim.name );
		}
	}
	else
	{	
		// if attacker has no bullet damage then check if victim has armor
		// if victim has armor then less damage is taken, else damage unchanged
		
		if( isdefined( victim ) && isPlayer( victim ) && victim cac_hasSpecialty( "specialty_armorvest" ) )
		{
			final_damage = old_damage*(level.cac_armorvest_data/100);
			println( "Perk/> " + victim.name + "'s armor decreased " + attacker.name + "'s damage" );
		}
		else
		{
			final_damage = old_damage;
		}	
	}
	
	// debug
	println( "Perk/> Damage Factor: " + final_damage/old_damage + " - Pre Damage: " + old_damage + " - Post Damage: " + final_damage );
	
	// return unchanged damage
	return int( final_damage );
}

// including grenade launcher, grenade, RPG, C4, claymore
isExplosiveDamage( meansofdeath )
{
	explosivedamage = "MOD_GRENADE MOD_GRENADE_SPLASH MOD_PROJECTILE MOD_PROJECTILE_SPLASH MOD_EXPLOSIVE";
	if( isSubstr( explosivedamage, meansofdeath ) )
		return true;
	return false;
}

// if primary weapon damage
isPrimaryDamage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}
