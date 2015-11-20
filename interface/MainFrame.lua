NeP.Config.Defaults['NePFrame'] = {
	['POS_1'] = 'TOP',
	['POS_2'] = 0,
	['POS_3'] = 0
}

function StatusGUI_RUN()
	
	local _addonColor = '|cff'..NeP.Interface.addonColor
	local textColor = '|cffFFFFFF'
	local OPTIONS_HEIGHT = 30
	
	-- Main Farme (PARENT)
	NeP_Frame = NeP.Interface.addFrame(UIParent)
	NeP_Frame:SetPoint(NeP.Config.readKey('NePFrame', 'POS_1'), NeP.Config.readKey('NePFrame', 'POS_2'), NeP.Config.readKey('NePFrame', 'POS_3'))
	NeP_Frame:SetMovable(NeP.Core.PeFetch('NePConf', 'NePFrameMove'))
	NeP_Frame:EnableMouse(NeP.Core.PeFetch('NePConf', 'NePFrameMove'))
	NeP_Frame:RegisterForDrag('LeftButton')
	NeP_Frame:SetScript('OnDragStart', NeP_Frame.StartMoving)
	NeP_Frame:SetScript('OnDragStop', function(self)
		local from, _, to, x, y = self:GetPoint()
		self:StopMovingOrSizing()
		NeP.Config.writeKey('NePFrame', 'POS_1', from)
		NeP.Config.writeKey('NePFrame', 'POS_2', x)
		NeP.Config.writeKey('NePFrame', 'POS_3', y)
	end)
	NeP_Frame:SetFrameLevel(0)
	NeP_Frame:SetFrameStrata('HIGH')
	NeP_Frame:SetClampedToScreen(true)
	
		-- Addon Name text.
		local Tittle_Text = NeP.Interface.addText(NeP_Frame)
		Tittle_Text:SetPoint('LEFT', NeP_Frame, 0, 0)
		Tittle_Text:SetText('|T'..NeP.Info.Logo..':10:10|t'.._addonColor..NeP.Info.Name)
		Tittle_Text:SetFont('Fonts\\FRIZQT__.TTF', NeP.Core.PeFetch('NePConf', 'NePFrameSize') or 20)
		Tittle_Text:SetSize(Tittle_Text:GetStringWidth(), Tittle_Text:GetStringHeight())
		
		-- Button for minimizing menus or other child GUI's.
		local minButton = NeP.Interface.addButton(NeP_Frame)
		minButton.text:SetText('=')
		minButton:SetPoint('RIGHT', NeP_Frame, 0, 0)
		minButton:SetSize(15, Tittle_Text:GetStringHeight()) 
	
	-- Set Main Frame size depending on 'Tittle_Text' and 'minButton'.
	NeP_Frame:SetSize(Tittle_Text:GetStringWidth()+minButton:GetWidth(), Tittle_Text:GetStringHeight())
	
		-- GUI wich displays alerts
		local AlertGUI = NeP.Interface.addFrame(NeP_Frame)
		AlertGUI:SetPoint('TOP', NeP_Frame, 0, -Tittle_Text:GetStringHeight()) 
		AlertGUI:SetClampedToScreen(true)
		local AlertGUI_Text = NeP.Interface.addText(AlertGUI)
		AlertGUI_Text:SetPoint('TOP', AlertGUI, 0, 0)
		AlertGUI_Text:SetText('')
		AlertGUI_Text:SetFont('Fonts\\FRIZQT__.TTF', 30)
		AlertGUI:SetAlpha(1)
		AlertGUI:Hide()
		
		-- Menu wich contains all buttons
		local MenuGUI = NeP.Interface.addFrame(NeP_Frame)
		MenuGUI:SetPoint('TOP', NeP_Frame, 0, -Tittle_Text:GetStringHeight())
		MenuGUI:SetClampedToScreen(true)
		
			-- Vars
			local buttonH = 15
			--local buttonP = 30 (FIXME: add padding)
			local buttonsTH = 5
			
			local statusText2 = NeP.Interface.addText(MenuGUI)
			statusText2:SetPoint('TOP', MenuGUI, 0, 0)
			statusText2:SetText(_addonColor..'Version:|r '..NeP.Info.Version..' '..NeP.Info.Branch)
			statusText2:SetSize(statusText2:GetStringWidth(), statusText2:GetStringHeight())
			
			-- Fishing
			buttonsTH = buttonsTH + buttonH
			local fishingButton = NeP.Interface.addButton(MenuGUI)
			fishingButton.text:SetText('FishingBot')
			fishingButton:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			fishingButton:SetSize(statusText2:GetStringWidth()-10, buttonH)
			fishingButton:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.displayGUI('fishingBot')
			end)
			
			-- ObjectManager
			buttonsTH = buttonsTH + buttonH
			local OMButton = NeP.Interface.addButton(MenuGUI)
			OMButton.text:SetText('ObjectManager')
			OMButton:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			OMButton:SetSize(statusText2:GetStringWidth()-10, buttonH)
			OMButton:SetScript('OnClick', function(self)
				_handleFrames()
				NeP_OMLIST:Show()
			end)
			
			-- ItemBot
			buttonsTH = buttonsTH + buttonH
			local ITButtom = NeP.Interface.addButton(MenuGUI)
			ITButtom.text:SetText('ItemBot')
			ITButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			ITButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			ITButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.displayGUI('itemBot')
			end)
			
			-- Information
			buttonsTH = buttonsTH + buttonH
			local InfoButtom = NeP.Interface.addButton(MenuGUI)
			InfoButtom.text:SetText('Information')
			InfoButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			InfoButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			InfoButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.displayGUI('Info')
			end)
			
			-- Class Settings
			buttonsTH = buttonsTH + buttonH
			local ClassButtom = NeP.Interface.addButton(MenuGUI)
			ClassButtom.text:SetText('Class Settings')
			ClassButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			ClassButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			ClassButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Interface.ClassGUI()
			end)
			
			-- General Settings
			buttonsTH = buttonsTH + buttonH
			local SettingsButtom = NeP.Interface.addButton(MenuGUI)
			SettingsButtom.text:SetText('General Settings')
			SettingsButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			SettingsButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			SettingsButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.displayGUI('Settings')
			end)
			
			-- Overlays
			buttonsTH = buttonsTH + buttonH
			local OverlaysButtom = NeP.Interface.addButton(MenuGUI)
			OverlaysButtom.text:SetText('Overlays')
			OverlaysButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			OverlaysButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			OverlaysButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.displayGUI('Overlays')
			end)
			
			-- Dummy Testing
			buttonsTH = buttonsTH + buttonH
			local DummyButtom = NeP.Interface.addButton(MenuGUI)
			DummyButtom.text:SetText('Dummy Testing')
			DummyButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			DummyButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			DummyButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Extras.dummyTest()
			end)
			
			-- Hide everything
			buttonsTH = buttonsTH + buttonH
			local HideButtom = NeP.Interface.addButton(MenuGUI)
			HideButtom.text:SetText('Hide Everything')
			HideButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			HideButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			HideButtom:SetScript('OnClick', function(self)
				_handleFrames()
				NeP.Core.HideAll()
			end)
			
			-- Donate
			buttonsTH = buttonsTH + buttonH
			local DonateButtom = NeP.Interface.addButton(MenuGUI)
			DonateButtom.text:SetText('Donate')
			DonateButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			DonateButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			DonateButtom:SetScript('OnClick', function(self)
				if FireHack then
					OpenURL(NeP.Info.Forum);
				else
					message('|cff00FF96Please Visit:|cffFFFFFF\n'..NeP.Info.Forum);
				end
			end)
			
			-- Forum
			buttonsTH = buttonsTH + buttonH
			local ForumButtom = NeP.Interface.addButton(MenuGUI)
			ForumButtom.text:SetText('Visit Forum')
			ForumButtom:SetPoint('TOP', MenuGUI, 0, -buttonsTH)
			ForumButtom:SetSize(statusText2:GetStringWidth()-10, buttonH)
			ForumButtom:SetScript('OnClick', function(self)
				_handleFrames()
				if FireHack then
					OpenURL(NeP.Info.Donate);
				else
					message('|cff00FF96Please Visit:|cffFFFFFF\n'..NeP.Info.Donate);
				end
			end)
		
		-- Set the size of the menu deping on how many buttons (uses buttonsTH to get height)
		MenuGUI:SetSize(statusText2:GetStringWidth(), buttonsTH+20)
		MenuGUI:Hide()

	-- Handle when stuff should close or open...
	local openGUIS = {}
	function _handleFrames()
		
		if NeP_OMLIST:IsVisible() then
			NeP_OMLIST:Hide()
		end
			
		if MenuGUI:IsVisible() then
			MenuGUI:Hide()
			minButton.text:SetText('=')
		else
			MenuGUI:Show()
			minButton.text:SetText('^')
		end
	end
	
	-- Close Childs button script (has to be here because it depends on prior things)
	minButton:SetScript('OnClick', function(self) _handleFrames() end)
	
	-- Only show if enabled
	NeP_Frame:Hide()
	if NeP.Core.PeFetch('NePConf', 'NePFrame') then
		NeP_Frame:Show()
	end
	
	
	
							-- Ticker (Update UI elements)
	-- VARs
	local _Time = 0
	local _alertRunning = false

	C_Timer.NewTicker(0.01, (function()
		
		-- display depending alets.
		for i=1, #NeP.Interface.Alerts do
			
			-- If not displaying any alert and one is pending, then display it.
			if not AlertGUI:IsVisible() and not _alertRunning then
				if NeP.Interface.Alerts[i] ~= nil and #NeP.Interface.Alerts > 0 then
					local text = tostring(_addonColor..NeP.Interface.Alerts[i])
					statusText2:SetText('')
					AlertGUI_Text:SetText(text)
					AlertGUI:SetAlpha(1)
					AlertGUI:SetSize(AlertGUI_Text:GetStringWidth()+10, AlertGUI_Text:GetStringHeight())
					AlertGUI:Show()
					if NeP.Core.PeFetch('NePConf', 'Sounds') then
						PlaySoundFile(NeP.Interface.mediaDir..'beep.mp3')
					end
					_Time = GetTime()
					_alertRunning = true
				end
			end
			
			-- End displaying alerts.
			if _Time < GetTime() - 1.0 and _alertRunning then
				if AlertGUI:GetAlpha() == 0 then
					AlertGUI:Hide()
					table.remove(NeP.Interface.Alerts, i)
					_alertRunning = false
					statusText2:SetText(_addonColor..'Version:|cffFFFFFF '..NeP.Info.Version..' '..NeP.Info.Branch)
				else 
					AlertGUI:SetAlpha(AlertGUI:GetAlpha() - .05)
				end
			end
			
		end
		
	end), nil)
	
end