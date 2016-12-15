
local _,L = ...
local rematch = Rematch
local panel -- will be dialog.preferencesPanel

-- primarily sets up preferences dialog text
function rematch:InitPreferences()
	panel = rematch.dialog.preferencesPanel
	panel.title:SetText(L["Leveling Pet Preferences"])
	panel.minHPLabel:SetText(L["Minimum Health"])
	panel.maxXPLabel:SetText(L["Maximum Level"])
	panel.allowMMLabel:SetText(format("%s %s & %s",L["Or any"],rematch:PetTypeAsText(6),rematch:PetTypeAsText(10)))
	panel.minHP.tooltipTitle = L["Minimum Health"]
	panel.minHP.tooltipBody = L["This is the minimum health preferred for a leveling pet."]
	panel.allowMM.tooltipTitle = panel.allowMMLabel:GetText():gsub("20:20","16:16") -- shrink icons from 20x20 to 16x16
	panel.allowMM.tooltipBody = L["Allow low-health Magic and Mechanical pets to ignore the Minimum Health, since their racials allow them to often survive a hit that would ordinarily kill them."]
	panel.maxXP.tooltipTitle = L["Maximum Level"]
	panel.maxXP.tooltipBody = L["This is the maximum level preferred for a leveling pet.\n\nLevels can be partial amounts. Level 23.45 is level 23 with 45% xp towards level 24."]
	panel.expected.label:SetText(L["Expected damage taken"])
	for i=1,10 do
		panel.expected.buttons[i]:SetScript("OnClick",rematch.PreferencesExpectedOnClick)
		panel.expected.buttons[i]:SetScript("OnEnter",rematch.PreferencesExpectedOnEnter)
		panel.expected.buttons[i]:SetScript("OnLeave",rematch.HideTooltip)
		panel.expected.buttons[i].icon:SetTexture("Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[i])
		panel.expected.buttons[i]:SetPoint("BOTTOMLEFT",(i-1)*19,0)
	end
end

function rematch:UpdatePreferences()
	local team = rematch:GetSideline()
	panel.minHP:SetText(team.minHP or "")
	panel.allowMM:SetChecked(team.allowMM and true)
	panel.maxXP:SetText(team.maxXP or "")
	local buttons = panel.expected.buttons
	for i=1,10 do
		buttons[i]:SetChecked(team.expectedDD==i)
		buttons[i].icon:SetDesaturated(team.expectedDD and team.expectedDD~=i)
	end
end

-- this is for the preferences button OnEnter in the team list and beside the leveling slot
-- displays a tooltip of the leveling preferences on a team
-- if teamName not passed, it will grab it from the parent of the button
function rematch:PreferencesOnEnter(teamName)
	local team = RematchSaved[teamName or self:GetParent().teamName]
	if team then
		local info = rematch.info
		wipe(info)
		tinsert(info,format("%s %s","\124TInterface\\AddOns\\Rematch\\textures\\preference:20:20:0:0:64:64:16:47:16:47\124t",L["Leveling Preferences"]))
		if team.minHP then -- minimum hp defined
			tinsert(info,format("%s: \124cffffd200%s",L["Minimum Health"],team.minHP))
			if team.expectedDD then -- expected damage taken
				tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[team.expectedDD][1]),team.minHP*1.5))
				tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[team.expectedDD][2]),team.minHP*2/3))
			end
			if team.allowMM then -- allow magic & mechanical
				tinsert(info,format("  %s %s & %s",L["Or any"],rematch:PetTypeAsText(6),rematch:PetTypeAsText(10)))
			end
--			if team[10] then -- it looks better if damage taken line is last (and is line even needed?)
--				tinsert(info,format("  %s: %s",L["Damage expected"],rematch:PetTypeAsText(team[10])))
--			end
		end
		if team.maxXP then -- maximum level
			tinsert(info,format("%s: \124cffffd200%s",L["Maximum Level"],team.maxXP))
		end
		rematch:ShowTableTooltip(self,info)
	end
end

