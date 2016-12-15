local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Druid
------------------




Sequences["DANB-潜冲"] = { 
        '/cast 潜行',
	'/cast 野性冲锋',
        '/cast 撕碎',
}


Sequences['熊坦'] = {
PreMacro = [[
/targetenemy [noharm][dead]
/cast 铁鬃
/cast 狂暴回复
]],
"/castsequence reset=4 痛击,月火术,横扫,痛击,横扫,横扫,痛击,横扫,横扫",
'/cast 裂伤',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}



Sequences['DANB-野德'] = {
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=5 斜掠,野蛮咆哮,撕碎,撕碎,撕碎,撕碎,割裂,撕碎,撕碎,撕碎,撕碎,凶猛撕咬",
'/cast 猛虎之怒',
'/cast 狂暴',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}



Sequences['DANB-熊德'] = {
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=5 裂伤,痛击,横扫,横扫",
'/cast 重殴',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}

