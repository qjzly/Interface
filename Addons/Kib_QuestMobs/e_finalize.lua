local LocalDatabase, _, SavedVars = unpack(select(2, ...))

--<<IMPORTANT STUFF>>-------------------------------------------------------------------------------<<>>

    local Dummy = CreateFrame("Frame")
    Dummy:RegisterEvent("ADDON_LOADED")

--<<REGISTER EVENTS>>-------------------------------------------------------------------------------<<>>

    Dummy:SetScript("OnEvent", function(self,_, Addon)
        if Addon == LocalDatabase.addonName then
            if SavedVars.State == true or SavedVars.State == nil then

                LocalDatabase.Player_Name = UnitName("player")
                self:RegisterEvent("QUEST_TURNED_IN")
                self:RegisterEvent("QUEST_LOG_UPDATE")
                self:RegisterEvent("NAME_PLATE_UNIT_ADDED")
                self:RegisterEvent("NAME_PLATE_UNIT_REMOVED")
                self:RegisterEvent("PLAYER_ENTERING_WORLD")
                self:RegisterEvent("UNIT_THREAT_LIST_UPDATE")

                self:SetScript("OnEvent", function(self, event, ...) LocalDatabase[event](...) end)

                LocalDatabase.InitConfigElements()  
            end

            self:UnregisterEvent("ADDON_LOADED")
        end
    end)

----------------------------------------------------------------------------------------------------<<END>>