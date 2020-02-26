#include maps\_utility;


#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;












RenderDebug(msg, pos, numFrame)
{
	if( isdefined(msg) && isdefined(pos) && isdefined(numFrame) )
	{
		if( msg != "" )
		{
			for(i=0; i<numFrame ;i++)
			{
				print3d (pos, msg, (1,1,1), 1, 1.50);	
				wait( 0.05 );
			}		
		}
	}
}











gettimeinsec()
{
	return gettime() / 1000;
}




init_aiBattleChatter( accent, voiceType, voiceIndex )
{	
	AiBattleChatterinitAll();
	
	if ( !isdefined( accent ) )
	{
		accent = "SAM";
	}

	if ( !isdefined( voiceIndex ) )
	{
		voiceIndex = randomintrange( 1, 5 ); 
	}

	if( !isdefined( voiceType ) )
	{
		voiceType = "E"; 
	}

	self.chatQueue = [];
	self.chatQueue["threat"] = undefined;
	self.chatLastPlay = [];
	
	self.chatPlaying  = undefined;
	self.chatenable   = true;

	self.chatAccent     = accent;
	self.chatVoiceIndex = voiceIndex;
	self.chatVoiceType  = voiceType;
		
	self thread AiBattleChatterEnableListener();
	self thread AiBattleChatterDisableListener();
	
	self thread AiChatListenerThreat();
	self thread AiBattleChatterLoop();
	self thread AiBattleChatterDebugRenderLoop();
	self thread AiScreamListener();
	self thread AiNoteTrackListener();
	
}
			


			
AiBattleChatterinitAll()
{
	if( !isdefined(level.BattleChatterInit) )
	{
		level.BattleChatterInit				= true;
		level.BattleChatterSpeak			= -10000;
		level.BattleChatterPriority			= -10000;
		level.BattleChatterAnyoneElite		= -10000;
		level.chatLastPlay = [];

		level.landmarks = GetEntArray("trigger_landmark", "targetname");
		
		InitSoundAliasSuffix();
		InitSoundAliasMsg();
		InitNoteTracks();

		thread bcDrawObjects();

		thread WaitStartPlayerNoteTrackListener();

		level thread UpdateTimeSinceStealthBrokenOrEngaged();
	}
} 




WaitStartPlayerNoteTrackListener()
{
	
	while( !isDefined(level.player) )
	{
		wait 0.05;
	}

	level.player thread AiNoteTrackListener();
	level.player thread BondQKListener();
}




UpdateTimeSinceStealthBrokenOrEngaged()
{
	self endon ( "death" );

	level.BattleChatterStealthBrokenOrEngaged	= -10000;

	while( isdefined(self) )
	{	
		time = CalcTimeSinceStealthBrokenOrEngaged();
		
		wait(0.25);
	}
}




CalcTimeSinceStealthBrokenOrEngaged()
{
	
	if( IsStealthBroken() || IsAnyAiEngaged() )
	{
		level.BattleChatterStealthBrokenOrEngaged = gettimeinsec();
	}

	return gettimeinsec() - level.BattleChatterStealthBrokenOrEngaged;
}




AiBattleChatterEnableListener()
{	
	self endon ( "death" );
	
	while( isdefined(self) )
	{	
		self waittill( "chatenable"); 
		self.chatenable   = true;
	}
}




AiBattleChatterDisableListener()
{	
	self endon ( "death" );
	
	while( isdefined(self) )
	{	
		self waittill( "chatdisable"); 
		self.chatenable   = false;
	}
}
	



tryAddEvent(chatEvent)
{
	replace = false;
	if( isdefined(self.chatQueue["threat"] ) )
	{
		replace = chatEvent.priority >= self.chatQueue["threat"].priority;
	}
	else
	{
		replace = true;
	}
	
	if( replace )
	{		
		
		
		self.chatQueue["threat"] = undefined;
		self.chatQueue["threat"] = chatEvent;
	}
}




