--[[  There are over two dozen occasions to ask a user to confirm something:
			"Delete this tab?" "Load this team?" "Choose a name and icon" etc.
			Instead of creating separate dialogs, one common dialog is used with
			common elements that functions can repurpose for its use.

			rematch:ShowDialog("ArbitraryName",height,"Title","Prompt text",okayFunc)

			Widgets are all hidden/reset when a dialog is just shown. It's up to the
			calling functions to set them up.

			Pre-defined widgets:
				text: <FontString> for text
				slot: <RematchPetSlotTemplate> for pet slots
				editBox: <RematchInputBoxTemplate> wide single-line editbox
				warning: <Frame> alert icon with .text that resizes based on text
				tabPicker: <RematchToolbarButtonTemplate> to switch team tabs
				multiLine: <ScrollFrame> multi-line editbox
				levelingCarousel: <Frame> contains a carousel UI for choosing a leveling pet

			For custom widgets:
				- Make the dialog its direct parent
				- rematch:RegisterDialogWidget("widgetName")
]]

local _,L = ...
local rematch = Rematch
local saved
local dialog = rematch.dialog

-- list of widget keys (ie dialog.slot) to unanchor/hide when a dialog is shown
-- before calling function makes its changes.
dialog.widgets = { "text", "slot", "editBox", "team", "warning", "tabPicker", "multiLine", "checkBox", "levelingCarousel", "preferencesPanel", "preferencesToggle", "numberEditBox", "save" }

function rematch:InitDialog()
	saved = RematchSaved
	dialog:SetFrameLevel(3)
	dialog.blackout:SetFrameLevel(1)
	dialog.tabPicker.label:SetText(L["Save in team tab:"])
	dialog.tabPicker.OnClick = rematch.TabPickerOnClick
	dialog.tabPicker.text:SetPoint("LEFT",20,0)
end

-- hides all the little popups and widgets
function rematch:HideDialogs()
	rematch:HideMenu()
	rematch:HideFloatingPetCard(true)
	RematchAbilityFlyout:Hide()
	RematchTeamCard:Hide()
	RematchAbilityCard:Hide()
	RematchTooltip:Hide()
	RematchTableTooltip:Hide()
	dialog:Hide()
end

-- setup dialog with a few standard settings
-- it's up to the calling function to move/show widgets where it wants
-- and anchor the dialog itself too
-- if okayFunc is true, then only an accept button is shown (cancel is hidden)
function rematch:ShowDialog(name,height,title,prompt,okayFunc)
	rematch:HideTooltip()
	rematch:WipeDialog()
	dialog:SetHeight(height)
	dialog.name = name
	dialog.header.text:SetText(title)
	if saved[title] and saved[title][4] then
		-- color header text white when it's a teamName with an npcID
		dialog.header.text:SetTextColor(1,1,1)
	else
		dialog.header.text:SetTextColor(1,.82,0)
	end
	dialog.prompt:SetText(prompt)
	if okayFunc==true then
		dialog.cancel:Hide()
		dialog.accept:SetPoint("BOTTOMRIGHT",dialog.cancel)
	else
		dialog.cancel:Show()
		dialog.accept:SetPoint("BOTTOMRIGHT",-28,2)
		dialog.accept:SetScript("OnClick",okayFunc)
	end
	dialog.timeShown = GetTime()
	rematch:SmartDialogAnchor()
	dialog:Show()
	return dialog
end

