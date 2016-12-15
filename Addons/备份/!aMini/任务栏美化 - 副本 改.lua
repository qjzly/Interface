    local ot = ObjectiveTrackerFrame
    local BlocksFrame = ot.BlocksFrame

    -- [[ Header ]]

    -- Header

    ot.HeaderMenu.Title:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")

-- local function CreateShadow(f, t, thickness)
	-- if f.shadow then return end

	-- local borderr, borderg, borderb = 0, 0, 0
    -- local backdropr, backdropg, backdropb, backdropa =  .1, .1, .1
	-- local frameLevel = f:GetFrameLevel() > 1 and f:GetFrameLevel() - 1 or 1
	-- local thickness = 4
	-- local offset = 4--thickness - 1

    -- if t == "Background" then
        -- backdropr, backdropg, backdropb, backdropa = .04, .04, .04, .7
    -- else
        -- backdropa = 0
    -- end

	-- local border = CreateFrame("Frame", nil, f)
	-- border:SetFrameLevel(frameLevel)
	-- border:SetOutside(f, 1, 1)
    -- border:SetTemplate("Border")
	-- f.border = f.border or border

	-- local shadow = CreateFrame("Frame", nil, border)
	-- shadow:SetFrameLevel(frameLevel - 1)
	-- shadow:SetOutside(border, offset, offset)
	-- shadow:SetBackdrop( {
		-- edgeFile = nil,
        -- bgFile = [[Interface\ChatFrame\ChatFrameBackground.blp]],
		-- edgeSize = 5,
        -- tile = false,
        -- tileSize = 0,
		-- insets = { left = 4, right = 4, top = 4, bottom = 4 },
	-- })
	-- shadow:SetBackdropColor(.05,.05,.05, .6)
	-- shadow:SetBackdropBorderColor(0, 0, 0, 1)
	-- f:SetFrameLevel(frameLevel + 1)
	-- f.shadow = shadow
-- end

-- local function CreateBD(f, a)
	-- assert(f, "doesn't exist!")
	-- f:SetBackdrop({
		-- bgFile = [[Interface\ChatFrame\ChatFrameBackground.blp]],
		-- edgeFile = [[Interface\AddOns\!aMini\Media\glowTex.tga]],
		-- edgeSize = 5,
	-- })
	-- f:SetBackdropColor(.05,.05,.05, .6)
	-- f:SetBackdropBorderColor(0, 0, 0, 1)
-- end

-- local function CreateBG(frame)
	-- assert(frame, "doesn't exist!")
	-- local f = frame
	-- if frame:GetObjectType() == "Texture" then f = frame:GetParent() end

	-- local bg = f:CreateTexture(nil, "BACKGROUND")
	-- bg:Point("TOPLEFT", frame, -1, 1)
	-- bg:Point("BOTTOMRIGHT", frame, 1, -1)
	-- bg:SetTexture([[Interface\AddOns\!aMini\Media\glowTex.tga]])
	-- bg:SetVertexColor(0, 0, 0)

	-- return bg
-- end

-- local function ReskinIcon(icon)
	-- assert(icon, "doesn't exist!")
	-- icon:SetTexCoord(.08, .92, .08, .92)
	-- icon.bg = CreateBD(icon)
-- end

-- local function CreateBDFrame(f, a)
	-- local frame
	-- if f:GetObjectType() == "Texture" then
		-- frame = f:GetParent()
	-- else
		-- frame = f
	-- end

	-- local lvl = frame:GetFrameLevel()

	-- local bg = CreateFrame("Frame", nil, frame)
	-- bg:Point("TOPLEFT", f, -1, 1)
	-- bg:Point("BOTTOMRIGHT", f, 1, -1)
	-- bg:SetFrameLevel(lvl == 0 and 1 or lvl - 1)
	-- CreateBD(bg, a or alpha)
	-- return bg
-- end


local function StripTextures(object, kill)
	for i=1, object:GetNumRegions() do
		local region = select(i, object:GetRegions())
		if region:GetObjectType() == "Texture" then
			if kill then
				region:Kill()
			else
				region:SetTexture(nil)
			end
		end
	end
