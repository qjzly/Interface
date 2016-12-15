AutoSkillModel=CreateFrame("frame")
AutoSkillModel.Round = 0
AutoSkillModel:SetScript('OnEvent',function(_, event, ...) return AutoSkillModel[event](AutoSkillModel, event, ...) end)
AutoSkillModel.AddReg = function(self,event,func)
	if not AutoSkillModel[event] then
		AutoSkillModel:RegisterEvent(event)
		AutoSkillModel[event]=func
	else
		hooksecurefunc(AutoSkillModel,event,func)
	end
end
AutoSkillSaved=AutoSkillSaved or {}
AutoSkillModel:AddReg("PET_BATTLE_PET_ROUND_PLAYBACK_COMPLETE", function(self,event,round)
	AutoSkillModel.Round = round
end)
AutoSkillModel:AddReg("ADDON_LOADED", function(self,event,name)
	if name=="AutoSkill" then
		local VERSION = GetAddOnMetadata("AutoSkill","Version")
		print("|cff3399FFAutoSkill|r"..VERSION.."主要模块载入成功\n如果你进行了任何修改。都需要'保存lua文件'并且'游戏内/reload'之后才会生效")
		AutoSkillModel:SetActionTarget(AutoSkillSaved.target)
		AutoSkillModel:SetActionFunc(AutoSkillSaved.func)
	end
end)
RegisterAddonMessagePrefix("AutoSkill")
AutoSkillModel:AddReg("CHAT_MSG_ADDON",function(self,event, prefix, data, channel, sender)
	if sender == UnitName("player") then return end
	if prefix ~= "AutoSkill" then return end
	local a,b=GetPlayerMapPosition("player")
	if data == "x" then SendAddonMessage("AutoSkill",a.."|"..b,"WHISPER",sender) end
end)
AutoSkillModel.otherfunc={}		--附加函数(只执行/autoskill XXXX中的otherfunc[XXXX],并且返回值决定是否继续AutoSkill)
AutoSkillModel.Otherfunc=AutoSkillModel.otherfunc
AutoSkillModel.alwayfunc={}		--附加函数(每次/autoskill都执行其中的所有)
AutoSkillModel.Custom={}			--自定义模块
AutoSkillModel.GetPetFunction={["Ally"]={["petOwner"]=1},["Enemy"]={["petOwner"]=2}}	---函数集合
AutoSkillModel.GetPetFunction.Ally.Reverse=AutoSkillModel.GetPetFunction.Enemy
AutoSkillModel.GetPetFunction.Enemy.Reverse=AutoSkillModel.GetPetFunction.Ally

