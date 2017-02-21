if IsAddOnLoaded('SmartFollowerManager') then return; end
local Addon = {}
--------------------------------------------------------------------------------------------------
--    data from wowhead.com
--------------------------------------------------------------------------------------------------
if (UnitFactionGroup("player"))=="Alliance" then
	Addon.raceID = {[32]=15,[34]=8,[87]=2,[88]=6,[89]=5,[90]=6,[91]=4,[92]=2,[93]=6,[94]=2,[95]=8,[96]=8,[97]=5,[98]=8,[99]=14,[100]=14,[101]=8,[102]=2,[103]=2,[104]=14,[105]=2,[106]=2,[107]=4,[108]=14,[109]=4,[110]=5,[111]=5,[112]=8,[113]=5,[114]=4,[115]=5,[116]=8,[117]=2,[118]=10,[119]=10,[120]=10,[153]=5,[154]=2,[155]=4,[157]=9,[159]=4,[168]=41,[170]=29,[171]=28,[172]=2,[176]=4,[177]=2,[178]=2,[179]=4,[180]=14,[182]=2,[183]=9,[184]=4,[185]=4,[186]=4,[189]=30,[190]=2,[192]=7,[193]=15,[194]=31,[195]=2,[202]=2,[203]=33,[204]=2,[205]=4,[207]=4,[208]=4,[209]=12,[211]=5,[212]=4,[216]=5,[217]=8,[218]=36,[219]=29,[224]=36,[225]=9,[227]=2,[228]=14,[229]=5,[230]=14,[231]=2,[232]=8,[233]=6,[234]=6,[235]=4,[236]=5,[237]=8,[238]=14,[239]=4,[240]=2,[241]=5,[242]=2,[243]=5,[244]=8,[245]=8,[246]=14,[247]=8,[248]=14,[249]=8,[250]=14,[251]=14,[252]=14,[253]=8,[254]=14,[255]=8,[256]=14,[257]=8,[258]=14,[259]=14,[260]=8,[261]=14,[262]=8,[263]=8,[264]=8,[265]=14,[266]=8,[267]=14,[268]=8,[269]=2,[270]=14,[271]=5,[272]=8,[273]=2,[274]=8,[275]=5,[276]=2,[277]=4,[278]=5,[279]=5,[280]=14,[281]=5,[282]=10,[283]=2,[284]=8,[285]=4,[286]=2,[287]=2,[288]=6,[289]=5,[290]=8,[291]=2,[292]=8,[293]=6,[294]=14,[295]=3,[296]=5,[297]=8,[298]=10,[299]=4,[300]=2,[301]=5,[302]=2,[303]=5,[304]=8,[323]=5,[324]=2,[325]=5,[326]=5,[327]=4,[328]=2,[329]=2,[330]=2,[331]=4,[332]=4,[333]=5,[334]=5,[335]=4,[336]=2,[337]=2,[338]=4,[339]=4,[340]=5,[341]=2,[342]=2,[343]=5,[344]=10,[345]=2,[346]=8,[347]=2,[348]=6,[349]=4,[350]=6,[351]=5,[352]=14,[353]=2,[354]=8,[355]=5,[356]=14,[357]=8,[358]=8,[359]=2,[360]=14,[361]=8,[362]=6,[363]=2,[364]=8,[365]=6,[366]=10,[367]=6,[368]=2,[369]=8,[370]=14,[371]=5,[372]=5,[373]=2,[374]=8,[375]=5,[376]=6,[377]=5,[378]=5,[379]=5,[380]=5,[381]=4,[382]=5,[383]=4,[384]=5,[385]=5,[386]=10,[387]=5,[388]=5,[389]=4,[390]=4,[391]=4,[392]=4,[393]=4,[394]=5,[395]=2,[396]=2,[397]=5,[398]=2,[399]=2,[400]=2,[401]=5,[402]=6,[403]=5,[404]=6,[405]=5,[406]=14,[407]=6,[408]=14,[409]=14,[410]=14,[411]=6,[412]=2,[413]=2,[414]=14,[415]=5,[416]=8,[417]=2,[418]=8,[419]=5,[420]=10,[421]=4,[422]=2,[423]=8,[424]=14,[425]=4,[426]=5,[427]=6,[428]=2,[429]=5,[430]=8,[431]=5,[432]=10,[433]=10,[434]=34,[435]=2,[436]=10,[437]=10,[438]=5,[439]=2,[440]=8,[441]=5,[442]=6,[443]=4,[444]=6,[445]=10,[446]=2,[447]=5,[448]=35,[449]=8,[450]=8,[451]=6,[452]=6,[453]=5,[455]=6,[458]=4,[459]=4,[460]=7,[462]=42,[463]=8,[465]=2,[466]=4,[467]=10,[468]=9,[474]=37,[580]=29,[581]=6,[582]=42}
else
	Addon.raceID = {[32]=15,[34]=11,[87]=9,[88]=9,[89]=7,[90]=3,[91]=13,[92]=9,[93]=12,[94]=13,[95]=7,[96]=12,[97]=13,[98]=11,[99]=12,[100]=11,[101]=12,[102]=13,[103]=13,[104]=3,[105]=3,[106]=3,[107]=3,[108]=12,[109]=9,[110]=11,[111]=9,[112]=3,[113]=7,[114]=13,[115]=3,[116]=3,[117]=13,[118]=10,[119]=10,[120]=10,[153]=9,[154]=3,[155]=9,[157]=9,[159]=9,[168]=41,[170]=29,[171]=28,[172]=2,[176]=9,[177]=2,[178]=2,[179]=9,[180]=12,[182]=9,[183]=9,[184]=9,[185]=9,[186]=9,[189]=30,[190]=2,[192]=7,[193]=15,[194]=31,[195]=13,[202]=2,[203]=33,[204]=13,[205]=4,[207]=3,[208]=4,[209]=12,[211]=7,[212]=9,[216]=13,[217]=11,[218]=36,[219]=29,[224]=36,[225]=9,[227]=9,[228]=7,[229]=13,[230]=9,[231]=3,[232]=11,[233]=11,[234]=12,[235]=3,[236]=11,[237]=9,[238]=7,[239]=10,[240]=9,[241]=13,[242]=13,[243]=12,[244]=11,[245]=11,[246]=12,[247]=12,[248]=12,[249]=11,[250]=11,[251]=12,[252]=12,[253]=11,[254]=12,[255]=12,[256]=12,[257]=11,[258]=11,[259]=12,[260]=11,[261]=11,[262]=11,[263]=12,[264]=11,[265]=12,[266]=11,[267]=12,[268]=11,[269]=9,[270]=13,[271]=13,[272]=10,[273]=9,[274]=11,[275]=11,[276]=12,[277]=3,[278]=11,[279]=12,[280]=7,[281]=9,[282]=7,[283]=3,[284]=13,[285]=9,[286]=11,[287]=9,[288]=13,[289]=13,[290]=10,[291]=9,[292]=9,[293]=12,[294]=12,[295]=3,[296]=9,[297]=12,[298]=7,[299]=3,[300]=13,[301]=12,[302]=3,[303]=7,[304]=3,[323]=11,[324]=11,[325]=11,[326]=11,[327]=3,[328]=11,[329]=11,[330]=3,[331]=3,[332]=11,[333]=11,[334]=11,[335]=3,[336]=3,[337]=3,[338]=3,[339]=3,[340]=11,[341]=13,[342]=2,[343]=11,[344]=12,[345]=13,[346]=12,[347]=13,[348]=3,[349]=10,[350]=11,[351]=12,[352]=13,[353]=11,[354]=13,[355]=12,[356]=3,[357]=7,[358]=3,[359]=9,[360]=3,[361]=3,[362]=13,[363]=9,[364]=9,[365]=9,[366]=12,[367]=10,[368]=3,[369]=7,[370]=7,[371]=13,[372]=13,[373]=13,[374]=12,[375]=12,[376]=3,[377]=9,[378]=11,[379]=10,[380]=12,[381]=11,[382]=9,[383]=12,[384]=11,[385]=12,[386]=9,[387]=7,[388]=11,[389]=7,[390]=12,[391]=7,[392]=7,[393]=9,[394]=9,[395]=3,[396]=9,[397]=13,[398]=3,[399]=9,[400]=9,[401]=9,[402]=12,[403]=3,[404]=12,[405]=7,[406]=7,[407]=13,[408]=13,[409]=12,[410]=13,[411]=12,[412]=3,[413]=9,[414]=3,[415]=13,[416]=7,[417]=9,[418]=11,[419]=13,[420]=12,[421]=3,[422]=11,[423]=9,[424]=7,[425]=13,[426]=9,[427]=11,[428]=13,[429]=10,[430]=11,[431]=9,[432]=10,[433]=10,[434]=34,[435]=9,[436]=10,[437]=10,[438]=13,[439]=9,[440]=10,[441]=11,[442]=12,[443]=3,[444]=12,[445]=9,[446]=11,[447]=13,[448]=35,[449]=10,[450]=13,[451]=10,[452]=12,[453]=13,[455]=6,[458]=9,[459]=9,[460]=7,[462]=42,[463]=13,[465]=2,[466]=9,[467]=10,[468]=9,[474]=37,[580]=29,[581]=7,[582]=42}
