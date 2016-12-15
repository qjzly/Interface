--[[
	This module was previously dedicated to finding the best petID for a species
	(to assign petIDs to missing pets if possible).  It will still serve that
	role but is now being expanded to track all owned pets all the time.

	The Sanctuary system now handles petIDs that are reassigned since last login.

	Previously, a table of owned petIDs was only generated when it went to find
	a pet.  Now it will maintain that list at all times for use in other areas
	(counting unique pets, determining if user owns a 25 of species, etc).

	This adds about ~50k to the addon but will greatly improve capabilities.

	 rematch:FindBestPetID(speciesID[,otherthanPetID1,otherthanPetID2]) takes a
]]

local rematch = Rematch

rematch.ownedPets = {} -- petID of owned pets, sorted by level then rarity
rematch.ownedSpeciesAt25 = {} -- indexed by speciesID, species where the player has a level 25 pet

-- these flags/filters will be used to clear and revert flags
rematch.ownedFlags = {
	[LE_PET_JOURNAL_FLAG_COLLECTED]=true,
	[LE_PET_JOURNAL_FLAG_NOT_COLLECTED]=true
}
rematch.ownedFilters = { flags={}, types={}, sources={} }
rematch.ownedDefaultSearch = "" -- search text of default pet journal
rematch.ownedUpdating = nil -- true when updating owned pets

rematch.movesets = nil -- will be table of movesets, max level and speciesID (if filtered)
rematch.movesetsAt25 = nil -- will be table of speciesID's that have a moveset at 25

