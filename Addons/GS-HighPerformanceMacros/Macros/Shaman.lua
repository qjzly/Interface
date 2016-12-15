local GNOME, Sequences = ...

------------------
----- Shaman
------------------
Sequences["增强"] = {   
PreMacro = [[
/targetenemy [noharm][dead]
/cast [combat] 毁灭之风
]],
'/cast 石拳',
'/cast 风暴打击',
"/castsequence reset=7 火舌,冰封,毁灭闪电,毁灭闪电",
'/cast [@player]闪电奔涌图腾',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}