end

--Represent follower for each specialization ID
Addon.specFollower = {[2] = 115, [3] = 237, [4] = 244, [5] = 462, [7] = 255, [8] = 260, [9] = 267, [10] = 274, [12] = 280, [13] = 285, [14] = 455, [15] = 297, [16] = 303, [17] = 439, [18] = 445, [19] = 452, [20] = 327, [21] = 105, [22] = 177, [23] = 345, [24] = 351, [25] = 357, [26] = 363, [27] = 370, [28] = 376, [29] = 382, [30] = 387, [31] = 394, [32] = 400, [33] = 406, [34] = 412, [35] = 225, [37] = 203, [38] = 429}

Addon.abiSpec = 
{
--Death Knight(Blood, Frost, Unholy)
	[2] = {115, 114, 116, 118, 117},
	[3] = {119, 114, 116, 118, 117},
	[4] = {115, 114, 116, 118, 117},
--Druid(Balance, Feral, Guardian, Restoration)
	[5] = {139, 182, 134, 137},--133
	[7] = {132, 138, 182, 108},--133
	[8] = {132, 182, 134, 108},--133
	[9] = {134, 137, 136, 135},--133
--Hunter(Beast Mastery, Marksmanship, Survival)
	[10] = {165, 163, 167, 101, 103},
	[12] = {166, 165, 167, 101, 103},
	[13] = {164, 165, 167, 101, 103},
--Mage(Arcane, Fire, Frost)
	[14] = {170, 171, 172, 173},--169
	[15] = {170, 5, 171, 172, 173},
	[16] = {5, 171, 168, 172, 173},
--Monk(Brewmaster, Mistweaver, Windwalker)
	[17] = {142, 141, 144, 140, 143},
	[18] = {142, 145, 143, 147},--146
	[19] = {183, 144, 140, 143, 147},
--Paladin(Holy, Protection, Retribution)
	[20] = {125, 128, 126, 127},--129
	[21] = {125, 124, 126, 123, 127},
	[22] = {131, 124, 130, 126, 127},
--Priest(Discipline, Holy, Shadow)
	[23] = {148, 151, 10, 11},--149
	[24] = {148, 10, 150, 11},--149
	[25] = {148, 151, 10, 150, 152},
--Rogue(Assassination, Combat, Subtlety)
	[26] = {159, 105, 162, 104, 160},
	[27] = {161, 105, 162, 104, 160},
	[28] = {159, 161, 105, 104, 160},
--Shaman(Elemental, Enhancement, Restoration)
	[29] = {158, 106, 154, 157, 155},
	[30] = {158, 106, 154, 156, 157},
	[31] = {106, 154, 107, 155},--153
--Warlock(Affliction, Demonology, Destruction)
	[32] = {180, 178, 176, 179, 181},
	[33] = {177, 178, 179, 181, 174},
	[34] = {175, 180, 177, 179, 181},
--Warrior(Arms, Fury, Protection)
	[35] = {120, 102, 121, 122, 100},
	[37] = {120, 102, 121, 122, 6},
	[38] = {120, 102, 121, 6, 100}
}


--Localization
Addon.L = {}

local L = Addon.L
--GARRISON_ABILITY_COUNTERS_FORMAT.."(|cFFFFFFFF%d|r,|cFFFF0000%d|r)"
if GetLocale() == "zhCN" then
	L.TextShift = "按下Shift显示其他可能的技能"
	L.TextAlt = "按下Alt显示可能的技能组合"
	L.ShiftDown = "其他可能的技能"
	L.AltDown = "可能的技能组合"
	L.AbilityCountFormat = "%s(%d/%d)"
	L.AbilityPair = "此组合: 激活%d  总计%d"
elseif GetLocale() == "zhTW" then
	L.TextShift = "按下Shift顯示其他可能的技能"
	L.TextAlt = "按下Alt顯示可能的技能組合"
	L.ShiftDown = "其他可能的技能"
	L.AltDown = "可能的技能組合"
	L.AbilityCountFormat = "%s(%d/%d)"
	L.AbilityPair = "此組合: 任用%d  總計%d"

else --enUS
	L.TextShift = "Press SHIFT to show other abilities..."
	L.TextAlt = "Press ALT to show ability pairs..."
	L.ShiftDown = "Other Abilities"	--need review
	L.AltDown = "Ability Pairs"
	L.AbilityCountFormat = "%s(%d/%d)"
	L.AbilityPair = "This Pair: Active %d  Total %d"
end

-- RaceName
if GetLocale() == "zhCN" then
	L.raceName = 
	{
		[2] = "人类",
		[3] = "血精灵",
		[4] = "德莱尼",
		[5] = "矮人",
		[6] = "侏儒",
		[7] = "地精",
		[8] = "暗夜精灵",
		[9] = "兽人",
		[10] = "熊猫人",
		[11] = "牛头人",
		[12] = "巨魔",
		[13] = "亡灵",
		[14] = "狼人",
		[15] = "食人魔",
		[28] = "机械",
		[29] = "刃牙虎人",
		[30] = "独眼魔",
		[31] = "木精",
		[33] = "豺狼人",
		[34] = "锦鱼人",
		[35] = "猢狲",
		[36] = "鸦人流亡者",
		[37] = "狂兽人",
		[41] = "埃匹希斯守卫",
		[42] = "高等鸦人"
	}
