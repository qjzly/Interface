
local _,L = ...
local rematch = Rematch
local settings
local saved

function rematch:InitSaveAs()
	settings = RematchSettings
	saved = RematchSaved
	RegisterAddonMessagePrefix("Rematch")
	rematch:RegisterEvent("CHAT_MSG_ADDON")
	rematch:RegisterEvent("BN_CHAT_MSG_ADDON")

	-- init save dialog stuff
	local save = rematch.dialog.save
	save.inTab.OnClick = rematch.TabPickerOnClick
	save.inTab.text:SetPoint("LEFT",20,0)
	save.teamName.label:SetText(L["Team name:"])
	save.teamName:SetJustifyH("CENTER")
	save.forTarget.label:SetText(L["Save for target:"])
	save.inTab.label:SetText(L["Save in team tab:"])
	save.asThemselves.text:SetText(L["Save leveling pets as themselves"])
	save.asThemselves.text:SetTextColor(1,0.82,0)
	save.help.label:SetText(L["When \124TInterface\\RaidFrame\\ReadyCheck-Ready:16\124t is clicked or [Enter] hit:"])
	save.forTarget.OnClick = rematch.ForTargetOnClick
end

--[[ Save Dialog ]]

-- this shows the "initial" (also from cancelled replace) save dialog. the actual work is
-- done in UpdateSaveDialog which adjusts as changes are made
-- if context "deleteOriginal" is true, the team is being edited instead of "Save As..."
-- so the original team is deleted as the new one is saved.
function rematch:ShowSaveDialog()
	local title,prompt
	if rematch:GetSidelineContext("deleteOriginal") then -- this is from an edit dialog
		title = L["Edit Team"]
		prompt = L["Save changes?"]
	else
		title = L["Save As..."]
		prompt = L["Save this team?"]
	end
	local dialog = rematch:ShowDialog("SaveTeam",420,title,prompt,rematch.SaveDialogAcceptOnClick)
	dialog.save:SetPoint("BOTTOM",0,34)
	dialog.save:Show()
	dialog.save.asThemselves:SetChecked(false)
	local team = rematch:GetSideline()
	rematch:FillPetFramesFromTeam(dialog.save.team.pets,team)
	rematch:SelectTeamTab(team.tab or 1)
	local tab = team.tab or 1
	dialog.save.inTab.text:SetText(RematchSettings.TeamGroups[tab][1])
	dialog.save.inTab.icon:SetTexture(RematchSettings.TeamGroups[tab][2])
	dialog.save.teamName:SetText(rematch:GetSidelineTitle())
	dialog.save.asThemselves:SetChecked(false)
	rematch:UpdateSaveDialog()
end

-- updates save dialog details: team name, target, etc; and adjusts height for its content
function rematch:UpdateSaveDialog()
	local dialog = rematch.dialog
	local save = dialog.save
	local yoffset = 160
	local team,key = rematch:GetSideline()
	save.teamName:SetText(rematch:GetSidelineTitle())
	-- update color of team name (white-targeted, gold-untargeted)
	if type(key)=="number" then
		save.teamName:SetTextColor(1,1,1)
	else
		save.teamName:SetTextColor(1,0.82,0)
	end

	-- update target name (GetNameFromNpcID returns "No Target" if no target)
	local targetName = rematch:GetNameFromNpcID(key)
	if targetName:match("^NPC ") then -- if uncached npcID, come back in half a second with real name
		C_Timer.After(0.5,rematch.UpdateSaveDialog)
	end
	save.forTarget.text:SetText(targetName)

	-- if team is targeted, see if target is a notable npc
	local notable
	if type(key)=="number" then
		for index,info in pairs(rematch.notableNPCs) do
			if info[1]==key then
				notable = rematch.notableNPCs[index]
				break
			end
		end
	end
	if notable then -- notable is the notableNPCs entry if it was found
		local numPets = #notable-2
		yoffset = yoffset + (numPets*18)+18
		local maxWidth = 0
		for i=1,3 do
			save.targetPets.pets[i]:SetShown(i<=numPets)
			local speciesID = notable[i+2]
			if speciesID then
				local speciesName, speciesIcon, speciesType = C_PetJournal.GetPetInfoBySpeciesID(speciesID)
				save.targetPets.pets[i].icon:SetTexture(speciesIcon)
				save.targetPets.pets[i].name:SetText(speciesName)
				save.targetPets.pets[i].typeIcon:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[speciesType])
				maxWidth = max(maxWidth,save.targetPets.pets[i].name:GetStringWidth())
				save.targetPets.pets[i].petID = speciesID -- for floatingpetcard use
			end
		end
		maxWidth = min(250,maxWidth+35)
		save.targetPets:SetWidth(maxWidth)
		for i=1,3 do
			save.targetPets.pets[i]:SetWidth(maxWidth)
		end
		save.targetPets:Show()
	else -- not a notable npc, hide targetPets
		save.targetPets:Hide()
		yoffset = yoffset + 14
	end
	-- if user has team tabs, display save-specific tab picker (rmf handles the actual changing/update of this combo box)
	if #settings.TeamGroups>1 then
		save.inTab:SetPoint("TOP",0,-yoffset)
		save.inTab:Show()
		yoffset = yoffset + 32
	else
		save.inTab:Hide()
		yoffset = yoffset - 12
	end
	-- if any pets are a leveling pet, show "Save leveling pets as themselves" checkbox
	local showAsThemselves
	for i=1,3 do
		if team[i][1]==0 or rematch:IsPetLeveling(team[i][1]) then
			showAsThemselves = true
		end
	end
	if showAsThemselves then
		save.asThemselves:SetPoint("TOP",-88,-yoffset)
		save.asThemselves:Show()
		yoffset = yoffset + 30
	else
		save.asThemselves:Hide()
		yoffset = yoffset + 6
	end
	-- adjust height of save dialog to what was added above
	save:SetHeight(yoffset+80-12)
	dialog:SetHeight(yoffset+130-12) -- -16 is shortening help from 58 to 42
	-- finally fill in help window with what will happen if accept clicked
	save.help.text:SetText(rematch:GetSaveHelp())