AiChatListenerThreat()
{	
	self endon ( "death" );
	
	while( isdefined(self) )
	{	
		self waittill( "event_threat", msgtype, priority, duration );
		
		if( self.chatenable )
		{
			threattype = self GetCurrentThreatType();
			
			chatEvent = createChatEvent( self.chatAccent, self.chatVoiceType, self.chatVoiceIndex, "threat", msgtype, threattype,  priority, duration );
			
			self tryAddEvent(chatEvent);
		}
	}
}




createChatEvent ( accent, voiceType, voiceIndex, event, msgtype, threattype, priority, duration )
{
	chatEvent = spawnstruct();
	
	chatEvent.accent		= accent;
	chatEvent.voiceType		= voiceType;
	chatEvent.voiceIndex	= voiceIndex;
	chatEvent.msgtype		= msgtype;
	chatEvent.threattype	= threattype;
	
	chatEvent.priority  = 0;		
	if( isdefined(priority) )
	{
		if( priority >= 0 )
		{
			chatEvent.priority = priority;
		}
	}
	  
	chatEvent.expireTime = gettimeinsec() + 0.1;
	if( isdefined(duration) )
	{
		if( duration >= 0 )
		{
			chatEvent.expireTime = gettimeinsec() + duration;
		}
	}
		
	
	return chatEvent;
}




AiBattleChatterLoop()
{
	self endon ( "death" );

	
	wait 0.05;

	while( isdefined(self) )
	{				
		if( getdvarint ("ai_ChatEnable") > 0 )
		{
			self CheckCombatRole();
			self TryPlayBattleChatter();
			self ResetTimers();
		}

		wait( 0.05 );
	}
}




findChatDesire()
{
	return  self.chatQueue["threat"];
}




buildSoundAlias( accent, voiceType, voiceIndex, actionType, threatType )
{
	alias = accent + "_" + voiceType + "_" + voiceIndex + "_";
	suffix = getSoundAliasSuffix( actionType, threatType );
	
	if ( suffix == "" )
	{
		return suffix;
	}
	else
	{
		return (alias + suffix);
	}
}




buildSoundAliasWithSuffix( accent, voiceType, voiceIndex, suffix )
{
	alias = accent + "_" + voiceType + "_" + voiceIndex + "_";
	
	if ( suffix == "" )
	{
		return suffix;
	}
	else
	{
		return (alias + suffix);
	}
}




TryPlayBattleChatter()
{	
	chatDesire = self findChatDesire();
	if( isdefined( chatDesire ) )
	{
		play = false;
		if( chatDesire.expireTime > gettimeinsec() )
		{
			timeSinceAnyoneSpeak = gettimeinsec() - level.BattleChatterSpeak;
				
			if( self RespectIntervalsMin(chatDesire) )
			{								
				
				if( timeSinceAnyoneSpeak > 3.0 )
				{
					play = true;
				}
				else if( chatDesire.msgtype == "Death" || chatDesire.msgtype == "BalconyDeath" || chatDesire.msgtype == "DeathSilent" )
				{
					play = true;
				}
				else 
				{
					
					if(		chatDesire.priority  >= level.BattleChatterPriority
							&&	timeSinceAnyoneSpeak > 0.5							)
					{
						play = true;
					}
				}
			}
		}
		
		
		if(	 play 
		  && chatDesire.msgtype == "GotoCover"	)
		{
			play = self WillFlank();
		}

		
		if(	 play 
		  && (chatDesire.msgtype == "NoticeBond" || chatDesire.msgtype == "IdentifyBond") )
		{
			
			if( (self gettimesinceaction("pain") < 60) || (self gettimesinceshotat() < 60) )
			{
				play = false;
			}
			else
			{
				
				if( self IsPerfectSense() )
				{
					play = false;
				}
				else
				{
					if( CalcTimeSinceStealthBrokenOrEngaged() < 15 )
					{
						play = false;
					}
					else
					{			
						canSeeBom = (self IsAThreat(level.player)) && (self CanSeeThreat(level.player));

						
						if( chatDesire.msgtype == "NoticeBond" && canSeeBom )
						{
							play = false;
						}
					}
				}
			}
		}


		
		
		if(	 play 
		  && (chatDesire.msgtype == "WasHit" || chatDesire.msgtype == "WasKilled") )
		{
			
			play = (NumEngagedNearAi(self) > 0);
		}

		
		if( play )
		{
			numNearAi = NumNearAi(self);
			numNeeded = getNearAiMin(chatDesire.msgtype, chatDesire.threattype);

			if( numNearAi < numNeeded )
			{
				if( chatDesire.msgtype == "WasKilled" )
				{
					chatDesire.msgtype = "LastManStanding";
				}
				else
				{
					play = false;
				}
			}
		}

		
		if( play )
		{					
			self PlayBattleChatter( chatDesire );
		}
		
		
		if( self.chatQueue["threat"] == chatDesire )
		{
			self.chatQueue["threat"] = undefined;
		}
	}
}




