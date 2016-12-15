local Sequences = GSMasterSequences -- Dont remove this

------------------
----- Demon Hunter
------------------



Sequences['暗牧123'] = {
StepFunction = GSStaticPriority,
PreMacro = [[
/cast 暗影魔
/cast 吸血鬼的拥抱
/targetenemy [noharm][dead]
]],
        '/cast [nochanneling] 精神鞭笞',
        '/cast 虚空爆发,
        '/cast 心灵震爆,
        '/castsequence reset=10/target/combat 暗言术：痛,吸血鬼之触,',
        '/cast !暗言术：灭',
PostMacro = [[
/use [combat]13
/use [combat]14
/script UIErrorsFrame:Clear()
/console Sound_EnableSFX 1
]],
}