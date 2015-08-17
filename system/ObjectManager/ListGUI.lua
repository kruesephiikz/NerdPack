local DiesalGUI = LibStub("DiesalGUI-1.0")
local _addonColor = '|cff'..NeP.Addon.Interface.GuiColor
local _tittleGUI = '|T'..NeP.Addon.Info.Logo..':20:20|t'.._addonColor..NeP.Addon.Info.Nick
local _objectTable = NeP.ObjectManager.unitFriendlyCache
local _Displaying = 'Friendly List'
local OPTIONS_WIDTH = 524
local OPTIONS_HEIGHT = 250
local scrollMax = 0

local _CacheShow = false

function NeP.Addon.Interface.OMGUI()
	_CacheShow = not _CacheShow
	if _CacheShow then
		mainFrame:Show()
	else
		mainFrame:Hide()
	end
end

-- Parent mainFrame 
mainFrame = CreateFrame("Frame", "ObjectManager", UIParent) 
mainFrame:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
mainFrame:SetPoint("CENTER") 
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:EnableMouse(true)
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)
mainFrame.texture = mainFrame:CreateTexture() 
mainFrame.texture:SetAllPoints() 
mainFrame.texture:SetTexture(0,0,0,0.7)


mainFrame.title = CreateFrame("Frame", nil, mainFrame)
mainFrame.title:SetPoint("TOPLEFT", mainFrame)
mainFrame.title:SetWidth(OPTIONS_WIDTH-30)
mainFrame.title:SetHeight(30)
mainFrame.title.texture = mainFrame.title:CreateTexture() 
mainFrame.title.texture:SetAllPoints()
mainFrame.title.texture:SetTexture(0,0,0,1)
mainFrame.title.text1 = mainFrame.title:CreateFontString(nil, "OVERLAY")
mainFrame.title.text1:SetFont("Fonts\\FRIZQT__.TTF", 15)
mainFrame.title.text1:SetPoint("LEFT")
mainFrame.title.text1:SetText(_tittleGUI..'|r ObjectManager GUI')
mainFrame.title.text2 = mainFrame.title:CreateFontString(nil, "OVERLAY")
mainFrame.title.text2:SetFont("Fonts\\FRIZQT__.TTF", 15)
mainFrame.title.text2:SetPoint("RIGHT", -20, 0)
mainFrame.title.text2:SetText('')
mainFrame.title.text3 = mainFrame.title:CreateFontString(nil, "OVERLAY")
mainFrame.title.text3:SetFont("Fonts\\FRIZQT__.TTF", 15)
mainFrame.title.text3:SetPoint("RIGHT", -100, 0)
mainFrame.title.text3:SetText('')
 
 -- Close Button
mainFrame.closeButton = CreateFrame("Button", nil, mainFrame)
mainFrame.closeButton:SetPoint("BOTTOMLEFT", 0, 0)
mainFrame.closeButton:SetWidth(100)
mainFrame.closeButton:SetHeight(30)
mainFrame.closeButton:SetText("|cff000000Close")
mainFrame.closeButton:SetNormalFontObject("GameFontNormal")
mainFrame.closeButton:SetScript("OnClick", function(self) mainFrame:Hide(); _CacheShow = false end)
mainFrame.closeButton.closeButton1 = mainFrame.closeButton:CreateTexture()
mainFrame.closeButton.closeButton1:SetTexture(153, 0 ,0 , 0.5)
mainFrame.closeButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.closeButton.closeButton1:SetAllPoints() 
mainFrame.closeButton.closeButton2 = mainFrame.closeButton:CreateTexture()
mainFrame.closeButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.closeButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.closeButton.closeButton2:SetAllPoints()
mainFrame.closeButton.closeButton3 = mainFrame.closeButton:CreateTexture()
mainFrame.closeButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.closeButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.closeButton.closeButton3:SetAllPoints()
mainFrame.closeButton:SetNormalTexture(mainFrame.closeButton.closeButton1)
mainFrame.closeButton:SetHighlightTexture(mainFrame.closeButton.closeButton2)
mainFrame.closeButton:SetPushedTexture(mainFrame.closeButton.closeButton3)

