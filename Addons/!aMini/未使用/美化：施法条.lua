----------------------------------------------------------------------------------------
--  PORTRAIT
----------------------------------------------------------------------------------------



CastingBarFrame.Text:SetFont(STANDARD_TEXT_FONT, 13, "THINOUTLINE") 
CastingBarFrame.Text:ClearAllPoints()
CastingBarFrame.Text:SetPoint("CENTER", CastingBarFrame, 0, 1)

TargetFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE") 
TargetFrameSpellBar.Text:ClearAllPoints()
TargetFrameSpellBar.Text:SetPoint("CENTER", TargetFrameSpellBar, 0, 2) 
TargetFrameSpellBar.Icon:Show() 
TargetFrameSpellBar.Icon:SetHeight(15) 
TargetFrameSpellBar.Icon:SetWidth(15) 
TargetFrameSpellBar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
TargetFrameSpellBar.Icon:SetPoint("LEFT", TargetFrameSpellBar, -20, 0) 

FocusFrameSpellBar.Text:SetFont(STANDARD_TEXT_FONT, 11, "THINOUTLINE") 
FocusFrameSpellBar.Text:ClearAllPoints()
FocusFrameSpellBar.Text:SetPoint("CENTER", FocusFrameSpellBar, 0, 2) 
FocusFrameSpellBar.Icon:SetHeight(15) 
FocusFrameSpellBar.Icon:SetWidth(15) 
FocusFrameSpellBar.Icon:SetTexCoord(0.1,0.9,0.1,0.9)
FocusFrameSpellBar.Icon:SetPoint("LEFT", FocusFrameSpellBar, -20, 0) 