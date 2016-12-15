local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Death Knight
------------------



Sequences['DANB-邪死骑'] = {
PreMacro = [[
/targetenemy [noharm][dead]
]],
specID = 252,
author = "throwryuken",
helpTxt = "Talents 2221213",
'/cast [nochanneling] 亡者复生',
'/cast [nochanneling] 爆发',
'/cast [nochanneling] 黑暗突变',
'/cast [nochanneling] 脓疮打击',
'/cast [nochanneling] 天灾打击',
'/cast [nochanneling] 灵魂收割',
'/cast [nochanneling] 灵界打击',
'/cast [nochanneling] 召唤石像鬼',
'/cast [nochanneling] 凋零缠绕',
PostMacro = [[
/startattack
]],
}


Sequences["DANB-冰死骑"] = {
StepFunction = GSStaticPriority,  
PreMacro = [[
/use [combat] 冰霜之柱
]],
	'/cast 湮灭',
	'/cast 冰霜打击',
	'/cast 冷酷严冬',
	'/cast 冰川突进',
PostMacro = [[
]],
 }

Sequences['DANB-血死骑'] = {
StepFunction = GSStaticPriority,
specID = 250,
author = "goose",
helpTxt = "Talents 2112333",
PreMacro = [[
/use [combat] 13
/use [combat] 14
]],
"/cast 骨髓分裂",
"/castsequence reset=combat 死神的抚摩, 灵界打击, 灵界打击, 灵界打击, 灵界打击, 灵界打击, 灵界打击, 灵界打击",
'/castsequence reset=combat 血液沸腾, 血液沸腾, 骨髓分裂',
'/castsequence reset=combat 心脏打击, 心脏打击, 心脏打击, 心脏打击, 骨髓分裂',
PostMacro = [[
/targetenemy [noharm][dead]
]],
} 


Sequences['邪恶'] = {
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=15/combat 爆发,脓疮打击,暗影之爪,暗影之爪,暗影之爪,脓疮打击,暗影之爪,暗影之爪,暗影之爪,脓疮打击,暗影之爪,暗影之爪,暗影之爪",
'/cast 凋零缠绕',
'/cast 黑暗突变',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