PlayBattleChatter( chatDesire )
{
	self endon ("death");

	timeInSec = GetTimeInSec();	
	
	self.chatPlaying				= undefined; 

	self.chatPlaying				= spawnstruct();
	self.chatPlaying.accent			= chatDesire.accent;
	self.chatPlaying.voiceType		= chatDesire.voiceType;
	self.chatPlaying.voiceIndex		= chatDesire.voiceIndex;
	self.chatPlaying.priority		= chatDesire.priority;
	self.chatPlaying.msgtype		= chatDesire.msgtype;
	self.chatPlaying.threattype		= chatDesire.threattype;
	self.chatPlaying.msg			= getSoundAliasMsg(chatDesire.msgtype, chatDesire.threattype);

	AddSoundAliases(self, self.chatPlaying);

	for (i = 0; i < self.chatPlaying.soundAliases.size; i++)
	{
		if( self.chatPlaying.soundAliases[i] != "" && soundExists(self.chatPlaying.soundAliases[i]) )
		{
			self.chatLastPlay[chatDesire.msgtype]	= timeInSec;
			level.chatLastPlay[chatDesire.msgtype]	= timeInSec;	
			level.BattleChatterSpeak				= timeInSec;
			level.BattleChatterPriority				= chatDesire.priority;

			
			println("playSound: " + self.chatPlaying.soundAliases[i]);

			self maps\_utility::play_dialogue( self.chatPlaying.soundAliases[i] );

		}
		else if( self.chatPlaying.msg != "" && getdvarint ("ai_ChatShowDebug") > 0 )
		{
			self.chatLastPlay[chatDesire.msgtype]	= timeInSec;
			level.chatLastPlay[chatDesire.msgtype]	= timeInSec;	
			level.BattleChatterSpeak				= timeInSec;
			level.BattleChatterPriority				= chatDesire.priority;

			print3d(self.origin + (0,0,50), self.chatPlaying.soundAliases[i], (1,0,0), 1, 1.50);	

			
			wait(0.25);
		}
	}
	
	self.chatPlaying = undefined; 
}




AddSoundAliases(speaker, chat)
{
	chat.soundAliases = [];

	chat.soundAliases[chat.soundAliases.size] = buildSoundAlias( chat.accent, chat.voiceType, chat.voiceIndex, chat.msgtype, chat.threattype );

	if( chat.msgtype == "IdentifyBond" || chat.msgtype == "NoticeBond" || chat.msgtype == "InquireBond" )
	{
		self addLandmarkAlias(1.0, level.player); 
	}
}




AiBattleChatterDebugRenderLoop()
{
/#
	self endon ( "death" );
	
	msg   = "";
	
	while( isdefined(self) )
	{	
		wait( 0.05 );
		
		if( IsDefined(self.chatPlaying ) && self.chatPlaying.msg != "" )
		{
			if ( getdvarint ("ai_ChatEnable") > 0 && getdvarint ("ai_ChatShowDebug") > 0  )
			{			
				msg   = self.chatPlaying.msg;
				for(i=0; i<30;i++)
				{
					print3d (self.origin + (0,0,50), msg, (1,1,1), 1, 1.50);	
					
					wait( 0.05 );
					
					if( IsDefined(self.chatPlaying ) && self.chatPlaying.msg != msg )
					{
						i	= 0;	
						msg = self.chatPlaying.msg;					
					}
				} 
			}	
		}
		
	}	 
#/	

}




