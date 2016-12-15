local GNOME, Sequences = ...

------------------
----- Hunter
------------------
Sequences['杀戮眼镜蛇'] = {
specID = 253,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
StepFunction = GSStaticPriority,
PreMacro = [[
/startattack
/petattack [@target,harm]
/petautocaston [nogroup] 低吼
]],
'/cast [nochanneling,combat] 夺命黑鸦',
'/cast [nochanneling,combat] !乱射',
'/castsequence reset=15 狂野怒火,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令',
'/cast [nochanneling,combat] !凶暴野兽',
'/cast [nochanneling,combat] !杀戮命令',
'/cast [nochanneling,combat] 眼镜蛇射击',
PostMacro = [[
/petattack
/cast [combat]野性守护
/use [combat]13
/use [combat]14
/cancelaura 灵龟守护
]],
}


Sequences['生存'] = {
specID = 253,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
StepFunction = GSStaticPriority,
PreMacro = [[
/startattack
/petattack [@target,harm]
/petautocaston [nogroup] 低吼
]],
'/cast [nochanneling:雄鹰之怒] 爆炸陷阱',
'/cast [nochanneling:雄鹰之怒] 龙焰手雷',
'/cast [nochanneling:雄鹰之怒] 裂痕',
PostMacro = [[
/petattack
/use [combat]13
/use [combat]14
/cancelaura 灵龟守护
]],
}

Sequences['猫鼬'] = {
specID = 253,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
StepFunction = GSStaticPriority,
PreMacro = [[
/startattack
/petattack [@target,harm]
/petautocaston [nogroup] 低吼
]],
'/cast [nochanneling:雄鹰之怒] 猫鼬撕咬',
'/cast [nochanneling:雄鹰之怒] 侧翼打击',
PostMacro = [[
/petattack
/use [combat]13
/use [combat]14
/cancelaura 灵龟守护
]],
}