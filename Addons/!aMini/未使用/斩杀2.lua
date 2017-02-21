local cfg = {}
cfg.enableexecute = true
cfg.onlyshowboss = false
cfg.font = "Fonts\\ARKai_C.ttf"
cfg.fontflag = "OUTLINE" -- for pixelcfg.font stick to this else OUTLINE or THINOUTLINE
cfg.fontsize = 24 -- cfg.font size
cfg.iconsize = 24
band = bit.band

local announce = CreateFrame("Frame")
local COMBATLOG_OBJECT_AFFILIATION_MINE = COMBATLOG_OBJECT_AFFILIATION_MINE

local ClassThreshold = {
	["WARRIOR"] = { 0, 0, 0},--{ 0.2, 0.2, 0},
	["DRUID"] = { 0, 0, 0},--{ 0, 0.25, 0},
	["PALADIN"] = { 0, 0, 0},--{ 0, 0, 0.2},
	["PRIEST"] = { 0, 0, 0.2},
	["DEATHKNIGHT"] = { 0, 0.35, 0},
	["WARLOCK"] = { 0, 0, 0},--{ 0.25, 0.25, 0.25},
	["ROGUE"] = { 0, 0, 0},--{ 0.35, 0, 0},
	["HUNTER"] = { 0.2, 0.35, 0},
	["MAGE"] = { 0, 0, 0},--{ 0, 0.35, 0},
	["SHAMAN"] = { 0, 0, 0},	
	["MONK"] = { 0, 0, 0},--
}
local ExecuteText = {
	["WARRIOR"] = GetSpellInfo(5308),--"斩杀",
	["PALADIN"] = GetSpellInfo(24275),--"愤怒之锤",
	["PRIEST"] = GetSpellInfo(129176),--"暗言术：灭",
 	--["WARLOCK"] = GetSpellInfo(1120),--"吸取灵魂",
	--["ROGUE"] = GetSpellInfo(53),--"背刺",
	["HUNTER"] = GetSpellInfo(53351),--"杀戮射击",
	["DEATHKNIGHT"] = GetSpellInfo(114866),--"灵魂收割",
}

local ExecuteThreshold, flag = ClassThreshold[select(2, UnitClass("player"))][GetSpecialization()], 1
 



-------------------------------------------------------------------------------------
-- Credit Alleykat 
-- Entering combat and allertrun function (can be used in anther ways)
------------------------------------------------------------------------------------
local speed = .057799924 -- how fast the text appears
cfg.fontflag = "OUTLINE" -- for pixelcfg.font stick to this else OUTLINE or THINOUTLINE
cfg.fontsize = 24 -- cfg.font size
 
local GetNextChar = function(word,num)
	local c = word:byte(num)
	local shift
	if not c then return "",num end
		if (c > 0 and c <= 127) then
			shift = 1
		elseif (c >= 192 and c <= 223) then
			shift = 2
		elseif (c >= 224 and c <= 239) then
			shift = 3
		elseif (c >= 240 and c <= 247) then
			shift = 4
		end
	return word:sub(num,num+shift-1),(num+shift)
end
 
local updaterun = CreateFrame("Frame")
 
local flowingframe = CreateFrame("Frame",nil,UIParent)
flowingframe:SetFrameStrata("HIGH")
flowingframe:SetPoint("CENTER",UIParent,0, 50) -- where we want the textframe
flowingframe:SetHeight(64)
 
local flowingtext = flowingframe:CreateFontString(nil,"OVERLAY")
flowingtext:SetFont(cfg.font,cfg.fontsize, cfg.fontflag)
flowingtext:SetShadowOffset(1.5,-1.5)
 
local rightchar = flowingframe:CreateFontString(nil,"OVERLAY")
rightchar:SetFont(cfg.font,60, cfg.fontflag)
rightchar:SetShadowOffset(1.5,-1.5)
rightchar:SetJustifyH("LEFT") -- left or right
 
local count,len,step,word,stringE,a,backstep
 
