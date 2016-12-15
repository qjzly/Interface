xCTSavedDB = {
	["profileKeys"] = {
		["浅井真理亚 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		["顺毛员 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		["浅井真莉亚 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
	},
	["profiles"] = {
		["浅井真莉亚 - 巫妖之王"] = {
			["blizzardFCT"] = {
				["floatingCombatTextCombatLogPeriodicSpells"] = true,
				["floatingCombatTextCombatDamage"] = true,
				["floatingCombatTextCombatDamageAllAutos"] = true,
				["floatingCombatTextCombatHealing"] = true,
				["floatingCombatTextDamageReduction"] = true,
				["floatingCombatTextPetSpellDamage"] = true,
				["floatingCombatTextFriendlyHealers"] = true,
				["floatingCombatTextPetMeleeDamage"] = true,
			},
			["frames"] = {
				["general"] = {
					["font"] = "伤害数字",
					["Y"] = 261,
					["fontSize"] = 14,
				},
				["power"] = {
					["font"] = "伤害数字",
					["fontSize"] = 10,
					["enabledFrame"] = false,
					["Y"] = -94,
				},
				["class"] = {
					["font"] = "伤害数字",
					["enabledFrame"] = false,
				},
				["outgoing"] = {
					["Width"] = 200,
					["font"] = "伤害数字",
					["fontSize"] = 12,
					["names"] = {
						["PLAYER"] = {
							["nameType"] = 2,
						},
					},
					["Y"] = -46,
					["X"] = 558,
					["Height"] = 417,
				},
				["critical"] = {
					["fontSize"] = 14,
					["X"] = 298,
					["Y"] = 16,
					["font"] = "伤害数字",
				},
				["procs"] = {
					["fontSize"] = 20,
					["font"] = "伤害数字",
					["enabledFrame"] = false,
				},
				["loot"] = {
					["font"] = "伤害数字",
					["fontSize"] = 16,
					["enabledFrame"] = false,
					["Y"] = -223,
				},
				["healing"] = {
					["fontSize"] = 14,
					["font"] = "伤害数字",
				},
				["damage"] = {
					["font"] = "伤害数字",
					["fontSize"] = 15,
				},
			},
		},
	},
}



local addon, ns = ...

-- if not IsAddOnLoaded("xCT") then return end

-- 預設設置
local SetXCT = function()
	if(xCTSavedDB) then table.wipe(xCTSavedDB) end
	xCTSavedDB = {
		-- ["profileKeys"] = {
			-- ["浅井真理亚 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
			-- ["顺毛员 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
			-- ["浅井真莉亚 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
			-- ["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
			-- ["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
			-- ["両儀未娜 - 巫妖之王"] = "浅井真莉亚 - 巫妖之王",
		-- },
		["profiles"] = {
			-- ["浅井真莉亚 - 巫妖之王"] = {
				["blizzardFCT"] = {
					["floatingCombatTextCombatLogPeriodicSpells"] = true,
					["floatingCombatTextCombatDamage"] = true,
					["floatingCombatTextCombatDamageAllAutos"] = true,
					["floatingCombatTextCombatHealing"] = true,
					["floatingCombatTextDamageReduction"] = true,
					["floatingCombatTextPetSpellDamage"] = true,
					["floatingCombatTextFriendlyHealers"] = true,
					["floatingCombatTextPetMeleeDamage"] = true,
				},
				["frames"] = {
					["general"] = {
						["font"] = "伤害数字",
						["Y"] = 261,
						["fontSize"] = 14,
					},
					["power"] = {
						["font"] = "伤害数字",
						["fontSize"] = 10,
						["enabledFrame"] = false,
						["Y"] = -94,
					},
					["class"] = {
						["font"] = "伤害数字",
						["enabledFrame"] = false,
					},
					["outgoing"] = {
						["Width"] = 200,
						["font"] = "伤害数字",
						["fontSize"] = 12,
						["names"] = {
							["PLAYER"] = {
								["nameType"] = 2,
							},
						},
						["Y"] = -46,
						["X"] = 558,
						["Height"] = 417,
					},
					["critical"] = {
						["fontSize"] = 14,
						["X"] = 298,
						["Y"] = 16,
						["font"] = "伤害数字",
					},
					["procs"] = {
						["fontSize"] = 20,
						["font"] = "伤害数字",
						["enabledFrame"] = false,
					},
					["loot"] = {
						["font"] = "伤害数字",
						["fontSize"] = 16,
						["enabledFrame"] = false,
						["Y"] = -223,
					},
					["healing"] = {
						["fontSize"] = 14,
						["font"] = "伤害数字",
					},
					["damage"] = {
						["font"] = "伤害数字",
						["fontSize"] = 15,
					},
				},
			-- },
		},
	}
end

-- 載入設置
StaticPopupDialogs.SET_XCT = {
        text = "载入xCT布局",
        button1 = ACCEPT,
        button2 = CANCEL,
        OnAccept =  function() SetXCT() ReloadUI() end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = true,
        preferredIndex = 5,
}

SLASH_SETSK1 = "/setxct"
SlashCmdList["SETXCT"] = function()
        StaticPopup_Show("SET_XCT")
end




