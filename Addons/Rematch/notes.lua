local _,L = ...
local rematch = Rematch
local card = RematchNotesCard

-- frame levels:
-- 11 lockFrame
-- 12 lockFrame clear/resize buttons
-- 15 RematchNotesCard
-- 16 scrollFrame
-- 17 focusGrabber
-- 18 editBox

function rematch:InitNotes()
	card:SetFrameLevel(15)
	card.lockFrame:SetFrameLevel(11)
	card.scrollFrame.editBox:SetFrameLevel(18)
	local settings = RematchSettings
	if settings.NotesLeft then -- if we have a saved position, move to that
		card:ClearAllPoints()
		card:SetPoint("BOTTOMLEFT",settings.NotesLeft,settings.NotesBottom)
		card:SetSize(settings.NotesWidth,settings.NotesHeight)
	end
	SetPortraitToTexture(card.icon,"Interface\\Icons\\INV_Scroll_03")
	rematch:HookScript("OnShow",rematch.UpdateNotesESCability)
	rematch:HookScript("OnHide",rematch.UpdateNotesESCability)
end

function rematch:NotesCardStopMovingOrSizing()
	card:StopMovingOrSizing()
	local settings = RematchSettings
	settings.NotesLeft = card:GetLeft()
	settings.NotesBottom = card:GetBottom()
	settings.NotesWidth = card:GetWidth()
	settings.NotesHeight = card:GetHeight()
end

function rematch:ShowNotesCard(teamName,force)
	if not force and card.locked then
		return -- notes are locked, don't show new notes unless forced (clicking new note)
	end
	local saved = RematchSaved[teamName]
	if saved then
		if force then
			card.locked = true
			if card:IsVisible() then
				rematch:NotesCardSave() -- if we're maybe switching from one team to another, save previous notes if needed
			end
		end
		card.teamName = teamName
		card.scrollFrame.editBox:SetText(saved.notes or "")
		card.title:SetText(rematch:GetTeamTitle(teamName))
		card.scrollFrame.editBox:SetCursorPosition(0)
		card.save:SetShown(card.scrollFrame.editBox:HasFocus())
		rematch:UpdateNotesCardLock()
		card:Show()
	end
end

function rematch:HideNotesCard()
	if not card.locked then
		card:Hide()
	end
end

function rematch:LockNotesCard(teamName)
	if teamName ~= card.teamName then
		rematch.ShowNotesCard(self,teamName,true)
	else
		card.locked = not card.locked
	end
	rematch:UpdateNotesCardLock()
end

function rematch:NotesCardOnHide()
	rematch:NotesCardSave()
	rematch:UpdateNotesESCability()
	card.locked = nil
	card.teamName = nil
end

-- when hiding (or switching to another note) we save the contents
-- of the editBox to the team assigned to the card
function rematch:NotesCardSave()
	if card.undo:IsShown() then -- only bother if undo is up
		local saved = RematchSaved[card.teamName]
		if saved then
			local text = card.scrollFrame.editBox:GetText()
			if text:trim():len()>0 then
				saved.notes = text
			else
				saved.notes = nil
			end
			if rematch.drawer.teams:IsVisible() then
				rematch:UpdateTeamList()
			end
		end
		card.undo:Hide()
		rematch:StartTimer("UpdateWindow",0,rematch.UpdateWindow)
	end
end

-- to prevent onenter/onleave spasms if the card overlaps the button that spawn them, the
-- mouse is disabled for these when the notes are not locked
local elements = { card, card.scrollFrame, card.scrollFrame.editBox, card.scrollFrame.focusGrabber }
function rematch:UpdateNotesCardLock()
	local locked = card.locked and true
	for _,element in pairs(elements) do
		element:EnableMouse(locked)
	end
	card.lockFrame:SetShown(locked)
end

function rematch:NotesCardUndo()
	card.scrollFrame.editBox:SetText(RematchSaved[card.teamName].notes or "")
	card.scrollFrame.editBox:SetCursorPosition(0)
	card.undo:Hide()
	if not card.scrollFrame.editBox:HasFocus() then
		card.save:Hide()
	end
end

function rematch:NotesCardOnTextChanged()
	local text = self:GetText() or ""
	local saved = RematchSaved[card.teamName].notes
	card.undo:SetShown(text~=saved and (saved or text:len()>0))
end

-- this is likely called from a "Set Notes" menu; force a locked card of the passed team
function rematch:SetNotes(teamName)
	if RematchSaved[teamName] then
		card.locked = true
		rematch:ShowNotesCard(teamName,true)
		local editBox = card.scrollFrame.editBox
		editBox:SetFocus(true)
		editBox:SetCursorPosition(editBox:GetText():len())
	end
end

-- Most ESC handling is done through the OnKeyDown in ESCHandler, but that only works
-- while Rematch is on screen.  Since notes can exist on screen without Rematch, the
-- RematchNotesCard will join UISpecialFrames when Rematch is hidden and notes are up.
function rematch:UpdateNotesESCability()
	if not RematchSettings.NotesNoESC and card:IsVisible() and not rematch:IsVisible() then
		-- if esc not disabled, card is visible and rematch is not
		if not tContains(UISpecialFrames,"RematchNotesCard") then -- then we want notes in UISpecialFrames
			tinsert(UISpecialFrames,"RematchNotesCard")
		end
	else -- otherwise we don't want notes in UISpecialFrames
		for i=#UISpecialFrames,1,-1 do
			if UISpecialFrames[i]=="RematchNotesCard" then
				tremove(UISpecialFrames,i)
			end
		end
	end
end

-- toggles locked card on/off screen for currently loaded team
function rematch:ToggleNotes()
	local loadedTeam = RematchSettings.loadedTeam
	if card:IsVisible() then
	  card:Hide()
	elseif RematchSaved[loadedTeam] then
		card.teamName = nil
	  Rematch:ShowNotesCard(loadedTeam)
	  Rematch:LockNotesCard(loadedTeam)
	end
end

