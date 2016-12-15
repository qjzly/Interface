
function SkadaFormatNumber(self,number)
	if number then
	if self.db.profile.numberformat == 1 then
		if number > 100000000 then -- 亿
			return ("%02.2f亿"):format(number / 100000000)
		end
		if number > 100000 then    -- 十万
			return ("%d万"):format(number / 10000)
		end
			return ("%02.2f万"):format(number / 10000)
		else
			return math.floor(number)
		end
	end
end

-------------------------------------------------------------------------
--Cache global variables
--Lua functions
local _G = _G
local type = type
local hooksecurefunc = hooksecurefunc
local unpack = unpack
local select = select
local getmetatable = getmetatable
local CreateFrame = CreateFrame

local function Kill(object)
	if object.UnregisterAllEvents then
		object:UnregisterAllEvents()
		object:SetParent(HiddenFrame)
	else
		object.Show = object.Hide
	end
	object:Hide()
end

local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end

local function addapi(object)
	local mt = getmetatable(object).__index
	if not object.Size then mt.Size = Size end
	if not object.Point then mt.Point = Point end
	if not object.SetTemplate then mt.SetTemplate = SetTemplate end
	if not object.CreatePanel then mt.CreatePanel = CreatePanel end
	if not object.FontTemplate then mt.FontTemplate = FontTemplate end
	if not object.CreateShadow then mt.CreateShadow = CreateShadow end
	if not object.Kill then mt.Kill = Kill end
	if not object.StyleButton then mt.StyleButton = StyleButton end
	if not object.Width then mt.Width = Width end
	if not object.Height then mt.Height = Height end
	if not object.SetOutside then mt.SetOutside = SetOutside end
	if not object.SetInside then mt.SetInside = SetInside end
	if not object.FadeIn then mt.FadeIn = FadeIn end
	if not object.FadeOut then mt.FadeOut = FadeOut end
	if not object.CreateBorder then mt.CreateBorder = CreateBorder end
	if not object.StripTextures then mt.StripTextures = StripTextures end
end
local handled = {["Frame"] = true}
local object = CreateFrame("Frame")
addapi(object)
addapi(object:CreateTexture())
addapi(object:CreateFontString())
object = EnumerateFrames()
while object do
	if not handled[object:GetObjectType()] then
		addapi(object)
		handled[object:GetObjectType()] = true
	end

	object = EnumerateFrames(object)
end

local frame= CreateFrame("Frame")
frame:SetScript("OnEvent", function(f, e, ...)
    if Skada.FormatNumber ~= nil and Skada.FormatNumber ~= SkadaFormatNumber then
        Skada.FormatNumber = SkadaFormatNumber
    end
end)

frame:RegisterEvent("PLAYER_ENTERING_WORLD")


local function CreateShadow(f, t)
	-- if f.shadow then return end
	local borderr, borderg, borderb = 0, 0, 0
    local backdropr, backdropg, backdropb, backdropa =  .1, .1, .1
	
	-- if t == "Background" then
        -- backdropr, backdropg, backdropb, backdropa = .1, .1, .1
    -- else
        -- backdropa = 0
    -- end

	local border = CreateFrame("Frame", nil, f) --1像素
	border:SetFrameLevel(1)
	border:SetOutside(f, -1, -1)
    border:SetTemplate("Border")
	f.border = f.border or border
	
	local shadow = CreateFrame("Frame", nil, border)  --阴影
	shadow:SetFrameLevel(1)
	shadow:SetFrameStrata(f:GetFrameStrata())
	-- shadow:SetOutside(border, 3, 3)
	shadow:SetPoint("TOPLEFT", -3, 3)
	shadow:SetPoint("BOTTOMRIGHT", 3, -3)
	shadow:SetBackdrop({
	bgFile = [[Interface\ChatFrame\ChatFrameBackground.blp]], 
	edgeFile = [[Interface\AddOns\RayWatcher\media\glowTex.tga]], 
	edgeSize = 5,
	insets = { left = 4, right = 4, top = 4, bottom = 4 }
	})

	shadow:SetBackdropColor(.05,.05,.05, .6)
	shadow:SetBackdropBorderColor(0, 0, 0, 1)
	f.shadow = shadow
	f.glow = shadow
end