end
	
    -- [[ Blocks and lines ]]

    for _, headerName in pairs({"QuestHeader", "AchievementHeader", "ScenarioHeader"}) do
        local header = BlocksFrame[headerName]

        header:StripTextures()
        header.Text:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
    end

    BONUS_OBJECTIVE_TRACKER_MODULE.Header:StripTextures()

    hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "SetBlockHeader", function(_, block)
            if not block.headerStyled then
                block.HeaderText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
                block.headerStyled = true
            end
        end)

    hooksecurefunc(QUEST_TRACKER_MODULE, "SetBlockHeader", function(_, block)
            if not block.headerStyled then
                block.HeaderText:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")--标题
                block.headerStyled = true
            end

            local itemButton = block.itemButton

            -- if itemButton and not itemButton.styled then
                -- itemButton:SetNormalTexture(nil)
                -- itemButton:StyleButton(true)
                -- itemButton:CreateShadow("Background")

                -- itemButton.HotKey:ClearAllPoints()
                -- itemButton.HotKey:SetPoint("TOP", itemButton, -1, 0)
                -- itemButton.HotKey:SetJustifyH("CENTER")
                -- itemButton.HotKey:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")

                -- itemButton.icon:SetTexCoord(.08, .92, .08, .92)
                -- CreateBG(itemButton)

                -- itemButton.styled = true
            -- end
        end)

    hooksecurefunc(DEFAULT_OBJECTIVE_TRACKER_MODULE, "AddObjective", function(self, block)
            if block.module == QUEST_TRACKER_MODULE or block.module == ACHIEVEMENT_TRACKER_MODULE then
                local line = block.currentLine

                local p1, a, p2, x, y = line:GetPoint()
                line:SetPoint(p1, a, p2, x, y - 4)
            end
        end)

    local function fixBlockHeight(block)
        if block.shouldFix then
            local height = block:GetHeight()

            if block.lines then
                for _, line in pairs(block.lines) do
                    if line:IsShown() then
                        height = height + 4
                    end
                end
            end

            block.shouldFix = false
            block:SetHeight(height + 5)
            block.shouldFix = true
        end
    end

    hooksecurefunc("ObjectiveTracker_AddBlock", function(block)
            if block.lines then
                for _, line in pairs(block.lines) do
                    if not line.styled then
                        line.Text:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
                        line.Text:SetSpacing(2)

                        if line.Dash then
                            line.Dash:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")
                        end

                        line:SetHeight(line.Text:GetHeight())

                        line.styled = true
                    end
                end
            end

            if not block.styled then
                block.shouldFix = true
                hooksecurefunc(block, "SetHeight", fixBlockHeight)
                block.styled = true
            end
        end)

    -- [[ Bonus objective progress bar ]]

    -- hooksecurefunc(BONUS_OBJECTIVE_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
            -- local progressBar = line.ProgressBar

            -- if not progressBar.styled then
                -- local bar = progressBar.Bar
                -- local label = bar.Label
                -- local icon = bar.Icon

                -- bar.BarFrame:Hide()
                -- bar.BarBG:Hide()
                -- bar.IconBG:Hide()

                -- if icon:IsShown() then
                    -- icon:SetMask(nil)
                    -- icon:SetDrawLayer("BORDER")
                    -- icon:ClearAllPoints()
                    -- icon:SetPoint("RIGHT", 35, 2)
                    -- ReskinIcon(icon)
                -- end

                -- bar:SetStatusBarTexture([[Interface\AddOns\!aMini\Media\gloss.tga]])

                -- label:ClearAllPoints()
                -- label:SetPoint("CENTER", 0, -1)
                -- label:SetFont(nil, nil, "OUTLINE")

                -- local bg = CreateShadowFrame(bar)
                -- bg:SetOutside(bar, 1, 1)

                -- progressBar.styled = true
            -- end

        -- end)

    WORLD_QUEST_TRACKER_MODULE.Header:StripTextures()
    WORLD_QUEST_TRACKER_MODULE.Header.Text:SetFont("Fonts\\FRIZQT__.TTF", 16, "OUTLINE")
    local bg = WORLD_QUEST_TRACKER_MODULE.Header:CreateTexture(nil, "ARTWORK")
    bg:SetTexture([[Interface\LFGFrame\UI-LFG-SEPARATOR]])
    bg:SetTexCoord(0, 0.6640625, 0, 0.3125)
    bg:SetVertexColor(.05,.05,.05, .6)--(255 * 0.7, 255 * 0.7, 255 * 0.7)
    bg:SetPoint("BOTTOMLEFT", -30, -4)
    bg:SetSize(210, 30)

    -- hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddObjective", function(_, block)
            -- local itemButton = block.itemButton
            -- if itemButton and not itemButton.styled then
                -- itemButton:SetNormalTexture(nil)
                -- itemButton:StyleButton(true)
                -- itemButton:CreateShadow("Background")

                -- itemButton.HotKey:ClearAllPoints()
                -- itemButton.HotKey:SetPoint("TOP", itemButton, -1, 0)
                -- itemButton.HotKey:SetJustifyH("CENTER")
                -- itemButton.HotKey:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

                -- itemButton.icon:SetTexCoord(.08, .92, .08, .92)
                -- CreateBG(itemButton)

                -- itemButton.styled = true
            -- end
        -- end)

    -- hooksecurefunc(WORLD_QUEST_TRACKER_MODULE, "AddProgressBar", function(self, block, line)
            -- local progressBar = line.ProgressBar
            -- local bar = progressBar.Bar
            -- local icon = bar.Icon
            -- if not progressBar.styled then
                -- local label = bar.Label

                -- bar.BarBG:Hide()
				-- bar.BarFrame:Hide()

                -- icon:SetMask(nil)
                -- icon:SetDrawLayer("BORDER")
                -- icon:ClearAllPoints()
                -- icon:SetPoint("RIGHT", 35, 2)
				-- ReskinIcon(icon)

                -- bar:SetStatusBarTexture([[Interface\AddOns\!aMini\Media\gloss.tga]])

                -- label:ClearAllPoints()
                -- label:SetPoint("CENTER")
                -- label:SetFont("Fonts\\FRIZQT__.TTF", 14, "OUTLINE")

                -- local bg = CreateBDFrame(bar)
                -- bg:SetOutside(bar, 1, 1)

                -- progressBar.styled = true
            -- end

            -- bar.IconBG:Hide()

        -- end)
