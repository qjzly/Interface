----------------------------------------------------------------------------------------
--  FRAME
----------------------------------------------------------------------------------------


   
 -- COLORING THE MAIN BAR
	for i,v in pairs({
				PlayerFrameTexture,
				PlayerFrameAlternateManaBarBorder,
				PlayerFrameAlternateManaBarLeftBorder,
				PlayerFrameAlternateManaBarRightBorder,
				AlternatePowerBarBorder,
				AlternatePowerBarLeftBorder,
				AlternatePowerBarRightBorder,
   				TargetFrameTextureFrameTexture,
  				PetFrameTexture,
				PartyMemberFrame1Texture,
				PartyMemberFrame2Texture,
				PartyMemberFrame3Texture,
				PartyMemberFrame4Texture,
				PartyMemberFrame1PetFrameTexture,
				PartyMemberFrame2PetFrameTexture,
				PartyMemberFrame3PetFrameTexture,
				PartyMemberFrame4PetFrameTexture,
   				FocusFrameTextureFrameTexture,
   				TargetFrameToTTextureFrameTexture,
   				FocusFrameToTTextureFrameTexture,
				Boss1TargetFrameTextureFrameTexture,
				Boss2TargetFrameTextureFrameTexture,
				Boss3TargetFrameTextureFrameTexture,
				Boss4TargetFrameTextureFrameTexture,
				Boss5TargetFrameTextureFrameTexture,
				Boss1TargetFrameSpellBarBorder,
				Boss2TargetFrameSpellBarBorder,
				Boss3TargetFrameSpellBarBorder,
				Boss4TargetFrameSpellBarBorder,
				Boss5TargetFrameSpellBarBorder,
				
		--施法条
		MirrorTimer1Border,
		MirrorTimer2Border,
		TimerTrackerTimer1StatusBarBorder,
		CastingBarFrame.Border,
		FocusFrameSpellBar.Border,
		TargetFrameSpellBar.Border,
				
		--主动作条
		MainMenuBarTexture0,
		MainMenuBarTexture1,
		MainMenuBarTexture2,
		MainMenuBarTexture3,
		MainMenuBarLeftEndCap,
		MainMenuBarRightEndCap,
		
		--经验条
		MainMenuXPBarTextureLeftCap,
		MainMenuXPBarTextureRightCap,
		MainMenuXPBarTextureMid,
		MainMenuXPBarDiv1,
		MainMenuXPBarDiv2,
		MainMenuXPBarDiv3,
		MainMenuXPBarDiv4,
		MainMenuXPBarDiv5,
		MainMenuXPBarDiv6,
		MainMenuXPBarDiv7,
		MainMenuXPBarDiv8,
		MainMenuXPBarDiv9,
		MainMenuXPBarDiv10,
		MainMenuXPBarDiv11,
		MainMenuXPBarDiv12,
		MainMenuXPBarDiv13,
		MainMenuXPBarDiv14,
		MainMenuXPBarDiv15,
		MainMenuXPBarDiv16,
		MainMenuXPBarDiv17,
		MainMenuXPBarDiv18,
		MainMenuXPBarDiv19,
		
		--经验条精力充沛点
		ExhaustionTickNormal,
		ExhaustionTickHighlight,
		
		--声望条
		ReputationWatchBar.StatusBar.WatchBarTexture0,
		ReputationWatchBar.StatusBar.WatchBarTexture1,
		ReputationWatchBar.StatusBar.WatchBarTexture2,
		ReputationWatchBar.StatusBar.WatchBarTexture3,
		
		--潜行者头像连击点框架
		ComboPointPlayerFrame.Background,
		
		-- 团队框架
		CompactRaidGroup1BorderFrame,
        CompactRaidGroup2BorderFrame,
        CompactRaidGroup3BorderFrame,
        CompactRaidGroup4BorderFrame,
        CompactRaidGroup5BorderFrame,
        CompactRaidGroup6BorderFrame,
        CompactRaidGroup7BorderFrame,
        CompactRaidGroup8BorderFrame,
	
        CompactRaidFrameContainerBorderFrameBorderBottom,
        CompactRaidFrameContainerBorderFrameBorderBottomLeft,
        CompactRaidFrameContainerBorderFrameBorderBottomRight,
        CompactRaidFrameContainerBorderFrameBorderLeft,
        CompactRaidFrameContainerBorderFrameBorderRight,
        CompactRaidFrameContainerBorderFrameBorderTop,
        CompactRaidFrameContainerBorderFrameBorderTopLeft,
        CompactRaidFrameContainerBorderFrameBorderTopRight,

        CompactRaidFrameManagerToggleButton:GetRegions(),
        CompactRaidFrameManagerBg,
        CompactRaidFrameManagerBorderBottom,
        CompactRaidFrameManagerBorderBottomLeft,
        CompactRaidFrameManagerBorderBottomRight,
        CompactRaidFrameManagerBorderRight,
        CompactRaidFrameManagerBorderTopLeft,
        CompactRaidFrameManagerBorderTopRight,
        CompactRaidFrameManagerBorderTop,

	}) do
                 v:SetVertexColor(.3, .3, .3)
  	end 	


	
 -- COLORING ARENA FRAMES
	local CF = CreateFrame("Frame")
	local _, instanceType = IsInInstance()
	CF:RegisterEvent("ADDON_LOADED")
	CF:RegisterEvent("PLAYER_ENTERING_WORLD")
	CF:RegisterEvent("ARENA_PREP_OPPONENT_SPECIALIZATIONS")
        CF:SetScript("OnEvent", function(self, event, addon)
             	if addon == "Blizzard_ArenaUI" and not (IsAddOnLoaded("Shadowed Unit Frames")) then
			for i,v in pairs({
 				ArenaEnemyFrame1Texture,
				ArenaEnemyFrame2Texture,
				ArenaEnemyFrame3Texture, 
				ArenaEnemyFrame4Texture,
				ArenaEnemyFrame5Texture,
				ArenaEnemyFrame1SpecBorder,
				ArenaEnemyFrame2SpecBorder,
				ArenaEnemyFrame3SpecBorder,
				ArenaEnemyFrame4SpecBorder,
				ArenaEnemyFrame5SpecBorder,
				ArenaEnemyFrame1PetFrameTexture,
				ArenaEnemyFrame2PetFrameTexture,
				ArenaEnemyFrame3PetFrameTexture,
				ArenaEnemyFrame4PetFrameTexture, 
				ArenaEnemyFrame5PetFrameTexture,
              		}) do
                		v:SetVertexColor(.3, .3, .3)
	      		end 
		elseif event == "ARENA_PREP_OPPONENT_SPECIALIZATIONS" or (event == "PLAYER_ENTERING_WORLD" and instanceType == "arena") then
			for i,v in pairs({
				ArenaPrepFrame1Texture,
				ArenaPrepFrame2Texture,
				ArenaPrepFrame3Texture,
				ArenaPrepFrame4Texture,
				ArenaPrepFrame5Texture,
				ArenaPrepFrame1SpecBorder,
				ArenaPrepFrame2SpecBorder,
				ArenaPrepFrame3SpecBorder,
				ArenaPrepFrame4SpecBorder,
				ArenaPrepFrame5SpecBorder,
			}) do
                		v:SetVertexColor(.3, .3, .3)
	      		end 		
		end 
	end)
	
	


	
	
	
