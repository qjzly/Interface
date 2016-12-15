function regulartab() 
   SetCVar("TargetPriorityAllowAnyOnScreen", 0) 
   SetCVar("Targetnearestuseold", 1) 
end 

local frame = CreateFrame("FRAME", "RegularTab"); 
   frame:RegisterEvent("PLAYER_ENTERING_WORLD"); 
      local function eventHandler(self, event, ...) 
          regulartab(); 
end 
frame:SetScript("OnEvent", eventHandler);