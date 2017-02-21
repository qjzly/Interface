----------------------------------------------------------------------------------------
--   MAP
----------------------------------------------------------------------------------------

--  迷你地图  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
local mailicon = "Interface\\AddOns\\A4U\\media\\mail"
local lattex = "Interface\\AddOns\\A4U\\media\\lattex"
local blankTex = "Interface\\Buttons\\WHITE8x8"
local backdrop = {bgFile = blankTex, edgeFile = blankTex, edgeSize = 1, insets = { left = 0, right = 0, top = 0, bottom = 0}}

---------------------------------------------------------------------------------------------------------------------------
--  Config --  Config --  Config --  Config --  Config --  Config --  Config --  Config --  Config --  Config --  Config --
---------------------------------------------------------------------------------------------------------------------------
	
-------------
-- Options --
-------------
	scale = 1                 							-- Scale
	X = -6												-- X pos
	Y = -22												-- Y pos
	anchor = "TOPRIGHT"								    -- Anchor
	usezonetext = true									-- Use Zonetext
	hidetime = false								    -- Hide Time
	
-------------	
-- Borders --
-------------	
	useborders = true             						-- Enables or disables the white border on the minimap. True/False
	bordersize = 2										-- Border size
	rc = 0												-- Red
	gc = 0												-- Green
	bc = 0												-- Blue
	a = 1												-- Transperancy

----------
-- Font --
----------
	font = "FONTS\\ARHei.TTF"
	timefont = 14										-- Clock font size
	timeypos = -10										-- Time Y pos
	zonefont = 15										-- Zone font size
	zoneypos = 6										-- Zone Y pos

-------------
-- Latency --
-------------
	latshow = false										-- show Latency
	latbynum = false									-- use number Latency
	latfont = 12										-- Latency font size
	
------------
-- Shadow --
------------
local shadows = {
	edgeFile = "Interface\\AddOns\\A4U\\media\\outer_shadow",
	edgeSize = 6,
	insets = 1,
	color = { r = 0, g = 0, b = 0, a = 1},
}
function CreateShadow(f)
	if f.shadow then return end
	local shadow = CreateFrame("Frame", nil, f)
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	shadow:SetPoint("TOPLEFT", -3, 3)
	shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop(shadows)
	shadow:SetBackdropColor(0, 0, 0, 0)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	return shadow
end

CreateShadow(Minimap)

------------------------------------------------------------------------------------------------------------------------------------	
-- End Config-- End Config-- End Config-- End Config-- End Config-- End Config-- End Config-- End Config-- End Config-- End Config--
------------------------------------------------------------------------------------------------------------------------------------


-- Code Start --
Minimap:SetSize(150, 150)
Minimap:SetMaskTexture('Interface\\Buttons\\WHITE8x8')
Minimap:SetScale(scale)
Minimap:SetFrameStrata("LOW")
Minimap:ClearAllPoints()
Minimap:SetPoint(anchor, UIParent, X, Y)

-- Zone text
if (usezonetext == true) then
	MinimapZoneTextButton:SetParent(Minimap)
	MinimapZoneTextButton:SetPoint('CENTER', Minimap, 'TOP', 0, zoneypos)
	MinimapZoneTextButton:SetFrameStrata('LOW')
	MinimapZoneText:SetPoint("TOPLEFT","MinimapZoneTextButton","TOPLEFT", 5, 5) -- to center the minimap zone text从其他拷贝的
	MinimapZoneText:SetFont(font, zonefont, 'OUTLINE')
	MinimapZoneText:SetJustifyH"CENTER"
else
	MinimapZoneTextButton:Hide()
end

-- Border
if (useborders == true) then
    Minimap:SetBackdrop{edgeFile = 'Interface\\Buttons\\WHITE8x8', edgeSize = bordersize, insets = {left = -bordersize/2, right = -bordersize/2, top = -bordersize/2, bottom = -bordersize/2}}
    Minimap:SetBackdropColor(1, 1, 1, 1)
    Minimap:SetBackdropBorderColor(rc, gc, bc, a)
end

