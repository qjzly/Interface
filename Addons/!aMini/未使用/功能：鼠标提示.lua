----------------------------------------------------------------------------------------
--  Tooltip
----------------------------------------------------------------------------------------




--  鼠标提示染色

local _, ns = ...
local cfg = {
    scale = 1.0,

    backdrop = {
        bgFile = "Interface\\Buttons\\WHITE8x8",
        edgeFile = "Interface\\Buttons\\WHITE8x8",
        tile = true,
        tileSize = 11,
        edgeSize = 2,
        insets = { left = 0, right = 0, top = 0, bottom = 0 },
    },
    bgcolor = { r=0, g=0, b=0, t=0.5 },
    bdrcolor = { r=0, g=0, b=0 },
    gcolor = { r=0.9, g=0.5, b=0.2 },
}


local function setBakdrop(frame)
    frame:SetBackdrop(cfg.backdrop)
    frame:SetScale(cfg.scale)

    frame.freebBak = true
end

local function style(frame)
    if not frame.freebBak then
        setBakdrop(frame)
    end

    frame:SetBackdropColor(cfg.bgcolor.r, cfg.bgcolor.g, cfg.bgcolor.b, cfg.bgcolor.t)
    frame:SetBackdropBorderColor(cfg.bdrcolor.r, cfg.bdrcolor.g, cfg.bdrcolor.b)


end

local tooltips = {
    GameTooltip,
    ItemRefTooltip,
    ShoppingTooltip1,
    ShoppingTooltip2, 
    ShoppingTooltip3,
    WorldMapTooltip,
    DropDownList1MenuBackdrop, 
    DropDownList2MenuBackdrop,
	--ConsolidatedBuffsTooltip,
}

for i, frame in ipairs(tooltips) do
    frame:SetScript("OnShow", function(frame) style(frame) end)
end




-- 鼠标提示目标染色function
-- func GetHexColor
local function GetHexColor(color)
  return ("%.2x%.2x%.2x"):format(color.r*255, color.g*255, color.b*255)
end

local classColors, reactionColors = {}, {}

for class, color in pairs(RAID_CLASS_COLORS) do
  classColors[class] = GetHexColor(RAID_CLASS_COLORS[class])
end

for i = 1, #FACTION_BAR_COLORS do
  reactionColors[i] = GetHexColor(FACTION_BAR_COLORS[i])
end

local function GetTarget(unit)
  if UnitIsUnit(unit, "player") then
    return ("|cffff0000%s|r"):format("<YOU>")
  elseif UnitIsPlayer(unit, "player")then
    return ("|cff%s%s|r"):format(classColors[select(2, UnitClass(unit))], UnitName(unit))
  elseif UnitReaction(unit, "player") then
    return ("|cff%s%s|r"):format(reactionColors[UnitReaction(unit, "player")], UnitName(unit))
  else
    return ("|cffffffff%s|r"):format(UnitName(unit))
  end
end



-- 鼠标提示目标职业颜色
local GameTooltip = GameTooltip

GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	local _, unit = self:GetUnit()
	if (not unit) then return end

	if (UnitIsUnit("player", unit .. "target")) then----目标职业颜色
		self:AddDoubleLine("|cffff9999Target|r",GetTarget(unit.."target") or "Unknown")----self:AddLine("< YOU >", 0.5, 1)
	elseif (UnitExists(unit .. "target")) then
		self:AddDoubleLine("|cffff9999Target|r",GetTarget(unit.."target") or "Unknown")----self:AddLine(UnitName(unit .. "target"), 0.5, 1)
	end
	
	local unitGuild = GetGuildInfo(unit)
    local text = GameTooltipTextLeft2:GetText()
    if unitGuild and text and text:find("^"..unitGuild) then
      GameTooltipTextLeft2:SetText("<"..text..">")
      GameTooltipTextLeft2:SetTextColor(255/255, 20/255, 200/255)
    end
end)

--GameTooltipHeaderText:SetFont(STANDARD_TEXT_FONT, 16, "THINOUTLINE")
--GameTooltipText:SetFont(STANDARD_TEXT_FONT, 14, "THINOUTLINE")



-- 鼠标提示名字染色
function GameTooltip_UnitColor(unit)
	local r, g, b
	local reaction = UnitReaction(unit, "player")
	if reaction then
		r = FACTION_BAR_COLORS[reaction].r
		g = FACTION_BAR_COLORS[reaction].g
		b = FACTION_BAR_COLORS[reaction].b
	else
		r = 1.0
		g = 1.0
		b = 1.0
	end

	if UnitIsPlayer(unit) then
		local class = select(2, UnitClass(unit))
		r = RAID_CLASS_COLORS[class].r
		g = RAID_CLASS_COLORS[class].g
		b = RAID_CLASS_COLORS[class].b
	end
	return r, g, b
end



-- 鼠标提示法术ID和施法者
hooksecurefunc(GameTooltip, "SetUnitBuff", function(self,...) 
   local id = select(11,UnitBuff(...)) 
   local caster = select(8,UnitBuff(...)) and UnitName(select(8,UnitBuff(...))) 
   self:AddLine(id and ' ') 
   self:AddDoubleLine(id, caster) 
   self:Show() 
end) 

hooksecurefunc(GameTooltip, "SetUnitDebuff", function(self,...) 
   local id = select(11,UnitDebuff(...)) 
   local caster = select(8,UnitDebuff(...)) and UnitName(select(8,UnitDebuff(...))) 
   self:AddLine(id and ' ') 
   self:AddDoubleLine(id, caster) 
   self:Show() 
end) 



hooksecurefunc(GameTooltip, "SetUnitAura", function(self,...) 
   local id = select(11,UnitAura(...)) 
   local caster = select(8,UnitAura(...)) and UnitName(select(8,UnitAura(...))) 
   self:AddLine(id and ' ') 
   self:AddDoubleLine(id, caster) 
   self:Show() 
end) 

hooksecurefunc("SetItemRef", function(link) 
   if link then 
      local _, id = strsplit(":", link) 
      ItemRefTooltip:AddLine(id and ' ') 
      ItemRefTooltip:AddLine(id) 
      ItemRefTooltip:Show() 
   end 
end) 

GameTooltip:HookScript("OnTooltipSetSpell", function(self) 
   if self.GetSpell then 
      local _, _, id = self:GetSpell() 
      self:AddLine(id and ' ') 
      self:AddLine(id) 
      self:Show() 
   end 
end) 





