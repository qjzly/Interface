
--[[ functions used by more than one module ]]

local _,L = ...
local rematch = Rematch
local settings

rematch.info = {} -- reusable table to reduce garbage creation
rematch.abilityList = {} -- reusable table for C_PetJournal.GetPetAbilityList
rematch.levelList = {} -- reusable table for C_PetJournal.GetPetAbilityList
rematch.emptyPetID = "0x0000000000000000" -- petID to load for an empty slot

BINDING_HEADER_REMATCH = "Rematch"
BINDING_NAME_REMATCH_WINDOW = L["Toggle Window"]
BINDING_NAME_REMATCH_AUTOLOAD = L["Toggle Auto Load"]
BINDING_NAME_REMATCH_PETS = L["Toggle Pets"]
BINDING_NAME_REMATCH_TEAMS = L["Toggle Teams"]
BINDING_NAME_REMATCH_TOGGLENOTES = L["Toggle Notes"]

-- 1=Humanoid 2=Dragonkin 3=Flying 4=Undead 5=Critter 6=Magic 7=Elemental 8=Beast 9=Aquatic 10=Mechanical

-- this table describes how an attack will be received by the indexed pet type (incoming modifier)
-- {[petType]={increasedVs,decreasedVs},[petType]={increasedVs,decreasedVs},etc}
-- ie dragonkin pets {1,3} take increased damage from humanoid attacks (1) and less damage from flying attacks (3)
rematch.hintsDefense = {{4,5},{1,3},{6,8},{5,2},{8,7},{2,9},{9,10},{10,1},{3,4},{7,6}}

-- this table describes how an attack of the indexed pet type will be applied (outgoing modifier)
-- {[attackType]={increasedVs,decreasedVs},[attackType]={increasedVs,decreasedVs},etc}
-- ie dragonkin attacks {6,4) deal increased damage to magic pets (6) and less damage to undead pets (4)
rematch.hintsOffense = {{2,8},{6,4},{9,2},{1,9},{4,1},{3,10},{10,5},{5,3},{7,6},{8,7}}

function rematch:InitCommon()
	RematchSettings = RematchSettings or {}
	settings = RematchSettings
	settings.LevelingQueue = settings.LevelingQueue or {}
	RematchSaved = RematchSaved or {}

	rematch.breedSource = rematch:FindBreedSource() -- go find a source for breed info

	hooksecurefunc(C_PetJournal,"PickupPet",rematch.events.CURSOR_UPDATE)
	rematch:RegisterEvent("PET_JOURNAL_LIST_UPDATE")

	rematch:RegisterEvent("PLAYER_TARGET_CHANGED")
	rematch:RegisterEvent("UPDATE_MOUSEOVER_UNIT")

	rematch:RegisterEvent("PLAYER_REGEN_ENABLED")
	rematch:RegisterEvent("PLAYER_REGEN_DISABLED")
	rematch:RegisterEvent("PET_BATTLE_OPENING_START")
	rematch:RegisterEvent("PET_BATTLE_CLOSE")
	rematch:RegisterEvent("PET_BATTLE_FINAL_ROUND")
	rematch:RegisterEvent("PLAYER_LOGOUT")

	rematch:RegisterEvent("PET_BATTLE_QUEUE_STATUS")
	rematch.events:PET_BATTLE_QUEUE_STATUS()

	settings.WoDReady = nil -- everyone is on WoD client

	-- 3.3.1 there must be a sort order if active sort is enabled
	if settings.QueueFullSort then
		settings.QueueSortOrder = settings.QueueSortOrder or 1
	end
	-- 3.3.1 LevelingTimeline is the pets in the queue in the order they were added
	if not settings.LevelingTimeline then
		settings.LevelingTimeline = {}
		for _,petID in ipairs(settings.LevelingQueue) do
			tinsert(settings.LevelingTimeline,petID) -- start with 3.3.0 (or earlier) order
		end
	end
	-- 3.3.1 ManuallySlotted is petIDs user manually slots (really) with a silver "leave alone" border
	settings.ManuallySlotted = settings.ManuallySlotted or {}

	-- 3.4.0 convert teams to new format
	rematch:ConvertToNewTeamFormat()

	-- 3.4.2 disable the awful 'Discard loaded team on changes' option
	settings.AutoAlways = nil
	settings.SanctuaryPets = settings.SanctuaryPets or {}
end

--[[ Events ]]

rematch.events = {}
function rematch:OnEvent(event,...)
	if rematch.events[event] then
		rematch.events[event](...)
	end
end

