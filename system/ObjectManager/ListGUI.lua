local DiesalGUI = LibStub("DiesalGUI-1.0");
local _addonColor = '|cff'..NeP.Addon.Interface.GuiColor;
local _tittleGUI = '|T'..NeP.Addon.Info.Logo..':20:20|t'.._addonColor..NeP.Addon.Info.Nick;
local _objectTable = NeP.ObjectManager.unitFriendlyCache;
local _Displaying = 'Friendly List';
local OPTIONS_WIDTH = 524;
local OPTIONS_HEIGHT = 250;
local scrollMax = 0;
local SETTINGS_WIDTH = 200;

local _addText = function(parent)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	return text
end

local _addButton = function(parent)
	local Button = CreateFrame("Button", nil, parent)
	Button:SetWidth(100)
	Button:SetHeight(30)
	Button:SetNormalFontObject("GameFontNormal")
	Button.Button1 = Button:CreateTexture()
	Button.Button1:SetTexture(255, 255 ,255 , 0.1)
	Button.Button1:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button1:SetAllPoints() 
	Button.Button2 = Button:CreateTexture()
	Button.Button2:SetTexture(0.5,0.5,0.5,1)
	Button.Button2:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button2:SetAllPoints()
	Button.Button3 = Button:CreateTexture()
	Button.Button3:SetTexture(0,0,0,1)
	Button.Button3:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button3:SetAllPoints()
	Button:SetNormalTexture(Button.Button1)
	Button:SetHighlightTexture(Button.Button2)
	Button:SetPushedTexture(Button.Button3)
	Button.text = Button:CreateFontString(nil, "OVERLAY")
	Button.text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	Button.text:SetPoint("CENTER", 0, 0)
	return Button
end

local _addScrollFrame = function(parent)
	local scrollframe = CreateFrame("ScrollFrame", nil, parent) 
	scrollframe.texture = scrollframe:CreateTexture() 
	scrollframe.texture:SetAllPoints() 
	scrollframe.texture:SetTexture(255,255,255,0.3)
	scrollframe.scrollbar = CreateFrame("Slider", "FPreviewScrollBar", scrollframe)
	scrollframe.scrollbar.bg = scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollframe.scrollbar.bg:SetAllPoints(true)
	scrollframe.scrollbar.bg:SetTexture(255, 255, 255, 0.1)
	scrollframe.scrollbar.thumb = scrollframe.scrollbar:CreateTexture(nil, "OVERLAY")
	scrollframe.scrollbar.thumb:SetTexture(0, 0, 0, 1)
	scrollframe.scrollbar.thumb:SetSize(16, 16)
	scrollframe.scrollbar:SetThumbTexture(scrollframe.scrollbar.thumb)
	scrollframe.scrollbar:SetOrientation("VERTICAL");
	scrollframe.scrollbar:SetSize(16, OPTIONS_HEIGHT - 60)
	scrollframe.scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 0, 0)
	scrollframe.scrollbar:SetMinMaxValues(0, scrollMax)
	scrollframe.scrollbar:SetValue(0)
	scrollframe.scrollbar:SetScript("OnValueChanged", function(self)
		  scrollframe:SetVerticalScroll(self:GetValue())
	end)
	scrollframe:EnableMouseWheel(true)
	scrollframe:SetScript("OnMouseWheel", function(self, delta)
		  local current = scrollframe.scrollbar:GetValue()
		  if IsShiftKeyDown() and (delta > 0) then
			 scrollframe.scrollbar:SetValue(0)
		  elseif IsShiftKeyDown() and (delta < 0) then
			 scrollframe.scrollbar:SetValue(scrollMax)
		  elseif (delta < 0) and (current < scrollMax) then
			 scrollframe.scrollbar:SetValue(current + 20)
		  elseif (delta > 0) and (current > 1) then
			 scrollframe.scrollbar:SetValue(current - 20)
		  end
	end)
	return scrollframe
