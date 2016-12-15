local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Priest
------------------

Sequences['暗影321'] = {
specID = 7269,
author = "DANB",
helpTxt = "2322121",
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/castsequence reset=combat 暗言术：痛,吸血鬼之触,精神鞭笞,心灵震爆,精神鞭笞,精神鞭笞,精神鞭笞,精神鞭笞,心灵震爆
'/cast !虚空爆发',
'/cast 暗言术：灭',
PostMacro = [[
/cast [nochanneling] 暗影魔
]],
}

Sequences["暗影12"] = { 
PreMacro = [[
/targetenemy [noharm][dead]
/cast 能量灌注
]],
"/castsequence [nochanneling]reset=6 暗言术：痛,吸血鬼之触,精神鞭笞,精神鞭笞,心灵震爆,精神鞭笞,精神鞭笞,精神鞭笞,心灵震爆",
'/cast 虚空爆发',
'/cast 暗言术：灭',
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
}


Sequences["暗影牧师"] = { 
PreMacro = [[
/targetenemy [noharm][dead]
/cast 能量灌注
]],
'/cast 虚空爆发',
'/cast 虚空箭',
'/cast 暗言术：灭',
"/castsequence [nochanneling]reset=6 暗言术：痛,吸血鬼之触,精神鞭笞,心灵震爆,精神鞭笞,精神鞭笞,精神鞭笞,精神鞭笞,心灵震爆",
PostMacro = [[
/Use [combat] 13
/Use [combat] 14
]],
} 
