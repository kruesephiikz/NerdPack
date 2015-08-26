local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

NeP.Interface.addText = function(parent)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	return text
end

-- Work Around outdated PE's
local statusBarStylesheet = {
	['frame-texture'] = {
		type		= 'texture',
		layer		= 'BORDER',
		gradient	= 'VERTICAL',							
		color		= '000000',			
		alpha 		= 0.7,
		alphaEnd	= 0.1,
		offset		= 0,
	}
}


DiesalGUI:RegisterObjectConstructor("NePStatusBar", function()
	local self  = DiesalGUI:CreateObjectBase(Type)
	local frame = CreateFrame('StatusBar',nil,UIParent)
	self.frame  = frame

	self:AddStyleSheet(statusBarStylesheet)

	frame.Left = frame:CreateFontString()
	frame.Left:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
	frame.Left:SetShadowColor(0,0,0, 0)
	frame.Left:SetShadowOffset(-1,-1)
	frame.Left:SetPoint("LEFT", frame)

	frame.Right = frame:CreateFontString()
	frame.Right:SetFont(SharedMedia:Fetch('font', 'Calibri Bold'), 10)
	frame.Right:SetShadowColor(0,0,0, 0)
	frame.Right:SetShadowOffset(-1,-1)
		
	frame:SetStatusBarTexture(1,1,1,0.8)
	frame:GetStatusBarTexture():SetHorizTile(false)
	frame:SetMinMaxValues(0, 100)
	frame:SetHeight(15)
		
	self.SetValue = function(self, value)
		self.frame:SetValue(value)
	end
	self.SetParent = function(self, parent)
	self.parent = parent
	self.frame:SetParent(parent)
	self.frame:SetPoint("LEFT", parent, "LEFT")
	self.frame:SetPoint("RIGHT", parent, "RIGHT")
	self.frame.Right:SetPoint("RIGHT", self.frame, "RIGHT", -2, 2)
	self.frame.Left:SetPoint("LEFT", self.frame, "LEFT", 2, 2)
	end
	self.OnRelease = function(self)
		self:Hide()
	end
	self.OnAcquire = function(self)	
		self:Show()		
	end
	self.type = "Rule"
	return self
end, 1)

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