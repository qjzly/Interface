----------------------------------------------------------------------------------------
---------------- >显示颜色
ToggleChatColorNamesByClassGroup(true, "SAY")
ToggleChatColorNamesByClassGroup(true, "EMOTE")
ToggleChatColorNamesByClassGroup(true, "YELL")
ToggleChatColorNamesByClassGroup(true, "GUILD")
ToggleChatColorNamesByClassGroup(true, "GUILD_OFFICER")
ToggleChatColorNamesByClassGroup(true, "OFFICER")
ToggleChatColorNamesByClassGroup(true, "GUILD_ACHIEVEMENT")
ToggleChatColorNamesByClassGroup(true, "ACHIEVEMENT")
ToggleChatColorNamesByClassGroup(true, "WHISPER")
ToggleChatColorNamesByClassGroup(true, "PARTY")
ToggleChatColorNamesByClassGroup(true, "PARTY_LEADER")
ToggleChatColorNamesByClassGroup(true, "RAID")
ToggleChatColorNamesByClassGroup(true, "RAID_LEADER")
ToggleChatColorNamesByClassGroup(true, "RAID_WARNING")
ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND")
ToggleChatColorNamesByClassGroup(true, "BATTLEGROUND_LEADER")   
ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT")
ToggleChatColorNamesByClassGroup(true, "INSTANCE_CHAT_LEADER")
ToggleChatColorNamesByClassGroup(true, "CHANNEL1")
ToggleChatColorNamesByClassGroup(true, "CHANNEL2")
ToggleChatColorNamesByClassGroup(true, "CHANNEL3")
ToggleChatColorNamesByClassGroup(true, "CHANNEL4")
ToggleChatColorNamesByClassGroup(true, "CHANNEL5")
ToggleChatColorNamesByClassGroup(true, "CHANNEL6")
ToggleChatColorNamesByClassGroup(true, "CHANNEL7")
   
   --每一个button的長、寬，空隙，綜合/交易/本地防務/組隊 頻道的顏色
local buttontex = "Interface\\AddOns\\m_chat\\textures\\bartexture"
local buttonwidth, buttonheight, buttonspacing = 25, 12, 2.5
local c1r, c1g, c1b = 255/255, 192/255 ,192/255  --綜合
local c2r, c2g, c2b = 255/255, 130/255, 130/255  --交易
local c3r, c3g, c3b = 255/255, 255/255, 150/255  --防務
local c4r, c4g, c4b = 200/255, 200/255, 200/255  --灰


local chat = CreateFrame("Frame","chat",UIParent)
chat:RegisterEvent("PLAYER_ENTERING_WORLD")
chat:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_ENTERING_WORLD" then
	    ChangeChatColor("CHANNEL1", c1r, c1g, c1b)
		ChangeChatColor("CHANNEL2", c2r, c2g, c2b)
		ChangeChatColor("CHANNEL3", c3r, c3g, c3b)
		ChangeChatColor("CHANNEL4", c4r, c4g, c4b)
		ChangeChatColor("CHANNEL5", c4r, c4g, c4b)
		ChangeChatColor("CHANNEL6", c4r, c4g, c4b)
		ChangeChatColor("CHANNEL7", c4r, c4g, c4b)
	end
end)

-------------------------------------
-- 聊天信息複製
-- Author:M
-------------------------------------

--注意規則順序, button(LeftButton/RightButton)可以指定鼠標左右鍵使用不同的邏輯
local rules = {
--!!这两条不要更改
{ pat = "|c%x+|HChatCopy|h.-|h|r", repl = "" }, --去掉本插件定義的鏈接
{ pat = "|c%x%x%x%x%x%x%x%x(.-)|r", repl = "%1" }, --替換所有顔色值
--以下為左鍵特有
{ pat = "|Hchannel:.-|h.-|h", repl = "", button = "LeftButton" }, --(L)去掉頻道文字
{ pat = "|Hplayer:.-|h.-|h" .. ":", repl = "", button = "LeftButton" }, --(L)去掉發言玩家名字
{ pat = "|Hplayer:.-|h.-|h" .. "：", repl = "", button = "LeftButton" }, --(L)去掉發言玩家名字
{ pat = "|HBNplayer:.-|h.-|h" .. ":", repl = "", button = "LeftButton" }, --(L)去掉戰網發言玩家名字
{ pat = "|HBNplayer:.-|h.-|h" .. "：", repl = "", button = "LeftButton" }, --(L)去掉戰網發言玩家名字
--以下為右鍵特有
{ pat = "|Hchannel:.-|h(.-)|h", repl = "%1", button = "RightButton" }, --(R)留下頻道文字
{ pat = "|Hplayer:.-|h(.-)|h", repl = "%1", button = "RightButton" }, --(R)留下發言玩家名字
{ pat = "|HBNplayer:.-|h(.-)|h", repl = "%1", button = "RightButton" }, --(R)留下戰網發言玩家名字
--!!这三條不要更改
{ pat = "|H.-|h(.-)|h", repl = "%1" }, --替換所有超連接
{ pat = "|TInterface\\TargetingFrame\\UI%-RaidTargetingIcon_(%d):0|t", repl = "{rt%1}" },
{ pat = "|T.-|t", repl = "" }, --替換所有素材
{ pat = "^%s+", repl = "" }, --去掉空格
}