-- Hide Stuff
MinimapBorder:Hide()
MinimapBorderTop:Hide()
MinimapZoomIn:Hide()
MinimapZoomOut:Hide()
MiniMapVoiceChatFrame:Hide()
--GameTimeFrame:Hide()
MiniMapTracking:Hide()
MiniMapMailFrame:ClearAllPoints()
MiniMapMailFrame:SetSize(16,10)
MiniMapMailFrame:SetScale(0.9)
MiniMapMailIcon:SetTexture(mailicon)
MiniMapMailIcon:SetPoint("TOPLEFT", MiniMapMailFrame, "TOPLEFT", -1, 3)
MiniMapMailBorder:Hide()
--MinimapNorthTag:SetAlpha(0)


WorldMapFrame:HookScript("OnHide",SetMapToCurrentZone);
MiniMapWorldMapButton:Hide()

-- QueueStatus: Raid, Battelfield, 
QueueStatusMinimapButton:ClearAllPoints()
QueueStatusMinimapButton:SetPoint("BOTTOMLEFT", Minimap, -16, 30)
QueueStatusMinimapButtonIcon:SetScale(1)

-- Difficulty 
local iconScale = 1  ----------------------0.9
if (usezonetext == true) then
	iconScale = 0.8  ----------------------0.6
end

GuildInstanceDifficulty:SetParent(Minimap)
GuildInstanceDifficulty:ClearAllPoints() 
GuildInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)
GuildInstanceDifficulty:SetScale(iconScale)

MiniMapInstanceDifficulty:SetParent(Minimap)
MiniMapInstanceDifficulty:ClearAllPoints()
MiniMapInstanceDifficulty:SetPoint("TOPLEFT", Minimap, "TOPLEFT", 2, -2)
MiniMapInstanceDifficulty:SetScale(iconScale)

MiniMapChallengeMode:SetParent(Minimap)
MiniMapChallengeMode:ClearAllPoints()
MiniMapChallengeMode:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, -2)
MiniMapChallengeMode:SetScale(iconScale)

-- Default LFG icon
LFG_EYE_TEXTURES.raid = LFG_EYE_TEXTURES.default
LFG_EYE_TEXTURES.unknown = LFG_EYE_TEXTURES.default


-- Time
if (hidetime == true) then
	local f = CreateFrame("Frame", nil, UIParent)
	f:RegisterEvent("ADDON_LOADED")
	f:SetScript("OnEvent", function(self, event, name)
		if name == "Blizzard_TimeManager" then
			TimeManagerClockButton:Hide()
			TimeManagerClockButton:SetScript("OnShow", function(self)
				TimeManagerClockButton:Hide()
			end)
		end
	end)
else

	LoadAddOn('Blizzard_TimeManager')
	TimeManagerClockButton:SetSize(45,20)
	local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
	clockFrame:Hide()
	clockTime:Show()
	clockTime:SetFont(font, timefont, 'OUTLINE')
	clockTime:SetPoint('CENTER', TimeManagerClockButton, 'CENTER', 2, 2)
	TimeManagerClockButton:ClearAllPoints()
	TimeManagerClockButton:SetPoint('CENTER', Minimap, 'BOTTOM', 0, timeypos)

	local fclock=CreateFrame("Frame")
	fclock:SetScript("OnEvent", function(self, event, ...)
		if CalendarGetNumPendingInvites() > 0 then
			clockTime:SetTextColor(0, 1, 0)
		else
			clockTime:SetTextColor(1, 1, 1)
		end
	end)
	fclock:RegisterEvent("CALENDAR_UPDATE_PENDING_INVITES")
	fclock:RegisterEvent("PLAYER_ENTERING_WORLD")

	--Location
	local flocat=CreateFrame("Frame")
	flocat:SetScript("OnEvent", function(self, event, ...)
		SetMapToCurrentZone()
	end)
	flocat:RegisterEvent("ZONE_CHANGED_INDOORS")
	flocat:RegisterEvent("ZONE_CHANGED_NEW_AREA")

	local location = TimeManagerClockButton:CreateFontString()
	location:SetFont(font, timefont, 'OUTLINE')
	location:SetPoint('CENTER', TimeManagerClockButton, 'CENTER', 2, 2)
	location:Hide()
	local elapsed = 0
	flocat:SetScript("OnUpdate", function(self, e)
		elapsed = elapsed + e
		if elapsed >= 0.06 then
			local x, y = GetPlayerMapPosition("player")
			location:SetFormattedText("%.1f, %.1f", x*100, y*100)
			elapsed = 0
		end
	end)

	local origOnClick = TimeManagerClockButton:GetScript("OnClick")
	TimeManagerClockButton:SetScript("OnClick", function(self, button)
		if button == "RightButton" then
			Stopwatch_Toggle()
		elseif (button == "MiddleButton") then
			if clockTime:IsShown() then
				clockTime:Hide()
				location:Show()
			else
				clockTime:Show()
				location:Hide()
			end
		else
			origOnClick(self, button)
		end
	end)
