
--[[
This menu system is intended to be used in place of the default DropDownMenu.

Instead of building menus on the fly, menus are pre-made tables with functions to fetch
run-time values.

Valid menu tags:
title, hide, indent, disable, subMenu, check, radio, value, icon, text, stay,
iconCoords,

TODO for 4.0: Menu needs to not be parented to Rematch
]]



local _,L = ...
local rematch = Rematch
rematch.menu = {}
local menu = rematch.menu
local rmf = rematch.rmf

menu.menus = {} -- all registered menus are stored here, indexed by menu name
menu.framePool = {} -- pool of menu frames, indexed by their level
menu.buttonPool = {} -- pool of buttons, numerically indexed

--[[ functions to be called from rematch ]]

local testVar
local radioVar = 1
function rematch:GetRadioTest()
	return self.arg==radioVar
end
function rematch:SetRadioTest()
	radioVar = self.arg
end

function rematch:InitMenu()

end

function rematch:RegisterMenu(name,menuTable)
	menu.menus[name] = menuTable
end

-- subject is some persistent object (petID or team name) menu is acting on
function rematch:SetMenuSubject(subject,arg1,arg2,arg3)
	menu.subject = subject
	menu.arg1 = arg1
	menu.arg2 = arg2
	menu.arg3 = arg3
end

function rematch:HideMenu()
	for i=1,#menu.framePool do
		menu.framePool[i]:ClearAllPoints() -- to prevent <unnamed>:SetPoint(): <unnamed> is dependent on this
		menu.framePool[i]:Hide()
	end
	menu.menuOpen = nil
end

function rematch:GetMenuOpen()
	return menu.menuOpen
end

function rematch:IsMenuOpen(menuName)
	if not menuName then
		return RematchMenu and RematchMenu:IsVisible() -- if no menuName given, return true if any menu is open
	end
	for i=1,#menu.framePool do
		local frame = menu.framePool[i]
		if frame:IsVisible() and frame.menu==menuName then
			return true
		end
	end
end

function rematch:MouseIsOverMenu()
	for i=1,#menu.framePool do
		if MouseIsOver(menu.framePool[i]) then
			return true
		end
	end
end

function rematch:MenuJustClosed()
	return menu.timeClosed==GetTime()
end

function rematch:RefreshAllMenus()
	for i=1,#menu.framePool do
		if menu.framePool[i]:IsVisible() then
			menu:RefreshMenu(menu.framePool[i])
		end
	end
end

--[[ Resource pool ]]

-- returns the frame for a specific level; only one menu can exist per level
function menu:GetMenuFrame(level,parent)
	local frame,name
	if not menu.framePool[level] then
		frame = CreateFrame("Frame",level==1 and "RematchMenu" or nil,nil,"RematchMenuTemplate")
		frame:SetScript("OnHide",menu.FrameOnHide)
		frame:SetID(level)
		menu.framePool[level] = frame
		if level==1 then -- first level gets an OnUpdate
			frame:SetScript("OnUpdate",menu.FrameOnUpdate)
		end
	end
	frame = menu.framePool[level]
	frame:SetParent(parent)
	frame:SetFrameStrata("FULLSCREEN_DIALOG")
	return frame
end

-- returns an available button for parent, also assigning it as a parent.
-- when menus close, buttons are hidden and they lose their parents (aww) to become free
function menu:GetButton(parent)
	for i=1,#menu.buttonPool do
		if not menu.buttonPool[i]:GetParent() and select(2,parent:GetPoint())~=menu.buttonPool[i] then
			menu.buttonPool[i]:SetParent(parent)
			menu.buttonPool[i].text:SetFontObject(RematchSettings.LargeFont and "GameFontHighlight" or "GameFontHighlightSmall")
			return menu.buttonPool[i]
		end
	end
	-- if we reached this far, all buttons have parents. create a new button
	local button = CreateFrame("Button",nil,parent,"RematchMenuButtonTemplate")
	button:SetScript("OnEnter",menu.ButtonOnEnter)
	button:SetScript("OnLeave",menu.ButtonOnLeave)
	button:SetScript("OnMouseDown",menu.ButtonOnMouseDown)
	button:SetScript("OnMouseUp",menu.ButtonOnMouseUp)
	button:SetScript("OnClick",menu.ButtonOnClick)
	button.text:SetFontObject(RematchSettings.LargeFont and "GameFontHighlight" or "GameFontHighlightSmall")
	tinsert(menu.buttonPool,button)
	return button
