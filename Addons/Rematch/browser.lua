--[[ browser portion of the "PETS" drawer ]]


local _,L = ...
local rematch = Rematch
local browser = rematch.drawer.browser
local roster = rematch.roster
local settings

browser.typeMode = 1 -- 1=type, 2=strong, 3=tough

function rematch:InitBrowser()
	settings = RematchSettings

	-- position typebar buttons
	for i=1,10 do
		browser.typeBar.buttons[i]:SetPoint("CENTER",browser.typeBar,"CENTER",(i-1)*19+3-89,0)
		browser.typeBar.buttons[i].icon:SetTexture("Interface\\Icons\\Icon_PetFamily_"..PET_TYPE_SUFFIX[i])
	end

	local tabs = browser.typeBar.tabs
	tabs[2]:SetText(L["Strong vs"])
	tabs[3]:SetText(L["Tough vs"])
	-- color browser tabs (type=yellow, strong=green, tough=red)
	for k,v in pairs({{.5,.41,0},{0,.5,0},{.5,0,0}}) do
		for _,e in pairs({"left","middle","right"}) do
			tabs[k].selected[e]:SetVertexColor(unpack(v))
		end
	end
	-- anchor tab 2 to 1 and 3 to 2
	for i=2,3 do
		tabs[i]:SetPoint("BOTTOMLEFT",tabs[i-1],"BOTTOMRIGHT",-5,0)
	end

	browser.resultsBar.petsLabel:SetText(L["Pets:"])
	browser.resultsBar.ownedLabel:SetText(L["Owned:"])

	-- setup list scrollFrame
	local scrollFrame = browser.list.scrollFrame
	scrollFrame.update = rematch.UpdateBrowserList
	HybridScrollFrame_CreateButtons(scrollFrame, "RematchBrowserListButtonTemplate")
	for _,button in ipairs(scrollFrame.buttons) do
		button.leveling:SetPoint("CENTER",button,"RIGHT",rematch.breedSource and -32 or -12,-1)
	end

	browser.filter.icon:SetTexCoord(0.925,0.075,0.075,0.925) -- flip spyglass icon around


end

function rematch:BrowserFilterButtonOnClick()
	if rematch:IsMenuOpen("browserFilter") then
		rematch:HideDialogs()
	else
		rematch:ShowMenu("browserFilter","TOPLEFT",self,"TOPRIGHT",-6,8)
	end
end

--[[ Type Bar ]]

function rematch:ToggleTypeBar(value)
	rematch:EnableTypeBar(not settings.UseTypeBar)
end

function rematch:EnableTypeBar(enable)
	settings.UseTypeBar = enable
	rematch:UpdateBrowser()
end

-- click on the tabs in the typbar
function rematch:TypeBarTabOnClick()
	browser.typeMode = self:GetID()
	rematch:UpdateTypeBar()
end

-- click on the type buttons in the typebar
function rematch:TypeBarTypeButtonOnClick()
	roster:SetTypeFilter(browser.typeMode,self:GetID(),self:GetChecked())
end

-- click on clear button in the typebar
function rematch:TypeBarClearOnClick()
	if roster:IsTypeFilterClear(browser.typeMode) then -- if tab already clear, clear all tabs and move to type tab
		rematch:ClearAllTypeFilters()
	else -- otherwise clear just the current tab
		roster:ClearTypeFilter(browser.typeMode)
	end
end

function rematch:ClearAllTypeFilters()
	for i=1,3 do
		roster:ClearTypeFilter(i)
	end
	browser.typeMode = 1
end

