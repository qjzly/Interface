local ot = ObjectiveTrackerFrame
local BlocksFrame = ot.BlocksFrame

ObjectiveTrackerFrame:ClearAllPoints()
ObjectiveTrackerFrame:SetPoint("TOPLEFT", frame, "TOPLEFT", 20, 0)
ObjectiveTrackerFrame:SetHeight(GetScreenHeight() - 300)

ot.HeaderMenu.Title:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")

for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	local header = BlocksFrame[headerName]

	if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
		header.Text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
	end
end

hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
	if not block.headerStyled then
		if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
			block.HeaderText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE") --标题
		end
		block.headerStyled = true
	end
end)

    hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
            if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
                local line = block.currentLine

                local p1, a, p2, x, y = line:GetPoint()
                line:SetPoint(p1, a, p2, x, y - 4)
            end
        end)
		
    local function fixBlockHeight(block)
        if block.shouldFix then
            local height = block:GetHeight()

            if block.lines then
                for _, line in pairs(block.lines) do
                    if line:IsShown() then
                        height = height + 4
                    end
                end
            end

            block.shouldFix = false
            block:SetHeight(height + 5)
            block.shouldFix = true
        end
    end
    hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
            if block.lines then
                for _, line in pairs(block.lines) do
                    if not line.styled then
                        line.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
                        line.Text:SetSpacing(4)

                        if line.Dash then
                            line.Dash:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
                        end

                        line:SetHeight(line.Text:GetHeight())

                        line.styled = true
                    end
                end
            end

            if not block.styled then
                block.shouldFix = true
                hooksecurefunc(block, "SetHeight", fixBlockHeight)
                block.styled = true
            end
        end)
	
	
	
	
	
-- hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
	-- if block.lines then
		-- for _, line in pairs(block.lines) do
			-- if not line.styled then
				-- if GetLocale() == "zhCN" or GetLocale() == "zhTW" then
					-- line.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")  --描述
				-- end
				-- line.Text:SetSpacing(4)

				-- line:SetHeight(line.Text:GetHeight())

				-- line.styled = true
			-- end
		-- end
	-- end
-- end)

-- [[ Header background ]]
for _, headerName in next, {"QuestHeader", "AchievementHeader", "ScenarioHeader"} do
	local header = _G.ObjectiveTrackerFrame.BlocksFrame[headerName]
	--header.Background:Hide()

	local bg = header:CreateTexture(nil, "ARTWORK")
	bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
	bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
	bg:SetVertexColor(247/255 * 0.7, 225/255 * 0.7, 171/255 * 0.7)--r = 247/255, g = 225/255, b =171/255
	bg:SetPoint("BOTTOMLEFT", -30, -4)
	bg:SetSize(210, 30)
end