local nextstep = function()
	a,step = GetNextChar (word,step)
	flowingtext:SetText(stringE)
	stringE = stringE..a
	a = string.upper(a)
	rightchar:SetText(a)
end
 
local backrun = CreateFrame("Frame")
backrun:Hide()
 
local updatestring = function(self,t)
	count = count - t
		if count < 0 then
			count = speed
			if step > len then
				self:Hide()
				flowingtext:SetText(stringE)
				rightchar:SetText()
				flowingtext:ClearAllPoints()
				flowingtext:SetPoint("RIGHT")
				flowingtext:SetJustifyH("RIGHT")
				rightchar:ClearAllPoints()
				rightchar:SetPoint("RIGHT",flowingtext,"LEFT")
				rightchar:SetJustifyH("RIGHT")
				self:Hide()
				count = 1.456789
				backrun:Show()
			else
				nextstep()
			end
		end
end
 
updaterun:SetScript("OnUpdate",updatestring)
updaterun:Hide()
 
local backstepf = function()
	local a = backstep
	local firstchar
		local texttemp = ""
		local flagon = true
		while a <= len do
			local u
			u,a = GetNextChar(word,a)
			if flagon == true then
				backstep = a
				flagon = false
				firstchar = u
			else
				texttemp = texttemp..u
			end
		end
	flowingtext:SetText(texttemp)
	firstchar = string.upper(firstchar)
	rightchar:SetText(firstchar)
end
 
local rollback = function(self,t)
	count = count - t
		if count < 0 then
			count = speed
			if backstep > len then
				self:Hide()
				flowingtext:SetText()
				rightchar:SetText()
			else
				backstepf()
			end
		end
end
 
backrun:SetScript("OnUpdate",rollback)
 
local allertrun = function(f,r,g,b,s)
	if s then speed = s else speed = .057799924 end
	-- if f == "斩杀！！" then flowingframe:SetScale(1.8);speed = 0 else flowingframe:SetScale(1);speed = .057799924 end
	flowingframe:Hide()
	updaterun:Hide()
	backrun:Hide()
 
	flowingtext:SetText(f)
	local l = flowingtext:GetWidth()
 
	local color1 = r or 1
	local color2 = g or 1
	local color3 = b or 1
 
	flowingtext:SetTextColor(color1*.95,color2*.95,color3*.95) -- color in RGB(red green blue)(alpha)
	rightchar:SetTextColor(color1,color2,color3)
 
	word = f
	len = f:len()
	step,backstep = 1,1
	count = speed
	stringE = ""
	a = ""
 
	flowingtext:SetText("")
	flowingframe:SetWidth(l)
	flowingtext:ClearAllPoints()
	flowingtext:SetPoint("LEFT")
	flowingtext:SetJustifyH("LEFT")
	rightchar:ClearAllPoints()
	rightchar:SetPoint("LEFT",flowingtext,"RIGHT")
	rightchar:SetJustifyH("LEFT")
 
	rightchar:SetText("")
	updaterun:Show()
	flowingframe:Show()
end
 
SlashCmdList.ALLEYRUN = function(lol) allertrun(lol) end
SLASH_ALLEYRUN1 = "/arn" -- /command to test the text

--CombatText:UnregisterEvent("PLAYER_REGEN_ENABLED")
--CombatText:UnregisterEvent("PLAYER_REGEN_DISABLED")

SetCVar("fctCombatState", "0")
local a = CreateFrame ("Frame")
a:RegisterEvent("PLAYER_REGEN_ENABLED")
a:RegisterEvent("PLAYER_REGEN_DISABLED")
a:RegisterEvent("PLAYER_ENTERING_WORLD")
-- a:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
a:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
if cfg.enableexecute then
	a:RegisterEvent("UNIT_HEALTH")
	a:RegisterEvent("PLAYER_TARGET_CHANGED")
	a:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
end

local tradeSkillAnnouce = CreateFrame("Frame")
tradeSkillAnnouce:RegisterEvent("CHAT_MSG_SKILL")
tradeSkillAnnouce:SetScript("OnEvent", function(self, event, message)
	UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
end)