end

-- when text in the team name editbox changes, change the name in the sideline team
function rematch:TeamNameOnTextChanged()
	local name = self:GetText()
	-- disable green check if there's no name
	rematch:SetAcceptEnabled(name and name:len()>0)
	if name==rematch:GetSidelineTitle() or not name or name:len()==0 then
		rematch.dialog.save.help.text:SetText(rematch:GetSaveHelp())
		return -- name of team isn't changing, ignore this
	end
	local team,key = rematch:GetSideline()
	if type(key)=="number" then -- key is an npcID, name can be anything (duplicate copies fine too)
		team.teamName = name
	else -- key is named, change key of sideline team to new name
		rematch:ChangeSidelineKey(name)
	end
	rematch:UpdateSaveDialog()
end

-- target combo box click
function rematch:ForTargetOnClick()
	if rematch:IsMenuOpen("forTarget") then
		rematch:HideMenu()
		return
	end
	local menu = rematch.menu.menus["forTarget"]
	wipe(menu) -- rebuilding menu
	local info = rematch.info
	wipe(info) -- scratch table to make sure an npcID isn't added twice
	-- adds the passed npcID to the menu
	local function addToMenu(npcID)
		if npcID and type(npcID)=="number" and not info[npcID] then
			info[npcID] = true
			tinsert(menu,{text=rematch:GetNameFromNpcID(npcID), npcID=npcID, func=rematch.PickNotableNpcID})
		end
	end
	-- add any relevant npcIDs to the menu
	tinsert(menu,{text=L["No Target"], func=rematch.PickNotableNpcID}) -- manually adding the "no target" which wouldn't add with addMenu
	addToMenu(rematch.targetNpcID) -- add the targeted npcID next
	addToMenu(select(2,rematch:GetSideline())) -- add the current sideline npcID
	addToMenu(rematch:GetSidelineContext("originalKey")) -- add the original npcID from initial save dialog
	addToMenu(settings.loadedTeam) -- add the npcID of the currently loaded team
	tinsert(menu,{text=L["Noteworthy Targets"],subMenu="notableGroups"})
	rematch:ShowMenu("forTarget","TOPRIGHT",self,"BOTTOMRIGHT",-4,4,true)
end

-- when an npcID (or nil!) is chosen from the forTarget combo box
function rematch:PickNotableNpcID()
	local npcID = self.npcID
	local team,key = rematch:GetSideline()
	local teamName = rematch:GetSidelineTitle()
	if type(key)=="string" and not npcID then
		return -- user chose No Target and team already had no target, no change needed
	elseif type(key)=="number" and key==npcID then
		return -- user chose the already-sidelined npcID, no change needed
	end
	-- if we're choosing no target and original key had no target (is a string), use that for new team name
	if not npcID and type(rematch:GetSidelineContext("originalKey"))=="string" then
		teamName = rematch:GetSidelineContext("originalKey")
	end
	-- at this point the key has changed--it's either an npcID or the teamName
	rematch:ChangeSidelineKey(npcID or teamName)
	team = rematch:GetSideline() -- need to get new sideline team
	if npcID then
		team.teamName = rematch:GetNameFromNpcID(npcID)
	else
		team.teamName = nil -- named team without a target, drop teamName
	end
	rematch:UpdateSaveDialog()