elseif GetLocale() == "zhTW" then
	L.raceName = 
	{
		[2] = "人類",
		[3] = "血精靈",
		[4] = "德萊尼",
		[5] = "矮人",
		[6] = "地精",
		[7] = "哥布林",
		[8] = "夜精靈",
		[9] = "獸人",
		[10] = "熊貓人",
		[11] = "牛頭人",
		[12] = "食人妖",
		[13] = "不死族",
		[14] = "狼人",
		[15] = "巨魔",
		[28] = "機械",
		[29] = "劍齒人",
		[30] = "歐格隆",
		[31] = "波塔尼",
		[33] = "豺狼人",
		[34] = "錦魚人",
		[35] = "猴人",
		[36] = "阿拉卡流亡者",
		[37] = "狂獸人",
		[41] = "頂尖守護者",
		[42] = "高等阿拉卡人"
	}

else --enUS
	L.raceName = 
	{
		[2] = "Human",
		[3] = "Blood Elf",
		[4] = "Draenei",
		[5] = "Dwarf",
		[6] = "Gnome",
		[7] = "Goblin",
		[8] = "Night Elf",
		[9] = "Orc",
		[10] = "Pandaren",
		[11] = "Tauren",
		[12] = "Troll",
		[13] = "Undead",
		[14] = "Worgen",
		[15] = "Ogre",
		[28] = "Mechanical",
		[29] = "Saberon",
		[30] = "Ogron",
		[31] = "Botani",
		[33] = "Gnoll",
		[34] = "Jinyu",
		[35] = "Hozen",
		[36] = "Outcast Arakkoa",
		[37] = "Dire Orc",
		[41] = "Apexis Guardian",
		[42] = "High Arakkoa",
	}
end


--DataAPI
local race = Addon.raceID
local raceName = Addon.L.raceName
local specFollower = Addon.specFollower

local API = {}

function API.GetClassSpecNameBySpecID(specID)
	local garrFollowerID = specFollower[specID]
	if garrFollowerID then
		return C_Garrison.GetFollowerClassSpecName(garrFollowerID)
	end
end

function API.GetRaceID(garrFollowerID)
	local id = garrFollowerID
	if not id then
		return
	end
	if type(id) == "string" then
		id = tonumber(id)
	end
	
	return race[id]
end

function API.GetRaceName(garrFollowerID)
	local id = garrFollowerID
	if not id then
		return
	end
	if type(id) == "string" then
		id = tonumber(id)
	end
	
	local rID = race[id]
	if not rID then
		return
	end
	
	local rName = raceName[rID]
	if not rName then
		rName = OTHER
	end
	
	return rName
end

Addon.API = API

local GarrisonFollowerTooltip_Owner = Addon.GarrisonFollowerTooltip_Owner
local Override = {}

local GARRISON_FOLLOWER_TOOLTIP = {};
function Override.GarrisonFollowerTooltip_Show(garrisonFollowerID, collected, quality, level, xp, levelxp, itemLevel, spec1, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, noAbilityDescriptions, underBiased, tooltipFrame, xpWidth)
	GARRISON_FOLLOWER_TOOLTIP.garrisonFollowerID = garrisonFollowerID;
	GARRISON_FOLLOWER_TOOLTIP.followerTypeID = C_Garrison.GetFollowerTypeByID(garrisonFollowerID);
	GARRISON_FOLLOWER_TOOLTIP.collected = collected;
	GARRISON_FOLLOWER_TOOLTIP.hyperlink = false;
	GARRISON_FOLLOWER_TOOLTIP.name = C_Garrison.GetFollowerNameByID(garrisonFollowerID);
	GARRISON_FOLLOWER_TOOLTIP.spec = C_Garrison.GetFollowerClassSpecByID(garrisonFollowerID);
	GARRISON_FOLLOWER_TOOLTIP.portraitIconID = C_Garrison.GetFollowerPortraitIconIDByID(garrisonFollowerID);
	GARRISON_FOLLOWER_TOOLTIP.quality = quality;
	GARRISON_FOLLOWER_TOOLTIP.level = level;
	GARRISON_FOLLOWER_TOOLTIP.xp = xp;
	GARRISON_FOLLOWER_TOOLTIP.levelxp = levelxp;
	GARRISON_FOLLOWER_TOOLTIP.iLevel = itemLevel;
	GARRISON_FOLLOWER_TOOLTIP.spec1 = spec1;
	GARRISON_FOLLOWER_TOOLTIP.ability1 = ability1;
	GARRISON_FOLLOWER_TOOLTIP.ability2 = ability2;
	GARRISON_FOLLOWER_TOOLTIP.ability3 = ability3;
	GARRISON_FOLLOWER_TOOLTIP.ability4 = ability4;
	GARRISON_FOLLOWER_TOOLTIP.trait1 = trait1;
	GARRISON_FOLLOWER_TOOLTIP.trait2 = trait2;
	GARRISON_FOLLOWER_TOOLTIP.trait3 = trait3;
	GARRISON_FOLLOWER_TOOLTIP.trait4 = trait4;
	GARRISON_FOLLOWER_TOOLTIP.isMaxLevel = (level >= GARRISON_FOLLOWER_MAX_LEVEL)
	GARRISON_FOLLOWER_TOOLTIP.isTroop = C_Garrison.GetFollowerIsTroop(garrisonFollowerID);
	GARRISON_FOLLOWER_TOOLTIP.noAbilityDescriptions = noAbilityDescriptions;
	GARRISON_FOLLOWER_TOOLTIP.underBiased = underBiased;

	if (not tooltipFrame) then
		if (GARRISON_FOLLOWER_TOOLTIP.followerTypeID == LE_FOLLOWER_TYPE_SHIPYARD_6_2) then
			tooltipFrame = GarrisonShipyardFollowerTooltip;
		else
			tooltipFrame = GarrisonFollowerTooltip;
		end
	end

	if (GARRISON_FOLLOWER_TOOLTIP.followerTypeID == LE_FOLLOWER_TYPE_SHIPYARD_6_2) then
		GarrisonFollowerTooltipTemplate_SetShipyardFollower(tooltipFrame, GARRISON_FOLLOWER_TOOLTIP, xpWidth);
	else
		GarrisonFollowerTooltipTemplate_SetGarrisonFollower(tooltipFrame, GARRISON_FOLLOWER_TOOLTIP, xpWidth);
	end
	tooltipFrame:Show();
end

GarrisonFollowerTooltip_Show_Override = Override.GarrisonFollowerTooltip_Show
--GarrisonFollowerTooltip_Show = Override.GarrisonFollowerTooltip_Show

