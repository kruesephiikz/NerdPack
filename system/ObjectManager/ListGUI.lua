local DiesalGUI = LibStub("DiesalGUI-1.0");
local _addonColor = '|cff'..NeP.Interface.addonColor;
local _tittleGUI = '|T'..NeP.Info.Logo..':20:20|t'.._addonColor..NeP.Info.Nick;
local _objectTable = NeP.ObjectManager.unitFriendlyCache;
local _Displaying = 'Friendly List';
local OPTIONS_WIDTH = 400;
local OPTIONS_HEIGHT = 400;
local scrollMax = 0;
local SETTINGS_WIDTH = 200;

local statusBars = { }
local statusBarsUsed = { }

NeP.Config.defaults['OMList'] = {
	['test'] = false,
	['ShowDPS'] = false,
	['ShowInfoText'] = true,
	['ShowHealthBars'] = true,
	['ShowHealthText'] = true
}

local getAllObjects = function()
	local ObjTable = {}
	if FireHack then
		for i=1, ObjectCount() do
			local Obj = ObjectWithIndex(i)
			if ObjectExists(Obj) then
				ObjTable[#ObjTable+1] = {
					key=Obj,
					name=UnitName(Obj)
				}
			end
		end
	end
	return ObjTable
end

function OMGUI_RUN()
	
	NeP_OMLIST = NeP.Interface.addFrame(NeP_Frame)
	NeP_OMLIST:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
	NeP_OMLIST:SetPoint("TOP", 0, -15) 
	--NeP_OMLIST:SetMovable(true)
	NeP_OMLIST.texture:SetTexture(0,0,0,0.7)
	--NeP_OMLIST:SetClampedToScreen(true)

	-- Settings Frame
	local settingsFrame = NeP.Interface.addFrame(NeP_OMLIST)
	settingsFrame:SetSize(SETTINGS_WIDTH, OPTIONS_HEIGHT) 
	settingsFrame:SetPoint("BOTTOMRIGHT", SETTINGS_WIDTH, 0) 
	settingsFrame:Hide()

	-- Settings Scroll Frame
	local SettingsScroll = NeP.Interface.addScrollFrame(settingsFrame)
	SettingsScroll:SetSize(SETTINGS_WIDTH-16, OPTIONS_HEIGHT - 60)  
	SettingsScroll:SetPoint("TOP", -8, -30)
	SettingsScroll.scrollbar:SetMinMaxValues(0, 400-OPTIONS_HEIGHT)
	SettingsScroll.scrollbar:SetSize(16, OPTIONS_HEIGHT - 60)  

	-- Settings Content Frame 
	local settingsContentFrame = NeP.Interface.addFrame(SettingsScroll)
	settingsContentFrame:SetPoint("TOP", SettingsScroll) 
	settingsContentFrame:SetSize(SETTINGS_WIDTH-16, 400)

	local _SettinsCount = 0
	-- Settings Content
	local SettingsText = NeP.Interface.addText(settingsContentFrame)
	_SettinsCount = _SettinsCount + 1
	SettingsText:SetPoint("TOP", settingsContentFrame, 0, 0)
	SettingsText:SetText('Settings:')
	SettingsText:SetSize(SETTINGS_WIDTH-16, 15)
	
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
	
	
	SettingsScroll:SetScrollChild(settingsContentFrame)

	-- Title Frame
	local titleFrame = NeP.Interface.addFrame(NeP_OMLIST)
	titleFrame:SetSize(OPTIONS_WIDTH-30, 30) 
	titleFrame:SetPoint("TOPLEFT", NeP_OMLIST)
	--titleFrame:EnableMouse(true)
	titleFrame:RegisterForDrag("LeftButton")
	titleFrame.texture:SetTexture(0,0,0,1)
	--titleFrame:SetScript("OnDragStart", function(self) 
	--	self:GetParent():StartMoving()
	--end)
	--titleFrame:SetScript("OnDragStop", function(self) 
	--	self:GetParent():StopMovingOrSizing()
	--end)
	local titleText1 = NeP.Interface.addText(titleFrame)
	titleText1:SetPoint("LEFT", 0, 0)
	titleText1:SetText('OM')
	local titleText2 = NeP.Interface.addText(titleFrame)
	titleText2:SetPoint("RIGHT", -20, 0)
	titleText2:SetText('')
	local titleText3 = NeP.Interface.addText(titleFrame)
	titleText3:SetPoint("RIGHT", -100, 0)
	titleText3:SetText('')

	-- Enemy Button
	local enemieButton = NeP.Interface.addButton(NeP_OMLIST)
	enemieButton:SetText("|cffFFFFFFEnemie List")
	enemieButton:SetPoint("BOTTOMRIGHT", 0, 0)
	enemieButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.unitCache; 
		_Displaying = 'Enemy List' 
	end)

	-- Friendly Button
	local friendlyButton = NeP.Interface.addButton(NeP_OMLIST)
	friendlyButton:SetText("|cffFFFFFFFriendly List")
	friendlyButton:SetPoint("BOTTOMRIGHT", -100, 0)
	friendlyButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.unitFriendlyCache; 
		_Displaying = 'Friendly List' 
	end)

	-- Object Button
	local objectButton = NeP.Interface.addButton(NeP_OMLIST)
	objectButton:SetText("|cffFFFFFFObjects List")
	objectButton:SetPoint("BOTTOMRIGHT", -200, 0)
	objectButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.ObjectManager.objectsCache; 
		_Displaying = 'Objects List' 
	end)
	
	-- ALL Button
	local objectButton = NeP.Interface.addButton(NeP_OMLIST)
	objectButton:SetText("|cffFFFFFFAll Objects")
	objectButton:SetPoint("BOTTOMRIGHT", -300, 0)
	objectButton:SetScript("OnClick", function(self) 
		_objectTable = getAllObjects(); 
		_Displaying = 'All Objects' 
	end)
	objectButton.Button1:SetTexture(0, 255, 0, 0.3)

	-- Settings Button
	local settingsButton = NeP.Interface.addButton(NeP_OMLIST)
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
	local settingsCloseButton = NeP.Interface.addButton(settingsFrame)
	settingsCloseButton:SetText("|cffFFFFFFClose Settings")
	settingsCloseButton:SetPoint("BOTTOM", 0, 0)
	settingsCloseButton:SetScript("OnClick", function(self) 
		settingsFrame:Hide();
		settingsButton.text:SetText("|cffFFFFFFS: »")
		titleFrame:SetSize(OPTIONS_WIDTH-30, 30); 
		settingsButton:SetPoint("TOPRIGHT", 0, 0) 
	end)

	-- Objects Scroll Frame
	local ObjectScroll = NeP.Interface.addScrollFrame(NeP_OMLIST)
	ObjectScroll:SetSize(OPTIONS_WIDTH-16, OPTIONS_HEIGHT - 60)  
	ObjectScroll:SetPoint("TOPLEFT", 0, -30)
	ObjectScroll.texture:SetTexture(0,0,0,0)
	ObjectScroll.scrollbar:SetSize(16, OPTIONS_HEIGHT - 60)  

	-- Content Frame 
	local objectsContentFrame = NeP.Interface.addFrame(ObjectScroll)
	objectsContentFrame:SetSize(OPTIONS_WIDTH-16, 0)
	objectsContentFrame:SetPoint("TOPLEFT", 0, 0)
	objectsContentFrame.texture:SetTexture(0,0,0,0)

	ObjectScroll:SetScrollChild(objectsContentFrame)

	local _CacheShow = false

	function NeP.Interface.OMGUI()
		_CacheShow = not _CacheShow
		if _CacheShow then
			NeP_OMLIST:Show()
		else
			NeP_OMLIST:Hide()
		end
	end

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
	
	C_Timer.NewTicker(0.1, (function()
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

NeP_OMLIST:Hide()
	
 end