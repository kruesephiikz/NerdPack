local _Time = 0

local function onUpdate(NeP_Alert,elapsed) 
	if _Time < GetTime() - 1.0 then
		if NeP_Alert:GetAlpha() == 0 and npStart:GetAlpha() == 0 then
			NeP_Alert:Hide()
		else 
			NeP_Alert:SetAlpha(NeP_Alert:GetAlpha() - .05)
		end
	end
end

function NeP.Alert(txt)
	local _addonColor = NeP.Addon.Interface.addonColor
	if NeP.Core.PeFetch('npconf', 'Splash') then
		NeP_Alert.text:SetText(_addonColor..txt)
		NeP_Alert:SetAlpha(1)
		_Time = GetTime()
		NeP_Alert:Show()
		PlaySoundFile("Sound\\Interface\\Levelup.Wav")
	end
end
	
NeP_Alert = CreateFrame("Frame",nil,UIParent)
NeP_Alert:SetWidth(600)
NeP_Alert:SetHeight(30)
NeP_Alert:Hide()
NeP_Alert:SetScript("OnUpdate",onUpdate)
NeP_Alert:SetPoint("TOP",0,0)
NeP_Alert.text = NeP_Alert:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
NeP_Alert.text:SetAllPoints()
NeP_Alert.texture = NeP_Alert:CreateTexture()
NeP_Alert.texture:SetAllPoints()
NeP_Alert.texture:SetTexture(0,0,0,0.7)