

--/played
RequestTimePlayed()

KuiNameplatesCoreSaved = {
	["profiles"] = {
		["default"] = {
			["level_text"] = true,
			["frame_height"] = 18,
			["frame_height_minus"] = 12,
			["bar_texture"] = "TukTex",
		},
	},
}

AdvancedInterfaceOptionsSaved = {
	["CharVars"] = {
	},
	["AccountVars"] = {

		["floatingCombatTextCombatHealingAbsorbTarget"] = true,
		["floatingCombatTextRepChanges"] = true,

		["floatingCombatTextCombatDamageDirectionalScale"] = true,

		["floatingCombatTextReactives"] = true,
		["enableFloatingCombatText"] = false,
	},
}

ecfDB = {
	["profiles"] = {
		["Default"] = {
			["enableIGM"] = true,
			["advancedConfig"] = true,
		},
	},
}

GladiatorlosSADB = {
	["profiles"] = {
		["Default"] = {
			["path"] = "GladiatorlosSA_zhCN\\Voice_zhCN",
			["path_menu"] = "GladiatorlosSA_zhCN\\Voice_zhCN",
		},
	},
}

AdvancedInterfaceOptionsSaved = {
	["CharVars"] = {
	},
	["AccountVars"] = {
		["floatingCombatTextReactives"] = true,
		["floatingCombatTextCombatHealingAbsorbTarget"] = true,
		["floatingCombatTextRepChanges"] = true,
		["nameplateMaxDistance"] = 60,
		["cameraDistanceMaxFactor"] = 2.6,
		["enableFloatingCombatText"] = false,
	},
}

DBT_AllPersistentOptions = {
	["Default"] = {
		["DBM"] = {
			["TimerPoint"] = "LEFT",
			["HugeTimerPoint"] = "CENTER",

			["BarYOffset"] = 0,
			["height"] = 20,
			["HugeWidth"] = 200,
			["TimerX"] = 106,

			["EnlargeBarTime"] = 11,

			["FontFlag"] = "OUTLINE",
			["EndColorAB"] = 1,
			["Width"] = 183,
			["HugeTimerY"] = -28,
			
			["IconLeft"] = true,
			["FontSize"] = 10,
			["HugeBarYOffset"] = 0,
			["TimerY"] = 268,
			["HugeTimerX"] = -268,
		},
	},
}
----------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------

SkadaDB = {
	["profileKeys"] = {
		["浅井真莉亚 - 巫妖之王"] = "Default",
		["顺毛员 - 巫妖之王"] = "Default",
		["小清水亞美 - 巫妖之王"] = "Default",
		["両儀未娜 - 巫妖之王"] = "Default",
		["浅井真理亚 - 巫妖之王"] = "Default",
		["菲布莉 - 巫妖之王"] = "Default",
		
		["茅野爱衣 - 巫妖之王"] = "Default",
		["菲布理 - 巫妖之王"] = "Default",
		["椒椒 - 巫妖之王"] = "Default",
		["时雨布丁 - 巫妖之王"] = "Default",
		["水无月酱 - 巫妖之王"] = "Default",
		["夕立慕斯 - 巫妖之王"] = "Default",
		
		["坚而不射 - 巫妖之王"] = "Default",
		["拉萨丶 - 巫妖之王"] = "Default",
		["丶拉萨 - 巫妖之王"] = "Default",
	},
	["profiles"] = {
		["Default"] = {
			["windows"] = {
				{
					["barheight"] = 22,
					["classicons"] = false,
					["barslocked"] = true,
					["y"] = 32,
					["x"] = -7,
					["title"] = {
						["color"] = {
							["a"] = 0.3,
							["b"] = 0,
							["g"] = 0,
							["r"] = 0,
						},
						["bordercolor"] = {
							["a"] = 0,
						},
						["font"] = "聊天",
						["borderthickness"] = 0,
						["height"] = 22,
						["fontflags"] = "OUTLINE",
						["bordertexture"] = "Glow",
						["texture"] = "Statusbar",
					},
					["barfontflags"] = "OUTLINE",
					["point"] = "BOTTOMRIGHT",
					["mode"] = "伤害",
					["bartexture"] = "Statusbar",
					["barwidth"] = 240,
					["barbgcolor"] = {
						["a"] = 0.3,
						["b"] = 0,
						["g"] = 0,
						["r"] = 0,
					},
					["background"] = {
						["bordertexture"] = "Glow",
						["color"] = {
							["a"] = 0.3,
						},
						["borderthickness"] = 4,
						["height"] = 155,
						["bordercolor"] = {
							["a"] = 0.8,
						},
					},
					["barfont"] = "聊天",
				}, -- [1]
			},
		},
	},
}


