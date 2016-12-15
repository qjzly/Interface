
local _,L = ...
local rematch = Rematch
local settings

function rematch:InitCurrent()
	settings = RematchSettings
	rematch.header.text:SetText(L["Current Battle Pets"])

	for i=1,3 do
		rematch.current.pets[i].menu = "current"
		rematch.current.pets[i].shine:SetDrawEdge(false)
		rematch.current.pets[i].shine:SetDrawSwipe(false)
	end

	-- there's no event for when loadout pets change (really!) so we hooksecurefunc them
	hooksecurefunc(C_PetJournal,"SetAbility",rematch.StartPetsChanging)
	hooksecurefunc(C_PetJournal,"SetPetLoadOutInfo",rematch.StartPetsChanging)

	-- adjust the color of the doodads in the corners
	for i=1,4 do
		if i<3 then -- top ones are lighter
			rematch.current.doodads[i]:SetVertexColor(1,.82,0)
		else -- bottom ones are darker (1,.82,0 divided by 5)
			rematch.current.doodads[i]:SetVertexColor(.2,.164,0)
		end
		rematch.current.doodads[i]:SetDesaturated(true)
	end

end

function rematch:CurrentPetOnReceiveDrag()
	local petID = rematch:GetCursorPetID()
	if petID then
		rematch:LoadPetSlot(self:GetID(),petID)
		rematch:HandleReceivingLevelingPet(petID)
		ClearCursor()
	end
end

function rematch:CurrentPetOnEnter(noCard)
	if not noCard then
		rematch:ShowFloatingPetCard(self.petID,self)
	end
	if self.petID and rematch:GetCurrentLevelingPet()==self.petID then
		rematch.current.swap:SetParent(self)
		rematch.current.swap:SetPoint("TOP",self,"BOTTOM",0,4) -- -10,10)
		rematch.current.swap:Show()
	end
end

function rematch:UpdateCurrentPets()

	rematch:WipePetFrames(rematch.current.pets)

	if select(2,C_PetJournal.GetNumPets())==0 then
		-- if pets not loaded, come back in half a second to try again
		rematch:StartTimer("PetsRanAway",0.5,rematch.UpdateCurrentPets)
		return
	end

	local ability = rematch.info
	local petID

	for i=1,3 do
		local button = rematch.current.pets[i]
		petID, ability[1],ability[2],ability[3] = C_PetJournal.GetPetLoadOutInfo(i)
		if petID then
			button.petID = petID
			local speciesID,_,level,xp,xpmax,_,_,_,icon = C_PetJournal.GetPetInfoByPetID(petID)
			-- update this pet's icon
		  button.icon:SetTexture(icon)
			button.icon:Show()
			-- update this pet's abilities
			for j=1,3 do
				button.abilities[j].abilityID = ability[j]
				button.abilities[j].icon:SetTexture((select(2,C_PetJournal.GetPetAbilityInfo(ability[j]))))
				button.abilities[j].icon:Show()
				-- confirm pet is high enough to have this ability
				local canUseAbility,abilityLevel
				wipe(rematch.abilityList)
				C_PetJournal.GetPetAbilityList(speciesID,rematch.abilityList,rematch.levelList)
				for k=1,#rematch.abilityList do
					if ability[j]==rematch.abilityList[k] then
						abilityLevel = rematch.levelList[k]
						if level>=abilityLevel then
							-- they have this ability and they're high enough to use it
							canUseAbility = true
						end
						break
					end
				end
				if canUseAbility then
					button.abilities[j].icon:SetVertexColor(1,1,1)
					button.abilities[j].icon:SetDesaturated(false)
					button.abilities[j].level:Hide()
				else
					button.abilities[j].icon:SetVertexColor(.3,.3,.3)
					button.abilities[j].icon:SetDesaturated(true)
					button.abilities[j].level:SetText(abilityLevel)
					button.abilities[j].level:Show()
				end
				button.abilities[j].canUse = canUseAbility
			end
			-- xp bar: update+show xp bar if pet is less than 25, hide if pet is 25
			local notMax = level<25
			local bars = button.bars
			if notMax then
				bars.healthBG:SetPoint("TOPLEFT",button,"BOTTOMLEFT",2,0)
				bars.xp:SetWidth(xp>0 and 38*(xp/xpmax) or 1)
				button.level:SetText(level)
			else
				bars.healthBG:SetPoint("TOPLEFT",button,"BOTTOMLEFT",2,-4)
			end
			bars.xpBG:SetShown(notMax)
			bars.xp:SetShown(notMax)
			button.levelBG:SetShown(notMax)
			button.level:SetShown(notMax)
			-- update hp and whether pet is dead
			local hp,hpmax,_,_,rarity = C_PetJournal.GetPetStats(petID)
			if hp>0 then
				bars.health:SetWidth(hp>0 and 38*(hp/hpmax) or 1)
				button.deadPulse:Stop()
			else
				button.deadPulse:Play()
			end
			button.blood:SetShown(hp<hpmax)
			button.dead:SetShown(hp==0)
			bars.healthBG:Show()
			bars.health:SetShown(hp>0)
			-- color border for rarity
			if not settings.HideRarityBorders then
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
				button.border:SetVertexColor(r,g,b,1)
				button.border:Show()
			end
			button.bars:Show()
		else
			button.petID = rematch.emptyPetID
			button.bars:Hide()
			button.level:Hide()
		end
	end
	rematch:UpdateCurrentLevelingBorders()
