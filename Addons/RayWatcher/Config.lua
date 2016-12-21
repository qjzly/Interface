----------------------------------------------------------------------------------------------------
-- name = "目标debuff",
-- setpoint = { "LEFT", UIParent, "CENTER", 198, -190 }, setpoint = positions.pvp_player_icon,
-- direction = "UP",
-- iconSide = "LEFT",
-- mode = "BAR", 
-- size = 36,
-- barWidth = 200,				
--	{spellID = 8050, unitId = "target", caster = "target", filter = "DEBUFF"},
--	{ spellID = 18499, filter = "CD" },
--	{ itemID = 56285, filter = "CD" },

-- name = "其他监视",
-- direction = "UP",
-- setpoint = {unpack(other)},
-- mode = "BAR",
-- barWidth = 150,
-- size = 25,
---------------------------------------------------------------------------------------------------

local _, ns = ...

ns.font = "Interface\\AddOns\\RayWatcher\\Media\\ROADWAY.TTF"
ns.fontsize = 16
ns.fontflag = 'OUTLINE'

local positions = {
    player_buff_icon    = { "BOTTOMRIGHT", "ElvUF_Player", "TOPRIGHT", 0, 13 },	-- "玩家buff&debuff"
    target_buff_icon    = { "BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 13 },	-- "目标buff&debuff"
    -- player_proc_icon    = { "BOTTOMRIGHT", "ElvUF_Player", "TOPRIGHT", 0, 43 },	-- "玩家重要buff&debuff"
    -- target_proc_icon    = { "BOTTOMLEFT", "ElvUF_Target", "TOPLEFT", 0, 43 },	-- "目标重要buff&debuff"
    focus_buff_icon     = { "BOTTOMLEFT", "ElvUF_Focus", "TOPLEFT", 0, 10 },	-- "焦点buff&debuff"
    player_special_icon = { "TOPRIGHT", "ElvUF_Player", "BOTTOMRIGHT", 0, -4 }, -- "玩家特殊buff&debuff"
    pvp_player_icon     = { "BOTTOM", UIParent, "BOTTOM", -82, 382 }, -- "玩家PVPDebuff"
    pvp_target_icon     = { "BOTTOM", UIParent, "BOTTOM", 82, 382 }, -- "目标PVPBuff"
	player_cd    = {"CENTER", UIParent, "CENTER", -185, -242},  --name = "玩家技能CD"
	player_other    = {"CENTER", UIParent, "CENTER", -180, 90},  --name = "其他监视"
}

ns.watchers ={
	["DRUID"] = {
		{
			name = "玩家buff",
			direction = "LEFT",
			setpoint =  positions.player_buff_icon,
			size = 36,
                --月光增效
                { spellID = 164547, unitId = "player", caster = "player", filter = "BUFF" },
                --日光增效
                { spellID = 164545, unitId = "player", caster = "player", filter = "BUFF" },

				-- 激活
				{ spellID = 29166, unitId = "player", caster = "player", filter = "BUFF" },
				
				-- 节能施法
				{ spellID = 16870, unitId = "player", caster = "player", filter = "BUFF" },
				-- 生命绽放
				{ spellID = 33763, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神器
				{ spellID = 208253, unitId = "player", caster = "player", filter = "BUFF" },
				-- 野性成长
				{ spellID = 48438, unitId = "player", caster = "player", filter = "BUFF" },
				-- 回春術
				{ spellID = 774, unitId = "player", caster = "player", filter = "BUFF" },
				-- 癒合
				{ spellID = 8936, unitId = "player", caster = "player", filter = "BUFF" },
				-- 回春術(萌芽)
				{ spellID = 155777, unitId = "player", caster = "player", filter = "BUFF" },
				-- 化身：生命之树
				{ spellID = 117679, unitId = "player", caster = "player", filter = "BUFF" },
				
				-- 狂暴猫
				{ spellID = 106951, unitId = "player", caster = "player", filter = "BUFF" },
				-- 野蛮咆哮(猫)
				{ spellID = 52610, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂奔怒吼
				{ spellID = 77761, unitId = "player", caster = "player", filter = "BUFF" },

				-- 树皮术
				{ spellID = 22812, unitId = "player", caster = "player", filter = "BUFF" },
				-- 铁木树皮
				{ spellID = 102342, unitId = "player", caster = "player", filter = "BUFF" },
				-- 乌索尔的印记
				{ spellID = 192083, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神器：沉睡者之怒
				{ spellID = 200851, unitId = "player", caster = "player", filter = "BUFF" },
				-- 铁鬃
				{ spellID = 192081, unitId = "player", caster = "player", filter = "BUFF" },
				-- 生存本能
				{ spellID = 61336, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂暴恢复
				{ spellID = 22842, unitId = "player", caster = "player", filter = "BUFF" },
				-- 化身：乌索克的守护者
				{ spellID = 102558, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint =positions.target_buff_icon,
			size = 36,
				-- 挫志咆哮(熊)
				{ spellID =    99, unitId = "target", caster = "player", filter = "DEBUFF" },
				
				-- 野性成长
				{ spellID = 48438, unitId = "target", caster = "player", filter = "BUFF" },
				-- 生命之种
				{ spellID = 48504, unitId = "target", caster = "player", filter = "BUFF" },
				-- 塞纳里奥结界
				{ spellID = 102351, unitId = "target", caster = "player", filter = "BUFF" },
				-- 生命绽放
				{ spellID = 33763, unitId = "target", caster = "player", filter = "BUFF" },
				-- 回春術
				{ spellID = 774, unitId = "target", caster = "player", filter = "BUFF" },
				-- 癒合
				{ spellID = 8936, unitId = "target", caster = "player", filter = "BUFF" },
				-- 回春術(萌芽)
				{ spellID = 155777, unitId = "target", caster = "player", filter = "BUFF" },
				-- 缠绕
				{ spellID = 339, unitId = "target", caster = "player", filter = "BUFF" },
				-- 群体缠绕
				{ spellID = 102359, unitId = "target", caster = "player", filter = "BUFF" },
				-- 激活
				{ spellID = 29166, unitId = "target", caster = "player", filter = "BUFF" },
				-- 树皮术
				{ spellID = 22812, unitId = "target", caster = "player", filter = "BUFF" },
				-- 铁木树皮
				{ spellID = 102342, unitId = "target", caster = "player", filter = "BUFF" },
				
				-- 割裂(猫)
				{ spellID =  1079, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 斜掠(猫)
				{ spellID =  1822, unitId = "target", caster = "player", filter = "DEBUFF" },			
				-- 月火术
				{ spellID =  164812, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 阳炎术
				{ spellID =  164815, unitId = "target", caster = "player", filter = "DEBUFF" },

				-- 野蛮咆哮(猫)
				{ spellID = 52610, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 阳炎术
				{ spellID = 93402, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割碎
				{ spellID = 33878, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 36,
				-- 
				-- { spellID = 33891, filter = "CD" },
		},
	},
	["HUNTER"] = {
			{
			name = "玩家buff",
			direction = "LEFT",
			setpoint = positions.player_buff_icon,
			size = 36,
				-- 治疗宠物
				{ spellID =   136, unitId = "pet", caster = "player", filter = "BUFF"},
				-- 凶暴野兽
				{ spellID =   120694, unitId = "player", caster = "player", filter = "BUFF"},
				-- 顺劈
				{ spellID =   118455, unitId = "pet", caster = "player", filter = "BUFF"},
				-- 百发百中
				{ spellID =  193526, unitId = "player", caster = "player", filter = "BUFF" },
				--灵龟守护
				{ spellID =  186265, unitId = "player", caster = "player", filter = "BUFF" },	
				-- 误导
				{ spellID = 35079, unitId = "player", caster = "player", filter = "BUFF" },
				-- 野性守护
				{ spellID = 193530, unitId = "player", caster = "player", filter = "BUFF" },
				-- 荷枪实弹
				{ spellID = 194594, unitId = "player", caster = "player", filter = "BUFF" },
				-- 伪装
				{ spellID = 199483, unitId = "player", caster = "player", filter = "BUFF" },
				-- 猫鼬之怒
				{ spellID = 190931, unitId = "player", caster = "player", filter = "BUFF" },
				-- 狂野怒火
				{ spellID = 19574, unitId = "player", caster = "player", filter = "BUFF" },
				-- 假死
				{ spellID = 5384, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint =positions.target_buff_icon,
			size = 36,
			    -- 猎人印记
				{ spellID =  185365 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 震荡射击
				{ spellID = 5116 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 易伤
				{ spellID = 187131 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 夺命黑鸭
				{ spellID = 131894 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 黑蝕箭
				{ spellID = 194599, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 猫鼬撕咬
				{ spellID = 190931, unitId = "target", caster = "player", filter = "DEBUFF" },
				--裂痕
				{ spellID = 185855, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 翼龙钉刺
				{ spellID = 19386 ,unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 胁迫
				{ spellID = 24394 ,unitId = "target", caster = "pet", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 38,
			
		},
	},
	["MAGE"] = {
		{
			name = "玩家buff",
			direction = "LEFT",
			setpoint =positions.player_buff_icon,
			size = 36,
                -- 奥术强化
				{ spellID = 12042, unitId = "player", caster = "player", filter = "BUFF" },
				-- 唤醒
				{ spellID = 12051, unitId = "player", caster = "player", filter = "BUFF" },
				-- 奥术冲击
				{ spellID = 36032, unitId = "player", caster = "player", filter = "DEBUFF" },				
				-- 寒冰指
				{ spellID = 44544, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法术连击
				{ spellID = 44448, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法术连击
				{ spellID = 48108, unitId = "player", caster = "player", filter = "BUFF" },
				-- 奥术飞弹!
				{ spellID = 79683, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灸灼
				{ spellID = 87023, unitId = "player", caster = "player", filter = "BUFF" },
				-- 隱形術
				{ spellID =    66, unitId = "player", caster = "player", filter = "BUFF" },
				-- 隱形術
				{ spellID = 32612, unitId = "player", caster = "player", filter = "BUFF" },
				-- 幻鏡之像
				{ spellID = 55342, unitId = "player", caster = "player", filter = "BUFF" },
				-- 寒冰护体
				{ spellID = 11426, unitId = "player", caster = "player", filter = "BUFF" },
				-- 寒冰屏障
				{ spellID = 45438, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法力护盾
				{ spellID =  1463, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint = positions.target_buff_icon,
			size = 36,
    			-- 点燃
				{ spellID = 12654 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 减速
				{ spellID = 31589 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 活动炸弹
				{ spellID = 44457 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 寒冰箭
				{ spellID = 116 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 冰霜新星
				{ spellID = 122 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 燃烧
				{ spellID = 83853 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 炎爆术
				{ spellID = 11366 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 霜火之箭
				{ spellID = 44614 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 变形术
				{ spellID = 118 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 龙息
				{ spellID = 31661 ,unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 虚空风暴
				{ spellID = 114923 ,unitId = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 唤醒
				{ spellID = 12051, filter = "CD" },
				-- 秘法强化
				{ spellID =  12042, filter = "CD" },
				-- 燃火
				{ spellID = 11129, filter = "CD" },
		},
	},
	["WARRIOR"] = {
		{
			name = "玩家Buff",
			direction = "LEFT",
			setpoint = positions.player_buff_icon,
			size = 36,
				-- 盾墙(防御姿态)
				{ spellID =   871, unitId = "player", caster = "player", filter = "BUFF" },
				-- 盾牌格挡(防御姿态)
				{ spellID =  2565, unitId = "player", caster = "player", filter = "BUFF" },				
				-- 横扫攻击(战斗,狂暴姿态)
				{ spellID = 12328, unitId = "player", caster = "player", filter = "BUFF" },
				-- 破釜沉舟
				{ spellID = 12975, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血之狂热
				{ spellID = 16491, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法术发射(战斗,防御姿态)
				{ spellID = 23920, unitId = "player", caster = "player", filter = "BUFF" },
				-- 胜利
				{ spellID = 32216, unitId = "player", caster = "player", filter = "BUFF" },
				-- 血脉喷张
				{ spellID = 46916, unitId = "player", caster = "player", filter = "BUFF" },
				-- 剑盾猛攻
				{ spellID = 50227, unitId = "player", caster = "player", filter = "BUFF" },
				-- 猝死
				{ spellID = 55694, unitId = "player", caster = "player", filter = "BUFF" },
				-- 主宰
				{ spellID = 65156, unitId = "player", caster = "player", filter = "BUFF" },
		  },
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint =positions.target_buff_icon,
			size = 36,
    			-- 冲锋击昏
    			{ spellID = 7922, unitId = "target", caster = "all", filter = "DEBUFF" },
    			-- 震荡波
    			{ spellID = 46968, unitId = "target", caster = "all", filter = "DEBUFF" },
    			-- 断筋
    			{ spellID = 1715, unitId = "target", caster = "all", filter = "DEBUFF" },
    			-- 破甲攻击
    			{ spellID = 7386, unitId = "target", caster = "all", filter = "DEBUFF" },
    			-- 雷霆一击
    			{ spellID = 6343, unitId = "target", caster = "player", filter = "DEBUFF" },
    			-- 挫志怒吼
    			{ spellID = 1160, unitId = "target", caster = "player", filter = "DEBUFF" },
    		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 破釜沉舟
				{ spellID = 12975, filter = "CD" },
				-- 震荡波
				{ spellID = 25425, filter = "CD" },
		},
    },
	["DEMONHUNTER"]	= {
		{
		    name = "玩家buff",
			direction = "LEFT",
			setpoint =  positions.player_buff_icon,
			size = 36,
                -- 恶魔变形（浩劫）
                { spellID = 187827, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔变形（复仇）
                { spellID = 162264, unitId = "player", caster = "player", filter = "BUFF" },
                -- 强化结界
                { spellID = 218256, unitId = "player", caster = "player", filter = "BUFF" },
                -- 恶魔尖刺
                { spellID = 203819, unitId = "player", caster = "player", filter = "BUFF" },
                -- 势如破竹
                { spellID = 208628, unitId = "player", caster = "player", filter = "BUFF" },
				-- 疾影
				{ spellID =   212800, unitId = "player", caster = "player", filter = "BUFF" },
                -- 献祭光环
                { spellID = 178740, unitId = "player", caster = "player", filter = "BUFF" },
                -- 幽灵视觉
                { spellID = 188501, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灵魂壁障
                { spellID = 227225, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灵魂残片
                { spellID = 203981, unitId = "player", caster = "player", filter = "BUFF" },
                -- 黑暗
                { spellID = 209426, unitId = "player", caster = "all", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint =positions.target_buff_icon,
			size = 36,
                -- 烈焰咒符
                { spellID = 204598, unitId = "target", caster = "player", filter = "DEBUFF" },
                -- 悲苦咒符
                { spellID = 207685, unitId = "target", caster = "all", filter = "DEBUFF" },
                -- 烈火烙印
                { spellID = 207744, unitId = "target", caster = "player", filter = "DEBUFF" },

		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
			    -- 
				--{ spellID = 16188, filter = "CD" },
		},
	},
	["SHAMAN"] = {
		{
			name = "玩家buff",
			direction = "LEFT",
			setpoint =  positions.player_buff_icon,
			size = 36,

				-- 潮汐奔涌
				{ spellID = 53390, unitId = "player", caster = "player", filter = "BUFF" },
				-- 灵魂行者的恩赐
				{ spellID = 79206, unitId = "player", caster = "player", filter = "BUFF" },
		       	-- 生命释放
				{ spellID = 73685, unitId = "player", caster = "player", filter = "BUFF" },
		    	-- 激流
				{ spellID = 61295, unitId = "player", caster = "player", filter = "BUFF" },
				-- 根基图腾
				{ spellID =  8178, unitId = "player", caster = "player", filter = "BUFF" },
				-- 石壁图腾
				{ spellID =  114893, unitId = "player", caster = "player", filter = "BUFF" },
				-- 毁灭闪电
				{ spellID =  187878, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint =positions.target_buff_icon,
			size = 36,

				-- 冰霜震击
				{ spellID =  196840, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 烈焰震击
				{ spellID =  188389, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 风暴打击
				{ spellID = 17364, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 灼热烈焰
				{ spellID = 77661, unitId = "target", caster = "player", filter = "DEBUFF"},
			    -- 妖术
				{ spellID = 51514, unitId = "target", caster = "player", filter = "DEBUFF"},
			    -- 激流
				{ spellID = 61295, unitId = "target", caster = "player", filter = "BUFF"}, 
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
			    -- 自然迅捷
				--{ spellID = 16188, filter = "CD" },
		},
	},
	["PALADIN"] = {
		{
			name = "玩家buff",
			direction = "LEFT",
			setpoint =  positions.player_buff_icon,
			size = 36,
				-- 圣佑术
				{ spellID =   498, unitId = "player", caster = "player", filter = "BUFF" },
				-- 圣盾术
				{ spellID =   642, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神恩术
				{ spellID = 31842, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣之盾
				{ spellID = 20925, unitId = "player", caster = "player", filter = "BUFF" },
				-- 复仇之怒
				{ spellID = 31884, unitId = "player", caster = "player", filter = "BUFF" },
				-- 炙热防御者
				{ spellID = 31850, unitId = "player", caster = "player", filter = "BUFF" },
				-- 纯洁审判(等级3)
				{ spellID = 53657, unitId = "player", caster = "player", filter = "BUFF" },
				-- 圣光灌注(等级2)
				{ spellID = 54149, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣恳求
				{ spellID = 54428, unitId = "player", caster = "player", filter = "BUFF" },
				-- 战争艺术
				{ spellID = 59578, unitId = "player", caster = "player", filter = "BUFF" },
				-- 异端裁决
				{ spellID = 84963, unitId = "player", caster = "player", filter = "BUFF" },
				-- 大十字军 (复仇盾)
				{ spellID = 85043, unitId = "player", caster = "player", filter = "BUFF" },
				-- 远古列王守卫
				{ spellID = 86659, unitId = "player", caster = "player", filter = "BUFF" },
				-- 破晓
				{ spellID = 88819, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神圣意志
				{ spellID = 90174, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint = positions.target_buff_icon,
			size = 36,
				-- 制裁之锤
				{ spellID =   853, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 神圣愤怒
				{ spellID =  2812, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 忏悔
				{ spellID = 20066, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 辩护
				{ spellID = 26017, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 圣光道标
				{ spellID = 53563, unitId = "target", caster = "player", filter = "BUFF"},
				-- 牺牲之手
				{ spellID =  6940, unitId = "target", caster = "player", filter = "BUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 十字军打击
				{ spellID = 35395, filter = "CD" },
		},
	},
	["PRIEST"] = {
		{
			name = "玩家buff",
			direction = "LEFT",
			setpoint =  positions.player_buff_icon,
			size = 36,
				-- 消散
				{ spellID = 47585, unitId = "player", caster = "player", filter = "BUFF" },
				
				-- 愈合祷言
				{ spellID = 41635, unitId = "player", caster = "player", filter = "BUFF" },
                -- 真言术：盾
				{ spellID =17, unitId = "player", caster = "player", filter = "BUFF"},
				-- 恢复
				{ spellID = 139, unitId = "player", caster = "player", filter = "BUFF" },
				-- 守护圣灵
				{ spellID = 47788, unitId = "player", caster = "player", filter = "BUFF" },
				-- 预支时间
				{ spellID = 59889, unitId = "player", caster = "player", filter = "BUFF" },
				-- 漸隱術
				{ spellID =586, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神性火焰
				{ spellID = 99132, unitId = "player", caster = "player", filter = "BUFF" },
				-- 真言术:障
				{ spellID = 81782, unitId = "player", caster = "player", filter = "BUFF" },
				--5.0免费的心爆
				{ spellID = 124430, unitId = "player", caster = "player", filter = "BUFF" },
				},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint = positions.target_buff_icon,
			size = 36,
				-- 吸血鬼之触
				{ spellID = 34914, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 暗言术:痛
				{ spellID =   589, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 噬灵疫病
				{ spellID =  2944, unitId = "target", caster = "player", filter = "DEBUFF" },

				-- 愈合祷言
				{ spellID = 41635, unitId = "target", caster = "player", filter = "BUFF" },
				-- 守护圣灵
				{ spellID = 47788, unitId = "target", caster = "player", filter = "BUFF" },
				--光明回想
				{ spellID = 77489, unitId = "target", caster = "player", filter = "BUFF" },
				-- 恢复
				{ spellID = 139, unitId = "target", caster = "player", filter = "BUFF" },
				-- 聖言術:寧 
				{ spellID = 88684, unitId = "target", caster = "player", filter = "BUFF" },
				-- 聖言術:譴
				{ spellID = 88625, unitId = "target", caster = "player", filter = "DEBUFF"},
                -- 真言术：盾
				{ spellID =    17, unitId = "target", caster = "player", filter = "BUFF"},
				-- 痛苦压制
				{ spellID = 44416, unitId = "target", caster = "player", filter = "BUFF"},
				},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			-- mode = "BAR",
			-- barWidth = 150,
			size = 28,
				--CD
				--愈合祷言
				{ spellID = 33076, filter = "CD" },
		},
	},
	["WARLOCK"]={
		{
			name = "玩家Buff",
			direction = "LEFT",
			setpoint = positions.player_buff_icon,
			mode = "ICON",
			size = 36,
				-- 暗影冥思
				{ spellID = 17941, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			setpoint = positions.target_buff_icon,
			direction = "RIGHT",
			mode = "ICON",
			size = 36,
				-- 腐蚀术
				{ spellID =   146739, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 虹吸
				{ spellID =   63106, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 末日灾祸
				{ spellID =   603, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 痛苦灾祸
				{ spellID =   980, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 烧尽
				{ spellID = 29722, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 献祭
				{ spellID = 157736, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 痛苦无常
				{ spellID = 30108, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 鬼影缠身
				{ spellID = 36181, unitId = "target", caster = "player", filter = "DEBUFF"},
				-- 浩劫灾祸
				{ spellID = 80240, unitId = "target", caster = "player", filter = "DEBUFF"},
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 混乱之箭
				{ spellID = 135664, filter = "CD" },
		},
	},
	["ROGUE"] = {
		{
			name = "玩家Buff",
			direction = "LEFT",
			setpoint = positions.player_buff_icon,
			size = 36,
				-- 佯攻
				{ spellID =  1966, unitId = "player", caster = "player", filter = "BUFF" },
				-- 切割
				{ spellID =  5171, unitId = "player", caster = "player", filter = "BUFF" },
				-- 毒伤
				{ spellID = 32645, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嫁祸诀窍
				{ spellID = 57934, unitId = "player", caster = "player", filter = "BUFF" },			
				-- 灭绝
				{ spellID = 58427, unitId = "player", caster = "player", filter = "BUFF" },
				-- 嫁祸诀窍
				{ spellID = 59628, unitId = "player", caster = "player", filter = "BUFF" },
				-- 能量刺激
				{ spellID = 13750, unitId = "player", caster = "player", filter = "BUFF" },
		
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint = positions.target_buff_icon,
			size = 36,
				-- 肾击
				{ spellID =   408, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 绞喉
				{ spellID =   703, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 偷袭
				{ spellID =  1833, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 割裂
				{ spellID =  1943, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 仇杀
				{ spellID = 79140, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 殺戮盛筵
				--{ spellID = 51690, filter = "CD" },
		},
	},
	["DEATHKNIGHT"] = {
		{
			name = "玩家Buff",
			direction = "LEFT",
			setpoint = positions.player_buff_icon,
			size = 36,
				-- 反魔法护罩
				{ spellID = 48707, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冰封之韧
				{ spellID = 48792, unitId = "player", caster = "player", filter = "BUFF" },
				-- 巫妖之躯
				{ spellID = 49039, unitId = "player", caster = "player", filter = "BUFF" },
				-- 杀戮机器
				{ spellID = 51124, unitId = "player", caster = "player", filter = "BUFF" },
				-- 吸血鬼之血
				{ spellID = 55233, unitId = "player", caster = "player", filter = "BUFF" },
				-- 冰冻之雾
				{ spellID = 59052, unitId = "player", caster = "player", filter = "BUFF" },
				-- 赤色天灾
				{ spellID = 81141, unitId = "player", caster = "player", filter = "BUFF" },
				-- 符文刃舞
				{ spellID = 81256, unitId = "player", caster = "player", filter = "BUFF" },
		},
		{
			name = "目标debuff",
			direction = "RIGHT",
			setpoint = positions.target_buff_icon,
			size = 36,
				-- 血之疫病
				{ spellID = 55078, unitId = "target", caster = "player", filter = "DEBUFF" },
				-- 冰霜疫病
				{ spellID = 55095, unitId = "target", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 冰封之韧
				--{ spellID = 36792, filter = "CD" },
		},
	},
	["MONK"] = { 
		{ 
			name = "玩家buff", 
			direction = "LEFT", 
			setpoint =positions.player_buff_icon, 
			size = 36, 
				-- 禅意珠
				{ spellID = 124081, unitId = "player", caster = "player", filter = "BUFF" },
				-- 氤氲之雾
				{ spellID = 132120, unitId = "player", caster = "player", filter = "BUFF" },
				-- 壮胆酒
				{ spellID = 120954, unitId = "player", caster = "player", filter = "BUFF" },
				-- 翻地滚
				{ spellID = 119085, unitId = "player", caster = "player", filter = "BUFF" },
				-- 复苏之雾
				{ spellID = 119611, unitId = "player", caster = "player", filter = "BUFF" },
				-- 作茧缚命
				{ spellID = 116849, unitId = "player", caster = "player", filter = "BUFF" },
				-- 雷光聚神茶
				{ spellID = 116680, unitId = "player", caster = "player", filter = "BUFF" },
				-- 力贯千钧
				{ spellID = 129914, unitId = "player", caster = "player", filter = "BUFF" },
				-- 飘渺酒
				{ spellID = 115308, unitId = "player", caster = "player", filter = "BUFF" },
				-- 金钟罩
				{ spellID = 115295, unitId = "player", caster = "player", filter = "BUFF" },
				-- 金钟罩
				{ spellID = 118604, unitId = "player", caster = "player", filter = "BUFF" },
				-- 金钟罩(雕文)
				{ spellID = 123402, unitId = "player", caster = "player", filter = "BUFF" },
				-- 虎眼酒(蒸馏)
				{ spellID = 116740, unitId = "player", caster = "player", filter = "BUFF" },
				-- 豪能酒
				{ spellID = 115288, unitId = "player", caster = "player", filter = "BUFF" },
				-- 活力之雾
				{ spellID = 118674, unitId = "player", caster = "player", filter = "BUFF" },
				-- 散魔功
				{ spellID = 122783, unitId = "player", caster = "player", filter = "BUFF" },
				-- 碧玉疾风
				{ spellID = 123664, unitId = "player", caster = "player", filter = "BUFF" },
				-- 业报之触
				{ spellID = 125174, unitId = "player", caster = "player", filter = "BUFF" },
				-- 禅意聚神
				{ spellID = 124488, unitId = "player", caster = "player", filter = "BUFF" },
				-- 躯不坏
				{ spellID = 122278, unitId = "player", caster = "player", filter = "BUFF" },
				-- 法力茶
				{ spellID = 115867, unitId = "player", caster = "player", filter = "BUFF" },
			    -- 虎眼酒
				{ spellID = 125195, unitId = "player", caster = "player", filter = "BUFF" },
			    -- 飘渺酒
				{ spellID = 128939, unitId = "player", caster = "player", filter = "BUFF" },
				-- 强力金钟罩
				{ spellID = 118636, unitId = "player", caster = "player", filter = "BUFF" },
				-- 和平之环
				{ spellID = 116844, unitId = "player", caster = "player", filter = "BUFF" },
				-- 真气破
				{ spellID = 157681, unitId = "player", caster = "player", filter = "BUFF" },
				-- 屏气凝神
				{ spellID = 152173, unitId = "player", caster = "player", filter = "BUFF" },
				-- 禅意聚神
				{ spellID = 159546, unitId = "player", caster = "player", filter = "BUFF" },
		}, 
		{ 
			name = "目标debuff", 
			direction = "RIGHT", 
			setpoint = positions.target_buff_icon,
			size = 36, 
			    -- 抚慰之雾
				{ spellID =  115175, unitId = "target", caster = "player", filter = "BUFF"},
				-- 氤氲之雾
				{ spellID =  132120, unitId = "target", caster = "player", filter = "BUFF"},
				-- 碎玉闪电
				{ spellID =  117952, unitId = "target", caster = "player", filter = "DEBUFF"},

		},
		{
			name = "玩家技能CD",
			direction = "RIGHT",
			setpoint = positions.player_cd,
			size = 22,
				-- 壮胆酒
				{spellID = 115203, filter = "CD" },
		},
		{
			name = "其他监视",
			direction = "UP",
			setpoint = positions.player_other,
			mode = "BAR",
			barWidth = 150,
			size = 25,
		    	-- 复仇
				{ spellID = 132365, unitId = "player", caster = "player", filter = "BUFF" },
				-- 探云鞭
				{ spellID = 117431, unitId = "player", caster = "player", filter = "BUFF" },
				-- 探云鞭，输出
				{ spellID = 123231, unitId = "player", caster = "player", filter = "BUFF" },
				-- 探云鞭，坦克
				{ spellID = 123232, unitId = "player", caster = "player", filter = "BUFF" },
				-- 探云鞭，治疗
				{ spellID = 123234, unitId = "player", caster = "player", filter = "BUFF" },
				-- 轻度醉拳
			    { spellID = 124275, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 猛虎之力
				{ spellID = 125359, unitId = "player", caster = "player", filter = "BUFF" },
				-- 抚慰之雾
				{ spellID = 115175, unitId = "player", caster = "player", filter = "BUFF" },
				-- 猛虎连击
				{ spellID = 120273, unitId = "player", caster = "player", filter = "BUFF" },
				-- 醉八仙
				{ spellID = 138233, unitId = "player", caster = "player", filter = "BUFF" },
				-- 神鹤狂热
				{ spellID = 127722, unitId = "player", caster = "player", filter = "BUFF"},
				-- 抚慰之雾雕文
				{ spellID = 159537, unitId = "player", caster = "player", filter = "BUFF"},
		},
		{
			name = "醉拳",
			direction = "RIGHT",
			setpoint = {"CENTER", UIParent, "CENTER", -180, 90},
			size = 50,
			-- 中度醉拳
			{ spellID = 124274, unitId = "player", caster = "player", filter = "DEBUFF" },
		    -- 重度醉拳
			{ spellID = 124273, unitId = "player", caster = "player", filter = "DEBUFF" },
			-- 英勇之源钻(刚毅)
			{ spellID =  137593, unitId = "player", caster = "all", filter = "BUFF" },
			-- 英勇之源钻(清澈)
			{ spellID =  137331, unitId = "player", caster = "all", filter = "BUFF" },
			-- 活血化瘀
			{ spellID =  138237, unitId = "player", caster = "all", filter = "BUFF" },
			-- 赤精之魂
			{ spellID =  146200, unitId = "player", caster = "all", filter = "BUFF" },
		},
	}, 
	["ALL"]={
		{
			name = "玩家PVPDebuff",
			direction = "RIGHT",
			setpoint = positions.pvp_player_icon,
			size = 42,
                -- 撕扯
		        { spellID = 47361, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 绞袭
				{ spellID = 47476, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 寒冰锁链
				{ spellID = 45524, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 猛击
				{ spellID = 5211, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 旋风
				{ spellID = 33786, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 割碎
				{ spellID = 22570, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 纠缠根须
				{ spellID = 339, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 台风
				{ spellID = 61391, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰冻陷阱
				{ spellID = 3355, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 胁迫
				{ spellID = 24394, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 翼龙钉刺
				{ spellID = 19386, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 震荡射击
				{ spellID = 5116, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰霜陷阱
				{ spellID = 13810, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 龙息术
				{ spellID = 31661, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 变形术
				{ spellID = 118, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰冻术
				{ spellID = 33395, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰霜新星
				{ spellID = 122, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰冻
				{ spellID = 6136, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰锥术
				{ spellID = 120, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 寒冰箭
				{ spellID = 116, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 减速
				{ spellID = 31589, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 制裁之锤
				{ spellID = 853, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 忏悔
				{ spellID = 20066, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 精神控制
				{ spellID = 605, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 心灵惊骇
				{ spellID = 64044, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 心灵尖啸
				{ spellID = 8122, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 沉默
				{ spellID = 15367, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 致盲			
				{ spellID = 2094, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 偷袭
				{ spellID = 1833, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 凿击
				{ spellID = 1776, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 肾击
				{ spellID = 408, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 闷棍
				{ spellID = 6770, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 锁喉 - 沉默
				{ spellID = 1330, unitId = "player", caster = "player", filter = "DEBUFF" },  
				-- 减速药膏
				{ spellID = 3409, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 致命投掷
				{ spellID = 26679, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 妖术
				{ spellID = 51514, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 大地之缚
				{ spellID = 64695, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 地缚术
				{ spellID = 3600, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冰霜震击
				{ spellID = 196840, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 放逐术
				{ spellID = 710, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 死亡缠绕
				{ spellID = 6789, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 恐惧
				{ spellID = 5782, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				{ spellID = 118699, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 恐惧嚎叫
				{ spellID = 5484, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 诱惑
				{ spellID = 6358, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 暗影之怒
				{ spellID = 30283, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 冲锋击昏
				{ spellID = 7922, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 破胆怒吼
				{ spellID = 5246, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 震荡波
				{ spellID = 46968, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 断筋
				{ spellID = 1715, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 刺耳怒吼
				{ spellID = 12323, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 战争践踏
				{ spellID = 20549, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 奥术洪流
				{ spellID = 25046, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 变形术(龟)
				{ spellID = 28271, unitId = "player", caster = "player", filter = "DEBUFF" }, 
				-- 分筋错骨
				{ spellID = 115078, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 扫堂腿
				{ spellID = 119381, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 金刚镇
				{ spellID = 116095, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 怒雷破
				{ spellID = 120086, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 旋火冲
				{ spellID = 123407, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 镇山掌
				{ spellID = 107079, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 恐惧
				{ spellID = 118699, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 迷惑
				{ spellID = 115268, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 冰霜之环
				{ spellID =  82691, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 业报之触
				{ spellID = 122470, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 盲目之光
				{ spellID = 105421, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 破胆怒吼
				{ spellID = 5246, unitId = "player", caster = "player", filter = "DEBUFF" },
				-- 和平之环
				{ spellID = 140023, unitId = "player", caster = "player", filter = "DEBUFF" },
		},
		{
			name = "药水饰品减伤等Buff",
			direction = "LEFT",
			setpoint = positions.player_special_icon,
			size = 36,
			
                --飾品
                -- PvP 飾品 (生命上限)
                { spellID = 126697, unitId = "player", caster = "all", filter = "BUFF" },
                -- PvP 飾品 (全能)
                { spellID = 170397, unitId = "player", caster = "all", filter = "BUFF" },
                -- 炼金 飾品 (敏捷)
                { spellID = 60233, unitId = "player", caster = "all", filter = "BUFF" },

                --錮法索銀指環
                -- 大法師的白熱光 (智力)
                { spellID = 177159, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大法師的白熱光 (力量)
                { spellID = 177160, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大法師的白熱光 (敏捷)
                { spellID = 177161, unitId = "player", caster = "player", filter = "BUFF" },

                --錮法符文指環
                -- 大法師的白熱強光 (智力)
                { spellID = 177176, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大法師的白熱強光 (力量)
                { spellID = 177175, unitId = "player", caster = "player", filter = "BUFF" },
                -- 大法師的白熱強光 (敏捷)
                { spellID = 177172, unitId = "player", caster = "player", filter = "BUFF" },

                --橙色戒指
                -- 尼萨姆斯 (全见者尼萨姆斯)
                { spellID = 187616, unitId = "player", caster = "player", filter = "BUFF" },
                -- 萨克图斯 (不动之印萨克图斯)
                { spellID = 187617, unitId = "player", caster = "player", filter = "BUFF" },
                -- 伊瑟拉鲁斯 (永恒之赐伊瑟拉鲁斯)
                { spellID = 187618, unitId = "player", caster = "player", filter = "BUFF" },
                -- 索拉苏斯 (岩石之心索拉苏斯)
                { spellID = 187619, unitId = "player", caster = "player", filter = "BUFF" },

                --藥水
                -- Draenic Agility Potion
                { spellID = 156423, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Intellect Potion
                { spellID = 156426, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Strength Potion
                { spellID = 156428, unitId = "player", caster = "player", filter = "BUFF" },
                -- Draenic Armor Potion
                { spellID = 156430, unitId = "player", caster = "player", filter = "BUFF" },
                -- 玉蛟
                { spellID = 105702, unitId = "player", caster = "player", filter = "BUFF" },
                -- 兔妖之咬
                { spellID = 105697, unitId = "player", caster = "player", filter = "BUFF" },
                -- 魔古之力
                { spellID = 105706, unitId = "player", caster = "player", filter = "BUFF" },
                -- 卡法加速
                { spellID = 125282, unitId = "player", caster = "player", filter = "BUFF" },
				
				-- 时间扭曲
				{ spellID = 80353, unitId = "player", caster = "all", filter = "BUFF" },
				-- 嗜血
				{ spellID =  2825, unitId = "player", caster = "all", filter = "BUFF" },
				-- 英勇气概
				{ spellID = 32182, unitId = "player", caster = "all", filter = "BUFF" },
				-- 远古狂乱
				{ spellID = 90355, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 灵魂石
				{ spellID = 20707, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 真言术障
				{ spellID = 81782, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 集结呐喊
				{ spellID = 97463, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 虔诚光环
				{ spellID = 31821, unitId = "player", caster = "all", filter = "BUFF" },  
				-- 反魔法领域
				{ spellID = 145629, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 灵魂链接图腾
				{ spellID = 98008, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 治疗之潮图腾
				{ spellID = 108280, unitId = "player", caster = "all", filter = "BUFF" },
				-- 宁静
				{ spellID = 740, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 神圣赞美诗
				{ spellID = 64844, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 烟雾弹
				{ spellID = 88611, unitId = "player", caster = "all", filter = "BUFF" },
	            -- 专注药水
				{ spellID = 105701, unitId = "player", caster = "all", filter = "BUFF" },
				-- 兔妖之啮
				{ spellID = 105697, unitId = "player", caster = "all", filter = "BUFF" },
				-- 群山药水
				{ spellID = 105698, unitId = "player", caster = "all", filter = "BUFF" },
				-- 青龙药水
				{ spellID = 105702, unitId = "player", caster = "all", filter = "BUFF" },
				-- 魔古之力药水
				{ spellID = 105706, unitId = "player", caster = "all", filter = "BUFF" },
				-- 作茧缚命
				{ spellID =   116849, unitId = "player", caster = "all", filter = "BUFF"},
				-- 牺牲
				{ spellID =   6940, unitId = "player", caster = "all", filter = "BUFF"},
				-- 保护之手
				{ spellID =   1022, unitId = "player", caster = "all", filter = "BUFF"},
				-- 痛苦压制
				{ spellID =   33206, unitId = "player", caster = "all", filter = "BUFF"},
				-- 援护
				{ spellID =   114030, unitId = "player", caster = "all", filter = "BUFF"},
				-- 咆哮
				{ spellID =   106898, unitId = "player", caster = "all", filter = "BUFF"},
				-- 自由
				{ spellID =   1044, unitId = "player", caster = "all", filter = "BUFF"},
				-- 群体法术反射
				{ spellID =   114028, unitId = "player", caster = "all", filter = "BUFF"},
				-- 风行图腾
				{ spellID =   108273, unitId = "player", caster = "all", filter = "BUFF"},
				--偷取时间
				{ spellID =  105785, unitId = "player", caster = "all", filter = "BUFF" },
				--橙色匕首
				{ spellID =  109941, unitId = "player", caster = "all", filter = "BUFF" },
				--风歌(暴击)
				{ spellID =  104509, unitId = "player", caster = "all", filter = "BUFF" }, 
				--风歌(精通)
				{ spellID =  104510, unitId = "player", caster = "all", filter = "BUFF" }, 
				--风歌(急速)
				{ spellID =  104423, unitId = "player", caster = "all", filter = "BUFF" }, 
				--风中的书页
				{ spellID =  126483, unitId = "player", caster = "all", filter = "BUFF" }, 
				--千年腌蛋
				{ spellID =  127915, unitId = "player", caster = "all", filter = "BUFF" }, 
				--空的水果桶
				{ spellID =  126266, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 敏捷(炼金石)
				{ spellID =   60233, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- 宇宙之光
				{ spellID =  126577, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- MoP暗月卡 治疗
				{ spellID =  128987, unitId = "player", caster = "all", filter = "BUFF" }, 
				-- MoP暗月卡 法系DPS
				{ spellID =  128985, unitId = "player", caster = "all", filter = "BUFF" },
				-- 秦太的强化印记
				{ spellID =  126588, unitId = "player", caster = "all", filter = "BUFF" },
				-- 黑光
				{ spellID =  125488, unitId = "player", caster = "all", filter = "BUFF" },
				-- 群星之瓶N
				{ spellID =  126554, unitId = "player", caster = "all", filter = "BUFF" },
				-- 玉魂
				{ spellID =  104993, unitId = "player", caster = "all", filter = "BUFF" },
				-- 舞钢
				{ spellID =  120032, unitId = "player", caster = "all", filter = "BUFF" },
				-- 奥术优雅
				{ spellID =  136086, unitId = "player", caster = "all", filter = "BUFF" },
				-- 容光焕发
				{ spellID =  126640, unitId = "player", caster = "all", filter = "BUFF" },
				-- 无尽能量
				{ spellID =  139189, unitId = "player", caster = "all", filter = "BUFF" },
				-- 刀刃
				{ spellID =  138737, unitId = "player", caster = "all", filter = "BUFF" },
				-- 邪能疯狂
				{ spellID =  138938, unitId = "player", caster = "all", filter = "BUFF" },
				-- 法力风暴
				{ spellID =  138856, unitId = "player", caster = "all", filter = "BUFF" },
				-- 不屈之源钻 
				{ spellID =  137593, unitId = "player", caster = "all", filter = "BUFF" },
				-- 英勇之源钻
				{ spellID =  137331, unitId = "player", caster = "all", filter = "BUFF" },
				-- 赤精之魂
			    { spellID =  146200, unitId = "player", caster = "all", filter = "BUFF" },
				-- 泰坦恢复
			    { spellID =  146314, unitId = "player", caster = "all", filter = "BUFF" },
		},
		{
			name = "目标PVPBuff",
			direction = "LEFT",
			setpoint = positions.pvp_target_icon,
			size = 36,

			    -- 黑暗模拟
				{ spellID = 77606, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 冰封之韧
				{ spellID = 36792, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 法术反射
				{ spellID = 23920, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 光环掌握
				{ spellID = 31821, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 寒冰屏障
				{ spellID = 45438, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 暗影斗篷
				{ spellID = 31224, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 威慑
				{ spellID = 19263, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 反魔法护罩
				{ spellID = 48707, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 巫妖之躯
				{ spellID = 49039, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 自由之手
				{ spellID =  1044, unitId = "target", caster = "all", filter = "BUFF"},
			    -- 根基图腾
				{ spellID =  8178, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 盾墙
				{ spellID =   871, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 破釜沉舟
				{ spellID = 12975, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 集结呐喊
				{ spellID = 97463, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 盾牌格挡
				{ spellID =  2565, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 圣盾术
				{ spellID =   642, unitId = "target", caster = "all", filter = "BUFF"},
		        -- 远古列王守卫
				{ spellID = 86659, unitId = "target", caster = "all", filter = "BUFF"},
				-- 炽热防御者
				{ spellID = 31850, unitId = "target", caster = "all", filter = "BUFF"},
				-- 圣佑术
				{ spellID =   498, unitId = "target", caster = "all", filter = "BUFF"},
				-- 保护之手
				{ spellID =  1022, unitId = "target", caster = "all", filter = "BUFF"},
				-- 牺牲之手
				{ spellID =  6940, unitId = "target", caster = "all", filter = "BUFF"},
				-- 反魔法护罩
				{ spellID = 48707, unitId = "target", caster = "all", filter = "BUFF"},
				-- 反魔法领域
				{ spellID = 50461, unitId = "target", caster = "all", filter = "BUFF"},
				-- 冰封之韧
				{ spellID = 48792, unitId = "target", caster = "all", filter = "BUFF"},
				-- 吸血鬼之血
				{ spellID = 55233, unitId = "target", caster = "all", filter = "BUFF"},
				-- 树皮术
				{ spellID = 22812, unitId = "target", caster = "all", filter = "BUFF"},
				-- 狂暴回复
				{ spellID = 22842, unitId = "target", caster = "all", filter = "BUFF"},
				-- 生存本能
				{ spellID = 61336, unitId = "target", caster = "all", filter = "BUFF"},
				-- 痛苦压制
				{ spellID = 33206, unitId = "target", caster = "all", filter = "BUFF"},
				-- 守护之魂
				{ spellID = 47788, unitId = "target", caster = "all", filter = "BUFF"},
				-- 能量灌注
				{ spellID = 37274, unitId = "target", caster = "all", filter = "BUFF"},
				-- 消散
				{ spellID = 47585, unitId = "target", caster = "all", filter = "BUFF"},
				--吸血鬼的拥抱
				{ spellID = 15286, unitId = "target", caster = "all", filter = "BUFF" },
				-- 佯攻
				{ spellID = 1966, unitId = "target", caster = "all", filter = "BUFF"},
				-- 时间扭曲
				{ spellID = 80353, unitId = "target", caster = "all", filter = "BUFF"},
				-- 嗜血
				{ spellID = 2825, unitId = "target", caster = "all", filter = "BUFF"},
				-- 英勇气概
				{ spellID = 32182, unitId = "target", caster = "all", filter = "BUFF"},
				-- 上古狂乱
				{ spellID = 90355, unitId = "target", caster = "all", filter = "BUFF"},
				-- 壮胆酒
				{ spellID = 120954, unitId = "target", caster = "all", filter = "BUFF"},
				-- 禅意聚神
				{ spellID = 124488, unitId = "target", caster = "all", filter = "BUFF"},
				-- 躯不坏
				{ spellID = 122278, unitId = "target", caster = "all", filter = "BUFF"},
				--业报之触 
				{ spellID = 125174, unitId = "target", caster = "all", filter = "BUFF" },  
				-- 破胆怒吼
				{ spellID = 5246, unitId = "target", caster = "all", filter = "DEBUFF" },
				-- 和平之环
				{ spellID = 116844, unitId = "target", caster = "all", filter = "BUFF" },
		},
		-- {
			-- name = "玩家饰品附魔触发buff",
			-- direction = "LEFT",
			-- setpoint = {unpack(enbuff)},
			-- size = 22,

		-- },
	},
}