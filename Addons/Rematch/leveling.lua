
local _,L = ...
local rematch = Rematch
local settings
local queue = rematch.drawer.queue

-- settings.CurrentLevelingPet is depreciated; now the top pet in the queue is the current leveling pet
-- settings.LevelingQueue is the master "unordered" list of petIDs

local levelingQueue -- will be settings.LevelingQueue, with the current leveling pet at top
local levelingLoadouts = {} -- indexed 1-3 loadout slots that contain a leveling pet and the petID within
local topLevelingPicks = {} -- top three leveling pets to load
local levelingPets = {} -- for faster lookups, this is all leveling pets in the queue indexed by petID
local skippedLevelingPicks = {} -- picks that we last skipped (indexed by petID)

rematch.sortIcons = {
	"Interface\\Icons\\misc_arrowlup", -- 1 = ascending
	"Interface\\Icons\\misc_arrowdown", -- 2 = descending
	"Interface\\Icons\\Ability_Hunter_FocusedAim", -- 3 = median
	"Interface\\Icons\\Icon_UpgradeStone_Beast_Uncommon", -- 4 = type
	"Interface\\Icons\\Spell_Holy_BorrowedTime" -- 5 = time
}

rematch.levelingIcon = "Interface\\AddOns\\Rematch\\textures\\leveling.blp"

function rematch:InitLeveling()
	settings = RematchSettings
	levelingQueue = settings.LevelingQueue

	queue.levelingSlot.icon:SetTexture(rematch.levelingIcon)
	queue.levelingSlot.leveling:Show()
	queue.levelingSlot.menu = "levelingSlot"
	queue.resultsBar.label:SetText(L["Queued:"])
	queue.filter.icon:SetTexture("Interface\\Icons\\INV_Misc_EngGizmos_30")
	queue.title.label:SetText(L["Leveling"])
	queue.title.sortLabel:SetText(L["Active"])

	-- setup queue list scrollFrame
	local scrollFrame = queue.list.scrollFrame
	scrollFrame.update = rematch.UpdateQueueList
	HybridScrollFrame_CreateButtons(scrollFrame, "RematchQueueListButtonTemplate")
	scrollFrame.emptyCapture:RegisterForClicks("AnyUp")
	rematch:RegisterEvent("UPDATE_SUMMONPETS_ACTION")

	-- setup levelingCarousel
	local pets = rematch.dialog.levelingCarousel.carousel.child.pets
	for i=1,3 do
		pets[i+1]:SetPoint("LEFT",pets[i],"RIGHT")
		pets[i+4]:SetPoint("RIGHT",pets[i==1 and 1 or i==2 and 5 or i==3 and 6],"LEFT")
	end
	Rematch:LevelingCarouselResizePets()

end

-- this event is required to catch when pets gain xp
function rematch.events.UPDATE_SUMMONPETS_ACTION()
	rematch:UpdateOwnedSpeciesAt25()
	rematch:StartTimer("ProcessQueue",0.5,rematch.ProcessQueue)
end

function rematch:UpdateLeveling()
	if rematch:IsVisible() then
		rematch:UpdateCurrentLevelingBorders()
	end
	if queue:IsVisible() then
		rematch:UpdateLevelingSlot()
		rematch:UpdateQueueList()
		rematch:UpdateQueueTitle()
	end
	if PetJournal and PetJournal:IsVisible() then
		rematch:UpdateLevelingMarkers()
	end
end

function rematch:IsPetLeveling(petID)
	return levelingPets[petID]
end

-- returns true if petID is below 25 and can battle
-- also returns pet's level (including partial level)
function rematch:PetCanLevel(petID)
	if petID and type(petID)=="string" and petID:match("^Battle") then
		local _,_,level,xp,maxXp,_,_,_,_,_,_,_,_,_,canBattle = C_PetJournal.GetPetInfoByPetID(petID)
		if level and level<25 and canBattle then
			return true,level+(xp/maxXp)
		end
	end
end

function rematch:GetCurrentLevelingPet()
	return levelingQueue[1]
end

-- returns the petID of the indexed pick (top 3 pets to load for leveling pets)
function rematch:GetLevelingPick(index)
	return topLevelingPicks[index]
end

function rematch:GetNumLevelingPets()
	return #levelingQueue
end

