local ChangePetList={1,2,3}			----宠物死完后自动换宠优先级(战斗中1号宠死了自动换2号/3号死了自动换1号)
local GetPetFunction=AutoSkillModel.GetPetFunction
local AutoSkillPrint=AutoSkillModel.AutoSkillPrint
AutoSkillModel.RetSkillNum = function()
	local Ally=GetPetFunction["Ally"]
	local Enemy=GetPetFunction["Enemy"]

	if AutoSkillModel.Custom["FirstModule"] then
		local r,i = AutoSkillModel.Custom["FirstModule"](Ally,Enemy)
		if r or i then return r,i,"FirstModule" end
	end

	if AutoSkillModel.Custom then
		for funcname,func in pairsByAutoMode(AutoSkillModel.Custom) do
			if funcname~="FirstModule" and  funcname~="LastModule" then
				local r1,r2 = func(Ally,Enemy)
				if r1 or r2 then
					return r1,r2,funcname
				end
			end
		end
	end

	if AutoSkillModel.Custom["LastModule"] then
		local r,i = AutoSkillModel.Custom["LastModule"](Ally,Enemy)
		if r or i then return r,i,"LastModule" end
	end
end


AutoSkillModel.CastPetAbility = function(result,index,f)
	if printt then printt(result,index,f) end
	if C_PetBattles.ShouldShowPetSelect() and not(not result and index) then		---如果被迫换宠物(宠物死亡),并且下一个命令不是换宠(result不是nil)那么就按规则自动换宠物
		for _,i in pairs(ChangePetList) do
			if C_PetBattles.CanPetSwapIn(i) then
				AutoSkillPrint("被动换宠物["..C_PetBattles.GetName(1,i).."]上场")
				C_PetBattles.ChangePet(i)
				return
			end
		end
		AutoSkillPrint("被迫换宠异常")
	elseif not result and index then
		if C_PetBattles.CanPetSwapIn(index) and C_PetBattles.CanActivePetSwapOut() then
			AutoSkillPrint("主动换宠物["..C_PetBattles.GetName(1,index).."]上场")
			C_PetBattles.ChangePet(index)
		else
			AutoSkillPrint("宠物交换异常，改为待命")
			C_PetBattles.SkipTurn()
		end
	elseif result==4 then
		C_PetBattles.ForfeitGame()
	elseif result==5 then
		if C_PetBattles.IsTrapAvailable() then
			C_PetBattles.UseTrap()
		else
			AutoSkillPrint("宠物捕捉异常，改为待命")
			C_PetBattles.SkipTurn()
		end
	elseif result and result>0 and result<4 then
		AutoSkillPrint("No."..GetPetFunction.Ally.Index().."使用技能"..result..GetBattlePetAbilityHyperlink(select(result+1,C_PetJournal.GetPetLoadOutInfo(GetPetFunction.Ally.Index()))))
		C_PetBattles.UseAbility(result)
	elseif result==0 then
		C_PetBattles.SkipTurn()
	else
		AutoSkillPrint("被动待命/异常")
	end
end

----------------------------主函数-----------------------------
------------------一般情况，别改动这些下面的内容---------------
---------AutoToPet()
---------写成宏/run AutoToPet()
AutoToPet = function(fname,fkey)
	if fname and fname ~= "" then
		if AutoSkillModel.otherfunc[fname] then
			local isover = AutoSkillModel.otherfunc[fname](fkey)
			if isover then return end
		else
			print("不存在的函数名"..fname)
		end
	end
	---新的 AutoSkillModel.otherfunc,以前的AutoSkillModel.otherfunc套用下面的alwayfunc
	---AutoSkillModel.otherfunc["函数名"] = function(参数) ---只能一个参数
	---返回值用途:是否中段AutoToPet(),就是是不是需要继续运行下去,如果否,等于用写了一个独立函数
	---调用方式 /autoskill 函数名 参数
	---这样避免了某些只在某些情况下才使用的函数,需要每次来改动.


	---	 代码执行前,做一些其他事情(调用一些其他自定义函数.).不懂得可以无视.
	for funcname,func in pairsByAutoMode(AutoSkillModel.alwayfunc) do
		if type(func) == "function" then func() end
	end

	if not C_PetBattles.IsInBattle() then return end			---不在战斗中
	if (not C_PetBattles.ShouldShowPetSelect() and not C_PetBattles.IsSkipAvailable()) or C_PetBattles.GetSelectedAction() then return end
	---			(不在选择宠物界面	 并且	待命按钮不可用中(能用技能的时候肯定可以用) )			或者正在使用技能

	AutoSkillModel.CastPetAbility(AutoSkillModel.RetSkillNum())
end


SLASH_AUTOSKILL1 = "/autoskill";
SLASH_AUTOSKILL2 = "/autotopet";
SlashCmdList["AUTOSKILL"] = function(msg, editbox)
	local comm, rest = msg:match("^(%S*)%s*(.-)$")
	local command = string.lower(comm)
	if command == "debug" then
		print(AutoSkillModel.RetSkillNum())
	else
		AutoToPet(comm,rest)
	end
end
---1.5
SetCVar("scriptErrors", 1, SHOW_LUA_ERRORS)