-- Enemy Button
mainFrame.enemyButton = CreateFrame("Button", nil, mainFrame)
mainFrame.enemyButton:SetPoint("BOTTOMRIGHT", 0, 0)
mainFrame.enemyButton:SetWidth(100)
mainFrame.enemyButton:SetHeight(30)
mainFrame.enemyButton:SetText("|cffFFFFFFEnemy List")
mainFrame.enemyButton:SetNormalFontObject("GameFontNormal")
mainFrame.enemyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitCache; _Displaying = 'Enemy List' end)
mainFrame.enemyButton.closeButton1 = mainFrame.enemyButton:CreateTexture()
mainFrame.enemyButton.closeButton1:SetTexture(255, 255, 255, 0.1)
mainFrame.enemyButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.enemyButton.closeButton1:SetAllPoints() 
mainFrame.enemyButton.closeButton2 = mainFrame.enemyButton:CreateTexture()
mainFrame.enemyButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.enemyButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.enemyButton.closeButton2:SetAllPoints()
mainFrame.enemyButton.closeButton3 = mainFrame.enemyButton:CreateTexture()
mainFrame.enemyButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.enemyButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.enemyButton.closeButton3:SetAllPoints()
mainFrame.enemyButton:SetNormalTexture(mainFrame.enemyButton.closeButton1)
mainFrame.enemyButton:SetHighlightTexture(mainFrame.enemyButton.closeButton2)
mainFrame.enemyButton:SetPushedTexture(mainFrame.enemyButton.closeButton3)

-- Friendly Button
mainFrame.friendlyButton = CreateFrame("Button", nil, mainFrame)
mainFrame.friendlyButton:SetPoint("BOTTOMRIGHT", -100, 0)
mainFrame.friendlyButton:SetWidth(100)
mainFrame.friendlyButton:SetHeight(30)
mainFrame.friendlyButton:SetText("|cffFFFFFFFriendly List")
mainFrame.friendlyButton:SetNormalFontObject("GameFontNormal")
mainFrame.friendlyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitFriendlyCache; _Displaying = 'Friendly List' end)
mainFrame.friendlyButton.closeButton1 = mainFrame.friendlyButton:CreateTexture()
mainFrame.friendlyButton.closeButton1:SetTexture(255, 255, 255, 0.1)
mainFrame.friendlyButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.friendlyButton.closeButton1:SetAllPoints() 
mainFrame.friendlyButton.closeButton2 = mainFrame.friendlyButton:CreateTexture()
mainFrame.friendlyButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.friendlyButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.friendlyButton.closeButton2:SetAllPoints()
mainFrame.friendlyButton.closeButton3 = mainFrame.friendlyButton:CreateTexture()
mainFrame.friendlyButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.friendlyButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.friendlyButton.closeButton3:SetAllPoints()
mainFrame.friendlyButton:SetNormalTexture(mainFrame.friendlyButton.closeButton1)
mainFrame.friendlyButton:SetHighlightTexture(mainFrame.friendlyButton.closeButton2)
mainFrame.friendlyButton:SetPushedTexture(mainFrame.friendlyButton.closeButton3)

-- Object Button
mainFrame.ObjectButton = CreateFrame("Button", nil, mainFrame)
mainFrame.ObjectButton:SetPoint("BOTTOMRIGHT", -200, 0)
mainFrame.ObjectButton:SetWidth(100)
mainFrame.ObjectButton:SetHeight(30)
mainFrame.ObjectButton:SetText("|cffFFFFFFObjects List")
mainFrame.ObjectButton:SetNormalFontObject("GameFontNormal")
mainFrame.ObjectButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.objectsCache; _Displaying = 'Objects List' end)
mainFrame.ObjectButton.closeButton1 = mainFrame.ObjectButton:CreateTexture()
mainFrame.ObjectButton.closeButton1:SetTexture(255, 255, 255, 0.1)
mainFrame.ObjectButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.ObjectButton.closeButton1:SetAllPoints() 
mainFrame.ObjectButton.closeButton2 = mainFrame.ObjectButton:CreateTexture()
mainFrame.ObjectButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.ObjectButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.ObjectButton.closeButton2:SetAllPoints()
mainFrame.ObjectButton.closeButton3 = mainFrame.ObjectButton:CreateTexture()
mainFrame.ObjectButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.ObjectButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.ObjectButton.closeButton3:SetAllPoints()
mainFrame.ObjectButton:SetNormalTexture(mainFrame.ObjectButton.closeButton1)
mainFrame.ObjectButton:SetHighlightTexture(mainFrame.ObjectButton.closeButton2)
mainFrame.ObjectButton:SetPushedTexture(mainFrame.ObjectButton.closeButton3)