------------↓NEW↓--------------
----------------------------------
---------------------------------------------------------------------
---------------------------------------------------------------------
-- AddOnSkinsOptions = {
	-- ["EmbedOoCDelay"] = 10,
	-- ["EmbedOoC"] = false,
	-- ["WeakAuraAuraBar"] = false,
	-- ["EmbedRight"] = "Skada",
	-- ["DBMFontSize"] = 12,
	-- ["DBMFontFlag"] = "OUTLINE",
	-- ["DBMSkinHalf"] = true,
	-- ["EmbedSystemMessage"] = true,
	-- ["DetailsBackdrop"] = true,
	-- ["EmbedSystemDual"] = false,
	-- ["EmbedMain"] = "Skada",
	-- ["EmbedRightChat"] = true,
	-- ["EmbedBelowTop"] = false,
	-- ["HideChatFrame"] = "NONE",
	-- ["EmbedSystem"] = false,
	-- ["WeakAuraIconCooldown"] = false,
	-- ["OmenBackdrop"] = true,
	-- ["SkinTemplate"] = "Transparent",
	-- ["EmbedLeftWidth"] = 200,
	-- ["EmbedCoolLine"] = false,
	-- ["DBMFont"] = "Tukui",
	-- ["DBMRadarTrans"] = true,
	-- ["SkinDebug"] = false,
	-- ["EmbedSexyCooldown"] = false,
	-- ["SkadaBackdrop"] = true,
	-- ["TransparentEmbed"] = false,
	-- ["LoginMsg"] = true,
	-- ["EmbedLeft"] = "Skada",
	-- ["MiscFixes"] = true,
	-- ["RecountBackdrop"] = true,
-- }
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
BugSackDB = {
	["fontSize"] = "GameFontHighlight",
	["auto"] = false,
	["soundMedia"] = "BugSack: Fatality",
	["mute"] = true,
	["chatframe"] = false,
}

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
DraenorTreasuresDB = {
	["profiles"] = {
		["Default"] = {
			["icon_scale_rares"] = 1,
			["icon_scale_treasures"] = 1,
		},
	},
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MogItDB = {

	["profiles"] = {
		["Default"] = {
			--["tooltipMod"] = "Alt",
			["minimap"] = {
				["minimapPos"] = 200,
			},
		},
	},
}
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
KalielsTrackerDB = {
	["profiles"] = {
		["Default"] = {
			["bgrColor"] = {
				["a"] = 0,
			},
			["hdrBgr"] = 3,
			["fontSize"] = 14,
			["maxHeight"] = 550,
			["fontShadow"] = 0,
			["fontFlag"] = "OUTLINE",
			["helpTutorial"] = 9,
			["collapseInInstance"] = true,
		},
	},
}



TrufiGCDChSave = {
	["TooltipEnable"] = true,
	["TooltipStopMove"] = true,
	["TrGCDQueueFr"] = {
		{
			["point"] = "CENTER",
			["enable"] = true,
			["text"] = "Player",
			["fade"] = "Left",
			["y"] = -255,
			["x"] = -40,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [1]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Party 1",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [2]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Party 2",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [3]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Party 3",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [4]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Party 4",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [5]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Arena 1",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [6]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Arena 2",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [7]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Arena 3",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [8]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Arena 4",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [9]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Arena 5",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [10]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Target",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [11]
		{
			["point"] = "CENTER",
			["enable"] = false,
			["text"] = "Focus",
			["fade"] = "Left",
			["y"] = 0,
			["x"] = 0,
			["speed"] = 18.75,
			["width"] = 3,
			["size"] = 30,
		}, -- [12]
	},
	["TooltipSpellID"] = false,
	["EnableIn"] = {
		["World"] = true,
		["Arena"] = true,
		["Enable"] = true,
		["Raid"] = true,
		["Bg"] = true,
		["PvE"] = true,
	},
	["TrGCDBL"] = {
		6603, -- [1]
		75, -- [2]
		7384, -- [3]
	},
	["ModScroll"] = true,
}
