local F, C = unpack(select(2, ...))

if not C.automation.hideRaidNames then return end

local HRN = CreateFrame("Frame")

HRN:RegisterEvent("PLAYER_ENTERING_WORLD")

HRN:SetScript("OnEvent", function(self, event)
	if event=="PLAYER_ENTERING_WORLD" then
		local _,instanceType = IsInInstance()
		if instanceType=="raid" then
			SetCVar("UnitNameFriendlyPlayerName",0);
		else
			SetCVar("UnitNameFriendlyPlayerName",1);
		end
	end
end)