end

-- returns the text to appear in "When (check) is clicked of [Enter] hit:" window
function rematch:GetSaveHelp()
	local save = rematch.dialog.save
	local teamName = save.teamName:GetText()
	if not teamName or teamName:len()==0 then
		return L["The team must be named before it can be saved."]
	end
	local team,key = rematch:GetSideline()
	local loadedKey = settings.loadedTeam
	local loadedTeam = saved[loadedKey]
	rematch:SetSidelineContext("confirmReplace",nil) -- this will be set true if a confirm should happen regardless of pets changing
	
	local function returnConfirmHelp()
		rematch:SetSidelineContext("confirmReplace",true)
		if type(key)=="number" then
			return format(L["Confirm you want to overwrite the team already saved for %s."],rematch:GetNameFromNpcID(key))
		else
			return format(L["Confirm you want to overwrite the team already named \124cffffd200%s\124r."],teamName)
		end
	end

	if rematch:GetSidelineContext("deleteOriginal") then -- if we're editing a team, slightly different behavior
		if key~=rematch:GetSidelineContext("originalKey") and saved[key] then -- a team already exists we're changing key to
			return returnConfirmHelp()
		else -- not replacing another team in this edit
			return format(L["Save changes to this team."])
		end
	elseif loadedKey==key then -- if key is the same for loaded and sidelined team, we're saving over the existing team
		return format(L["Save changes to the loaded team."])
	else -- key is changing
		if not saved[key] then -- this is a new team
			if type(key)=="number" then
				return format(L["Create a new team for %s."],rematch:GetNameFromNpcID(key))
			else
				return format(L["Create a new team named \124cffffd200%s\124r."],teamName)
			end
		else -- this is overwriting an existing team
			return returnConfirmHelp()
		end
	end
	return ""
end

-- when accept (green check) clicked on main save dialog
function rematch:SaveDialogAcceptOnClick()
	local team,teamKey = rematch:GetSideline()
	local askReplace = rematch:GetSidelineContext("confirmReplace")
	-- for teams where confirmReplace not set, check if pets have changed (if team already exists)
	if saved[teamKey] then
		for i=1,3 do
			if saved[teamKey][i][1]~=team[i][1] then
				askReplace = true
			end
		end
	end
	if not askReplace then -- okay to push as is, save it!
		rematch:PushSideline(true)
	else -- ask to confirm whether to save this team
		rematch:ShowReplaceDialog(rematch.CancelReplaceSaveDialog)
	end
end

-- when replace dialog is summoned from main save dialog, a cancel
-- of the replace dialog will run this, bringing up the save dialog again
function rematch:CancelReplaceSaveDialog()
	local asThemselves = rematch.dialog.save.asThemselves
	local checked = asThemselves:GetChecked()
	rematch:ShowSaveDialog()
	if checked then
		asThemselves:Click() -- if asThemselves as checked before replace dialog, re-check it (rematch:PreferencesAsThemselvesOnClick() handles this click)
	end
end

--[[ Replace Dialog ]]

-- shows the replace dialog; accepting will push the sideline team
-- cancel will run the passed cancelFunc (typically to return the previous dialog)
function rematch:ShowReplaceDialog(cancelFunc)
	local team,teamKey = rematch:GetSideline()
	local dialog = rematch:ShowDialog("ReplaceTeam",220,rematch:GetTeamTitle(teamKey,true),L["Overwrite this team?"],function() rematch:PushSideline(true) end)
	if not dialog.replace then
		dialog.replace = CreateFrame("Frame",nil,dialog,"RematchTeamTemplate")
		rematch:RegisterDialogWidget("replace")
		dialog.replace.arrow = dialog.replace:CreateTexture(nil,"ARTWORK")
		dialog.replace.arrow:SetSize(32,32)
		dialog.replace.arrow:SetPoint("TOP",dialog.replace,"BOTTOM",0,0)
		dialog.replace.arrow:SetTexture("Interface\\Buttons\\UI-MicroStream-Green")
	end
	-- old team is saved[teamKey] and filled into dialog.replace
	dialog.replace:SetPoint("TOP",0,-24)
	rematch:FillPetFramesFromTeam(dialog.replace.pets,saved[teamKey])
	dialog.replace:Show()

	-- new team is sideline team and filled into dialog.team
	dialog.team:SetPoint("TOP",dialog.replace,"BOTTOM",0,-32)
	rematch:FillPetFramesFromTeam(dialog.team.pets,team)
	dialog.team:Show()
	dialog.runOnCancel = cancelFunc
