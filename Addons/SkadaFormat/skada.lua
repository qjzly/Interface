local addon, ns = ...

if not IsAddOnLoaded("Skada") then return end

-- 預設設置
local SetSK = function()
	if(SkadaDB) then table.wipe(SkadaDB) end
	SkadaDB = {
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
					}, 
				},
			},
		},
	}
end

-- 載入設置
StaticPopupDialogs.SET_SK = {
        text = "载入Skada布局",
        button1 = ACCEPT,
        button2 = CANCEL,
        OnAccept =  function() SetSK() ReloadUI() end,
        timeout = 0,
        whileDead = 1,
        hideOnEscape = true,
        preferredIndex = 5,
}

SLASH_SETSK1 = "/setsk"
SlashCmdList["SETSK"] = function()
        StaticPopup_Show("SET_SK")
end
