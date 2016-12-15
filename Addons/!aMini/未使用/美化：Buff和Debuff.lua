
  -- // Lorti UI
  -- // Lorti - 2013

  -----------------------------
  -- INIT
  -----------------------------

  --get the addon namespace
  local addon, ns = ...

  --generate a holder for the config data
  local cfg = CreateFrame("Frame")

  -----------------------------
  -- ACTIONBUTTON CONFIG
  -----------------------------

  cfg.textures = {
    normal            = "Interface\\AddOns\\A4U\\media\\gloss",
    flash             = "Interface\\AddOns\\A4U\\media\\flash",
    hover             = "Interface\\AddOns\\A4U\\media\\hover",
    pushed            = "Interface\\AddOns\\A4U\\media\\pushed",
    checked           = "Interface\\AddOns\\A4U\\media\\checked",
    equipped          = "Interface\\AddOns\\A4U\\media\\gloss_grey",
    buttonback        = "Interface\\AddOns\\A4U\\media\\button_background",
    buttonbackflat    = "Interface\\AddOns\\A4U\\media\\button_background_flat",
    outer_shadow      = "Interface\\AddOns\\A4U\\media\\outer_shadow",
  }

  cfg.background = {
    showbg            = true,  --show an background image?
    showshadow        = true,   --show an outer shadow?
    useflatbackground = false,  --true uses plain flat color instead
    backgroundcolor   = { r = 0, g = 0, b = 0, a = 0.6},
    shadowcolor       = { r = 0, g = 0, b = 0, a = 1},
    classcolored      = false,
    inset             = 6,  --从阴影边框外背景边框里，
  }

  cfg.color = {
    normal            = { r = 0, g = 0, b = 0, },
    equipped          = { r = 0.1, g = 0.5, b = 0.1, },
    classcolored      = false,
  }

  cfg.hotkeys = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "TOPRIGHT", x = 0, y = 0 },
    pos2             = { a1 = "TOPLEFT", x = 0, y = 0 }, --important! two points are needed to make the hotkeyname be inside of the button
  }

  cfg.macroname = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMLEFT", x = 0, y = 0 },
    pos2             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 }, --important! two points are needed to make the macroname be inside of the button
  }

  cfg.itemcount = {
    show            = true,
    fontsize        = 12,
    pos1             = { a1 = "BOTTOMRIGHT", x = 0, y = 0 },
  }

  cfg.cooldown = {
    spacing         = 0,
  }

  cfg.font = STANDARD_TEXT_FONT




  
  -----------------------------
  -- BUFF&DEBUFF CONFIG
  -----------------------------

  --adjust the oneletter abbrev?
  cfg.adjustOneletterAbbrev = true
  

  
  --combine buff and debuff frame - should buffs and debuffs be displayed in one single frame?
  --if you disable this it is intended that you unlock the buff and debuffs and move them apart!
  cfg.combineBuffsAndDebuffs = true

  --buff frame settings
  cfg.buffFrame = {
    pos             = { a1 = "TOPRIGHT", af = "Minimap", a2 = "TOPLEFT", x = -35, y = 0 },
    gap             = 10, --gap between buff and debuff rows
    userplaced      = true, --want to place the bar somewhere else?
    rowSpacing      = 14,
    colSpacing      = 5, --7
    buttonsPerRow   = 12,
    button = {
      size              = 32, --size              = 28,
    },
    icon = {
      padding           = -2,
    },
    border = {
      texture           = "Interface\\AddOns\\A4U\\media\\gloss",
      color             = { r = 0, g = 0, b = 0, }, --{ r = 0.4, g = 0.35, b = 0.35, },
      classcolored      = false,
    },
    background = {
      show              = true,   --show backdrop
      edgeFile          = "Interface\\AddOns\\A4U\\media\\outer_shadow",
      color             = { r = 0, g = 0, b = 0, a = 1},
      classcolored      = false,
      inset             = 6,
      padding           = 3,
    },
    duration = {
      font              = STANDARD_TEXT_FONT,
      size              = 13,
      pos               = { a1 = "BOTTOM", x = 0, y = -14 },
    },
    count = {
      font              = STANDARD_TEXT_FONT,
      size              = 12,
      pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
    },
  }

  --debuff frame settings
  cfg.debuffFrame = {
    pos             = { a1 = "TOPRIGHT", af = "rBFS_BuffDragFrame", a2 = "BOTTOMRIGHT", x = 0, y = -10 },
    userplaced      = true, --want to place the bar somewhere else?
    rowSpacing      = 10,
    colSpacing      = 7,
    buttonsPerRow   = 6,
    button = {
      size              = 40,
    },
    icon = {
      padding           = -2,
    },
    border = {
      texture           = "Interface\\AddOns\\A4U\\media\\gloss",
    },
    background = {
      show              = true,   --show backdrop
      edgeFile          = "Interface\\AddOns\\A4U\\media\\outer_shadow",
      color             = { r = 0, g = 0, b = 0, a = 0.9}, --{ r = 0.4, g = 0.35, b = 0.35, },
      classcolored      = false,
      inset             = 6,
      padding           = 3,
    },
    duration = {
      font              = STANDARD_TEXT_FONT,
      size              = 13,
      pos               = { a1 = "BOTTOM", x = 0, y = 0 },
    },
    count = {
      font              = STANDARD_TEXT_FONT,
      size              = 12,
      pos               = { a1 = "TOPRIGHT", x = 0, y = 0 },
    },
  }

  -----------------------------
  -- HANDOVER
  -----------------------------

  --hand the config to the namespace for usage in other lua files (remember: those lua files must be called after the cfg.lua)
  ns.cfg = cfg













  

  --get the addon namespace
  local addon, ns = ...
  --get the config values
  local cfg = ns.cfg
  local dragFrameList = ns.dragFrameList

  -----------------------------
  -- GLOBAL FUNCTIONS
  -----------------------------

  --rCreateDragFrame func
  function rCreateDragFrame(self, dragFrameList, inset, clamp)
    if not self or not dragFrameList then return end
    --save the default position for later
    self.defaultPoint = rGetPoint(self)
    table.insert(dragFrameList,self) --add frame object to the list
    --anchor a dragable frame on self
    local df = CreateFrame("Frame",nil,self)
    df:SetAllPoints(self)
    df:SetFrameStrata("HIGH")
    df:SetHitRectInsets(inset or 0,inset or 0,inset or 0,inset or 0)
    df:EnableMouse(true)
    df:RegisterForDrag("LeftButton")
    df:SetScript("OnDragStart", function(self) if IsAltKeyDown() and IsShiftKeyDown() then self:GetParent():StartMoving() end end)
    df:SetScript("OnDragStop", function(self) self:GetParent():StopMovingOrSizing() end)
    df:SetScript("OnEnter", function(self)
      GameTooltip:SetOwner(self, "ANCHOR_TOP")
      GameTooltip:AddLine(self:GetParent():GetName(), 0, 1, 0.5, 1, 1, 1)
      GameTooltip:AddLine("Hold down ALT+SHIFT to drag!", 1, 1, 1, 1, 1, 1)
      GameTooltip:Show()
    end)
    df:SetScript("OnLeave", function(s) GameTooltip:Hide() end)
    df:Hide()
    --overlay texture
    local t = df:CreateTexture(nil,"OVERLAY",nil,6)
    t:SetAllPoints(df)
    t:SetTexture(0,1,0)
    t:SetAlpha(0.2)
    df.texture = t
    --self stuff
    self.dragFrame = df
    self:SetClampedToScreen(clamp or false)
    self:SetMovable(true)
    self:SetUserPlaced(true)
  end

  ---------------------------------------
  -- LOCALS
  ---------------------------------------

  --rewrite the oneletter shortcuts
  if cfg.adjustOneletterAbbrev then
    HOUR_ONELETTER_ABBR = "%dh"
    DAY_ONELETTER_ABBR = "%dd"
    MINUTE_ONELETTER_ABBR = "%dm"
    SECOND_ONELETTER_ABBR = "%ds"
  end

  --classcolor
  local classColor = RAID_CLASS_COLORS[select(2, UnitClass("player"))]

  --backdrop debuff
  local backdropDebuff = {
    bgFile = nil,
    edgeFile = cfg.debuffFrame.background.edgeFile,
    tile = false,
    tileSize = 32,
    edgeSize = cfg.debuffFrame.background.inset,
    insets = {
      left = cfg.debuffFrame.background.inset,
      right = cfg.debuffFrame.background.inset,
      top = cfg.debuffFrame.background.inset,
      bottom = cfg.debuffFrame.background.inset,
    },
  }

  --backdrop buff
  local backdropBuff = {
    bgFile = nil,
    edgeFile = cfg.buffFrame.background.edgeFile,
    tile = false,
    tileSize = 32,
    edgeSize = cfg.buffFrame.background.inset,
    insets = {
      left = cfg.buffFrame.background.inset,
      right = cfg.buffFrame.background.inset,
      top = cfg.buffFrame.background.inset,
      bottom = cfg.buffFrame.background.inset,
    },
  }

  local ceil, min, max = ceil, min, max
  local ShouldShowConsolidatedBuffFrame = ShouldShowConsolidatedBuffFrame
  
  local buffFrameHeight = 0

  ---------------------------------------
  -- FUNCTIONS
  ---------------------------------------

  --apply aura frame texture func
  local function applySkin(b)
    if not b or (b and b.styled) then return end
    --button name
    local name = b:GetName()
    --check the button type
    local tempenchant, debuff, buff = false, false, false
    if (name:match("TempEnchant")) then
      tempenchant = true
    elseif (name:match("Debuff")) then
      debuff = true
    else
      buff = true
    end
    --get cfg and backdrop
    local cfg, backdrop
    if debuff then
      cfg = ns.cfg.debuffFrame
      backdrop = backdropDebuff
    else
      cfg = ns.cfg.buffFrame
      backdrop = backdropBuff
    end
    --check class coloring options
    if cfg.border.classcolored then
      cfg.border.color = classColor
    end
    if cfg.background.classcolored then
      cfg.background.color = classColor
    end

    --button
    b:SetSize(cfg.button.size, cfg.button.size)

    --icon
    local icon = _G[name.."Icon"]
    icon:SetTexCoord(0.1,0.9,0.1,0.9)
    icon:ClearAllPoints()
    icon:SetPoint("TOPLEFT", b, "TOPLEFT", -cfg.icon.padding, cfg.icon.padding)
    icon:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", cfg.icon.padding, -cfg.icon.padding)
    icon:SetDrawLayer("BACKGROUND",-8)
    b.icon = icon

    --border
    local border = _G[name.."Border"] or b:CreateTexture(name.."Border", "BACKGROUND", nil, -7)
    border:SetTexture(cfg.border.texture)
    border:SetTexCoord(0,1,0,1)
    border:SetDrawLayer("BACKGROUND",-7)
    if tempenchant then
      border:SetVertexColor(0.7,0,1)
    elseif not debuff then
      border:SetVertexColor(cfg.border.color.r,cfg.border.color.g,cfg.border.color.b)
    end
    border:ClearAllPoints()
    border:SetAllPoints(b)
    b.border = border

    --duration
    b.duration:SetFont(cfg.duration.font, cfg.duration.size, "THINOUTLINE")
    b.duration:ClearAllPoints()
    b.duration:SetPoint(cfg.duration.pos.a1,cfg.duration.pos.x,cfg.duration.pos.y)

    --count
    b.count:SetFont(cfg.count.font, cfg.count.size, "THINOUTLINE")
    b.count:ClearAllPoints()
    b.count:SetPoint(cfg.count.pos.a1,cfg.count.pos.x,cfg.count.pos.y)

    --shadow
    if cfg.background.show then
      local back = CreateFrame("Frame", nil, b)
      back:SetPoint("TOPLEFT", b, "TOPLEFT", -cfg.background.padding, cfg.background.padding)
      back:SetPoint("BOTTOMRIGHT", b, "BOTTOMRIGHT", cfg.background.padding, -cfg.background.padding)
      back:SetFrameLevel(b:GetFrameLevel()-1)
      back:SetBackdrop(backdrop)
      back:SetBackdropBorderColor(cfg.background.color.r,cfg.background.color.g,cfg.background.color.b,cfg.background.color.a)
      b.bg = back
    end

    --set button styled variable
    b.styled = true
  end

  --update debuff anchors
  local function updateDebuffAnchors(buttonName,index)
    local button = _G[buttonName..index]
    if not button then return end
    --apply skin
    if not button.styled then applySkin(button) end
    --position button
    button:ClearAllPoints()
    if index == 1 then
      if cfg.combineBuffsAndDebuffs then
        button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, -buffFrameHeight*1.3+5)
      else
        --debuffs and buffs are not combined anchor the debuffs to its own frame
        button:SetPoint("TOPRIGHT", rBFS_DebuffDragFrame, "TOPRIGHT", 0, 0)      
      end
    elseif index > 1 and mod(index, cfg.debuffFrame.buttonsPerRow) == 1 then
      button:SetPoint("TOPRIGHT", _G[buttonName..(index-cfg.debuffFrame.buttonsPerRow)], "BOTTOMRIGHT", 0, -cfg.debuffFrame.rowSpacing)
    else
      button:SetPoint("TOPRIGHT", _G[buttonName..(index-1)], "TOPLEFT", -cfg.debuffFrame.colSpacing, 0)
    end
  end
  
  --update buff anchors
  local function updateAllBuffAnchors()
    --variables
    local buttonName  = "BuffButton"
    local numEnchants = BuffFrame.numEnchants
    local numBuffs    = BUFF_ACTUAL_DISPLAY
    local offset      = numEnchants
    local realIndex, previousButton, aboveButton

    
    --calculate the previous button in case tempenchant or consolidated buff are loaded
    if BuffFrame.numEnchants > 0 then
      previousButton = _G["TempEnchant"..numEnchants]
    end

	if numEnchants > 0 then
      aboveButton = TempEnchant1
    end
    --loop on all active buff buttons
    local buffCounter = 0
    for index = 1, numBuffs do
      local button = _G[buttonName..index]
      if not button then return end
      if not button.consolidated then
        buffCounter = buffCounter + 1
        --apply skin
        if not button.styled then applySkin(button) end
        --position button
        button:ClearAllPoints()
        realIndex = buffCounter+offset
        if realIndex == 1 then
          button:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0)
          aboveButton = button
        elseif realIndex > 1 and mod(realIndex, cfg.buffFrame.buttonsPerRow) == 1 then
          button:SetPoint("TOPRIGHT", aboveButton, "BOTTOMRIGHT", 0, -cfg.buffFrame.rowSpacing)
          aboveButton = button
        else
          button:SetPoint("TOPRIGHT", previousButton, "TOPLEFT", -cfg.buffFrame.colSpacing, 0)
        end
        previousButton = button
        
      end
    end
    --calculate the height of the buff rows for the debuff frame calculation later
    local rows = ceil((buffCounter+offset)/cfg.buffFrame.buttonsPerRow)
    local height = cfg.buffFrame.button.size*rows + cfg.buffFrame.rowSpacing*rows + cfg.buffFrame.gap*min(1,rows)
    buffFrameHeight = height
    --make sure the debuff frames update the position asap
    if DebuffButton1 and cfg.combineBuffsAndDebuffs then    
      updateDebuffAnchors("DebuffButton", 1)
    end
  end

  ---------------------------------------
  -- INIT
  ---------------------------------------

  --buff drag frame
  local bf = CreateFrame("Frame", "rBFS_BuffDragFrame", UIParent)
  bf:SetSize(cfg.buffFrame.button.size,cfg.buffFrame.button.size)
  bf:SetPoint(cfg.buffFrame.pos.a1,cfg.buffFrame.pos.af,cfg.buffFrame.pos.a2,cfg.buffFrame.pos.x,cfg.buffFrame.pos.y)
  if cfg.buffFrame.userplaced then
    rCreateDragFrame(bf, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
  end

  if not cfg.combineBuffsAndDebuffs then
    --debuff drag frame
    local df = CreateFrame("Frame", "rBFS_DebuffDragFrame", UIParent)
    df:SetSize(cfg.debuffFrame.button.size,cfg.debuffFrame.button.size)
    df:SetPoint(cfg.debuffFrame.pos.a1,cfg.debuffFrame.pos.af,cfg.debuffFrame.pos.a2,cfg.debuffFrame.pos.x,cfg.debuffFrame.pos.y)
    if cfg.debuffFrame.userplaced then
      rCreateDragFrame(df, dragFrameList, -2 , true) --frame, dragFrameList, inset, clamp
    end
  end

  --temp enchant stuff
  applySkin(TempEnchant1)
  applySkin(TempEnchant2)
  applySkin(TempEnchant3)

  --position the temp enchant buttons
  TempEnchant1:ClearAllPoints()
  TempEnchant1:SetPoint("TOPRIGHT", rBFS_BuffDragFrame, "TOPRIGHT", 0, 0) --button will be repositioned later in case temp enchant and consolidated buffs are both available
  TempEnchant2:ClearAllPoints()
  TempEnchant2:SetPoint("TOPRIGHT", TempEnchant1, "TOPLEFT", -cfg.buffFrame.colSpacing, 0)
  TempEnchant3:ClearAllPoints()
  TempEnchant3:SetPoint("TOPRIGHT", TempEnchant2, "TOPLEFT", -cfg.buffFrame.colSpacing, 0)



  --hook Blizzard functions
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", updateAllBuffAnchors)
  hooksecurefunc("DebuffButton_UpdateAnchors", updateDebuffAnchors)