end


-- displays a pre-defined menu at either "cursor" or a specific anchorPoint
-- rematch:ShowMenu("current","cursor")
-- rematch:ShowMenu("filter","TOPLEFT",browser.filter,"TOPRIGHT",3,0)
-- for sub-level use only (should never be called outside menu3.lua):
-- rematch:ShowMenu("subMenu",self,self,level+1)
function rematch:ShowMenu(name,anchorPoint,relativeTo,relativePoint,anchorXoff,anchorYoff,stay)

	-- when called by a subMenu, anchorPoint and relativeTo are both frames, and relativePoint is level
	local level = type(relativePoint)=="number" and relativePoint or 1

	if not menu.menus[name] then
		return -- leave if name isn't in menu of menus
	end

	if level==1 and not stay then
		rematch:HideDialogs()
	end

	local entry = menu.menus[name]
	local frame = menu:GetMenuFrame(level or 1,relativeTo or rematch)

	if level==1 then
		frame.timeAway = nil
		frame.elapsed = 0
	end

	-- hide any sub-menus
	for i=level,#menu.framePool do
		menu.framePool[i]:Hide()
	end

	local maxWidth = 0
	local hasSubMenu -- becomes true if any item in this menu has a sub-menu
	local yoff = -7 -- offset from top to anchor next button
	local first = 1 -- which entry we start from (can change if we have a title)

	local item = entry[1]
	if item.title then
		frame.title.text:SetText(type(item.title)=="function" and item.title(item) or item.title)
		local titleWidth = frame.title.text:GetStringWidth()+16
		maxWidth = item.maxWidth and min(item.maxWidth,titleWidth) or titleWidth
