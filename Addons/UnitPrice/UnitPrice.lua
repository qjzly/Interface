UnitPriceShowBid = true;
UnitPriceShowBuyout = true;

local coin = [[|cffffffff%%d|r|TInterface\AddOns\UnitPrice\Textures\%s:0:0:1|t]];
local G = coin:format("Gold");
local S = coin:format("Silver");
local C = coin:format("Copper");
local GSC = G.." "..S.." "..C;
local GS = G.." "..S;
local GC = G.." "..C;
local SC = S.." "..C;

local function moneyFormat(amount)
    if (not amount) then
        return "";
    end

    if (amount <= 0) then
        return string.format(C, 0);
    end

    if (amount < 100) then
        return string.format(C, amount);
    end

    if (amount < 10000) then
        local copper = amount % 100;
        if (copper > 0) then
            return string.format(SC, (amount - copper) / 100, copper);
        else
            return string.format(S, amount / 100);
        end
    else
        local copper = amount % 100;
        if (copper > 0) then
            local tmp = (amount - copper) / 100;
            local silver = tmp % 100;
            if (silver > 0) then
                return string.format(GSC, (tmp - silver) / 100, silver, copper);
            else
                return string.format(GC, tmp / 100, copper);
            end
        else
            local tmp = amount / 100;
            local silver = tmp % 100;
            if (silver > 0) then
                return string.format(GS, (tmp - silver) / 100, silver);
            else
                return string.format(G, tmp / 100);
            end
        end
    end
end

local function truncateItemName(item)
    local itemName = item:GetText();
    local itemWidth = item:GetWidth();
    local stringWidth = item:GetStringWidth();
    if (itemName and stringWidth > itemWidth) then
        local stringLength = strlen(itemName);
        stringLength = floor(stringLength * itemWidth / stringWidth) - 3;
        item:SetText(strsub(itemName, 1, stringLength) .. "...");
    end
end

local AuctionFrameBrowse_Update_Old = AuctionFrameBrowse_Update;

local function AuctionFrameBrowse_Update_Hooked()
    AuctionFrameBrowse_Update_Old();

    local offset = FauxScrollFrame_GetOffset(BrowseScrollFrame);

    for i = 1, NUM_BROWSE_TO_DISPLAY do
        local name, _, count, _, _, _, _, min, inc, buy, bid =  GetAuctionItemInfo("list", offset + i);
        if (name) then
            local _, _, id = strfind(GetAuctionItemLink("list", offset + i) or "", "item:(%d+):");
            if (id) then
                local stack = select(8, GetItemInfo(id));
                if (stack and stack > 1) then
                    bid = (bid > 0 and (bid + inc) or min);
                    local item = getglobal("BrowseButton" .. i .. "Name");
                    truncateItemName(item);
                    local text;
                    if (UnitPriceShowBid) then
                        text = moneyFormat(floor(bid / count));
                        if (UnitPriceShowBuyout and buy > 0) then
                            text = text .. "/";
                        end
                    end
                    if (UnitPriceShowBuyout and buy > 0) then
                        text = (text or "") .. moneyFormat(floor(buy / count));
                    end
                    if (text) then
                        item:SetFormattedText("%s\n(%s)", item:GetText() or "", text);
                    end
                end
            end
        end
    end
end

AuctionFrameBrowse_Update = AuctionFrameBrowse_Update_Hooked;

local function command(arg)
    if (arg == "") then
        DEFAULT_CHAT_FRAME:AddMessage("UnitPrice settings:");
        DEFAULT_CHAT_FRAME:AddMessage("/up showbid - enable/disable display of bid price.");
        DEFAULT_CHAT_FRAME:AddMessage("/up showbuyout - enable/disable display of buyout price.");
    elseif (arg == "showbid") then
        if (UnitPriceShowBid) then
            DEFAULT_CHAT_FRAME:AddMessage("UnitPrice: Display of bid price disabled");
        else
            DEFAULT_CHAT_FRAME:AddMessage("UnitPrice: Display of bid price enabled");
        end
        UnitPriceShowBid = not UnitPriceShowBid;
    elseif (arg == "showbuyout") then
        if (UnitPriceShowBuyout) then
            DEFAULT_CHAT_FRAME:AddMessage("UnitPrice: Display of buyout price disabled");
        else
            DEFAULT_CHAT_FRAME:AddMessage("UnitPrice: Display of buyout price enabled");
        end
        UnitPriceShowBuyout = not UnitPriceShowBuyout;
    end
end

SlashCmdList["UNITPRICE"] = command;
SLASH_UNITPRICE1 = "/up";
SLASH_UNITPRICE2 = "/unitprice";
