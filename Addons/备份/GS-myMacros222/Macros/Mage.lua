local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Mage
------------------


Sequences["冰法"] = { 
PreMacro = [[
/targetenemy [noharm][dead]
/petattack [nogroup]
/cast 冰冷血脉
]], 
"/castsequence [nochanneling]reset=0 冰霜射线",
"/castsequence [nochanneling]reset=0 冰川尖刺",
"/castsequence [nochanneling]reset=0 水流喷射",
'/castsequence [nochanneling]reset=0 冰风暴',
'/castsequence [nochanneling]reset=1 寒冰箭',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


