
local _,L = ...
local rematch = Rematch
local settings
local saved

local DEBUG = nil
local function debugp(...) if DEBUG then print(...) end end

-- loadin is a team table filled with the pets and abilities to load
-- LoadTeam(teamName) fills the table
-- LoadLoadIn() actually loads the pets/abilities (and removes from table)
-- when loadin is empty, the team is done loading
local loadin = {{},{},{}}
local loadingTeamName -- name of team being loaded
local loadtimeout -- LoadLoadIn attempts (max 10)

function rematch:InitPetLoading()
	settings = RematchSettings
	saved = RematchSaved
	settings.loadedTeamTable = type(settings.loadedTeamTable)=="table" and settings.loadedTeamTable or {{},{},{}}
end

-- loads the pets defined in loadin
-- nils the pets/abilities in loadin that loaded successfully
-- returns true if everything loaded
function rematch:LoadLoadIn()

	if InCombatLockdown() or C_PetBattles.IsInBattle() then
		rematch.teamNeedsLoaded = loadingTeamName
		return
	end

	local loadout = rematch.info
	wipe(loadout)

	-- now attempt to load all pets/abilities that are defined
	for slot=1,3 do
		debugp("__ slot",slot,"__")
		loadout[1],loadout[2],loadout[3],loadout[4] = C_PetJournal.GetPetLoadOutInfo(slot)
		-- pet slot
		if loadin[slot][1] and loadin[slot][1] ~= loadout[1] then
			debugp("loading pet slot",slot,":",loadin[slot][1],(select(8,C_PetJournal.GetPetInfoByPetID(loadin[slot][1]))))
			if slot==1 then
				rematch:SummonedPetMayChange()
			end
			C_PetJournal.SetPetLoadOutInfo(slot,loadin[slot][1])
		end
		-- ability slots
		for i=1,3 do
			local abilityID = loadin[slot][i+1]
			if abilityID and loadout[i+1]~=abilityID then
				debugp("loading ability slot",i,":",abilityID)
				C_PetJournal.SetAbility(slot,i,abilityID)
			end
		end
	end

	-- now nil out the pets/abilities that loaded successfully
	for slot=1,3 do
		loadout[1],loadout[2],loadout[3],loadout[4] = C_PetJournal.GetPetLoadOutInfo(slot)
		for i=1,4 do
			if (loadin[slot][i]==loadout[i]) or (loadin[slot][i]==rematch.emptyPetID and not loadout[i]) then
				loadin[slot][i] = nil
			elseif loadin[slot][i] then
				debugp("pet slot",slot,"index",i,"(",unpack(loadin[slot]),") didn't load.")
			end
		end
	end

	-- if anything left in loadin, return false; everything didn't load
	for i=1,3 do
		for j=1,4 do
			if loadin[i][j] then
				return false
			end
		end
	end

	-- if we made it this far, return true; everything loaded
	return true
end

function rematch:LoadTeam(teamName)

	local team = saved[teamName]
	if not team then return end

	if C_PetBattles.GetPVPMatchmakingInfo() then -- can't load teams while queued or in a pvp battle
		local info = ChatTypeInfo["SYSTEM"]
		print(format("\124cff%02x%02x%02x",info.r*255, info.g*255, info.b*255)..ERR_PETBATTLE_NOT_WHILE_IN_MATCHED_BATTLE)
		return
	end
	if InCombatLockdown() or C_PetBattles.IsInBattle() then
		rematch.teamNeedsLoaded = teamName
		return
	end

	rematch.loadInProgress = true

	loadingTeamName = teamName

	rematch:HideDialogs()

	rematch:ValidateTeam(team)

	rematch.header.text:SetText(L["Loading..."])
	rematch:DesaturatePets(true)

	-- wipe loadout; slots/abilities to ignore will be nil
	for i=1,3 do
		wipe(loadin[i])
	end

	local levelingPickIndex = 1

	-- fill loadin from the team
	for i=1,3 do
		local petID = team[i][1]
		local levelingPick = rematch:GetLevelingPick(levelingPickIndex)
		if petID==0 and levelingPick then
			loadin[i][1] = levelingPick
			levelingPickIndex = levelingPickIndex + 1
		elseif rematch:GetIDType(petID)=="pet" then
			if C_PetJournal.GetPetInfoByPetID(petID) and not C_PetJournal.PetIsRevoked(petID) then
				loadin[i][1] = petID
				for j=1,3 do
					local abilityID = team[i][j+1]
					if abilityID and abilityID~=0 then
						loadin[i][j+1] = abilityID
					end
				end
			end
		end
	end

	if rematch:LoadLoadIn() then
		debugp(teamName,"loaded successfully first try!")
		rematch:LoadingDone()
	else
		debugp("** something didn't load from",teamName,"**")
		loadtimeout = 0
		rematch:StartTimer("ReloadLoadIn",0.2,rematch.ReloadLoadIn)
	end

end

