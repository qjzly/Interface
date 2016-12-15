local F, C = unpack(select(2, ...))

if not C.unitframes.enable then return end

if(select(2, UnitClass('player')) ~= 'PALADIN') then return end

local parent, ns = ...
local oUF = ns.oUF

local SPELL_POWER_HOLY_POWER = SPELL_POWER_HOLY_POWER
local Colors = { 255/255, 199/255, 48/255}

local Update = function(self, event, unit, powerType)
	if(self.unit ~= unit or (powerType and powerType ~= "HOLY_POWER")) then return end

	local hp = self.HolyPower
	if(hp.PreUpdate) then hp:PreUpdate(unit) end

	local num = UnitPower("player", SPELL_POWER_HOLY_POWER)
	local maxHolyPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)

	for i = 1, maxHolyPower do
		if i <= num then
			hp[i]:GetStatusBarTexture():SetAlpha(1)
		else
			hp[i]:GetStatusBarTexture():SetAlpha(.2)
		end
	end

	if(hp.PostUpdate) then
		return hp:PostUpdate(num)
	end
end

local init = true

local function Visibility(self, event, unit)
	local hp = self.HolyPower
	local spec = GetSpecialization()
	local spacing = select(4, hp[4]:GetPoint())
	local w = hp:GetWidth()
	local s = 0

	if not hp:IsShown() then
		hp:Show()
	end

	if init then
		for i = 1, UnitPowerMax("player", SPELL_POWER_HOLY_POWER) do
			local max = select(2, hp[i]:GetMinMaxValues())
			hp[i]:SetValue(max)
			hp[i]:GetStatusBarTexture():SetAlpha(1)
			hp[i]:Show()
		end
		init = false
	end

	local maxHolyPower = UnitPowerMax("player", SPELL_POWER_HOLY_POWER)

	for i = 1, maxHolyPower do
		if i ~= maxHolyPower then
			hp[i]:SetWidth(w / maxHolyPower - spacing)
			s = s + (w / maxHolyPower)
		else
			hp[i]:SetWidth(w - s)
		end
		hp[i]:SetStatusBarColor(unpack(Colors))
	end

	-- force an update each time we respec
	Update(self, nil, "player")
end

local Path = function(self, ...)
	return (self.HolyPower.Override or Update) (self, ...)
end

local ForceUpdate = function(element)
	return Path(element.__owner, 'ForceUpdate', element.__owner.unit, 'HOLY_POWER')
end

local function Enable(self)
	local hp = self.HolyPower
	if(hp) then
		hp.__owner = self
		hp.ForceUpdate = ForceUpdate

		self:RegisterEvent("UNIT_POWER", Path)
		self:RegisterEvent("UNIT_DISPLAYPOWER", Path)
		self:RegisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		self:RegisterEvent("PLAYER_TALENT_UPDATE", Visibility)

		for i = 1, 5 do
			local Point = hp[i]
			if not Point:GetStatusBarTexture() then
				Point:SetStatusBarTexture([=[Interface\TargetingFrame\UI-StatusBar]=])
			end

			Point:SetFrameLevel(hp:GetFrameLevel() + 1)
			Point:GetStatusBarTexture():SetHorizTile(false)
		end

		hp:Hide()

		return true
	end
end

local function Disable(self)
	local hp = self.HolyPower
	if(hp) then
		self:UnregisterEvent("UNIT_POWER", Path)
		self:UnregisterEvent("UNIT_DISPLAYPOWER", Path)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD", Visibility)
		self:UnregisterEvent("PLAYER_TALENT_UPDATE", Visibility)
	end
end

oUF:AddElement('HolyPower', Path, Enable, Disable)