function rematch.events.PLAYER_LOGIN()
	if not rematch.SetSideline then
		-- version 3.4.0 updated while logged in can be catastrophic, shut down the addon in that case
		local text = L["You updated Rematch while logged in.\n\nWhich is usually fine!\n\nHowever, this update has changes the game won't pick up while logged in.\n\nTo prevent corruption of your data, Rematch is disabled until you've exited the game and restarted."]
		StaticPopupDialogs["REMATCHUPDATE"] = { button1 = OKAY, timeout = 0, showAlert=1, text=text }
		local function warn() StaticPopup_Show("REMATCHUPDATE") end
		for _,func in pairs({"Toggle","ToggleAutoLoad","ToggleTab","ToggleNotes"}) do rematch[func]=warn end
		warn() -- display a popup warning the addon is disabled until they exit
		return
	end
	-- start initializing everything
	rematch:InitCommon()
	rematch:InitMain()
	rematch:InitCurrent()
	rematch:InitOptions()
	rematch:InitBrowser()
	rematch:InitLeveling()
	rematch:InitMenu()
	rematch:InitRMF()
	rematch:InitDialog()
	rematch:InitTeams()
	rematch:InitSaveAs()
	rematch:InitPetLoading()
	rematch:InitNotes()
	rematch:InitPreferences()
	if settings.ResetFilters or not pcall(rematch.roster.LoadFilters,rematch,settings.loginFilters) then
		rematch.roster:ClearAllFilters()
	end
end

function rematch.events.PLAYER_LOGOUT()
	settings.loginFilters = {} -- save filters to loginFilters for next login
	rematch.roster:SaveFilters(settings.loginFilters)
	rematch:SanctuarySave() -- save petIDs (and stats) of owned pets in teams and queue
	settings.ShownOnLogout = settings.StayOnLogout and rematch:IsVisible()
end

function rematch.events.PET_JOURNAL_LIST_UPDATE()
	local _,owned = C_PetJournal.GetNumPets()
	if owned and owned>0 and owned~=rematch.lastOwned then -- if number of owned pets changed
		rematch:UpdateOwnedPets()
		wipe(rematch.sanctuaryLookups) -- pets changed, any sanctuary lookups should start fresh
		rematch:CheckForChangedPetIDs()
		rematch:ProcessQueue() -- process the queue
		if not rematch.lastOwned and settings.ShownOnLogout and not InCombatLockdown() then
			rematch:Toggle() -- show the window if it was shown on last logout
		end
		rematch.lastOwned = owned
	end
	rematch:StartTimer("UpdateWindow",0,rematch.UpdateWindow)
end

function rematch.events.PLAYER_REGEN_DISABLED()
	if rematch:IsVisible() then
		rematch.resummonWindow = true
		rematch:Toggle()
	end
	rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
	rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
end

-- post-battle processing also calls this to handle stuff that was suspended during battle
function rematch.events.PLAYER_REGEN_ENABLED()
	if rematch.resummonWindow  then
		rematch:Show()
		rematch.resummonWindow = nil
	end
	if C_PetBattles.IsInBattle() or C_PetBattles.GetPVPMatchmakingInfo() then
		return -- in pet battle or pvp, come back when those are done
	end
	-- at this point the player is neither in combat, battle or pvp
	if rematch.queueNeedsProcessed then
		rematch:ProcessQueue()
		rematch.queueNeedsProcessed = nil
	end
	if rematch.teamNeedsLoaded then
		rematch:LoadTeam(rematch.teamNeedsLoaded)
		rematch.teamNeedsLoaded = nil
	end
	rematch:RegisterEvent("UPDATE_MOUSEOVER_UNIT")
	rematch:RegisterEvent("PLAYER_TARGET_CHANGED")
	rematch.events.PLAYER_TARGET_CHANGED()
	rematch.events.UPDATE_MOUSEOVER_UNIT()
end

function rematch.events.PET_BATTLE_OPENING_START()
	rematch:HideDialogs()
	-- if 'Show notes in battle' checked, and a team is loaded that has notes...
	if settings.ShowNotesInBattle and settings.loadedTeam and RematchSaved[settings.loadedTeam] and RematchSaved[settings.loadedTeam].notes then
		-- and if 'Only once per team' not checked, or team is different than last notes displayed...
		if not settings.ShowNotesOnce or rematch.lastNotedTeam~=settings.loadedTeam then
			rematch:ShowNotesCard(settings.loadedTeam,true) -- then show notes!
			rematch.lastNotedTeam = settings.loadedTeam
		end
	end
	if not settings.StayForBattle then
		rematch.resummonWindow = rematch:IsVisible()
		rematch:Hide()
	end
	rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
	rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	rematch.queueNeedsProcessed = true
end

-- PET_BATTLE_CLOSE fires twice after a pet battle ends
-- the first time C_PetBattles.IsInBattle() is true, the second time false
-- however if a pet needs to be swapped the server sends a message that a battle is in progress
-- so post-battle processing is delayed 0.5 seconds after the second PET_BATTLE_CLOSE
function rematch.events.PET_BATTLE_CLOSE()
	if not C_PetBattles.IsInBattle() then
		C_Timer.After(0.5,rematch.PostBattleProcessing)
	end
end

function rematch:PostBattleProcessing()
	if rematch:IsDialogOpen("NewNPCSavePrompt") then
		return -- don't do post battle processing while prompting to save a new team
	end
	if settings.ShowNotesInBattle then
		RematchNotesCard:Hide()
	end
	if settings.ShowAfterBattle then
		rematch:Show()
	end
	rematch.events.PLAYER_REGEN_ENABLED() -- rest of end-of-fight handling identical to leaving combat
