local GNOME, Sequences = ...

------------------
----- Paladin
------------------
Sequences['惩戒'] = {
specID = 66,
author = " ",
helpTxt = "Protection single target tanking macro.",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/cast 灰烬觉醒(神器)",
'/cast 圣殿骑士的裁决',
'/cast 十字军打击',
'/cast 公正之剑',
"/cast 审判",
PostMacro = [[
/startattack
]],
}