function rematch:ReloadLoadIn()
	if rematch:LoadLoadIn() then
		debugp(loadingTeamName,"loaded successfully in",loadtimeout,"tries!")
		rematch:LoadingDone()
	elseif loadtimeout<20 then
		loadtimeout = loadtimeout + 1
		debugp("retrying again. loadtimeout=",loadtimeout)
		rematch:StartTimer("ReloadLoadIn",0.25,rematch.ReloadLoadIn)
	else
		debugp("giving up on",loadingTeamName,"!")
		rematch:LoadingDone(true)
	end
end

function rematch:DesaturatePets(value)
	for i=1,3 do
		rematch.current.pets[i].icon:SetDesaturated(value)
		for j=1,3 do
			rematch.current.pets[i].abilities[j].icon:SetDesaturated(value)
		end
	end
	rematch.current.back:SetDesaturated(value)
end

function rematch:LoadingDone(unsuccessful)

	if unsuccessful then
		-- in the rare event a load unsuccessful (lag?), nil loaded team
		settings.loadedTeam = nil
		rematch.lastOffered = nil
	else
		-- set loaded team
		settings.loadedTeam = loadingTeamName
		if rematch:IsVisible() then
			for i=1,3 do
				rematch.current.pets[i].shine:SetCooldownDuration(0.01)
			end
		end
	end

	rematch:DesaturatePets(false)
	rematch.loadInProgress = nil
	rematch.teamNeedsLoaded = nil

	if PetJournal then
		PetJournal_UpdatePetLoadOut()
	end

	local team = saved[settings.loadedTeam]

	-- the AutoAlways setting will reprompt to load a team when interacting with a target that has
	-- the team already loaded. simply nil'ing knowledge of the loaded team when pets change causes
	-- prompts to appear for any change (like leveling pet automatic swaps). this will note the
	-- "fixed" pets and abilities (non-empty, non-leveling slots) to compare when pets change.
	-- this information is kept for the reload option as well
	if team then
		local info = rematch.info
		for i=1,3 do
			info[1],info[2],info[3],info[4] = C_PetJournal.GetPetLoadOutInfo(i)
			for j=1,4 do
				if info[j]==team[i][j] then
					settings.loadedTeamTable[i][j] = info[j]
				else
					settings.loadedTeamTable[i][j] = nil
				end
			end
		end
	end

	if rematch:IsVisible() then
		if settings.loadedTeam and settings.loadedTeam==rematch.automaticallyShownForTeam and not settings.AutoShowStay then
			rematch:Hide()
		else
			rematch:UpdateWindow()
		end
	else
		if settings.AutoLoadShow or not team then -- if team loaded when window wasn't up, show the window is AutoLoadShow set or a team failed to load
			rematch:Show()
		elseif team then -- if window isn't up, see if any pets are hurt enough to show window
			for i=1,3 do
				local petID = C_PetJournal.GetPetLoadOutInfo(i)
				if type(petID)=="string" and petID~=rematch.emptyPetID then
					local health,maxHealth = C_PetJournal.GetPetStats(petID)
					if health<1 then
						rematch:Show()
					elseif health<maxHealth and settings.ShowOnInjured then
						rematch:Show()
					end
				end
			end
		end
	end

	rematch.automaticallyShownForTeam = nil
	rematch.lastNotedTeam = nil

	-- if any pets are species (petID is a number), show a dialog to warn pet is missing
	if not settings.DontWarnMissing and team then
		local missing
		for i=1,3 do
			local idType = rematch:GetIDType(team[i][1])
			if idType=="species" or (idType=="pet" and not C_PetJournal.GetPetInfoByPetID(team[i][1])) then
				missing = true
			end
		end
		if missing then
			rematch:Show()
			rematch:ShowMissingDialog(settings.loadedTeam)
		end
	end

	wipe(settings.ManuallySlotted)

	rematch:ProcessQueue() -- team change may mean leveling pet preferences changed

end

function rematch:ShowMissingDialog(teamName)
	local team = saved[teamName]
	if team then

		local dialog = rematch:ShowDialog("MissingPets",158,teamName,L["Pets are missing!"],true)

		dialog.team:SetPoint("TOP",0,-24)
		dialog.team:Show()

		rematch:FillPetFramesFromTeam(dialog.team.pets,team,teamName)

		-- show a red leveling border around missing pets
		for i=1,3 do
			local idType = rematch:GetIDType(team[i][1])
			if idType=="species" or (idType=="pet" and not C_PetJournal.GetPetInfoByPetID(team[i][1])) then
				dialog.team.pets[i].leveling:Show()
				dialog.team.pets[i].leveling:SetDesaturated(true)
				dialog.team.pets[i].leveling:SetVertexColor(1,0,0)
			end
		end

		dialog.checkBox:SetPoint("BOTTOMLEFT",28,38)
		dialog.checkBox.tooltipTitle = nil
		dialog.checkBox.text:SetText(L["Don't warn about missing pets"])
		dialog.checkBox:SetChecked(false)
		dialog.checkBox:SetScript("OnClick",function(self) settings.DontWarnMissing = self:GetChecked() end)
		dialog.checkBox:Show()

		dialog.warning:SetPoint("BOTTOMLEFT",12,5)
		dialog.warning.text:SetText(" ")
		dialog.warning:Show()

	end
end
