﻿zTip = CreateFrame("Frame", nil, GameTooltip) 
--[[ 
   装等天赋改自 Cloudy Unit Info http://www.wowinterface.com/downloads/info22081-CloudyUnitInfo.html 
]] 
--- Variables --- 
local currentUNIT, currentGUID 
local GearDB, SpecDB = {}, {} 

local nextInspectRequest = 0 
lastInspectRequest = 0 

local prefixColor = '|cffffeeaa' 
local detailColor = '|cffffffff' 

local gearPrefix = STAT_AVERAGE_ITEM_LEVEL .. ': ' 
local specPrefix = SPECIALIZATION .. ': ' 
local _ 


--- Create Frame --- 
local f = CreateFrame('Frame', 'CloudyUnitInfo') 
f:RegisterEvent('UNIT_INVENTORY_CHANGED') 
f:RegisterEvent('INSPECT_READY') 


--- Set Unit Info --- 
local function SetUnitInfo(gear, spec) 
   if (not gear) and (not spec) then return end 

   local _, unit = GameTooltip:GetUnit() 
   if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end 

   local gearLine, specLine 
   for i = 2, GameTooltip:NumLines() do 
      local line = _G['GameTooltipTextLeft' .. i] 
      local text = line:GetText() 

      if text and strfind(text, gearPrefix) then 
         gearLine = line 
      elseif text and strfind(text, specPrefix) then 
         specLine = line 
      end 
   end 

   if gear then 
      gear = prefixColor .. gearPrefix .. detailColor .. gear 

      if gearLine then 
         gearLine:SetText(gear) 
      else 
         GameTooltip:AddLine(gear) 
      end 
   end 

   if spec then 
      spec = prefixColor .. specPrefix .. detailColor .. spec 

      if specLine then 
         specLine:SetText(spec) 
      else 
         GameTooltip:AddLine(spec) 
      end 
   end 

   GameTooltip:Show() 
end 


--- Upgraded Item Bonus --- 
local UGBonus = { 
   [001] =  8, [373] =  4, [374] =  8, [375] =  4, 
   [376] =  4, [377] =  4, [379] =  4, [380] =  4, 
   [446] =  4, [447] =  8, [452] =  8, [454] =  4, 
   [455] =  8, [457] =  8, [459] =  4, [460] =  8, 
   [461] = 12, [462] = 16, [466] =  4, [467] =  8, 
   [469] =  4, [470] =  8, [471] = 12, [472] = 16, 
   [492] =  4, [493] =  8, [494] =  4, [495] =  8, 
   [496] =  8, [497] = 12, [498] = 16, [504] = 12, 
   [505] = 16, [506] = 20, [507] = 24, [530] = 5, 
   [531] = 10, 
} 


--- Old BOA List --- 
local OldBOA = { 
   [42943] = 1, [42944] = 1, [42945] = 1, [42946] = 1, [42947] = 1, 
   [42948] = 1, [42949] = 1, [42950] = 1, [42951] = 1, [42952] = 1, 
   [42984] = 1, [42985] = 1, [42991] = 1, [42992] = 1, [44091] = 1, 
   [44092] = 1, [44093] = 1, [44094] = 1, [44095] = 1, [44096] = 1, 
   [44097] = 1, [44098] = 1, [44099] = 1, [44100] = 1, [44101] = 1, 
   [44102] = 1, [44103] = 1, [44105] = 1, [44107] = 1, [48677] = 1, 
   [48683] = 1, [48685] = 1, [48687] = 1, [48689] = 1, [48691] = 1, 
   [48716] = 1, [48718] = 1, [50255] = 1, 
} 


--- BOA Item Level --- 
local function BOALevel(level, id) 
   if (level > 80) and OldBOA[id] then 
      level = 80 
   elseif (level > 100) then 
      level = 100 
   end 

   if level > 97 then 
      if id == 133585 or id == 133595 or id == 133596 or id == 133597 or id == 133598 then 
         level = 715 
      else 
         level = 605 - (100 - level) * 5 
      end 
   elseif level > 90 then 
      level = 590 - (97 - level) * 10 
   elseif level > 85 then 
      level = 463 - (90 - level) * 19.75 
   elseif level > 80 then 
      level = 333 - (85 - level) * 13.5 
   elseif level > 67 then 
      level = 187 - (80 - level) * 4 
   elseif level > 57 then 
      level = 105 - (67 - level) * 2.9 
   else 
      level = level + 5 
   end 

   return level 
end 



