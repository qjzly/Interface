----------------------------------------------------------------------------------------
--  PORTRAIT
----------------------------------------------------------------------------------------

--  光环美化
local backtex = "Interface\\AddOns\\A4U\\media\\outer_shadow"

local backdrop = {
    bgFile = nil,
    edgeFile = backtex,
    tile = false,
    tileSize = 32,
    edgeSize = 3,
    insets = {
      left = 6,
      right = 6,
      top = 6,
      bottom = 6,
    },
  }

local function StyleTargetAura(b)
    if b and not b.styled then
	    local n = b:GetName()
        local bo = _G[n.."Border"];
        local ic = _G[n.."Icon"];

        ic:SetTexCoord(.1, .9, .1, .9);
        ic:SetPoint("TOPLEFT", b, "TOPLEFT", 2, -2);
        ic:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", -2, 2);
		ic:SetDrawLayer("BACKGROUND",-8)
        back = CreateFrame("Frame", nil, b)
        back:SetPoint("TOPLEFT", b, "TOPLEFT", -1, 1)
        back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", 1, -1)
        back:SetFrameLevel(b:GetFrameLevel()-1)
        back:SetBackdrop(backdrop)	
        back:SetBackdropBorderColor(0, 0, 0, 1)
        b.bg = back	
        b.styled = true;		
    end 
end;

local function ScanTargetAuras()
    for i = 1, MAX_TARGET_BUFFS do    
        local b = _G["TargetFrameBuff"..i];
        if b and not b.styled then
            StyleTargetAura(b);
        end;
    end;

    for i = 1, MAX_TARGET_DEBUFFS do
        local b = _G["TargetFrameDebuff"..i];
        if b and not b.styled then
            StyleTargetAura(b);
        end;
    end;
end;



local function ScanFocusAuras()
    for i = 1, 8 do
    local b = _G["FocusFrameBuff"..i];
        if b and not b.styled then
            StyleTargetAura(b);
        end;
    end;
    for i = 1, 8 do
    local b = _G["FocusFrameDebuff"..i];
        if b and not b.styled then
            StyleTargetAura(b);
        end;
    end;
end;

-- events
local a = CreateFrame("Frame", "thek_Buttons_BuffsDebuffs", UIParent);
a:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_TARGET_CHANGED" then
        ScanTargetAuras();
    elseif event == "PLAYER_FOCUS_CHANGED" then
        ScanFocusAuras();
    elseif event == "UNIT_AURA" then
        if ... == TargetFrame.unit then 
            ScanTargetAuras();
        elseif ... == FocusFrame.unit then
            ScanFocusAuras();
        end
    end;
end);

a:RegisterEvent("PLAYER_TARGET_CHANGED");
a:RegisterEvent("PLAYER_FOCUS_CHANGED");
a:RegisterEvent("UNIT_AURA");

---------------------------------------------------
-- TARGETBUFFS --
---------------------------------------------------
-- aura positioning constants
local AURA_START_X = 5;
local AURA_START_Y = 30;
local AURA_OFFSET_Y = 3
local LARGE_AURA_SIZE = 26
local SMALL_AURA_SIZE = 22
local AURA_ROW_WIDTH = 132
local NUM_TOT_AURA_ROWS = 3

function UpdateAuraPositions(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX, mirrorAurasVertically)
    local size
    local offsetY = AURA_OFFSET_Y
    local rowWidth = 0
    local firstBuffOnRow = 1
    for i=1, numAuras do
        if ( largeAuraList[i] ) then
            size = LARGE_AURA_SIZE
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y
        else
            size = SMALL_AURA_SIZE
        end
        if ( i == 1 ) then
            rowWidth = size
            self.auraRows = self.auraRows + 1
        else
            rowWidth = rowWidth + size + offsetX
        end
        if ( rowWidth > maxRowWidth ) then
            updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY, mirrorAurasVertically)
            rowWidth = size
            self.auraRows = self.auraRows + 1
            firstBuffOnRow = i
            offsetY = AURA_OFFSET_Y
        else
            updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY, mirrorAurasVertically)
        end
    end
end

hooksecurefunc("TargetFrame_UpdateAuraPositions", UpdateAuraPositions)