WillFlank()
{
	
	target = level.player;
	
	if( IsDefined(target) )
	{
		meAroundTgt = target CalcYawAroundMe(self.origin);
				
		
		if( abs(meAroundTgt) < 20 )
		{
			destCover = self GetDestinationCover();
			if( IsDefined(destCover) )
			{				
				destAroundTgt	= target CalcYawAroundMe(destCover.origin);	
								
				if( abs(destAroundTgt) > 30 )
				{
					return true;
				}
			}				
		}
	}
	return false;
}





CalcYawAroundMe(point)
{
	deltaAng  = vectortoangles(point - self.origin);
	deltaYaw  = deltaAng[1]-self.angles[1];
	
	return deltaYaw;
}





RespectIntervalsMin(chatDesire)
{
	time		= level calcTimeSincePlay(chatDesire.msgtype, chatDesire.threattype);
	intervalMin = getIntervalMinTeam(chatDesire.msgtype, chatDesire.threattype);
				
	if( time >= intervalMin )
	{
		time		= self calcTimeSincePlay(chatDesire.msgtype, chatDesire.threattype);
		intervalMin = getIntervalMinSelf(chatDesire.msgtype, chatDesire.threattype);
				
		if( time >= intervalMin )
		{
			return true;
		}
	}	
	return false;
}




getSoundAliasSuffix(msgtype, threattype)
{		
	return level.SoundAliasSuffix[msgtype];
}





InitSoundAliasSuffix()
{
	level.SoundAliasSuffix = [];
	
	
	
	
	level.SoundAliasSuffix["NoticeBond"]		= "Noti_Bnd";
	level.SoundAliasSuffix["InvalidateBond"]	= "Inva_Bnd";
	level.SoundAliasSuffix["InquireBond"]		= "Inqu_Bnd";
	level.SoundAliasSuffix["WarnBond"]			= "Warn_Bnd";
	level.SoundAliasSuffix["SearchBond"]		= "Sear_Bnd";
	level.SoundAliasSuffix["IdentifyBond"]		= "Iden_Bnd";
	level.SoundAliasSuffix["Propagation"]		= "Prop_Bnd";
	level.SoundAliasSuffix["FireAtTgt"]			= "Fire_Cmb";
	level.SoundAliasSuffix["RusherFireAtTgt"]	= "FrRs_Cmb";
	level.SoundAliasSuffix["Reload"]			= "Relo_Cmb";
	level.SoundAliasSuffix["GotoCover"]			= "Flan_Cmb";
	level.SoundAliasSuffix["TakeCover"]			= "TkCv_Cmb";	
	level.SoundAliasSuffix["HideCover"]			= "HdCv_Cmb";
	level.SoundAliasSuffix["WasHit"]			= "Woun_Cmb";
	level.SoundAliasSuffix["WasKilled"]			= "Dead_Cmb";
	level.SoundAliasSuffix["LostBond"]			= "McLS_Cmb";
	level.SoundAliasSuffix["ReacquiredBond"]	= "McGS_Cmb";
	level.SoundAliasSuffix["IsSuppressed"]		= "Supp_Cmb"; 
	level.SoundAliasSuffix["BalconyDeath"]		= "Balc_Cmb";
	level.SoundAliasSuffix["SuppressBond"]		= "Pind_Cmb";
	level.SoundAliasSuffix["CoverMe"]			= "CvFr_Cmb";
	level.SoundAliasSuffix["GrenadeAtTgt"]		= "Grnd_Cmb";
	level.SoundAliasSuffix["GrenadeEvade"]		= "GrEv_Cmb";
	level.SoundAliasSuffix["LastManStanding"]	= "Last_Cmb";
	level.SoundAliasSuffix["Death"]				= "generic_death";
	level.SoundAliasSuffix["DeathSilent"]		= "quiet_death";
	
	
	
	
	level.SoundAliasSuffix["NoticeCorpse"]		= "Noti_Crp";
	level.SoundAliasSuffix["IdentifyCorpse"]	= "Iden_Crp";
	level.SoundAliasSuffix["CheckVitalCorpse"]	= "ChVi_Crp";
	level.SoundAliasSuffix["SearchCorpse"]		= "Sear_Crp";
	
}




