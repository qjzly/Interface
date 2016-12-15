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
	["HUNTER"] = { 0.2, 0.2, 0.2},
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
a:SetScript("OnEvent", function (self,event,...)
	local pclass = select(2, UnitClass("player"))
	if (UnitIsDead("player")) then return end
	-- if event == "PLAYER_REGEN_ENABLED" and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1") then
		-- allertrun(LEAVING_COMBAT.." !",0.1,1,0.1)
	-- elseif event == "PLAYER_REGEN_DISABLED" and(COMBAT_TEXT_SHOW_COMBAT_STATE=="1") then
		-- allertrun(ENTERING_COMBAT.." !",1,0.1,0.1)
	if event == "PLAYER_TARGET_CHANGED" then
		flag = 0
	elseif event == "UNIT_HEALTH" then
		if ExecuteThreshold and ((UnitName("target") and UnitCanAttack("player", "target") and not UnitIsDead("target") and ( UnitHealth("target")/UnitHealthMax("target") < ExecuteThreshold ) and flag == 0 )) and not (pclass == "DRUID" and UnitBuff("player", GetSpellInfo(768))) then
			if ((cfg.onlyshowboss and UnitLevel("target")==-1) or ( not cfg.onlyshowboss)) then
				local text = ExecuteText[pclass] or "斩杀阶段"
				allertrun(text.."!",1,0.82,0,0)
			end
			flag = 1
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		ExecuteThreshold = ClassThreshold[pclass][GetSpecialization()]
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
	elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
		ExecuteThreshold = ClassThreshold[pclass][GetSpecialization()]
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local timestamp, eventtype, hideCaster, srcGUID, srcName, srcFlags, srcRaidFlags, destGUID, destName, destFlags, destRaidFlags, param9, param10, param11, param12, param13, param14,  param15, param16, param17, param18, param19, param20 = ...
		-- print (bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY))
		if eventtype == "SPELL_CAST_SUCCESS" and (param9 == 1784 or param9 == 1856 or param9 == 5215 or param9 == 66 or param9 == 51753) and bit.band(srcFlags, COMBATLOG_OBJECT_TYPE_PLAYER) == 1024 and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_FRIENDLY) ~= 16 then
			local msg = srcName.."施放了"..select(1, GetSpellInfo(param9)).."！"
			-- allertrun(msg, RAID_CLASS_COLORS[select(2,UnitClass(unit))].r, RAID_CLASS_COLORS[select(2,UnitClass(unit))].g, RAID_CLASS_COLORS[select(2,UnitClass(unit))].b, 0)
			if IsAddOnLoaded("xCT") then xCTgen:AddMessage(msg,RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].r, RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].g, RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].b)
			else RaidNotice_AddMessage(RaidWarningFrame,msg,RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].r, RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].g, RAID_CLASS_COLORS[select(2,GetPlayerInfoByGUID(srcGUID))].b)
			end
		end
	end
end)

local tradeSkillAnnouce = CreateFrame("Frame")
tradeSkillAnnouce:RegisterEvent("CHAT_MSG_SKILL")
tradeSkillAnnouce:SetScript("OnEvent", function(self, event, message)
	UIErrorsFrame:AddMessage(message, ChatTypeInfo["SKILL"].r, ChatTypeInfo["SKILL"].g, ChatTypeInfo["SKILL"].b)
end)