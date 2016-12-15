local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Shaman
------------------


Sequences['萨满-增强1'] = {
specID = 263,
author = "Suiseiseki - stan",
helpTxt = "Single Target",
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence [combat] 毁灭闪电, 熔岩猛击, 熔岩猛击",
"/cast 风暴打击",
"/castsequence 火舌, 石化, 石化, 石化, 石化, 石化",
'/cast 风歌',
PostMacro = [[
/cast 狂野扑击
/use [combat] 13
/use [combat] 14
]],
}


Sequences['萨满-增强2'] = {
specID = 263,
author = "lloskka",
helpTxt = "Talents  3112112 - Artifact Order: 毁灭之风 �> Hammer of Storms �> Gathering Storms �> Wind Strikes �> Wind Surge �> Weapons of the elements �> Elemental Healing �> and all the way to Unleash Doom",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
]],
[[/castsequence 石拳, 毁灭闪电, !风暴打击;]],
[[/castsequence 石拳, 风暴打击, 毁灭闪电;]],
[[/castsequence [nochanneling] 石拳, 石拳, !毁灭闪电;]],
[[/castsequence 石拳, 石拳;]],
[[/cast 闪电箭;]],
PostMacro = [[
/startattack
/use [combat] 11
/use [combat] 12
/cast [combat] 毁灭之风
]],
}

Sequences['萨满-治疗'] = {
specID = 264,
author = "Draik",
helpTxt = "Talents - 3211233",
PreMacro = [[
/targetenemy [noharm][dead]
]],
'/cast Chain Lightning',
'/cast Flame Shock',
'/cast Eathern Shield Totem',
'/cast Lava Burst',
'/cast Lightning Bold',
'/cast Lightning Surge Totem',
PostMacro = [[
/use [combat] 13
/use [combat] 14
]],
}


Sequences["萨满-恢复-单"] = { 
[[
/castsequence reset=3/combat 治疗之涌,治疗波
]],	
	'/cast 激流',
}

Sequences["萨满-恢复-群"] = { 
        '/cast 治疗之泉图腾',
	'/cast 治疗链',
}


Sequences['DANB-增强萨'] = {
specID = 263,
author="逐日者-桩子",
helpTxt = 'Talents:32x3112',
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/cast 石拳",
"/cast 风暴打击",
"/castsequence reset=8/combat/target 冰封,火舌,毁灭闪电,毁灭闪电",
"/cast 风暴打击",
PostMacro = [[
/startattack
]],
}

Sequences['增强2'] = {
specID = 1263,
author="danb",
helpTxt = 'Talents:32x3112',
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=8/combat/target 火舌,冰封",
"/cast 石拳",
"/cast 风暴打击",
"/cast 毁灭闪电",
PostMacro = [[
/startattack
]],
}