end

function rematch.events.PET_BATTLE_QUEUE_STATUS()
	if rematch:UpdatePVPStatus() then
		rematch:UnregisterEvent("PLAYER_TARGET_CHANGED")
		rematch:UnregisterEvent("UPDATE_MOUSEOVER_UNIT")
	else
		C_Timer.After(0.5,rematch.events.PLAYER_REGEN_ENABLED)
	end
end

function rematch:UpdatePVPStatus()
	local button = rematch.sidebar.findbattle
	local oldIcon = button.icon:GetTexture()
	local queued = C_PetBattles.GetPVPMatchmakingInfo()
	button.tooltipTitle = queued and LEAVE_QUEUE or FIND_BATTLE
	button.icon:SetTexture(queued and "Interface\\Icons\\PetBattle_Attack-Down" or "Interface\\Icons\\PetBattle_Attack")
	if oldIcon~="Interface\\Icons\\INV_Misc_QuestionMark" and oldIcon~=button.icon:GetTexture() then
		rematch:ShineOnYouCrazy(button,"CENTER")
	end
	return queued
end

--[[ Pet template script handlers ]]

function rematch:PetOnEnter()
	rematch:ShowFloatingPetCard(self.petID,self,self.menu=="browserPet")
end

function rematch:PetOnLeave()
	rematch:HideFloatingPetCard()
end

function rematch:PetOnClick(button)
	local cursorPetID = rematch:GetCursorPetID()
	if cursorPetID then -- if pet on the cursor
		if button=="RightButton" then
			RematchTooltip:Hide()
			ClearCursor()
			return
		end
		local receive = self:GetScript("OnReceiveDrag")
		if receive then -- any slot that expects to receive pets, run its function and leave
			return receive(self)
		end
	end
	local petID = self.petID
	-- send to chat if Shift+Clicked (or whatever CHATLINK modifier they use)
	if IsModifiedClick("CHATLINK") and type(petID)=="string" then
		return ChatEdit_InsertLink(C_PetJournal.GetBattlePetLink(petID))
	end
	if button=="RightButton" then
		if self.menu then
			rematch:SetMenuSubject(petID,self:GetID())
			rematch:ShowMenu(self.menu,"cursor")
		end
	elseif petID then
		local cardID = RematchFloatingPetCard.petID
		rematch:LockFloatingPetCard()
		if petID ~= cardID then
			rematch:ShowFloatingPetCard(petID,self)
			rematch:LockFloatingPetCard() -- lock it again
		end
	end
end

function rematch:PetOnDoubleClick()
	local petID = self.petID
	if type(petID)=="string" then
		C_PetJournal.SummonPetByGUID(petID)
	end
	rematch:HideFloatingPetCard(true)
end

function rematch:PetOnDragStart()
	if type(self.petID)=="string" then
		C_PetJournal.PickupPet(self.petID)
	end
end

function rematch:AbilityOnEnter()
	local petID = self:GetParent().petID
	if petID and self.abilityID then
		rematch.ShowAbilityCard(self,petID,self.abilityID)
	end
end

function rematch:AbilityOnClick()
	if IsModifiedClick("CHATLINK") and self.abilityID and self:GetParent().petID then
		rematch:ChatLinkAbility(self:GetParent().petID,self.abilityID)
	end
end

function rematch:AbilityOnDoubleClick()
	if self.abilityID then
		rematch:HideDialogs()
		RematchSettings.DrawerMode="PETS"
		rematch.roster:SetSimilarFilter(nil,self.abilityID)
	end
end

--[[ ListTemplate script handlers ]]

function rematch:ListScrollToTop(frame)
	(frame or self:GetParent()).scrollBar:SetValue(0)
	PlaySound("UChatScrollButton")
end

function rematch:ListScrollToBottom(frame)
	local scrollFrame = frame or self:GetParent()
	scrollFrame.scrollBar:SetValue(scrollFrame.range)
	PlaySound("UChatScrollButton")
end

function rematch:ListScrollToIndex(frame,index)
	if index then
		local scrollFrame = frame or self:GetParent()
		if scrollFrame.scrollBar:IsEnabled() then
			local buttons = scrollFrame.buttons
			local height = math.max(0,floor(scrollFrame.buttonHeight*(index-((scrollFrame:GetHeight()/scrollFrame.buttonHeight))/2)))
			HybridScrollFrame_SetOffset(scrollFrame,height)
			scrollFrame.scrollBar:SetValue(height)
		else
			rematch:ListScrollToTop(frame)
		end
	end
end

-- used in scrollBar's OnValueChanged hooked in during the OnLoad
-- when scrolling with the mousewheel, force an OnEnter of whatever is under mouse
function rematch:ReOnEnter()
	local focus = GetMouseFocus()
	local scrollFrame = self:GetParent()
	for i=1,#scrollFrame.buttons do
		if scrollFrame.buttons[i]==focus then
			local script = focus:GetScript("OnEnter")
			if script then
				script(focus) -- if there's an OnEnter script, use it for focus
			end
			return
		end
	end
