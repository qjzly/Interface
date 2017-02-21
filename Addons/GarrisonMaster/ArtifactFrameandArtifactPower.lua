-- ArtifactFrame and Artifact Power
local function openArtifactFrame()
	local currentWeapon = GetInventoryItemID("player", GetInventorySlotInfo("MainHandSlot"))
	if currentWeapon == nil then return end
	local name, link, quality = GetItemInfo(currentWeapon)
	if name and quality == LE_ITEM_QUALITY_ARTIFACT then
		SocketInventoryItem(16)
	end
end

local function ArtifactFrame_Toggle()
	if ArtifactFrame and ArtifactFrame:IsShown() then
		C_ArtifactUI.Clear()
	else
		openArtifactFrame()
	end
end

GarrisonLandingPageMinimapButton:RegisterForClicks("LeftButtonUp", "RightButtonUp")
GarrisonLandingPageMinimapButton:SetScript("OnClick", function(self, button)
	if button == "RightButton" then
		ArtifactFrame_Toggle()
	else
		GarrisonLandingPage_Toggle()
	end
end)

hooksecurefunc("MainMenuBar_ArtifactUpdateOverlayFrameText", function()
	if ArtifactWatchBar.OverlayFrame.Text:IsShown() then
		local _, xpForNextPoint = ArtifactWatchBar.StatusBar:GetMinMaxValues()
		if xpForNextPoint > 0 then
			local text = ArtifactWatchBar.OverlayFrame.Text:GetText()
			local _, _, _, _, totalXP, pointsSpent = C_ArtifactUI.GetEquippedArtifactInfo()
			for i = 0, pointsSpent - 1 do
				totalXP = totalXP + C_ArtifactUI.GetCostForPointAtRank(i)
			end
			text = text .. "    ( 全部神器能量：" .. totalXP.. " )"
			ArtifactWatchBar.OverlayFrame.Text:SetText(text)
		end
	end
end)