-- takes a petID and returns true if it's a valid candidate for topLevelingPicks
function rematch:IsPetPickable(petID)
	local health = C_PetJournal.GetPetStats(petID)
	if C_PetJournal.PetIsSummonable(petID) or (health and health<1 and (not settings.QueueSkipDead or settings.QueueNoPreferences)) then
		-- passed first test, pet is summonable (or has health and QueueSkipDead not enabled)
		local team = RematchSaved[settings.loadedTeam]
		if team and not settings.QueueNoPreferences then
			local minHP = team.minHP
			if minHP then
				local petType = select(10,C_PetJournal.GetPetInfoByPetID(petID))
				if team.expectedDD then -- expected damage defined, adjust minHP for expected damage
					if rematch.hintsOffense[team.expectedDD][1]==petType then
						minHP = minHP*1.5
					elseif rematch.hintsOffense[team.expectedDD][2]==petType then
						minHP = minHP*2/3
					end
				end
				if health<minHP then
					if not ((petType==6 or petType==10) and team.allowMM) then
						return false -- if minHP defined, health is less than minHP and allowMM not enabled, failed
					end
				end
			end
			if team.maxXP and levelingPets[petID]>team.maxXP then
				return false -- if maxXP defined and pet's level.xp is greater, failed
			end
		end
		return true
	end
end

--[[ ProcessQueue

	This is the heart of the leveling queue.

	1) Save pets that are currently in loadouts for potential swaps later on.
	2) Note old top-most leveling pet.
	3) Go through levelingQueue and:
	  a) remove any pets that can't level (25 or missing)
	  b) fill levelingPets with valid leveling pets and their level
	4) Sort levelingQueue if FullSort and there's a QueueSortOrder
	5) Fill topLevelingPicks and skippedLevelingPicks
	6) Go through loadouts and load any topLevelingPicks that aren't loaded
	7) If top-most leveling pet changes, send a toast (unless noToast true)
	8) Schedule an UpdateWindow to happen in the next frame.

	In reaction to an event (leaving battle, journal update, etc) it should be called
	with no parameters: rematch:ProcessQueue() to send a toast when the top pet changes.

	If noToast is true, when the current leveling pet changes a toast will not be displayed.
	outgoingPetID should be defined when a pet has just been removed from levelingQueue (so it can be swapped)

]]

function rematch:ProcessQueue(noToast,outgoingPetID)

	if select(2,C_PetJournal.GetNumPets())==0 then -- if pets not loaded, come back in half a second to try again
		rematch:StartTimer("PetsRanAwayFromQueue",0.5,rematch.ProcessQueue)
		return
	end

	rematch:StopTimer("ProcessQueue") -- stop any delayed ProcessQueues happening

	-- if there's an existing queue (possible leveling pet loaded), there's a chance a pet needs loaded, which
	-- can't happen in combat, battle or pvp.
	if (InCombatLockdown() or C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo()) and #levelingQueue>0 then
		rematch.queueNeedsProcessed = true -- or we need to swap while in a pet battle
		return
	end

