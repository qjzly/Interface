local F, C, L = unpack(select(2, ...))

if not C.automation.autoScreenShot then return end

----------------------------------------------------------------------------------------
--  Take screenshots of defined events (Sinaris)
----------------------------------------------------------------------------------------
local function OnEvent( self, event, ... )
    C_Timer.After( 1, function() Screenshot() end )
end

local EventFrame = CreateFrame( 'Frame' )
EventFrame:RegisterEvent( 'ACHIEVEMENT_EARNED' )
EventFrame:SetScript( 'OnEvent', OnEvent )