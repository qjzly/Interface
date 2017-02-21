if not IsAddOnLoaded("Bugger") then return end

local F, C, L = unpack(select(2, ...))

-- Lua Globals --
local _G = _G

_G.hooksecurefunc(_G.Bugger, "SetupFrame", function()
	local BuggerFrame = _G.BuggerFrame
	-- Properly enable dragging...
	BuggerFrame:EnableMouse(true)
	BuggerFrame:SetScript("OnDragStart", BuggerFrame.StartMoving)
	BuggerFrame:SetScript("OnDragStop", BuggerFrame.StopMovingOrSizing)


	BuggerFrame:DisableDrawLayer("OVERLAY")
	_G.BuggerFrameTitleBG:Hide()
	_G.BuggerFrameDialogBG:Hide()
	F.CreateBD(BuggerFrame)
	F.CreateSD(BuggerFrame)

	BuggerFrame.titleButton:ClearAllPoints()
	BuggerFrame.titleButton:SetPoint("TOPLEFT")
	BuggerFrame.titleButton:SetPoint("BOTTOMRIGHT", BuggerFrame, "TOPRIGHT", 0, -24)
	BuggerFrame.options:SetPoint("TOPRIGHT", "$parentClose", "TOPLEFT", -2, 0)

	F.ReskinClose(_G.BuggerFrameClose)
	F.ReskinScroll(BuggerFrame.scrollFrame.ScrollBar)

	F.Reskin(BuggerFrame.reload)
	F.Reskin(BuggerFrame.clear)
	F.Reskin(BuggerFrame.showLocals)

	F.Reskin(BuggerFrame.next)
	F.Reskin(BuggerFrame.previous)

	for i = 1, 3 do
		local tab = _G["BuggerFrameTab"..i]
		F.ReskinTab(tab)
	end
end)

