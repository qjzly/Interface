
local _,L = ...
local rematch = Rematch
local settings

-- append this to new options to show a yellow ! icon beside the option
local newOption = " \124TInterface\\OptionsFrame\\UI-OptionsFrame-NewFeatureIcon:12\124t"

-- options:
-- [1] = type: header, check or button
-- [2] = variable name: settings[variable_name], also name of optionsFunc to run when clicked
-- [3] = text to display on option or header
-- [4] = "tooltip" to display onenter of option
-- [5] = setting that this option is dependant on (indented and greyed if dependency unchecked)
-- [6] = true if its optionsFunc should run on startup
rematch.optionsList = {
	{ "header", nil, L["Targeting Options"] },
	{ "check", "AutoShow", L["Auto show on target"], L["When targeting something with a saved team not already loaded, show the Rematch window."] },
	{ "check", "AutoShowStay", L["Stay after loading"], L["Keep the Rematch window on screen after loading a team when the window was shown via 'Auto show on target'."], "AutoShow" },
	{ "check", "AutoLoad", L["Auto load"], L["When your mouseover or target has a saved team not already loaded, load the team immediately."] },
	{ "check", "AutoLoadShow", L["Show after loading"], L["When a team is automatically loaded, show the Rematch window if it's not already shown."], "AutoLoad" },
	{ "check", "AutoLoadTargetOnly", L["On target only"], L["Auto load will only happen when you target, not mouseover. \124cffff2222WARNING!\124cffffd200 This option is not recommended! It is often too late to load pets when a battle starts if you target with right-click!"], "AutoLoad" },
--	{ "check", "AutoAlways", L["Discard loaded team on changes"], L["\124cffff2222WARNING!\124cffffd200 This option is not recommended!\124r\n\nThis option changes the normal behavior of Rematch and its interaction with teams and targets.\n\nSpecifically:\n- Anytime you change pets or abilities, it will 'unload' the team.\n- It will forget what's loaded in the past and always offer to load/show teams.\n- It will be very difficult to save changes to teams.\n-The Reload button will be disabled.\n\n\124cffff2222This option will be going away very soon!"], nil, true },
	{ "header", nil, L["Window Options"] },
	{ "check", "LargeWindow", L["Larger window"], L["Make the Rematch window larger for easier viewing."] },
	{ "check", "LargeFont", L["Larger text"], L["Make the text in the scrollable lists (pets, teams and options) and menus a little bigger."], nil, true },
	{ "check", "KeepExpanded", L["Keep window expanded"], L["Keep the window expanded at all times while on screen."], nil, true },
	{ "check", "LockPosition", L["Lock window position"], L["Prevent the Rematch window from being dragged unless Shift is held."] },
	{ "check", "LockHeight", L["Lock window size"], L["Prevent the window from being resized with the resize grip along the edge of the window."] },
	{ "check", "GrowDownward", L["Reverse pullout"], L["When the Pets or Teams tab is opened, expand the window down the screen instead of up."] },
	{ "check", "ReverseDialog", L["Reverse dialog direction"], L["This setting controls which side of the Rematch window popup dialogs will appear.\n\nRegardless of this setting, when the window is expanded, unless the 'Show dialogs at side' option is checked, they will appear in the middle of the window.\n\n\Otherwise:\n\n\124cffffd200When this option is disabled:\124r Dialogs will appear in the direction that the pullout drawer grows.\n\n\124cffffd200When this option is enabled:\124r Dialogs will appear in the opposite direction that the pullout drawer grows."] },
	{ "check", "SideDialog", L["Show dialogs at side"], L["Instead of making popup dialogs appear in the middle of the expanded Rematch window, make them appear to the side."] },
	{ "check", "StayOnLogout", L["Stay through logouts"], L["If the Rematch window is up when you logout, summon it back on next login after pets load."] },
	{ "header", nil, L["Escape Key Behavior"] },
	{ "check", "LockWindow", L["Disable ESC for window"], L["Prevent the Rematch window from being dismissed with the Escape key."] },
	{ "check", "LockDrawer", L["Disable ESC for drawer"], L["Prevent the pullout drawer from being collapsed with the Escape key."] },
	{ "check", "NotesNoESC", L["Disable ESC for notes"], L["Prevent the notes card from being dismissed with the Escape key."] },
	{ "check", "CloseAllOnESC", L["Close everything with ESC"], L["Close all Escape-enabled Rematch windows at once with the Escape key instead of one at a time."] },
	{ "header", nil, L["Battle Options"] },
	{ "check", "StayForBattle", L["Stay for pet battle"], L["When a pet battle begins, keep Rematch on screen instead of hiding it. Note: the window will still close on player combat."] },
	{ "check", "ShowAfterBattle", L["Show after pet battle"], L["When leaving a pet battle, automatically show the Rematch window."] },
	{ "check", "ShowNotesInBattle", L["Show notes in battle"], L["If the loaded team has notes, display and lock the notes when you enter a pet battle."] },
	{ "check", "ShowNotesOnce", L["Only once per team"], L["Only display notes automatically the first time entering battle, until another team is loaded."], "ShowNotesInBattle" },
	{ "header", nil, L["Loading Options"] },
	{ "check", "OneClickLoad", L["One-click loading"], L["When clicking a team in the Teams tab, instead of locking the team card, load the team immediately. If this is unchecked you can double-click a team to load it."] },
	{ "check", "DontWarnMissing", L["Don't warn about missing pets"], L["Don't display a popup when a team loads and a pet within the team can't be found."] },
	{ "check", "KeepSummoned", L["Keep companion"], L["After a team is loaded, summon back the companion that was at your side before the load."] },
	{ "check", "ShowOnInjured", L["Show on injured"], L["When pets load, show the window if any pets are injured. The window will show if any pets are dead or missing regardless of this setting."] },
	{ "header", nil, L["Leveling Queue Options"] },
	{ "check", "KeepCurrentOnSort", L["Keep current pet on new sort"], L["When sorting the queue, keep the top-most pet at the top so the current leveling pet doesn't change.\n\nThis option has no effect when the queue is actively sorted."] },
	{ "check", "HidePetToast", L["Hide pet toast"], L["Don't display the popup 'toast' when a new pet is automatically loaded from or added to the leveling queue."] },
	{ "check", "QueueSkipDead", L["Prefer live pets"], L["When loading pets from the queue, skip dead pets and load living ones first."] },
	{ "check", "QueueAutoLearn", L["Automatically level new pets"], L["When you capture or learn a pet, automatically add it to the leveling queue."] },
	{ "check", "QueueAutoLearnOnly", L["Only pets not at 25 or queued"], L["Only automatically level pets which don't already have a version at 25 or in the queue."], "QueueAutoLearn" },
	{ "check", "QueueAutoLearnRare", L["Only rare pets"], L["Only automatically level rare quality pets."], "QueueAutoLearn" },
	{ "header", nil, L["Pet Tab Options"] },
	{ "check", "UseTypeBar", L["Use type bar"], L["Show the tabbed bar near the top of the pet browser to filter pet types, pets that are strong or tough vs chosen types."] },
	{ "check", "OnlyBattlePets", L["Only battle pets"], L["Never list pets that can't battle in the pet browser, such as Guild Heralds. Note: most filters like rarity, level or stats will not include non-battle pets already."] },
	{ "check", "ListRealNames", L["List real names"], L["Even if a pet has been renamed, list each pet by its real name."] },
	{ "check", "StrongVsAny", L["Inclusive \"Strong Vs\" filter"], L["When filtering Strong Vs multiple types, list pets that have an ability that's strong vs one of the chosen types, instead of requiring at least one ability to be strong vs each chosen type."] },
	{ "check", "ResetFilters", L["Reset filters on login"], L["Reset all pet browser filters (including sort) when logging in."] },
	{ "check", "DontResetSort", L["Don't reset sort with filters"], L["When a non-standard sort is chosen, don't reset it when clicking the filter reset button at the bottom of the pet browser.\n\n\124cffffd200Note:\124r If 'Reset filters on login' is enabled, sort will still be reset on login regardless of this option."] },
	{ "header", nil, L["Team Tab Options"] },
	{ "check", "SpamTeamMove", L["Spam when teams move"], L["Display in your chat window when a team moves to another tab."] },
	{ "check", "SpamTeamSave", L["Spam when teams save"], L["Display in your chat window when a team is saved and the tab it was saved to."] },
	{ "check", "LockTeamDrag", L["Require Shift to drag"], L["Lock teams in place so they require holding Shift to drag them."] },
	{ "check", "HideTargeted", L["Hide Target buttons"]..newOption, L["In the team list, hide the \124TInterface\\AddOns\\Rematch\\textures\\targeted:16:16:0:0:64:64:48:16:16:48\124t buttons that mark when a team is saved for a specific target."] },
	{ "check", "HideFloatingTeamFootnote", L["Hide mouseover buttons"]..newOption, L["When you mouseover a team in the team list, don't show faded buttons to set notes, preferences and a target when the team lacks any of them.\n\nNote: This is experimental and may disappear."] },
	{ "header", nil, MISCELLANEOUS },
	{ "check", "ShowAbilityNumbers", L["Show ability numbers"], L["In the ability flyout, show the numbers 1 and 2 to help with the common notation such as \"Pet Name 122\" to know which abilities to use."], nil, true },
	{ "check", "RealAbilityIcons", L["Use actual ability icons"], L["In the pet card, display the actual icon of each ability instead of an icon showing the ability's type."], nil, true },
	{ "check", "HideRarityBorders", L["Hide rarity borders"], L["Hide the colored borders to indicate rarity around current pets and pets on the team cards."] },
	{ "check", "DisableShare", L["Disable sharing"], L["Disable the Send button and also block any incoming pets sent by others. Import and Export still work."] },
	{ "check", "JumpToTeam", L["Jump to key"], L["While the mouse is over the team list or pet browser, hitting a key will jump to the next team or pet that begins with that letter."] },
	{ "check", "HideTooltips", L["Hide tooltips"], L["Hide the more common tooltips within Rematch."] },
	{ "check", "HideOptionTooltips", L["Even options"], L["Also hide tooltips that appear here in the options panel. This is not recommended if you're new to the addon."], "HideTooltips" },
	{ "check", "UseMinimapButton", L["Use minimap button"], L["Place a button on the minimap to toggle Rematch."], nil, true },
	{ "check", "HideJournalButton", L["Hide journal button"], L["Do not place a Rematch button along the bottom of the default Pet Journal."], nil, true },
	{ "button", "BindingsButton", KEY_BINDINGS, L["Go to the key binding window to create or change bindings for Rematch."] },
}

