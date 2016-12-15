-- local function defaultcvar()

    -- 截圖品質(10最高) 
    SetCVar("screenshotQuality", 10) 
    -- 截圖格式，tga或jpg 
    SetCVar("screenshotFormat", "jpg") 
    -- 反和諧，0關
    SetCVar("overrideArchive", 0)
	
----------------------------------  界面设置 ------------------------------
	-- 目标锁定
	SetCVar("deselectOnClick", 1) 
	-- 自身高亮
	SetCVar("findYourselfMode", 1) 
	
    -- 垃圾信息过滤
    SetCVar("spamFilter", 0)
	
	
	-- 显示所有NPC姓名
    SetCVar("UnitNameNPC", 1)
    SetCVar("UnitNameHostleNPC", 0)
    SetCVar("UnitNameInteractiveNPC", 0)
    SetCVar("UnitNameFriendlySpecialNPCName", 0)
	
	
    -- 顯示LUA錯誤，1開 
    SetCVar("scriptErrors", 1) 
	-- 水体碰撞
	SetCVar("cameraWaterCollision", 1) 
	
	
    -- 聊天模式
    SetCVar("chatStyle", "classic")
	
	
    -- 鏡頭跟隨地形，爬坡時往上，下坡時往下 
    SetCVar("cameraTerrainTilt", 0)
	-- 从不调整镜头
    SetCVar("cameraSmoothStyle", 0)
	-- 最远镜头
    SetCVar("cameraView", 5)
    -- 自动拾取 1开
    SetCVar("autoLootDefault", 1)

----------------------------------  浮動戰鬥文字 ------------------------------
    -- 浮動戰鬥文字逗點，1是有逗點 
    SetCVar("breakUpLargeNumbers", 0) 
	
    -- 裝備對比，0關 
    SetCVar("alwaysCompareItems", 1) 
	
    -- 顯示經驗值數值，1開 
    SetCVar("xpBarText", 1) 
    -- 進階提示，1開；tooltip的技能說明，關掉就只顯示技能名字了，這個現在默認是開啟的，不用特別去設置它 
    SetCVar("UberTooltips", 1) 
	
    -- 技能隊列，開了才能用自定延遲，1開 
    SetCVar("reducedLagTolerance", 1) 
    -- 自定延遲值，現在默認應該是0了，可設定的範圍是0~400 
    --SetCVar("maxSpellStartRecoveryOffset", 100) 
    -- 切換技能時觸發保險，1開 
    --SetCVar("secureAbilityToggle", 1)  
    -- 按下按鍵時施放技能，1開，這個現在默認是開啟的，不用特別去設置它 
    SetCVar("ActionButtonUseKeyDown", 1) 

    -- 公會頭銜，0關
    SetCVar("UnitNameGuildTitle", 1) 
    -- 目標頭像顯示所有的增益效果，而非只顯示自己的，1開
    SetCVar("noBuffDebuffFilterOnTarget", 1) 
    -- 移動時大地圖半透明，1開
    SetCVar("mapFade", 1) 
	
    -- 背包剩餘空間，0關
    SetCVar("displayFreeBagSlots", 0) 
    -- 個人資源上的閃光動畫效果
    SetCVar("showSpenderFeedback", 1)
    -- 不顯示即將到來的治療，這個設定要重載才會生效
    SetCVar("predictedHealth", 0)
    -- 自動打開拾取紀錄，0關 
    SetCVar("autoOpenLootHistory", 0)
	
    -- 只在滑鼠移過時顯示狀態數字 
    SetCVar("statusText", 0) 
    -- 接任務後自動追蹤直到完成 
    SetCVar("autoQuestWatch", 1) 
    -- 當你達到一個任務地區時會自動切換觀察該任務 
    SetCVar("autoQuestProgress", 1) 

	
	
    -------------------------------- 姓名版  ------------------------------------
	
    -- 姓名板職業染色，1開 
    SetCVar("ShowClassColorInNameplate", 1) 
    -- 在名條下顯示施法條，1開 
    SetCVar("showVKeyCastbar", 1) 
    -- 只在當前目標的名條下顯示施法條，0關 
    SetCVar("showVKeyCastbarOnlyOnTarget", 0) 
    -- 在名條下的施法條顯示法術名稱，1開 
    SetCVar("showVKeyCastbarSpellName", 1) 
	
    -- 名條寬高設定：預設是1，啟用大型名條後，預設是是1.39寬2.7高 
    -- 數值可以自訂，如下例：改成1寬3高 
    -- SetCVar("NamePlateHorizontalScale", 1) 
    -- SetCVar("NamePlateVerticalScale", 3) 
    -- 顯示名條的最遠距離：legion默認是60，以前是40；60太遠了，容易干擾畫面 
    SetCVar("nameplateMaxDistance", 40) 
    -- 使tab的距離和判斷回到legion以前的設定，1是會tab到螢幕外距離內，2是會tab到距離外 
	
    -- tab最近的目標 
    SetCVar("Targetnearestuseold", 1)
    -- 不讓名條貼邊，預設會貼邊的topinset是0.08，bottominset是0.1 
    -- SetCVar("nameplateOtherTopInset", -1) 
    -- SetCVar("nameplateOtherBottomInset", -1)
    -- #不讓名條隨距離而變小，預設minscale是0.8 
    SetCVar("namePlateMinScale", 1) 
    SetCVar("namePlateMaxScale", 1)
	
	
	
