-- rActionButtonStyler by Roth, modified.

local F, C = unpack(select(2, ...))

if not C.actionbars.enable then return end
if not C.actionbars.enableStyle then return end

local r, g, b = unpack(C.class)
local locale = GetLocale()
local _G = _G
local gsub = gsub

local textures = {
	blank = "Interface\\Buttons\\WHITE8x8",
	normal= "Interface\\AddOns\\FreeUI\\media\\button\\gloss",
	flash = "Interface\\AddOns\\FreeUI\\media\\button\\flash",
	hover = "Interface\\AddOns\\FreeUI\\media\\button\\hover",
	pushed = "Interface\\AddOns\\FreeUI\\media\\button\\pushed",
	checked = "Interface\\AddOns\\FreeUI\\media\\button\\checked",
	equipped = "Interface\\AddOns\\FreeUI\\media\\button\\gloss_grey",
	outer_shadow = "Interface\\AddOns\\FreeUI\\media\\button\\glow",
	}

local color = {
	normal= { r = 0, g = 0, b = 0, },
	equipped= { r = 1, g = 1, b = 1, },
	}

-- glow
local backdrop = {
	bgFile = textures.blank,
	edgeFile = textures.outer_shadow,
	tile = false,
	edgeSize = 3,
	insets = { left = 3, right = 3, top = 3, bottom = 3 },
}

-- border
local backdrop2 = {
	bgFile = textures.blank,
	edgeFile = textures.blank,
	edgeSize = 1,
	insets = {top = 1, left = 1, bottom = 1, right = 1},
}

local showHotKey = C.actionbars.hotKey
local showMacroName = C.actionbars.macroName

F.AddOptionsCallback("actionbars", "hotKey", function()
	showHotKey = C.actionbars.hotKey

	for k, frame in pairs(ActionBarButtonEventsFrame.frames) do
		ActionButton_UpdateHotkeys(frame, frame.buttonType)
	end

	for i = 1, NUM_PET_ACTION_SLOTS do
		PetActionButton_SetHotkeys(_G["PetActionButton"..i])
	end
end)

local function updateHotkey(self)
	local ho = _G[self:GetName().."HotKey"]
	local text = ho:GetText()
	
	if not self.styledHotkey then
		ho:ClearAllPoints()
		ho:SetWidth(0)
		ho:SetPoint("TOPLEFT", 1, 0)
		F.SetFS(ho)
		ho:SetJustifyH("RIGHT")
		ho:SetDrawLayer("OVERLAY", 1)
		self.styledHotkey = true
	end

	if text then
		text = text:gsub("(s%-)", "S")
		text = text:gsub("(a%-)", "A")
		text = text:gsub("(c%-)", "C")

		if locale == "zhCN" then
        	text = text:gsub("鼠标按键", "M")
        	text = text:gsub("鼠标中键", "M3")
        	text = text:gsub("鼠标滚轮向上滚动", "MU")
        	text = text:gsub("鼠标滚轮向下滚动", "MD")
    	end

		text = text:gsub("Mouse Button", "M")
		text = text:gsub("Middle Mouse", "M3")
		text = text:gsub("Mouse Wheel Up", "MU")
		text = text:gsub("Mouse Wheel Down", "MD")
		text = text:gsub("Delete", "Del")
		text = text:gsub("Num Pad", "N")
		text = text:gsub("Page Up", "PU")
		text = text:gsub("Page Down", "PD")
		text = text:gsub("Spacebar", "SpB")
		text = text:gsub("Insert", "Ins")
		text = text:gsub("Num Lock", "NL")
		text = text:gsub("Home", "Hm")
	end

	if ho:GetText() == _G["RANGE_INDICATOR"] then
		ho:SetText("")
	else
		ho:SetText(text)
	--	ho:SetText("|cffffffff"..text)
	end

	if showHotKey then
		ho:Show()
	else
		ho:Hide()
	end
end

local function applyBackground(bu)
	if bu:GetFrameLevel() < 7 then bu:SetFrameLevel(7) end
	-- glow + background
	bu.bg = CreateFrame("Frame", nil, bu)
	bu.bg:SetAllPoints(bu)
	bu.bg:SetPoint("TOPLEFT", bu, "TOPLEFT", -3, 3)
	bu.bg:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 3, -3)
	bu.bg:SetFrameLevel(bu:GetFrameLevel()-2)
	bu.bg:SetBackdrop(backdrop)
	bu.bg:SetBackdropColor(0.05, 0.05, 0.05, 0.7)
	bu.bg:SetBackdropBorderColor(0,0,0)
	-- border
	bu.border = CreateFrame("Frame", nil, bu)
	bu.border:SetAllPoints(bu)
	bu.border:SetPoint("TOPLEFT", bu, "TOPLEFT", -1, 1)
	bu.border:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 1, -1)
	bu.border:SetFrameLevel(bu:GetFrameLevel()-1)
	bu.border:SetBackdrop(backdrop2)
	bu.border:SetBackdropColor(0,0,0,0)
	bu.border:SetBackdropBorderColor(0,0,0)

	bu.bg = true
