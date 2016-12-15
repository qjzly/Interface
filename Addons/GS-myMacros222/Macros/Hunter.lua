local Sequences = GSMasterSequences -- Dont remove this

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
/petautocastoff [group] 低吼
/petautocaston [nogroup] 低吼
]],
'/cast [nochanneling,combat] 夺命黑鸦',
'/cast [nochanneling,combat] 泰坦之雷',
'/castsequence [combat] reset=15 狂野怒火,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令,眼镜蛇射击,杀戮命令',
'/cast [nochanneling,combat] !凶暴野兽',
'/cast [nochanneling,combat] !杀戮命令',
PostMacro = [[
/startattack
/petattack
/cast [combat]野性守护
/use [combat]13
/use [combat]14
/cancelaura 灵龟守护
]],
}

Sequences['群体'] = {
specID = 253,
author = " ",
helpTxt = "Single Target - Talent: 3132212",
StepFunction = GSStaticPriority,
PreMacro = [[
/startattack
/petautocastoff [group] 低吼
/petautocaston [nogroup] 低吼
]],
'/cast [nochanneling,combat] 多重射击',
'/cast [nochanneling,combat] !凶暴野兽',
PostMacro = [[
/cancelaura 灵龟守护
]],
}


Sequences['猎人-野兽-单体'] = {
specID = 253,
author = " ",
helpTxt = "Single Target - Talent: 3111323",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/startattack
/petattack [@target,harm]
/petautocastoff [group] 低吼
/petautocaston [nogroup] 低吼
/cast [target=focus, exists, nodead],[target=pet, exists, nodead] 误导
]],
'/cast [nochanneling,combat] 眼镜蛇射击',
'/cast [nochanneling,combat] !杀戮命令',
'/cast [nochanneling,combat] 狂野怒火',
'/cast [nochanneling,combat] !凶暴野兽',
'/cast [nochanneling,combat] !夺命黑鸦',
PostMacro = [[
/startattack
/petattack
/cast [combat]野性守护
/use [combat]13
/use [combat]14
/cancelaura 灵龟守护
]],
}