end

function rematch:ListOnLoad()
	-- tweak scrollBar appearance
	local scrollBar = self.scrollFrame.scrollBar
	scrollBar.doNotHide = true
	scrollBar.trackBG:SetPoint("TOPLEFT",-2,25)
	scrollBar.trackBG:SetPoint("BOTTOMRIGHT",2,-25)
	scrollBar.trackBG:SetTexture("Interface\\ChatFrame\\ChatFrameBackground")
	scrollBar.trackBG:SetGradientAlpha("HORIZONTAL",.125,.125,.125,1,.05,.05,.05,1)
	scrollBar:HookScript("OnValueChanged",rematch.ReOnEnter)
end

function rematch:ListOnSizeChanged()
	local scrollFrame = self.scrollFrame
	-- stepSize moved to the update functions
	rematch:ListResizeButtons(scrollFrame) -- do an immediate width adjustment on buttons
	rematch:StartTimer(scrollFrame:GetName(),0.1,scrollFrame.update)
end

function rematch:ListResizeButtons(scrollFrame)
	local width = scrollFrame:GetWidth()
	if width<64 then return end
	for i=1,#scrollFrame.buttons do
		scrollFrame.buttons[i]:SetWidth(width-17)
	end
	-- if resizing browser, then also reposition typebar buttons
	if scrollFrame==rematch.drawer.browser.list.scrollFrame then
		rematch:TypeBarResize() -- in browser.lua
	end
	-- if resizing options, also extend hitrectinset of checkbuttons and name fontstring width
	if scrollFrame==rematch.drawer.options.list.scrollFrame then
		for i=1,#scrollFrame.buttons do
			scrollFrame.buttons[i].check:SetHitRectInsets(-24,-width+50,0,0)
			scrollFrame.buttons[i].name:SetWidth(width-49) -- -17-32 (scrollbar+checkbutton+spacing)
		end
	end
end

--[[ Other template script handlers ]]

-- when a button is resized or released from being pushed, reset its icon to normal
function rematch:ResizeSlotIcon()
	local inset = ceil(self:GetWidth()/12)
	self.icon:SetPoint("TOPLEFT",inset,-inset)
	self.icon:SetPoint("BOTTOMRIGHT",-inset-1,inset+1)
	self.icon:SetVertexColor(1,1,1)
end

function rematch:PushToolbarButton()
	if self:IsEnabled() then
		self.icon:SetSize(18,18)
		local vertex = self.vertex and self.vertex*0.65 or 0.65
		self.icon:SetVertexColor(vertex,vertex,vertex)
	end
end

function rematch:ReleaseToolbarButton()
	self.icon:SetSize(20,20)
	local vertex = self.vertex or 1
	self.icon:SetVertexColor(vertex,vertex,vertex)
end

function rematch:ToolbarButtonOnEnter()
	if self.tooltipTitle then
		local title = _G[self.tooltipTitle] or L[self.tooltipTitle]
		local body = _G[self.tooltipBody] or L[self.tooltipBody]
		rematch:ShowTooltip(title,self.tooltipBody)
		RematchTooltip:ClearAllPoints()
		RematchTooltip:SetPoint("BOTTOM",self,"TOP",0,-2)
	end
end

function rematch:SetToolbarButtonEnabled(button,enable)
	button:SetEnabled(enable)
	button.icon:SetDesaturated(not enable)
end

function rematch:ScrollFrameToTop(scrollFrame)
	scrollFrame.scrollBar:SetValue(0)
end

function rematch:ScrollFrameToBottom(scrollFrame)
	scrollFrame.scrollBar:SetValue(scrollFrame.range)
end

--[[ Pet frames ]]

function rematch:WipePetFrames(pets)
	for i=1,3 do
		pets[i].petID = nil
		pets[i].icon:Hide()
		pets[i].dead:Hide()
		pets[i].leveling:Hide()
		pets[i].leveling:SetDesaturated(false)
		pets[i].leveling:SetVertexColor(1,1,1)
		pets[i].level:Hide()
		pets[i].levelBG:Hide()
		pets[i].border:Hide()
		for j=1,3 do
			pets[i].abilities[j].abilityID = nil
			pets[i].abilities[j].icon:Hide()
			if pets[i].abilities[j].level then
				pets[i].abilities[j].level:Hide()
			end
		end
	end
	for i=4,9 do
		pets[i] = nil
	end
	pets.teamName = nil
end

--[[ Timer Management ]]

rematch.timerFuncs = {} -- indexed by arbitrary name, the func to run when timer runs out
rematch.timerTimes = {} -- indexed by arbitrary name, the duration to run the timer
rematch.timerFrame = CreateFrame("Frame") -- timer independent of main frame visibility
rematch.timerFrame:Hide()
rematch.timersRunning = {} -- indexed numerically, timers that are running