local function SetTemplate(f, t, glossTex)
    if t == "Border" then
        f:SetBackdrop({
            edgeFile = [[Interface\AddOns\RayWatcher\media\glowTex.tga]], 
            edgeSize = 1,
            tile = false,
            tileSize = 0,
        })
    else
        f:SetBackdrop({
            bgFile = [[Interface\ChatFrame\ChatFrameBackground.blp]], 
            edgeFile = [[Interface\AddOns\RayWatcher\media\glowTex.tga]], 
            edgeSize = 1,
            tile = false,
            tileSize = 0,
        })
    end
end

local CreateBD = function(f, a)
	f:SetBackdrop({
		bgFile = [[Interface\ChatFrame\ChatFrameBackground.blp]], 
		edgeFile = [[Interface\AddOns\!aMini\Media\glowTex.tga]], 
		edgeSize = 1,
	})
	f:SetBackdropColor(.06, .06, .06, a or .8)
	f:SetBackdropBorderColor(0, 0, 0)

	if not a then
		f.tex = f.tex or f:CreateTexture(nil, "BACKGROUND", nil, 1)
		f.tex:SetTexture([[Interface\AddOns\!aMini\Media\StripesThin]], true, true)
		f.tex:SetAlpha(.45)
		f.tex:SetAllPoints()
		f.tex:SetHorizTile(true)
		f.tex:SetVertTile(true)
		f.tex:SetBlendMode("ADD")
	else
		f:SetBackdropColor(0, 0, 0, .8)
	end
end
local CreateSD = function(parent, size, r, g, b, alpha, offset)
	local sd = CreateFrame("Frame", nil, parent)
	sd.size = 4
	sd.offset = offset or -1
	sd:SetBackdrop({
		edgeFile = [[Interface\AddOns\!aMini\Media\glowTex]], 
		edgeSize = 4,
	})
	sd:SetPoint("TOPLEFT", -3, 3)--("TOPLEFT", parent, -sd.size - 0 - sd.offset, sd.size + 0 + sd.offset)
	sd:SetPoint("BOTTOMRIGHT", 3, -3)--("BOTTOMRIGHT", parent, sd.size + 0 + sd.offset, -sd.size - 0 - sd.offset)
	sd:SetBackdropBorderColor(.06, .06, .06)
	sd:SetAlpha(alpha or .8)
end
function SetBD(f, x, y, x2, y2)
	-- assert(f, "doesn't exist!")
	local bg = CreateFrame("Frame", nil, f)
	if not x then
		bg:SetPoint("TOPLEFT")
		bg:SetPoint("BOTTOMRIGHT")
	else
		bg:Point("TOPLEFT", x, y)
		bg:Point("BOTTOMRIGHT", x2, y2)
	end
	local level = f:GetFrameLevel() - 1
	if level < 0 then level = 0 end
	bg:SetFrameLevel(level)
	CreateBD(bg)
	CreateSD(bg)
	f:HookScript("OnShow", function()
		bg:SetFrameLevel(level)
	end)
end

function dummy()
    return
end

-------------------------------------------------------------------------
local Skada = Skada
local barSpacing = 1
local bars = 8
local windowWidth = 240

local barmod = Skada.displays["bar"]
-- Used to strip unecessary options from the in-game config
local function StripOptions(options)
	options.baroptions.args.barspacing = nil
	options.titleoptions.args.texture = nil
	options.titleoptions.args.bordertexture = nil
	options.titleoptions.args.thickness = nil
	options.titleoptions.args.margin = nil
	options.titleoptions.args.color = nil
	options.windowoptions = nil
	options.baroptions.args.barfont = nil
	options.baroptions.args.reversegrowth = nil
	options.titleoptions.args.font = nil
end

barmod.AddDisplayOptions_ = barmod.AddDisplayOptions
barmod.AddDisplayOptions = function(self, win, options)
	self:AddDisplayOptions_(win, options)
	StripOptions(options)
end

for k, options in pairs(Skada.options.args.windows.args) do
	if options.type == "group" then
		StripOptions(options.args)
	end
end

