local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0") 
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

-- Get RGB colors
local _RBGColors = {
	['black'] = { r = 0.00, g = 0.00, b = 0.00 },
	['white'] = { r = 1.00, g = 1.00, b = 1.00 },
	['green'] = { r = 0.33, g = 0.54, b = 0.52 },
	['blue'] = { r = 0.00, g = 0.44, b = 0.87 },
	['red'] = { r = 0.77, g = 0.12, b = 0.23 },
	['class'] = { r = select(1, NeP.Core.classColor('player', 'RBG')), g = select(2, NeP.Core.classColor('player', 'RBG')), b = select(3, NeP.Core.classColor('player', 'RBG')) },
}
local function _getRGB(color)
	if color == nil then color = 'black' end
	return _RBGColors[color].r, _RBGColors[color].g, _RBGColors[color].b
end

local bC_R, bC_G, bC_B = _getRGB(NeP.Core.PeFetch('NePConf', 'NePFrameColor'))
local textColor = function() 
	if NeP.Core.PeFetch('NePConf', 'NePFrameColor') ~= "black" then
		return _getRGB('black')
	else
		return _getRGB('white')
	end
end

local _openPEGUIs = {}
NeP.Core.BuildGUI = function(gui, _table)
	local gui = tostring(gui)
	if _openPEGUIs[gui] ~= nil then
		if _openPEGUIs[gui].parent:IsShown() then
			_openPEGUIs[gui].parent:Hide()
		else
			_openPEGUIs[gui].parent:Show()
		end
	else
		_openPEGUIs[gui] = ProbablyEngine.interface.buildGUI(_table)
	end
end

NeP.Core.getGUI = function(gui)
	return _openPEGUIs[gui]
end

NeP.Interface.addText = function(parent)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	text:SetTextColor(textColor())
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
	Button.Button1:SetTexture(bC_R, bC_G, bC_B, 0.50)
	Button.Button1:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button1:SetAllPoints() 
	Button.Button2 = Button:CreateTexture()
	Button.Button2:SetTexture(1.0, 1.0, 1.0, 0.75)
	Button.Button2:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button2:SetAllPoints()
	Button.Button3 = Button:CreateTexture()
	Button.Button3:SetTexture(bC_R, bC_G, bC_B, 1)
	Button.Button3:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button3:SetAllPoints()
	Button:SetNormalTexture(Button.Button1)
	Button:SetHighlightTexture(Button.Button2)
	Button:SetPushedTexture(Button.Button3)
	Button.text = Button:CreateFontString(nil, "OVERLAY")
	Button.text:SetTextColor(textColor())
	Button.text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	Button.text:SetPoint("CENTER", 0, 0)
	return Button
end

NeP.Interface.addScrollFrame = function(parent)
	local scrollframe = CreateFrame("ScrollFrame", nil, parent) 
	scrollframe.texture = scrollframe:CreateTexture() 
	scrollframe.texture:SetAllPoints() 
	scrollframe.texture:SetTexture(bC_R, bC_G, bC_B, 0.3)
	scrollframe.scrollbar = CreateFrame("Slider", "FPreviewScrollBar", scrollframe)
	scrollframe.scrollbar.bg = scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollframe.scrollbar.bg:SetAllPoints(true)
	scrollframe.scrollbar.bg:SetTexture(bC_R, bC_G, bC_B, 0.50)
	scrollframe.scrollbar.thumb = scrollframe.scrollbar:CreateTexture(nil, "OVERLAY")
	scrollframe.scrollbar.thumb:SetTexture(1.0, 1.0, 1.0, 1.0)
	scrollframe.scrollbar.thumb:SetSize(16, 16)
	scrollframe.scrollbar.text = scrollframe.scrollbar:CreateFontString(nil, "OVERLAY")
	scrollframe.scrollbar.text:SetTextColor(textColor())
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
	Frame.texture:SetTexture(bC_R, bC_G, bC_B, 0.7)
	return Frame
end

NeP.Interface.addCheckButton = function(parent)
	local createCheckBox = CreateFrame("CheckButton", "UICheckButtonTemplateTest", parent, "UICheckButtonTemplate")
	createCheckBox:ClearAllPoints();
	createCheckBox:SetSize(15, 15)
	createCheckBox.text = parent:CreateFontString(nil, "OVERLAY")
	createCheckBox.text:SetTextColor(textColor())
	
	return createCheckBox
end