-- Hide in combat Garrison Mission Completions

local frame = CreateFrame( "FRAME" )
frame:RegisterEvent( "PLAYER_REGEN_DISABLED" )
frame:RegisterEvent( "PLAYER_REGEN_ENABLED" )
local originalHandler, lastMissionID = GarrisonMissionAlertFrame_ShowAlert


local function newHandler( missionID )
	lastMissionID = missionID
end

frame:SetScript( "OnEvent", function( self, event )
	if event == "PLAYER_REGEN_DISABLED" then
		-- Entering Combat
		GarrisonMissionAlertFrame_ShowAlert = newHandler
	else
		-- Leaving Combat
		GarrisonMissionAlertFrame_ShowAlert = originalHandler

		if tonumber( lastMissionID ) then
			GarrisonMissionAlertFrame_ShowAlert( lastMissionID )
			lastMissionID = nil
		end
	end
end )