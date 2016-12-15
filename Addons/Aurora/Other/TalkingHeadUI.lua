local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
--local select, pairs = _G.select, _G.pairs

-- [[ WoW API ]]
local CreateFrame = _G.CreateFrame

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)


C.themes["Blizzard_TalkingHeadUI"] = function()

	-- TalkingHeadFrame = F.dummy
	-- TalkingHeadFrame.MainFrame = F.dummy
	-- TalkingHeadFrame.PortraitFrame = F.dummy
	TalkingHeadFrame.MainFrame.Model.PortraitBg:Hide()
	
	F.ReskinClose(TalkingHeadFrame.MainFrame.CloseButton)
	TalkingHeadFrame.MainFrame.CloseButton:Hide()

	local scale = .8

	--Sanitize
	if scale < 0.5 then	scale = 0.5
	elseif scale > 2 then scale = 2	end

	--:SetScale no longer triggers OnSizeChanged in Legion, and as such the mover will not update its size
	--Calculate dirtyWidth/dirtyHeight based on original size and scale
	--This way the mover frame will use the right size when we manually trigger "OnSizeChanged"
	local width = TalkingHeadFrame:GetWidth() * scale
	local height = TalkingHeadFrame:GetHeight() * scale
	TalkingHeadFrame.dirtyWidth = width
	TalkingHeadFrame.dirtyHeight = height

	TalkingHeadFrame:SetScale(scale)

	--Reset Model Camera
	-- local model = TalkingHeadFrame.MainFrame.Model
	-- if model.uiCameraID then
	-- 	model:RefreshCamera()
	-- 	Model_ApplyUICamera(model, model.uiCameraID)
	-- end

	--Use this to prevent the frame from auto closing, so you have time to test things.
	-- TalkingHeadFrame:UnregisterEvent("SOUNDKIT_FINISHED")
	-- TalkingHeadFrame:UnregisterEvent("TALKINGHEAD_CLOSE")
	-- TalkingHeadFrame:UnregisterEvent("LOADING_SCREEN_ENABLED")

	--Prevent WoW from moving the frame around
	TalkingHeadFrame.ignoreFramePositionManager = true
	UIPARENT_MANAGED_FRAME_POSITIONS["TalkingHeadFrame"] = nil

	--Set default position
	TalkingHeadFrame:ClearAllPoints()
	TalkingHeadFrame:SetPoint("TOP", 0, -100)
	
	--Iterate through all alert subsystems in order to find the one created for TalkingHeadFrame, and then remove it.
	--We do this to prevent alerts from anchoring to this frame when it is shown.
	for index, alertFrameSubSystem in ipairs(AlertFrame.alertFrameSubSystems) do
		if alertFrameSubSystem.anchorFrame and alertFrameSubSystem.anchorFrame == TalkingHeadFrame then
			table.remove(AlertFrame.alertFrameSubSystems, index)
		end
	end

end