-- All Button
mainFrame.AllButton = CreateFrame("Button", nil, mainFrame)
mainFrame.AllButton:SetPoint("BOTTOMRIGHT", -300, 0)
mainFrame.AllButton:SetWidth(50)
mainFrame.AllButton:SetHeight(30)
mainFrame.AllButton:SetText("|cff000000All")
mainFrame.AllButton:SetNormalFontObject("GameFontNormal")
mainFrame.AllButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.objectsCache; _Displaying = 'All' end)
mainFrame.AllButton.closeButton1 = mainFrame.AllButton:CreateTexture()
mainFrame.AllButton.closeButton1:SetTexture(0, 255, 0, 1)
mainFrame.AllButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.AllButton.closeButton1:SetAllPoints() 
mainFrame.AllButton.closeButton2 = mainFrame.AllButton:CreateTexture()
mainFrame.AllButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.AllButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.AllButton.closeButton2:SetAllPoints()
mainFrame.AllButton.closeButton3 = mainFrame.AllButton:CreateTexture()
mainFrame.AllButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.AllButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.AllButton.closeButton3:SetAllPoints()
mainFrame.AllButton:SetNormalTexture(mainFrame.AllButton.closeButton1)
mainFrame.AllButton:SetHighlightTexture(mainFrame.AllButton.closeButton2)
mainFrame.AllButton:SetPushedTexture(mainFrame.AllButton.closeButton3)

-- Settings Button
mainFrame.SettingsButton = CreateFrame("Button", nil, mainFrame)
mainFrame.SettingsButton:SetPoint("TOPRIGHT", 0, 0)
mainFrame.SettingsButton:SetWidth(30)
mainFrame.SettingsButton:SetHeight(30)
mainFrame.SettingsButton:SetText("|cff000000S")
mainFrame.SettingsButton:SetNormalFontObject("GameFontNormal")
mainFrame.SettingsButton:SetScript("OnClick", function() NeP.Addon.Interface.CacheGUI() end)
mainFrame.SettingsButton.closeButton1 = mainFrame.SettingsButton:CreateTexture()
mainFrame.SettingsButton.closeButton1:SetTexture(255, 255, 255, 0.1)
mainFrame.SettingsButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.SettingsButton.closeButton1:SetAllPoints() 
mainFrame.SettingsButton.closeButton2 = mainFrame.SettingsButton:CreateTexture()
mainFrame.SettingsButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
mainFrame.SettingsButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.SettingsButton.closeButton2:SetAllPoints()
mainFrame.SettingsButton.closeButton3 = mainFrame.SettingsButton:CreateTexture()
mainFrame.SettingsButton.closeButton3:SetTexture(0,0,0,1)
mainFrame.SettingsButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
mainFrame.SettingsButton.closeButton3:SetAllPoints()
mainFrame.SettingsButton:SetNormalTexture(mainFrame.SettingsButton.closeButton1)
mainFrame.SettingsButton:SetHighlightTexture(mainFrame.SettingsButton.closeButton2)
mainFrame.SettingsButton:SetPushedTexture(mainFrame.SettingsButton.closeButton3)

mainFrame.scrollframe = CreateFrame("ScrollFrame", nil, mainFrame) 
mainFrame.scrollframe:SetSize(OPTIONS_WIDTH-16, OPTIONS_HEIGHT - 60)  
mainFrame.scrollframe:SetPoint("TOPLEFT", 0, -30) 
mainFrame.scrollframe.texture = mainFrame.scrollframe:CreateTexture() 
mainFrame.scrollframe.texture:SetAllPoints() 
mainFrame.scrollframe.texture:SetTexture(255,255,255,0.3)

mainFrame.scrollbar = CreateFrame("Slider", "FPreviewScrollBar", mainFrame.scrollframe)
mainFrame.scrollbar.bg = mainFrame.scrollbar:CreateTexture(nil, "BACKGROUND")
mainFrame.scrollbar.bg:SetAllPoints(true)
mainFrame.scrollbar.bg:SetTexture(255, 255, 255, 0.1)
mainFrame.scrollbar.thumb = mainFrame.scrollbar:CreateTexture(nil, "OVERLAY")
mainFrame.scrollbar.thumb:SetTexture(0, 0, 0, 1)
mainFrame.scrollbar.thumb:SetSize(16, 16)
mainFrame.scrollbar:SetThumbTexture(mainFrame.scrollbar.thumb)
mainFrame.scrollbar:SetOrientation("VERTICAL");
mainFrame.scrollbar:SetSize(16, OPTIONS_HEIGHT - 60)
mainFrame.scrollbar:SetPoint("TOPLEFT", mainFrame.scrollframe, "TOPRIGHT", 0, 0)
mainFrame.scrollbar:SetMinMaxValues(0, scrollMax)
mainFrame.scrollbar:SetValue(0)
mainFrame.scrollbar:SetScript("OnValueChanged", function(self)
      mainFrame.scrollframe:SetVerticalScroll(self:GetValue())
end)

