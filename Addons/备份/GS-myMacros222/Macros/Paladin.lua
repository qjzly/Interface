local Sequences = GSMasterSequences

------------------
----- Paladin
------------------

-------------------
-- Protection - 66
-------------------
Sequences['DB_Prot'] = {
specID = 66,
author = "Maurice Greer",
helpTxt = "Protection single target tanking macro.",
StepFunction = GSStaticPriority,
PreMacro = [[
/targetenemy [noharm][dead]
]],
"/cast Avenger's Shield",
'/cast Judgment',
'/cast Hammer of the Righteous',
'/cast Holy Wrath',
"/cast Avenger's Shield",
'/cast Hammer of Wrath',
'/cast Consecration',
PostMacro = [[
/cast Shield of the Righteous
/startattack
]],
}

-------------------
-- Retribution - 70
-------------------

Sequences['DB_Ret'] = {
specID = 70,
author = "Draik",
helpTxt = "Retribution Single Target macro - 3311112.",
icon = "INV_Sword_2H_AshbringerCorrupt",
PreMacro = [[
/targetenemy [noharm][dead]
]],
'/cast Judgment',
'/cast Crusader Strike',
'/cast Blade of Justice',
'/cast [combat]!Consecration',
'/cast [combat]!Crusade',
'/cast !Wake of Ashes',
"/cast Templar's Verdict",
PostMacro = [[
/use [combat]13
/use [combat]14
]],
}

Sequences['DB_RetAoE'] = {
specID = 70,
author = "Draik",
helpTxt = "Retribution AoE macro - 3311112.",
icon = "Ability_Paladin_DivineStorm",
PreMacro = [[
/targetenemy [noharm][dead]
]],
'/cast Judgment',
'/cast Crusader Strike',
'/cast Blade of Justice',
'/cast [combat]!Consecration',
'/cast [combat]!Crusade',
'/cast !Wake of Ashes',
"/cast Divine Storm",
PostMacro = [[
/use [combat]13
/use [combat]14
]],
}


-------------------
-- Holy - 65
-------------------

Sequences['DB_HolyDeeps'] = {
specID = 65,
author = "Draik",
helpTxt = "Holy DPS levelling macro - 3131123.",
icon = "Ability_Paladin_InfusionofLight",
PreMacro = [[
/targetenemy [noharm][dead]
]],
'/cast Judgment',
'/cast Crusader Strike',
'/cast Consecration',
'/cast [combat]!Avenging Wrath',
'/cast !Blinding Light',
'/cast Holy Shock',
'/cast Divine Protection',
PostMacro = [[
/use [combat]13
/use [combat]14
]],
}


Sequences['DANB-防骑'] = {
specID = 1263,
author="逐日者-桩子",
helpTxt = 'Talents:32x3112',
PreMacro = [[
/targetenemy [noharm][dead]
/cast 正义盾击
]],
"/cast 奉献",
"/cast 守护之光",
"/cast 复仇者之盾",
"/castsequence reset=6/combat/target 审判,正义之锤,正义之锤",
PostMacro = [[
/startattack
]],
}


Sequences['DANB-惩骑'] = {
specID = 2263,
author="逐日者-桩子",
helpTxt = 'Talents:32x3112',
PreMacro = [[
/targetenemy [noharm][dead]
/cast 征伐
]],
"/castsequence reset=6/combat/target 十字军打击,愤怒之剑,十字军打击,十字军打击,审判,处决宣判,愤怒之剑,十字军打击,圣殿骑士的裁决,十字军打击,圣殿骑士的裁决,愤怒之剑,审判,十字军打击,圣殿骑士的裁决",
PostMacro = [[
/startattack
]],
}


Sequences['DANB-惩骑群'] = {
specID = 2263,
author="逐日者-桩子",
helpTxt = 'Talents:32x3112',
PreMacro = [[
/targetenemy [noharm][dead]
/cast 征伐
]],
"/castsequence reset=6/combat/target 十字军打击,愤怒之剑,十字军打击,十字军打击,审判,神圣风暴,愤怒之剑,十字军打击,神圣风暴,十字军打击,神圣风暴,愤怒之剑,审判,十字军打击,神圣风暴",
PostMacro = [[
/startattack
]],
}

