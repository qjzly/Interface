----------------------------------------------------------------------------------------
--  NamePlate
----------------------------------------------------------------------------------------
  
--  百分比

CreateFrame('frame'):SetScript('OnUpdate', function(self, elapsed) 
  for index = 1, select('#', WorldFrame:GetChildren()) do 
        local f = select(index, WorldFrame:GetChildren()) 
        if f:GetName() and f:GetName():find('NamePlate%d') then 
          f.h = select(1, select(1, f:GetChildren()):GetChildren()) 
          if f.h then 
         if not f.h.v then 
           f.h.v = f.h:CreateFontString(nil, "ARTWORK")   
           f.h.v:SetPoint("RIGHT", 28, 0.5) ----f.h.v:SetPoint("RIGHT", 0, 1) 
           f.h.v:SetFont(STANDARD_TEXT_FONT, 9, 'OUTLINE') 
         else 
           local _, maxh = f.h:GetMinMaxValues() 
           local val = f.h:GetValue() 
           f.h.v:SetText(string.format(math.floor((val/maxh)*100)).." %") 
         end 
          end 
        end 
  end 
end)