function rematch:StartTimer(name,duration,func)
	local timers = rematch.timersRunning
	rematch.timerFuncs[name] = func
	rematch.timerTimes[name] = duration
	if not tContains(timers,name) then
		tinsert(timers,name)
	end
	rematch.timerFrame:Show()
end

function rematch:StopTimer(name)
	local timers = rematch.timersRunning
	for i=#timers,1,-1 do
		if timers[i]==name then
			tremove(timers,i)
			return
		end
	end
end

rematch.timerFrame:SetScript("OnUpdate",function(self,elapsed)
	local tick
	local times = rematch.timerTimes
	local timers = rematch.timersRunning

	for i=#timers,1,-1 do
		local name = timers[i]
		times[name] = times[name] - elapsed
		if times[name] < 0 then
			tremove(timers,i)
			if rematch.timerFuncs[name] then
				rematch.timerFuncs[name]()
			else
				rematch:print(name,"doesn't have a function")
			end
		end
		tick = true
	end

	if not tick then
		self:Hide()
	end
end)

--[[ Tooltips ]]

-- anchors frame to relativeTo depending on where relativeTo is on the screen, based on
-- the center of the reference frame (rematch frame itself if no reference given)
-- specifically, frame will be anchored to the corner furthest from the edge of the screen
function rematch:SmartAnchor(frame,relativeTo,reference)
	reference = reference or rematch
	local referenceScale = reference:GetEffectiveScale()
	local UIParentScale = UIParent:GetEffectiveScale()
	local isLeft = (reference:GetRight()*referenceScale+reference:GetLeft()*referenceScale)/2 < (UIParent:GetWidth()*UIParentScale)/2
	local isBottom = (reference:GetTop()*referenceScale+reference:GetBottom()*referenceScale)/2 < (UIParent:GetHeight()*UIParentScale)/2
	if isLeft then
		anchorPoint = isBottom and "BOTTOMLEFT" or "TOPLEFT"
		relativePoint = isBottom and "TOPRIGHT" or "BOTTOMRIGHT"
	else
		anchorPoint = isBottom and "BOTTOMRIGHT" or "TOPRIGHT"
		relativePoint = isBottom and "TOPLEFT" or "BOTTOMLEFT"
	end
	frame:ClearAllPoints()
	frame:SetPoint(anchorPoint,relativeTo,relativePoint)
end

-- shows tooltip with title[,body] and resizes around text
-- if priority is set, show through normal HideTooltip option and float by cursor with an OnUpdate
-- if option is set, make the tooltip wider and anchor it to the parent of the mouseover
-- if no title is given, it will fetch self's .tooltipTitle and .tooltipBody
function rematch:ShowTooltip(title,body,priority,option,fromMenu)

	if MouseIsOver(rematch.dialog) and rematch.dialog.timeShown==GetTime() then
		return -- if dialog appeared this frame, don't show a tooltip, to prevent it from obscuring what just appeared
	end

	if not title then -- get tooltip info from self if not passed
		title = self.tooltipTitle
		body = self.tooltipBody
		priority = self.tooltipPriority
	end

	if not title then
		return -- don't display a tooltip if nothing to display
	end

	if not fromMenu and settings.HideTooltips then
		if option and settings.HideOptionTooltips then
			return
		elseif not option and not priority then
			return
		end
	end

	local tooltip = RematchTooltip
	tooltip.title:SetText(title)
	tooltip.body:SetText(body)
	local titleWidth=tooltip.title:GetStringWidth()
	local tooltipWidth

	if option then
		width = 200
	elseif not body then
		width = titleWidth -- for tooltips with just a title, make width the title width
	else
		width = max(titleWidth,164) -- otherwise make width the max of title or 164
		-- but if 164 is greater than both title and body width, shrink to max of title and body
		local bodyWidth=tooltip.body:GetStringWidth()
		if width>titleWidth and width>bodyWidth then
			width = max(titleWidth,bodyWidth)
		end
	end
	tooltip.title:SetSize(width,0)
	tooltip.body:SetSize(width,0)

	local titleHeight=tooltip.title:GetStringHeight()
	local bodyHeight=tooltip.body:GetStringHeight()
	tooltip:SetWidth( width+16 )
	tooltip:SetHeight( titleHeight+bodyHeight+16 + (body and 4 or 0) ) -- + ((body and body:len()>0 and 4) or 0) )
	tooltip:Show()
	tooltip:SetScript("OnUpdate",nil)
	if option then -- option tooltips get anchored to parent of mouseover
		rematch:SmartAnchor(tooltip,GetMouseFocus():GetParent())
	elseif priority then -- priority tooltips get an OnUpdated anchor by the cursor
		tooltip:SetScript("OnUpdate",rematch.TooltipOnUpdate)
	else -- regular tooltips are SmartAnchored
		rematch:SmartAnchor(tooltip,GetMouseFocus())
	end
end

function rematch:HideTooltip()
	RematchTooltip:Hide()
	RematchTableTooltip:Hide()