end

local _addFrame = function(parent)
	local Frame = CreateFrame("Frame", nil, parent)
	Frame.texture = Frame:CreateTexture() 
	Frame.texture:SetAllPoints() 
	Frame.texture:SetTexture(0,0,0,0.7)
	return Frame
end

local _addCheckButton = function(parent)
	local createCheckBox = CreateFrame("CheckButton", "UICheckButtonTemplateTest", parent, "UICheckButtonTemplate")
	createCheckBox:ClearAllPoints();
	createCheckBox:SetSize(15, 15)
	createCheckBox.text = parent:CreateFontString(nil, "OVERLAY")
	
	return createCheckBox
end

local statusBars = { }
local statusBarsUsed = { }

function CreateFrame_VARIABLES_LOADED()
	
	-- Parent mainFrame 
	local mainFrame = _addFrame(UIParent)
	mainFrame:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
	mainFrame:SetPoint("CENTER") 
	mainFrame:SetMovable(true)
	mainFrame.texture:SetTexture(0,0,0,0.7)
	mainFrame:SetClampedToScreen(true)

	-- Settings Frame
	local settingsFrame = _addFrame(mainFrame)
	settingsFrame:SetSize(SETTINGS_WIDTH, OPTIONS_HEIGHT) 
	settingsFrame:SetPoint("BOTTOMRIGHT", SETTINGS_WIDTH, 0) 
	settingsFrame:Hide()

	-- Settings Scroll Frame
	local SettingsScroll = _addScrollFrame(settingsFrame)
	SettingsScroll:SetSize(SETTINGS_WIDTH-16, OPTIONS_HEIGHT - 60)  
	SettingsScroll:SetPoint("TOP", -8, -30)
	SettingsScroll.scrollbar:SetMinMaxValues(0, 400-OPTIONS_HEIGHT)

	-- Settings Content Frame 
	local settingsContentFrame = _addFrame(SettingsScroll)
	settingsContentFrame:SetPoint("TOP", SettingsScroll) 
	settingsContentFrame:SetSize(SETTINGS_WIDTH-16, 400)

	local _SettinsCount = 0
	-- Settings Content
	local SettingsText = _addText(settingsContentFrame)
	_SettinsCount = _SettinsCount + 1
	SettingsText:SetPoint("TOP", settingsContentFrame, 0, 0)
	SettingsText:SetText('Settings:')
	SettingsText:SetSize(SETTINGS_WIDTH-16, 15)
	
	-- Health Text checkbox
	local HealthTextCheckbox = _addCheckButton(settingsContentFrame)
	_SettinsCount = _SettinsCount + 1
	HealthTextCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthText'));
	HealthTextCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
	HealthTextCheckbox:SetScript("OnClick", function(self)
		NeP.Config.writeKey('OMList', 'ShowHealthText', self:GetChecked());
	end);
	local HealthText = _addText(settingsContentFrame)
	HealthText:SetSize(SETTINGS_WIDTH-31, 10)
	HealthText:SetText('Show Health')
	HealthText:SetFont("Fonts\\FRIZQT__.TTF", 10)
	HealthText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
	
	-- Health Bars checkbox
	local HealthBarCheckbox = _addCheckButton(settingsContentFrame)
	_SettinsCount = _SettinsCount + 1
	HealthBarCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthBars'));
	HealthBarCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
	HealthBarCheckbox:SetScript("OnClick", function(self)
		NeP.Config.writeKey('OMList', 'ShowHealthBars', self:GetChecked());
	end);
	local HealthBarText = _addText(settingsContentFrame)
	HealthBarText:SetSize(SETTINGS_WIDTH-31, 10)
	HealthBarText:SetText('Enable Health Bars')
	HealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 10)
	HealthBarText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
	
	
	SettingsScroll:SetScrollChild(settingsContentFrame)

	-- Title Frame
	local titleFrame = _addFrame(mainFrame)
	titleFrame:SetSize(OPTIONS_WIDTH-30, 30) 
	titleFrame:SetPoint("TOPLEFT", mainFrame)
	titleFrame:EnableMouse(true)
	titleFrame:RegisterForDrag("LeftButton")
	titleFrame.texture:SetTexture(0,0,0,1)
	titleFrame:SetScript("OnDragStart", function(self) 
		self:GetParent():StartMoving()
	end)
	titleFrame:SetScript("OnDragStop", function(self) 
		self:GetParent():StopMovingOrSizing()
	end)
	local titleText1 = _addText(titleFrame)
	titleText1:SetPoint("TOPLEFT", 0, 0)
	titleText1:SetText(_tittleGUI..'|r ObjectManager GUI')
	local titleText2 = _addText(titleFrame)
	titleText2:SetPoint("RIGHT", -20, 0)
	titleText2:SetText('')
	local titleText3 = _addText(titleFrame)
	titleText3:SetPoint("RIGHT", -100, 0)
	titleText3:SetText('')

	-- Close Button
	local closeButton = _addButton(mainFrame)
	closeButton:SetText("|cff000000Close")
	closeButton:SetPoint("BOTTOMLEFT", 0, 0)
	closeButton.Button1:SetTexture(153, 0 ,0 , 0.5)
	closeButton:SetScript("OnClick", function(self) 
		mainFrame:Hide(); 
		_CacheShow = false 
	end)

	-- Enemy Button
	local enemieButton = _addButton(mainFrame)
	enemieButton:SetText("|cffFFFFFFEnemie List")
	enemieButton:SetPoint("BOTTOMRIGHT", 0, 0)
	enemieButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.unitCache; 
		_Displaying = 'Enemy List' 
	end)

	-- Friendly Button
	local friendlyButton = _addButton(mainFrame)
	friendlyButton:SetText("|cffFFFFFFFriendly List")
	friendlyButton:SetPoint("BOTTOMRIGHT", -100, 0)
	friendlyButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.unitFriendlyCache; 
		_Displaying = 'Friendly List' 
	end)

	-- Object Button
	local objectButton = _addButton(mainFrame)
	objectButton:SetText("|cffFFFFFFObjects List")
	objectButton:SetPoint("BOTTOMRIGHT", -200, 0)
	objectButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.objectsCache; 
		_Displaying = 'Objects List' 
	end)

	-- All Button
	local allButton = _addButton(mainFrame)
	allButton:SetText("|cff000000All List")
	allButton:SetPoint("BOTTOMRIGHT", -300, 0)
	allButton:SetSize(50, 30)
	allButton.Button1:SetTexture(0, 255, 0, 1)
	allButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.objectsCache; 
		_Displaying = 'All' 
	end)

	-- Settings Button
	local settingsButton = _addButton(mainFrame)
	settingsButton:SetPoint("TOPRIGHT", 0, 0)
	settingsButton:SetSize(30, 30)
	settingsButton.text:SetText("|cffFFFFFF»")
	settingsButton:SetScript("OnClick", function()
		if settingsFrame:IsShown() then
			settingsFrame:Hide();
			settingsButton.text:SetText("|cffFFFFFFS: »")
			titleFrame:SetSize(OPTIONS_WIDTH-30, 30); 
			settingsButton:SetPoint("TOPRIGHT", 0, 0) 
		else
			settingsButton.text:SetText("|cffFFFFFFS: «")
			settingsFrame:Show(); 
			titleFrame:SetSize(OPTIONS_WIDTH+200-30, 30); 
			settingsButton:SetPoint("TOPRIGHT", 200, 0)
		end
	end)

	-- Settings Frame Close Button
	local settingsCloseButton = _addButton(settingsFrame)
	settingsCloseButton:SetText("|cffFFFFFFClose Settings")
	settingsCloseButton:SetPoint("BOTTOM", 0, 0)
	settingsCloseButton:SetScript("OnClick", function(self) 
		settingsFrame:Hide();
		settingsButton.text:SetText("|cffFFFFFFS: »")
		titleFrame:SetSize(OPTIONS_WIDTH-30, 30); 
		settingsButton:SetPoint("TOPRIGHT", 0, 0) 
	end)

	-- Objects Scroll Frame
	local ObjectScroll = _addScrollFrame(mainFrame)
	ObjectScroll:SetSize(OPTIONS_WIDTH-16, OPTIONS_HEIGHT - 60)  
	ObjectScroll:SetPoint("TOPLEFT", 0, -30)
	ObjectScroll.texture:SetTexture(0,0,0,0)

	-- Content Frame 
	local objectsContentFrame = _addFrame(ObjectScroll)
	objectsContentFrame:SetSize(OPTIONS_WIDTH-16, 0)
	objectsContentFrame:SetPoint("TOPLEFT", 0, 0)
	objectsContentFrame.texture:SetTexture(0,0,0,0)

	ObjectScroll:SetScrollChild(objectsContentFrame)

	local _CacheShow = false

	function NeP.Addon.Interface.OMGUI()
		_CacheShow = not _CacheShow
		if _CacheShow then
			mainFrame:Show()
		else
			mainFrame:Hide()
		end
	end

	local function getStatusBar()
		local statusBar = tremove(statusBars)
		if not statusBar then
			statusBar = DiesalGUI:Create('StatusBar')
			statusBar:SetParent(objectsContentFrame)
			statusBar.frame:SetHeight(15)
			statusBar.frame.Left:SetPoint("LEFT", statusBar.frame)
			statusBar.frame:SetStatusBarColor(255, 255, 255, 0.5)
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
				titleText3:SetText('|cffCCCCCC('.._Displaying..')')

				if _Displaying == 'All' then
					if FireHack then
						local totalObjects = ObjectCount()
						titleText2:SetText('|cffff0000Total: '..totalObjects)
						for i=1, totalObjects do
							local Obj = ObjectWithIndex(i)
							if ObjectExists(Obj) then
								local distance = (NeP.Core.Distance('player', Obj) or '???')
								local name = (UnitName(Obj) or '???')
								local health = (UnitHealth(Obj) or 100)
								local statusBar = getStatusBar()
								statusBar.frame:SetPoint("TOPLEFT", objectsContentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
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
					titleText2:SetText('|cffff0000Total: '..#_objectTable)
						if #_objectTable > 0 then
							for i=1,#_objectTable do
							local _object = _objectTable[i]
							local name = (_object.name or '???')
							local health = (_object.health or 100)
							local distance = (_object.distance or '???')
							local statusBar = getStatusBar()

							statusBar.frame:SetPoint("TOPLEFT", objectsContentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
							statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(_object.key)..name..' |cffFFFFFF( Distance: '..distance..' )')
							
							if NeP.Config.readKey('OMList', 'ShowHealthText') then
								statusBar.frame.Right:SetText('(Health:'..(health)..'%'..')')
								statusBar.frame.Right:Show()
							else
								statusBar.frame.Right:Hide()
							end
							
							if NeP.Config.readKey('OMList', 'ShowHealthBars') then
								statusBar:SetValue(health)
							else
								statusBar:SetValue(0)
							end
							
							statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(_object.key) end)
							height = height + 16
							currentRow = currentRow + 1
						end
					end
				end
				
				if height > OPTIONS_HEIGHT then
					scrollMax = height - (OPTIONS_HEIGHT-60)
				else
					scrollMax = 0
				end
				
				objectsContentFrame:SetSize(OPTIONS_WIDTH-16, height)
				ObjectScroll.scrollbar:SetMinMaxValues(0, scrollMax)

			end
		end
	end), nil)

mainFrame:Hide()
	
 end