-- shared media stuff for FreeUI.Fluffy

local LSM = _G.LibStub("LibSharedMedia-3.0")
local koKR, ruRU, zhCN, zhTW, western = LSM.LOCALE_BIT_koKR, LSM.LOCALE_BIT_ruRU, LSM.LOCALE_BIT_zhCN, LSM.LOCALE_BIT_zhTW, LSM.LOCALE_BIT_western

-- BACKGROUND
LSM:Register("background", "FF_B", 				[[Interface\Addons\FreeUI\Media\HalBackgroundB.tga]])
LSM:Register("background", "FF_A", 				[[Interface\Addons\FreeUI\Media\HalBackgroundA.tga]])

-- FONT
LSM:Register("font", "ExocetBlizzardLight", 	[[Interface\Addons\FreeUI\Media\ExocetBlizzardLight.ttf]], zhCN + zhTW + western)
LSM:Register("font", "ExocetBlizzardMedium", 	[[Interface\Addons\FreeUI\Media\ExocetBlizzardMedium.ttf]], zhCN + zhTW + western)
LSM:Register("font", "FruityMicrofont", 		[[Interface\Addons\FreeUI\Media\FruityMicrofont.ttf]], zhCN + zhTW + western)
LSM:Register("font", "supereffective", 			[[Interface\Addons\FreeUI\Media\supereffective.ttf]], zhCN + zhTW + western)
LSM:Register("font", "pixel", 					[[Interface\Addons\FreeUI\Media\pixel.ttf]], zhCN + zhTW + western)
LSM:Register("font", "pixel_bold", 				[[Interface\Addons\FreeUI\Media\pixel_bold.ttf]], zhCN + zhTW + western)
LSM:Register("font", "pixel_large", 			[[Interface\Addons\FreeUI\Media\pixel_large.ttf]], zhCN + zhTW + western)
LSM:Register("font", "pixel_condensed", 		[[Interface\Addons\FreeUI\Media\pixel_condensed.ttf]], zhCN + zhTW + western)
LSM:Register("font", "SempliceRegular", 		[[Interface\Addons\FreeUI\Media\SempliceRegular.ttf]], zhCN + zhTW + western)
LSM:Register("font", "visitor1", 				[[Fonts\pixel\visitor1.ttf]], zhCN + zhTW + western)
LSM:Register("font", "visitor2", 				[[Fonts\pixel\visitor2.ttf]], zhCN + zhTW + western)
LSM:Register("font", "Hooge0655", 				[[Interface\Addons\FreeUI\Media\Hooge0655.ttf]], zhCN + zhTW + western)
LSM:Register("font", "BitOnX", 					[[Interface\Addons\FreeUI\Media\BitOnX.ttf]], zhCN + zhTW + western)
LSM:Register("font", "Pixelway_Baseline", 		[[Interface\Addons\FreeUI\Media\Pixelway_Baseline.ttf]], zhCN + zhTW + western)

LSM:Register("font", "pixfontCN", 				[[Fonts\pixfontCN.ttf]], zhCN + zhTW + western)
LSM:Register("font", "Hiragino", 				[[Fonts\Hiragino.ttf]], zhCN + zhTW + western)
LSM:Register("font", "lihei", 					[[Fonts\lihei.ttf]], zhCN + zhTW + western)
LSM:Register("font", "cy_emblem", 				[[Fonts\cy_emblem.ttf]], zhCN + zhTW + western)
LSM:Register("font", "yahei", 					[[Fonts\yh_.ttf]], zhCN + zhTW + western)
LSM:Register("font", "yh_expressway", 			[[Fonts\msyhbd_expresswaysb.ttf]], zhCN + zhTW + western)
LSM:Register("font", "yh_fritzQuad", 			[[Fonts\yh_fritzQuad.ttf]], zhCN + zhTW + western)
LSM:Register("font", "yh_myriad", 				[[Fonts\yh_myriad.ttf]], zhCN + zhTW + western)
LSM:Register("font", "PingFang",				[[Fonts\CN\PingFangTC-Semibold.otf]], zhCN + zhTW + western)


-- LSM:Register("font", "张海山草泥马体", 				[[Fonts\CN\zhscnmt.ttf]], zhCN + zhTW)
-- LSM:Register("font", "张海山锐谐体", 				[[Fonts\CN\zhsrxt.ttf]], zhCN + zhTW)
-- LSM:Register("font", "颜体楷书", 					[[Fonts\CN\yanti.ttf]], zhCN + zhTW)
-- LSM:Register("font", "方正柳楷", 					[[Fonts\CN\方正柳楷.ttf]], zhCN + zhTW)
-- LSM:Register("font", "方正粗黑宋简", 				[[Fonts\CN\方正粗黑宋简.otf]], zhCN + zhTW)
-- LSM:Register("font", "方正行黑", 					[[Fonts\CN\方正行黑.ttf]], zhCN + zhTW)
-- LSM:Register("font", "方正跃进体", 				[[Fonts\CN\方正跃进体.ttf]], zhCN + zhTW)
-- LSM:Register("font", "方正邱氏粗瘦金书简体", 		[[Fonts\CN\方正邱氏粗瘦金书简体.ttf]], zhCN + zhTW)
-- LSM:Register("font", "方正黑隶简_粗", 				[[Fonts\CN\方正黑隶简_粗.ttf]], zhCN + zhTW)
-- LSM:Register("font", "書體坊顏體", 				[[Fonts\CN\書體坊顏體.ttf]], zhCN + zhTW)

