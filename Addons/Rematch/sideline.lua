--[[ The sideline is a place to put teams for intermediate use, such as when
		 saving, receiving, renaming, etc.

	Instead of ferrying parts of teams piecemeal through the dialogs, all
	interactions with teams will begin by placing them on the sideline. When
	done, they're pushed back into the saved teams.

	When starting to deal with a team:
		rematch:SetSideline("name of team" or npcID[,{team table}])
			
	Any manipulation of this team should be from the return of:
		{team table}, "name of team", "orinal name" = rematch:GetSideline()
	If the name of the team needs changed:
		rematch:RenameSideline("name of team" or npcID)
			
	When the team is ready to get integrated into saved teams:
		rematch:PushSideline()

]]

local _,L = ...
local rematch = Rematch

-- the table that contains the sideline team, will usually only have one:
-- { ["teamName" or npcID] = {team table} }
local sideline = {} 
-- context stores information about how the sideline is to be used, to be set
-- after a team is sidelined with rematch:SetSidelineContext("var",value) and
-- retrieved with rematch:GetSidelineContact("var")
-- wiped when a new team is sidelined with originalKey immediately added
local context = {}

-- copies a table (max one sub-table deep)
local function copy(t1,t2)
	for k,v in pairs(t1) do
		if type(v)=="table" then
			t2[k] = {}
			for x,y in pairs(v) do
				t2[k][x] = y
			end
		else
			t2[k] = v
		end
	end
end

-- copies a team to the sideline. Used when starting to deal with a new
-- (or old) team. If a dialog can reappear (such as a save dialog returning
-- on a cancelled confirmation) this should be called before dialogs start
-- getting involved.
function rematch:SetSideline(key,team)
	if not key then return end -- no name/key given, leave right away
	team = team or RematchSaved[key]
	if key and type(team)=="table" then -- setting up new team
		wipe(sideline)
		sideline[key] = {}
		copy(team,sideline[key])
		wipe(context)
		rematch:SetSidelineContext("originalKey",key)
		return sideline[key],key
	end
end

-- sidelines the currently loaded team and changes pets to the currently loaded pets
-- if no team is loaded, sidelines a unique "New Team"
-- if useTarget is true, change the key to the current target if an npc is targeted
function rematch:SidelineCurrentPets(useTarget)
	local settings = RematchSettings
	local saved = RematchSaved
	wipe(sideline)

	local key = settings.loadedTeam
	if key and saved[key] then
		rematch:SetSideline(key,saved[key])
	else
		rematch:SetSideline(L["New Team"],{tab=(settings.SelectedTab>1 and settings.SelectedTab or nil)})
		rematch:MakeSidelineUnique()
	end

	-- if we have an npc targeted, and useTarget passed (save as... button), then change key/name to target
	if useTarget and rematch.targetNpcID then
		local _,teamKey = rematch:GetSideline()
		if teamKey~=rematch.targetNpcID then
			rematch:ChangeSidelineKey(rematch.targetNpcID)
		end
		local team = rematch:GetSideline() -- have to get it again since ChangeSidelineKey has changed team
		team.teamName = rematch.targetName
	end

	local team,teamKey = rematch:GetSideline()

	-- copy the currently loaded pets and their abilities to the sidelined pet slots
	for i=1,3 do
		local petID,ability1,ability2,ability3 = C_PetJournal.GetPetLoadOutInfo(i)
		if rematch:IsPetLeveling(petID) then -- if loadout pet is leveling
			team[i] = {0}
		elseif petID then -- for normal pets, get its speciesID and add it too
			local speciesID = C_PetJournal.GetPetInfoByPetID(petID)
			team[i] = {petID,ability1,ability2,ability3,speciesID}
		else -- empty slot?
			team[i] = {}
		end
	end

	rematch:SetSidelineContext("forCurrent",true) -- notes that this team was made from current pets
end

-- copies existing sideline to a new team with newKey as index and deletes the old
function rematch:ChangeSidelineKey(newKey)
	local oldTeam, oldKey = rematch:GetSideline()
	if newKey and oldKey and newKey~=oldKey then
		sideline[newKey] = {}
		copy(oldTeam,sideline[newKey])
		sideline[oldKey] = nil
	end
