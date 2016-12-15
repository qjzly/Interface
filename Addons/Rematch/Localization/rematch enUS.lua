--[[

	As of 2.4.5, enUS no longer has a dedicated localization.

	'localization template.lua' contains strings added in each update.

	If you'd like to help translate Rematch into another language that
	would be awesome. You can check out 'localization template.lua' to
	see how.

	Alternately, a localization page is set up on curse:
	http://wow.curseforge.com/addons/rematch/localization/

	If you have any questions, PM me at Gello on	wowinterface.com
	or curse.com.  Thanks!

]]

local _,L = ...
local function defaultFunc(L, key) return key end
setmetatable(L, {__index=defaultFunc})
