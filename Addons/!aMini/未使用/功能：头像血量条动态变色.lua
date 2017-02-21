----------------------------------------------------------------------------------------
--  PORTRAIT
----------------------------------------------------------------------------------------
  
--  血量条动态变色（暴雪默认方案）
local t=HealthBar_OnValueChanged
HealthBar_OnValueChanged=function(self,value,smooth)
	t(self,value,true)
end
