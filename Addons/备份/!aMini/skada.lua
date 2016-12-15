	local Skada = Skada
	local barSpacing = 0.75
	local bars = 12
    local windowWidth = 240

	local AcceptFrame
	function Skada:ShowPopup()
		if not AcceptFrame then
			AcceptFrame = CreateFrame("Frame", "AcceptFrame", UIParent)
			S:SetBD(AcceptFrame)
			AcceptFrame:SetPoint("CENTER", UIParent, "CENTER")
			AcceptFrame:SetFrameStrata("DIALOG")
			AcceptFrame.Text = AcceptFrame:CreateFontString(nil, "OVERLAY")
			AcceptFrame.Text:SetFont("Fonts\\FRIZQT__.TTF", 14)
			AcceptFrame.Text:SetPoint("TOP", AcceptFrame, "TOP", 0, -10)
			AcceptFrame.Accept = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
			--S:Reskin(AcceptFrame.Accept)
			AcceptFrame.Accept:SetSize(70, 25)
			AcceptFrame.Accept:SetPoint("RIGHT", AcceptFrame, "BOTTOM", -10, 20)
			AcceptFrame.Accept:SetFormattedText("|cFFFFFFFF%s|r", YES)
			AcceptFrame.Close = CreateFrame("Button", nil, AcceptFrame, "OptionsButtonTemplate")
			--S:Reskin(AcceptFrame.Close)
			AcceptFrame.Close:SetSize(70, 25)
			AcceptFrame.Close:SetPoint("LEFT", AcceptFrame, "BOTTOM", 10, 20)
			AcceptFrame.Close:SetScript("OnClick", function(self) self:GetParent():Hide() end)
			AcceptFrame.Close:SetFormattedText("|cFFFFFFFF%s|r", NO)
		end
		AcceptFrame.Text:SetText(LibStub("AceLocale-3.0"):GetLocale("Skada", false)["Do you want to reset Skada?"])
		AcceptFrame:SetSize(AcceptFrame.Text:GetStringWidth() + 50, AcceptFrame.Text:GetStringHeight() + 60)
		AcceptFrame.Accept:SetScript("OnClick", function(self) Skada:Reset() self:GetParent():Hide() end)
		AcceptFrame:Show()
	end
	

	local function EmbedWindow(window, width, barheight, height, point, relativeFrame, relativePoint, ofsx, ofsy)
		window.db.barwidth = width
		window.db.barheight = barheight
		if window.db.enabletitle then
			height = height - barheight
		else
			height = height + barSpacing
		end
		window.db.background.height = height
		window.db.spark = false
		window.db.barslocked = true
		window.bargroup:ClearAllPoints()
		window.bargroup:SetPoint(point, relativeFrame, relativePoint, ofsx, ofsy)

		barmod.ApplySettings(barmod, window)
	end

	local windows = {}
	function EmbedSkada()
		if #windows == 1 then
			EmbedWindow(windows[1], windowWidth, 140/bars - barSpacing, 140, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30)
		elseif #windows == 2 then
			EmbedWindow(windows[1], windowWidth*3/4, 140/bars - barSpacing, 140, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -15, 30)
			EmbedWindow(windows[2], windowWidth*3/4, 140/bars - barSpacing, 140, "BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", - windowWidth*3/4 - 25, 30)
		end
	end

	-- Update pre-existing displays
	for _, window in ipairs(Skada:GetWindows()) do
		window:UpdateDisplay()
	end

	Skada.CreateWindow_ = Skada.CreateWindow
	function Skada:CreateWindow(name, db)
		Skada:CreateWindow_(name, db)

		windows = {}
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end

		EmbedSkada()
	end

	Skada.DeleteWindow_ = Skada.DeleteWindow
	function Skada:DeleteWindow(name)
		Skada:DeleteWindow_(name)

		windows = {}
		for _, window in ipairs(Skada:GetWindows()) do
			tinsert(windows, window)
		end

		EmbedSkada()
	end