function rematch:InitOptions()
	settings = RematchSettings
	-- for options with field 6 set, run their optionsFunc
	for i=#rematch.optionsList,1,-1 do
		local opt = rematch.optionsList[i]
		if opt[6] and rematch.optionsFunc[opt[2]] then
			rematch.optionsFunc[opt[2]]()
		end
	end

	-- if PetBattleTeams enabled, add a button to import teams
	if IsAddOnLoaded("PetBattleTeams") then
		tinsert(rematch.optionsList,{"button", "ImportPBTButton", L["Import Pet Battle Teams"], L["Copy the teams from the addon Pet Battle Teams to the current team tab in Rematch."]})
	end
	if IsAddOnLoaded("Blizzard_Collections") then
		rematch.events.ADDON_LOADED("Blizzard_Collections") -- another addon forced a load, run the event manually
	else
		rematch:RegisterEvent("ADDON_LOADED")
	end
	-- add launcher button for LDB if it exists
	local ldb = LibStub and LibStub:GetLibrary("LibDataBroker-1.1",true)
	if ldb then
	  ldb:NewDataObject("Rematch",{ type="launcher", icon="Interface\\Icons\\PetJournalPortrait", iconCoords={0.075,0.925,0.075,0.925}, tooltiptext=L["Toggle Rematch"], OnClick=Rematch.Toggle	})
	end

	local scrollFrame = rematch.drawer.options.list.scrollFrame
	scrollFrame.update = rematch.UpdateOptionsList
	HybridScrollFrame_CreateButtons(scrollFrame, "RematchOptionsListTemplate")

	rematch.drawer.options.title:SetText(format("Rematch version %s",GetAddOnMetadata("Rematch","Version")))