end

--[[ Sharing teams: Export/Import & Send/Receive ]]

-- common functions between sharing methods

-- Name of team:npcID:S1:A1:A2:A3:S2:A1:A2:A3:S3:A1:A2:A3:
function rematch:ConvertTeamToString()
	local team,teamKey = rematch:GetSideline()
	local teamString
	if type(teamKey)=="number" then
		teamString = format("%s:%s:",team.teamName,teamKey)
	else
		teamString = format("%s:0:",teamKey)
	end
	for i=1,3 do
		local petID = team[i][1]
		if not petID then
			petID = 1 -- empty slot is "speciesID" 1
		elseif type(petID)=="number" then
			petID = petID -- already a speciesID, or 0 for leveling slot
		elseif team[i][5] then
			petID = team[i][5] -- a genuine petID should have speciesID in [5]
		else
			petID = 1
		end
		teamString = teamString..format("%d:%d:%d:%d:",petID,team[i][2],team[i][3],team[i][4])
	end
	return teamString
end

-- sidelines a team defined in teamString, returning the key if it was valid
function rematch:ConvertStringToTeam(teamString)
	local t={{},{},{}}
	local teamName
	teamName,t[4],t[1][1],t[1][2],t[1][3],t[1][4],t[2][1],t[2][2],t[2][3],t[2][4],t[3][1],t[3][2],t[3][3],t[3][4] = teamString:match("(.+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):(%d+):")
	if teamName then
		for i=1,3 do
			-- convert all string matches to numbers
			for j=1,4 do
				t[i][j]=tonumber(t[i][j])
			end
			-- copy speciesID of actual species to [5]
			if t[i][1]>1 then
				t[i][5] = t[i][1]
			end
			-- convert petID's of 1 to 0x0000etc (emptyPetID)
			if t[i][1]==1 then
				t[i][1] = rematch.emptyPetID
			end
		end
		rematch:ValidateTeam(t) -- fill out species IDs with petIDs
		local key = teamName
		if t[4]~="0" then
			key = tonumber(t[4])
			t.teamName = teamName
		end
		t.tab = RematchSettings.SelectedTab
		rematch:SetSideline(key,t)
		return key
	end
end

-- For import and receive windows, this creates a little frame with a warning
-- and two radio options: (*) Create a new copy. ( ) Overwrite existing team.
-- Sideline context "overwrite" is true when second radio button selected.
-- This should NOT be used as a dialog widget since the receive window needs
-- to be visible when Rematch is not.
-- returns true if the confirmation window is displayed
function rematch:ConfirmKeyExists(key,anchorPoint,relativeTo,relativePoint,xoff,yoff,multiTeam)
	if not multiTeam and (not key or not saved[key]) then
		if rematch.overwriteConfirm then
			rematch.overwriteConfirm:Hide()
		end
		return false
	end
	-- if we're at this point a team exists with the key, or this is a multi-team
	-- display radio buttons to ask what to do with it
	local confirm = rematch.overwriteConfirm
	if not confirm then -- create overwriteConfirm if it doesn't exist
		rematch.overwriteConfirm = CreateFrame("Frame")
		confirm = rematch.overwriteConfirm
		confirm:SetSize(200,66)
		confirm.text = confirm:CreateFontString(nil,"ARTWORK","GameFontHighlight")
		confirm.text:SetPoint("TOP",16,-4)
		confirm.icon = confirm:CreateTexture(nil,"ARTWORK")
		confirm.icon:SetSize(22,22)
		confirm.icon:SetPoint("RIGHT",confirm.text,"LEFT",-6,0)
		confirm.icon:SetTexture("Interface\\DialogFrame\\UI-Dialog-Icon-AlertNew")
		confirm.copy = CreateFrame("CheckButton",nil,confirm,"UIRadioButtonTemplate")
		confirm.copy.text:SetFontObject("GameFontHighlight")
		confirm.copy:SetPoint("TOPLEFT",12,-26)
		confirm.copy:SetHitRectInsets(0,-160,0,0)
		confirm.copy:SetChecked(true)
		confirm.copy:SetScript("OnClick",function(self) rematch:SetSidelineContext("overwrite",nil) rematch:UpdateConfirmRadios(self) end)
		confirm.overwrite = CreateFrame("CheckButton",nil,confirm,"UIRadioButtonTemplate")
		confirm.overwrite.text:SetFontObject("GameFontHighlight")
		confirm.overwrite:SetPoint("TOPLEFT",confirm.copy,"BOTTOMLEFT",0,-2)
		confirm.overwrite:SetHitRectInsets(0,-160,0,0)
		confirm.overwrite:SetScript("OnClick",function(self) rematch:SetSidelineContext("overwrite",true) rematch:UpdateConfirmRadios(self) end)
		confirm:SetScript("OnHide",function(self) self:Hide() end) -- really hide this frame if any parent hides
	end
	confirm.copy.text:SetText(plural and L["Save as new teams."] or L["Save as a new team."])
	confirm.overwrite.text:SetText(plural and L["Overwrite existing teams."] or L["Overwrite existing team."])
	if multiTeam then
		confirm.text:SetText(L["If a duplicate is found:"])
	elseif type(key)=="number" then
		confirm.text:SetText(L["This target already has a team."])
	else
		confirm.text:SetText(L["A team already has this name."])
	end
	confirm:ClearAllPoints()
	confirm:SetPoint(anchorPoint,relativeTo,relativePoint,xoff,yoff)
	confirm:SetParent(relativeTo)
	rematch:UpdateConfirmRadios()
	confirm:Show()
	return true