--替換字符
local function clearMessage(msg, button)
for _, rule in ipairs(rules) do
if (not rule.button or rule.button == button) then
msg = msg:gsub(rule.pat, rule.repl)
end
end
return msg
end

--顯示信息
local function showMessage(msg, button)
local editBox = ChatEdit_ChooseBoxForSend()
msg = clearMessage(msg, button)
ChatEdit_ActivateChat(editBox)
editBox:SetText(editBox:GetText() .. msg)
editBox:HighlightText()
end

--獲取複製的信息
local function getMessage(...)
local object
for i = 1, select("#", ...) do
object = select(i, ...)
if (object:IsObjectType("FontString") and MouseIsOver(object)) then
return object:GetText()
end
end
return ""
end

--HACK
local _SetItemRef = SetItemRef

SetItemRef = function(link, text, button, chatFrame)
if (link:sub(1,8) == "ChatCopy") then
local msg = getMessage(chatFrame.FontStringContainer:GetRegions())
return showMessage(msg, button)
end
_SetItemRef(link, text, button, chatFrame)
end

--HACK
local function AddMessage(self, text, ...)
if (type(text) ~= "string") then
text = tostring(text)
end
text = format("|cff68ccef|HChatCopy|h%s|h|r %s", " *", text)
self.OrigAddMessage(self, text, ...)
end

local chatFrame

for i = 1, NUM_CHAT_WINDOWS do
chatFrame = _G["ChatFrame" .. i]
if (chatFrame) then
chatFrame.OrigAddMessage = chatFrame.AddMessage
chatFrame.AddMessage = AddMessage
end
end



-------------------------------------
-- 循环列表变量 不想要的直接剃掉就完了

function ChatEdit_CustomTabPressed(...)
    ChatEdit_CustomTabPressed_Inner(...);
end
local cycles = {
	-- "说"
    {
        chatType = "SAY",
        use = function(self, editbox) return 1 end,
    },

	-- "小队"只有你处于小队时才会有效
    {
        chatType = "PARTY",
        use = function(self, editbox) return IsInGroup() end,
    },
	-- "团队"只有你处于团队时才会有效
    {
        chatType = "RAID",
        use = function(self, editbox) return IsInRaid() end,
    },
    {
        chatType = "INSTANCE_CHAT",  --副本
        use = function(self, editbox) return select(2, IsInInstance()) == 'pvp' end,
    },
    {
        chatType = "GUILD",   --工会
        use = function(self, editbox) return IsInGuild() end,
    },
	-- 频道遍历 默认tab切换会跳过本地防务 如果你想限制只使用世界频道的话 可以参考判断语句后的注释进行修改
    {
        chatType = "CHANNEL",
        use = function(self, editbox, currChatType)
                if currChatType~="CHANNEL" then
                    currNum = IsShiftKeyDown() and 21 or 0
                else
                    currNum = editbox:GetAttribute("channelTarget");
                end
                local h, r, step = currNum+1, 20, 1
                if IsShiftKeyDown() then 
					h, r, step = currNum-1, 1, -1 
				end
                for i=h,r,step do
                    local channelNum, channelName = GetChannelName(i);
                    if channelNum > 0 and not channelName:find("本地防务 %-")  and not channelName:find("综合 %-")  and not channelName:find("交易 %-")  and not channelName:find("寻求组队")  and not channelName:find("集合石 %-") then 
					-- 默认毙掉所有官方的公共频道，你可以去掉不想毙掉的频道
                        editbox:SetAttribute("channelTarget", i);
                        return true;
                    end
                end
        end,
    },
	-- 循环到"说"
    {
        chatType = "SAY",
        use = function(self, editbox) return 1 end,
    },
}
function ChatEdit_CustomTabPressed_Inner(self)
	if strsub(tostring(self:GetText()), 1, 1) == "/" then return end
    local currChatType = self:GetAttribute("chatType")
    --对于说然后SHIFT的情况，因为没有return，所以第一层循环会一直遍历到最后的SAY
    for i, curr in ipairs(cycles) do
        if curr.chatType== currChatType then
            local h, r, step = i+1, #cycles, 1
            if IsShiftKeyDown() then h, r, step = i-1, 1, -1 end
            if currChatType=="CHANNEL" then h = i end --频道仍然要测试一下
            for j=h, r, step do
                if cycles[j]:use(self, currChatType) then
                    self:SetAttribute("chatType", cycles[j].chatType);
                    ChatEdit_UpdateHeader(self);
                    return;
                end
            end
        end
    end
end
