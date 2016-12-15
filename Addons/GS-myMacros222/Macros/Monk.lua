local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Monk
------------------


Sequences['DANB-风行僧'] = {
specID = 269,
author = "John Mets",
helpTxt = "Talent are 2 3 2 3 1 2 3",
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=combat 猛虎掌, 猛虎掌, 幻灭踢, 幻灭踢, 旭日东升踢",
"/castsequence reset=combat 猛虎掌, 猛虎掌, 幻灭踢, 幻灭踢, 怒雷破",
"/cast 猛虎掌",
"/cast 轮回之触",
PostMacro = [[
/cast [combat] 屏气凝神
/cast [combat] 轮回之触
/use [combat] 11
/use [combat] 12
]],
}

Sequences['武僧-风行2'] = {
specID = 269,
author = "lloskka",
helpTxt = "Talents 2 3 2 3 2 2 3",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
/cast [combat] 业报之触
]],
'/castsequence 猛虎掌, 旭日东升踢, 猛虎掌, 猛虎掌, 猛虎掌, 猛虎掌',
'/castsequence [nochanneling] 猛虎掌, 怒雷破, 猛虎掌, 幻灭踢',
'/castsequence [nochanneling] 猛虎掌, 猛虎掌, 猛虎掌, 猛虎掌, 幻灭踢, 怒雷破, 猛虎掌, 猛虎掌, 猛虎掌, 猛虎掌, 幻灭踢',
'/castsequence 猛虎掌, 旭日东升踢, 猛虎掌, 猛虎掌, 猛虎掌, 幻灭踢',
PostMacro = [[
/startattack
/cast [combat] 白虎下凡
/cast [combat] 屏气凝神
/cast [combat] 轮回之触
/use [combat] 11
/use [combat] 12
]],
}