function GarrisonFollowerTooltip_Show(garrisonFollowerID, collected, quality, level, xp, levelxp, itemLevel, spec1, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, noAbilityDescriptions, underBiased, tooltipFrame, xpWidth)
	if type(trait4) ~= "number" then
		Override.GarrisonFollowerTooltip_Show(garrisonFollowerID, collected, quality, level, xp, levelxp, itemLevel, 0, spec1, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, noAbilityDescriptions, underBiased, tooltipFrame)
	else
		Override.GarrisonFollowerTooltip_Show(garrisonFollowerID, collected, quality, level, xp, levelxp, itemLevel, spec1, ability1, ability2, ability3, ability4, trait1, trait2, trait3, trait4, noAbilityDescriptions, underBiased, tooltipFrame, xpWidth)
	end
end
Addon.Override = Override
local API = Addon.API
local GarrisonFollowerTooltip_Owner = Addon.GarrisonFollowerTooltip_Owner
local Override = Addon.Override

local function GetRecruitLink(index)
	local follower = C_Garrison.GetAvailableRecruits()[index];
	local link;
	local lvl = follower.level;
	local iLvl = follower.iLevel
	local id = follower.followerID;
	local quality = follower.quality;
	local name = follower.name;
	local abilities = {0, 0, 0, 0};
	local traits = {0, 0, 0, 0};
	local color = ITEM_QUALITY_COLORS[quality].hex
	
	local abilityIndex = 0;
	local traitIndex = 0;
	
	local rec = C_Garrison.GetRecruitAbilities(index)
	for _, ability in pairs(rec) do
		if not ability.isTrait then
			abilityIndex = abilityIndex + 1;
			abilities[abilityIndex] = ability.id;
		else
			traitIndex = traitIndex + 1;
			traits[traitIndex] = ability.id;
		end
	end
	
	link = string.format("%s|Hgarrfollower:%d:%d:%d:%d", color, id, quality, lvl, iLvl);
	for i= 1, 4 do
		link = link .. ":" .. abilities[i];
	end
	for i= 1, 4 do
		link = link .. ":" .. traits[i];
	end
	link = string.format("%s|h[%s]|h|r", link, name);
	
	return link;
end

local function RecruitLink_OnClick(self)
	if not IsModifiedClick("CHATLINK") then
		return
	end
	
	local frame = self:GetParent();
	local index = frame.index;
	
	local link = GetRecruitLink(index);
	local editBox
	
	for i = 1, NUM_CHAT_WINDOWS do
		editBox = _G[format("%s%d%s", "ChatFrame", i, "EditBox")];
		if editBox:HasFocus() then
			editBox:Insert(link);
		end
	end
end
local function RecruitLink_OnEnter(self)
	local index = self:GetParent().index
	local follower = C_Garrison.GetAvailableRecruits()[index];
	local lvl = follower.level;
	local iLvl = follower.iLevel
	local id = follower.followerID;
	local quality = follower.quality;
	local name = follower.name;
	local abilities = {0, 0, 0, 0};
	local traits = {0, 0, 0, 0};
	
	local abilityIndex = 0;
	local traitIndex = 0;
	
	for _, ability in pairs(C_Garrison.GetRecruitAbilities(index)) do
		if not ability.isTrait then
			abilityIndex = abilityIndex + 1;
			abilities[abilityIndex] = ability.id;
		else
			traitIndex = traitIndex + 1;
			traits[traitIndex] = ability.id;
		end
	end
	
	GarrisonFollowerTooltip_Owner = self
	GarrisonFollowerTooltip:ClearAllPoints()
	GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
	
	GarrisonFollowerTooltip_Show(id, false, quality, lvl, 0, 0, iLvl, 0, abilities[1], abilities[2], abilities[3], abilities[4], traits[1], traits[2], traits[3], traits[4], false)
end
local function RecruitLink_OnLeave(self)
	if GarrisonFollowerTooltip_Owner == self then
		GarrisonFollowerTooltip:Hide()
		GarrisonFollowerTooltip_Owner = nil
	end
end

local function ShowRecruitInfo(waiting)
	if waiting then 
		return 
	end

	local followers = C_Garrison.GetAvailableRecruits();
	local id, frame, btn;
	local color = NORMAL_FONT_COLOR;
	if next(followers) ~= nil then
		for i = 1, 3 do
			id = followers[i].followerID;
			frame = GarrisonRecruitSelectFrame.FollowerSelection["Recruit"..i];
			
			frame.race = frame.race or frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
			frame.class = frame.class or frame:CreateFontString(nil, "ARTWORK", "GameFontHighlight");
			
			frame.race:SetText(API.GetRaceName(id));
			frame.class:SetText(followers[i].className);
			
			frame.race:SetPoint("TOPLEFT", frame.PortraitFrame, "BOTTOMLEFT", 8, -5);
			frame.class:SetPoint("TOPLEFT", frame.race, "BOTTOMLEFT", 0 , 0);
			
			if frame.Abilities:IsShown() then
				frame.Abilities:SetPoint("TOPLEFT", frame.class, "BOTTOMLEFT", 0 , -5);
				if frame.Traits:IsShown() then
					frame.Traits:SetPoint("TOPLEFT", frame.Abilities, "BOTTOMLEFT", 0 , 0);
				end
			else
				frame.Traits:SetPoint("TOPLEFT", frame.class, "BOTTOMLEFT", 0 , -5);
			end
			
			frame.class:SetVertexColor(color.r, color.g, color.b);
			
			frame.race:Show();
			frame.class:Show();
			frame.index = i;
			
			if not frame.btnLink then
				btn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate");
				btn:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0);
				btn:SetWidth(188);
				btn:SetHeight(50);
				btn:SetScript("OnClick", RecruitLink_OnClick);
				btn:SetScript("OnEnter", RecruitLink_OnEnter);
				btn:SetScript("OnLeave", RecruitLink_OnLeave);
				btn:SetAlpha(0.0);
				frame.btnLink = btn;
			end
		end
	end
end

--function Addon.LoadWithUI.SmartRecruiter()
	hooksecurefunc("GarrisonRecruitSelectFrame_UpdateRecruits", ShowRecruitInfo)
--end


--local GarrisonFollowerTooltip_Owner = Addon.GarrisonFollowerTooltip_Owner
local FGFTData = {isMaxLevel = false}
local GFTData = {isMaxLevel = false}
local AbilitiesData
local strLPair = Addon.L.AbilityPair

local GetFollowerAbilityCounterMechanicInfo = C_Garrison.GetFollowerAbilityCounterMechanicInfo

local bShiftKeyDown
local bAltKeyDown
local frameCheckModifier = CreateFrame("Frame")
local tModifierCheck
local KeyMode = 0 --0="NORMAL",1="SHIFT",2="ALT"

local function UpdateFollowerTooltips()
	if FloatingGarrisonFollowerTooltip:IsShown() then
		GarrisonFollowerTooltipTemplate_SetGarrisonFollower(FloatingGarrisonFollowerTooltip, FGFTData)
	end
	if GarrisonFollowerTooltip:IsShown() and (GFTData.noAbilityDescriptions ~= true) then
		GarrisonFollowerTooltipTemplate_SetGarrisonFollower(GarrisonFollowerTooltip, GFTData);
	end