--- Unit Gear Info --- 
local function UnitGear(unit) 
   if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end 

   local ulvl = UnitLevel(unit) 
   local class = select(2, UnitClass(unit)) 

   local ilvl, boa, pvp = 0, 0, 0 
   local total, count, delay = 0, 16, nil 
   local mainhand, offhand, twohand = 1, 1, 0 

   for i = 1, 20 do 
      if (i ~= 4) then 
         local itemTexture = GetInventoryItemTexture(unit, i) 

         if itemTexture then 
            local itemLink = GetInventoryItemLink(unit, i) 

            if (not itemLink) then 
               delay = true 
            else 
               local _, _, quality, level, _, _, _, _, slot = GetItemInfo(itemLink) 

               if (not quality) or (not level) then 
                  delay = true 
               else 
                  if (quality == 7) then 
                     boa = boa + 1 
                     local bid = tonumber(strmatch(itemLink, 'item:(%d+)')) 
                     total = total + BOALevel(ulvl, bid) 
                  else 
                     if (level == 660) or (level == 600)  or (level == 606) or (level == 626) or (level == 620) or (level == 700)or (level == 710)then 
                        pvp = pvp + 1 
                     end 

                     if (level >= 458) then 
                        local uid = tonumber(strmatch(itemLink, '.+:(%d+)')) 
                        if UGBonus[uid] then 
                           level = level + UGBonus[uid] 
                        end 
                     end 

                     total = total + level 
                  end 

                  if (i >= 16) then 
                     if (slot == 'INVTYPE_2HWEAPON') or (slot == 'INVTYPE_RANGED') or ((slot == 'INVTYPE_RANGEDRIGHT') and (class == 'HUNTER')) then 
                        twohand = twohand + 1 
                     end 
                  end 
               end 
            end 
         else 
            if (i == 16) then 
               mainhand = 0 
            elseif (i == 17) then 
               offhand = 0 
            end 
         end 
      end 
   end 

   if (mainhand == 0) and (offhand == 0) or (twohand == 1) then 
      count = count - 1 
   end 

   if (not delay) then 
      if (unit == 'player') and (GetAverageItemLevel() > 0) then 
         _, ilvl = GetAverageItemLevel() 
      else 
         ilvl = total / count 
      end 

      if (ilvl > 0) then ilvl = string.format('%.1f', ilvl) end 
      if (boa > 0) then ilvl = ilvl .. '  |cffe6cc80' .. boa .. ' 件传家宝' end 
      if (pvp > 0) then ilvl = ilvl .. '  |cffa335ee' .. pvp .. ' 件PVP装' end 
   else 
      ilvl = nil 
   end 

   return ilvl 
end 


--- Unit Specialization --- 
local function UnitSpec(unit) 
   if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end 

   local specName 

   if (unit == 'player') then 
      local specIndex = GetSpecialization() 

      if specIndex then 
         _, specName = GetSpecializationInfo(specIndex) 
      else 
         specName = NONE 
      end 
   else 
      local specID = GetInspectSpecialization(unit) 

      if specID and (specID > 0) then 
         _, specName = GetSpecializationInfoByID(specID) 
      elseif (specID == 0) then 
         specName = NONE 
      end 
   end 

   return specName 
end 


--- Scan Current Unit --- 
local function ScanUnit(unit, forced) 
   local cachedGear, cachedSpec 

   if UnitIsUnit(unit, 'player') then 
      cachedGear = UnitGear('player') 
      cachedSpec = UnitSpec('player') 

      SetUnitInfo(cachedGear or CONTINUED, cachedSpec or CONTINUED) 
   else 
      if (not unit) or (UnitGUID(unit) ~= currentGUID) then return end 

      cachedGear = GearDB[currentGUID] 
      cachedSpec = SpecDB[currentGUID] 

      if cachedGear or forced then 
         SetUnitInfo(cachedGear or CONTINUED, cachedSpec) 
      end 

      if not (IsShiftKeyDown() or forced) then 
         if cachedGear and cachedSpec then return end 
         if UnitAffectingCombat('player') then return end 
      end 

      if (not UnitIsVisible(unit)) then return end 
      if UnitIsDeadOrGhost('player') or UnitOnTaxi('player') then return end 
      if InspectFrame and InspectFrame:IsShown() then return end 

      SetUnitInfo(CONTINUED, cachedSpec or CONTINUED) 

      local timeSinceLastInspect = GetTime() - lastInspectRequest 
      if (timeSinceLastInspect >= 1.5) then 
         nextInspectRequest = 0 
      else 
         nextInspectRequest = 1.5 - timeSinceLastInspect 
      end 
      f:Show() 
   end 
end 


--- Character Info Sheet --- 
hooksecurefunc('PaperDollFrame_SetItemLevel', function(self, unit) 
   if (unit ~= 'player') then return end 

   local total, equip = GetAverageItemLevel() 
   if (total > 0) then total = string.format('%.1f', total) end 
   if (equip > 0) then equip = string.format('%.1f', equip) end 

   local ilvl = equip 
   if (equip ~= total) then 
      ilvl = equip .. ' / ' .. total 
   end 

   

   self.tooltip = detailColor .. STAT_AVERAGE_ITEM_LEVEL .. ' ' .. ilvl 
end) 


--- Handle Events --- 
f:SetScript('OnEvent', function(self, event, ...) 
   if (event == 'UNIT_INVENTORY_CHANGED') then 
      local unit = ... 
      if (UnitGUID(unit) == currentGUID) then 
         ScanUnit(unit, true) 
      end 
   elseif (event == 'INSPECT_READY') then 
      local guid = ... 
      if (guid ~= currentGUID) then return end 

      local gear = UnitGear(currentUNIT) 
      GearDB[currentGUID] = gear 

      local spec = UnitSpec(currentUNIT) 
      SpecDB[currentGUID] = spec 

      if (not gear) or (not spec) then 
         ScanUnit(currentUNIT, true) 
      else 
         SetUnitInfo(gear, spec) 
      end 
   end 
end) 

f:SetScript('OnUpdate', function(self, elapsed) 
   nextInspectRequest = nextInspectRequest - elapsed 
   if (nextInspectRequest > 0) then return end 

   self:Hide() 

   if currentUNIT and (UnitGUID(currentUNIT) == currentGUID) then 
      lastInspectRequest = GetTime() 
      NotifyInspect(currentUNIT) 
   end 
end) 

GameTooltip:HookScript('OnTooltipSetUnit', function(self) 
   local _, unit = self:GetUnit() 

   if (not unit) or (not CanInspect(unit)) then return end 
   if (UnitLevel(unit) > 0) and (UnitLevel(unit) < 10) then return end 

   currentUNIT, currentGUID = unit, UnitGUID(unit) 
   ScanUnit(unit) 
end) 