end

function rematch:TooltipOnUpdate(elapsed)
	local x,y = GetCursorPosition()
	local scale = UIParent:GetEffectiveScale()
	x = x/scale
	y = y/scale
	self:ClearAllPoints()
	if x>UIParent:GetWidth()/2 then -- right half of screen
		self:SetPoint("BOTTOMRIGHT",UIParent,"BOTTOMLEFT",x-2,y+2)
	else -- left half of screen
		self:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",x+2,y+2)
	end
end

--[[ Keep Summoned ]]

-- primarilyy for KeepSummoned, call this before pets are about to change
function rematch:SummonedPetMayChange()
	if settings.KeepSummoned then
		rematch.preLoadCompanion = rematch.preLoadCompanion or C_PetJournal.GetSummonedPetGUID()
		rematch:RegisterEvent("UNIT_PET")
		rematch:StartTimer("RestoreTimeout",1,rematch.RestoreTimeout)
	end
end

function rematch.events.UNIT_PET()
	rematch:StopTimer("RestoreTimeout")
	rematch:UnregisterEvent("UNIT_PET")
	rematch:StartTimer("RestoreCompanion",1.6,rematch.RestoreCompanion) -- wait a GCD before restoring
end

function rematch:RestoreCompanion()
	if not InCombatLockdown() then -- can't SummonPetByGUID in combat :(
		local nowSummoned = C_PetJournal.GetSummonedPetGUID()
		if not rematch.preLoadCompanion and nowSummoned then
			C_PetJournal.SummonPetByGUID(nowSummoned) -- something summoned, had nothing before
		elseif nowSummoned ~= rematch.preLoadCompanion then
			C_PetJournal.SummonPetByGUID(rematch.preLoadCompanion) -- something summoned different than before
		end
		rematch.preLoadCompanion = nil
	end
end

-- if no UNIT_PET fired, unregister it. apparently no pet was loaded
function rematch:RestoreTimeout()
	rematch.preLoadCompanion = nil
	rematch:UnregisterEvent("UNIT_PET")
end

--[[ Miscellaneous ]]

function rematch:GetCursorPetID()
	local cursorType,petID = GetCursorInfo()
	if cursorType=="battlepet" then
		return petID
	end
end

-- use this instead of a direct C_PetJournal.SetPetLoadOutInfo
function rematch:LoadPetSlot(slot,petID)
	if slot>0 and slot<4 and type(petID)=="string" then -- hilarious crash bug if we attempt to load slots other than 1-3
		rematch:SummonedPetMayChange()
		C_PetJournal.SetPetLoadOutInfo(slot,petID)
		if PetJournal then
			PetJournal_UpdatePetLoadOut() -- update petjournal if it's open
		end
	end
end

-- this makes the current pets glow when a pet is picked up onto the cursor
function rematch.events.CURSOR_UPDATE()
  local hasPet,petID = GetCursorInfo()
	hasPet = hasPet=="battlepet"
	for i=1,3 do
		rematch.current.pets[i].glow:SetShown(hasPet)
	end
	rematch.drawer.queue.levelingSlot.glow:SetShown(hasPet and rematch:PetCanLevel(petID))
	if hasPet then
		rematch:HideDialogs()
		rematch:RegisterEvent("CURSOR_UPDATE") -- this is the only place this event is registered
	else
		rematch:UnregisterEvent("CURSOR_UPDATE") -- cursor clear, stop watching cursor changes
	end
	if rematch.drawer.queue:IsVisible() then
		rematch:UpdateQueueList()
	end
end

-- for general purpose use, creates a shine cooldown effect on a frame
function rematch:ShineOnYouCrazy(frame,corner,xoff,yoff)
	if not rematch.shine then
		rematch.shine = CreateFrame("Frame")
		rematch.shine:SetSize(32,32)
		rematch.shine.cooldown = CreateFrame("Cooldown",nil,rematch.shine,"CooldownFrameTemplate")
		rematch.shine.cooldown:SetDrawEdge(false)
		rematch.shine.cooldown:SetDrawSwipe(false)
	end
	local shine = rematch.shine
	shine:SetParent(frame:GetObjectType()=="Frame" and frame or frame:GetParent())
	shine:SetPoint("CENTER",frame,corner,xoff,yoff)
	shine.cooldown:SetCooldownDuration(0.01)
end

-- toggle tooltip
function rematch:ToggleTooltip()
	GameTooltip:SetOwner(self, self==RematchJournalButton and "ANCHOR_RIGHT" or "ANCHOR_LEFT")
	GameTooltip:SetText("Rematch",1,1,1)
	GameTooltip:AddLine(L["Toggles the Rematch window to manage battle pets and teams."],nil,nil,nil,true)
	GameTooltip:Show()
end
function rematch:ToggleTooltipHide()
	GameTooltip:Hide()
end