end

-- updates the two radio buttons to make sure only one is checked
-- radio is the passed button itself
function rematch:UpdateConfirmRadios(radio)
	local confirm = rematch.overwriteConfirm
	if not radio then -- if radio isn't passed, it's the radio that's presently checked
		radio = confirm.copy:GetChecked() and confirm.copy or confirm.overwrite
	end
	if radio==confirm.copy then
		confirm.copy:SetChecked(true)
		confirm.overwrite:SetChecked(false)
		confirm.copy.text:SetTextColor(1,.82,0)
		confirm.overwrite.text:SetTextColor(0.82,0.82,0.82)
	else
		confirm.copy:SetChecked(false)
		confirm.overwrite:SetChecked(true)
		confirm.copy.text:SetTextColor(0.82,0.82,0.82)
		confirm.overwrite.text:SetTextColor(1,.82,0)
	end
end

--[[ Export ]]

-- called from rmf
function rematch:ShowExportDialog(key)
	local team,teamKey = rematch:SetSideline(key)
	local dialog = rematch:ShowDialog("ExportTeam",244,rematch:GetSidelineTitle(true),"",true)
	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,team)
	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Press CTRL+C to copy this team to the clipboard."])
	dialog.text:Show()
	dialog.multiLine:SetPoint("TOP",dialog.text,"BOTTOM",0,-8)
	dialog.multiLine:Show()
	dialog.multiLine.editBox:SetText(rematch:ConvertTeamToString())
	dialog.multiLine.editBox:HighlightText(0)
	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.ExportOnTextChanged)
end
-- any changes to editbox reverts editbox to sidelined team as a string
function rematch:ExportOnTextChanged()
	self:SetText(rematch:ConvertTeamToString())
	self:HighlightText(0)
end

-- this is called from rmf to export a whole tab of teams
function rematch:ShowTabExportDialog(tab)
	local tabName = settings.TeamGroups[tab][1]
	local dialog = rematch:ShowDialog("MassExport",300,format(L["Tab: %s"],tabName),"",true)
	dialog.text:SetSize(200,40)
	dialog.text:SetPoint("TOP",0,-20)
	dialog.text:SetText(L["Press CTRL+C to copy this tab's teams to the clipboard."])
	dialog.text:Show()

	if not dialog.massExportBlurb then
		dialog.massExportBlurb = dialog:CreateFontString(nil,"ARTWORK","GameFontNormalSmall")
		rematch:RegisterDialogWidget("massExportBlurb")
		local blurb = dialog.massExportBlurb
		blurb:SetSize(220,60)
		blurb:SetText(L["Note: This does not include preferences, notes or anything about this tab. This text just stores the names of each team, their targets, their pets and abilities only."])
		blurb:SetJustifyH("LEFT")
		blurb:SetJustifyV("CENTER")
	end
	dialog.massExportBlurb:SetPoint("TOP",dialog.text,"BOTTOM",0,4)
	dialog.massExportBlurb:Show()
	dialog.multiLine:SetPoint("BOTTOM",dialog,"BOTTOM",0,48)
	dialog.multiLine:SetSize(220,128)
	dialog.multiLine.editBox:SetSize(196,128)
	dialog.multiLine:Show()
	dialog.multiLine.editBox:SetText(rematch:ConvertTabToString(tab))
	dialog.multiLine.editBox:HighlightText(0)
	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.TabExportOnTextChanged)
