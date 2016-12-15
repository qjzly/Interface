-- daftUIFade by tonyis3l33t

local F, C, L = unpack(select(2, ...))

if not C.appearance.uiFader then return end

local addonName, addonTable = ... ;

addonTable.TIMETOFADEIN = 1.0;
addonTable.FADEIN = 1;

addonTable.TIMETOFADEOUT = 3.0;
addonTable.FADEOUT = 0.25;

local addon = CreateFrame("Frame");

addon:SetScript("OnUpdate", function()

	if UnitAffectingCombat("Player")
	or InCombatLockdown() then
		UIParent:SetAlpha(addonTable.FADEIN); -- UIFrameFadeIn causes access violation in combat
		return;
	end;

	if ChatFrame1EditBox:IsShown()
	or WorldMapFrame:IsShown()
	or MailFrame:IsShown()
	or GossipFrame:IsShown()
	or GameMenuFrame:IsShown()
	or StaticPopup1:IsShown()
	--or TalkingHeadFrame:IsShown()
	--or GarrisonMissionAlertFrame:IsShown()
	--or WorldQuestCompleteAlertFrame:IsShown()
	or LFGDungeonReadyPopup:IsShown()
	or LFDRoleCheckPopup:IsShown()
	or LevelUpDisplay:IsShown()
	or RolePollPopup:IsShown()
	or ReadyCheckFrame:IsShown()
	or BonusRollFrame:IsShown()
	or QuestLogPopupDetailFrame:IsShown()
	or GameTooltipTextLeft1:GetText()
	or UnitCastingInfo("Player")
	or UnitChannelInfo("Player")
	or UnitExists("Target")
	or MouseIsOver(ChatFrame1)
	or MouseIsOver(ChatFrame2)
	or MouseIsOver(ChatFrame3)
	or MouseIsOver(ChatFrame4) then
		UIFrameFadeIn(UIParent, addonTable.TIMETOFADEIN, UIParent:GetAlpha(), addonTable.FADEIN);
		return;
	end;

	if GetMouseFocus() then

		if GetMouseFocus():GetName() ~= "WorldFrame" then
			UIFrameFadeIn(UIParent, addonTable.TIMETOFADEIN, UIParent:GetAlpha(), addonTable.FADEIN);
		else
			UIFrameFadeOut(UIParent, addonTable.TIMETOFADEOUT, UIParent:GetAlpha(), addonTable.FADEOUT);
		end;
	end;
end);