--	rematch:print("ProcessQueue",GetTime())

	-- fill levelingLoadouts with the petIDs in the slots they're currently loaded (if any)
	-- this is later used to verify the proper leveling petIDs are loaded (or to load new ones to these slots)
	local loadedTeam = RematchSaved[settings.loadedTeam]
	for i=1,3 do
		levelingLoadouts[i] = nil
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		if loadedTeam and loadedTeam[i][1]==petID then
			-- pets are saved as themselves in this slot, don't replace it (do nothing)
		elseif settings.ManuallySlotted[petID] then
			-- pet was manually slotted, leave it alone
		elseif petID==outgoingPetID then
			-- special case for outgoing pet (it's not in queue) to replace
			levelingLoadouts[i] = true
		elseif tContains(levelingQueue,petID) then
			-- otherwise if pet is in the queue, mark it for replacement
			-- (need to tContains since new pets can be added to table before this)
			levelingLoadouts[i] = petID
		end
	end

	local oldLevelingPetID = rematch:GetCurrentLevelingPet()

	-- go through levelingQueue and remove pets that are 25, don't exist or are duplicates,
	-- add the remaining ones to levelingPets (level.xp in latter)
	wipe(levelingPets)
	for i=#levelingQueue,1,-1 do
		local petID = levelingQueue[i]
		local canLevel,level = rematch:PetCanLevel(petID)
		if canLevel and not levelingPets[petID] then
			levelingPets[petID] = level -- level can be partial (23.5 is level 23 and 50% towards 24)
		else
			table.remove(levelingQueue,i) -- if pet can't level or already in queue, remove this entry
		end
	end

	-- remove pets that are no longer leveling from timeline
	local timeline = settings.LevelingTimeline
	for i=#timeline,1,-1 do
		if not levelingPets[timeline[i]] then
			tremove(timeline,i)
		end
	end

	-- levelingQueue sorted here if there's a sort order
	if settings.QueueFullSort and settings.QueueSortOrder then
		rematch:SortQueue()
	end

	-- populate topLevelingPicks
	local pickIndex = 1 -- index to topLevelingPicks
	wipe(topLevelingPicks)
	wipe(skippedLevelingPicks)
	-- pick out preferred pets first and save which pets are skipped
	for i=1,#levelingQueue do
		local petID = levelingQueue[i]
		if rematch:IsPetPickable(petID) then
			if pickIndex<=3 then
				topLevelingPicks[pickIndex] = petID
				pickIndex = pickIndex + 1
			end
		else
			skippedLevelingPicks[petID] = true
		end
	end
	-- if top 3 picks not made, get top-most that aren't already picked
	for i=1,#levelingQueue do
		if pickIndex <= 3 then
			if not tContains(topLevelingPicks,levelingQueue[i]) then
				topLevelingPicks[pickIndex] = levelingQueue[i]
				pickIndex = pickIndex + 1
			end
		else
			break -- don't need to run through rest of queue once top 3 picks chosen
		end
	end

	-- if petIDs in levelingLoadouts don't match topLevelingPicks, load them
	local pickIndex = 1
	for i=1,3 do
		local petID = levelingLoadouts[i]
		if petID then
			local pickID = topLevelingPicks[pickIndex]
			if pickID and pickID~=petID then
				rematch:LoadPetSlot(i,pickID)
			end
			pickIndex = pickIndex + 1
		end
	end

	-- if toast is true and current leveling pet changed, send a toast
	local newLevelingPetID = rematch:GetCurrentLevelingPet()
	if not noToast and oldLevelingPetID and newLevelingPetID~=oldLevelingPetID then
		rematch:ToastNextLevelingPet(newLevelingPetID)
	end

	if rematch:IsVisible() then
		rematch:StartTimer("UpdateWindow",0,rematch.UpdateWindow)
		if rematch:IsDialogOpen("LevelingCarousel") then
			rematch:LevelingCarouselReset()
		end
	elseif PetJournal and PetJournal:IsVisible() then
		rematch:UpdateLevelingMarkers()
	end

end

-- sorts the queue based on current settings
function rematch:SortQueue()
	local petID = rematch:GetCurrentLevelingPet()
	if settings.QueueSortOrder==5 then -- sort by time
		local timeline = settings.LevelingTimeline
		-- copy timeline to levelingQueue
		if #timeline==#levelingQueue then
			for i=1,#timeline do
				levelingQueue[i] = timeline[i]
			end
		end
	else -- sort orders 1-4 do the sort by level
		table.sort(settings.LevelingQueue,rematch.LevelingQueueSort)
	end
	if settings.KeepCurrentOnSort and petID then
		rematch:RemoveFromQueue(petID)
		rematch:InsertIntoLevelingQueue(petID,1) -- move old leveling pet back to top if KeepCurrentOnSort enabled
	end
end

-- This does a full sort between e1 and e2 (petIDs)
-- Levels sort by level, then name, then petID.
-- Type sorts by type, then ascending level, then name, then petID.
function rematch.LevelingQueueSort(e1,e2)
	local order = settings.QueueSortOrder

	local name1, name2, type1, type2

	if order==4 then -- for type sort
		name1,_,type1 = select(8,C_PetJournal.GetPetInfoByPetID(e1))
		name2,_,type2 = select(8,C_PetJournal.GetPetInfoByPetID(e2))
		if type1 < type2 then
			return true
		elseif type1 > type2 then
			return false
		end
		-- if petType1 == petType2, continue to sort by level
	end

	local level1 = levelingPets[e1]
	local level2 = levelingPets[e2]
	if order==3 then -- for median sort, levels are distance from 10.5
		level1 = abs(level1-10.5)
		level2 = abs(level2-10.5)
	end
	if level1==level2 then -- if levels are the same, sort by their name next
		if not name1 then
			name1 = select(8,C_PetJournal.GetPetInfoByPetID(e1))
			name2 = select(8,C_PetJournal.GetPetInfoByPetID(e2))
		end
		if name1==name2 then -- if names are the same, sort by the petID for a stable sort
			return e1<e2
		else
			return name1<name2
		end
	else
		if order==2 then -- if descending, higher levels first
			return level1>level2
		else -- if ascending or median, lower levels (or distance from 10.5) first
			return level1<level2
		end
	end
end

--[[ Leveling Slot ]]

function rematch:UpdateLevelingSlot()
	local petID = rematch:GetCurrentLevelingPet()
	local slot = rematch.drawer.queue.levelingSlot
	slot.petID = petID
	if petID then
		local _,_,level,_,_,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(petID)
		slot.icon:SetTexture(icon)
		slot.level:SetText(level)
	else
		slot.icon:SetTexture(rematch.levelingIcon)
	end
	slot.levelBG:SetShown(petID and true)
	slot.level:SetShown(petID and true)
end

function rematch:LevelingQueueMouseoverWarning(petID)
	local canLevel = rematch:PetCanLevel(petID)
	if not canLevel then
		rematch:ShowTooltip(L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t This pet can't level"],nil,true)
	elseif settings.QueueFullSort then
		if rematch:IsPetLeveling(petID) then
			rematch:ShowTooltip(L["\124TInterface\\Buttons\\UI-GroupLoot-Pass-Up:16\124t Active Sort is enabled"],L["This pet is already in the queue.\n\nYou can't rearrange the order of pets while the queue is actively sorted."],true)
		else
			rematch:ShowTooltip(L["\124TInterface\\DialogFrame\\UI-Dialog-Icon-AlertNew:16\124t Active Sort is enabled"],L["The queue is actively sorted. This pet will be sorted with the rest."],true)
		end
	end
end

function rematch:LevelingSlotOnEnter()
	local cursorType,petID = GetCursorInfo()
	local canLevel = cursorType=="battlepet" and rematch:PetCanLevel(petID)
	if not rematch:GetCurrentLevelingPet() then -- if leveling slot is empty
		if canLevel then
			return -- don't show helpplate (or floatingpetcard) if a pet that can level is over empty slot
		end
		HelpPlate_TooltipHide()
		HelpPlateTooltip.ArrowLEFT:Show()
		HelpPlateTooltip.ArrowGlowLEFT:Show()
		HelpPlateTooltip:SetPoint("RIGHT", self, "LEFT", -10, 0)
		HelpPlateTooltip.Text:SetText(L["This is the leveling slot.\n\nDrag a level 1-24 pet here to set it as the active leveling pet.\n\nWhen a team is saved with a leveling pet, that pet's place on the team is reserved for future leveling pets.\n\nThis slot can contain as many leveling pets as you want. When a pet reaches 25 the topmost pet in the queue becomes your new leveling pet."])
		HelpPlateTooltip:Show()
	else
		if cursorType=="battlepet" then
			rematch:LevelingQueueMouseoverWarning(petID)
		end
		rematch:ShowFloatingPetCard(self.petID,self)
	end
end

function rematch:LevelingSlotOnLeave()
	HelpPlate_TooltipHide()
	rematch:HideFloatingPetCard()
	RematchTooltip:Hide()
end

function rematch:LevelingSlotOnReceiveDrag()
	if rematch:CantChangeQueue() then
		return
	end
	local petID = rematch:GetCursorPetID()
	if rematch:PetCanLevel(petID) and (not rematch:IsPetLeveling(petID) or not settings.QueueFullSort) then
		rematch:StartLevelingPet(petID)
		RematchTooltip:Hide()
		ClearCursor()
	end
end

-- this does a raw removal of a petID from levelingQueue
-- use with care! it's intended to be used for further queue manipulation
function rematch:RemoveFromQueue(petID)
	for i=#levelingQueue,1,-1 do
		if levelingQueue[i]==petID then
			tremove(levelingQueue,i)
			return
		end
	end
end

function rematch:SwapQueuePositions(index1,index2)
	local swap = levelingQueue[index1]
	levelingQueue[index1] = levelingQueue[index2]
	levelingQueue[index2] = swap
	rematch:ProcessQueue(true)
end

-- this is to be called in Start/AddLevelingPet and FillQueue right before ProcessQueue.
-- if a loaded team has leveling pets assigned but no leveling pets in their slots
-- (for instance if queue is empty), then just before processing the queue this
-- will move the incoming petID(s) into a slot that doesn't already have a petID
function rematch:MaybeSlotNewLevelingPet(...)
	for slot=1,select("#",...) do
		local petID = select(slot,...)
		local team = RematchSaved[settings.loadedTeam]
		if team and petID and (not C_PetJournal.PetIsSlotted(petID)) and (team[1][1]==0 or team[2][1]==0 or team[3][1]==0) then
			for i=1,3 do
				local loadedID = C_PetJournal.GetPetLoadOutInfo(i)
				if team[i][1]==0 and not rematch:IsPetLeveling(loadedID) then
					rematch:LoadPetSlot(i,petID)
					return
				end
			end
		end
	end
end

function rematch:StartLevelingPet(petID)
	if rematch:CantChangeQueue() or not rematch:PetCanLevel(petID) then
		return
	end
	if settings.QueueSortOrder and settings.QueueFullSort then
		-- a fully-sorted queue can't force a pet to top slot; add it instead
		rematch:AddLevelingPet(petID)
	else
		rematch:RemoveFromQueue(petID)
		rematch:InsertIntoLevelingQueue(petID,1)
--		tinsert(levelingQueue,1,petID)
		rematch:MaybeSlotNewLevelingPet(petID)
		rematch:ProcessQueue(true)
		if queue:IsVisible() then
			rematch:ListScrollToTop(queue.list.scrollFrame)
			queue.shinePetID = petID
		end
	end
end

function rematch:StopLevelingPet(petID)
	if rematch:CantChangeQueue() or not rematch:PetCanLevel(petID) then
		return
	end
	rematch:RemoveFromQueue(petID)
	rematch:ProcessQueue(true,petID)
end

function rematch:AddLevelingPet(petID)
	if rematch:CantChangeQueue() then
		return
	end
	if not tContains(levelingQueue,petID) then
		rematch:InsertIntoLevelingQueue(petID)
--		tinsert(levelingQueue,petID)
	end
	rematch:MaybeSlotNewLevelingPet(petID)
	rematch:ProcessQueue(true)
	if queue:IsVisible() then
		for i=1,#levelingQueue do
			if levelingQueue[i]==petID then
				rematch:ListScrollToIndex(queue.list.scrollFrame,i)
				queue.shinePetID = petID
				return
			end
		end
	end
end

--[[ Queue List ]]

function rematch:UpdateQueueList()

	local numData = #levelingQueue
	local scrollFrame = queue.list.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons
	local lastButton
	local cursorType,petOnCursor = GetCursorInfo()
	petOnCursor = cursorType=="battlepet" and petOnCursor

	scrollFrame.stepSize = floor(scrollFrame:GetHeight()*.65)

	for i=1,min(#buttons,scrollFrame:GetHeight()/scrollFrame.buttonHeight+2) do
		local index = i + offset
		local button = buttons[i]
		if ( index <= numData) then
			button.petID = levelingQueue[index]
			button.index = index
			local petID = button.petID
			local onCursor = petOnCursor==petID
			local _,_,level,xp,maxXp,_,_,_,icon,petType = C_PetJournal.GetPetInfoByPetID(petID)
			if icon then
				local isSelected = button.petID==rematch:GetCurrentLevelingPet()
				button.icon:SetTexture(icon)
				button.level:SetText(level)
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
				if onCursor then
					button.rarity:SetGradientAlpha("VERTICAL",.4,.4,.4,.25,.4,.4,.4,.6)
				elseif isSelected then
					button.rarity:SetGradientAlpha("VERTICAL",1,.82,0,.75,r,g,b,.6)
				else
			    button.rarity:SetGradientAlpha("VERTICAL",r,g,b,.25,r,g,b,.6)
				end
				button.type:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
				if onCursor then
					button:SetAlpha(skippedLevelingPicks[petID] and 0.167 or 0.33)
				else
					button:SetAlpha(skippedLevelingPicks[petID] and 0.4 or 1)
				end
			end
			button.selected:SetShown(button.petID and button.petID==rematch:GetCurrentLevelingPet())
			lastButton = button
			button:Show()
			-- if pet is marked to shine
			if queue.shinePetID==petID then
				rematch:ShineOnYouCrazy(button,"CENTER",-14,0)
				queue.shinePetID = nil
			end
		else
			button.petID = nil
			button.index = nil
			button:Hide()
		end
	end

	queue.resultsBar.count:SetText(numData)

	HybridScrollFrame_Update(scrollFrame,28*numData,28)

	rematch:UpdateEmptyCapture()
end

-- used in resize and regular update
-- a scrollframe can't receive clicks/drags; the invisible emptyCapture button will capture
-- clicks/drags to the empty area of scrollframe.
function rematch:UpdateEmptyCapture()
	local lastButton
	local scrollFrame = queue.list.scrollFrame
	local emptyCapture = scrollFrame.emptyCapture
	if not scrollFrame.scrollBar:IsEnabled() then
		-- find the last visible button to anchor top of emptyCapture to
		for i=1,#scrollFrame.buttons do
			if scrollFrame.buttons[i]:IsVisible() then
				lastButton = scrollFrame.buttons[i]
			else
				break
			end
		end
		if lastButton then -- anchor emptyCapture to the last visible button
			emptyCapture:SetPoint("TOPLEFT",lastButton,"BOTTOMLEFT",0,0)
		else -- no buttons are visible, anchor to top of scrollFrame
			emptyCapture:SetPoint("TOPLEFT",scrollFrame,"TOPLEFT")
		end
		emptyCapture:Show()
	else
		emptyCapture:Hide()
	end
end

-- when pet dragged over QueueListButton (or capture area)
function rematch:QueueListOnEnter()
	if self and self.petID then
		rematch:ShowFloatingPetCard(self.petID,self)
	end
	local cursorType,petID = GetCursorInfo()
	if cursorType=="battlepet" then
		rematch:LevelingQueueMouseoverWarning(petID)
		if rematch:PetCanLevel(petID) then
			queue.list.scrollFrame.insertLine.timer = 1 -- start immediately
			queue.list.scrollFrame.insertLine.parent = self
			queue.list.scrollFrame.insertLine:Show()
		end
	end
end

function rematch:QueueListOnLeave()
	rematch:HideFloatingPetCard()
	queue.list.scrollFrame.insertLine:Hide()
	RematchTooltip:Hide()
end

function rematch:QueueListOnDoubleClick()
	if rematch:GetCurrentLevelingPet()==self.petID then
		C_PetJournal.SummonPetByGUID(self.petID)
	else
		rematch:StartLevelingPet(self.petID)
	end
	rematch:HideFloatingPetCard(true)
end

function rematch:GetQueuePosition(petID)
	for i=1,#levelingQueue do
		if levelingQueue[i]==petID then
			return i
		end
	end
end

-- insertLine's OnUpdate that moves the line to where a battlepet on cursor will insert into queue
-- queue.list.scrollFrame.insertLine.index will be the index in the queue to insert the pet
-- an index of -1 means to add it to the end
function rematch:QueueListInsertLineOnUpdate(elapsed)
	self.timer = self.timer + elapsed
	if self.timer>0.1 then
		self.timer = 0
		local parent = self.parent
		if parent==queue.list.scrollFrame.emptyCapture then
			self:SetPoint("CENTER",queue.list.scrollFrame.emptyCapture,"TOP")
			self.index = -1 -- add to end of queue
		elseif parent then
			local _,y = GetCursorPosition()
			local top,bottom = parent:GetTop(),parent:GetBottom()
			local center = (top+bottom)*parent:GetEffectiveScale()/2
			if y>center then -- battlepet on cursor goes to slot previous to mouseover
				if top<=queue.list.scrollFrame:GetTop() then
					self:SetPoint("CENTER",parent,"TOP")
				else -- if above top of scrollFrame, get it off screen (but still "visible" so OnUpdate runs)
					self:ClearAllPoints()
				end
				self.index = parent.index
			else -- battlepet on cursor goes to slot after the mouseover
				if bottom>queue.list.scrollFrame:GetBottom()-6 then
					self:SetPoint("CENTER",parent,"BOTTOM")
				else -- move off screen if below bottom of scrollFrame
					self:ClearAllPoints()
				end
				self.index = parent.index+1
			end
		else
			self:Hide()
		end
	end
end

function rematch:QueueListOnReceiveDrag()
	if rematch:CantChangeQueue() then
		return
	end
	local petID = rematch:GetCursorPetID()
	if petID then
		if GetMouseButtonClicked()=="RightButton" then
			ClearCursor()
			queue.list.scrollFrame.insertLine:Hide()
			RematchTooltip:Hide()
			return
		elseif rematch:PetCanLevel(petID) then
			if settings.QueueFullSort and rematch:IsPetLeveling(petID) then
				return -- can't reorder queue when there's a sort order
			elseif self==queue.list.scrollFrame.emptyCapture then -- or settings.QueueFullSort then
				ClearCursor()
				rematch:RemoveFromQueue(petID)
				rematch:AddLevelingPet(petID) -- emptyCapture click/drags always add to end of queue
				queue.list.scrollFrame.insertLine:Hide()
				RematchTooltip:Hide()
			else -- this is a pet being dragged into the queue queue
				local index = queue.list.scrollFrame.insertLine.index
				if index then
					ClearCursor()
					-- first replace the petID in the queue (if it exists) with a non-string value
					for i=1,#levelingQueue do
						if levelingQueue[i]==petID then
							levelingQueue[i] = 0
						end
					end
					-- then insert petID into the queue at the dragged index
					rematch:InsertIntoLevelingQueue(petID,index)
--					tinsert(levelingQueue,index,petID)
					-- and process the queue
					rematch:ProcessQueue(true)
					queue.list.scrollFrame.insertLine:Hide()
					queue.shinePetID = petID
					RematchTooltip:Hide()
				end
			end
			rematch:UpdateLevelingMarkers()
		end
	end
end

function rematch:EmptyCaptureOnClick()
	local cursorPetID = rematch:GetCursorPetID()
	if cursorPetID then -- if pet on the cursor
		if button=="RightButton" then
			RematchTooltip:Hide()
			ClearCursor()
			return
		end
		rematch.QueueListOnReceiveDrag(self)
	end
end

function rematch:LevelingQueueFilterButtonOnClick()
	if rematch:IsMenuOpen("levelingQueueFilter") then
		rematch:HideDialogs()
	else
		if not rematch:CantChangeQueue() then
			rematch:ShowMenu("levelingQueueFilter","TOPLEFT",self,"TOPRIGHT",-6,8)
		end
	end
end

function rematch:SortOrderChanged()
	rematch:ProcessQueue(true)
	rematch:UpdateQueueTitle()
end

function rematch:UpdateQueueTitle()
	local title = queue.title
	local order = settings.QueueSortOrder
	local sorting = (order and settings.QueueFullSort) and true
	title.label:SetShown(not sorting)
	title.sortLabel:SetShown(sorting)
	title.sorted:SetShown(sorting)
	title.clear:SetShown(sorting)
	if sorting then
		title.sorted:SetTexture(rematch.sortIcons[order])
	end
end

function rematch:ClearQueueSort()
	settings.QueueFullSort = nil
	rematch:SortOrderChanged()
end

function rematch:EmptyQueue()
	wipe(settings.LevelingQueue)
	rematch:ClearQueueSort() -- does a ProcessQueue
end

-- adds one of each species listed in the browser (confirm dialog is in rmf)
function rematch:FillQueue(countOnly,fillMore)
	local roster = rematch.roster
	local scratch = rematch.info
	rematch:ProcessQueue(true)
	roster:Update()
	wipe(scratch)
	-- count how many species to add
	local count = 0
	for i=1,roster:GetNumPets() do
		local petID = roster:GetPetByIndex(i)
		local speciesID,level,canBattle,_
		if type(petID)=="string" then -- owned pet
			speciesID, _, level, _, _, _, _, _, _, _, _, _, _, _, canBattle = C_PetJournal.GetPetInfoByPetID(petID)
			if rematch:IsPetLeveling(petID) then
				scratch[speciesID]=1
			elseif rematch:PetCanLevel(petID) and not scratch[speciesID] and (fillMore or not rematch.ownedSpeciesAt25[speciesID]) then
				if not countOnly then
					rematch:InsertIntoLevelingQueue(petID)
				end
				count = count + 1
				scratch[speciesID]=1
			end
		end
	end
	if countOnly then
		return count
	end
	rematch:MaybeSlotNewLevelingPet(levelingQueue[1],levelingQueue[2],levelingQueue[3])
	rematch:ProcessQueue(true)
	rematch:UpdateLevelingMarkers()
	rematch:ShineOnYouCrazy(queue.resultsBar.count,"CENTER")
end

-- does a "criterea" toast to alert that the leveling pet has changed
-- if message is passed, L["Next leveling pet:"] is replaced by the message
function rematch:ToastNextLevelingPet(petID,message)
	if settings.HidePetToast then
		return -- aww :(
	end
	local emptyQueue, customName, realName, icon, _
	if not petID then -- if no petID, then the queue is empty
		emptyQueue = true
		realName = L["All done leveling pets!"]
		icon = "Interface\\Icons\\INV_Pet_Achievement_WinAPetBattle"
	else
		_,customName,_,_,_,_,_,realName,icon = C_PetJournal.GetPetInfoByPetID(petID)
	end
	if icon then
    local frame = CriteriaAlertFrame_GetAlertFrame()
		if frame then
			local frameName = frame:GetName()
			_G[frameName.."Name"]:SetText(customName or realName)
			_G[frameName.."Unlocked"]:SetText(emptyQueue and L["Rematch's leveling queue is empty"] or (message or L["Next leveling pet:"]))
	    _G[frameName.."IconTexture"]:SetTexture(icon)
	    frame.id = nil
	    AlertFrame_AnimateIn(frame)
      AlertFrame_FixAnchors()
			if not frame.rematchHide then
				-- add an OnHide secure hook to change "Unlocked" back to "Achievement Progress"
				frame.rematchHide = true
				frame:HookScript("OnHide",function(self) _G[self:GetName().."Unlocked"]:SetText(ACHIEVEMENT_PROGRESSED) end)
			end
		end
	end
end

-- if in a pet battle displays a dialog saying the queue can't change and returns true
-- to be used as "if rematch:CantChangeQueue() then return end" to leave queue-changing functions
function rematch:CantChangeQueue()
	local reason
	if InCombatLockdown() then
		reason = COMBAT
	elseif C_PetBattles.IsInBattle() then
		reason = L["a pet battle"]
	elseif C_PetBattles.GetPVPMatchmakingInfo() then
		reason = L["pet PVP"]
	else
		return false
	end
	if reason then
		if rematch:IsVisible() then
			ClearCursor()
			queue.list.scrollFrame.insertLine:Hide()
			local dialog = rematch:ShowDialog("CantChangeQueue",140,L["In Pet Battle"],"",true)
			dialog.slot.icon:SetTexture("Interface\\Icons\\INV_Pet_SwapPet")
			dialog.slot:SetPoint("LEFT",12,12)
			dialog.slot:Show()
			dialog.text:SetSize(170,80)
			dialog.text:SetPoint("CENTER",16,12)
			dialog.text:SetText(format(L["You are in %s.\n\nThe leveling slot and queue are locked while you are in %s."],reason,reason))
			dialog.text:Show()
		end
		return true
	end
end

--[[ Leveling Carousel ]]

function rematch:ShowLevelingCarouselDialog()
	local isOpen = rematch:IsDialogOpen("LevelingCarousel")
	rematch:HideDialogs()
	if isOpen then return end

	local dialog = rematch:ShowDialog("LevelingCarousel",114,L["Leveling Pet"],L["Choose a new pet"],rematch.LevelingCarouselAccept)

	local carousel = dialog.levelingCarousel
	carousel:SetPoint("TOP",0,-16)
	carousel:Show()
	rematch:LevelingCarouselReset()
end

function rematch:LevelingCarouselReset()
	local dialog = rematch.dialog
	local carousel = dialog.levelingCarousel
	carousel.xpos = 0
	carousel.offset = 1
	carousel.carousel.child.pets[1]:SetPoint("CENTER")
	rematch:LevelingCarouselResizePets()
	rematch:LevelingCarouselUpdate()
	if settings.QueueFullSort then
		dialog:SetHeight(136)
		dialog.warning:SetPoint("TOP",carousel,"BOTTOM",0,-3)
		dialog.warning.text:SetText(L["Choosing a pet will turn off Active Sort"])
		dialog.warning:Show()
	else
		dialog.warning:Hide()
		dialog:SetHeight(114)
	end
end

function rematch:LevelingCarouselResizePets()
	local frame = rematch.dialog.levelingCarousel
	local pets = frame.carousel.child.pets
  local x1 = frame:GetCenter()
  for i=1,7 do
    local x2 = pets[i]:GetCenter() or x1
    local size = 42 * (1-(math.abs(x2-x1)/frame:GetWidth()))
    pets[i]:SetSize(size,size)
  end
end

function rematch:LevelingCarouselSpin(direction,speed)
	local frame = rematch.dialog.levelingCarousel
	if frame:GetScript("OnUpdate") then return end -- don't spin if already moving
	local pets = frame.carousel.child.pets
	frame.direction = direction<0 and -1 or 1
	frame.xpos = 0
	for i=1,7 do
		pets[i]:EnableMouse(false) -- turn off mouseover while pets turning
	end
	frame.speed = speed and speed or 0.15
	frame:SetScript("OnUpdate",rematch.LevelingCarouselSpinOnUpdate)
	frame.offset = frame.offset + frame.direction
	if frame.offset<1 then
		frame.offset = #levelingQueue
	elseif frame.offset>#levelingQueue then
		frame.offset = 1
	end
end

function rematch:LevelingCarouselSpinOnUpdate(elapsed)
	self.xpos = self.xpos - (elapsed/self.speed)*42*self.direction -- 42 is width of square when centered
	if math.abs(self.xpos)>42 then
		self:SetScript("OnUpdate",nil) -- stop moving
		for i=1,7 do
			self.carousel.child.pets[i]:EnableMouse(true)
		end
		self.xpos = 0
		rematch:LevelingCarouselUpdate()
	end
	self.carousel.child.pets[1]:SetPoint("CENTER",self.xpos,0)
	rematch:LevelingCarouselResizePets()
end

-- fills the pet frames with pets and updates the left/right buttons
function rematch:LevelingCarouselUpdate()
	local frame = rematch.dialog.levelingCarousel
	local pets = frame.carousel.child.pets

	local function fill(button,index)
		local index = (index+frame.offset-1)%#levelingQueue
		index = index==0 and #levelingQueue or index
		local petID = levelingQueue[index]
		local icon,_,level = rematch:GetPetIDIcon(petID)
		if icon then
			button.index = index
			button.petID = petID
			button.icon:SetTexture(icon)
			-- color border for rarity
			if not settings.HideRarityBorders then
				local rarity = select(5,C_PetJournal.GetPetStats(petID))
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
				button.border:SetVertexColor(r,g,b,1)
			end
			button.border:SetShown(not settings.HideRarityBorders)
			if button.level then
				button.level:SetText(level)
			end
			button:Show()
		else
			button:Hide()
		end
	end

	for i=1,4 do
		fill(pets[i],i)
	end
	for i=5,7 do
		fill(pets[i],5-i)
	end
end

-- when the green check is clicked
function rematch:LevelingCarouselAccept()
	settings.QueueFullSort = nil
	rematch:StartLevelingPet(levelingQueue[rematch.dialog.levelingCarousel.offset])
end

-- when a pet is clicked, instead of locking the card, immediately choose it
function rematch:LevelingCarouselPetOnClick()
	rematch:HideDialogs()
	settings.QueueFullSort = nil
	rematch:StartLevelingPet(self.petID)
end

-- use this instead of tinsert(levelingQueue,petID)
function rematch:InsertIntoLevelingQueue(petID,index)
	if not petID or type(petID)~="string" then
		return
	end
	if index then
		tinsert(levelingQueue,index,petID)
	else
		tinsert(levelingQueue,petID)
	end
	if not tContains(settings.LevelingTimeline,petID) then
		tinsert(settings.LevelingTimeline,petID)
	end
	rematch:AddToSanctuary(petID)
end
