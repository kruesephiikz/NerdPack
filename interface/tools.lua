NeP.Interface.addText = function(parent)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	return text
end

NeP.Interface.addButton = function(parent)
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

NeP.Interface.addScrollFrame = function(parent)
	local scrollframe = CreateFrame("ScrollFrame", nil, parent) 
	scrollframe.texture = scrollframe:CreateTexture() 
	scrollframe.texture:SetAllPoints() 
	scrollframe.texture:SetTexture(255,255,255,0.3)
	scrollframe.scrollbar = CreateFrame("Slider", "FPreviewScrollBar", scrollframe)
	scrollframe.scrollbar.bg = scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollframe.scrollbar.bg:SetAllPoints(true)
	scrollframe.scrollbar.bg:SetTexture(255, 255, 255, 0.1)
	scrollframe.scrollbar.thumb = scrollframe.scrollbar:CreateTexture(nil, "OVERLAY")
	scrollframe.scrollbar.thumb:SetTexture(255, 255, 255, 0.7)
	scrollframe.scrollbar.thumb:SetSize(16, 16)
	scrollframe.scrollbar.text = scrollframe.scrollbar:CreateFontString(nil, "OVERLAY")
	scrollframe.scrollbar.text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	scrollframe.scrollbar.text:SetSize(16, 16)
	scrollframe.scrollbar.text:SetText('|cff000000=')
	scrollframe.scrollbar.text:SetPoint('CENTER', scrollframe.scrollbar.thumb)
	scrollframe.scrollbar:SetThumbTexture(scrollframe.scrollbar.thumb)
	scrollframe.scrollbar:SetOrientation("VERTICAL");
	scrollframe.scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 0, 0)
	scrollframe.scrollbar:SetMinMaxValues(0, 0)
	scrollframe.scrollbar:SetValue(0)
	scrollframe.scrollbar:SetScript("OnValueChanged", function(self)
		  scrollframe:SetVerticalScroll(self:GetValue())
	end)
	return scrollframe
end

NeP.Interface.addFrame = function(parent)
	local Frame = CreateFrame("Frame", nil, parent)
	Frame.texture = Frame:CreateTexture() 
	Frame.texture:SetAllPoints() 
	Frame.texture:SetTexture(0,0,0,0.7)
	return Frame
end

NeP.Interface.addCheckButton = function(parent)
	local createCheckBox = CreateFrame("CheckButton", "UICheckButtonTemplateTest", parent, "UICheckButtonTemplate")
	createCheckBox:ClearAllPoints();
	createCheckBox:SetSize(15, 15)
	createCheckBox.text = parent:CreateFontString(nil, "OVERLAY")
	
	return createCheckBox
end