barmod.ApplySettings_ = barmod.ApplySettings
barmod.ApplySettings = function(self, win)
	barmod.ApplySettings_(self, win)

	local skada = win.bargroup

	-- if win.db.enabletitle then
		-- skada.button:SetBackdrop(nil)
	-- end
	skada:SetTexture([[Interface\AddOns\!Media\Media\Statusbar.tga]])
	skada:SetSpacing(barSpacing)
	skada:SetFrameLevel(5)

	local titlefont = CreateFont("TitleFont"..win.db.name)
	titlefont:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
	win.bargroup.button:SetNormalFontObject(titlefont)
	
	-- local color = win.db.title.color
	-- win.bargroup.button:SetBackdropColor( .6, .6, .6)

	-- skada:SetBackdrop(nil)
	-- if not skada.shadow then
		-- skada:StripTextures()
		-- skada:CreateShadow("Background")
		-- if skada.borderFrame then skada.borderFrame:Kill() end
	-- end
	-- skada.borderFrame:ClearAllPoints()
	-- skada.shadow:SetFrameStrata("BACKGROUND")
	-- if win.db.enabletitle then
		-- skada.borderFrame:Point("TOPLEFT", win.bargroup.button, "TOPLEFT", -1, 1)
	-- else
		-- skada.borderFrame:Point("TOPLEFT", win.bargroup, "TOPLEFT", -1, 1)
	-- end
	-- skada.borderFrame:Point("BOTTOMRIGHT", win.bargroup, "BOTTOMRIGHT", 1, -1)

	skada.button:SetFrameStrata("MEDIUM")
	skada.button:SetFrameLevel(5)
	skada:SetFrameStrata("MEDIUM")
	win.bargroup.button:SetFrameStrata("MEDIUM")
	win.bargroup.button:SetFrameLevel(5)	
	win.bargroup:SetFrameStrata("MEDIUM")
end

hooksecurefunc(Skada, "UpdateDisplay", function(self)
	for _,window in ipairs(self:GetWindows()) do
		if window.bargroup.shadow then window.bargroup.shadow:SetFrameStrata("BACKGROUND") end
		for i,v in pairs(window.bargroup:GetBars()) do
			if not v.BarStyled then
				v.label:ClearAllPoints()
				v.label.ClearAllPoints = dummy
				v.label:SetPoint("LEFT", v, "LEFT", 2, 0)
				v.label.SetPoint = dummy
				v.timerLabel:ClearAllPoints()
				v.timerLabel.ClearAllPoints = dummy
				v.timerLabel:SetPoint("RIGHT", v, "RIGHT", -2, 0)
				v.timerLabel.SetPoint = dummy
				v.label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
				v.label.SetFont = dummy
				v.timerLabel:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
				v.timerLabel.SetFont = dummy
				v.label:SetShadowOffset(0, 0)
				v.label.SetShadowOffset = dummy
				v.timerLabel:SetShadowOffset(0, 0)
				v.timerLabel.SetShadowOffset = dummy
				v.BarStyled = true
			end
		end
	end
end)

hooksecurefunc(Skada, "OpenReportWindow", function(self)
	if not self.ReportWindow.frame.reskinned then
		self.ReportWindow.frame:StripTextures()
		-- SetBD(self.ReportWindow.frame)
		local closeButton = self.ReportWindow.frame:GetChildren()
	    -- ReskinClose(closeButton)
		self.ReportWindow.frame.reskinned = true
	end
end)
	


local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
	window.db.barwidth = width
	window.db.barheight = barheight
	if window.db.enabletitle then
		height = height - barheight
	else
		height = height + barSpacing
	end
	window.db.background.height = height
	window.db.spark = false
	window.db.barslocked = true
	window.bargroup:ClearAllPoints()
	window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

	barmod.ApplySettings(barmod, window)
end

local windows = {}
function EmbedSkada()
	if #windows == 1 then
		EmbedWindow(windows[1], windowWidth, 180/bars - barSpacing, 180, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 30)
	elseif #windows == 2 then
		EmbedWindow(windows[1], windowWidth*3/4, 180/bars - barSpacing, 180, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -5, 30)
		EmbedWindow(windows[2], windowWidth*3/4, 180/bars - barSpacing, 180, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", - windowWidth*3/4 - 25, 30)
	end
end

-- Update pre-existing displays
for _, window in ipairs(Skada:GetWindows()) do
	window:UpdateDisplay()
end

Skada.CreateWindow_ = Skada.CreateWindow
function Skada:CreateWindow(name, db)
	Skada:CreateWindow_(name, db)

	windows = {}
	for _, window in ipairs(Skada:GetWindows()) do
		tinsert(windows, window)
	end

	EmbedSkada()
end

Skada.DeleteWindow_ = Skada.DeleteWindow
function Skada:DeleteWindow(name)
	Skada:DeleteWindow_(name)

	windows = {}
	for _, window in ipairs(Skada:GetWindows()) do
		tinsert(windows, window)
	end

	EmbedSkada()
end