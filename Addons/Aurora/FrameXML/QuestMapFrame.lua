local _, private = ...

-- [[ Lua Globals ]]
local _G = _G
local select, next = _G.select, _G.next

-- [[ Core ]]
local F, C = _G.unpack(private.Aurora)

_G.tinsert(C.themes["Aurora"], function()
	local r, g, b = C.r, C.g, C.b

	local QuestMapFrame = _G.QuestMapFrame

	-- [[ Quest scroll frame ]]

	local QuestScrollFrame = _G.QuestScrollFrame
	local StoryHeader = QuestScrollFrame.Contents.StoryHeader

	QuestMapFrame.VerticalSeparator:Hide()
	QuestScrollFrame.Background:Hide()

	F.CreateBD(QuestScrollFrame.StoryTooltip)
	F.ReskinScroll(QuestScrollFrame.ScrollBar)

	-- Story header

	StoryHeader.Background:Hide()
	StoryHeader.Shadow:Hide()

	do
		local bg = F.CreateBDFrame(StoryHeader, .25)
		bg:SetPoint("TOPLEFT", 0, -1)
		bg:SetPoint("BOTTOMRIGHT", -4, 0)

		local hl = StoryHeader.HighlightTexture

		hl:SetTexture(C.media.backdrop)
		hl:SetVertexColor(r, g, b, .2)
		hl:SetPoint("TOPLEFT", 1, -2)
		hl:SetPoint("BOTTOMRIGHT", -5, 1)
		hl:SetDrawLayer("BACKGROUND")
		hl:Hide()

		StoryHeader:HookScript("OnEnter", function()
			hl:Show()
		end)

		StoryHeader:HookScript("OnLeave", function()
			hl:Hide()
		end)
	end

	-- [[ Quest details ]]

	local DetailsFrame = QuestMapFrame.DetailsFrame
	local RewardsFrame = DetailsFrame.RewardsFrame
	local CompleteQuestFrame = DetailsFrame.CompleteQuestFrame

	DetailsFrame:GetRegions():Hide()
	select(2, DetailsFrame:GetRegions()):Hide()
	select(4, DetailsFrame:GetRegions()):Hide()
	select(6, DetailsFrame.ShareButton:GetRegions()):Hide()
	select(7, DetailsFrame.ShareButton:GetRegions()):Hide()

	F.Reskin(DetailsFrame.BackButton)
	F.Reskin(DetailsFrame.AbandonButton)
	F.Reskin(DetailsFrame.ShareButton)
	F.Reskin(DetailsFrame.TrackButton)

	DetailsFrame.AbandonButton:ClearAllPoints()
	DetailsFrame.AbandonButton:SetPoint("BOTTOMLEFT", DetailsFrame, -1, 0)
	DetailsFrame.AbandonButton:SetWidth(95)

	DetailsFrame.ShareButton:ClearAllPoints()
	DetailsFrame.ShareButton:SetPoint("LEFT", DetailsFrame.AbandonButton, "RIGHT", 1, 0)
	DetailsFrame.ShareButton:SetWidth(94)

	DetailsFrame.TrackButton:ClearAllPoints()
	DetailsFrame.TrackButton:SetPoint("LEFT", DetailsFrame.ShareButton, "RIGHT", 1, 0)
	DetailsFrame.TrackButton:SetWidth(96)

	-- Rewards frame

	RewardsFrame.Background:Hide()
	select(2, RewardsFrame:GetRegions()):Hide()

	-- Scroll frame

	F.ReskinScroll(DetailsFrame.ScrollFrame.ScrollBar)
	_G.hooksecurefunc("QuestLogQuests_Update", function()
		for i, questLogHeader in next, QuestMapFrame.QuestsFrame.Contents.Headers do
			if not questLogHeader.isSkinned then
				F.ReskinExpandOrCollapse(questLogHeader)
				questLogHeader.isSkinned = true
			end
			questLogHeader:SetHighlightTexture("")
			if questLogHeader.questLogIndex then
				local _, _, _, _, isCollapsed = _G.GetQuestLogTitle(questLogHeader.questLogIndex)
				if isCollapsed then
					questLogHeader.plus:Show()
				else
					questLogHeader.plus:Hide()
				end
			end
		end
	end)

	-- Complete quest frame
	CompleteQuestFrame:GetRegions():Hide()
	select(2, CompleteQuestFrame:GetRegions()):Hide()
	select(6, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()
	select(7, CompleteQuestFrame.CompleteButton:GetRegions()):Hide()

	F.Reskin(CompleteQuestFrame.CompleteButton)

	-- [[ Quest log popup detail frame ]]

	local QuestLogPopupDetailFrame = _G.QuestLogPopupDetailFrame

	select(18, QuestLogPopupDetailFrame:GetRegions()):Hide()
	_G.QuestLogPopupDetailFrameScrollFrameTop:Hide()
	_G.QuestLogPopupDetailFrameScrollFrameBottom:Hide()
	_G.QuestLogPopupDetailFrameScrollFrameMiddle:Hide()

	F.ReskinPortraitFrame(QuestLogPopupDetailFrame, true)
	F.ReskinScroll(_G.QuestLogPopupDetailFrameScrollFrameScrollBar)
	F.Reskin(QuestLogPopupDetailFrame.AbandonButton)
	F.Reskin(QuestLogPopupDetailFrame.TrackButton)
	F.Reskin(QuestLogPopupDetailFrame.ShareButton)

	-- Show map button

	local ShowMapButton = QuestLogPopupDetailFrame.ShowMapButton

	ShowMapButton.Texture:Hide()
	ShowMapButton.Highlight:SetTexture("")
	ShowMapButton.Highlight:SetTexture("")

	ShowMapButton:SetSize(ShowMapButton.Text:GetStringWidth() + 14, 22)
	ShowMapButton.Text:ClearAllPoints()
	ShowMapButton.Text:SetPoint("CENTER", 1, 0)

	ShowMapButton:ClearAllPoints()
	ShowMapButton:SetPoint("TOPRIGHT", QuestLogPopupDetailFrame, -30, -25)

	F.Reskin(ShowMapButton)

	ShowMapButton:HookScript("OnEnter", function(self)
		self.Text:SetTextColor(_G.GameFontHighlight:GetTextColor())
	end)

	ShowMapButton:HookScript("OnLeave", function(self)
		self.Text:SetTextColor(_G.GameFontNormal:GetTextColor())
	end)

	-- Bottom buttons

	QuestLogPopupDetailFrame.ShareButton:ClearAllPoints()
	QuestLogPopupDetailFrame.ShareButton:SetPoint("LEFT", QuestLogPopupDetailFrame.AbandonButton, "RIGHT", 1, 0)
	QuestLogPopupDetailFrame.ShareButton:SetPoint("RIGHT", QuestLogPopupDetailFrame.TrackButton, "LEFT", -1, 0)
end)