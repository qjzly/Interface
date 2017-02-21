local F, C, L = unpack(select(2, ...))

if not C.appearance.ncShadow then return end

local f = CreateFrame("Frame", "ShadowBackground")
f:SetPoint("TOPLEFT")
f:SetPoint("BOTTOMRIGHT")
f:SetFrameLevel(0)
f:SetFrameStrata("BACKGROUND")
f.tex = f:CreateTexture()
f.tex:SetTexture([[Interface\Addons\FreeUI\media\shadow.tga]])
f.tex:SetAllPoints(f)
function f:SetShadowLevel(n)
	n = tonumber(n)
	if not n then error("The level must be a number between 100 and 0.") return end
	ncShadowLevel = 50
	f:SetAlpha(n/100)
end
f:SetScript("OnEvent", function()
	--f:SetShadowLevel((ncShadowLevel or 70))
	f:SetShadowLevel((50))
end)
f:RegisterEvent("PLAYER_ENTERING_WORLD")