end
-- any changes to editbox reverts editbox to sidelined team as a string
function rematch:TabExportOnTextChanged()
	self:SetText(rematch:ConvertTabToString(settings.SelectedTab))
	self:HighlightText(0)
end

-- this concatenates a whole tab of teams to an export string (delimited by a \n)
function rematch:ConvertTabToString(tab)
	local strings = {}
	for _,key in ipairs(rematch.drawer.teams.teamList) do
		local team,teamKey = rematch:SetSideline(key)
		if team then
			tinsert(strings,rematch:ConvertTeamToString())
		end
	end
	return table.concat(strings,"\n").."\n"
end

--[[ Import ]]

function rematch:ShowImportDialog()
	local dialog = rematch.dialog
	if dialog.name == "ImportTeam" then
		rematch:HideDialogs()
		return
	end
	rematch:ShowDialog("ImportTeam",244,L["Import Team"],"",rematch.ImportAcceptOnClick)
	dialog.team:SetPoint("TOP",0,-24)
	rematch:WipePetFrames(dialog.team.pets)
	dialog.team:Show()
	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:Show()
	dialog.multiLine:SetPoint("BOTTOM",0,48)
	dialog.multiLine:Show()
	dialog.multiLine.editBox:SetScript("OnTextChanged",rematch.ImportOnTextChanged)
	if #settings.TeamGroups>1 then
		dialog.multiLine:SetPoint("BOTTOM",0,48+42)
		dialog.tabPicker:SetPoint("TOP",dialog.multiLine,"BOTTOM",0,-20)
		dialog.tabPicker:Show()
		dialog:SetHeight(244+42) -- 42 extra height of tabPicker combo box
	end
	rematch:SetAcceptEnabled(false) -- initially accept button disabled
end

function rematch:ImportOnTextChanged()
	local dialog = rematch.dialog
	local teamString = self:GetText()
	local key = rematch:ConvertStringToTeam(teamString)
	local multiTeam
	rematch:SetAcceptEnabled(key and true)
	local confirm
	if teamString:match("\n.") then
		multiTeam = true
		confirm = rematch:ConfirmKeyExists(key,"TOP",dialog,"TOP",0,-24,true)
		dialog.team:Hide()
		dialog.multiLine:SetHeight(120)
	else
		confirm = rematch:ConfirmKeyExists(key,"TOP",dialog.team,"BOTTOM",0,-8,multiTeam)
		dialog.team:Show()
		dialog.multiLine:SetHeight(55)
	end
	local tabPickerOffset = #settings.TeamGroups>1 and 42 or 0
	dialog:SetHeight((confirm and 268 or 244)+tabPickerOffset)
	dialog.text:SetText(confirm and "" or L["Press CTRL+V to paste a team from the clipboard."])
	if self:GetText():len()>0 then
		dialog.teamString = self:GetText()
	end
	if key then
		local team,teamKey = rematch:GetSideline()
		rematch:FillPetFramesFromTeam(dialog.team.pets,team)
		rematch:SetSidelineContext("multiTeamImport",multiTeam)
		if multiTeam then
			dialog.header.text:SetText(L["Importing Multiple Teams..."])
			dialog.prompt:SetText(L["Save these teams?"])
		else
			dialog.header.text:SetText(rematch:GetSidelineTitle(true))
			dialog.prompt:SetText(L["Save this team?"])
		end
	else
		dialog.header.text:SetText(L["Import As..."])
		rematch:WipePetFrames(dialog.team.pets)
		dialog.prompt:SetText("")
	end
end

-- when accept (green check) is clicked on the import dialog
function rematch:ImportAcceptOnClick()
	-- overwriteCopy is true if user wants to create a copy of the team(s)
	local overwriteCopy = rematch.overwriteConfirm and rematch.overwriteConfirm.copy:GetChecked()

	-- if this isn't a multi-team import, import the single team
	if not rematch:GetSidelineContext("multiTeamImport") then
		if overwriteCopy then
			rematch:MakeSidelineUnique()
		end
		local team,teamKey = rematch:GetSideline()
		if saved[teamKey] then
			rematch:ShowReplaceDialog(rematch.CancelReplaceImportDialog)
		else
			rematch:PushSideline(true)
		end
	else -- this is a multi-team import
		local teams = {strsplit("\n",rematch.dialog.teamString)}
		local count = 0
		for k,v in ipairs(teams) do
			local key = rematch:ConvertStringToTeam(v)
			if key then
				if overwriteCopy then
					rematch:MakeSidelineUnique()
				end
				rematch:PushSideline()
				count = count + 1
			end
		end
		rematch:print(count,"teams imported successfully.")
	end