--		maxWidth = entry[1].maxWidth and entry[1].maxWidth or frame.title.text:GetStringWidth()+16
		frame.shadow:SetPoint("TOPLEFT",3,-20)
		frame.title:Show()
		yoff = -24
		first = 2
	else
		frame.shadow:SetPoint("TOPLEFT",3,-3)
		frame.title:Hide()
	end

	for i=first,#entry do
		local item = entry[i]

		if not menu:GetValue(item,item.hide) then

			local button = menu:GetButton(frame)
			button:SetPoint("TOPLEFT",8,yoff)

			local padding = item.indent or 0

			-- show arrow to menu items with a subMenu
			if item.subMenu then
				button.arrow:Show()
				button.arrow:SetTexCoord(0,1,1,1,0,0,1,0) -- rotate arrow
				hasSubMenu = true
			else
				button.arrow:Hide()
			end

			-- show/set checkboxes and radio buttons
			if menu:GetValue(item,item.check) or menu:GetValue(item,item.radio) then
				button.check:SetPoint("LEFT",padding,1)
				padding = padding + 18
				button.isChecked = menu:GetValue(item,item.value)
				menu:SetChecked(button,button.isChecked,item.radio)
				button.check:Show()
			else
				button.check:Hide()
			end

			-- show/set icons
			if item.icon then
				button.icon:SetPoint("LEFT",padding,0)
				padding = padding + 18
				button.icon:SetTexture(menu:GetValue(item,item.icon))
				if item.iconCoords then
					button.icon:SetTexCoord(unpack(item.iconCoords))
				else
					button.icon:SetTexCoord(0.075,0.925,0.075,0.925)
				end
				if item.iconColor then
					button.icon:SetVertexColor(unpack(item.iconColor))
				else
					button.icon:SetVertexColor(1,1,1)
				end
				button.icon:Show()
			else
				button.icon:Hide()
			end

			-- enable/disable and spacer at same time (spacer is disabled to prevent highlight)
			if item.spacer then
				menu:SetEnabled(button,false)
			else
				menu:SetEnabled(button,not menu:GetValue(item,item.disable))
			end

			-- the actual text on the button
			button.text:SetText(menu:GetValue(item,item.text) or "")
			button.text:SetPoint("LEFT",padding,0)
			button.padding = padding

			if menu:GetValue(item,item.highlight) then
				button.text:SetTextColor(1,.82,0)
			end

			maxWidth = math.max(button.text:GetStringWidth()+padding+4,maxWidth)

			button.item = item

			button:Show()
			yoff = yoff - 16 + (item.spacer and 10 or 0)

		end

	end

	maxWidth = maxWidth + (hasSubMenu and 4 or 0)

	-- make all of this frame's buttons the same maxWidth
	for i=1,#menu.buttonPool do
		if menu.buttonPool[i]:GetParent()==frame then
			menu.buttonPool[i]:SetWidth(maxWidth)
		end
	end

	-- now size this frame itself
	frame:SetWidth(maxWidth+16)
	frame:SetHeight(abs(yoff-7))

	-- now position the frame
	local uiScale = UIParent:GetEffectiveScale()
	frame:ClearAllPoints()
	if type(anchorPoint)=="table" then -- if this subMenu is being anchored to a menu button
		if menu.reverseAnchor or (anchorPoint:GetRight()+maxWidth)*anchorPoint:GetEffectiveScale() > UIParent:GetRight()*uiScale then
			frame:SetPoint("TOPRIGHT",anchorPoint,"TOPLEFT",-2,5)
			menu.reverseAnchor = true
		else
			frame:SetPoint("TOPLEFT",anchorPoint,"TOPRIGHT",2,5)
		end
	elseif anchorPoint=="cursor" or not anchorPoint then -- if "cursor" or no anchor, to cursor
	  local x,y = GetCursorPosition()
		uiScale = rematch:GetEffectiveScale()
		frame:SetPoint("TOPLEFT",UIParent,"BOTTOMLEFT",x/uiScale-4,y/uiScale+4)
		menu.reverseAnchor = nil
	elseif anchorPoint then -- or a defined anchor
		frame:SetPoint(anchorPoint,relativeTo,relativePoint,anchorXoff,anchorYoff)
		menu.reverseAnchor = nil
	end

	frame:Show()

	frame.menu = name
	menu.menuOpen = name

end

-- when a menu item doesn't hide the menu, it will refresh its menu and its parent menu.
-- a refresh only updates checkboxes, radio buttons and disabled states
function menu:RefreshMenu(frame)
	for i=1,#menu.buttonPool do
		local button = menu.buttonPool[i]
		if button:GetParent()==frame then
			local item = button.item
			-- refresh checks/radios
			if item.check or item.radio then
				button.isChecked = menu:GetValue(item,item.value)
				menu:SetChecked(button,button.isChecked,item.radio)
			end
			if item.spacer then
				menu:SetEnabled(button,false)
			else
				menu:SetEnabled(button,not menu:GetValue(item,item.disable))
			end
			if menu:GetValue(item,item.highlight) then
				button.text:SetTextColor(1,.82,0)
			end
		end
	end
end

-- many menu items are the result of functions (whether to hide, disable, etc)
-- while others are plain values; this returns the appropriate one
function menu:GetValue(item,variable)
	if type(variable)=="function" then
		return variable(item)
	else
		return variable
	end
end

-- enables or disables the menu button based
function menu:SetEnabled(button,enable)
	if enable then
		button.text:SetTextColor(1,1,1)
		button.check:SetDesaturated(false)
		button.icon:SetDesaturated(false)
		button:EnableMouse(true)
	else
		button.text:SetTextColor(.55,.55,.55)
		button.check:SetDesaturated(true)
		button.icon:SetDesaturated(true)
		button:EnableMouse(false)
	end
