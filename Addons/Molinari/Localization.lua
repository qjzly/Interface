local _, L = ...

setmetatable(L, {__index = function(L, key)
	local value = tostring(key)
	L[key] = value
	return value
end})

local locale = GetLocale()
if(locale == 'deDE') then
L["Drag items into the window below to add more."] = "Ziehe Gegenstände in das Fenster, um sie hinzuzufügen."
L["Items blacklisted from potentially being processed."] = "Ausgeschlossene Gegenstände, die niemals verarbeitet werden."
L["Right-click to remove item"] = "Rechtsklicke, um den Gegenstand zu entfernen"
elseif(locale == 'esES') then
elseif(locale == 'esMX') then
elseif(locale == 'frFR') then
elseif(locale == 'itIT') then
elseif(locale == 'koKR') then
elseif(locale == 'ptBR') then
elseif(locale == 'ruRU') then
elseif(locale == 'zhCN') then
elseif(locale == 'zhTW') then
L["Drag items into the window below to add more."] = "將物品拖曳到下方的視窗內，加入到忽略清單。"
L["Items blacklisted from potentially being processed."] = "請將要避免不小心被處理掉的物品加入忽略清單。"
L["Right-click to remove item"] = "點一下右鍵移除物品"
end
