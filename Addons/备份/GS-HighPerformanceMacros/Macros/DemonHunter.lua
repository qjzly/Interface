local GNOME, Sequences = ...

------------------
----- Demon Hunter
------------------
Sequences['浩劫'] = {
specID = 577,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
StepFunction = GSStaticPriority,
PreMacro = [[
/startattack
]],
'/cast [@mouseover,nodead,harm,exists]投掷利刃;[harm]投掷利刃;[]投掷利刃',
'/cast [nochanneling,combat] 伊利达雷之怒(神器)',
'/cast [nochanneling,combat] 混乱新星',
'/cast [nochanneling,combat] 邪能弹幕',
'/cast [nochanneling,combat] 混乱打击',
PostMacro = [[

]],
}

Sequences['复仇'] = {
specID = 577,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
PreMacro = [[
/startattack
]],
'/cast [@mouseover,nodead,harm,exists]投掷利刃;[harm]投掷利刃;[]投掷利刃',
'/cast [nochanneling,combat] 恶魔尖刺',
'/cast [nochanneling,combat] 献祭光环',
'/cast [nochanneling,combat] 裂魂',
'/cast [nochanneling,combat] 灵魂切削(神器)',
'/cast [nochanneling,combat] 灵魂壁障',
'/cast [nochanneling,combat] 邪能毁灭',

PostMacro = [[

]],
}