-- object fo_tutorial_launcher

--## SERVER

function fo_tutorial_launcher:init()

	while (not AllClientViewsActiveAndStable()) do
		Sleep(1);
	end
	
	RunClientScript ("fo_tutorial_launcher");
	
end

--## CLIENT

function remoteClient.fo_tutorial_launcher()

	FT_AssignObjectName(FT_FindClosestObject(-1096.84, 961.28, -129.55, 1), "Blockade_1")
	FT_AssignObjectName(FT_FindClosestObject(-1096.84, 961.28, -130.71, 1), "Blockade_2")

	FT_Clear()

	;-- Beat 1
	FT_LinearGroupBegin("Beat1_Group")

		FT_CreateTutorialInitializeAction("TutorialInit")
		
		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)

		FT_CreateForgeUIVisibleAction("HideOptionButtons", "OptionButtons", false)
		FT_CreateForgeUIVisibleAction("HideMenuButtons", "MenuButtons", false)
		FT_CreateForgeUIVisibleAction("HideControlsHelper", "ControlsHelper", false)

		FT_CreateTimerAction("Beat01_StartTimer", 2.0)
		FT_CreateModalPopupAction("TutorialStartPopup", "ft_beat01_00", "ft_beat01_01", "", 0, 0)

		FT_CreateCameraAction("CameraInit", -1233, 1046, -20, -1146, 908, -24, 0.25)
	;--    FT_CreateDebugMessageAction("Welcome", "WELCOME TO THE FORGE TUTORIAL...", true, true)

		FT_CreateCameraAction("FlyThrough_01", -1428, 137, -21, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_01"), true, false, 30.0)

		FT_ParallelGroupBegin("Group1")
			FT_CreateDebugMessageAction("Welcome", "WE'LL START WITH A FLY THROUGH OF OUR WORLD...", false, false)
			FT_CreateCameraAction("FlyThrough_02", -983, -326, -39, 33, -330, 1.0, 2.0)
			FT_SetObjectivePrompt(FT_FindAction("FlyThrough_02"), "ft_beat01_00", "ft_beat01_02", "")
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_02"), false, false, 30.0)
	    	FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_02"), FT_FindAction("FlyThrough_01"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_03", -270, -1106, 6, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_03"), false, false, 30.0)
		FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_03"), FT_FindAction("FlyThrough_02"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateDebugMessageAction("Welcome", "EVERYTHING IS SO SHINY...", false, false)
			FT_CreateCameraAction("FlyThrough_04", 386, -424, 6, 33, -330, 1.0, 2.0)
			FT_SetObjectivePrompt(FT_FindAction("FlyThrough_04"), "ft_beat01_00", "ft_beat01_03", "")
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_04"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_04"), FT_FindAction("FlyThrough_03"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_05", 479, 577, 6, 33, -330, 1.0, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_05"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_05"), FT_FindAction("FlyThrough_04"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateCameraAction("FlyThrough_06", -289, 1233, 6, 33, -330, 1.0, 2.0)
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_06"), false, false, 30.0)
	   		FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_06"), FT_FindAction("FlyThrough_05"))
		FT_GroupEnd()

		FT_CreateCameraAction("FlyThrough_07", -972, 1456, -108, -1550, 1491, -121, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyThrough_07"), false, false, 30.0)
			FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_07"), FT_FindAction("FlyThrough_06"))

		FT_ParallelGroupBegin("Group1")
			FT_CreateCameraAction("FlyThrough_08", -1455, 1487, -120, -1550, 1491, -121, 3.0)
			FT_SetObjectivePrompt(FT_FindAction("FlyThrough_08"), "ft_beat01_00", "ft_beat01_04", "")
			FT_CameraActionSetParameters(FT_FindAction("FlyThrough_08"), false, true, 15.0)
	   		FT_CameraActionSetPrevious(FT_FindAction("FlyThrough_08"), FT_FindAction("FlyThrough_07"))
		FT_GroupEnd()

		FT_CreateTimerAction("Beat01_EndTimer", 0.0)
		FT_SetClearObjectivePrompt(FT_FindAction("Beat01_EndTimer"))
		
	FT_GroupEnd()

	;-- Beat 2
	FT_LinearGroupBegin("Beat2_Group")

		FT_SetOnSuccessAction(FT_FindAction("Beat1_Group"), FT_FindAction("Beat2_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)

		FT_CreateDebugMessageAction("Beat2", "Let's mount the camera so you can being to fly...", false, false)
		FT_CreateCameraAction("Beat02_FlyToCamera", -1547.77, 1483.41, -118.5, -1518.69, 1434.24, -122.8, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("Beat02_FlyToCamera"), true, false, 10.0)
		FT_SetObjectivePrompt(FT_FindAction("Beat02_FlyToCamera"), "ft_beat02_00", "ft_beat02_01", "")
		FT_SetHideObjectivePrompt(FT_FindAction("Beat02_FlyToCamera"), true)

	;--   	FT_CreateDebugScriptAction("HideFakeCamera", "FT_SetObjectPosition(FT_FindClosestObject(-1550, 1491, -121, 5), -1550, 1491, -134)", "")
		FT_CreateCameraAction("FlyToCamera_02", -1547.77, 1483.41, -118.5, -1518.69, 1434.24, -122.8, 2.0)
		FT_CameraActionSetParameters(FT_FindAction("FlyToCamera_02"), false, true, 10.0)

		FT_CreateTimerAction("Beat02_EndTimer", 0.0)
		
	FT_GroupEnd()

	;-- Beat 3
	FT_LinearGroupBegin("Beat3_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat2_Group"), FT_FindAction("Beat3_Group"))
		FT_SetObjectivePrompt(FT_FindAction("Beat3_Group"), "title", "firstbody", "")
		
		FT_CreateForgeUIVisibleAction("ShowControlsHelper", "ControlsHelper", true)

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "")

		FT_ParallelGroupBegin("EnterTube_Group")
			FT_CreateLocationNavPointAction("TubeEntrance", "ft_navpoint_start_of_tube", -1510.8, 1421.9, -122.1)
			FT_CreateDebugMessageAction("TubeEntranceMessage", "Enter the tube...", true, false)
			FT_CreateCameraLocationAction("CameraEnterTube", -1510.73, 1424.71, -121.72, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraEnterTube"), "ft_beat03_00", "ft_beat03_01", "ft_beat03_01_controller")
			FT_SetParentGroupComplete(FT_FindAction("CameraEnterTube"))
		FT_GroupEnd()

		FT_ParallelGroupBegin("ExitTube_Group")
			FT_CreateLocationNavPointAction("TubeExit", "ft_navpoint_end_of_tube", -1136.5, 1007.5, -131.0)
			FT_CreateDebugMessageAction("TubeEntranceMessage", "Follow the tube to the end...", true, false)
			FT_CreateCameraLocationAction("CameraExitTube",  -1136.5, 1007.5, -131.0, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraExitTube"), "ft_beat03_00", "ft_beat03_02", "")
			FT_SetHideObjectivePrompt(FT_FindAction("CameraExitTube"), true)
			FT_SetParentGroupComplete(FT_FindAction("CameraExitTube"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("ForceStopCamera", "FreeCam", false, "", false)
		FT_CreateCameraAction("CameraInit", -1126.87, 996.02, -132.09, -1063.37, 918.83, -129.21, 1.0)

		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "", "", "", "")

		FT_CreateTimerAction("Beat03_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 4
	FT_LinearGroupBegin("Beat4_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat3_Group"), FT_FindAction("Beat4_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableObjectSelectionInput", "ObjectSelection", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightObjectSelect", "GrabHighlightedItem", "UngrabHighlightedItem", "", "")

		FT_LinearGroupBegin("Delete1_Group")
		
			FT_ParallelGroupBegin("TestSelectedObjectGroup")
		    FT_CreateDebugMessageAction("DeleteMsg1", "Select the two objects blocking the exit...", false, false)
		    FT_CreateObjectSelectedAction("SelectObject1", FT_FindNamedObject("Blockade_1"))
		    FT_AddSelectionObjectIndex(FT_FindAction("SelectObject1"), FT_FindNamedObject("Blockade_2"))
			FT_SetObjectivePrompt(FT_FindAction("SelectObject1"), "ft_beat04_00", "ft_beat04_01", "ft_beat04_01_controller")
				FT_CreateObjectNavPointAction("SelectObject2NavPoint", "ft_navpoint_object_selection", FT_FindNamedObject("Blockade_2"))
				FT_CreateObjectNavPointAction("SelectObject1NavPoint", "ft_navpoint_object_selection", FT_FindNamedObject("Blockade_1"))
				FT_SetParentGroupComplete(FT_FindAction("SelectObject1"))
			FT_GroupEnd()
		    

			FT_CreateDebugMessageAction("DeleteMsg1", "Now delete or move the object2...", false, false)

			FT_CreateForgeInputEnabledAction("DisableObjectSelectionInput", "ObjectSelection", false, "", false)
			FT_CreateForgeInputEnabledAction("EnsableObjectActionsInput", "ObjectDelete", true, "", false)
			FT_CreateControlsHelperHighlightAction("HelperHighlightDelete", "DeleteSelectedItems", "", "", "")

			FT_ParallelGroupBegin("TestDeletedObjectGroup")
				FT_CreateObjectLocationAction("DeleteObject1", FT_FindNamedObject("Blockade_1"), -1096.84, 961.28, -129.55, 30.0, 30.0, true)
				FT_CreateObjectLocationAction("DeleteObject2", FT_FindNamedObject("Blockade_2"), -1096.84, 961.28, -130.71, 30.0, 30.0, true)
			FT_GroupEnd()
			
			FT_SetObjectivePrompt(FT_FindAction("TestDeletedObjectGroup"), "ft_beat04_00", "ft_beat04_02", "ft_beat04_02_controller")
		FT_GroupEnd()

	FT_GroupEnd()	

	;-- Beat 4b
	FT_LinearGroupBegin("Beat4b_Group")

		FT_SetOnSuccessAction(FT_FindAction("Beat4_Group"), FT_FindAction("Beat4b_Group"))
		FT_SetOnFailAction(FT_FindAction("Beat4_Group"), FT_FindAction("Beat4b_Group"))
		
		FT_CreateForgeUIVisibleAction("ShowOptionButtons", "OptionButtons", true)

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableForgeInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "EnterBoost")

		FT_ParallelGroupBegin("MoveToRing_Group")
			FT_CreateLocationNavPointAction("RingNavPoint", "ft_navpoint_approach_ring", -65.6, -416.2, -73.5)
			FT_CreateDebugMessageAction("MoveToRingMsg", "Fly over the hill to the next waypoint...", true, false)
			FT_CreateCameraLocationAction("CameraRingLocation", -65.6, -416.2, -73.5, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CameraRingLocation"), "ft_beat04_03", "ft_beat04_04", "ft_beat04_04_controller")
			FT_SetHideObjectivePrompt(FT_FindAction("CameraRingLocation"), true)
			FT_SetParentGroupComplete(FT_FindAction("CameraRingLocation"))
		FT_GroupEnd()

		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "", "", "", "")

		FT_CreateTimerAction("Beat04_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 5
	FT_LinearGroupBegin("Beat5_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat4b_Group"), FT_FindAction("Beat5_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)

		FT_CreateDebugMessageAction("Beat5_Message", "We're going to learn to spawn an object...", false, false)
		FT_CreateCameraAction("CameraPrepareSpawn", -69.5, -462.5, -88.0, -127.0, -532.0, -130.0, 2.0)
		
		FT_CreateForgeUIVisibleAction("ShowMenuButtons", "MenuButtons", true)
		FT_CreateForgeInputEnabledAction("MenuSpawn", "MenuSpawn", true, "", false)

		FT_CreateDebugMessageAction("Beat5_Message", "Press 'O' and use the Spawn Menu to create a 'Man Cannon'...", false, false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightSpawn", "OpenSpawnObjectMenu", "", "", "")
		FT_CreateMenuTrailAction("OpenSpawnMenu", "SpawnObject", false)
		FT_SetObjectivePrompt(FT_FindAction("OpenSpawnMenu"), "ft_beat05_00", "ft_beat05_01", "ft_beat05_01_controller")
		
		FT_CreateControlsHelperHighlightAction("ClearHelperHighlightSpawn", "", "", "", "")
		FT_ParallelGroupBegin("SpawnObjectGroup")
			FT_CreateMenuTrailAction("MenuSpawnAction", "SpawnManCannon", true)
			FT_CreateObjectCreatedAction("ObjectCreatedAction", "ManCannon")
			FT_SetObjectivePrompt(FT_FindAction("ObjectCreatedAction"), "ft_beat05_00", "ft_beat05_02", "")
			FT_SetHideObjectivePrompt(FT_FindAction("ObjectCreatedAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("ObjectCreatedAction"))
		FT_GroupEnd()

		FT_CreateTimerAction("Beat05_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 6
	FT_LinearGroupBegin("Beat6_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat5_Group"), FT_FindAction("Beat6_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableTranslateModeInput", "TranslateMode", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableTranslateInput", "Translate", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightTranslate", "TranslateGrabbedItems", "EndTranslateGrabbedItems", "MoveObject", "")

		FT_ParallelGroupBegin("MoveObjectGroup")
			FT_CreateLocationNavPointAction("MoveLocator", "ft_navpoint_move_object_here", -163.57, -572.16, -147.61)
			FT_CreateEditModeHighlightAction("TranslateButtonHighlight", "Translate")
			FT_CurrentObjectLocationAction("Beat06_MoveObjectAction", -163.57, -572.16, -147.61, 2.5, 2.5)
			FT_SetObjectivePrompt(FT_FindAction("Beat06_MoveObjectAction"), "ft_beat06_00", "ft_beat06_01", "ft_beat06_01_controller")
			FT_SetHideObjectivePrompt(FT_FindAction("Beat06_MoveObjectAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("Beat06_MoveObjectAction"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("DisableTranslateInput", "Translate", false, "", false)

		FT_CreateTimerAction("Beat06_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 7
	FT_LinearGroupBegin("Beat7_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat6_Group"), FT_FindAction("Beat7_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableRotationModeInput", "RotationMode", true, "", false)
		FT_CreateForgeInputEnabledAction("EnableRotationInput", "Rotate", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightRotate", "RotateGrabbedItems", "EndRotateGrabbedItems", "RotateObjectHorizontalAxis", "ChangeEditModeToRotation")

		FT_ParallelGroupBegin("RotateObjectGroup")
			FT_CreateLocationNavPointAction("RotateLocator", "ft_navpoint_rotate_object_here", -131.7, -589.5, -145.6)
			FT_CreateEditModeHighlightAction("RotateButtonHighlight", "Rotate")
			FT_CurrentObjectRotationAction("Beat07_RotateObjectAction", -131.7, -589.5, -145.6, 2.0, 0.0)
			FT_SetObjectivePrompt(FT_FindAction("Beat07_RotateObjectAction"), "ft_beat07_00", "ft_beat07_01", "ft_beat07_01_controller")
			FT_SetHideObjectivePrompt(FT_FindAction("Beat07_RotateObjectAction"), true)
			FT_SetParentGroupComplete(FT_FindAction("Beat07_RotateObjectAction"))
		FT_GroupEnd()


		FT_CreateForgeInputEnabledAction("DisableRotateInput", "Rotate", false, "", false)
		FT_CurrentObjectSetTransformAction("AdjustObject", -163.57, -572.16, -147.61, -131.7, -589.5, -145.6, 0.5)

		FT_CreateTimerAction("Beat07_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 8
	FT_LinearGroupBegin("Beat8_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat7_Group"), FT_FindAction("Beat8_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateForgeInputEnabledAction("MenuProperties", "MenuProperties", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightPropertiesMenu", "OpenObjectPropertiesMenu", "", "", "")

		FT_CreateDebugMessageAction("Beat8_OpenMenu", "Press 'P' to edit the cannon values...", false, false)
		FT_CreateDebugMessageAction("Beat8_Values", "Forward: 1000, Vertical:147.5, height: 0", false, false)
		
		FT_CreateMenuTrailAction("OpenObjectPropertiesMenu", "ObjectProperties", false)
		FT_SetObjectivePrompt(FT_FindAction("OpenObjectPropertiesMenu"), "ft_beat08_00", "ft_beat08_01", "ft_beat08_01_controller")
		
		FT_CreateControlsHelperHighlightAction("ClearHelperHighlightPropertiesMenu", "", "", "", "")
		
		FT_CreateMenuTrailAction("EditCannonValue_Forward", "EditCannonValue_Forward", false)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonValue_Forward"), "ft_beat08_00", "ft_beat08_02", "")
		
		FT_CreateMenuTrailAction("EditCannonValue_Vertical", "EditCannonValue_Vertical", false)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonValue_Vertical"), "ft_beat08_00", "ft_beat08_03", "")
		
		FT_CreateMenuTrailAction("EditCannonValue_ArcHeight", "EditCannonValue_ArcHeight", true)
		FT_SetObjectivePrompt(FT_FindAction("EditCannonValue_ArcHeight"), "ft_beat08_00", "ft_beat08_04", "")
		FT_SetHideObjectivePrompt(FT_FindAction("EditCannonValue_ArcHeight"), true)

		FT_CreateTimerAction("Beat08_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 9
	FT_LinearGroupBegin("Beat9_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat8_Group"), FT_FindAction("Beat9_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "FreeCam", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightWASD", "MoveCamera", "EnterMovementMode", "RotateCamera", "")
		
		FT_ParallelGroupBegin("MoveCameraToCannon")
			FT_CreateDebugMessageAction("Beat9_Launch", "Fly down to the waypoint...", false, false)
			FT_CreateLocationNavPointAction("CannonEntry", "ft_navpoint_approach_mancannon", -180.34, -555.91, -145.63)
			FT_CreateCameraLocationAction("Beat09_CannonEntryLocation", -180.34, -555.91, -145.63, 10.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("Beat09_CannonEntryLocation"), "ft_beat09_00", "ft_beat09_01", "")
			FT_SetParentGroupComplete(FT_FindAction("Beat09_CannonEntryLocation"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("DisableFreeCamInput", "FreeCam", false, "", false)
		FT_CreateForgeInputEnabledAction("EnableFreeCamInput", "SpartanMode", true, "", false)
		FT_CreateControlsHelperHighlightAction("HelperHighlightSpartanMode", "EnterPlayerModeNoLightBake", "", "", "")

		FT_CreateNotifyForgeInputAction("EnterSpartanMode", "SpartanMode")
		FT_SetObjectivePrompt(FT_FindAction("EnterSpartanMode"), "ft_beat09_00", "ft_beat09_02", "ft_beat09_02_controller")
		FT_SetHideObjectivePrompt(FT_FindAction("EnterSpartanMode"), true)

		FT_CreateTimerAction("Beat09_EndTimer", 0.0)

	FT_GroupEnd()

	;-- Beat 10
	FT_LinearGroupBegin("Beat10_Group")
		FT_SetOnSuccessAction(FT_FindAction("Beat9_Group"), FT_FindAction("Beat10_Group"))

		FT_CreateForgeInputEnabledAction("DisableForgeInput", "all", false, "all", true)
		FT_CreateControlsHelperHighlightAction("HelperHighlightClear", "", "", "", "")

		FT_ParallelGroupBegin("EnterCannonGroup")
			FT_CreateDebugMessageAction("Beat10_Enter", "Now use the Man Cannon, to jump up to the waypoint...", false, false)
			FT_CreateLocationNavPointAction("CannonWaypoint", "ft_navpoint_use_mancannon", -167, -570, -145)
			FT_CreatePlayerLocationAction("CannonTestEntry", -167, -570, -145, 6.0, 10.0)
			FT_SetObjectivePrompt(FT_FindAction("CannonWaypoint"), "ft_beat10_00", "ft_beat10_01", "ft_beat10_01_controller")
			FT_SetHideObjectivePrompt(FT_FindAction("CannonWaypoint"), true)
			FT_SetParentGroupComplete(FT_FindAction("CannonTestEntry"))
		FT_GroupEnd()

		FT_ParallelGroupBegin("JumpToWaypoint")
			FT_CreateLocationNavPointAction("FlyWaypoint", "ft_navpoint_end_landing", 576.14, -961.03, 99.47)
			FT_CreatePlayerLocationAction("PlayerAtWaypoint", 576.14, -961.03, 99.47, 10.0, 10.0)
			FT_SetParentGroupComplete(FT_FindAction("PlayerAtWaypoint"))
		FT_GroupEnd()

		FT_CreateForgeInputEnabledAction("EnableForgeInput", "all", true, "", false)

		FT_CreateTimerAction("Beat10_EndTimer", 8.0)
		FT_SetObjectivePrompt(FT_FindAction("Beat10_EndTimer"), "ft_beat11_00", "ft_beat11_01", "")
		FT_SetHideObjectivePrompt(FT_FindAction("Beat10_EndTimer"), true)

		FT_CreateModalPopupAction("TutorialCompletePopup", "ft_beat11_00", "ft_beat11_01", "", 0, 1)
		FT_CreateTutorialShutdownAction("TutorialComplete")

	FT_GroupEnd()

	FT_BeginAction(FT_FindAction("Beat1_Group"))
				
end