function rematch:UpdateTypeBar()
	local typeBar = browser.typeBar
	if settings.UseTypeBar then
		-- update tabs
		for i=1,3 do
			typeBar.tabs[i].selected:SetShown(i==browser.typeMode)
			typeBar.tabs[i]:SetNormalFontObject(i==browser.typeMode and "GameFontHighlightSmall" or "GameFontNormalSmall")
			typeBar.tabs[i].hasStuff:SetShown(not roster:IsTypeFilterClear(i))
		end
		-- color border to match tab color
		if browser.typeMode==1 then
			typeBar:SetBackdropBorderColor(1,.82,0)
		elseif browser.typeMode==2 then
			typeBar:SetBackdropBorderColor(0,.75,0)
		elseif browser.typeMode==3 then
			typeBar:SetBackdropBorderColor(.75,0,0)
		end
		-- update type buttons
		local modeClear = roster:IsTypeFilterClear(browser.typeMode)
		for i=1,10 do
			local isChecked = roster:GetTypeFilter(browser.typeMode,i)
			if modeClear then
				typeBar.buttons[i].icon:SetDesaturated(false)
			else
				typeBar.buttons[i].icon:SetDesaturated(not isChecked)
			end
			if browser.typeMode>1 then
				typeBar.buttons[i]:SetChecked(isChecked)
			else
				typeBar.buttons[i]:SetChecked(not modeClear and isChecked)
			end
		end
		-- show clear button if any tab has stuff
		if not roster:IsTypeFilterClear() or not roster:IsTypeFilterClear(2) or not roster:IsTypeFilterClear(3) then
			typeBar.clear:Show()
		else
			typeBar.clear:Hide()
		end
		browser.list:SetPoint("TOPLEFT",browser,"TOPLEFT",2,-70)
		browser.typeBar:Show()
	else -- typeBar not used
		browser.list:SetPoint("TOPLEFT",browser,"TOPLEFT",2,-25)
		browser.typeBar:Hide()
	end
end

-- the typebar is anchored to stretch, this function adjusts the components within
function rematch:TypeBarResize()
	local typeBar = browser.typeBar
	local tabs = typeBar.tabs
	local width = typeBar:GetWidth()
	-- widen tabs to a % of typebar's width
	tabs[1]:SetWidth(width*0.27551)
	tabs[2]:SetWidth(width*0.33673)
	tabs[3]:SetWidth(width*0.33673)

	local adjust = width/10.3157895 -- (static is 19)
	local offset = width*0.06122449 -- offset from left
	for i=1,10 do
		typeBar.buttons[i]:SetPoint("CENTER",typeBar,"LEFT",(i-1)*adjust+offset,0)
	end

end

--[[ Search Box ]]

function rematch:SearchBoxOnTextChanged()
	roster:SetSearch(self:GetText())
end

--[[ Results Bar ]]

function rematch:UpdateBrowserResults()
	local bar = browser.resultsBar
	local numPets = roster:GetNumPets()
	bar.petCount:SetText(numPets)
	local filters = roster:GetFilterResults()
	bar.ownedLabel:SetShown(not filters)
	bar.ownedCount:SetShown(not filters)
	bar.filters:SetShown(filters and true)
	bar.clear:SetShown(filters and true)

	if filters then
		bar.filters:SetText(filters)
	else
		bar.ownedCount:SetText((select(2,C_PetJournal.GetNumPets())))
	end
end

--[[ Browser ]]

function rematch:UpdateBrowser()
	if browser:IsVisible() then
		-- clear default search filter if any set
		if rematch.defaultSearchFilter and rematch.defaultSearchFilter~="" then
			C_PetJournal.ClearSearchFilter()
			if PetJournalSearchBox then
				PetJournalSearchBox:SetText("")
				PetJournalSearchBox:ClearFocus()
			end
		end
		roster:Update()
		rematch:UpdateTypeBar()
		rematch:UpdateBrowserList()
		rematch:UpdateBrowserResults()
	end
end

