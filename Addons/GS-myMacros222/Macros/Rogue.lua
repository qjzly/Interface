local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Rogue
------------------


Sequences['盗贼-狂徒'] = {
author="Suiseiseki - www.wowlazymacros.com",
specID=260,
helpTxt = 'Outlaw - 1223122',
StepFunction = GSStaticPriority,
PreMacro=[[
/targetenemy [noharm][dead]
/cast [nostealth,nocombat] 隐身
/cast [combat] 死亡标记
]],
"/castsequence 鬼魅攻击, 军刀猛刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 军刀猛刺",
"/castsequence 军刀猛刺, 穿刺, 军刀猛刺, 手枪射击",
"/castsequence [talent:7/1] 切割; [talent:7/2][talent:7/3] 命运骨骰, 军刀猛刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 手枪射击, 穿刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 手枪射击",
"/castsequence 穿刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 军刀猛刺, 手枪射击",
PostMacro=[[
/use [combat] 13
/use [combat] 14
]],
}



Sequences["刺杀"] = {
StepFunction = GSStaticPriority,  
PreMacro = [[
/cast [nostealth]潜行,
]],
	'/cast 暗影步',
	'/cast 偷袭',
	'/cast 毁伤',
PostMacro = [[
]],
 }

Sequences['DANB-狂徒贼'] = {
specID = 1269,
author = "DANB",
helpTxt = "Outlaw 2322121",
PreMacro = [[
/cast [nostealth,nocombat] 潜行
]],
"/castsequence reset=4/combat/target 军刀猛刺,军刀猛刺,手枪射击,军刀猛刺,切割,军刀猛刺,军刀猛刺,手枪射击,穿刺,军刀猛刺,军刀猛刺,手枪射击,穿刺,军刀猛刺,军刀猛刺,手枪射击,穿刺,军刀猛刺,军刀猛刺,手枪射击,穿刺",
PostMacro = [[
]],
}

Sequences["DANB-刺杀贼"] = {
specID = 8754,
author = "DANB",
helpTxt = "3211231", 
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=15 毁伤,毁伤,出血,割裂,锁喉,毁伤,毒伤",
'/cast 抽血',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]], 
}