end

-- when the replace dialog is cancelled while overwriting an existing team
-- from an import; restores the import dialog from where it left off
function rematch:CancelReplaceImportDialog()
	rematch:ShowImportDialog()
	rematch.dialog.multiLine.editBox:SetText(rematch.dialog.teamString)
end

--[[ Send ]]

-- called from rmf where it should've set sideline; warning passed to show a
-- warning message, such as "They're busy. Try again later."
function rematch:ShowSendDialog(warning)
	local dialog = rematch:ShowDialog("SendTeamStart",200,rematch:GetSidelineTitle(true),L["Send this team?"],rematch.SendTeam)
	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	dialog.text:SetSize(180,40)
	dialog.text:SetPoint("TOP",dialog.team,"BOTTOM",0,-8)
	dialog.text:SetText(L["Who would you like to send this team to?"])
	dialog.text:Show()
	dialog.editBox:SetPoint("TOP",dialog.text,"BOTTOM",0,-4)
	dialog.editBox:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,(rematch:GetSideline()))
	rematch:SetAcceptEnabled(false)
	if warning then
		dialog:SetHeight(220)
		dialog.warning:SetPoint("TOP",dialog.editBox,"BOTTOM",0,-4)
		dialog.warning.text:SetText(warning)
		dialog.warning:Show()
		dialog.editBox:SetText(rematch:GetSidelineContext("sendTo") or "")
	end
	dialog.editBox:SetScript("OnTextChanged",rematch.SendOnTextChanged)
end

-- when the "Who would you like to send this team to?" editbox changes
function rematch:SendOnTextChanged()
	local sendTo = self:GetText()
	rematch:SetSidelineContext("sendTo",sendTo)
	rematch:SetAcceptEnabled(sendTo:len()>0)
end

-- sends the sidelined team to sendTo context
function rematch:SendTeam()
	local dialog = rematch:ShowSendPendingDialog()
	dialog.runOnCancel = rematch.StopSend
	local teamString = rematch:ConvertTeamToString(dialog.teamName)
	local sendTo = rematch:GetSidelineContext("sendTo")
	if teamString and sendTo then
		rematch:StartTimer("SendTimeout",5,rematch.SendTimeout)
		-- look for bnet presence first (using toonID since presenceID not working for some reason)
		-- convert sendTo to a battletag search (there must be a better way!)
		local tagSearch = format("^%s#%%d+",rematch:DesensitizedText(sendTo))
		for i=1,BNGetNumFriends() do
		  local _,_,tag,_,_,id,client,online = BNGetFriendInfo(i)
		  if client==BNET_CLIENT_WOW and online and tag:match(tagSearch) then
		    BNSendGameData(id,"Rematch",teamString)
				return -- our work is done, team sent via bnet
		  end
		end
		-- if we reach here, a bnet recipient wasn't found
		rematch:RegisterEvent("CHAT_MSG_SYSTEM")
		-- otherwise send by normal SendAddonMessage
		rematch:SendMessage(teamString,rematch:GetSidelineContext("sendTo"))
	end
end

-- shows either a "Sending..." or "Team received!" (if success true) dialog
function rematch:ShowSendPendingDialog(success)
	local dialog = rematch.dialog
	rematch:ShowDialog("SendTeamPending",128,rematch:GetSidelineTitle(true),success and L["Team received!"] or L["Sending..."],success and true)
	dialog.team:SetPoint("TOP",0,-24)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,(rematch:GetSideline()))
	if not success then
		dialog.accept:Hide()
	end
	return dialog
end

function rematch:StopSend()
	rematch:UnregisterEvent("CHAT_MSG_SYSTEM")
	rematch:StopTimer("SendTimeout")
end

-- after 5 seconds with no response
function rematch:SendTimeout()
	rematch:SendFailed(L["No response. Lag or no Rematch?"])
end

-- send failed for passed reason, return to the send dialog with the reason
function rematch:SendFailed(reason)
	rematch:StopSend()
	rematch:ShowSendDialog(reason)
end

-- sends message to sendTo via regular SendAddonMessage (bnet support NYI)
function rematch:SendMessage(message,sendTo)
	if type(sendTo)=="number" then -- this was a bnet-sent team, reply via same channel
		BNSendGameData(sendTo,"Rematch",message)
	else -- this was a regularly sent team, reply via same channel
		SendAddonMessage("Rematch",message,"WHISPER",sendTo)
	end
