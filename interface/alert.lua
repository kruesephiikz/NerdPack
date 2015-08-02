npAlert = CreateFrame("Frame",nil,UIParent)
npAlert:SetWidth(400)
npAlert:SetHeight(30)
npAlert:Hide()
npAlert:SetScript("OnUpdate",onUpdate)
npAlert:SetPoint("TOP",0,0)
npAlert.text = npAlert:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
npAlert.text:SetAllPoints()
npAlert.time = 0
npAlert.texture = npAlert:CreateTexture()
npAlert.texture:SetAllPoints()
npAlert.texture:SetTexture(0,0,0,0.7)

local function onUpdate(self,elapsed) 
	if self.time < GetTime() - 2.0 then
		if self:GetAlpha() == 0 then
			self:Hide()
		else 
			self:SetAlpha(self:GetAlpha() - .05)
		end
	end
end

function npAlert:message(message)
	if not NeP.Core.hidding then
		self.text:SetText(NeP.Addon.Interface.GuiTextColor..message)
		self:SetAlpha(1)
		self.time = GetTime() 
		self:Show()
	end
end