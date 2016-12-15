local _, ns = ...
local CurEB = "ChatFrame1EditBox"


--[[
配置选项 
iconSize 表情大小你可以根据聊天字号调整
enableEmoteInput 允许输入表情
enableBubbleEmote 允许解析表情
]]

local Config = {
	iconSize = 18,
	enableEmoteInput = true,
	enableBubbleEmote = true,
}

-- 自定义表情开始的序号
local customEmoteStartIndex = 9

local emotes = {
	--原版暴雪提供的8个图标
	{"{rt1}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_1]=]},
	{"{rt2}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_2]=]},
	{"{rt3}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_3]=]},
	{"{rt4}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_4]=]},
	{"{rt5}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_5]=]},
	{"{rt6}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_6]=]},
	{"{rt7}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_7]=]},
	{"{rt8}",	[=[Interface\TargetingFrame\UI-RaidTargetingIcon_8]=]},
	
	--自定义表情
	{"{天使}",	[=[Interface\Addons\!aMini\icon\Angel]=]},
	{"{生气}",	[=[Interface\Addons\!aMini\icon\Angry]=]},
	{"{大笑}",	[=[Interface\Addons\!aMini\icon\Biglaugh]=]},
	{"{鼓掌}",	[=[Interface\Addons\!aMini\icon\Clap]=]},
	{"{酷}",	[=[Interface\Addons\!aMini\icon\Cool]=]},
	{"{哭}",	[=[Interface\Addons\!aMini\icon\Cry]=]},
	{"{可爱}",	[=[Interface\Addons\!aMini\icon\Cutie]=]},
	{"{鄙视}",	[=[Interface\Addons\!aMini\icon\Despise]=]},
	{"{美梦}",	[=[Interface\Addons\!aMini\icon\Dreamsmile]=]},
	{"{尴尬}",	[=[Interface\Addons\!aMini\icon\Embarrass]=]},
	{"{邪恶}",	[=[Interface\Addons\!aMini\icon\Evil]=]},
	{"{兴奋}",	[=[Interface\Addons\!aMini\icon\Excited]=]},

	{"{晕}",	[=[Interface\Addons\!aMini\icon\Faint]=]},
	{"{打架}",	[=[Interface\Addons\!aMini\icon\Fight]=]},
	{"{流感}",	[=[Interface\Addons\!aMini\icon\Flu]=]},
	{"{呆}",	[=[Interface\Addons\!aMini\icon\Freeze]=]},
	{"{皱眉}",	[=[Interface\Addons\!aMini\icon\Frown]=]},
	{"{致敬}",	[=[Interface\Addons\!aMini\icon\Greet]=]},
	{"{鬼脸}",	[=[Interface\Addons\!aMini\icon\Grimace]=]},
	{"{龇牙}",	[=[Interface\Addons\!aMini\icon\Growl]=]},
	{"{开心}",	[=[Interface\Addons\!aMini\icon\Happy]=]},
	{"{心}",	[=[Interface\Addons\!aMini\icon\Heart]=]},

	{"{恐惧}",	[=[Interface\Addons\!aMini\icon\Horror]=]},
	{"{生病}",	[=[Interface\Addons\!aMini\icon\Ill]=]},
	{"{无辜}",	[=[Interface\Addons\!aMini\icon\Innocent]=]},
	{"{功夫}",	[=[Interface\Addons\!aMini\icon\Kongfu]=]},
	{"{花痴}",	[=[Interface\Addons\!aMini\icon\Love]=]},
	{"{邮件}",	[=[Interface\Addons\!aMini\icon\Mail]=]},
	{"{化妆}",	[=[Interface\Addons\!aMini\icon\Makeup]=]},
	{"{马里奥}",	[=[Interface\Addons\!aMini\icon\Mario]=]},
	{"{沉思}",	[=[Interface\Addons\!aMini\icon\Meditate]=]},
	{"{可怜}",	[=[Interface\Addons\!aMini\icon\Miserable]=]},

	{"{好}",	[=[Interface\Addons\!aMini\icon\Okay]=]},
	{"{漂亮}",	[=[Interface\Addons\!aMini\icon\Pretty]=]},
	{"{吐}",	[=[Interface\Addons\!aMini\icon\Puke]=]},
	{"{握手}",	[=[Interface\Addons\!aMini\icon\Shake]=]},
	{"{喊}",	[=[Interface\Addons\!aMini\icon\Shout]=]},
	{"{闭嘴}",	[=[Interface\Addons\!aMini\icon\Shuuuu]=]},
	{"{害羞}",	[=[Interface\Addons\!aMini\icon\Shy]=]},
	{"{睡觉}",	[=[Interface\Addons\!aMini\icon\Sleep]=]},
	{"{微笑}",	[=[Interface\Addons\!aMini\icon\Smile]=]},
	{"{吃惊}",	[=[Interface\Addons\!aMini\icon\Suprise]=]},

	{"{失败}",	[=[Interface\Addons\!aMini\icon\Surrender]=]},
	{"{流汗}",	[=[Interface\Addons\!aMini\icon\Sweat]=]},
	{"{流泪}",	[=[Interface\Addons\!aMini\icon\Tear]=]},
	{"{悲剧}",	[=[Interface\Addons\!aMini\icon\Tears]=]},
	{"{想}",	[=[Interface\Addons\!aMini\icon\Think]=]},
	{"{偷笑}",	[=[Interface\Addons\!aMini\icon\Titter]=]},
	{"{猥琐}",	[=[Interface\Addons\!aMini\icon\Ugly]=]},
	{"{胜利}",	[=[Interface\Addons\!aMini\icon\Victory]=]},
	{"{雷锋}",	[=[Interface\Addons\!aMini\icon\Volunteer]=]},
	{"{委屈}",	[=[Interface\Addons\!aMini\icon\Wronged]=]},
}

local fmtstring = format("\124T%%s:%d\124t",max(floor(select(2,SELECTED_CHAT_FRAME:GetFont())),Config.iconSize))

local function myChatFilter(self, event, msg, ...)
	for i = customEmoteStartIndex, #emotes do
		if msg:find(emotes[i][1]) then
			msg = msg:gsub(emotes[i][1],format(fmtstring,emotes[i][2]),1)
			break
		end
	end
	return false, msg, ...
end

local ShowEmoteTableButton
local EmoteTableFrame

function EmoteIconMouseUp(frame, button)
	if (button == "LeftButton") then
		local ChatFrameEditBox = ChatEdit_ChooseBoxForSend()
		if (not ChatFrameEditBox:IsShown()) then
			ChatEdit_ActivateChat(ChatFrameEditBox)
		end
		ChatFrameEditBox:Insert(frame.text)
	end
	ToggleEmoteTable()
end

function CreateEmoteTableFrame()
	EmoteTableFrame = CreateFrame("Frame", "EmoteTableFrame", UIParent)

	EmoteTableFrame:SetBackdrop({
		bgFile = "Interface\\Buttons\\WHITE8x8", 
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", 
		tile = true, tileSize = 16, edgeSize = 16, 
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	})
	EmoteTableFrame:SetBackdropColor(0.05, 0.05, 0.05)
	EmoteTableFrame:SetBackdropBorderColor(0.3, 0.3, 0.3)
	EmoteTableFrame:SetWidth((Config.iconSize+2) * 12+10)
	EmoteTableFrame:SetHeight((Config.iconSize+2) * 5+10)
	EmoteTableFrame:SetPoint("BOTTOM", ChatFrame1EditBox, 30, 30) -- 表情选择框出现位置 默认30,30
	EmoteTableFrame:Hide()
	EmoteTableFrame:SetFrameStrata("DIALOG")

	local icon, row, col
	row = 1
	col = 1
	for i=1,#emotes do 
		text = emotes[i][1]
		texture = emotes[i][2]
		icon = CreateFrame("Frame", format("IconButton%d",i), EmoteTableFrame)
		icon:SetWidth(Config.iconSize)
		icon:SetHeight(Config.iconSize)
		icon.text = text
		icon.texture = icon:CreateTexture(nil,"ARTWORK")
		icon.texture:SetTexture(texture)
		icon.texture:SetAllPoints(icon)
		icon:Show()
		icon:SetPoint("TOPLEFT", 5+(col-1)*(Config.iconSize+2), -5-(row-1)*(Config.iconSize+2))
		icon:SetScript("OnMouseUp", EmoteIconMouseUp)
		icon:EnableMouse(true)
		col = col + 1 
		if (col>12) then
			row = row + 1
			col = 1
		end
	end
end

function ToggleEmoteTable()
	if (not EmoteTableFrame) then CreateEmoteTableFrame() end
	if (EmoteTableFrame:IsShown()) then
		EmoteTableFrame:Hide()
	else
		EmoteTableFrame:Show()
	end
end

local MaxBubbleWidth = 250

function HandleBubbleEmote(frame, fontstring)
	if not frame:IsShown() then 
		fontstring.cachedText = nil
		return 
	end

	MaxBubbleWidth = math.max(frame:GetWidth(), MaxBubbleWidth)

	local text = fontstring:GetText() or ""

	if text == fontstring.cachedText then return end

	frame:SetBackdropBorderColor(fontstring:GetTextColor())
	--fontstring:SetFont(ChatFrame1:GetFont(),select(2,ChatFrame1:GetFont()))
	local term;
	for tag in string.gmatch(text, "%b{}") do
		term = strlower(string.gsub(tag, "[{}]", ""));
		if ( ICON_TAG_LIST[term] and ICON_LIST[ICON_TAG_LIST[term]] ) then
			text = string.gsub(text, tag, ICON_LIST[ICON_TAG_LIST[term]] .. "0|t");
		end
	end  

	for i = customEmoteStartIndex, #emotes do
		if text:find(emotes[i][1]) then
			text = text:gsub(emotes[i][1],format(fmtstring,emotes[i][2]),1)
			break
		end
	end
	fontstring:SetText(text)    
	fontstring.cachedText = text  
	fontstring:SetWidth(math.min(fontstring:GetStringWidth(), MaxBubbleWidth - 14))
end

function CheckBubbles()
	for i=1,WorldFrame:GetNumChildren() do
		local v = select(i, WorldFrame:GetChildren())
		local b = v:GetBackdrop()
		if b and b.bgFile == "Interface\\Tooltips\\ChatBubble-Background" then
			for i=1,v:GetNumRegions() do
				local frame = v
				local v = select(i, v:GetRegions())
				if v:GetObjectType() == "FontString" then
					HandleBubbleEmote(frame, v)
				end
			end
		end
	end
end

ChatFrame_AddMessageEventFilter("CHAT_MSG_CHANNEL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_SAY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_YELL", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BN_WHISPER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_WHISPER_INFORM", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_RAID_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_PARTY_LEADER", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_GUILD", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_BATTLEGROUND", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_AFK", myChatFilter)
ChatFrame_AddMessageEventFilter("CHAT_MSG_DND", myChatFilter)

if (Config.enableEmoteInput) then
	CreateEmoteTableFrame()
end



if (Config.enableBubbleEmote) then
	local BubbleScanInterval = 0.15
	AddonFrame = CreateFrame("Frame")
	AddonFrame.interval = BubbleScanInterval
	AddonFrame:SetScript("OnUpdate", 
	function(frame, elapsed) 
		frame.interval = frame.interval - elapsed
		if frame.interval < 0 then
			frame.interval = BubbleScanInterval
			CheckBubbles()
		end
	end) 
end