getSoundAliasMsg(msgtype, threattype)
{		
	return level.SoundAliasMsg[msgtype];
}




InitSoundAliasMsg()
{
	level.SoundAliasMsg = [];
	
	
	
	
	level.SoundAliasMsg["NoticeBond"]		= "Notice Bond";
	level.SoundAliasMsg["InvalidateBond"]	= "Nevermind";
	level.SoundAliasMsg["InquireBond"]		= "Who's there?";
	level.SoundAliasMsg["WarnBond"]			= "Warn Bond";
	level.SoundAliasMsg["SearchBond"]		= "Search for Bond";
	level.SoundAliasMsg["IdentifyBond"]		= "It's Bond!";
	level.SoundAliasMsg["Propagation"]		= "Shots fired! Need backup!";
	level.SoundAliasMsg["FireAtTgt"]		= "Fire!!!";
	level.SoundAliasMsg["RusherFireAtTgt"]	= "Fire!!! (Rusher)";
	level.SoundAliasMsg["Reload"]			= "Reloading";
	level.SoundAliasMsg["GotoCover"]		= "Flanking";
	level.SoundAliasMsg["TakeCover"]		= "Taking Cover";
	level.SoundAliasMsg["HideCover"]		= "I'm hiding!";
	level.SoundAliasMsg["WasHit"]			= "I'm hit!";
	level.SoundAliasMsg["WasKilled"]		= "He's dead!";
	level.SoundAliasMsg["LostBond"]			= "Where'd he go?";
	level.SoundAliasMsg["ReacquiredBond"]	= "There he is!";
	level.SoundAliasMsg["IsSuppressed"]		= "I'm pinned down";
	level.SoundAliasMsg["BalconyDeath"]		= "I'm falling to my death";
	level.SoundAliasMsg["SuppressBond"]		= "Keep him pinned down";
	level.SoundAliasMsg["CoverMe"]			= "Cover me";	
	level.SoundAliasMsg["GrenadeAtTgt"]		= "Catch!";
	level.SoundAliasMsg["GrenadeEvade"]		= "Grenade! Run!";
	level.SoundAliasMsg["LastManStanding"]	= "They're all dead!";
	level.SoundAliasMsg["Death"]			= "I'm dead =(";
	level.SoundAliasMsg["DeathSilent"]		= "I'm dead, and no one even noticed =(";
	
	
	
	
	level.SoundAliasMsg["NoticeCorpse"]		= "Notice Corpse";
	level.SoundAliasMsg["IdentifyCorpse"]	= "It's a corpse!";
	level.SoundAliasMsg["CheckVitalCorpse"]	= "No pulse";
	level.SoundAliasMsg["SearchCorpse"]		= "Where's the killer?";
	
}




calcTimeSincePlay(msgtype, threattype)
{
	if( isdefined(self.chatLastPlay[msgtype]) )
	{
		return gettimeinsec() - self.chatLastPlay[msgtype];
	}
	else
	{
		return 10000000;
	}
}




getIntervalMinTeam(msgtype, threattype)
{		
	return GetDvarInt("ai_chatNotify" + msgtype + "TeamInt");
}




getIntervalMinSelf(msgtype, threattype)
{		
	return GetDvarInt("ai_chatNotify" + msgtype + "SelfInt");
}




getNearAiMin(msgtype, threattype)
{		
	return GetDvarInt("ai_chatNotify" + msgtype + "MinAi");
}