end
local function ModifierStateChanged(self, event, key, state)
	if key ~= "LSHIFT" and key ~= "RSHIFT" and key ~= "LALT" and key ~= "RALT" then
		return
	end
	bShiftKeyDown = IsShiftKeyDown()
	bAltKeyDown = IsAltKeyDown()
	
	if (not bShiftKeyDown) and (not bAltKeyDown) then
		KeyMode = 0	--NORMAL
	elseif bShiftKeyDown and (not bAltKeyDown) then
		KeyMode = 1	--SHIFT
	elseif (not bShiftKeyDown) and bAltKeyDown then
		KeyMode = 2	--ALT
	end
	
	UpdateFollowerTooltips()
end
local function ModifierStateCheck(self, elapsed)
	if tModifierCheck and tModifierCheck < 1 then
		tModifierCheck = tModifierCheck + elapsed
		return
	end
	
	tModifierCheck = 0
	if bShiftKeyDown ~= IsShiftKeyDown() then
		ModifierStateChanged(nil, "MODIFIER_STATE_CHANGED", "LSHIFT", bShiftKeyDown and 0 or 1)
	end
	if bAltKeyDown ~= IsAltKeyDown() then
		ModifierStateChanged(nil, "MODIFIER_STATE_CHANGED", "LALT", bAltKeyDown and 0 or 1)
	end
end
frameCheckModifier:RegisterEvent("MODIFIER_STATE_CHANGED")
frameCheckModifier:SetScript("OnEvent", ModifierStateChanged)
frameCheckModifier:SetScript("OnUpdate", ModifierStateCheck)

local function GetAbilityPairIndex(c1, c2)
	if c1 > c2 then
		c1, c2 = c2, c1
	end
	
	return c1 * 100 + c2
end
local function GetAbilityPairNum(c1, c2)
	local ix = GetAbilityPairIndex(c1, c2)
	local nActive, nInactive
	
	if AbilitiesData and AbilitiesData.Pair[ix] then
		nActive = #AbilitiesData.Pair[ix][1]
		nInactive = #AbilitiesData.Pair[ix][2]
	else
		nActive = 0
		nInactive = 0
	end
	
	return nActive, nInactive, nActive+nInactive
end
local tAbilitiesDataUpdate
local function UpdateAbilitiesData(self, elapsed)
	if UnitLevel("player") < 90 then
		return
	end
	
	if tAbilitiesDataUpdate and elapsed and tAbilitiesDataUpdate < 1 then
		tAbilitiesDataUpdate = tAbilitiesDataUpdate + elapsed
		return
	end
	tAbilitiesDataUpdate = 0
	
	local followers = C_Garrison.GetFollowers(1)
	if not AbilitiesData then
		AbilitiesData = {}
		AbilitiesData.Count = {}
		AbilitiesData.Pair = {}
	end
	
	--  clear old data
	local wipe = wipe
	local tinsert = table.insert
	for _, t in pairs(AbilitiesData.Count) do
		wipe(t[1])
		wipe(t[2])
	end
	for _, t in pairs(AbilitiesData.Pair) do
		wipe(t[1])
		wipe(t[2])
	end
	
	local follower, id, aid, ix, gid, updateData
	local abilities = {}
	for i = 1, #followers do
		follower = followers[i]
		wipe(abilities)
		if follower.isCollected and follower.followerTypeID == 1 then
			id = follower.followerID
			for j = 1, 4 do
				aid = C_Garrison.GetFollowerAbilityAtIndex(id, j)
				if aid and aid > 0 then
					aid = GetFollowerAbilityCounterMechanicInfo(aid)
					tinsert(abilities, aid)
					
					if not AbilitiesData.Count[aid] then
						AbilitiesData.Count[aid] = {{}, {}}
					end
					if follower.status ~= GARRISON_FOLLOWER_INACTIVE then
						tinsert(AbilitiesData.Count[aid][1], id)
					else
						tinsert(AbilitiesData.Count[aid][2], id)
					end
				end
			end
			if #abilities == 2 then
				ix = GetAbilityPairIndex(unpack(abilities))
				
				if not AbilitiesData.Pair[ix] then
					AbilitiesData.Pair[ix] = {{}, {}}
				end
				if follower.status ~= GARRISON_FOLLOWER_INACTIVE then
					tinsert(AbilitiesData.Pair[ix][1], id)
				else
					tinsert(AbilitiesData.Pair[ix][2], id)
				end
			end
			
			-- Update GarrisonFollowerTooltip because it may change
			gid = follower.garrFollowerID
			if GarrisonFollowerTooltip:IsShown() and GFTData.garrisonFollowerID == gid and (GFTData.noAbilityDescriptions ~= true) then
				updateData = {gid, follower.isCollected, follower.quality, follower.level, follower.xp, follower.levelXP, follower.iLevel, C_Garrison.GetFollowerSpecializationAtIndex(id, 1), C_Garrison.GetFollowerAbilityAtIndex(id, 1), C_Garrison.GetFollowerAbilityAtIndex(id, 2), C_Garrison.GetFollowerAbilityAtIndex(id, 3), C_Garrison.GetFollowerAbilityAtIndex(id, 4), C_Garrison.GetFollowerTraitAtIndex(id, 1), C_Garrison.GetFollowerTraitAtIndex(id, 2), C_Garrison.GetFollowerTraitAtIndex(id, 3), C_Garrison.GetFollowerTraitAtIndex(id, 4), GFTData.noAbilityDescriptions, false}
			end
		end
	end
	if updateData then
		Override.GarrisonFollowerTooltip_Show(unpack(updateData))
		wipe(updateData)
	end
	collectgarbage("collect")
end
local function ModifyAbilityDetailsText(fontString, ab)
	local cid, cname = GetFollowerAbilityCounterMechanicInfo(ab)
	local nActive, nInactive
	
	if AbilitiesData and AbilitiesData.Count[cid] then
		nActive = #AbilitiesData.Count[cid][1]
		nInactive = #AbilitiesData.Count[cid][2]
	else
		nActive = 0
		nInactive = 0
	end
	fontString:SetFormattedText("%s(%d/%d)", cname, nActive, nActive + nInactive)
end
local function SetAbilityPairText(fontString, ab1, ab2)
	local c1 = GetFollowerAbilityCounterMechanicInfo(ab1)
	local c2 = GetFollowerAbilityCounterMechanicInfo(ab2)
	local nActive, nTotal
	
	nActive, _, nTotal = GetAbilityPairNum(c1, c2)
	
	fontString:SetFormattedText(strLPair, nActive, nTotal)
