----------------------------------------------------------------------------------------
--  OBJECTIVE TRACKER
----------------------------------------------------------------------------------------
  
--  进副本收起任务栏
-- local autocollapse = CreateFrame("Frame") 
-- autocollapse:RegisterEvent("ZONE_CHANGED_NEW_AREA") 
-- autocollapse:RegisterEvent("PLAYER_ENTERING_WORLD") 
-- autocollapse:SetScript("OnEvent", function(self) 
-- if IsInInstance() then 
-- ObjectiveTrackerFrame.userCollapsed = true 
-- ObjectiveTracker_Collapse() 
-- else 
-- ObjectiveTrackerFrame.userCollapsed = nil 
-- ObjectiveTracker_Expand() 
-- end 
-- end)









--  定义任务栏文字
	local f = CreateFrame("Frame");
	f:RegisterEvent("PLAYER_ENTERING_WORLD");
	f:SetScript("OnEvent", function()

		bonusobj= select(4,ObjectiveTrackerBlocksFrame:GetChildren() )
		bonusobj2=select(2,bonusobj:GetRegions())
		--bonusobj2:SetTextColor(1,1,1,1)
		bonusobj2:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
		bonusobj2:SetShadowColor(0,0,0,0)
		WatchFrameTitle= select(2,ObjectiveTrackerBlocksFrame.QuestHeader:GetRegions())
		--WatchFrameTitle:SetTextColor(1, 1, 1,1)
		WatchFrameTitle:SetShadowColor(0,0,0,0)
		WatchFrameTitle:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
		ACHFrameTitle= select(2,ObjectiveTrackerBlocksFrame.AchievementHeader:GetRegions())
		--ACHFrameTitle:SetTextColor(1, 1, 1,1)
		ACHFrameTitle:SetShadowColor(0,0,0,0)
		ACHFrameTitle:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
		ScenFrameTitle= select(2,ObjectiveTrackerBlocksFrame.ScenarioHeader:GetRegions())
		--ScenFrameTitle:SetTextColor(1, 1, 1,1)
		ScenFrameTitle:SetShadowColor(0,0,0,0)
		ScenFrameTitle:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")

		local function A4U_SetStringText(_,fontString, text, useFullHeight, colorStyle, useHighlight)
			local r, g, b = fontString:GetTextColor()
			r = floor(r * 255 ) 
			g = floor(g * 255 ) 
			b = floor(b * 255 ) 
			if r == 190 then
					--fontString:SetTextColor(0.301,0.301,0.301,1)
					fontString:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
					fontString:SetShadowColor(0,0,0,0)
			elseif r == 203 then
					--fontString:SetTextColor(1,1,1,1)
					fontString:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
					fontString:SetShadowColor(0,0,0,0)
			elseif r == 152 then
					--fontString:SetTextColor(0, 1, 0.5, 1)
					fontString:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
					fontString:SetShadowColor(0,0,0,0)
			end
		end

		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"SetStringText", A4U_SetStringText)


		local function miirgui_OnBlockHeaderEnter(self,block)
			if ( block.HeaderText ) then
				--block.HeaderText:SetTextColor(0.694, 0.694, 0.694,1);
				for objectiveKey, line in pairs(block.lines) do
					whitepls = line.Text:GetTextColor()
						whitepls = floor(whitepls * 255 ) 
							if ( line.Dash ) then
								--line.Dash:SetTextColor(1,1,1,1);
								r, g, b, a = line.Dash:GetTextColor()
							end
				end
			end
		end

		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"OnBlockHeaderEnter",miirgui_OnBlockHeaderEnter)

		local function miirgui_OnBlockHeaderLeave(self,block)
			if ( block.HeaderText ) then
						--block.HeaderText:SetTextColor(0.301,0.301,0.301,1);
			end
			for objectiveKey, line in pairs(block.lines) do
				local colorStyle = line.Text.colorStyle.reverse;
				if ( colorStyle ) then
					--line.Text:SetTextColor(1,1,1,1);
					if ( line.Dash ) then
						--line.Dash:SetTextColor(1,1,1,1);
					end
				else
				end
			end	
		end

		hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE,"OnBlockHeaderLeave",miirgui_OnBlockHeaderLeave)

		local function miirgui_ObjectiveTracker_Collapse()
			--ObjectiveTrackerFrame.HeaderMenu.Title:SetTextColor(1, 1, 1,1)
			ObjectiveTrackerFrame.HeaderMenu.Title:SetShadowColor(0,0,0,0)
			ObjectiveTrackerFrame.HeaderMenu.Title:SetFont("Fonts\\FRIZQT__.TTF",14, "OUTLINE")
		end

		hooksecurefunc("ObjectiveTracker_Collapse",miirgui_ObjectiveTracker_Collapse)

		

	end)
	
	
	

	
	
	
	

--  隐藏任务栏头背景
for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
	ObjectiveTrackerFrame.BlocksFrame[headerName].Background:Hide()
end