-- returns the icon of a petID, whether it's missing, and its level
-- if backupSpeciesID is passed and the pet is missing, the icon of the species returned
function rematch:GetPetIDIcon(petID,backupSpeciesID)
	local speciesID,level,icon
	if petID==0 then
		return rematch.levelingIcon
	elseif not petID or petID==rematch.emptyPetID then
		return nil
	elseif type(petID)=="string" then
		local speciesID,_,level,_,_,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(petID)
		if speciesID then
			return icon,false,level
		elseif backupSpeciesID then
			return (select(2,C_PetJournal.GetPetInfoBySpeciesID(backupSpeciesID))),true
		end
	else
		return (select(2,C_PetJournal.GetPetInfoBySpeciesID(petID))),true
	end
end

function rematch:ChatLinkAbility(petID,abilityID)
	local maxHealth,power,speed,_ = 100,0,0
	if type(petID)=="string" and petID~=rematch.emptyPetID then
		_,maxHealth,power,speed = C_PetJournal.GetPetStats(petID)
	end
	ChatEdit_InsertLink(GetBattlePetAbilityHyperlink(abilityID,maxHealth,power,speed))
end

--[[ Search Box ]]

function rematch:SearchBoxOnEditFocusGained()
	self.searchIcon:SetVertexColor(1,1,1)
	self.clearButton:Show()
	self.Instructions:Hide()
end

function rematch:SearchBoxOnEditFocusLost()
	self.Instructions:SetShown(self:GetText() == "")
	if ( self:GetText() == "" ) then
		self.searchIcon:SetVertexColor(0.6, 0.6, 0.6);
		self.clearButton:Hide();
	end
end

function rematch:ClearSearchBox(searchBox)
	searchBox.clearButton:Click()
end

function rematch:SearchBoxOnLoad()
	self.clearButton:SetScript("OnClick",function(self)
		PlaySound("igMainMenuOptionCheckBoxOn")
		local editBox = self:GetParent()
		editBox:SetText("")
		editBox:ClearFocus()
		editBox:GetScript("OnEditFocusLost")(editBox)
	end)
end

local function literal(c)
	return "%"..c
end

local function caseinsensitive(c)
	return format("[%s%s]",c:lower(),c:upper())
end

-- returns text in a literal (magic characters escaped) and case-insensitive format
function rematch:DesensitizedText(text)
	if type(text)=="string" then
		return text:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]",literal):gsub("%a",caseinsensitive)
	end
end

-- prints the file:line that called the function
function rematch:debugstack(name)
	rematch:print(name,debugstack():match(".-%.lua:%d+.-%.lua:%d+.-\\.-\\.-\\(.-%.lua:%d+)"),GetTime())
end

function rematch:print(...)
	print("\124cffffd200Rematch:\124r",...)
end

-- returns the breed of the petID
function rematch:GetBreed(petID)
	local source = rematch.breedSource
	if source=="BattlePetBreedID" then
		return GetBreedID_Journal(petID) or ""
	elseif source=="PetTracker_Breeds" then
		return PetTracker:GetBreedIcon((PetTracker.Journal:GetBreed(petID)),.95)
	elseif source=="LibPetBreedInfo-1.0" then
		return rematch.breedLib:GetBreedName(rematch.breedLib:GetBreedByPetID(petID)) or ""
	end
	return ""
end

-- returns the addon that will provide breed data
function rematch:FindBreedSource()
	local addon
	for _,name in pairs({"BattlePetBreedID","PetTracker_Breeds","LibPetBreedInfo-1.0"}) do
		if not addon and IsAddOnLoaded(name) then
			addon = name
		end
	end
	if not addon then -- one of the sources is not loaded, try loading LibPetBreedInfo separately
		LoadAddOn("LibPetBreedInfo-1.0")
		if LibStub then
			for lib in LibStub:IterateLibraries() do
				if lib=="LibPetBreedInfo-1.0" then
					rematch.breedLib = LibStub("LibPetBreedInfo-1.0")
					addon = lib
					break
				end
			end
		end
	end
	return addon
end

-- this is called after a pet is dragged to a loadout slot, either in rematch
-- or the default journal
function rematch:HandleReceivingLevelingPet(petID)
	-- if petID not passed, grab it from the journal slot receiving the pet
	if not petID then
		local slot = self:GetParent():GetID()
		if slot and slot>0 and slot<4 then
			petID = C_PetJournal.GetPetLoadOutInfo(self:GetParent():GetID())
		end
	end
	if petID and petID~=rematch:GetCurrentLevelingPet() then
		settings.ManuallySlotted[petID] = true
	end
	rematch:StartTimer("ProcessQueue",0.5,rematch.ProcessQueue)
end