end
local fAbilitiesDataUpdate = CreateFrame("Frame")
local bUpdateHasSet = false
fAbilitiesDataUpdate:RegisterEvent("GARRISON_UPDATE")
fAbilitiesDataUpdate:RegisterEvent("GARRISON_FOLLOWER_ADDED")
fAbilitiesDataUpdate:RegisterEvent("GARRISON_FOLLOWER_REMOVED")
fAbilitiesDataUpdate:SetScript("OnEvent", function() UpdateAbilitiesData() end)
local function ModifyFollowerTooltip(tooltipFrame, data)
	local backup
	if tooltipFrame == FloatingGarrisonFollowerTooltip then
		backup = FGFTData
	elseif tooltipFrame == GarrisonFollowerTooltip then
		backup = GFTData
	end
	if backup then
		for k, _ in pairs(data) do
			backup[k] = data[k]
		end
		backup.isMaxLevel = (backup.level >= GARRISON_FOLLOWER_MAX_LEVEL)
	end
	
	local abilities = {data.ability1, data.ability2, data.ability3, data.ability4}
	local traits = {data.trait1, data.trait2, data.trait3, data.trait4};
	local detailed = not data.noAbilityDescriptions
	local cAbility , cTrait = 0, 0
	local Ability, abilityCounterMechanicName, abilityCounterMechanicIcon, Trait
	local tooltipFrameHeight = tooltipFrame:GetHeight()
	
	local abiSpec = Addon.abiSpec[data.spec]
	local otherAbilities = {}
	local bHasGot, bShowPairInfo, bShowCurrentPairInfo
	
	local tooltipFrameHeightBase = 80;					-- this is the tooltip frame height w/ no abilities/traits being displayed
	local abilityOffset = 10;							-- distance between ability entries
	local abilityFrameHeightBase = 20;					-- ability frame height w/ no description/details being displayed
	local spacingBetweenLabelAndFirstAbility = 8;		-- distance between the &quot;Abilities&quot; label and the first ability below it
	local spacingBetweenNameAndDescription = 4;			-- must match the XML ability template setting
	local spacingBetweenDescriptionAndDetails = 8;		-- must match the XML ability template setting
	local labelPairXOffset = 15;
	local tOffset
	local followerSpecName, followerRaceName
	
	tooltipFrame.Name:SetWordWrap(false)
	tooltipFrame.Name:SetPoint("RIGHT")
	tooltipFrame.ClassSpecName:SetWordWrap(false)
	tooltipFrame.ClassSpecName:SetPoint("RIGHT")
	
	if ( data.spec ) then
		followerSpecName = C_Garrison.GetFollowerClassSpecName(data.garrisonFollowerID)
		followerRaceName = API.GetRaceName(data.garrisonFollowerID)
		if followerRaceName then
			tooltipFrame.ClassSpecName:SetFormattedText("%s %s", followerRaceName, followerSpecName)
		end
	end
	
	for i = 1, 4 do
		if abilities[i] and abilities[i] > 0 then
			cAbility = cAbility + 1
		end
		if traits[i] and traits[i] > 0 then
			cTrait = cTrait + 1
		end
	end
	for i = 1, cAbility do
		Ability = tooltipFrame.Abilities[i];
		if not detailed then
			tooltipFrameHeight = tooltipFrameHeight - Ability:GetHeight();

			Ability.Details:Show();	
			
			_, abilityCounterMechanicName, abilityCounterMechanicIcon = GetFollowerAbilityCounterMechanicInfo(abilities[i]);
			Ability.Details:SetFormattedText(GARRISON_ABILITY_COUNTERS_FORMAT, abilityCounterMechanicName);
			Ability:SetHeight(Ability:GetHeight() + Ability.Details:GetHeight() + spacingBetweenDescriptionAndDetails);

			Ability.CounterIcon:SetTexture(abilityCounterMechanicIcon);
			Ability.CounterIcon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask");
			Ability.CounterIcon:SetPoint("TOPLEFT", Ability.Name, "BOTTOMLEFT", 0, -spacingBetweenDescriptionAndDetails)
			Ability.CounterIcon:Show();
			Ability.CounterIconBorder:Show();
			
			tooltipFrameHeight = tooltipFrameHeight + Ability:GetHeight();
		else
			Ability.CounterIcon:SetPoint("TOPLEFT", Ability.Description, "BOTTOMLEFT", 0, -spacingBetweenDescriptionAndDetails)
			ModifyAbilityDetailsText(Ability.Details, abilities[i])
		end
	end
	
	for i = 1, #abiSpec do
		bHasGot = false
		for j = 1, cAbility do
			if abiSpec[i] == abilities[j] then
				bHasGot = true
			end
		end
		if not bHasGot then
			otherAbilities[#otherAbilities+1] = abiSpec[i] 
		end
	end
	
	tooltipFrame.labelAbilityPair = tooltipFrame.labelAbilityPair or tooltipFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	local labelPair = tooltipFrame.labelAbilityPair
	bShowCurrentPairInfo = detailed and cAbility == 2
	
	if bShowCurrentPairInfo then
		labelPair:SetPoint("TOPLEFT", tooltipFrame.Abilities[2], "BOTTOMLEFT", labelPairXOffset, -abilityOffset);
		SetAbilityPairText(labelPair, abilities[1], abilities[2])
		tooltipFrameHeight = tooltipFrameHeight + labelPair:GetHeight() + abilityOffset
		labelPair:Show()
		
		tooltipFrame.TraitsLabel:SetPoint("TOPLEFT", labelPair, "BOTTOMLEFT", -labelPairXOffset, -abilityOffset);
	else
		labelPair:Hide()
	end
	
	tooltipFrame.OtherAbilitiesLabel = tooltipFrame.OtherAbilitiesLabel or tooltipFrame:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	local label = tooltipFrame.OtherAbilitiesLabel
	label:SetJustifyH("LEFT")
	
	local TooltipMode, TooltipModeText
	
	--[[
	if data.quality <= 4 then
		TooltipMode = KeyMode
		TooltipModeText = Addon.L.TextShift..'|n'..Addon.L.TextAlt
	else
		TooltipMode = (KeyMode == 1) and 1 or 0
		TooltipModeText = Addon.L.TextShift
	end
	]]
	TooltipMode = KeyMode
	TooltipModeText = Addon.L.TextShift..'|n'..Addon.L.TextAlt
	
	if cTrait > 0 and (TooltipMode == 0) then
		label:SetPoint("TOPLEFT", tooltipFrame.Traits[cTrait], "BOTTOMLEFT", 0, -abilityOffset);
	elseif bShowCurrentPairInfo then
		label:SetPoint("TOPLEFT", labelPair, "BOTTOMLEFT", -labelPairXOffset, -abilityOffset);
	elseif cAbility > 0 then
		label:SetPoint("TOPLEFT", tooltipFrame.Abilities[cAbility], "BOTTOMLEFT", 0, -abilityOffset);
	else
		label:SetPoint("TOPLEFT", tooltipFrame, "TOPLEFT", 15, -tooltipFrameHeightBase - 5);
	end
	
	tooltipFrame.OtherAbilities = tooltipFrame.OtherAbilities or {}
	for i = 1, #tooltipFrame.OtherAbilities do
		tooltipFrame.OtherAbilities[i]:Hide()
	end
	
	tooltipFrame.EpicRetrainingPairs = tooltipFrame.EpicRetrainingPairs or {}
	for i = 1, #tooltipFrame.EpicRetrainingPairs do
		tooltipFrame.EpicRetrainingPairs[i]:Hide()
	end
	
	local color, description, id, pair
	
	if #otherAbilities > 0 and detailed then
		if TooltipMode ~= 0 then
			-- Hide traits
			if cTrait > 0 then 
				tooltipFrameHeight = tooltipFrameHeight - tooltipFrame.TraitsLabel:GetHeight() - abilityOffset
				for i = 1, cTrait do
					Trait = tooltipFrame.Traits[i]
					tooltipFrameHeight = tooltipFrameHeight - Trait:GetHeight() - ((i == 1) and spacingBetweenLabelAndFirstAbility or abilityOffset)
					Trait:Hide()
				end
			end
			tooltipFrame.TraitsLabel:Hide();
		end
		if TooltipMode == 1 then
			bShowPairInfo = detailed and cAbility == 1
			label:SetText(Addon.L.ShiftDown)
			color = NORMAL_FONT_COLOR
			label:SetVertexColor(color.r, color.g, color.b);
			
			for i = 1, #otherAbilities do
				tooltipFrame.OtherAbilities[i] = tooltipFrame.OtherAbilities[i] or CreateFrame("Frame", nil, tooltipFrame, "GarrisonFollowerAbilityTemplate")
				Ability = tooltipFrame.OtherAbilities[i]
				id = otherAbilities[i]
				
				if i == 1 then
					Ability:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -spacingBetweenLabelAndFirstAbility)
					tooltipFrameHeight = tooltipFrameHeight + spacingBetweenLabelAndFirstAbility
				else
					pair = tooltipFrame.OtherAbilities[i-1].pair
					if pair and pair:IsShown() then
						tOffset = abilityOffset - spacingBetweenDescriptionAndDetails + spacingBetweenNameAndDescription
					else
						tOffset = abilityOffset
					end
					Ability:SetPoint("TOPLEFT", tooltipFrame.OtherAbilities[i-1], "BOTTOMLEFT", 0, -tOffset)
					tooltipFrameHeight = tooltipFrameHeight + tOffset
				end
				Ability.Name:SetText(C_Garrison.GetFollowerAbilityName(id))
				Ability.Icon:SetTexture(C_Garrison.GetFollowerAbilityIcon(id))
				Ability:SetHeight(abilityFrameHeightBase)
				
				Ability.Details:Show();	
				_, abilityCounterMechanicName, abilityCounterMechanicIcon = GetFollowerAbilityCounterMechanicInfo(id);
				Ability.Details:SetFormattedText(GARRISON_ABILITY_COUNTERS_FORMAT, abilityCounterMechanicName);
				ModifyAbilityDetailsText(Ability.Details, otherAbilities[i])
				Ability:SetHeight(Ability:GetHeight() + Ability.Details:GetHeight() + spacingBetweenDescriptionAndDetails);
				
				Ability.CounterIcon:SetTexture(abilityCounterMechanicIcon);
				Ability.CounterIcon:SetMask("Interface\\CharacterFrame\\TempPortraitAlphaMask");
				Ability.CounterIcon:Show();
				Ability.CounterIconBorder:Show();
				Ability.CounterIconBorder:SetAtlas("GarrMission_EncounterAbilityBorder-Lg");
			
				Ability.Description:Show();
				description = C_Garrison.GetFollowerAbilityDescription(otherAbilities[i]);
				if string.len(description) == 0 then description = "PH - Description Missing"; end
				Ability.Description:SetText(description);
				Ability:SetHeight(Ability:GetHeight() + Ability.Description:GetHeight() + spacingBetweenNameAndDescription);
				Ability.CounterIcon:SetPoint("TOPLEFT", Ability.Description, "BOTTOMLEFT", 0, -spacingBetweenDescriptionAndDetails)
				
				Ability.pair = Ability.pair or Ability:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
				pair = Ability.pair
				pair:SetPoint("LEFT", Ability, labelPairXOffset, 0)
				pair:SetPoint("TOP", Ability.Details, "BOTTOM", 0, -spacingBetweenDescriptionAndDetails)
				
				if bShowPairInfo then
					pair:Show()
					SetAbilityPairText(pair, abilities[1], id)
					Ability:SetHeight(Ability:GetHeight() + pair:GetHeight() + spacingBetweenDescriptionAndDetails)
				else
					pair:Hide()
				end

				Ability:Show();

				tooltipFrameHeight = tooltipFrameHeight + Ability:GetHeight();
			end
			tooltipFrameHeight = tooltipFrameHeight + label:GetHeight() + abilityOffset;
		elseif TooltipMode == 2 then
			local RetrainingPair
			local idC1, idC2, iconC1, iconC2
			local idPair, colorPair, idAbilCurrent
			local nActive, nTotal
			local idRP = 0
			if cAbility == 2 then
				idC1 = GetFollowerAbilityCounterMechanicInfo(abilities[1])
				idC2 = GetFollowerAbilityCounterMechanicInfo(abilities[2])
				idAbilCurrent = GetAbilityPairIndex(idC1, idC2)
			elseif cAbility == 1 then
				idAbilCurrent = abilities[1]
			end
			label:SetText(Addon.L.AltDown)
			color = NORMAL_FONT_COLOR
			label:SetVertexColor(color.r, color.g, color.b)
			
			for i = 1, #abiSpec do
				for j = i + 1, #abiSpec do 
					idRP = idRP + 1
					RetrainingPair = tooltipFrame.EpicRetrainingPairs[idRP]
					if not RetrainingPair then
						RetrainingPair = CreateFrame("Frame", nil, tooltipFrame)
						RetrainingPair:SetSize(20, 20)
						--RetrainingPair.CounterIcon1 = CreateFrame("Button", nil, RetrainingPair, "GarrisonAbilityCounterTemplate")
						--RetrainingPair.CounterIcon2 = CreateFrame("Button", nil, RetrainingPair, "GarrisonAbilityCounterTemplate")
						RetrainingPair.CounterIcon1 = RetrainingPair:CreateTexture()
						RetrainingPair.CounterIcon1:SetSize(20, 20)
						RetrainingPair.CounterIcon1:SetDrawLayer("ARTWORK", -1)
						RetrainingPair.CounterIcon1Border = RetrainingPair:CreateTexture()
						RetrainingPair.CounterIcon1Border:SetAtlas("GarrMission_EncounterAbilityBorder")
						RetrainingPair.CounterIcon1Border:SetPoint("CENTER", RetrainingPair.CounterIcon1, "CENTER")
						RetrainingPair.CounterIcon1Border:SetSize(30, 30)
						
						RetrainingPair.CounterIcon2 = RetrainingPair:CreateTexture()
						RetrainingPair.CounterIcon2:SetSize(20, 20)
						RetrainingPair.CounterIcon2:SetDrawLayer("ARTWORK", -1)
						RetrainingPair.CounterIcon2Border = RetrainingPair:CreateTexture()
						RetrainingPair.CounterIcon2Border:SetAtlas("GarrMission_EncounterAbilityBorder")
						RetrainingPair.CounterIcon2Border:SetPoint("CENTER", RetrainingPair.CounterIcon2, "CENTER")
						RetrainingPair.CounterIcon2Border:SetSize(30, 30)
						
						RetrainingPair.Text = RetrainingPair:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
						tooltipFrame.EpicRetrainingPairs[idRP] = RetrainingPair
					end
					
					if idRP == 1 then
						RetrainingPair:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 5, -spacingBetweenLabelAndFirstAbility)
					elseif idRP == 2 then
						RetrainingPair:SetPoint("TOPLEFT", tooltipFrame.EpicRetrainingPairs[1], "TOPLEFT", 120, 0)
					else
						RetrainingPair:SetPoint("TOPLEFT", tooltipFrame.EpicRetrainingPairs[idRP-2], "BOTTOMLEFT", 0, -10)
					end
					
					idC1, _, iconC1 = GetFollowerAbilityCounterMechanicInfo(abiSpec[i]);
					idC2, _, iconC2 = GetFollowerAbilityCounterMechanicInfo(abiSpec[j]);
					
					RetrainingPair.CounterIcon1:SetPoint("TOPLEFT");
					RetrainingPair.CounterIcon1:SetTexture(iconC1);
					
					RetrainingPair.CounterIcon2:SetPoint("TOPLEFT", RetrainingPair.CounterIcon1, "TOPRIGHT", 5, 0)
					RetrainingPair.CounterIcon2:SetTexture(iconC2);
					
					idPair = GetAbilityPairIndex(idC1, idC2)
					nActive, _, nTotal = GetAbilityPairNum(idC1, idC2)
					RetrainingPair.Text:SetPoint("LEFT", RetrainingPair.CounterIcon2, "RIGHT", 5, 0)
					RetrainingPair.Text:SetFormattedText("%d/%d", nActive, nTotal)
					if cAbility == 2 then
						colorPair = (idPair == idAbilCurrent) and NORMAL_FONT_COLOR or HIGHLIGHT_FONT_COLOR
					elseif cAbility == 1 then
						if idAbilCurrent == abiSpec[i] or idAbilCurrent == abiSpec[j] then
							colorPair = NORMAL_FONT_COLOR
						else
							colorPair = HIGHLIGHT_FONT_COLOR
						end
					else
						colorPair = HIGHLIGHT_FONT_COLOR
					end
					RetrainingPair.Text:SetVertexColor(colorPair.r, colorPair.g, colorPair.b);
					
					RetrainingPair:Show()
				end
			end
			tooltipFrameHeight = tooltipFrameHeight + label:GetHeight() + abilityOffset + 30*math.ceil(idRP/2)
		else
			label:SetText(TooltipModeText)
			color = ITEM_QUALITY_COLORS[3]
			label:SetVertexColor(color.r, color.g, color.b);
			
			tooltipFrameHeight = tooltipFrameHeight + label:GetHeight();
			
			bShowPairInfo = false
		end
		label:Show()
	else
		label:Hide()
	end
	
	if not detailed then
		tooltipFrame:SetHeight(tooltipFrameHeight - 5);
	else
		tooltipFrame:SetHeight(tooltipFrameHeight + 5);
	end