do
	for FnName,Fn in pairs(AutoSkillModel.GetPetFunction) do
		local petOwner = Fn.petOwner

		Fn.Round = function()
			return AutoSkillModel.Round + 1
		end

		Fn.Index = function(v)
			if v then
				return Fn.Index() == v
			else
				return C_PetBattles.GetActivePet(petOwner)
			end
		end
		--[[然后，这上面的并不是所有宠物对战API,还有些API可以获取双方的攻击/速度等
		我写在这后面。需要的可以自己看。
			C_PetBattles.ChangePet(n)			换到宠物n
			C_PetBattles.CanPetSwapIn(n)		可否换到宠物n
			C_PetBattles.GetSpeed(n,index)		获取友方(n=1)/地方(n=2)上场序号为index的宠物当前速度
			C_PetBattles.GetMaxHealth(n,index)	获取友方(n=1)/地方(n=2)上场序号为index的宠物当前最大生命值
			C_PetBattles.GetPower(n,index)		获取友方(n=1)/地方(n=2)上场序号为index的宠物当前攻击
			C_PetBattles.ForfeitGame()			放弃战斗
			C_PetBattles.SkipTurn()				待命


		]]
		------------------------------------------------------------------------------
		-----------------------------------自身判断-----------------------------------
		------------------------------------------------------------------------------

		-------Self.Level(level);level等级,用于判断当前上场的宠物等级
		-------例如:Self.Level(10)，因为用的少，所以很粗糙
		-------C_PetBattles.GetLevel(a,b),a可以输入1/2，分辨表示我方/敌方;b就是当前宠物的序号(序号概念见上↑)
		Fn.Level=function(level)
			return level == C_PetBattles.GetLevel(petOwner,Fn.Index())
		end

		-------Self.PetID(id,l);id:宠物ID，l:1或者不输入,用于设定是否限定25级宠物(当然也能用前面selflevel来判断)
		-------例如:SelfPetID(1162)判断当前上场的宠物是否是25级的机器猫,如果不需要一定是25级,就改成SelfPetID(1162,true)
		Fn.PetID=function(id,l)
			if type(id) == "number" then id = {id} end
			if type(id) == "table" then
				for _,i in pairs(id) do
					if i == C_PetBattles.GetPetSpeciesID(petOwner,Fn.Index()) then ---and (l or Fn.Level(25)) then
						return true
					end
				end
			end
			return false
		end

		Fn.Team=function(id1,id2,id3)
			local ids={UnitBattlePetSpeciesID(id1) or id1,UnitBattlePetSpeciesID(id2) or id2,UnitBattlePetSpeciesID(id3) or id3}
			for i = 1, 3 do
				if not (ids[1] and ids[1] == C_PetBattles.GetPetSpeciesID(i,Fn.Index())) then
					return false
				end
			end
			return true
		end

		--------Self.Buff(id);判断自身是否有该BUFF/debuff(可应用于判断天气)
		--------例如:SelfBuff(296)判断自身是否有增压BUFF
		--------hasturn,用来
		Fn.Buff=function(id,hasturn)
			for i = 1, C_PetBattles.GetNumAuras(petOwner,Fn.Index()) do		---个人
				local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(petOwner,Fn.Index(),i)
				if id == auraID then
					if hasturn then
						if turnsRemaining - hasturn > 0 or Fn.VSpeed(1) then
							return true
						end
					else
						return true
					end
				end
			end
			for i = 1, C_PetBattles.GetNumAuras(petOwner,0) do		---团队
				local auraID, instanceID, turnsRemaining, isBuff = C_PetBattles.GetAuraInfo(petOwner,0,i)
				if id == auraID then
					if hasturn then
						if turnsRemaining - hasturn > 0 or Fn.VSpeed(1) then
							return true
						end
					else
						return true
					end
				end
			end
			return id == C_PetBattles.GetAuraInfo(0,0,1)		---天气
		end

		--------Self.Ability(index);判断该技能是否可以用
		--------index为列出来的技能序号(1~3)
		Fn.Ability=function(i)
			return C_PetBattles.GetAbilityState(petOwner,Fn.Index(),i)
		end

		---------Self.Health(value,is);判断当前宠物生命值,value:生命值,is:决定是大于value还是要小于value
		---------Self.Health(600)当前宠物生命小于600
		---------Self.Health(800,true)当前宠物生命大于800
		Fn.Health=function(value,is)
			if is then
				return C_PetBattles.GetHealth(petOwner,Fn.Index()) >= value
			else
				return C_PetBattles.GetHealth(petOwner,Fn.Index()) < value
			end
		end

		---------SelfType(value)判断当前宠物的类别;value:取值1~8,对应8种类别，具体数字可以打开宠物日志。打开过滤,宠物类型里面的排序就是1~8
		---------SelfType(3)当前宠物是飞行
		Fn.Type=function(value)
			return value == C_PetBattles.GetPetType(petOwner,Fn.Index())
		end

		---------直接返回速度比较值,(例如Self返回 Self速度>Enemy速度,Enemy同理)
		Fn.VSpeed=function()
			return Fn.GetSpeed() > Fn.Reverse.GetSpeed()
		end
		-- 检测是否能够打到对方
		Fn.CanHit = function()
			if Fn.Reverse.Buff(340) or Fn.Reverse.Buff(341) or Fn.Reverse.Buff(505) then  -- 340 遁地, 341 飞行, 505丝茧
				if Fn.VSpeed()	then					-- 我放比敌人快，打不到
					return false
				end
			end
			return true
		end

		Fn.MaxHealth=function(petIndex)
			return C_PetBattles.GetMaxHealth(petOwner,petIndex or Fn.Index())
		end

		Fn.Quality=function(petIndex)
			C_PetBattles.GetBreedQuality(petOwner,petIndex or Fn.Index())
		end

		Fn.CanTrap=function()
			C_PetBattles.IsTrapAvailable()
		end

		--------Get
		Fn.GetLevel=function(petIndex)
			return C_PetBattles.GetLevel(petOwner,petIndex or Fn.Index())
		end

		Fn.GetHealth=function(petIndex)
			return C_PetBattles.GetHealth(petOwner,petIndex or Fn.Index())
		end

		Fn.GetSpeed=function(petIndex)
			return C_PetBattles.GetSpeed(petOwner,petIndex or Fn.Index())
		end

		Fn.GetAbility=function(i,petIndex)
			return C_PetBattles.GetAbilityInfo(petOwner,petIndex or Fn.Index(),i)
		end
		Fn.GetType=function(value)
			return C_PetBattles.GetPetType(petOwner,Fn.Index())
		end
		Fn.GetPower=function(petindex)
			return C_PetBattles.GetPower(petOwner,petIndex or Fn.Index())
		end
		Fn.GetAPower=function(i)
			local id = Fn.GetAbility(i) or i
			return GetAbilityPowerByID(id,petOwner)
		end
		Fn.GetEDamage=function(i)
			local damage=Fn.GetAPower(i)
			local Self = Fn
			local Enemy = Fn.Reverse

		---额外附加/减伤害
			if Enemy.Buff(918) then damage=damage+Self.GetAPower(918) end
			if Enemy.Buff(171) then damage=damage+Self.GetAPower(171) end
			if Enemy.Buff(309) then damage=damage-Enemy.GetAPower(309) end
			if Enemy.Buff(316) then	damage=damage-Enemy.GetAPower(316) end

		---自身攻击力变化BUFF
			---被动
			if Self.Buff(245) then damage=damage*1.5 end
			if Self.Buff(237) then damage=damage*1.25 end
			---自身降低
			if Self.Buff(537) then damage=damage*0.5 end
			if Self.Buff(470) then damage=damage*0.5 end
			if Self.Buff(153) then damage=damage*0.75 end
			---自身提高
			if Self.Buff(485) then damage=damage*1.25 end
			if Self.Buff(807) then damage=damage*1.25 end


		---敌对承受伤害变化BUFF
			---自身降低
			if Enemy.Buff(807) then damage=damage*1.5 end
			if Enemy.Buff(542) then damage=damage*2 end
			---自身提高
			if Enemy.Buff(164) then	damage = damage*0.5 end
			---被动
			if Enemy.Buff(284) then
				if damage>Enemy.GetHealth() then damage=Enemy.GetHealth()-1 end
			end
			if Enemy.Type(6) then
				if damage>Enemy.MaxHealth()*0.4 then damage=Enemy.MaxHealth()*0.4 end
			end
		end
		---------功能函数
		Fn.Quick = function(...)
			if petOwner == 2 then return end
			for _,i in pairs({...}) do
				local n = tonumber(i)
				if Fn.Ability(n) and Fn.CanHit(n) then
					return n
				end
			end
			return nil
		end

		Fn.QuickBeta = function()
			if petOwner == 2 then return end
			local damages={}
			for i = 1 ,3 do
				damages[i]=(Fn.Ability(i) and Fn.CanHit(i)) and Fn.GetAPower(i) or 0
			end
			for i = 1 ,3 do
				if damages[i]>damages[i-1>0 and i-1 or 3] and damages[i]>damages[i+1<4 and i+1 or 1]  then
					return i
				end
			end
		end
	end