end

local function styleExtraActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	bu.style:SetTexture(nil)

	hooksecurefunc(bu.style, "SetTexture", function(self, texture)
		if texture then
			self:SetTexture(nil)
		end
	end)

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetHighlightTexture("")
	bu:SetCheckedTexture(C.media.backdrop)

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r, g, b)
	ch:SetDrawLayer("ARTWORK")
	ch:SetAllPoints(bu)

	_G[bu:GetName().."HotKey"]:Hide()

	bu.icon:SetDrawLayer("OVERLAY")
	bu.icon:SetTexCoord(.08, .92, .08, .92)
	bu.icon:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	bu.icon:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

	bu.cooldown:SetAllPoints()

	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function styleActionButton(bu)
	if not bu or (bu and bu.styled) then return end

	local action = bu.action
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local co= _G[name.."Count"]
	local bo= _G[name.."Border"]
	local cd= _G[name.."Cooldown"]
	local na= _G[name.."Name"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture"]
	local fbg= _G[name.."FloatingBG"]
	local fob = _G[name.."FlyoutBorder"]
	local fobs = _G[name.."FlyoutBorderShadow"]
	if fbg then fbg:Hide() end--floating background
	--flyout border stuff
	if fob then fob:SetTexture(nil) end
	if fobs then fobs:SetTexture(nil) end
	bo:SetTexture(nil) --hide the border (plain ugly, sry blizz)

	-- local name = bu:GetName()
	-- local ic  = bu.icon
	-- local co  = _G[name.."Count"]
	-- local fl  = _G[name.."FloatingBG"]

	-- _G[name.."Name"]:Hide()
	-- _G[name.."Border"]:SetTexture("")
	-- bu.NewActionTexture:SetTexture("")

	--macroname
	F.SetFS(na)
    na:ClearAllPoints()
	na:SetPoint("BOTTOMLEFT",bu)
    na:SetPoint("BOTTOMRIGHT",bu)
	if not showMacroName then na:Hide() end

	--count
	F.SetFS(co)
	co:ClearAllPoints()
	co:SetPoint("TOPRIGHT", -1, -1)
	co:SetDrawLayer("OVERLAY")

	--applying the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
--	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)

	if not nt then
		--fix the non existent texture problem (no clue what is causing this)
		nt = bu:GetNormalTexture()
	end

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r, g, b)
	ch:SetDrawLayer("ARTWORK")
	ch:SetAllPoints(bu)

	-- ic:SetTexCoord(.08, .92, .08, .92)
	-- ic:SetDrawLayer("OVERLAY")
	-- ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 1, -1)
	-- ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", -1, 1)

	--cut the default border of the icons and make them shiny
	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	--adjust the cooldown frame
	cd:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	cd:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	--apply the normaltexture
	if action and ( IsEquippedAction(action) ) then
		bu:SetNormalTexture(textures.equipped)
		nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b,1)
	else
		bu:SetNormalTexture(textures.normal)
		nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	end
	--make the normaltexture match the buttonsize
	nt:SetAllPoints(bu)
	--hook to prevent Blizzard from reseting our colors
	-- hooksecurefunc(nt, "SetVertexColor", function(nt, r, g, b, a)
	-- 	local bu = nt:GetParent()
	-- 	local action = bu.action
	-- 	--print("bu"..bu:GetName().."R"..r.."G"..g.."B"..b)
	-- 	if r==1 and g==1 and b==1 and action and (IsEquippedAction(action)) then
	-- 		nt:SetVertexColor(color.equipped.r,color.equipped.g,color.equipped.b, 1)
	-- 	elseif r==0.5 and g==0.5 and b==1 then
	-- 		nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	-- 	elseif r==1 and g==1 and b==1 then
	-- 		nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)
	-- 	end
	-- end)

	if fbg then
		fbg:Hide()
	end

	updateHotkey(bu)
	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function stylePetButton(bu)
	if not bu or (bu and bu.styled) then return end

	local name = bu:GetName()
	local ic  = _G[name.."Icon"]
	local fl= _G[name.."Flash"]
	local nt= _G[name.."NormalTexture2"]
	nt:SetAllPoints(bu)
	--applying color
	nt:SetVertexColor(color.normal.r,color.normal.g,color.normal.b,1)

	_G[name.."NormalTexture2"]:SetAllPoints(bu)
	_G[name.."AutoCastable"]:SetAlpha(0)

	--setting the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)
	hooksecurefunc(bu, "SetNormalTexture", function(self, texture)
		--make sure the normaltexture stays the way we want it
		if texture and texture ~= textures.normal then
			self:SetNormalTexture(textures.normal)
		end
	end)

	

	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)
	ic:SetDrawLayer("OVERLAY")

	updateHotkey(bu)
	if not bu.bg then applyBackground(bu) end

	bu.styled = true
