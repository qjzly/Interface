local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
--local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local frame = LossOfControlFrame
	frame.RedLineTop:SetTexture(nil)
	frame.RedLineBottom:SetTexture(nil)
	frame.blackBg:SetTexture(nil)

	frame.Icon:SetTexCoord(.1, .9, .1, .9)
	F.CreateBG(frame.Icon)
end)