end


AutoSkillModel.AutoSkillPrint = function(str,...)
	if ( FCFManager_GetNumDedicatedFrames("PET_BATTLE_COMBAT_LOG") == 0 ) then
		FCF_OpenTemporaryWindow("PET_BATTLE_COMBAT_LOG");
	end
	local chatFrameName
	for _, chatFrameName in pairs(CHAT_FRAMES) do
		local frame = _G[chatFrameName];
		for index = #frame.messageTypeList,1,-1 do
			if frame.messageTypeList[index] == "PET_BATTLE_COMBAT_LOG" then
				if str then
					if not frame:IsShown() then FCF_StartAlertFlash(frame) end
					frame:AddMessage("AutoSkill:"..str,...)
				else
					return frame
				end
			end
		end
	end
end


function pairsByAutoMode(t)
	local a={}
	local b={}
	for n in pairs(t) do
		if type(n) == "number" then
			a[#a+1]=n
		elseif type(n) == "string" then
			b[#b+1]=n
		end
	end
	table.sort(a)
	table.sort(b)
	local i = 0
	return function()
		i = i + 1
		if i>#a then
			return b[i-#a],t[b[i-#a]]
		else
			return a[i],t[a[i]]
		end
	end
end

GetAbilityPowerByID=nil
do
	local oabilityID
	local otarget,otargetRev = "Ally","Enemy"
	local GetTarget = function(value)
		otarget,otargetRev = "Ally","Enemy"
		if value == 2 then
			otarget,otargetRev = otargetRev,otarget
		end
	end
	local Shine={}
	Shine.abs=abs
	Shine.abilityStateMod = function(stateID, abilityID)
		return C_PetBattles.GetAbilityStateModification(abilityID or oabilityID, stateID);
	end
	Shine.unitPetType = function(target)
		return AutoSkillModel.GetPetFunction[target].GetType()
	end
	Shine.unitPower = function(target)
		return AutoSkillModel.GetPetFunction[target].GetPower()
	end
	Shine.points = function(...)
		local turnIndex, effectIndex, abilityID = ...
		return C_PetBattles.GetAbilityEffectInfo(abilityID or oabilityID, turnIndex, effectIndex, "points")
	end
	Shine.abilityHasHints = function(abilityID)
		local id, name, icon, maxCooldown, unparsedDescription, numTurns, petType, noStrongWeakHints = C_PetBattles.GetAbilityInfoByID(abilityID or oabilityID);
		return petType and not noStrongWeakHints;
	end
	Shine.AttackBonus = function() return (1 + 0.05 * Shine.unitPower(otarget)); end;
	Shine.SimpleDamage = function(...) return Shine.points(...)*Shine.AttackBonus() end
	Shine.StandardDamage = function(...)
		local turnIndex, effectIndex, abilityID = ...
		return Shine.FormatDamage(Shine.SimpleDamage(...), abilityID)
	end
	Shine.FormatDamage = function(baseDamage, abilityID)
		if ( C_PetBattles.IsInBattle() and Shine.abilityHasHints(abilityID) ) then
			return Shine.FormatDamageHelper(baseDamage, select(7,C_PetBattles.GetAbilityInfoByID(abilityID or oabilityID)), Shine.unitPetType(otargetRev));
		else
			return floor(baseDamage);
		end
	end

	Shine.FormatDamageHelper = function(baseDamage, attackType, defenderType)
		local multi = C_PetBattles.GetAttackModifier(attackType, defenderType);
		return math.floor(baseDamage * multi)
	end

	local safeEnv = {};
	setmetatable(safeEnv, { __index = Shine, __newindex = function() end });

	GetValue=function(expr)
		local newf = loadstring("return ("..string.sub(expr, 2, -2)..")")
		setfenv(newf, safeEnv)
		local isok,value = pcall(newf)
--~ 		print(value)
		if isok then return value end
	end

	GetAbilityPowerByID=function(SkillID,target)
		local id, name, icon, maxCooldown, description, numTurns, petType, noStrongWeakHints  = C_PetBattles.GetAbilityInfoByID(SkillID)
		local value=0
		if id then
			oabilityID = SkillID
			GetTarget(target)
			for str in string.gmatch(description, "%b[]") do
				value = value + tonumber(GetValue(str) or 0)
			end
		end
--~ 		print(name,description)
		otarget=nil
		otargetRev=nil
		oabilityID=nil
		return value or 0
	end
end

---------------------button
AutoSkillModel.ActionButton = CreateFrame("Button","AutoSkillButton",AutoSkillModel,"SecureActionButtonTemplate")
AutoSkillModel.ExtraButton = CreateFrame("Button","AutoSkillExtraButton",AutoSkillModel,"SecureActionButtonTemplate")
local ButtonBindsCommand = "CLICK AutoSkillButton:1"
local ActionButton = AutoSkillModel.ActionButton
local ExtraButton = AutoSkillModel.ExtraButton
local macro_click = "/click AutoSkillExtraButton"
local macro_text = "/autoskill\n"..macro_click
ActionButton:SetAttribute("macrotext",macro_text)

---hook,用来在"按键设置"里增加一个项
---正常的方法应该是创建一个Bindings.xml
do
	_G["BINDING_NAME_"..ButtonBindsCommand]="一键对战"
	_G["BINDING_HEADER_AUTOSKILL"]="宠物对战自动模块"
	local MaxNum = GetNumBindings() + 2
	local GetNumBindings_old = GetNumBindings
	GetNumBindings=function()
		MaxNum = GetNumBindings_old() + 2
		return MaxNum
	end
	local GetBinding_old = GetBinding
	GetBinding=function(keyOffset,...)
		if keyOffset == MaxNum then
			local a,b = GetBindingKey(ButtonBindsCommand)
			return ButtonBindsCommand,a,b
		elseif keyOffset == MaxNum - 1 then
			return "HEADER_AUTOSKILL"
		else
			return GetBinding_old(keyOffset,...)
		end
	end
end
ExtraButton:SetAttribute("type",nil)
function AutoSkillModel:SetExtraItem(id)
	ExtraButton:SetAttribute("type","item")
	ExtraButton:SetAttribute("item",GetItemInfo(id))
	print("|cff3399FFExtraButton内容为|r:",ExtraButton:GetAttribute("item"))
end
function AutoSkillModel:SetExtraSpell(id)
	ExtraButton:SetAttribute("type","spell")
	ExtraButton:SetAttribute("spell",GetSpellInfo(id))
	print("|cff3399FFExtraButton内容为|r:",ExtraButton:GetAttribute("spell"))
end
function AutoSkillModel:SetExtraMacro(macro)
	ExtraButton:SetAttribute("type","macro")
	ExtraButton:SetAttribute("macrotext",macro)
	print("|cff3399FFExtraButton内容为|r:",ExtraButton:GetAttribute("macrotext"))
end

ActionButton:SetAttribute("type","macro")
function AutoSkillModel:SetActionTarget(str)
	AutoSkillSaved.target = str
	local text = ""
	if str and str~="" then
		text = "\n/target "..str
	end
	local macrotext,isok = ActionButton:GetAttribute("macrotext"):gsub("\n/target [^\n]*",text)

	if isok == 0 and text~="" then macrotext = macrotext..text end
	ActionButton:SetAttribute("macrotext",macrotext)
	_G["BINDING_NAME_"..ButtonBindsCommand]="一键对战"..text
end

function AutoSkillModel:SetActionFunc(str)
	AutoSkillSaved.func = str
	local text = "/autoskill"
	if str and str~="" and AutoSkillModel.otherfunc[str] then
		text = text.." "..str
	end
	local macrotext,isok = ActionButton:GetAttribute("macrotext"):gsub("/autoskill[ ]?[^\n]*",text)

	ActionButton:SetAttribute("macrotext",macrotext)
	print("|cff3399FF快捷键内容为|r:",ActionButton:GetAttribute("macrotext"))
end

-----------------------------------快捷键内容修改

-------/autoskill target xxxx
-------添加修改/target xxxx
AutoSkillModel.otherfunc["target"] = function(str)
	if not UnitAffectingCombat("player") then
		AutoSkillModel:SetActionTarget(str)
		if str and str~="" then
			print("|cff3399FF快捷键已附加|r:[/target "..str.."]")
		else
			print("|cff3399FF已清除附加的target命令|r")
		end
	end
	return true
end

-------/autoskill func xxxx
-------修改/autoskill为/autoskill xxxx
-------ps:xxxx必须为存在的函数.
AutoSkillModel.otherfunc["func"] = function(str)
	if not UnitAffectingCombat("player") then
		AutoSkillModel:SetActionFunc(str)
	end
	return true
end
