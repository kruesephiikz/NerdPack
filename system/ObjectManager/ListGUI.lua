NeP.Config.Defaults['OMList'] = {
	['ShowDPS'] = false,
	['ShowInfoText'] = true,
	['ShowHealthBars'] = true,
	['ShowHealthText'] = true,
	['POS_1'] = 'CENTER',
	['POS_2'] = 0,
	['POS_3'] = 0
}

-- Tables to Control Status Bars Used
local statusBars = { }
local statusBarsUsed = { }

-- Vars
local OPTIONS_WIDTH = 500;
local OPTIONS_HEIGHT = 300;
local SETTINGS_WIDTH = 200;
local _objectTable = NeP.OM.unitFriend;
local _Displaying = 'Friendly List';
local scrollMax = 0;

-- Locals
local DiesalGUI = LibStub("DiesalGUI-1.0");
local _addonColor = '|cff'..NeP.Interface.addonColor;
local _tittleGUI = '|T'..NeP.Info.Logo..':20:20|t'.._addonColor..NeP.Info.Nick;

function OMGUI_RUN()
	
	NeP_OMLIST = NeP.Interface.addFrame(UIParent)
	NeP_OMLIST:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
	NeP_OMLIST:SetPoint(NeP.Config.readKey('OMList', 'POS_1'), NeP.Config.readKey('OMList', 'POS_2'), NeP.Config.readKey('OMList', 'POS_3'))
	NeP_OMLIST:SetMovable(true)
	NeP_OMLIST:SetFrameLevel(0)
	NeP_OMLIST:RegisterForDrag("LeftButton")
	NeP_OMLIST:EnableMouse(true)
	NeP_OMLIST:RegisterForDrag('LeftButton')
	NeP_OMLIST:SetScript('OnDragStart', NeP_OMLIST.StartMoving)
	NeP_OMLIST:SetScript('OnDragStop', function(self)
		local from, _, to, x, y = self:GetPoint()
		self:StopMovingOrSizing()
		NeP.Config.writeKey('OMList', 'POS_1', from)
		NeP.Config.writeKey('OMList', 'POS_2', x)
		NeP.Config.writeKey('OMList', 'POS_3', y)
	end)
	-- Title
	local titleText1 = NeP.Interface.addText(NeP_OMLIST)
	titleText1:SetPoint("TOPLEFT", 0, -7)
	titleText1:SetText('OM')
	local titleText2 = NeP.Interface.addText(NeP_OMLIST)
	titleText2:SetPoint("TOP", 0, -7)
	titleText2:SetText('')
	local titleText3 = NeP.Interface.addText(NeP_OMLIST)
	titleText3:SetPoint("TOPRIGHT", -35, -7)
	titleText3:SetText('')

		-- Settings Frame
		local settingsFrame = NeP.Interface.addFrame(NeP_OMLIST)
		settingsFrame:SetSize(200, NeP_OMLIST:GetHeight()) 
		settingsFrame:SetPoint("BOTTOMRIGHT", 200, 0)
		settingsFrame:Hide()

			-- Tittle
			local SettingsText = NeP.Interface.addText(settingsFrame)
			SettingsText:SetPoint("TOP", 0, -7)
			SettingsText:SetText('Settings:')
			SettingsText:SetSize(settingsFrame:GetWidth(), 15)
			
			-- Settings Scroll Frame
			local SettingsScroll = NeP.Interface.addScrollFrame(settingsFrame)
			SettingsScroll:SetSize(settingsFrame:GetWidth()-16, settingsFrame:GetHeight()-60)  
			SettingsScroll:SetPoint("TOPLEFT", 0, -30)
			--SettingsScroll.scrollbar:SetMinMaxValues(0, 400-NeP_OMLIST:GetHeight())
			SettingsScroll.scrollbar:SetSize(16, settingsFrame:GetHeight()-60)  

			-- Settings Content Frame 
			local settingsContentFrame = NeP.Interface.addFrame(SettingsScroll)
			settingsContentFrame:SetPoint("TOP", 0, 0) 
			settingsContentFrame:SetSize(SettingsScroll:GetWidth(), SettingsScroll:GetHeight())

				-- Settings Content
				local _SettinsCount = 0
				
				-- Status Text checkbox
				local StatusTextCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				StatusTextCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowInfoText'));
				StatusTextCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				StatusTextCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowInfoText', self:GetChecked());
				end);
				local StatusText = NeP.Interface.addText(settingsContentFrame)
				StatusText:SetSize(SETTINGS_WIDTH-31, 10)
				StatusText:SetText('Show Status Text')
				StatusText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				StatusText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
				-- Health Text checkbox
				local HealthTextCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				HealthTextCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthText'));
				HealthTextCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				HealthTextCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowHealthText', self:GetChecked());
				end);
				local HealthText = NeP.Interface.addText(settingsContentFrame)
				HealthText:SetSize(SETTINGS_WIDTH-31, 10)
				HealthText:SetText('Show Health Text')
				HealthText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				HealthText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
				-- Health Bars checkbox
				local HealthBarCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				HealthBarCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthBars'));
				HealthBarCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				HealthBarCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowHealthBars', self:GetChecked());
				end);
				local HealthBarText = NeP.Interface.addText(settingsContentFrame)
				HealthBarText:SetSize(SETTINGS_WIDTH-31, 10)
				HealthBarText:SetText('Enable Health Bars')
				HealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				HealthBarText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
			-- Settings Frame Close Button
			local settingsCloseButton = NeP.Interface.addButton(settingsFrame)
			settingsCloseButton:SetSize(settingsFrame:GetWidth(), 30)
			settingsCloseButton.text:SetText("Close Settings")
			settingsCloseButton:SetPoint("BOTTOM", 0, 0)
			settingsCloseButton:SetScript("OnClick", function(self) 
				settingsFrame:Hide();
				settingsButton.text:SetText(": »")
				--titleFrame:SetSize(NeP_OMLIST:GetWidth()-30, 30); 
				settingsButton:SetPoint("TOPRIGHT", 0, 0) 
			end)	
			
		SettingsScroll:SetScrollChild(settingsContentFrame)
	
	-- Settings Button
	settingsButton = NeP.Interface.addButton(NeP_OMLIST)
	settingsButton:SetPoint("TOPRIGHT", 0, 0)
	settingsButton:SetSize(30, 30)
	settingsButton.text:SetText("»")
	settingsButton:SetScript("OnClick", function()
		if settingsFrame:IsShown() then
			settingsFrame:Hide()
			settingsButton.text:SetText("S: »")
		else
			settingsButton.text:SetText("S: «")
			settingsFrame:Show()
		end
	end)

	-- Enemy Button
	local enemieButton = NeP.Interface.addButton(NeP_OMLIST)
	enemieButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	enemieButton.text:SetText("Enemie List")
	enemieButton:SetPoint("BOTTOMRIGHT", 0, 0)
	enemieButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.unitEnemie; 
		_Displaying = 'Enemy List' 
	end)

	-- Friendly Button
	local friendlyButton = NeP.Interface.addButton(NeP_OMLIST)
	friendlyButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	friendlyButton.text:SetText("Friendly List")
	friendlyButton:SetPoint("BOTTOM", 0, 0)
	friendlyButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.unitFriend; 
		_Displaying = 'Friendly List' 
	end)

	-- Object Button
	local objectButton = NeP.Interface.addButton(NeP_OMLIST)
	objectButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	objectButton.text:SetText("Objects List")
	objectButton:SetPoint("BOTTOMLEFT", 0, 0)
	objectButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.GameObjects; 
		_Displaying = 'Objects List' 
	end)

		-- Objects Scroll Frame
		local ObjectScroll = NeP.Interface.addScrollFrame(NeP_OMLIST)
		ObjectScroll:SetSize(NeP_OMLIST:GetWidth()-16, NeP_OMLIST:GetHeight() - 60)  
		ObjectScroll:SetPoint("TOPLEFT", 0, -30)
		ObjectScroll.scrollbar:SetSize(16, NeP_OMLIST:GetHeight() - 60)  

		-- Content Frame 
		local objectsContentFrame = NeP.Interface.addFrame(ObjectScroll)
		objectsContentFrame:SetSize(NeP_OMLIST:GetWidth()-16, 0)
		objectsContentFrame:SetPoint("TOPLEFT", 0, 0)

		ObjectScroll:SetScrollChild(objectsContentFrame)

	local function getStatusBar()
		local statusBar = tremove(statusBars)
		if not statusBar then
			statusBar = DiesalGUI:Create('NePStatusBar')
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
	
	local ST_Color = "|cfff28f0d"
	
	C_Timer.NewTicker(0.01, (function()
		if NeP.Core.CurrentCR and NeP_OMLIST:IsShown() then
			if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
				
				recycleStatusBars()
				
				local height = 0
				local currentRow = 0
				titleText3:SetText('|cffCCCCCC('.._Displaying..')')

					titleText2:SetText('|cffff0000Total: '..#_objectTable)
						if #_objectTable > 0 then
							for i=1,#_objectTable do
							local Obj = _objectTable[i]
							local name = Obj.name or ""
							local health = Obj.health or 100
							local distance = Obj.distance or ""
							local guid = UnitGUID(Obj.key) or ""
							local _id = tonumber(guid:match("-(%d+)-%x+$"), 10) or ""
							local statusBar = getStatusBar()

							statusBar.frame:SetPoint("TOPLEFT", objectsContentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
							statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name..ST_Color..' (ID:'.._id..' D:'..distance..')')
							
							if NeP.Config.readKey('OMList', 'ShowInfoText') then
								statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name..ST_Color..' (ID:'.._id..' \ D:'..distance..')')
							else
								statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name)
							end
							
							if NeP.Config.readKey('OMList', 'ShowHealthText') then
								statusBar.frame.Right:SetText('(H:'..(health)..'%'..')')
								statusBar.frame.Right:Show()
							else
								statusBar.frame.Right:Hide()
							end
							
							if NeP.Config.readKey('OMList', 'ShowHealthBars') then
								statusBar:SetValue(health)
							else
								statusBar:SetValue(0)
							end
							
							statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(Obj.key) end)
							height = height + 16
							currentRow = currentRow + 1
						end
					end
				
				if height > NeP_OMLIST:GetHeight() then
					scrollMax = height - (NeP_OMLIST:GetHeight()-60)
				else
					scrollMax = 0
				end
				
				objectsContentFrame:SetSize(NeP_OMLIST:GetWidth()-16, height)
				ObjectScroll.scrollbar:SetMinMaxValues(0, scrollMax)

			end
		end
	end), nil)

-- Hide frame
NeP_OMLIST:Hide()
	
 end