end

-- returns the table of the sidelined team and its current key
function rematch:GetSideline()
	local teamKey,team = next(sideline)
	return team,teamKey
end

-- pushes the sideline team into RematchSaved huzzah!
function rematch:PushSideline(report)
	local saved = RematchSaved
	local settings = RematchSettings
	local team,key = rematch:GetSideline()
	local originalKey = rematch:GetSidelineContext("originalKey")
	local forCurrent = rematch:GetSidelineContext("forCurrent")
	local backupNotes -- place to store backup notes and preferences in case they shouldn't be pushed
	local backupKeys = {"notes","minHP","allowMM","expectedDD","maxXP"} -- keys into the team table for notes and preferences (that don't always get pushed)

	-- if a team saving over another existing team, backup existing team's notes/preferences
	if saved[key] and originalKey~=key then
		backupNotes = {}
		for k,v in pairs(backupKeys) do
			backupNotes[v] = saved[key][v]
		end
	end

	saved[key] = {} -- create new one with clean slate
	copy(team,saved[key]) -- copy sideline to saved

	-- if we just overwrote another existing team, restore its original notes/preferences if it had any
	if backupNotes then
		for k,v in pairs(backupKeys) do
			saved[key][v] = backupNotes[v]
		end
	end

	if forCurrent or RematchSettings.loadedTeam==originalKey then
		-- this is the current pets being pushed, do anything related to loaded team here
		RematchSettings.loadedTeam = key
		if rematch:IsVisible() then -- do a cooldown bling on team name at top of window
			rematch:ShineOnYouCrazy(rematch.header)
		end
		-- Loadteam in case any funny business with imported/received teams (changed loaded team)
		-- also a LoadTeam will wipe ManuallySlotted and run ProcessQueue
		rematch:LoadTeam(key)
	end

	if originalKey~=key and rematch:GetSidelineContext("deleteOriginal") then
		saved[originalKey] = nil
	end
	if type(key)=="string" then
		saved[key].teamName = nil -- don't keep redundant teamName when a team is keyed by its name
	end
	for i=1,3 do
		rematch:AddToSanctuary(team[i][1])
	end
	rematch:UpdateWindow()
	rematch:ScrollToTeam(key) -- checks to make sure team list visible
	if report and settings.SpamTeamSave then
		local tab = team.tab or 1
		rematch:print(format(L["\124cffffd200%s\124r saved to \124T%s:14\124t%s"],rematch:GetSidelineTitle(true),settings.TeamGroups[tab][2],settings.TeamGroups[tab][1]))
	end
end

-- sets and returns single values from the sideline context table.
-- example: rematch:SetSidelineContext("forCurrent",true)
function rematch:SetSidelineContext(var,value)
	context[var] = value
end
function rematch:GetSidelineContext(var)
	return context[var]
end

-- returns the displayed name of the sidelined team
function rematch:GetSidelineTitle(color)
	local team,teamKey = rematch:GetSideline()
	if type(teamKey)=="number" then
		if color then
			return format("\124cffffffff%s\124r",team.teamName)
		else
			return team.teamName
		end
	else
		return teamKey
	end
end

--[[ New Team reorganization

	Instead of the key for all teams being the name of the team, with various
	info (like npcID) stored in an ordered table (1-3 pets, 4=npcID, 5=tab, etc),
	teams are now keyed by npcID for teams with an npcID, name for those without
	an npcID, and all data except pets are unordered keys within the table:

	[npcID or "teamName"] = {
	  [1] = {"BattlePet-0-petID",ability1,ability2,ability3,speciesID},
	  [2] = 0, -- leveling pet
	  [3] = {nil,ability1,ability2,ability3,speciesID}, -- missing pet
	  teamName = "Name of team", (if key is npcID)
	  tab = 3 -- tab number or nil if general
	  notes = "Notes for team",
	  minHP = 500, -- minimum health preference
	  allowMM = true, -- allow magic & mechanical preference
	  expectedDD = 10, -- damage type expected (1-10 pet type)
	  maxXP = 23.5, -- maximum level preference
	},

	The possibility of having an npcID within a named team is still left open for
	later. It will just be another entry in the table.
]]

function rematch:ConvertToNewTeamFormat()
	local settings = RematchSettings
	local saved = RematchSaved

	if settings.NewTeamFormat then
		return -- teams are already updated
	end

	if settings.loadedTeamName and saved[settings.loadedTeamName] then
		settings.loadedTeam = saved[settings.loadedTeamName][4] or settings.loadedTeamName
	end

	oldSaved = {} -- copying live teams to here to translate from
	copy(saved,oldSaved)

	local npcTeams = {} -- table indexed by team names of the npcID they contain

	local function convert(teamName,team)
		local key = team[4] or teamName
		if saved[key] then
			key = teamName -- another team shared an npcID, use the teamName instead
		end
		saved[key] = {}
		for i=1,3 do
			local petID = team[i][1]
			local idType = rematch:GetIDType(petID)
			if idType=="leveling" then
				saved[key][i] = {0} -- leveling pet
			elseif idType=="pet" or idType=="species" then
				saved[key][i] = {unpack(team[i])} -- any other pet
			else -- everything else
				saved[key][i] = {nil} -- slots with nil for petID are ignored
			end
		end
		if type(key)=="number" then
			saved[key].teamName = teamName
			npcTeams[teamName] = team[4]
		end
		saved[key].tab = team[5]
		saved[key].notes = team[6]
		saved[key].minHP = team[7]
		saved[key].allowMM = team[8]
		saved[key].maxXP = team[9]
		saved[key].expectedDD = team[10]
	end

	wipe(saved) -- scary!
	for teamName,team in pairs(oldSaved) do
		-- using pcall to skip a team if any errors happen instead of stopping conversion
		pcall(convert,teamName,team)
	end
--	wipe(oldSaved) -- done with old teams

	-- now go through custom sorted team tabs and change team names to npcIDs
	local tabs = settings.TeamGroups
	if type(tabs)=="table" then
		for i=2,#tabs do
			local custom = tabs[i][3]
			if type(custom)=="table" then
				for j=1,#custom do
					local name = custom[j]
					if npcTeams[name] then
						custom[j] = npcTeams[name]
					end
				end
			end
		end
	end

	settings.NewTeamFormat = true
end

-- returns the name of the team for display purposes
-- if color is true, prefixes white color code if it's a team with an npcID
function rematch:GetTeamTitle(teamKey,color)
	local saved = RematchSaved
	local forNpc = type(teamKey)=="number"
	if saved[teamKey] and forNpc then
		if color then
			return format("\124cffffffff%s\124r",saved[teamKey].teamName or "")
		else
			return saved[teamKey].teamName or ""
		end
	else
		return teamKey
	end
end

-- Call when a sideline team needs to be made unique. (Creating a "New Team"
-- or when choosing "Save as a new team" in import/receive.)
-- If the sideline team's key is already unique, no changes are made.
-- If the key isn't unique, the key will be converted to a named key (if needed)
-- and a number appended to make it unique: "New Team (3)" "Aki the Chosen (2)"
function rematch:MakeSidelineUnique()
	local saved = RematchSaved
	local team,key = rematch:GetSideline()
	if not saved[key] then
		return -- team is already unique, that was easy!
	end
	-- all npcID-keyed teams that are not unique get their key changed to the team's name
	if type(key)=="number" then
		key = team.teamName
		team.teamName = nil
		rematch:ChangeSidelineKey(key)
		if not saved[key] then
			return -- text name of team for this npcID is unique
		end
	end
	-- at this point, key is a type(text) is a string that's not unique
	local index = 2
	local newKey
	repeat -- extra copies are named "New Team (2)" "New Team (3)" until one available
		newKey = format("%s (%d)",key,index)
		index = index + 1
	until not saved[newKey]
	-- now, newKey is a unique key
	rematch:ChangeSidelineKey(newKey)
end
