local _addonColor = NeP.Addon.Interface.addonColor
local _playerInfo = "|r[|cff"..NeP.Core.classColor('player')..UnitClass('player').." - "..select(2, GetSpecializationInfo(GetSpecialization())).."|r]"
local buttonColor = "|cffFFFFFF"

local OPTIONS_HEIGHT = 30
local _StatusText = false
local buttonsTotalHeight = 10

function StatusGUI_VARIABLES_LOADED()
	NeP_Frame = NeP.Interface.addFrame(UIParent)
	NeP_Frame:SetPoint("TOP") 
	NeP_Frame:SetMovable(true)
	NeP_Frame.texture:SetTexture(0,0,0,0.7)
	NeP_Frame:SetClampedToScreen(true)
	local statusText1 = NeP.Interface.addText(NeP_Frame)
	statusText1:SetPoint("LEFT", NeP_Frame, 0, 0)
	statusText1:SetText(NeP.Addon.Info.Icon.._addonColor..NeP.Addon.Info.Name)
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
	statusText2:SetText(_addonColor..'Version:|cffFFFFFF '..NeP.Addon.Info.Version..' '..NeP.Addon.Info.Branch)
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
		NeP.Addon.Interface.FishingGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local OMButton = NeP.Interface.addButton(statusGUI3)
	OMButton.Button1:SetTexture(0, 0, 0, 0.7)
	OMButton.text:SetText(buttonColor.."ObjectManager")
	OMButton:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	OMButton:SetSize(statusText2:GetStringWidth()-10, 15)
	OMButton:SetScript("OnClick", function(self)
		NeP.Addon.Interface.OMGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local ITButtom = NeP.Interface.addButton(statusGUI3)
	ITButtom.Button1:SetTexture(0, 0, 0, 0.7)
	ITButtom.text:SetText(buttonColor.."ItemBot")
	ITButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	ITButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	ITButtom:SetScript("OnClick", function(self)
		NeP.Addon.Interface.FishingGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local InfoButtom = NeP.Interface.addButton(statusGUI3)
	InfoButtom.Button1:SetTexture(0, 0, 0, 0.7)
	InfoButtom.text:SetText(buttonColor.."Information")
	InfoButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	InfoButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	InfoButtom:SetScript("OnClick", function(self)
		NeP.Addon.Interface.InfoGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local ClassButtom = NeP.Interface.addButton(statusGUI3)
	ClassButtom.Button1:SetTexture(0, 0, 0, 0.7)
	ClassButtom.text:SetText(buttonColor.."Class Settings")
	ClassButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	ClassButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	ClassButtom:SetScript("OnClick", function(self)
		NeP.Addon.Interface.ClassGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local SettingsButtom = NeP.Interface.addButton(statusGUI3)
	SettingsButtom.Button1:SetTexture(0, 0, 0, 0.7)
	SettingsButtom.text:SetText(buttonColor.."Settings")
	SettingsButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	SettingsButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	SettingsButtom:SetScript("OnClick", function(self)
		NeP.Addon.Interface.ConfigGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local OverlaysButtom = NeP.Interface.addButton(statusGUI3)
	OverlaysButtom.Button1:SetTexture(0, 0, 0, 0.7)
	OverlaysButtom.text:SetText(buttonColor.."Overlays")
	OverlaysButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	OverlaysButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	OverlaysButtom:SetScript("OnClick", function(self)
		NeP.Addon.Interface.OverlaysGUI()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local DummyButtom = NeP.Interface.addButton(statusGUI3)
	DummyButtom.Button1:SetTexture(0, 0, 0, 0.7)
	DummyButtom.text:SetText(buttonColor.."Dummy Testing")
	DummyButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	DummyButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	DummyButtom:SetScript("OnClick", function(self)
		NeP.Extras.dummyTest()
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	local HideButtom = NeP.Interface.addButton(statusGUI3)
	HideButtom.Button1:SetTexture(0, 0, 0, 0.7)
	HideButtom.text:SetText(buttonColor.."Hide Everything")
	HideButtom:SetPoint("TOP", statusGUI3, 0, -buttonsTotalHeight)
	HideButtom:SetSize(statusText2:GetStringWidth()-10, 15)
	HideButtom:SetScript("OnClick", function(self)
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
			OpenURL("http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/498642-pe-mrthesoulzpack.html");
		else
			message("|cff00FF96Please Visit:|cffFFFFFF\nhttp://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/498642-pe-mrthesoulzpack.html");
		end
	end)
	buttonsTotalHeight = buttonsTotalHeight + 15
	statusGUI3:SetSize(statusText2:GetStringWidth(), buttonsTotalHeight+20)
	
	
	minButton:SetScript("OnClick", function(self)
		if _StatusText then
			_StatusText = not _StatusText
			statusText1:SetPoint("LEFT", NeP_Frame, 0, 0)
			statusGUI2:Hide()
			minButton.text:SetText(buttonColor.."=")
		else
			_StatusText = not _StatusText
			statusText1:SetPoint("CENTER", NeP_Frame, 0, 0)
			statusGUI2:Show()
			minButton.text:SetText(buttonColor.."^")
		end
	end)
	
	local _Time = 0

	C_Timer.NewTicker(0.01, (function()
		if _Time < GetTime() - 1.0 then
			if statusGUIAlert:GetAlpha() == 0 then
				statusGUIAlert:Hide()
				statusText2:SetText(_addonColor..'Version:|cffFFFFFF '..NeP.Addon.Info.Version..' '..NeP.Addon.Info.Branch)
			else 
				statusGUIAlert:SetAlpha(statusGUIAlert:GetAlpha() - .05)
			end
		end
	end), nil)

	function NeP.Alert(txt)
		local _txt = tostring(txt)
		_Time = GetTime()
		statusText2:SetText('')
		statusGUIAlertText:SetText(_addonColor.._txt)
		statusGUIAlert:SetAlpha(1)
		statusGUIAlertText:SetSize(statusGUIAlertText:GetStringWidth(), statusGUIAlertText:GetStringHeight())
		statusGUIAlert:SetSize(statusGUIAlertText:GetStringWidth(), statusGUIAlertText:GetStringHeight())
		statusGUIAlert:Show()
		--PlaySoundFile("Sound\\Interface\\Levelup.Wav")
	end
	
end