FindGroundType()
{
	groundType = "dirt";
	
	
	if (isdefined(self.groundtype))
	{
		groundtype = self.groundtype;
	}
	else if (isdefined(self.lastGroundtype))
	{	
		groundtype = self.lastGroundtype;
	}
	
	return groundType;
}




AiFootstepLoop()
{
	self endon ( "death" );
		
	if ( isAI(self) )
	{				
		while( isdefined(self) )
		{	
			
			self waittillmatch( "anim_notetrack", "footstep" );
			
			self.lastGroundtype = self FindGroundType();
		
			
			speed = self GetSpeed()/12;

			soundname = "";
			if( speed > 6.5 )
			{		
				soundname  = "step_run_" + self.lastGroundtype;
			}
			else
			{
				soundname  = "step_walk_" + self.lastGroundtype;
			}
			
			
			
			self playsound( soundname );

			wait( 0.05 );
		}
	}
}




AiScreamListener()
{
	self endon ( "death" );
		
	if ( isAI(self) )
	{
		while( isdefined(self) )
		{							
			self waittill("pain");

			painSound = self.chatAccent + "_" + self.chatVoiceType + "_" + self.chatVoiceIndex + "_generic_pain";

			println("playSound: " + painSound);
			self maps\_utility::play_dialogue( painSound );
			
			wait(0.2);
		}
	}
}




AiQKListener()
{
	if ( isAI(self) )
	{
	}
}

BondQKListener()
{
	if ( isplayer( self ) )
	{
		self thread QKNoteListener( "qk_bond_exert", "bond_exert", "bond_stealth_exert");
		self thread QKNoteListener( "qk_exert_quick", "exert_quick", "exert_stealth_quick");
		self thread QKNoteListener( "qk_exert_long", "exert_long", "exert_stealth_long");
		self thread QKNoteListener( "qk_exert_choke", "ex_choke", "exert_stealth_choke");
		self thread QKNoteListener( "qk_exert_gut", "ex_gut", "exert_stealth_gut");
	}
}


QKNoteListener( noteName, aliasName, stealthName)
{
	self endon ( "death ");
	while (isdefined(self) )
	{
		self waittillmatch("anim_notetrack", noteName);
		if (isstealthbroken())
		{
			soundName = aliasName;
		}
		else
		{
			soundName = stealthName;
		}
		println("playSound: " + soundName);
		self maps\_utility::play_dialogue( soundName );
		wait(0.2);
	}
}




addLandmarkAlias(chance, target)
{
	if (randomfloat (1) > chance)
		return (false);
	
	self.chatPlaying.landmarkEnt = target getLandmark();	
	if (!isdefined (self.chatPlaying.landmarkEnt))
		return (false);

	landmark = self.chatPlaying.landmarkEnt.script_landmark;
	








	
	self.chatPlaying.landmark = "LndMrk_" + landmark;

	
	self.chatPlaying.landmark = "Woun_Cmb";

	self.chatPlaying.soundAliases[self.chatPlaying.soundAliases.size] = buildSoundAliasWithSuffix( self.chatPlaying.accent, self.chatPlaying.voiceType, self.chatPlaying.voiceIndex, self.chatPlaying.landmark );
	
	return (true);
}




getLandmark()
{
	landmarks = level.landmarks;
	for (i = 0; i < landmarks.size; i++)
	{
		if (self istouching (landmarks[i]) && isdefined (landmarks[i].script_landmark))
			return (landmarks[i]);
	}
	return (undefined);
}




bcDrawObjects()
{
	for (i = 0; i < level.landmarks.size; i++)
	{
		if (!isdefined (level.landmarks[i].script_landmark))
			continue;

		thread drawBCObject("Landmark: " + level.landmarks[i].script_landmark, level.landmarks[i] getOrigin(), (0,0,0), (1,1,1));
	}
}