end

-- Mail
if (usezonetext == true) then
	local clockFrame, clockTime = TimeManagerClockButton:GetRegions()
	local relativePoint = "TOP"
	if (hidetime == true) then
		relativePoint = "BOTTOM"
	end
	MiniMapMailFrame:SetPoint("BOTTOM", clockFrame, relativePoint, 0, 6)
else
	MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, 3, 3)
end

-- Mouse
Minimap:EnableMouseWheel(true)
Minimap:SetScript('OnMouseWheel', function(self, delta)
    if delta > 0 then
        Minimap_ZoomIn()
    else
        Minimap_ZoomOut() 
    end
end)

Minimap:SetScript('OnMouseUp', function(self, button)
    if (button == "RightButton") then
        ToggleDropDownMenu(1, nil, MiniMapTrackingDropDown, self, - (Minimap:GetWidth() * 0.7), -3)
    elseif (button == "MiddleButton") then
        ToggleCalendar()
    else
        Minimap_OnClick(self)
    end
end)

function GetMinimapShape() return 'SQUARE' end

---------------------------------------------------
-- latency icon
---------------------------------------------------
local lattimer = 0
local hlatency,wlatency,_

local function RGBPercToHex(r,g,b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

local latcfg = {
	color = {
		["low"]  = RGBPercToHex(0,0.8,0),
		["mid"]  = RGBPercToHex(0.8,0.8,0),
		["high"] = RGBPercToHex(0.8,0,0)
	},
	coords = {
		["low"]  = {0, 14/64, 0, 14/16},
		["mid"]  = {14/64, 28/64, 0, 14/16},
		["high"] = {28/64, 42/64, 0, 14/16}
	}
}
local function getLatLevel(wlatency)
	if wlatency <= 125 then
		return "low"
	elseif wlatency <= 300 then
		return "mid"
	else
		return "high"
	end
end

local function InitLatencyModule()
	local f = CreateFrame("Frame", "latency", Minimap)
	f:SetSize(14,14)
	f:ClearAllPoints()
	f:SetPoint("BOTTOMRIGHT", Minimap, "BOTTOMRIGHT", -3, 3)

	local lat
	if latbynum then
		lat = f:CreateFontString("latencyText")
		lat:ClearAllPoints()
		lat:SetPoint("RIGHT", f, 1, -2)
		lat:SetFont(font, latfont, 'OUTLINE')
		lat:SetJustifyH"RIGHT"
	else
		lat = f:CreateTexture("latTexure","BACKGROUND",nil,nil)
        lat:SetTexture(lattex)
		lat:SetPoint("RIGHT")
		lat:SetSize(14,14)
	end

	f:SetScript("OnUpdate", function(self, elapsed)
		lattimer = lattimer + elapsed
		if lattimer >= 1 then
			_,_,hlatency,wlatency = GetNetStats()
			if latbynum then
				lat:SetText("|cff"..latcfg.color[getLatLevel(wlatency)]..wlatency.."ms")
			else
				lat:SetTexCoord(unpack(latcfg.coords[getLatLevel(wlatency)]))
			end
			lattimer = 0
		end
	end)

	--tooltips
	local tt = GameTooltip
	f:SetScript("OnEnter", function(self)
			tt:SetOwner(self, "ANCHOR_TOPRIGHT")
			tt:AddLine("Latency Stats")
			tt:AddDoubleLine("UI latency:", hlatency.." ms", 1,1,1,1,1,1)
			tt:AddDoubleLine("World latency:", wlatency.." ms", 1,1,1,1,1,1)
			tt:Show()
		end)
	f:SetScript("OnLeave", function() tt:Hide() end)
end

if latshow then
	InitLatencyModule()
end










--  小地图显示坐标  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
MinimapCluster:SetScript("OnUpdate", function() 
local px, py = GetPlayerMapPosition("player") 
local zone = GetMinimapZoneText() 
if px == 0 and py == 0 then 
MinimapZoneText:SetText(zone) 
else 
MinimapZoneText:SetText(zone..(format(" %d,%d", px*100, py*100))) 
end 
end) 

MinimapCluster:HookScript("OnEvent", function(self, event, ...) 
if event == "ZONE_CHANGED_NEW_AREA" and not WorldMapFrame:IsShown() then 
SetMapToCurrentZone() 
end 
end) 
WorldMapFrame:HookScript("OnHide", SetMapToCurrentZone) 

MinimapZoomIn:Hide() 
MinimapZoomOut:Hide() 
Minimap:EnableMouseWheel(true) 
Minimap:SetScript("OnMouseWheel", function(self, y) 
if y > 0 then 
MinimapZoomIn:Click() 
else 
MinimapZoomOut:Click() 
end 
end) 

Minimap:SetMovable(true) 
Minimap:SetClampedToScreen(true) 
Minimap:SetScript("OnMouseDown", function(self) 
if IsShiftKeyDown() then 
self:ClearAllPoints() 
self:StartMoving() 
end 
end) 
Minimap:HookScript("OnMouseUp", function(self) self:StopMovingOrSizing() end)










--  小地图隐藏日历、要塞图标  --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
GarrisonLandingPageMinimapButton:ClearAllPoints()
GarrisonLandingPageMinimapButton:SetWidth(40)
GarrisonLandingPageMinimapButton:SetHeight(40)
GarrisonLandingPageMinimapButton:SetPoint("BOTTOMLEFT", Minimap, -20, -20)
GarrisonLandingPageMinimapButton:SetAlpha(0)
GarrisonLandingPageMinimapButton:SetScript("OnEnter", function()
	GarrisonLandingPageMinimapButton:FadeIn()
end)
GarrisonLandingPageMinimapButton:SetScript("OnLeave", function()
	GarrisonLandingPageMinimapButton:FadeOut()
end)


GameTimeFrame:ClearAllPoints()
GameTimeFrame:SetPoint("TOPRIGHT", Minimap, 14, 14)
GameTimeFrame:SetAlpha(0)
GameTimeFrame:SetScript("OnEnter", function()
	GameTimeFrame:FadeIn()
end)
GameTimeFrame:SetScript("OnLeave", function()
	GameTimeFrame:FadeOut()
end)


local function FadeIn(f)
	UIFrameFadeIn(f, 0.4, f:GetAlpha(), 1)
end

local function FadeOut(f)
	UIFrameFadeOut(f, 0.8, f:GetAlpha(), 0)
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
end

local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)