end

function rematch:ToggleOptions()
	local drawerMode = rematch:GetDrawerMode()
	if drawerMode=="OPTIONS" then
		settings.DrawerMode = settings.oldDrawerMode
		settings.oldDrawerMode = nil
	else
		settings.oldDrawerMode = drawerMode
		settings.DrawerMode = "OPTIONS"
	end
	rematch:UpdateWindow()
end

function rematch:UpdateOptionsList()
	local list = rematch.optionsList
	local numData = #list
	local scrollFrame = rematch.drawer.options.list.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	rematch:ListResizeButtons(scrollFrame)
	scrollFrame.stepSize = floor(scrollFrame:GetHeight()*.65)

	for i=1,min(#buttons,scrollFrame:GetHeight()/scrollFrame.buttonHeight+2) do
		local index = i + offset
		local button = buttons[i]
		button.index = nil
		button:Hide()
		if ( index <= numData) then
			button.index = index
			button.name:ClearAllPoints()
			if list[index][1]=="header" then
				button.name:SetText(list[index][3])
				button.name:SetTextColor(1,.82,0)
				button.name:SetPoint("CENTER")
				button.back:Show()
				button.check:Hide()
				button.button:Hide()
			elseif list[index][1]=="check" then
				button.name:SetText(list[index][3])
				button.back:Hide()
				button.check:Show()
				button.button:Hide()
				button.check:SetPoint("LEFT",list[index][5] and 16 or 6,0)
				button.name:SetPoint("LEFT",button.check,"RIGHT",2,0)
				if list[index][5] and not settings[list[index][5]] then
					button.check:SetEnabled(false) -- disable dependant option if parent unchecked
					button.name:SetTextColor(.5,.5,.5)
				else
					button.check:SetEnabled(true)
					button.name:SetTextColor(1,1,1)
				end
				button.check:SetChecked(settings[list[index][2]])
			elseif list[index][1]=="button" then
				button.name:SetText("")
				button.button:SetText(list[index][3])
				button.back:Hide()
				button.check:Hide()
				button.button:Show()
			end
			button:Show()
		end
	end
	HybridScrollFrame_Update(scrollFrame,20*numData,20)
end

function rematch:OptionOnEnter()
	local index = self:GetParent().index
	-- strip the newOption yellow ! from title if it's there
	local title = rematch.optionsList[index][3]:gsub(rematch:DesensitizedText(newOption),"")
	rematch:ShowTooltip(title,rematch.optionsList[index][4],nil,true)
	rematch:SmartAnchor(RematchTooltip,self:GetParent())
end

function rematch:OptionOnClick()
	local index = self:GetParent().index
	local var = rematch.optionsList[index][2]
	if rematch.optionsList[index][1]=="check" then
		settings[var] = self:GetChecked()
		rematch:UpdateOptionsList()
	end
	if rematch.optionsFunc[var] then
		rematch.optionsFunc[var]()
	end
end

--[[ Minimap Button ]]

function rematch:CreateMinimapButton()
	if RematchMinimapButton then
		return
	end
	local button = CreateFrame("Button","RematchMinimapButton",Minimap)
	button:SetSize(31,31)
	button:SetToplevel(true)
	button:SetFrameStrata("MEDIUM")
	button:SetFrameLevel(button:GetFrameLevel()+3)
	button:RegisterForClicks("AnyUp")
	button:SetHighlightTexture("Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight")
	button.icon = button:CreateTexture(nil,"BACKGROUND")
	button.icon:SetTexture("Interface\\Icons\\PetJournalPortrait")
	button.icon:SetSize(20,20)
	button.icon:SetPoint("CENTER")
	local border = button:CreateTexture(nil,"OVERLAY")
	border:SetTexture("Interface\\Minimap\\MiniMap-TrackingBorder")
	border:SetSize(53,53)
	border:SetPoint("TOPLEFT")
	button:SetScript("OnMouseDown",rematch.MinimapButtonOnMouseDown)
	button:SetScript("OnMouseUp",rematch.MinimapButtonOnMouseUp)
	button:SetScript("OnClick",rematch.Toggle)
	button:SetScript("OnEnter",rematch.ToggleTooltip)
	button:SetScript("OnLeave",rematch.ToggleTooltipHide)
	button:RegisterForDrag("LeftButton")
	button:SetScript("OnDragStart",rematch.MinimapButtonOnDragStart)
	button:SetScript("OnDragStop",rematch.MinimapButtonOnDragStop)
end

function rematch:MinimapButtonOnMouseDown()
	self.icon:SetPoint("CENTER",1,-1)
	self.icon:SetVertexColor(.75,.75,.75)
end

function rematch:MinimapButtonOnMouseUp()
	self.icon:SetPoint("CENTER")
	self.icon:SetVertexColor(1,1,1)
end

function rematch:MinimapButtonOnDragStart()
	self.update = self.update or CreateFrame("Frame",nil,self)
	self.update:SetScript("OnUpdate",rematch.MinimapButtonDragUpdate)
end

function rematch:MinimapButtonOnDragStop()
	rematch.MinimapButtonOnMouseUp(self) -- release button
	self.update:SetScript("OnUpdate",nil)
end

function rematch:MinimapButtonDragUpdate(elapsed)
	local x,y = GetCursorPosition()
	local minX,minY = Minimap:GetLeft(), Minimap:GetBottom()
	local scale = Minimap:GetEffectiveScale()
	settings.minimapButtonPosition = math.deg(math.atan2(y/scale-minY-70,minX-x/scale+70))
	rematch:MinimapButtonPosition()
end

function rematch:MinimapButtonPosition()
	local angle = settings.minimapButtonPosition or -162
	RematchMinimapButton:SetPoint("TOPLEFT",Minimap,"TOPLEFT",52-(80*cos(angle)),(80*sin(angle))-52)
end

--[[ optionsFuncs are functions that run in response to an option being clicked ]]

rematch.optionsFunc = {}

function rematch.optionsFunc.GrowDownward()
	rematch:UpdateWindow()
end

function rematch.optionsFunc.LockHeight()
	rematch:UpdateWindow()
end

function rematch.optionsFunc.LargeWindow()
	local growDown = settings.GrowDownward
	local oldScale = rematch:GetEffectiveScale()
	local x = rematch:GetLeft()
	local y = growDown and rematch:GetTop() or rematch:GetBottom()
	rematch:SetScale(settings.LargeWindow and 1.25 or 1.0)
	local newScale = rematch:GetEffectiveScale()
	settings.X = (x*oldScale)/newScale
	settings.Y = (y*oldScale)/newScale
	rematch:ClearAllPoints()
	rematch:SetPoint(growDown and "TOPLEFT" or "BOTTOMLEFT",UIParent,"BOTTOMLEFT",settings.X,settings.Y)
end

function rematch.optionsFunc.HideJournalButton()
	if PetJournal then
		local button = RematchJournalButton
		local hide = settings.HideJournalButton
		if button then
			button:SetShown(not hide)
		elseif not hide and not button then
			rematch:CreateJournalButton()
		end
	end
end

function rematch.optionsFunc.UseMinimapButton()
	if settings.UseMinimapButton then
		rematch:CreateMinimapButton()
		rematch:MinimapButtonPosition()
	end
	if RematchMinimapButton then
		RematchMinimapButton:SetShown(settings.UseMinimapButton)
	end
end

function rematch.optionsFunc.UseBNet()
	if settings.UseBNet then
		rematch:RegisterEvent("BN_CHAT_MSG_ADDON")
	else
		rematch:UnregisterEvent("BN_CHAT_MSG_ADDON")
	end
end

function rematch.optionsFunc.BindingsButton()
	LoadAddOn("Blizzard_BindingUI")
	ShowUIPanel(KeyBindingFrame)
	local list = KeyBindingFrame.categoryList
	for i=1,#list.buttons do
		if list.buttons[i]:IsVisible() and list.buttons[i].element.name==ADDONS then
			list.buttons[i]:Click()
			return
		end
	end
end

function rematch.optionsFunc.OnlyBattlePets()
	rematch:UpdateWindow()
end

function rematch.optionsFunc.LargeFont()
	if settings.LargeFont then
		RematchListFont:SetFontObject("GameFontHighlight")
	else
		RematchListFont:SetFontObject("SystemFont_Shadow_Small")
	end
end

function rematch.optionsFunc.AutoAlways()
	rematch:SetToolbarButtonEnabled(rematch.toolbar.buttons[2],not settings.AutoAlways)
end

function rematch.optionsFunc.HideRarityBorders()
	rematch:UpdateWindow()
end

function rematch.optionsFunc.QueueSkipDead()
	rematch:ProcessQueue(true)
end

function rematch.optionsFunc.RealAbilityIcons()
	for i=1,6 do
		local button = RematchFloatingPetCard.abilities[tostring(i)]
		button:UnlockHighlight()
		local icon = button.type
		local highlight = button:GetHighlightTexture()
		local hit = button.searchHit
		if settings.RealAbilityIcons then
			icon:SetTexCoord(0,1,0,1)
			highlight:SetTexture("Interface\\Buttons\\UI-Quickslot-Depress")
			highlight:SetTexCoord(0,1,0,1)
			hit:SetTexture("Interface\\PetBattles\\PetBattle-GoldSpeedFrame")
			hit:SetTexCoord(0.1171875,0.7421875,0.1171875,0.734375)
		else
			icon:SetTexCoord(0.4921875,0.796875,0.50390625,0.65625)
			highlight:SetTexture("Interface\\PetBattles\\PetBattleHUD")
			highlight:SetTexCoord(0.884765625,0.943359375,0.681640625,0.798828125)
			hit:SetTexture("Interface\\Common\\GoldRing")
			hit:SetTexCoord(0,1,0,1)
		end
	end
end

function rematch.optionsFunc.ShowAbilityNumbers()
	for i=1,2 do
		RematchAbilityFlyout.ability[i].number:SetShown(settings.ShowAbilityNumbers)
	end
end

function rematch.optionsFunc.KeepExpanded()
	settings.oldDrawerMode = settings.oldDrawerMode or "PETS"
end

-- migrate any teams saved in Pet Battle Teams, whose name doesn't already exist, into Rematch
function rematch:MigratePBT(over)
	local copied,notCopied = 0,0
	if IsAddOnLoaded("PetBattleTeams") and PetBattleTeamsDB and PetBattleTeamsDB.namespaces and PetBattleTeamsDB.namespaces.TeamManager then
		local saved = RematchSaved
		local PBTsaved = PetBattleTeamsDB.namespaces.TeamManager.global.teams
		for team=1,#PBTsaved do
			local teamName = PBTsaved[team].name or "Team: "..team
			if not saved[teamName] or over then -- only migrate teams that don't already exist
				saved[teamName] = {{},{},{}}
				for pet=1,3 do
					local petID = PBTsaved[team][pet].petID
					if petID then
						petID = petID:gsub("%x",function(c) return c:upper() end)
						if petID==rematch.emptyPetID or not petID then
							saved[teamName][pet] = {0} -- convert missing pet to leveling slot
						else
							local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
							if speciesID then
								saved[teamName][pet][1] = petID
							else
								speciesID = PBTsaved[team][pet].speciesID
								saved[teamName][pet][1] = speciesID or 0
							end
							for ability=1,3 do
								saved[teamName][pet][ability+1] = PBTsaved[team][pet].abilities[ability]
							end
							saved[teamName][pet][5] = speciesID
						end
					else
						saved[teamName][pet] = {0}
					end
				end
				saved[teamName].tab = settings.SelectedTab
				rematch:ValidateTeam(teamName)
				copied = copied + 1
				rematch:print(format(L["%s copied."],teamName))
			else
				notCopied = notCopied + 1
				rematch:print(format(L["%s not copied. A team of that name already exists."],teamName))
			end
		end
	end
	if rematch:IsVisible() then
		rematch:UpdateWindow()
	end
	return copied, notCopied
end

function rematch.optionsFunc.ImportPBTButton(over)
	local copied, notCopied = rematch:MigratePBT(over)
	local dialog = rematch:ShowDialog("PBTImport",120,L["Pet Battle Teams Imported"],notCopied==0 and "" or L["Copy again and overwrite?"],notCopied==0 and true or function() rematch.optionsFunc.ImportPBTButton(true) end)
	dialog.text:SetPoint("TOPLEFT",12,-24)
	dialog.text:SetPoint("BOTTOMRIGHT",-12,50)
	local text = format(L["%d teams copied successfully."],copied,settings.TeamGroups[settings.SelectedTab][1])
	if notCopied>0 then
		text = text.. format(L["\n\n%d teams were not copied because teams already exist in Rematch with the same names."],notCopied)
		dialog:SetHeight(164)
	end
	dialog.text:SetText(text)
	dialog.text:Show()
end

--[[ Default Pet Journal changes ]]

function rematch.events.ADDON_LOADED(addon)
	if addon=="Blizzard_Collections" then
		rematch:UnregisterEvent("ADDON_LOADED")

		-- hook the pet menu drop-down menu to rematch.NewDropDownMenu after giving time for all LoadWith to get done
		C_Timer.After(0.5,function()
			if not settings.HideJournalButton then
				rematch:CreateJournalButton()
			end
			local parent = PetJournalEnhancedPetMenu or PetJournalPetOptionsMenu
			rematch.oldDropDownInit = parent.initialize
			parent.initialize = rematch.NewPetMenuDropDownInit
		end) -- come back in .5 seconds to look for them
		hooksecurefunc("HybridScrollFrame_Update",rematch.UpdateLevelingMarkers)

		-- there is no GetSearchFilter, so we need to watch filters being set
		hooksecurefunc(C_PetJournal,"SetSearchFilter",function(search)
			if (search or ""):len()>0 and settings.DrawerMode=="PETS" and rematch.drawer:IsVisible() then
				rematch:Hide()
				rematch:print("The pet journal's search box can't be used while the pet tab is open, sorry!")
			end
			rematch.defaultSearchFilter = search
		end)
		hooksecurefunc(C_PetJournal,"ClearSearchFilter",function()
			rematch.defaultSearchFilter = search
		end)

		-- handlers for when a journal slot is receiving a leveling pet
		for i=1,3 do
		  local button = _G["PetJournalLoadoutPet"..i.."SetButton"]
			button:HookScript("OnClick",rematch.HandleReceivingLevelingPet)
			button:HookScript("OnReceiveDrag",rematch.HandleReceivingLevelingPet)
		end

	end
end

-- this is a prehook to the dropdown initialization for the journal pet menu (hook made when journal loads)
function rematch:NewPetMenuDropDownInit(level)
	local petID = PetJournal.menuPetID
	if petID then
	  local info = UIDropDownMenu_CreateInfo()
	  info.notCheckable = true
		info.arg1 = petID
		if rematch:PetCanLevel(petID) then
			local isLeveling = rematch:IsPetLeveling(petID)
			if petID~=rematch:GetCurrentLevelingPet() and not settings.QueueFullSort then
				info.text = L["Start Leveling"]
				info.func = rematch.DropDownStartLeveling
				UIDropDownMenu_AddButton(info,level)
			end
			if not isLeveling then
				info.text = L["Add to Leveling Queue"]
				info.func = rematch.DropDownAddToQueue
				UIDropDownMenu_AddButton(info,level)
			end
			if isLeveling then
				info.text = L["Stop Leveling"]
				info.func = rematch.DropDownStopLeveling
			  UIDropDownMenu_AddButton(info,level)
			end
		end
		info.text = L["Find Similar"]
		info.func = rematch.DropDownFindSimilar
	  UIDropDownMenu_AddButton(info,level)
	end
	rematch.oldDropDownInit(self,level)
end

function rematch:DropDownStartLeveling(petID)
	rematch:StartLevelingPet(petID)
end

function rematch:DropDownAddToQueue(petID)
	rematch:AddLevelingPet(petID)
end

function rematch:DropDownStopLeveling(petID)
	rematch:StopLevelingPet(petID)
end

function rematch:DropDownFindSimilar(petID)
	if type(petID)=="string" then
		petID = C_PetJournal.GetPetInfoByPetID(petID)
	end
	rematch.roster:SetSimilarFilter(petID)
end

-- in ADDON_LOADED of the pet journal, HybridScrollFrame_Update is hooked to this
-- to go through all buttons in the journal to show/hide a leveling icon
function rematch:UpdateLevelingMarkers()
	if self==rematch and PetJournal then
		self = PetJournalEnhancedListScrollFrame or PetJournalListScrollFrame
	end
	if self==PetJournalListScrollFrame or self==PetJournalEnhancedListScrollFrame then
		for i=1,#self.buttons do
			local petID = self.buttons[i].petID
			local showIcon
			local icon = self.buttons[i].rematchLevelingPet
			if petID and rematch:IsPetLeveling(petID) then
				if not icon then
					self.buttons[i].rematchLevelingPet = self.buttons[i]:CreateTexture(nil,"ARTWORK")
					icon = self.buttons[i].rematchLevelingPet
					icon:SetSize(24,24)
					icon:SetPoint("RIGHT",-6,0)
					icon:SetTexture("Interface\\AddOns\\Rematch\\textures\\preference")
					icon:SetTexCoord(0.25,0.75,0.25,0.75)
				end
				showIcon = true
			end
			if icon then
				icon:SetShown(showIcon)
			end
		end
	end
end

function rematch:CreateJournalButton()
	if RematchJournalButton then return end

	-- find the last frame anchored in a chain to the Find Battle button, if any
	local lastAnchor
	local function findAnchor(anchoredTo,...)
		lastAnchor = anchoredTo
		for i=1,select("#",...) do
			local button = select(i,...)
			if select(2,button:GetPoint())==anchoredTo then
				findAnchor(button,PetJournal:GetChildren())
				return
			end
		end
	end
	findAnchor(PetJournalFindBattle,PetJournal:GetChildren())

	-- create the button
	local button = CreateFrame("Button","RematchJournalButton",PetJournal,"UIPanelButtonTemplate") -- MagicButtonTemplate
	button:SetSize(100,22)
	button:SetText("Rematch")
	button:SetScript("OnClick",rematch.Toggle)
	button:SetScript("OnEnter",rematch.ToggleTooltip)
	button:SetScript("OnLeave",rematch.ToggleTooltipHide)

	-- position it anchored to the left of the lastAnchor found above
	button:SetPoint("RIGHT",lastAnchor,"LEFT",-2,0)
	-- now nudge it so it's properly centered if an addon does some yoffset
	local yoff = floor(button:GetBottom())-floor(PetJournal:GetBottom())-4
	button:SetPoint("RIGHT",lastAnchor,"LEFT",-2,-yoff)
end
