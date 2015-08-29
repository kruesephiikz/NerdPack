local _addonColor = '|cff'..NeP.Interface.addonColor
local buttonColor = "|cffFFFFFF"

local OPTIONS_HEIGHT = 30
local _StatusText = false
local buttonsTotalHeight = 10

NeP.Interface.Alerts = {}

function NeP.Alert(txt)
	if not NeP.Core.hiding and NeP.Core.PeFetch('npconf', 'Alerts') then
		local _txt = tostring(txt)
		table.insert(NeP.Interface.Alerts, _txt)
	end
end

function StatusGUI_RUN()
	
	NeP_Frame = NeP.Interface.addFrame(UIParent)
	NeP_Frame:SetPoint("TOP") 
	NeP_Frame:SetMovable(true)
	NeP_Frame.texture:SetTexture(0,0,0,0.7)
	NeP_Frame:SetClampedToScreen(true)
	local statusText1 = NeP.Interface.addText(NeP_Frame)
	statusText1:SetPoint("LEFT", NeP_Frame, 0, 0)
	statusText1:SetText('|T'..NeP.Info.Logo..':10:10|t'.._addonColor..NeP.Info.Name)
	local minButton = NeP.Interface.addButton(NeP_Frame)
	minButton.text:SetText(buttonColor.."=")
	minButton:SetPoint("RIGHT", NeP_Frame, 0, 0)
	minButton:SetSize(15, statusText1:GetStringHeight()) 
	statusText1:SetSize(statusText1:GetStringWidth(), statusText1:GetStringHeight())
	NeP_Frame:SetSize(statusText1:GetStringWidth()+minButton:GetWidth(), statusText1:GetStringHeight())
	
	local statusGUI2 = NeP.Interface.addFrame(NeP_Frame)
	statusGUI2:SetPoint("TOP", NeP_Frame, 0, -statusText1:GetStringHeight()) 
	statusGUI2.texture:SetTexture(0, 0, 0, 0.3)
	local statusText2 = NeP.Interface.addText(statusGUI2)
	statusText2:SetPoint("TOP", statusGUI2, 0, 0)
	statusText2:SetText(_addonColor..'Version:|cffFFFFFF '..NeP.Info.Version..' '..NeP.Info.Branch)
	statusText2:SetSize(statusText2:GetStringWidth(), statusText2:GetStringHeight())
	statusGUI2:SetSize(statusText2:GetStringWidth(), statusText2:GetStringHeight())
	statusGUI2:Hide()
	
	local statusGUIAlert = NeP.Interface.addFrame(NeP_Frame)
	statusGUIAlert:SetPoint("TOP", NeP_Frame, 0, -statusText1:GetStringHeight()) 
	statusGUIAlert.texture:SetTexture(0, 0, 0, 0.7)
	local statusGUIAlertText = NeP.Interface.addText(statusGUIAlert)
	statusGUIAlertText:SetPoint("TOP", statusGUIAlert, 0, 0)
	statusGUIAlertText:SetText('')
	statusGUIAlertText:SetFont("Fonts\\FRIZQT__.TTF", 30)
	statusGUIAlert:SetAlpha(1)
	statusGUIAlert:Hide()
	
	local statusGUI3 = NeP.Interface.addFrame(statusGUI2)
	statusGUI3:SetPoint("TOP", NeP_Frame, 0, -(statusText1:GetStringHeight()+statusText2:GetStringHeight())) 
	statusGUI3.texture:SetTexture(0, 0, 0, 0.5)
	local fishingButton = NeP.Interface.addButton(statusGUI3)
	fishingButton.text:SetText(buttonColor.."FishingBot")
	fishingButton.Button1:SetTexture(0, 0, 0, 0.7)
	fishingButton:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	fishingButton:SetSize(statusText2:GetStringWidth()-10, 15)
	fishingButton:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.FishingGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local OMButton = NeP.Interface.addButton(statusGUI3)
	OMButton.Button1:SetTexture(0, 0, 0, 0.7)
	OMButton.text:SetText(buttonColor.."ObjectManager")
	OMButton:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	OMButton:SetSize(statusText2:GetStringWidth()-10, 15)
	OMButton:SetScript("OnClick", function(self)
		_HideFrames()
		NeP_OMLIST:Show()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local ITButtom = NeP.Interface.addButton(statusGUI3)
	ITButtom.Button1:SetTexture(0, 0, 0, 0.7)
	ITButtom.text:SetText(buttonColor.."ItemBot")
	ITButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	ITButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	ITButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.FishingGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local InfoButtom = NeP.Interface.addButton(statusGUI3)
	InfoButtom.Button1:SetTexture(0, 0, 0, 0.7)
	InfoButtom.text:SetText(buttonColor.."Information")
	InfoButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	InfoButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	InfoButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.InfoGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local ClassButtom = NeP.Interface.addButton(statusGUI3)
	ClassButtom.Button1:SetTexture(0, 0, 0, 0.7)
	ClassButtom.text:SetText(buttonColor.."Class Settings")
	ClassButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	ClassButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	ClassButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.ClassGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local SettingsButtom = NeP.Interface.addButton(statusGUI3)
	SettingsButtom.Button1:SetTexture(0, 0, 0, 0.7)
	SettingsButtom.text:SetText(buttonColor.."Settings")
	SettingsButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	SettingsButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	SettingsButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.ConfigGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local OverlaysButtom = NeP.Interface.addButton(statusGUI3)
	OverlaysButtom.Button1:SetTexture(0, 0, 0, 0.7)
	OverlaysButtom.text:SetText(buttonColor.."Overlays")
	OverlaysButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	OverlaysButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	OverlaysButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Interface.OverlaysGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local DummyButtom = NeP.Interface.addButton(statusGUI3)
	DummyButtom.Button1:SetTexture(0, 0, 0, 0.7)
	DummyButtom.text:SetText(buttonColor.."Dummy Testing")
	DummyButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	DummyButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	DummyButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Extras.dummyTest()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local HideButtom = NeP.Interface.addButton(statusGUI3)
	HideButtom.Button1:SetTexture(0, 0, 0, 0.7)
	HideButtom.text:SetText(buttonColor.."Hide Everything")
	HideButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	HideButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	HideButtom:SetScript("OnClick", function(self)
		_HideFrames()
		NeP.Core.HideAll()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local DonateButtom = NeP.Interface.addButton(statusGUI3)
	DonateButtom.Button1:SetTexture(0, 0, 0, 0.7)
	DonateButtom.text:SetText(buttonColor.."Donate")
	DonateButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	DonateButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	DonateButtom:SetScript("OnClick", function(self)
		if FireHack then
			OpenURL(NeP.Info.Forum);
		else
			message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Forum);
		end
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local ForumButtom = NeP.Interface.addButton(statusGUI3)
	ForumButtom.Button1:SetTexture(0, 0, 0, 0.7)
	ForumButtom.text:SetText(buttonColor.."Visit Forum")
	ForumButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	ForumButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	ForumButtom:SetScript("OnClick", function(self)
		_HideFrames()
		if FireHack then
			OpenURL(NeP.Info.Donate);
		else
			message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Donate);
		end
	end)
	statusGUI3:SetSize(statusText2:GetStringWidth(), buttonsTotalHeight+20)
	
	
	minButton:SetScript("OnClick", function(self)
		if _StatusText then
			_StatusText = not _StatusText
			statusText1:SetPoint("LEFT", NeP_Frame, 0, 0)
			_HideFrames()
			minButton.text:SetText(buttonColor.."=")
		else
			_StatusText = not _StatusText
			statusText1:SetPoint("CENTER", NeP_Frame, 0, 0)
			statusGUI2:Show()
			minButton.text:SetText(buttonColor.."^")
		end
	end)
	
	local _Time = 0
	local _alertRunning = false

	C_Timer.NewTicker(0.01, (function()
		for i=1, #NeP.Interface.Alerts do
			if not statusGUIAlert:IsVisible() and not _alertRunning then
				if NeP.Interface.Alerts[i] ~= nil and #NeP.Interface.Alerts > 0 then
					local text = tostring(_addonColor..NeP.Interface.Alerts[i])
					statusText2:SetText('')
					statusGUIAlertText:SetText(text)
					statusGUIAlert:SetAlpha(1)
					statusGUIAlert:SetSize(statusGUIAlertText:GetStringWidth()+10, statusGUIAlertText:GetStringHeight())
					statusGUIAlert:Show()
					if NeP.Core.PeFetch('npconf', 'Sounds') then
						PlaySoundFile(NeP.Interface.mediaDir.."beep.mp3")
					end
					_Time = GetTime()
					_alertRunning = true
				end
			end
			if _Time < GetTime() - 1.0 and _alertRunning then
				if statusGUIAlert:GetAlpha() == 0 then
					statusGUIAlert:Hide()
					table.remove(NeP.Interface.Alerts, i)
					_alertRunning = false
					statusText2:SetText(_addonColor..'Version:|cffFFFFFF '..NeP.Info.Version..' '..NeP.Info.Branch)
				else 
					statusGUIAlert:SetAlpha(statusGUIAlert:GetAlpha() - .05)
				end
			end
		end
	end), nil)
	
	function _HideFrames()
		NeP_OMLIST:Hide()
		statusGUI2:Hide()
	end
	
end