-- this is either from the right-click "Leveling Preferences" (teamList rmf), the preferences button
-- display a dialog with the preferencesPanel
function rematch:EditPreferences(teamKey)
	teamKey = teamKey or self:GetParent().teamKey
	local team = RematchSaved[teamKey]
	if not team then return end
	rematch:SetSideline(teamKey,team)
	local dialog = rematch:ShowDialog("EditPreferences",rematch.dialog.preferencesPanel:GetHeight()+122,rematch:GetTeamTitle(teamKey,true),L["Save Preferences?"],rematch.PreferencesAccept)
	dialog.team:SetPoint("TOP",0,-24)
	rematch:FillPetFramesFromTeam(dialog.team.pets,team)
	dialog.team:Show()
	panel:SetPoint("TOP",0,-92)
	panel:Show()
	-- set initial values to controls
	panel.minHP:SetFocus(true)
	rematch:UpdatePreferences()
end

-- when accept is clicked for EditPreferences, preferences are lifted from pet frames and saved in the team
function rematch:PreferencesAccept()
	rematch:PushSideline()
	rematch:ProcessQueue() -- will do a delayed UpdateWindow to update teamlist icons if needed
end

-- the click to one of the 10 expected damage type buttons
function rematch:PreferencesExpectedOnClick()
	local team = rematch:GetSideline()
	local index = self:GetID()
	if team.expectedDD==index then
		team.expectedDD = nil
	else
		team.expectedDD = index
	end
	rematch:UpdatePreferences()
end

-- tooltip of expected type buttons calculates damage expected
function rematch:PreferencesExpectedOnEnter()
	local petType = self:GetID()
	local team = rematch:GetSideline()
	local minHP = team.minHP
	if not minHP then -- no min health defined, show a tooltip to describe what the buttons are for
		rematch:ShowTooltip(L["Expected damage taken"],L["The minimum health of pets can be adjusted by the type of damage they are expected to receive."])
	else
		local info = rematch.info
		wipe(info)
		tinsert(info,format("%s: %s",L["Damage expected"],rematch:PetTypeAsText(petType)))
		tinsert(info,format("%s: \124cffffd200%s",L["Minimum Health"],minHP))
		tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[petType][1]),minHP*1.5))
		tinsert(info,format(L["  For %s pets: \124cffffd200%d"],rematch:PetTypeAsText(rematch.hintsOffense[petType][2]),minHP*2/3))
		rematch:ShowTableTooltip(self,info)
	end
end

-- when text is typed into a preferences editbox (makes sure it's a number)
-- this is used because setting numeric="true" won't allow decimals (ie 23.5)
function rematch:PreferencesOnChar()
	rematch:HideTooltip()
	if not tonumber(self:GetText()) then
		local team = rematch:GetSideline()
		if team then
			self:SetText(team[self.var] or "")
		end
	end
end

-- when text changes in an editbox, show/hide clear button and update team var
-- the OnChar will make sure the editbox has a valid value (or none at all)
function rematch:PreferencesOnTextChanged()
	local value = tonumber(self:GetText())
	self.clear:SetShown(value and true)
	local team = rematch:GetSideline()
	if team then
		team[self.var] = value
	end
end

-- when a checkbutton in preferencesPanel clicked
function rematch:PreferencesCheckButtonOnClick()
	local team = rematch:GetSideline()
	team[self.var] = self:GetChecked() or nil
end

-- the "Save leveling pets as themselves" -- not technically a part of
-- the preferencesPanel, but it will only appear when panel is up (when
-- a team is being saved that's also loaded -- such as current pets)
function rematch:PreferencesAsThemselvesOnClick()
	local asThemselves = self:GetChecked()
	local team = rematch:GetSideline()
	for i=1,3 do
		local petID, ability1, ability2, ability3 = C_PetJournal.GetPetLoadOutInfo(i)
		if asThemselves then
			if petID then
				local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
				team[i] = {petID,ability1,ability2,ability3,speciesID}
			end
		elseif rematch:IsPetLeveling(petID) then
			team[i] = {0}
		end
	end
	rematch:FillPetFramesFromTeam(rematch.dialog.save.team.pets,team)
end

function rematch:PreferencesToggleOnClick()
	rematch.dialog.showPreferences = not Rematch.dialog.showPreferences
	rematch:UpdateSaveDialog()
end