drawBCObject( string, origin, offset, color )
{
	while( true )
	{
		if ( getdvarint ("ai_ChatShowDebug") == 0 || distance( level.player.origin, origin) > 2048 )
		{
			wait ( 0.1 );
			continue;
		}
			
		print3d( origin + offset, string, color, 1, 0.75);	
		wait 0.05;
	}	
}




InitNoteTracks()
{
	level.NoteTracks = [];

	level.NoteTracks["footstep"]					= ::doNoteTrackFootStep;
	level.NoteTracks["step"]						= ::doNoteTrackFootStep;
	level.NoteTracks["footstep_right_large"]		= ::doNoteTrackFootStep;
	level.NoteTracks["footstep_right_small"]		= ::doNoteTrackFootStep;
	level.NoteTracks["footstep_left_large"]			= ::doNoteTrackFootStep;
	level.NoteTracks["footstep_left_small"]			= ::doNoteTrackFootStep;

	level.NoteTracks["bodyfall large"]				= ::doNoteTrackBodyFall;
	level.NoteTracks["bodyfall small"]				= ::doNoteTrackBodyFall;
}




AiNoteTrackListener()
{
	self endon ( "death" );

	while(1)
	{
		self waittill( "anim_notetrack", note );






		self ProcessNoteTrack( note );
	}
}




ProcessNoteTrack( note, customFunction )
{
	if ( isDefined( level.NoteTracks[note] ) )
	{
		return [[level.NoteTracks[note]]]( note );
	}

	switch ( note )
	{
		case "end":
		case "finish":
		case "undefined":
			return note;
		default:
			if (isDefined(customFunction))
				return [[customFunction]] (note);
			break;
	}
}




doNoteTrackFootStep( note )
{
	self.lastGroundtype = self FindGroundType();
		
	
	speed = self GetSpeed()/12;

	soundname = "";
	if( speed > 6.5 )
	{		
		soundname  = "step_run_" + self.lastGroundtype;
	}
	else
	{
		soundname  = "step_walk_" + self.lastGroundtype;
	}
	
	
	
	self playsound( soundname );
}




doNoteTrackBodyFall( note )
{
	self.lastGroundtype = self FindGroundType();

	soundname = "";
	if( note == "bodyfall large" )
	{		
		soundname  = "bodyfall_" + self.lastGroundtype + "_large";
	}
	else
	{
		soundname  = "bodyfall_" + self.lastGroundtype + "_small";
	}
	
	
	
	self playsound( soundname );
}




NumNearAi( ignoreEnt )
{
	numNearAi = 0;

	nearAi = entsearch( level.CONTENTS_ACTOR, self.origin, 100*12 );
	for( i=0; i < nearAi.size; i++ )
	{
		if( nearAi[i] != ignoreEnt && isAlive(nearAi[i]) )
		{
			numNearAi++;
		}
	}

	return numNearAi;
}




NumEngagedNearAi( ignoreEnt )
{
	numNearAi = 0;

	nearAi = entsearch( level.CONTENTS_ACTOR, self.origin, 100*12 );
	for( i=0; i < nearAi.size; i++ )
	{
		if( nearAi[i] != ignoreEnt && isAlive(nearAi[i]) && nearAi[i] isEngaged() )
		{
			numNearAi++;
		}
	}

	return numNearAi;
}




ResetTimers()
{
	if( (self GetCombatRole()) == "Elite" )
	{
		level.BattleChatterAnyoneElite   = gettimeinsec();
	}
}




CheckCombatRole()
{
	
	if( self.chatVoiceType != "S" )
	{
		if( (self GetCombatRole()) == "Elite" )
		{
			self.chatVoiceType  = "S"; 
			self.chatVoiceIndex = randomintrange( 1, 3 ); 

			
			if( (gettimeinsec() - level.BattleChatterAnyoneElite) > 15 )
			{
				level.BattleChatterAnyoneElite = gettimeinsec();

				println("playSound: SAM_S_1_Alrt_Cmb");
				self playsound( "SAM_S_1_Alrt_Cmb", "SAM_S_1_Alrt_Cmb", true );
			}
		}
	}
}