--------------------------------  战斗信息文字 ------------------------------------	
	--[[ 如果要關閉浮動戰鬥文字只要使用這兩項 ]]-- 
    -- *新的浮動戰鬥文字運動方式，1往上2往下3弧形 
    SetCVar("floatingCombatTextFloatMode", 0) 
    -- 舊的動戰鬥文字運動方式，0開；使用這項，浮動戰鬥文字就會垂直往上，如同過去 
    --SetCVar("floatingCombatTextCombatDamageDirectionalScale", 1)
	
	--[[ 如果要關閉浮動戰鬥文字只要使用這兩項 ]]-- 
	--對目標傷害，0關；如果要關閉傷害數字，使用這項 
	SetCVar("floatingCombatTextCombatDamage", 0)   
	--對目標治療，0關；如果要關閉治療數字，使用這項 
	SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 0)
	
	--[[ 如果要調整細部(以前的子項目)再使用這些 0=關 1=開 ]]-- 
    -- 寵物對目標傷害 
    SetCVar("floatingCombatTextPetMeleeDamage", 1) 
    SetCVar("floatingCombatTextPetSpellDamage", 1) 
    -- 目標盾提示 
    SetCVar("floatingCombatTextCombatHealingAbsorbTarget", 1) 
    -- 自身得盾/護甲提示 
    SetCVar("floatingCombatTextCombatHealingAbsorbSelf", 0) 
	
    -------------------------------- [[ 進階設定自己的浮動戰鬥文字 ]]    ------------------------------------
    -- 閃招 
    SetCVar("floatingCombatTextDodgeParryMiss", 0) 
    -- 傷害減免 
    SetCVar("floatingCombatTextDamageReduction", 0) 
    -- 周期性傷害 
    SetCVar("floatingCombatTextCombatLogPeriodicSpells", 1) 
    -- 法術警示 
    SetCVar("floatingCombatTextReactives", 1) 
    -- 他人的糾纏效果(例如 誘補(xxxx-xxxx)) 
    SetCVar("floatingCombatTextSpellMechanics", 1) 
    -- 聲望變化 
    SetCVar("floatingCombatTextRepChanges", 0) 
    -- 友方治療者名稱 
    SetCVar("floatingCombatTextFriendlyHealers", 1) 
    -- 進入/離開戰鬥文字提示 
    SetCVar("floatingCombatTextCombatState", 1) 
    -- 低MP/低HP文字提示 
    SetCVar("floatingCombatTextLowManaHealth", 0)
    -- 連擊點 
    SetCVar("floatingCombatTextComboPoints", 0) 
    -- 能量獲得 
    SetCVar("floatingCombatTextEnergyGains", 0) 
    -- 周期性能量 
    SetCVar("floatingCombatTextPeriodicEnergyGains", 0) 
    -- *榮譽擊殺 
    SetCVar("floatingCombatTextHonorGains", 1) 
    -- 光環 
    SetCVar("floatingCombatTextAuras", 0)
-- end 

-- local frame = CreateFrame("FRAME", "defaultcvar") 
   -- frame:RegisterEvent("PLAYER_ENTERING_WORLD") 
      -- local function eventHandler(self, event, ...) 
         -- defaultcvar() 
-- end 
-- frame:SetScript("OnEvent", eventHandler)

SlashCmdList["RELOADUI"] = function() ReloadUI() end 
SLASH_RELOADUI1 = "/rl"