--[[	TrainAll
	by SDPhantom
	http://www.phantomweb.org	]]
------------------------------------------

local btn=CreateFrame("Button","ClassTrainerTrainAllButton",ClassTrainerFrame,"MagicButtonTemplate");
btn:SetPoint("TOPRIGHT",ClassTrainerTrainButton,"TOPLEFT");
btn:SetText("Train All");

function btn:UpdateTooltip()
	GameTooltip:ClearLines();
	GameTooltip:AddLine("Click to train all available skills.");
	GameTooltip:AddLine(("%d skills available for %s"):format(self.Count,GetCoinTextureString(self.Cost)));
end

btn:SetScript("OnEnter",function(self)
	GameTooltip:SetOwner(self,"ANCHOR_BOTTOMLEFT");
	self:UpdateTooltip();
	GameTooltip:Show();
end);

btn:SetScript("OnLeave",function(self) if GameTooltip:IsOwned(self) then GameTooltip:Hide(); end end);

btn:SetScript("OnClick",function(self)
	for i=1,GetNumTrainerServices() do
		if select(3,GetTrainerServiceInfo(i))=="available" then BuyTrainerService(i); end
	end
end);

hooksecurefunc("ClassTrainerFrame_Update",function()
	local sum,total=0,0;
	for i=1,GetNumTrainerServices() do
		if select(3,GetTrainerServiceInfo(i))=="available" then
			sum,total=sum+1,total+GetTrainerServiceCost(i);
		end
	end
	btn:SetEnabled(sum>0);
	btn.Count,btn.Cost=sum,total;
end);