-- SOUND
LSM:Register("sound", "FF_bell", 				[[Interface\Addons\FreeUI\Media\bell.ogg]])
LSM:Register("sound", "FF_bird_flap",		 	[[Interface\Addons\FreeUI\Media\bird_flap.ogg]])
LSM:Register("sound", "FF_buzz", 				[[Interface\Addons\FreeUI\Media\buzz.ogg]])
LSM:Register("sound", "FF_cling", 				[[Interface\Addons\FreeUI\Media\cling.ogg]])
LSM:Register("sound", "FF_ding", 				[[Interface\Addons\FreeUI\Media\ding.ogg]])
LSM:Register("sound", "FF_Evangelism_stacks", 	[[Interface\Addons\FreeUI\Media\Evangelism stacks.ogg]])
LSM:Register("sound", "FF_execute", 			[[Interface\Addons\FreeUI\Media\execute.ogg]])
LSM:Register("sound", "FF_Finisher", 			[[Interface\Addons\FreeUI\Media\Finisher.ogg]])
LSM:Register("sound", "FF_Glint", 				[[Interface\Addons\FreeUI\Media\Glint.ogg]])
LSM:Register("sound", "FF_LightsHammer", 		[[Interface\Addons\FreeUI\Media\LightsHammer.ogg]])
LSM:Register("sound", "FF_LowHealth", 			[[Interface\Addons\FreeUI\Media\LowHealth.ogg]])
LSM:Register("sound", "FF_LowMana", 			[[Interface\Addons\FreeUI\Media\LowMana.ogg]])
LSM:Register("sound", "FF_Mint", 				[[Interface\Addons\FreeUI\Media\Mint.ogg]])
LSM:Register("sound", "FF_miss", 				[[Interface\Addons\FreeUI\Media\miss.mp3]])
LSM:Register("sound", "FF_Proc", 				[[Interface\Addons\FreeUI\Media\Proc.ogg]])
LSM:Register("sound", "FF_ShadowOrbs", 			[[Interface\Addons\FreeUI\Media\ShadowOrbs.ogg]])
LSM:Register("sound", "FF_ShortCircuit", 		[[Interface\Addons\FreeUI\Media\ShortCircuit.ogg]])
LSM:Register("sound", "FF_Shutupfool", 			[[Interface\Addons\FreeUI\Media\Shutupfool.ogg]])
LSM:Register("sound", "FF_SliceDice", 			[[Interface\Addons\FreeUI\Media\SliceDice.ogg]])
LSM:Register("sound", "FF_sound", 				[[Interface\Addons\FreeUI\Media\sound.mp3]])
LSM:Register("sound", "FF_SpeedofLight", 		[[Interface\Addons\FreeUI\Media\SpeedofLight.ogg]])
LSM:Register("sound", "FF_Warning", 			[[Interface\Addons\FreeUI\Media\Warning.ogg]])
LSM:Register("sound", "FF_whisper", 			[[Interface\Addons\FreeUI\Media\whisper.ogg]])
LSM:Register("sound", "FF_whisper1", 			[[Interface\Addons\FreeUI\Media\whisper1.ogg]])
LSM:Register("sound", "FF_whisper2", 			[[Interface\Addons\FreeUI\Media\whisper2.ogg]])
LSM:Register("sound", "FF_swordecho", 			[[Interface\Addons\FreeUI\Media\swordecho.ogg]])

-- STATUSBAR
LSM:Register("statusbar", "FF_Angelique",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Angelique.tga]])
LSM:Register("statusbar", "FF_Antonia",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Antonia.tga]])
LSM:Register("statusbar", "FF_Bettina",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Bettina.tga]])
LSM:Register("statusbar", "FF_Jasmin",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Jasmin.tga]])
LSM:Register("statusbar", "FF_Lisa",  			[[Interface\Addons\FreeUI\Media\statusbar\FF_Lisa.tga]])
LSM:Register("statusbar", "FF_Larissa",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Larissa.tga]])
LSM:Register("statusbar", "FF_Sam",  			[[Interface\Addons\FreeUI\Media\statusbar\FF_Sam.tga]])
LSM:Register("statusbar", "FF_Stella",  		[[Interface\Addons\FreeUI\Media\statusbar\FF_Stella.tga]])