end
hooksecurefunc("GarrisonFollowerTooltipTemplate_SetGarrisonFollower", ModifyFollowerTooltip)

local bMasterPlanLoaded = false
local function FollowerTooltip_HideCondition()
	if bMasterPlanLoaded == false then
		bMasterPlanLoaded = IsAddOnLoaded("MasterPlan")
		if not bMasterPlanLoaded then
			bMasterPlanLoaded = IsAddOnLoaded("GarrisonMaster")
		end
	end
	if GarrisonMissionFrame.MissionTab.MissionPage:IsShown() and bMasterPlanLoaded then
		return true
	end
	return false
end

local function ShowRaceNameOnFollowerPage(self, followerID)
	local followerInfo = C_Garrison.GetFollowerInfo(followerID)
	local followerSpecName, followerRaceName
	if followerInfo then
		followerSpecName = followerInfo.className
		followerRaceName = API.GetRaceName(followerInfo.garrFollowerID or followerID)
		if followerRaceName then
			self.followerTab.ClassSpec:SetFormattedText("%s %s", followerRaceName, followerSpecName)
		end
	end
end

local function FollowerButton_OnEnter(self)
	if FollowerTooltip_HideCondition() then
		return
	end
	
	local info = self.info
	local fid = info.followerID
	local abilities = {0, 0, 0, 0}
	local traits = {0, 0, 0, 0}
	local GetAbility = info.garrFollowerID and C_Garrison.GetFollowerAbilityAtIndex or C_Garrison.GetFollowerAbilityAtIndexByID
	local GetTrait = info.garrFollowerID and C_Garrison.GetFollowerTraitAtIndex or C_Garrison.GetFollowerTraitAtIndexByID

	for i = 1, 4 do
		abilities[i] = GetAbility(fid, i)
		traits[i] = GetTrait(fid, i)
	end
	
	GarrisonFollowerTooltip_Owner = self
	GarrisonFollowerTooltip:ClearAllPoints()
	GarrisonFollowerTooltip:SetPoint("TOPLEFT", self, "TOPRIGHT")
	
	local collected = info.isCollected and true or false
	
	Override.GarrisonFollowerTooltip_Show(info.garrFollowerID or info.followerID, collected, info.quality, info.level, info.xp, info.levelXP, info.iLevel, 0, abilities[1], abilities[2], abilities[3], abilities[4], traits[1], traits[2], traits[3], traits[4], false)