end

local function styleStanceButton(bu)
	if not bu or (bu and bu.styled) then return end

--	local ic  = bu.icon
	local name = bu:GetName()
	local ic= _G[name.."Icon"]
	local fl= _G[name.."Flash"]

	--setting the textures
	fl:SetTexture(textures.flash)
	bu:SetHighlightTexture(textures.hover)
	bu:SetPushedTexture(textures.pushed)
	bu:SetCheckedTexture(textures.checked)
	bu:SetNormalTexture(textures.normal)

	bu:SetNormalTexture("")
	bu:SetPushedTexture("")
	bu:SetCheckedTexture(C.media.backdrop)

	local ch = bu:GetCheckedTexture()
	ch:SetVertexColor(r/2, g/2, b/2)
	-- ch:SetDrawLayer("ARTWORK")
	ch:SetAllPoints(bu)
	ch:SetPoint("TOPLEFT", bu, 1, -1)
	ch:SetPoint("BOTTOMRIGHT", bu, -1, 1)

	ic:SetTexCoord(0.1,0.9,0.1,0.9)
	ic:SetPoint("TOPLEFT", bu, "TOPLEFT", 0, 0)
	ic:SetPoint("BOTTOMRIGHT", bu, "BOTTOMRIGHT", 0, 0)

	--applyBackground(bu)
	if not bu.bg then applyBackground(bu) end
	bu.styled = true
end

local numFlyoutButtons = 0
local function flyoutbutton()
	for i = 1, numFlyoutButtons do
		local bu = _G["SpellFlyoutButton"..i]
		if bu and not bu.styled then
			styleActionButton(bu)

			if bu:GetChecked() then
				bu:SetChecked(nil)
			end
			bu.styled = true
		end
	end
end

SpellFlyout:HookScript("OnShow", flyoutbutton)

local function styleflyout(self)
	if not self.reskinned then
		if not self.FlyoutArrow then return end
		self.FlyoutBorder:SetAlpha(0)
		self.FlyoutBorderShadow:SetAlpha(0)

		SpellFlyoutHorizontalBackground:SetAlpha(0)
		SpellFlyoutVerticalBackground:SetAlpha(0)
		SpellFlyoutBackgroundEnd:SetAlpha(0)

		self.reskinned = true
	end

	for i=1, GetNumFlyouts() do
		local x = GetFlyoutID(i)
		local _, _, numSlots, isKnown = GetFlyoutInfo(x)
		if isKnown then
			numFlyoutButtons = numSlots
			break
		end
	end
end

local function init()
	for i = 1, NUM_ACTIONBAR_BUTTONS do
		styleActionButton(_G["ActionButton"..i])
		styleActionButton(_G["VehicleMenuBarActionButton"..i])
		styleActionButton(_G["BonusActionButton"..i])
		styleActionButton(_G["MultiBarBottomLeftButton"..i])
		styleActionButton(_G["MultiBarBottomRightButton"..i])
		styleActionButton(_G["MultiBarRightButton"..i])
		styleActionButton(_G["MultiBarLeftButton"..i])
	end

	for i = 1, 6 do
		styleActionButton(OverrideActionBar["SpellButton"..i])
	end

	applyBackground(OverrideActionBarLeaveFrameLeaveButton)
	OverrideActionBarLeaveFrameLeaveButton:SetHighlightTexture("")
	local nt = OverrideActionBarLeaveFrameLeaveButton:GetNormalTexture()
	nt:SetPoint("TOPLEFT", 1, -1)
	nt:SetPoint("BOTTOMRIGHT", -1, 1)
	nt:SetTexCoord(0.0959375, 0.1579688, 0.369375, 0.4314063)

	for i = 1, NUM_PET_ACTION_SLOTS do
		stylePetButton(_G["PetActionButton"..i])
	end

	for i = 1, NUM_STANCE_SLOTS do
		styleStanceButton(_G["StanceButton"..i])
	end
	for i = 1, NUM_POSSESS_SLOTS do
		styleStanceButton(_G["PossessButton"..i])
	end

	styleExtraActionButton(ExtraActionButton1)

	hooksecurefunc("ActionButton_OnEvent", function(self, event, ...) if event == "PLAYER_ENTERING_WORLD" then ActionButton_UpdateHotkeys(self, self.buttonType) end end)
	hooksecurefunc("ActionButton_UpdateHotkeys", updateHotkey)
	hooksecurefunc("PetActionButton_SetHotkeys", updateHotkey)
	hooksecurefunc("ActionButton_UpdateFlyout", styleflyout)
end

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", init)