end

function rematch:UpdateCurrentLevelingBorders()
	local loadedTeam = settings.loadedTeam and RematchSaved[settings.loadedTeam]
	for i=1,3 do
		local petID = C_PetJournal.GetPetLoadOutInfo(i)
		if loadedTeam and loadedTeam[i][1]==petID then
			rematch.current.pets[i].leveling:Hide()
		else
			rematch.current.pets[i].leveling:SetShown(rematch:IsPetLeveling(petID))
			rematch.current.pets[i].leveling:SetDesaturated(settings.ManuallySlotted[petID])
		end
	end
end

-- called from a hooksecurefunc of SetAbility and SetPetLoadOutInfo. update 0.1 seconds
-- after they begin to allow multiple simultaneous changes to happen before doing an update
function rematch:StartPetsChanging()
	if not rematch.loadInProgress then -- and rematch:IsVisible()
		rematch:StartTimer("PetsChanging",0.1,rematch.FinishPetsChanging)
	end
end

-- runs 0.1 seconds after pets/abilities change, primarily calls an UpdateWindow
-- but also does extra processing if AutoAlways enabled to see if any pets really changed
function rematch:FinishPetsChanging()
	if settings.AutoAlways and type(settings.loadedTeamTable)=="table" then
		local info = rematch.info
		for i=1,3 do
			info[1],info[2],info[3],info[4] = C_PetJournal.GetPetLoadOutInfo(i)
			for j=1,4 do
				local id = settings.loadedTeamTable[i][j] -- can be petID or abilityID
				if id and info[j]~=id then
					settings.loadedTeam = nil -- something legitimately changed, "forget" team currently loaded
				end
			end
		end
	end
	if rematch:IsVisible() then
		rematch:UpdateWindow()
	end
end

function rematch:CurrentAbilityOnEnter()
	if self.abilityID and self.arrow then
		self.arrow:Show()
	end
	rematch.ShowAbilityCard(self,self:GetParent().petID,self.abilityID)
end

function rematch:CurrentAbilityOnLeave()
	if self.arrow then
		self.arrow:Hide()
	end
	rematch:HideAbilityCard()
end

function rematch:CurrentAbilityOnClick()
	local flyout = RematchAbilityFlyout
	local petSlot = self:GetParent():GetID()
	local abilitySlot = self:GetID()
	if IsModifiedClick("CHATLINK") then
		rematch:ChatLinkAbility(self:GetParent().petID,self.abilityID)
	elseif flyout.petSlot==petSlot and flyout.abilitySlot==abilitySlot then
		flyout:Hide()
		self.arrow:Show()
	else
		local petID = self:GetParent().petID
		if petID and petID~=rematch.emptyPetID then
			self.arrow:Hide()
			flyout.petSlot = petSlot
			flyout.abilitySlot = abilitySlot
			flyout:SetParent(self)
			flyout:SetPoint("RIGHT",self,"LEFT")
			flyout.petID = petID
			rematch:FillFlyout(petSlot,abilitySlot)
			flyout.timer = 0
			flyout:Show()
		end
	end
end

function rematch:FlyoutOnHide()
	self.petSlot = nil
	self.abilitySlot = nil
end

function rematch:FlyoutButtonOnClick()
	if IsModifiedClick("CHATLINK") then
		rematch:ChatLinkAbility(self:GetParent().petID,self.abilityID)
	elseif self.canUse then
		local parent = self:GetParent()
		C_PetJournal.SetAbility(parent.petSlot,parent.abilitySlot,self.abilityID)
		parent:Hide()
		if PetJournal then
			PetJournal_UpdatePetLoadOut() -- update petjournal if it's open
		end
	end
end

function rematch:FlyoutOnUpdate(elapsed)
	self.timer = self.timer + elapsed
	if self.timer > 0.75 then
		self:Hide()
	elseif MouseIsOver(self) or MouseIsOver(self:GetParent()) then
		self.timer = 0
	end
end

function rematch:FillFlyout(petSlot,abilitySlot)
	local flyout = RematchAbilityFlyout
	local petID = C_PetJournal.GetPetLoadOutInfo(petSlot)
	local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(petID)
	C_PetJournal.GetPetAbilityList(speciesID,rematch.abilityList,rematch.levelList)

	for i=1,2 do
		local button = flyout.ability[i]
		local listIndex = (i-1)*3+abilitySlot
		local abilityID = rematch.abilityList[listIndex]

		local _,icon = C_PetJournal.GetPetAbilityInfo(abilityID)
		button.abilityID = rematch.abilityList[listIndex]
		button.icon:SetTexture(icon)
		if level>=rematch.levelList[listIndex] then
			button.level:Hide()
			button.icon:SetVertexColor(1,1,1)
			button.icon:SetDesaturated(false)
			button.canUse = true
		else
			button.level:SetText(rematch.levelList[listIndex])
			button.level:Show()
			button.icon:SetVertexColor(.3,.3,.3)
			button.icon:SetDesaturated(true)
			button.canUse = nil
		end
	end
end

function rematch:CurrentOnSizeChanged()
	-- position current pets 1 and 3 roughly equidistant between pet 2 and edge
	local offset = min((self:GetWidth()/2+34)/2,110) -- don't allow offset to go above 110
	self.pets[1]:SetPoint("CENTER",self,"CENTER",-offset-14,6)
	self.pets[3]:SetPoint("CENTER",self,"CENTER",offset-14,6)
end