function UpdateBuffAnchor(self, buffName, index, numDebuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local point, relativePoint
    local startY, auraOffsetY
    if ( mirrorVertically ) then
        point = "BOTTOM"
        relativePoint = "TOP"
        startY = -8
        offsetY = -offsetY
        auraOffsetY = -AURA_OFFSET_Y
    else
        point = "TOP"
        relativePoint="BOTTOM"
        startY = AURA_START_Y
        auraOffsetY = AURA_OFFSET_Y
    end
     
    local buff = _G[buffName..index]
    if ( index == 1 ) then
        if ( UnitIsFriend("player", self.unit) or numDebuffs == 0 ) then
            -- unit is friendly or there are no debuffs...buffs start on top
            buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", AURA_START_X, startY)           
        else
            -- unit is not friendly and we have debuffs...buffs start on bottom
            buff:SetPoint(point.."LEFT", self.debuffs, relativePoint.."LEFT", 0, -offsetY)
        end
        self.buffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0)
        self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    elseif ( anchorIndex ~= (index-1) ) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY)
        self.buffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY)
        self.spellbarAnchor = buff
    else
        -- anchor index is the previous index
        buff:SetPoint(point.."LEFT", _G[buffName..anchorIndex], point.."RIGHT", offsetX, 0)
    end
end

hooksecurefunc("TargetFrame_UpdateBuffAnchor", UpdateBuffAnchor)

function UpdateDebuffAnchor(self, debuffName, index, numBuffs, anchorIndex, size, offsetX, offsetY, mirrorVertically)
    local buff = _G[debuffName..index];
    local isFriend = UnitIsFriend("player", self.unit);
     
    --For mirroring vertically
    local point, relativePoint;
    local startY, auraOffsetY;
    if ( mirrorVertically ) then
        point = "BOTTOM";
        relativePoint = "TOP";
        startY = -8;
        offsetY = - offsetY;
        auraOffsetY = -AURA_OFFSET_Y;
    else
        point = "TOP";
        relativePoint="BOTTOM";
        startY = AURA_START_Y;
        auraOffsetY = AURA_OFFSET_Y;
    end
     
    if ( index == 1 ) then
        if ( isFriend and numBuffs > 0 ) then
            -- unit is friendly and there are buffs...debuffs start on bottom
            buff:SetPoint(point.."LEFT", self.buffs, relativePoint.."LEFT", 0, -offsetY);
        else
            -- unit is not friendly or there are no buffs...debuffs start on top
            buff:SetPoint(point.."LEFT", self, relativePoint.."LEFT", AURA_START_X, startY);
        end
        self.debuffs:SetPoint(point.."LEFT", buff, point.."LEFT", 0, 0);
        self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
            self.spellbarAnchor = buff;
        end
    elseif ( anchorIndex ~= (index-1) ) then
        -- anchor index is not the previous index...must be a new row
        buff:SetPoint(point.."LEFT", _G[debuffName..anchorIndex], relativePoint.."LEFT", 0, -offsetY);
        self.debuffs:SetPoint(relativePoint.."LEFT", buff, relativePoint.."LEFT", 0, -auraOffsetY);
        if ( ( isFriend ) or ( not isFriend and numBuffs == 0) ) then
            self.spellbarAnchor = buff;
        end
    else
        -- anchor index is the previous index
        buff:SetPoint(point.."LEFT", _G[debuffName..(index-1)], point.."RIGHT", offsetX, 0);
    end
end

hooksecurefunc("TargetFrame_UpdateDebuffAnchor", UpdateDebuffAnchor) 
local function UpdateTargetAuraPositions(self, auraName, numAuras, numOppositeAuras, largeAuraList, updateFunc, maxRowWidth, offsetX) 
    local AURA_OFFSET_Y = 3; 
    local LARGE_AURA_SIZE = 30; 
    local SMALL_AURA_SIZE = 21; 
    local size; 
    local offsetY = AURA_OFFSET_Y; 
    local rowWidth = 0; 
    local firstBuffOnRow = 1; 
    for i=1, numAuras do 
        if ( largeAuraList[i] ) then 
            size = LARGE_AURA_SIZE; 
            offsetY = AURA_OFFSET_Y + AURA_OFFSET_Y; 
        else 
            size = SMALL_AURA_SIZE; 
        end 
        if ( i == 1 ) then 
            rowWidth = size; 
            self.auraRows = self.auraRows + 1; 
        else 
            rowWidth = rowWidth + size + offsetX; 
        end 
        if ( rowWidth > maxRowWidth ) then 
            updateFunc(self, auraName, i, numOppositeAuras, firstBuffOnRow, size, offsetX, offsetY); 
            rowWidth = size; 
            self.auraRows = self.auraRows + 1; 
            firstBuffOnRow = i; 
            offsetY = AURA_OFFSET_Y; 
        else 
            updateFunc(self, auraName, i, numOppositeAuras, i - 1, size, offsetX, offsetY); 
        end 
    end; 
end; 
hooksecurefunc("TargetFrame_UpdateAuraPositions", UpdateTargetAuraPositions) 
