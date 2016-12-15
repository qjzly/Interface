local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Warrior
------------------


Sequences['战士-狂暴-单体'] = {
specID = 72,
author = "Firone - wowlazymacros.com",
helpTxt = "Single Target -- 2,3,1,2,3,3,3",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/cast [combat] 狂暴之怒
]],
[[/cast 斩杀]],
[[/castsequence reset=60 暴怒,战吼]],
[[/cast 暴怒]],
[[/cast [talent:7/3] 巨龙怒吼]],
[[/cast 嗜血]],
[[/cast 怒击]],
[[/cast 旋风斩]],
PostMacro = [[
/startattack
/use [combat]13
/use [combat]14
]],
}


Sequences['战士-狂暴-群体'] = {
specID = 72,
author = "Firone - wowlazymacros.com",
helpTxt = "AOE -- 2,3,1,2,3,3,3",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/cast [combat] 狂暴之怒
]],
[[/cast [talent:7/3] 巨龙怒吼]],
[[/cast !旋风斩]],
[[/cast !嗜血]],
PostMacro = [[
/cast [combat]狂暴之怒
/use [combat]13
/use [combat]14
]],
} 


Sequences['DANB-狂暴战'] = {
specID = 72,
author = "Firone - wowlazymacros.com",
helpTxt = "Single Target -- 2,3,1,2,3,3,3",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/cast [combat] 狂暴之怒
/cast [combat] 战吼
]],
[[/cast 斩杀]],
[[/cast 嗜血]],
[[/cast 怒击]],
[[/cast 旋风斩]],
[[/cast 暴怒]],
[[/cast [talent:7/3] 巨龙怒吼]],
PostMacro = [[
/startattack
/use [combat]13
/use [combat]14
]],
}

Sequences["狂暴战士"] = {  
PreMacro = [[
/targetenemy [noharm][dead]
/cast 天神下凡
/cast 战吼
]],
"/castsequence reset=3 嗜血,怒击,旋风斩",
'/cast 暴怒',
'/cast 斩杀',
'/cast 巨龙怒吼',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}




Sequences["武器战士"] = {  
PreMacro = [[
/targetenemy [noharm][dead]
/cast 战吼
]],
"/castsequence reset=6 撕裂,怒火聚焦,怒火聚焦,怒火聚焦,顺劈斩,旋风斩",
'/cast 致死打击',
'/cast 巨人打击',
'/cast 乘胜追击',
'/cast 斩杀',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


Sequences["DANB-防战单"] = {  
PreMacro = [[
/targetenemy [noharm][dead]
/cast 法术反射
/cast 战吼
/cast 狂暴之怒
]],
'/cast 复仇',
'/cast 盾牌猛击',
'/cast 盾牌格挡',
'/cast 复仇',
'/cast 盾牌猛击',
'/cast 无视苦痛',
'/cast 乘胜追击',
'/cast 毁灭打击',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


Sequences["DANB-防战群"] = {  
PreMacro = [[
/targetenemy [noharm][dead]
/cast 法术反射
/cast 战吼
/cast 狂暴之怒
]],
'/cast 复仇',
'/cast 盾牌猛击',
'/cast 盾牌格挡',
'/cast 无视苦痛',
'/cast 乘胜追击',
'/cast 雷霆一击',
'/cast 毁灭打击',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


Sequences['战士-狂暴-单体啊'] = {
specID = 72,
author = "Firone - wowlazymacros.com",
helpTxt = "Single Target -- 2,3,1,2,3,3,3",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/cast [combat] 狂暴之怒
/cast [combat] 战吼
]],
[[/castsequence reset=60 暴怒,战吼]],
[[/cast [talent:7/3] 巨龙怒吼]],
[[/cast 暴怒]],
[[/cast 嗜血]],
[[/cast 怒击]],
[[/cast 旋风斩]],
[[/cast !斩杀]],
PostMacro = [[
/startattack
/use [combat]13
/use [combat]14
]],
}