-- this updates the HybridScrollFrame with roster's pets, the big list of pets
function rematch:UpdateBrowserList()
	local numData = roster:GetNumPets()
	local scrollFrame = browser.list.scrollFrame
	local offset = HybridScrollFrame_GetOffset(scrollFrame)
	local buttons = scrollFrame.buttons

	rematch:ListResizeButtons(scrollFrame)
	scrollFrame.stepSize = floor(scrollFrame:GetHeight()*.65)

	for i=1, min(#buttons,scrollFrame:GetHeight()/scrollFrame.buttonHeight+2) do
		local index = i + offset
		local button = buttons[i]
		button.index = index
		if ( index <= numData ) then
			button:SetID(index)
			button.favorite:Hide()
			button.dead:Hide()
			local petID = roster:GetPetByIndex(index)
			button.petID = petID
			if type(petID)=="string" then -- an owned petID
				local speciesID,customName,level,_,_,_,favorite,speciesName,icon,petType = C_PetJournal.GetPetInfoByPetID(petID)
				button.name:SetText(not settings.ListRealNames and customName or speciesName)
				button.icon:SetTexture(icon)
				button.level:SetText(level)
				button.type:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
				if favorite then
					button.favorite:Show()
				end
				local health,maxHealth,_,_,rarity = C_PetJournal.GetPetStats(petID)
		    local r,g,b = ITEM_QUALITY_COLORS[rarity-1].r, ITEM_QUALITY_COLORS[rarity-1].g, ITEM_QUALITY_COLORS[rarity-1].b
		    button.rarity:SetGradientAlpha("VERTICAL",r,g,b,1,r,g,b,0)
		    button.rarity:Show()
				if health<1 and maxHealth>0 then
					button.dead:Show()
				end
				-- color unsummonable/revoked pets and half-alpha their buttons
				if (health>0 and not C_PetJournal.PetIsSummonable(petID)) or C_PetJournal.PetIsRevoked(petID) then
					button.icon:SetDesaturated(true)
					button.icon:SetVertexColor(1,0,0)
				else
					button.icon:SetDesaturated(false)
					button.icon:SetVertexColor(1,1,1)
				end
		    button.type:SetDesaturated(false)
		    button.name:SetTextColor(1,.82,.2)
				local isLeveling = rematch:IsPetLeveling(petID)
				button.leveling:SetShown(isLeveling)
				if rematch.breedSource then
					button.breed:SetText(rematch:GetBreed(petID))
					button.name:SetPoint("BOTTOMRIGHT",isLeveling and -42 or -24,2)
				else
					button.breed:SetText("")
					button.name:SetPoint("BOTTOMRIGHT",isLeveling and -22 or -8,2)
				end
			elseif type(petID)=="number" then -- an unowned species
				local name,icon,petType = C_PetJournal.GetPetInfoBySpeciesID(petID)
				button.name:SetText(name)
				button.icon:SetTexture(icon)
				button.level:SetText("")
				button.type:SetTexture("Interface\\PetBattles\\PetIcon-"..PET_TYPE_SUFFIX[petType])
				button.favorite:Hide()
				button.leveling:Hide()
		    button.rarity:Hide()
		    button.icon:SetDesaturated(true)
		    button.type:SetDesaturated(true)
				button.icon:SetVertexColor(1,1,1)
		    button.name:SetTextColor(.8,.8,.8)
				button.breed:SetText("")
				button.name:SetPoint("BOTTOMRIGHT",-8,2)
			end
			button:Show()
		else
			button:Hide()
		end

	end
	HybridScrollFrame_Update(scrollFrame, 28*numData, 28)
end

function rematch:ResetAllBrowserFilters()
	roster:ClearAllFilters()
	rematch:RefreshAllMenus()
	rematch:ClearSearchBox(browser.searchBox)
	rematch:ScrollFrameToTop(browser.list.scrollFrame)
end

function rematch:BrowserResultsOnEnter()
	local total, owned = C_PetJournal.GetNumPets()
	local scratch = rematch.info
	local unique = 0
	local maxLevel = 0
	wipe(scratch) -- this generates a rather lot of garbage; but going back through table takes a loooooong time
	for i=1,#rematch.ownedPets do
		local speciesID,_,level = C_PetJournal.GetPetInfoByPetID(rematch.ownedPets[i])
		if not tContains(scratch,speciesID) then
			unique = unique + 1
			tinsert(scratch,speciesID)
		end
		if level==25 then
			maxLevel = maxLevel + 1
		end
	end
	rematch.ShowTooltip(self,L["Your pets:"],format(L["Owned: \124cffffffff%d\124r\nMissing: \124cffffffff%d\124r\nUnique: \124cffffffff%d\124r\nLevel 25: \124cffffffff%d"],owned,total-owned,unique,maxLevel))
	wipe(scratch)
end
