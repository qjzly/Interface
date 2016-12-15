local GNOME, Sequences = ...

------------------
----- Death Knight
------------------
Sequences['HP_EX_Unholy'] = {
author="EnixLHQ",
specID=252,
version=24,
helpTxt = "Talents: 121??33 - Run at 80ms - https://wowlazymacros.com/forums/topic/unholy-soul-reaper/",
icon='INV_MISC_QUESTIONMARK',
lang="enUS",
PreMacro=[[
/targetenemy [noharm][dead]
/cast [nopet,nomod] Raise Dead
/use [mod:alt] Death Strike
/castsequence  reset=combat  Outbreak, Festering Strike, Festering Strike, null
]],
"/cast Apocalypse",
"/cast Scourge Strike",
"/castsequence Dark Transformation, Outbreak",
"/castsequence  reset=target  Festering Strike, Festering Strike",
"/castsequence  reset=target  Festering Strike, Festering Strike, Soul Reaper, Outbreak",
"/cast Summon Gargoyle",
"/cast Death Coil",
"/cast Scourge Strike",
PostMacro=[[
]],
}

Sequences['冰'] = {
author="John Metz",
specID=251,
helpTxt = "Talents: 2233213 - https://wowlazymacros.com/forums/topic/gs-ptr-dual-frost/page/7/#post-35102",
StepFunction = GSStaticPriority,
icon='INV_MISC_QUESTIONMARK',
PreMacro=[[
/cast [combat] 冰霜之柱
]],
"/cast !冰霜打击",
"/castsequence  reset=combat  湮没, 冰霜打击, 凛风冲击",
"/castsequence  reset=combat  冰霜之镰, 冰霜打击, 冰霜打击, 湮没, 凛风冲击",
"/castsequence  reset=combat  冰川突进",
"/cast [combat] 符文武器增效",
PostMacro=[[
/targetenemy [noharm][dead]
]],
}

Sequences['AOE冰'] = {
author="John Metz",
specID=251,
helpTxt = "Talents: 2213213 - https://wowlazymacros.com/forums/topic/gs-ptr-dual-frost/page/7/#post-35102",
StepFunction = GSStaticPriority,
icon='INV_MISC_QUESTIONMARK',
PreMacro=[[
/cast [combat] 冰霜之柱
]],
"/cast !冰霜打击",
"/castsequence  reset=combat  冰霜之镰, 冰霜打击, 凛风冲击",
"/castsequence  reset=combat  湮没, 冰霜打击, 冰霜打击, 冰霜之镰, 凛风冲击",
"/castsequence  reset=combat  冰川突进",
"/cast [combat] 冷酷严冬",
"/cast [combat] 符文武器增效",
PostMacro=[[
/targetenemy [noharm][dead]
]],
}

Sequences["HP_SquishyDK"] = {
specID = 250,
author = "Suiseiseki",
helpTxt = "Talents: 2112133",
StepFunction = GSStaticPriority,
PreMacro = [[
/Cast [combat] Dancing Rune Weapon
/cancelaura Wraith Walk
]],
"/cast [combat] Consumption",
"/cast [combat] Blood Boil",
"/cast Death Strike",
'/castsequence reset=combat Marrowrend, Heart Strike, Heart Strike, Heart Strike, Heart Strike, Heart Strike, Marrowrend',
"/castsequence reset=combat Death's Caress, null",
"/castsequence reset=combat Marrowrend, Heart Strike, Heart Strike, Heart Strike, Heart Strike, Marrowrend",
"/cast Death Strike",
PostMacro = [[
/TargetEnemy [noharm][dead]
]],
}
