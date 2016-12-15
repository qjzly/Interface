-- API 说明 --------------------------------------------------------------------------------------------------------------------
--[[
	Self.Level(level)/Enemy.Level(level)		level等级,用于判断当前上场的宠物等级
	Self.PetID(id,l)/Enemy.PetID(id,l)			id:宠物ID，l:1或者不输入,用于设定是否限定25级宠物(当然也能用前面Self.Level来判断)
	Self.Buff(id)/Enemy.Buff(id)				判断自身/敌方是否有该buff/debuff(可应用于判断天气)
	Self.Ability(index)/Enemy.Ability(index)	判断该技能是否可以用,index:使用中技能序号(1~3)
	Self.Health(value,is)/Enemy.Health(value,is)判断当前宠物生命值,value:生命值,is:决定是大于value还是要小于value
	Self.Type(value)/Enemy.Type(value)			判断当前宠物的类别;value:取值1~8,对应8种类别，打开过滤,宠物类型里面的排序就是1~8
	Self.CanTrap()/Enemy.CanTrap()				可否捕捉
	Self.Index()/Enemy.Index()					当前上场宠物的序号
	Self.Round()/Enemy.Round()					回合数
	Self.Quality()/Enemy.Quality()				宠物品质/4是蓝色
	Self.MaxHealth()/Enemy.MaxHealth()			当前宠物最大生命值
	Self.Quick(a1,a2,a3)						简单套路,例如return Self.Quick(2,3,1)
												等价于
												if Self.Ability(2) then
													return 2
												elseif Self.Ability(3) then
													return 3
												elseif Self.Ability(1) then
													return 1
												else
													return nil
												end
												建议写法: if Self.Quick(2,3,1) then return Self.Quick(2,3,1) end
												否则会导致函数意外终止.另外,这个API只有Self没有Enemy
	Self.VSpeed()/Enemy.VSpeed()				直接返回速度对比的结果(Self返回Self>Enemy的结果,Enemy同理)--是>没有=
	另外加2个函数Self.GetHealth(i)和Self.GetSpeed(i)同样有Enemy的,直接返回当前(无i)或者第i只宠物的生命值和速度
--]]

-- return 详解 -----------------------------------------------------------------------------------------------------------------
-- return 0 就是待命
-- return 1~3 简单的可以理解为使用技能1~3
-- return 4 放弃游戏
-- return 5 捕捉宠物
-- return nil,1~3 就是换宠物1~3号(如果换宠换不了就会被待命)
-- 如果发现当前宠物不是你预设的宠物，或者当前敌人不是你想要的敌人，请什么都不要返回，把机会留给别的模块
-- 需要记住的是，return执行后,后面的代码就不会被执行.

-- 自定义模块的说明 ------------------------------------------------------------------------------------------------------------
-- AutoSkillModel.Custom[n], n可以随便命名, 理论上按数字顺序优先, 从0开始, 如果是字母, 再按大写>小写
-- 为了无视这些优先级,自己写的代码最好都限定好PetID
-- 随便写在哪, 或者哪个lua文件(新的lua文件,你得在toc里添加名字.)
-- FirstModule 是第一执行序模块, LastModule 是最后执行序模块

--------------------------------------------------------------------------------------------------------------------------------
AutoSkillModel.Custom["FirstModule"]=function(Self,Enemy)

	if (Self.Buff(174) or Self.Buff(498) or Self.Buff(734) or Self.Buff(822) or Self.Buff(927) or Self.Buff(926)) then	-- xforce2000: 926昏睡
		return 0
	end

end

AutoSkillModel.Custom["LastModule"]=function(Self,Enemy)

	-- 低级宠物自动下场
	if not Self.Level(25) then
		if Enemy.Index() == 1 then
			if Self.Round() > 1 then		---只要过了第一回合,那就说明低级宠物能拿到经验,那就下场吧
				return nil,Self.Index()+1>3 and 1 or Self.Index()+1
			else
				return 1
			end
		else
			return nil,Self.Index()+1>3 and 1 or Self.Index()+1
		end
	end

	-- 这是通用模块, 意思就是能用技能1就用技能1，不然就用技能2, 或者技能3
	return Self.Quick(1,2,3)

end


AutoSkillModel.Custom["DLNkaimierhuiren"]=function(Self,Enemy)


    if Enemy.PetID(1501) then
	    if Self.PetID(868) then  
          if Self.Health(505) then
		    return 4
		  end		
		  if not Enemy.Health(2000) and Self.Ability(3) then
		      return 3
		  elseif not Enemy.Health(2000) and Self.Ability(2)  then
		      return 2
		  else
			  return 1
          end
       end
   end

	if Enemy.PetID(1502) then
      if Self.PetID(868)  then
	      if not Enemy.Health(1900) then
	       return 1
	      end
	      if Self.Ability(3) then
                return 3
          elseif Self.Ability(2)  then
                return 2
          else
		        return 1
		  end
        end
   end


   if Enemy.PetID(1502) then
        if Self.PetID(190)  then
	       return 1
	    end
   end

   if Enemy.PetID(1503) then
		if Self.PetID(190) then
		    if  Self.Buff(242) then 
			   return 2
			else
			   return 1
			end
		end
	end

    if Enemy.PetID(1503) then
	   return 1
	end
end
AutoSkillModel.Custom["yaosairichang2"]=function(Self,Enemy)


    if Enemy.PetID(1508) then
	    if Self.PetID(844) then  
          if Enemy.Health(190) and Self.Ability(2) then
		     return 2
		  end		
		  if Self.Ability(3) then
                return 3
          else
		        return 1
		  end
       end
   end

	  if Enemy.PetID(1509) then
	    if Self.PetID(844) then  		
		  if  Self.Ability(3) then
                return 3
          elseif Enemy.Health(190) and Self.Ability(2) then
		        return 2
		  else
		        return 1
	      end
       end
   end


   if Enemy.PetID(1510) then
	    if Self.PetID(844) then  
          if Enemy.Health(619) then
		    return 0
		  end		
		  if Self.Ability(3) then
                return 3
          else
		        return 1
		  end
       end
   end

   if Enemy.PetID(1510) then
		if Self.PetID(339) then
		    if Enemy.Health(619) then
			   return 2
			end
			if Self.Ability(3) then
                return 3
            else
		        return 1
			end
		end
	end

    if Enemy.PetID(1510) then
	   return 1
	end
end

--------------------------------------------------------------------------------------------------------------------------------