end

-- the checkbox/radio is one texture Interface\Common\UI-DropDownRadioChecks
-- with checkbox textures in top half and radio textures in bottom left
-- and "on" texture on left and "off" texture on right
function menu:SetChecked(button,isChecked,isRadio)
	button.check:SetTexCoord(isChecked and 0 or 0.5,isChecked and 0.5 or 1,isRadio and 0.5 or 0,isRadio and 1 or 0.5)
end

--[[ Frame and Button script handlers ]]

function menu:FrameOnHide()
	for i=1,#menu.buttonPool do
		if menu.buttonPool[i]:GetParent()==self then
			menu.buttonPool[i]:Hide()
			menu.buttonPool[i]:ClearAllPoints()
			menu.buttonPool[i]:SetParent(nil)
		end
	end
	-- if this is the first-level frame that's hiding, remove it from UISpecialFrames
	-- and hide all further level frames
	if self:GetID()==1 then
		for i=#menu.framePool,2,-1 do
			menu.framePool[i]:Hide()
		end
	end
	menu.timeClosed = GetTime()
end

-- this should only run for the first-level frame also
function menu:FrameOnUpdate(elapsed)
	self.elapsed = self.elapsed + elapsed
	if self.elapsed > 0.1 then

		local mouseOverMenu
		for i=1,#menu.framePool do
			if MouseIsOver(menu.framePool[i]) then
				mouseOverMenu = true
				break
			end
		end

		if mouseOverMenu then
			self.timeAway = 0
		elseif self.timeAway then
			self.timeAway = self.timeAway + self.elapsed
			if self.timeAway > 2 then
				rematch:HideMenu()
				self.timeAway = nil
				return
			end
		end

		self.elapsed = 0
	end
end

function menu:ButtonOnEnter()
	self.highlight:Show()
	-- hide any menus deeper than the button we entered
	local level = self:GetParent():GetID()
	for i=level+1,#menu.framePool do
		menu.framePool[i]:Hide()
	end
	-- if we entered a button with a subMenu, show it
	if self.item.subMenu then
		local level = self:GetParent():GetID()
		local newMenu = self.item.subMenu
		if type(newMenu)=="function" then
			newMenu = newMenu(self,self.item.subMenuVar)
		end
		rematch:ShowMenu(newMenu,self,self,level+1)
	end
	if self.item.tooltipTitle then
		rematch:ShowTooltip(self.item.tooltipTitle,self.item.tooltipBody,nil,nil,true)
	end
end

function menu:ButtonOnLeave()
	self.highlight:Hide()
	RematchTooltip:Hide()
end

function menu:ButtonOnMouseDown()
	if self.padding then
		self.text:SetPoint("LEFT",self.padding+2,-1)
	end
end

function menu:ButtonOnMouseUp()
	if self.padding then
		self.text:SetPoint("LEFT",self.padding,0)
	end
end

function menu:ButtonOnClick()
	local item = self.item

	-- toggle check/radio if it's used
	if item.check or item.radio then
		self.isChecked = not self.isChecked or nil
	end

	-- run function defined for the item
	if item.func then
		item.func(item,self.isChecked,self:GetParent().menu)
	end

	-- hide the menus unless it's a check, radio, stay flag set or this button opens a subMenu
	if item.stay==false or not (item.check or item.radio or item.stay or item.subMenu) then
		for i=1,#menu.framePool do
			menu.framePool[i]:Hide()
		end
	else
		-- if menu is staying, refresh it
		local menuFrame = self:GetParent()
		if menuFrame then
			local menuLevel = menuFrame:GetID()
			menu:RefreshMenu(menuFrame)
			if menuLevel>1 then -- refresh parent level too if this is a sub-menu
				menu:RefreshMenu(menu.framePool[menuLevel-1])
			end
		end
	end
end