object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end
	object = EnumerateFrames(object)
end










--  大地图坐标  ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
WorldMapButton:HookScript("OnUpdate", function(self) 
   if not self.coordText then 
      self.coordText = WorldMapFrameCloseButton:CreateFontString(nil, "OVERLAY", "GameFontNormalOutline") 
      self.coordText:SetPoint("BOTTOM", self, "BOTTOM", 0, 6) 
   end 
   local px, py = GetPlayerMapPosition("player") 
   local x, y = GetCursorPosition() 
   local width, height, scale = self:GetWidth(), self:GetHeight(), self:GetEffectiveScale() 
   local centerX, centerY = self:GetCenter() 
   x, y = (x/scale - (centerX - (width/2))) / width, (centerY + (height/2) - y/scale) / height 
   if px == 0 and py == 0 and (x > 1 or y > 1 or x < 0 or y < 0) then 
      self.coordText:SetText("") 
   elseif px == 0 and py == 0 then 
      self.coordText:SetText(format("鼠标: %d, %d", x*100, y*100)) 
   elseif x > 1 or y > 1 or x < 0 or y < 0 then 
      self.coordText:SetText(format("玩家: %d, %d", px*100, py*100)) 
   else 
      self.coordText:SetText(format("玩家: %d, %d    鼠标: %d, %d", px*100, py*100, x*100, y*100)) 
   end 
end)









