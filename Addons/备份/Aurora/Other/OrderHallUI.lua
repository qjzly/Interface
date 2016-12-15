local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
--local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)


C.themes["Blizzard_OrderHallUI"] = function()
	local b = OrderHallCommandBar
	b:UnregisterAllEvents()
	b:HookScript("OnShow", b.Hide)
	b:Hide()
end