-- ContentFrame 
mainFrame.scrollframe.contentFrame = CreateFrame("Frame") 
mainFrame.scrollframe.contentFrame:SetPoint("TOPLEFT", 0, 0) 
mainFrame.scrollframe.contentFrame:SetPoint("BOTTOMRIGHT", 0, 0) 
mainFrame.scrollframe.contentFrame:SetSize(OPTIONS_WIDTH-16, 0)
mainFrame.scrollframe.contentFrame.texture = mainFrame.scrollframe.contentFrame:CreateTexture() 
mainFrame.scrollframe.contentFrame.texture:SetAllPoints() 
mainFrame.scrollframe.contentFrame.texture:SetTexture(0, 0, 0, 0.3)
mainFrame.scrollframe.contentFrame:EnableMouseWheel(true)
mainFrame.scrollframe.contentFrame:SetScript("OnMouseWheel", function(self, delta)
      local current = mainFrame.scrollbar:GetValue()
      if IsShiftKeyDown() and (delta > 0) then
         mainFrame.scrollbar:SetValue(0)
      elseif IsShiftKeyDown() and (delta < 0) then
         mainFrame.scrollbar:SetValue(scrollMax)
      elseif (delta < 0) and (current < scrollMax) then
         mainFrame.scrollbar:SetValue(current + 20)
      elseif (delta > 0) and (current > 1) then
         mainFrame.scrollbar:SetValue(current - 20)
      end
end)

mainFrame.scrollframe:SetScrollChild(mainFrame.scrollframe.contentFrame)

local statusBars = { }
local statusBarsUsed = { }

local function getStatusBar()
	local statusBar = tremove(statusBars)
	if not statusBar then
		statusBar = DiesalGUI:Create('StatusBar')
		statusBar:SetParent(mainFrame.scrollframe.contentFrame)
		statusBar.frame:SetHeight(15)
		statusBar.frame.Left:SetPoint("LEFT", statusBar.frame)
		statusBar.frame:SetStatusBarColor(255, 255, 255, 0.3)
		statusBar.frame.Left:SetFont("Fonts\\FRIZQT__.TTF", 13)
		statusBar.frame.Left:SetShadowColor(0,0,0, 0)
		statusBar.frame.Left:SetShadowOffset(-1,-1)
		statusBar.frame.Right:SetPoint("RIGHT", statusBar.frame)
		statusBar.frame.Right:SetFont("Fonts\\FRIZQT__.TTF", 13)
		statusBar.frame.Right:SetShadowColor(0, 0, 0 , 0)
		statusBar.frame.Right:SetShadowOffset(0, 0)
	end
	statusBar:Show()
	table.insert(statusBarsUsed, statusBar)
	return statusBar
end

local function recycleStatusBars()
	for i = #statusBarsUsed, 1, -1 do
		statusBarsUsed[i]:Hide()
		tinsert(statusBars, tremove(statusBarsUsed))
	end
end

C_Timer.NewTicker(0.1, (function()
	if NeP.Core.CurrentCR and _CacheShow then
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			
			recycleStatusBars()
			
			local height = 0
			local currentRow = 0
			mainFrame.title.text3:SetText('|cffCCCCCC('.._Displaying..')')

			if _Displaying == 'All' then
				if FireHack then
					local totalObjects = ObjectCount()
					mainFrame.title.text2:SetText('|cffff0000Total: '..totalObjects)
					for i=1, totalObjects do
						local Obj = ObjectWithIndex(i)
						if ObjectExists(Obj) then
							local distance = (NeP.Core.Distance('player', Obj) or '???')
							local name = (UnitName(Obj) or '???')
							local health = (UnitHealth(Obj) or 100)
							local statusBar = getStatusBar()
							statusBar.frame:SetPoint("TOPLEFT", mainFrame.scrollframe.contentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
							statusBar:SetValue(health)
							statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj)..name..' |cffFFFFFF( Distance: '..distance..' )')
							statusBar.frame.Right:SetText('(Health:'..(health)..'%'..')')
							statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(Obj) end)
							height = height + 15
							currentRow = currentRow + 1
						end
					end
				end
			else
				mainFrame.title.text2:SetText('|cffff0000Total: '..#_objectTable)
					if #_objectTable > 0 then
						for i=1,#_objectTable do
						local _object = _objectTable[i]
						local name = (_object.name or '???')
						local health = (_object.health or 100)
						local distance = (_object.distance or '???')
						local statusBar = getStatusBar()
						statusBar.frame:SetPoint("TOPLEFT", mainFrame.scrollframe.contentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
						statusBar:SetValue(health)
						statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(_object.key)..name..' |cffFFFFFF( Distance: '..distance..' )')
						statusBar.frame.Right:SetText('(Health:'..(health)..'%'..')')
						statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(_object.key) end)
						height = height + 15
						currentRow = currentRow + 1
					end
				end
			end
			
			if height > OPTIONS_HEIGHT then
				scrollMax = height - (OPTIONS_HEIGHT-60)
			else
				scrollMax = 0
			end
			mainFrame.scrollframe.contentFrame:SetSize(OPTIONS_WIDTH-16, height)
			mainFrame.scrollbar:SetMinMaxValues(0, scrollMax)
		end
	end
end), nil)

mainFrame:Hide()