-- CheckForChangedPetIDs() runs on login after pets are loaded and after pets learned.
-- Occasionally, the server will reassign whole new petIDs to a user.
-- ValidatePetID uses the sanctuary system in finder.lua to get any changed petIDs.
function rematch:CheckForChangedPetIDs()
	-- validate pets in the queue
	for index,petID in ipairs(settings.LevelingQueue) do
		local valid,newPetID = rematch:ValidatePetID(petID)
		if not valid and newPetID then
			settings.LevelingQueue[index] = newPetID
			-- also replace petID in ManuallySlotted if petID changed (and it's there)
			if settings.ManuallySlotted[petID] then
				settings.ManuallySlotted[newPetID] = true
				settings.ManuallySlotted[petID] = nil
			end
		end
	end
	-- validate pets within teams
	for teamName,team in pairs(RematchSaved) do
		for i=1,3 do
			local valid,newPetID = rematch:ValidatePetID(team[i][1])
			if not valid and newPetID then
				team[i][1] = newPetID
			end
		end
	end
	-- validate pets in queue timeline
	for index,petID in ipairs(settings.LevelingTimeline) do
		local valid,newPetID = rematch:ValidatePetID(petID)
		if not valid and newPetID then
			settings.LevelingTimeline[index] = newPetID
		end
	end
end

-- takes a petType (1-10) and returns a text string for the icon (20x20) with the thin circle border
function rematch:PetTypeAsText(petType)
	local suffix = PET_TYPE_SUFFIX[petType]
	return suffix and format("\124TInterface\\PetBattles\\PetIcon-%s:20:20:0:0:128:256:102:63:129:168\124t",suffix) or "?"
end

-- RematchTableTooltip is a tooltip designed for bigger text that doesn't wrap,
-- especially for in-line textures that want vertically-centered fontstrings.
-- Use RematchTooltip for traditional tooltips with wrapping lines of text.
-- info is an ordered table with each entry as a line: {"title is gold","rest of lines","are white"}
function rematch:ShowTableTooltip(anchorTo,info,height)
	if MouseIsOver(rematch.dialog) and rematch.dialog.timeShown==GetTime() then
		return -- if dialog appeared this frame, don't show a tooltip, to prevent it from obscuring what just appeared
	end
	if settings.HideTooltips then
		return -- tooltips hidden :(
	end
	height = height or 20 -- default of 20 height if not given
	local tooltip = RematchTableTooltip
	tooltip.lines = tooltip.lines or {}
	local lines = tooltip.lines
	local maxWidth = 0
	-- erase what was in this tooltip
	for _,line in ipairs(lines) do
		line:SetText("")
		line:Hide()
	end
	-- add a line for each entry in the passed table
	for i=1,#info do
		if not lines[i] then -- create line if it doesn't exist
			lines[i] = tooltip:CreateFontString(nil,"ARTWORK",i==1 and "GameFontNormal" or "GameFontHighlight")
			lines[i]:SetJustifyH("LEFT")
			lines[i]:SetJustifyV("CENTER")
			if i>1 then
				lines[i]:SetTextColor(.9,.9,.9)
			end
		end
		lines[i]:SetSize(0,height)
		lines[i]:SetPoint("TOPLEFT",tooltip,"TOPLEFT",8,-8-(i-1)*height)
		lines[i]:SetText(info[i])
		lines[i]:Show()
		maxWidth = max(maxWidth,lines[i]:GetStringWidth())
	end
	-- resize to accommodate the width/lines
	tooltip:SetWidth(maxWidth+16)
	tooltip:SetHeight(#info*height+16)
	tooltip:Show()
	rematch:SmartAnchor(tooltip,anchorTo)
end

-- takes an id and returns what type of id it is ("pet" "species" or "leveling")
function rematch:GetIDType(id)
	if type(id)=="string" and id:match("^BattlePet%-%x%-%x%x%x%x%x%x%x%x%x%x%x%x$") then
		return "pet"
	elseif id==0 then
		return "leveling"
	elseif type(id)=="number" then
		return "species"
	end
end

-- called in UpdateOwnedPets when a new pet is learned by any means
function rematch:OnPetAdded(petID)
	if settings.QueueAutoLearn and rematch:GetIDType(petID)=="pet" and rematch:PetCanLevel(petID) then
		local addID
		local speciesID,_,level,_,_,_,_,name = C_PetJournal.GetPetInfoByPetID(petID)
		if not settings.QueueAutoLearnOnly and not settings.QueueAutoLearnRare then
			addID = petID
		else
			-- QueueAutoLearnOnly requires pet not have its species at 25 already or a version in queue
			local at25orQueued = rematch.ownedSpeciesAt25[speciesID]
			-- look through queue if QueueAutoLearnOnly checked to see if species is in queue already
			if settings.QueueAutoLearnOnly and not at25orQueued then
				for _,qPetID in ipairs(settings.LevelingQueue) do
					if C_PetJournal.GetPetInfoByPetID(qPetID)==speciesID then
						at25orQueued = true
						break
					end
				end
			end
			if (not settings.QueueAutoLearnOnly or not at25orQueued) and (not settings.QueueAutoLearnRare or select(5,C_PetJournal.GetPetStats(petID))==4) then
				addID = petID
			end
		end
		if addID then
			rematch:AddLevelingPet(addID)
			rematch:ToastNextLevelingPet(petID,L["Added to the queue:"])
		end
	end
end