end
local function FollowerButton_OnLeave(self)
	if FollowerTooltip_HideCondition() then
		return
	end
	
	if GarrisonFollowerTooltip_Owner == self then
		GarrisonFollowerTooltip:Hide()
		GarrisonFollowerTooltip_Owner = nil
	end
end
local function FollowerList_OnMouseWheel(self)
	if FollowerTooltip_HideCondition() then
		return
	end
	
	local buttons = self.buttons
	
	if GarrisonFollowerTooltip_Owner then
		FollowerButton_OnLeave(GarrisonFollowerTooltip_Owner)
	end
	for i = 1, #buttons do
		if GetMouseFocus() == buttons[i] then
			FollowerButton_OnEnter(buttons[i])
			return
		end
	end
end

local HasHooked = {GarrisonMissionFrame = false, GarrisonLandingPage = false, GarrisonRecruitSelectFrame = false}

local function HookFollowerButton(FollowerButton)
	FollowerButton:HookScript("OnEnter", FollowerButton_OnEnter)
	FollowerButton:HookScript("OnLeave", FollowerButton_OnLeave)
end

local function HookGarrisonFrame(GarrisonFrame)
	local FrameName = GarrisonFrame:GetName()
	if HasHooked[FrameName] then
		return
	end
	local buttons = GarrisonFrame.FollowerList.listScroll.buttons

	for i = 1, #buttons do
		HookFollowerButton(buttons[i].Follower)
	end
	GarrisonFrame.FollowerList.listScroll:HookScript("OnMouseWheel", FollowerList_OnMouseWheel)
	
	if FrameName ~= "GarrisonRecruitSelectFrame" then
		GarrisonFrame.FollowerList:HookScript("OnShow", function() fAbilitiesDataUpdate:SetScript("OnUpdate", UpdateAbilitiesData) end)
		GarrisonFrame.FollowerList:HookScript("OnHide", function() fAbilitiesDataUpdate:SetScript("OnUpdate", nil) end)
	end
	
	hooksecurefunc(GarrisonFrame.FollowerList, "ShowFollower", ShowRaceNameOnFollowerPage)

	HasHooked[FrameName] = true;
end

--function Addon.LoadWithUI.FollowerTooltip()
	for frame, _ in pairs(HasHooked) do
		_G[frame]:HookScript("OnShow", function() HookGarrisonFrame(_G[frame]) end)
	end
	GarrisonRecruitSelectFrame:HookScript("OnShow", function() UpdateAbilitiesData() end)
--end