-- reset dialog to a blank state
function rematch:WipeDialog()
	for _,name in pairs(dialog.widgets) do
		local widget = dialog[name]
		widget:ClearAllPoints()
		widget:Hide()
		widget.tooltipTitle = nil
		widget.tooltipBody = nil
	end
	dialog.slot.petID = nil
	dialog.prompt:SetText("")
	dialog.text:SetFontObject("GameFontHighlight")
	rematch:SetAcceptEnabled(true)
	dialog.editBox:SetScript("OnTextChanged",nil)
	dialog.editBox:SetText("")
	dialog.editBox:SetWidth(160)
	dialog.editBox:SetScript("OnTabPressed",nil)
	dialog.editBox:SetTextColor(1,1,1)
	dialog.editBox:SetJustifyH("CENTER")
	dialog.numberEditBox:SetScript("OnTextChanged",nil)
	dialog.numberEditBox:SetText("")
	dialog.multiLine.editBox:SetScript("OnTextChanged",nil)
	dialog.multiLine.editBox:SetText("")
	dialog.multiLine:SetSize(192,55)
	dialog.multiLine.editBox:SetSize(170,55)
	dialog.slot.level:Hide()
	dialog.slot.levelBG:Hide()
	dialog.slot.border:Hide()
	dialog.selectedIcon = nil
	dialog.accept:SetScript("OnClick",nil)
	dialog.accept:Show()
	dialog.text:SetSize(0,16)
	dialog.textTest:Hide()
	dialog.checkBox:SetScript("OnClick",nil)
	dialog.checkBox:SetChecked(false)
	dialog.runOnCancel = nil
end

-- to create non-standard widgets (like iconPicker), create
-- it as a key to rematch.dialog (ie rematch.dialog.iconPicker)
-- and rematch:RegisterDialogWidget("iconPicker")
function rematch:RegisterDialogWidget(name)
	if type(name)=="string" and not tContains(dialog.widgets,name) then
		tinsert(dialog.widgets,name)
	end
end

function rematch:DialogOnHide()
	self.name = nil
	rematch:HideMenu()
	rematch:HideFloatingPetCard(true)
	if self.runOnCancel then
		self:runOnCancel()
	end
	if dialog.teamNotLoaded then
		rematch:StartTimer("WipeTeamNotLoaded",0.1,rematch.WipeTeamNotLoaded)
	end
	self.timeClosed = GetTime()
end

function rematch:DialogJustClosed()
	return dialog.timeClosed==GetTime()
end

-- there are times when teams being saved are not loaded (import, receive)
-- since we can't know if a user cancelled or ESC'ed a frame (easily),
-- a flag dialog.teamNotLoaded is set to indicate that the team being
-- saved isn't necessarily loaded. After dialogs are done, this flag is wiped.
function rematch:WipeTeamNotLoaded()
	if not dialog:IsVisible() then
		dialog.teamNotLoaded = nil
	end
end

function rematch:IsDialogOpen(name)
	return dialog.name==name
end

-- when text changes for tab name in tab edit dialog
function rematch:DialogEditBoxOnTextChanged()
	rematch:SetAcceptEnabled(self:GetText():len()>0)
end

function rematch:SetAcceptEnabled(bool)
	dialog.accept.icon:SetDesaturated(not bool)
	dialog.accept:SetEnabled(bool)
end

function rematch:SmartDialogAnchor(frame)
	frame = frame or dialog
	local settings = RematchSettings
	frame:ClearAllPoints()
	if rematch.drawer:IsVisible() then
		if not settings.SideDialog then
			frame:SetPoint("CENTER")
		elseif settings.ReverseDialog then
			frame:SetPoint("LEFT",rematch,"RIGHT",0,0)
		else
			frame:SetPoint("RIGHT",rematch,"LEFT",0,0)
		end
	elseif settings.GrowDownward then
		if settings.ReverseDialog then
			frame:SetPoint("BOTTOM",rematch,"TOP",0,10)
		else
			frame:SetPoint("TOP",rematch,"BOTTOM",0,-10)
		end
	elseif settings.ReverseDialog then
		frame:SetPoint("TOP",rematch,"BOTTOM",0,-10)
	else
		frame:SetPoint("BOTTOM",rematch,"TOP",0,10)
	end
end

function rematch:TabPickerOnClick()
	if rematch:IsMenuOpen("tabPicker") then
		rematch:HideMenu()
	else
		rematch:ShowMenu("tabPicker","TOPRIGHT",self,"BOTTOMRIGHT",-4,4,true)
	end
end