-- fills rematch.ownedPets with a list of all owned petIDs sorted by
-- descending level (and descending rarity)
function rematch:UpdateOwnedPets()
	-- this function *always* causes PJLU to fire in the next frame;
	-- since a PJLU can cause other addons to react with their own, we'll unregister
	-- rematch from the event for 0.1 seconds to ignore its consequences
	rematch:UnregisterEvent("PET_JOURNAL_LIST_UPDATE")
	rematch.ownedUpdating = true
	rematch:StartTimer("UpdateOwnedBlackout",0.1,function() rematch:RegisterEvent("PET_JOURNAL_LIST_UPDATE") rematch.ownedUpdating=nil end)

	-- backup default filters (we don't touch roster at all)
	local filters = rematch.ownedFilters
	for flag in pairs(rematch.ownedFlags) do
		filters.flags[flag] = not C_PetJournal.IsFlagFiltered(flag)
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		filters.sources[i] = not C_PetJournal.IsPetSourceFiltered(i)
	end
	for i=1,C_PetJournal.GetNumPetTypes() do
		filters.types[i] = not C_PetJournal.IsPetTypeFiltered(i)
	end

	-- expand all filters so all pets are in journal
	C_PetJournal.ClearSearchFilter()
	for flag,value in pairs(rematch.ownedFlags) do
		C_PetJournal.SetFlagFilter(flag,value)
	end
	C_PetJournal.AddAllPetSourcesFilter()
	C_PetJournal.AddAllPetTypesFilter()

	local preOwnedPets -- if we need to know what pet was added, make a lookup of pets owned
	if RematchSettings.QueueAutoLearn and #rematch.ownedPets>0 then
		preOwnedPets = {}
		for _,petID in ipairs(rematch.ownedPets) do
			preOwnedPets[petID] = true
		end
	end

	-- fill ownedPets with all owned petIDs
	wipe(rematch.ownedPets)
	wipe(rematch.ownedSpeciesAt25) -- in case they cage any 25s

	-- if filter option enabled, indexed by moveset ("123,456,etc"), [1]=max level with moveset, then petIDs or speciesIDs with that moveset
	if rematch.roster:GetMiscFilter("NoMovesets25") then
		rematch.movesets = rematch.movesets or {}
		wipe(rematch.movesets) -- in case any 25s caged or released
	else
		rematch.movesets = nil -- don't make or carry this data if movesets not filtered
		rematch.movesetsAt25 = nil
	end
	local movesets = rematch.movesets

	for i=1,C_PetJournal.GetNumPets() do
		local petID,speciesID,_,_,level,_,_,_,_,_,_,_,_,_,canBattle = C_PetJournal.GetPetInfoByIndex(i)
		if petID then
			tinsert(rematch.ownedPets,petID)
			if level==25 then
				rematch.ownedSpeciesAt25[speciesID] = true
			end
		end
		-- moveset system by Zarbuta at curse.com (with some modifications)
		if canBattle and movesets then
			local moveset = ""
			C_PetJournal.GetPetAbilityList(speciesID,rematch.abilityList,rematch.levelList)
			for _,abilityID in ipairs(rematch.abilityList) do
				-- moveset is a list of the pet's abilities like "123,456,789,0123,45,678,"
				moveset = moveset..abilityID..","
			end
			if not movesets[moveset] then
				movesets[moveset] = {0} -- if this moveset not seen yet, create it and set its max level to 0
			end
			local set = movesets[moveset]
			set[1] = max(level,set[1]) -- set level to maximum of this pet's level or existing level
			if not tContains(set,speciesID) then
				table.insert(set,speciesID) -- add the speciesID to the moveset
			end
		end
	end

	-- if movesets populated, then update movesetsAt25
	if movesets then
		rematch:UpdateMovesetsAt25(true)
	end

	-- restore filters to their backed-up state
	for flag in pairs(rematch.ownedFlags) do
		C_PetJournal.SetFlagFilter(flag,filters.flags[flag])
	end
	for i=1,C_PetJournal.GetNumPetSources() do
		C_PetJournal.SetPetSourceFilter(i,filters.sources[i])
	end
	for i=1,C_PetJournal.GetNumPetTypes() do
		C_PetJournal.SetPetTypeFilter(i,filters.types[i])
	end
	C_PetJournal.SetSearchFilter(rematch.ownedDefaultSearch)

	-- now sort ownedPets by level/rarity
	local GetPetInfoByPetID = C_PetJournal.GetPetInfoByPetID
	local GetPetStats = C_PetJournal.GetPetStats
	table.sort(rematch.ownedPets,function(e1,e2)
		if e1 and not e2 then
			return true
		elseif e2 and not e1 then
			return false
		else
			local _,_,level1 = GetPetInfoByPetID(e1)
			local _,_,level2 = GetPetInfoByPetID(e2)
			if level1>level2 then -- level descending
				return true
			elseif level1<level2 then
				return false
			else -- levels are equal
				local _,_,_,_,rarity1 = GetPetStats(e1)
				local _,_,_,_,rarity2 = GetPetStats(e2)
				return rarity1>rarity2 -- rarity descending
			end
		end
	end)

	-- if there was a need to know what pet is added
	if preOwnedPets then
		for _,petID in ipairs(rematch.ownedPets) do
			if not preOwnedPets[petID] then
				rematch:OnPetAdded(petID) -- defined in common.lua
			end
		end
	end

end

-- finds best owned pet of speciesID that isn't pet1 or pet2 (if defined)
function rematch:FindBestPetID(speciesID,pet1,pet2)
	for i=1,#rematch.ownedPets do
		local petID = rematch.ownedPets[i]
		local candidateSpeciesID = C_PetJournal.GetPetInfoByPetID(petID)
		if candidateSpeciesID==speciesID and petID~=pet1 and petID~=pet2 and not C_PetJournal.PetIsRevoked(petID) then
			return petID
		end
	end
end

-- since there is no C_PetJournal.GetSearchFilter, we need to watch for it
hooksecurefunc(C_PetJournal,"SetSearchFilter",function(search)
	if not rematch.ownedUpdating then
		rematch.ownedDefaultSearch = search or ""
	end
end)
hooksecurefunc(C_PetJournal,"ClearSearchFilter",function(...)
	if not rematch.ownedUpdating then
		rematch.ownedDefaultSearch = ""
	end
end)

-- when ownedPets is populated, ownedSpeciesAt25 is too; but there it only happens
-- when pets are added/removed.  This function goes through and updates whether
-- any species reached 25.  To be called UPDATE_SUMMONPETS_ACTION (leveling.lua)
function rematch:UpdateOwnedSpeciesAt25()
	local speciesAt25 = rematch.ownedSpeciesAt25
	for _,petID in pairs(rematch.ownedPets) do
		local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
		if level==25 then
			speciesAt25[speciesID] = true
		end
	end
	-- if movesets exists, then update movesets at 25
	local movesets = rematch.movesets
	if movesets then
		for set,info in pairs(movesets) do
			for i=2,#info do
				if speciesAt25[info[i]] then
					movesets[set][1] = 25
				end
			end
		end
		rematch:UpdateMovesetsAt25()
	end
end

-- called from UpdateOwnedPets and UpdateOwnedSpeciesAt25, fills rematch.movesetsAt25
-- with speciesIDs that have a moveset at 25
function rematch:UpdateMovesetsAt25(clear)
	rematch.movesetsAt25 = rematch.movesetsAt25 or {}
	if clear then
		wipe(rematch.movesetsAt25)
	end
	for _,info in pairs(rematch.movesets) do
		if info[1]==25 then
			for i=2,#info do
				rematch.movesetsAt25[info[i]] = true
			end
		end
	end
end

--[[ Sanctuary system for restoring petIDs that are reassigned by the server ]]

-- This stores all petIDs in the teams and queue to RematchSettings.SanctuaryPets
-- and also removes petIDs that are no longer in a team or queue. It should
-- only be called on PLAYER_LOGOUT. (PushSideline and InsertIntoLevelingQueue
-- handle adding pets to the sanctuary as they join teams and the queue.)
function rematch:SanctuarySave()
	RematchSettings.SanctuaryPets = RematchSettings.SanctuaryPets or {}
	local sanctuary = RematchSettings.SanctuaryPets
	local known = {} -- lookup table to speed process
	-- save petIDs from the all teams
	for _,team in pairs(RematchSaved) do
		for i=1,3 do
			local petID = team[i][1]
			if petID and not known[petID] then
				known[petID] = true
				Rematch:AddToSanctuary(petID)
			end
		end
	end
	-- save petIDs from the queue
	for _,petID in pairs(RematchSettings.LevelingQueue) do
		if not known[petID] then
			known[petID] = true
			Rematch:AddToSanctuary(petID)
		end
	end
	-- now remove any petIDs from the sanctuary that weren't encountered in a team or queue
	for i=#sanctuary,1,-1 do
		local petID = sanctuary[i]:sub(1,24)
		if not known[petID] then
			tremove(sanctuary,i)
		end
	end
end

-- adds a petID and its stats to the sanctuary if it's not already in the sanctuary
function rematch:AddToSanctuary(petID)
	local sanctuary = RematchSettings.SanctuaryPets
	if rematch:GetIDType(petID)~="pet" then
		return -- only adding petIDs to sanctuary
	end
	for i=1,#sanctuary do
		if sanctuary[i]:sub(1,24)==petID then
			return -- pet is already in the sanctuary
		end
	end
	-- if we reach this point, pet isn't in sanctuary
	local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
	if speciesID then
		local _,maxHealth,power,speed = C_PetJournal.GetPetStats(petID)
		tinsert(sanctuary,format("%s,%d,%d,%d,%d,%d",petID,speciesID,level,maxHealth,power,speed))
	end
end

-- returns true if the petID is valid (or not an actual petID), false otherwise (followed by
-- the newPetID if one found). For optimization, sanctuaryLookups contains all petIDs that
-- are not valid and were already searched. the table is wiped on PET_JOURNAL_LIST_UPDATE
rematch.sanctuaryLookups = {}
function rematch:ValidatePetID(petID)
	if rematch:GetIDType(petID)~="pet" then
		return true -- it's not a petID, so it's fine whatever it is
	end
	local found = C_PetJournal.GetPetInfoByPetID(petID)
	if found then
		return true -- pet is valid, no need to find it in sanctuary
	end
	local lookup = rematch.sanctuaryLookups[petID]
	if lookup then
		-- we already searched for this petID in the sanctuary, return false (invalid petID)
		-- and the result of the previous attempt (lookup will be the new petID if a new one
		-- was found, or false if a new one wasn't found)
		return false,(lookup~=true and lookup)
	end

	-- at this point this is a petID that no longer exists (server reassigned petID or
	-- user caged/released the pet). We now go through the sanctuary to see if we can
	-- find the new petID for this same pet based on its saved stats.

	local sanctuary = RematchSettings.SanctuaryPets
	for i=1,#sanctuary do
		if sanctuary[i]:sub(1,24)==petID then
			found = sanctuary[i]
			break
		end
	end
	if not found then
		rematch.sanctuaryLookups[petID] = true
		return false,false -- uhoh, petID not valid and not found in sanctuary
	end

	local petID,speciesID,level,maxHealth,power,speed = found:match("^(.+),(%d+),(%d+),(%d+),(%d+),(%d+)")
	if not petID or not speed then
		rematch.sanctuaryLookups[petID] = true
		return false,false -- petID not valid and sanctuary pet is corrupted or unreadable
	end

	speciesID = tonumber(speciesID)
	level = tonumber(level)
	maxHealth = tonumber(maxHealth)
	power = tonumber(power)
	speed = tonumber(speed)

	for _,cPetID in ipairs(rematch.ownedPets) do
		local cSpeciesID,_,cLevel = C_PetJournal.GetPetInfoByPetID(cPetID)
		if speciesID==cSpeciesID and level==cLevel then -- species and level match
			local _,cMaxHealth,cPower,cSpeed = C_PetJournal.GetPetStats(cPetID)
			if cMaxHealth==maxHealth and cPower==power and cSpeed==speed then -- so do stats! found it!
				rematch.sanctuaryLookups[petID] = cPetID -- add it to lookup table
				rematch:AddToSanctuary(cPetID) -- add it to the saved sanctuary
				return false,cPetID -- petID not valid but return new petID
			end
		end
	end

	rematch.sanctuaryLookups[petID] = true
	return false,false -- found invalid petID in sanctuary, but didn't find a live version, sorry!
end