end

-- captures "No player named 'sendTo' is currently playing." system message
function rematch.events.CHAT_MSG_SYSTEM(message)
	if message==format(ERR_CHAT_PLAYER_NOT_FOUND_S,rematch:GetSidelineContext("sendTo")) then
		rematch:SendFailed(L["They do not appear to be online."])
	end
end

-- handles incoming messages via the regular SendAddonMessage
function rematch.events.CHAT_MSG_ADDON(prefix,message,_,sender)
	if prefix=="Rematch" then
		rematch:HandleReceivedMessage(message,sender)
	end
end

-- handles incoming messages via battle.net (sender will be a numeric toonID)
function rematch.events.BN_CHAT_MSG_ADDON(prefix,message,_,sender)
	if prefix=="Rematch" then
		rematch:HandleReceivedMessage(message,sender)
	end
end

-- actually processes the message
function rematch:HandleReceivedMessage(message,sender)
	if message=="ok" then
		rematch:StopSend()
		rematch:ShowSendPendingDialog(true)
	elseif message=="busy" then
		rematch:SendFailed(L["They're busy. Try again later."])
	elseif message=="combat" then
		rematch:SendFailed(L["They're in combat. Try again later."])
	elseif message=="block" then
		rematch:SendFailed(L["They have team sharing disabled."])
	else -- any other messages are unsolicited, likely an incoming team

		local dialog = rematch.dialog
		-- likely this is a team received, first check if user ready to receive a team
		if settings.DisableShare then
			rematch:SendMessage("block",sender)
		elseif InCombatLockdown() then
			rematch:SendMessage("combat",sender)
		elseif dialog:IsVisible() then
			rematch:SendMessage("busy",sender)
		else
			-- user appears ready to receive; now check if it's an actual team
			local key = rematch:ConvertStringToTeam(message)
			if key then
				-- it's an actual team, send back an ok
				rematch:SendMessage("ok",sender)
				if not rematch:IsVisible() then
					rematch:Toggle() -- show rematch if it's not already on screen
				end
				dialog.teamString = message
				if type(sender)=="number" then -- for bnet-sent teams, sender is a numeric toonID
					rematch:SetSidelineContext("sender",(select(2,BNGetToonInfo(sender)))) -- set to name of toonID
				else -- for regularly sent teams, sender is the name
					rematch:SetSidelineContext("sender",sender)
				end
				rematch:ShowReceiveDialog()
			end
		end

	end
end

-- shows the receive dialog for a sidelined team
function rematch:ShowReceiveDialog()
	local team,key = rematch:GetSideline()
	local dialog = rematch:ShowDialog("ReceiveTeam",170,L["Incoming Rematch Team"],L["Save this team?"],rematch.ReceiveAcceptOnClick)
	dialog.text:SetSize(220,42)
	dialog.text:SetPoint("TOP",0,-18)
	local form
	if type(key)=="number" then
		form = L["\124cffffd200%s\124r has sent you a team for %s."]
	else
		form = L["\124cffffd200%s\124r has sent you a team named \124cffffd200%s\124r."]
	end
	dialog.text:SetText(format(form,rematch:GetSidelineContext("sender"),rematch:GetSidelineTitle()))
	dialog.text:Show()
	dialog.team:SetPoint("TOP",dialog.text,"BOTTOM",0,-4)
	dialog.team:Show()
	rematch:FillPetFramesFromTeam(dialog.team.pets,team)
	local dialogHeight = 170
	local tabPickerOffset = 0
	if #settings.TeamGroups>1 then
		dialog.tabPicker:SetPoint("BOTTOM",dialog,"BOTTOM",0,40)		
		dialog.tabPicker:Show()
		dialogHeight = dialogHeight + 42
	end
	-- if team already exists, show confirm frame and make dialog taller to fit
	if rematch:ConfirmKeyExists(key,"TOP",dialog.team,"BOTTOM",0,-8) then
		dialogHeight = dialogHeight + 70
	end
	dialog:SetHeight(dialogHeight)

end

-- when accept (green check) is clicked on the receive dialog
function rematch:ReceiveAcceptOnClick()
	if rematch.overwriteConfirm and rematch.overwriteConfirm.copy:GetChecked() then
		rematch:MakeSidelineUnique()
	end
	local team,teamKey = rematch:GetSideline()
	if saved[teamKey] then
		rematch:ShowReplaceDialog(rematch.ShowReceiveDialog)
	else
		rematch:PushSideline(true)
	end
end
