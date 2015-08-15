local Texts = { }
local TextsUsed = { }
local _objectTable = NeP.ObjectManager.unitFriendlyCache
local _Displaying = 'Friendly List'

local OPTIONS_WIDTH = 510
local OPTIONS_HEIGHT = 210

--parent NeP.Addon.Interface.OMGUI 
NeP.Addon.Interface.OMGUI = CreateFrame("Frame", "ObjectManager", UIParent) 
NeP.Addon.Interface.OMGUI.Open = false
NeP.Addon.Interface.OMGUI:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
NeP.Addon.Interface.OMGUI:SetPoint("CENTER") 
NeP.Addon.Interface.OMGUI.texture = NeP.Addon.Interface.OMGUI:CreateTexture() 
NeP.Addon.Interface.OMGUI.texture:SetAllPoints() 
NeP.Addon.Interface.OMGUI.texture:SetTexture(0,0,0,0.7)

local title = CreateFrame("Frame", nil, NeP.Addon.Interface.OMGUI)
title:SetPoint("TOP", NeP.Addon.Interface.OMGUI)
title:SetWidth(OPTIONS_WIDTH)
title:SetHeight(30)
title.texture = title:CreateTexture() 
title.texture:SetAllPoints()
title.texture:SetTexture(0,0,0,1)
title.text1 = title:CreateFontString(nil, "OVERLAY")
title.text1:SetFont("Fonts\\FRIZQT__.TTF", 15)
title.text1:SetPoint("LEFT")
title.text1:SetText('NEP ObjectManager GUI')
title.text2 = title:CreateFontString(nil, "OVERLAY")
title.text2:SetFont("Fonts\\FRIZQT__.TTF", 15)
title.text2:SetPoint("RIGHT", -10, 0)
title.text2:SetText('')
title.text3 = title:CreateFontString(nil, "OVERLAY")
title.text3:SetFont("Fonts\\FRIZQT__.TTF", 15)
title.text3:SetPoint("RIGHT", -100, 0)
title.text3:SetText('')
 
 -- Close Button
local closeButton = CreateFrame("Button", nil, NeP.Addon.Interface.OMGUI)
closeButton:SetPoint("BOTTOMLEFT", 0, 0)
closeButton:SetWidth(100)
closeButton:SetHeight(25)
closeButton:SetText("Close")
closeButton:SetNormalFontObject("GameFontNormal")
closeButton:SetScript("OnClick", function(self) NeP.Addon.Interface.OMGUI:Hide() end)
closeButton.closeButton1 = closeButton:CreateTexture()
closeButton.closeButton1:SetTexture(0,0,0,1)
closeButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
closeButton.closeButton1:SetAllPoints() 
closeButton.closeButton2 = closeButton:CreateTexture()
closeButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
closeButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
closeButton.closeButton2:SetAllPoints()
closeButton.closeButton3 = closeButton:CreateTexture()
closeButton.closeButton3:SetTexture(0,0,0,1)
closeButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
closeButton.closeButton3:SetAllPoints()
closeButton:SetNormalTexture(closeButton.closeButton1)
closeButton:SetHighlightTexture(closeButton.closeButton2)
closeButton:SetPushedTexture(closeButton.closeButton3)

-- Enemy Button
local enemyButton = CreateFrame("Button", nil, NeP.Addon.Interface.OMGUI)
enemyButton:SetPoint("BOTTOMRIGHT", 0, 0)
enemyButton:SetWidth(100)
enemyButton:SetHeight(25)
enemyButton:SetText("Enemy List")
enemyButton:SetNormalFontObject("GameFontNormal")
enemyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitCache; _Displaying = 'Enemy List' end)
enemyButton.closeButton1 = enemyButton:CreateTexture()
enemyButton.closeButton1:SetTexture(0,0,0,1)
enemyButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
enemyButton.closeButton1:SetAllPoints() 
enemyButton.closeButton2 = enemyButton:CreateTexture()
enemyButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
enemyButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
enemyButton.closeButton2:SetAllPoints()
enemyButton.closeButton3 = enemyButton:CreateTexture()
enemyButton.closeButton3:SetTexture(0,0,0,1)
enemyButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
enemyButton.closeButton3:SetAllPoints()
enemyButton:SetNormalTexture(enemyButton.closeButton1)
enemyButton:SetHighlightTexture(enemyButton.closeButton2)
enemyButton:SetPushedTexture(enemyButton.closeButton3)

-- Friendly Button
local friendlyButton = CreateFrame("Button", nil, NeP.Addon.Interface.OMGUI)
friendlyButton:SetPoint("BOTTOMRIGHT", -110, 0)
friendlyButton:SetWidth(100)
friendlyButton:SetHeight(25)
friendlyButton:SetText("Friendly List")
friendlyButton:SetNormalFontObject("GameFontNormal")
friendlyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitFriendlyCache; _Displaying = 'Friendly List' end)
friendlyButton.closeButton1 = friendlyButton:CreateTexture()
friendlyButton.closeButton1:SetTexture(0,0,0,1)
friendlyButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
friendlyButton.closeButton1:SetAllPoints() 
friendlyButton.closeButton2 = friendlyButton:CreateTexture()
friendlyButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
friendlyButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
friendlyButton.closeButton2:SetAllPoints()
friendlyButton.closeButton3 = friendlyButton:CreateTexture()
friendlyButton.closeButton3:SetTexture(0,0,0,1)
friendlyButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
friendlyButton.closeButton3:SetAllPoints()
friendlyButton:SetNormalTexture(friendlyButton.closeButton1)
friendlyButton:SetHighlightTexture(friendlyButton.closeButton2)
friendlyButton:SetPushedTexture(friendlyButton.closeButton3)

-- Object Button
local ObjectButton = CreateFrame("Button", nil, NeP.Addon.Interface.OMGUI)
ObjectButton:SetPoint("BOTTOMRIGHT", -220, 0)
ObjectButton:SetWidth(100)
ObjectButton:SetHeight(25)
ObjectButton:SetText("Objects List")
ObjectButton:SetNormalFontObject("GameFontNormal")
ObjectButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.objectsCache; _Displaying = 'Objects List' end)
ObjectButton.closeButton1 = ObjectButton:CreateTexture()
ObjectButton.closeButton1:SetTexture(0,0,0,1)
ObjectButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
ObjectButton.closeButton1:SetAllPoints() 
ObjectButton.closeButton2 = ObjectButton:CreateTexture()
ObjectButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
ObjectButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
ObjectButton.closeButton2:SetAllPoints()
ObjectButton.closeButton3 = ObjectButton:CreateTexture()
ObjectButton.closeButton3:SetTexture(0,0,0,1)
ObjectButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
ObjectButton.closeButton3:SetAllPoints()
ObjectButton:SetNormalTexture(ObjectButton.closeButton1)
ObjectButton:SetHighlightTexture(ObjectButton.closeButton2)
ObjectButton:SetPushedTexture(ObjectButton.closeButton3)

local contentFrame = CreateFrame("Frame", nil, NeP.Addon.Interface.OMGUI) 
contentFrame:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT - 60)  
contentFrame:SetPoint("TOP", 0, -30) 
 
--scrollframe 
local scrollframe = CreateFrame("ScrollFrame", nil, contentFrame) 
scrollframe:SetPoint("TOPLEFT", 0, 0) 
scrollframe:SetPoint("BOTTOMRIGHT", 0, 0) 
local texture = scrollframe:CreateTexture() 
texture:SetAllPoints() 
texture:SetTexture(0,0,0,0.3)
NeP.Addon.Interface.OMGUI.scrollframe = scrollframe 
 
--scrollbar 
local scrollbar = CreateFrame("Slider", nil, scrollframe, "UIPanelScrollBarTemplate") 
scrollbar:SetPoint("TOPLEFT", NeP.Addon.Interface.OMGUI, "TOPRIGHT", 0, -16) 
scrollbar:SetPoint("BOTTOMLEFT", NeP.Addon.Interface.OMGUI, "BOTTOMRIGHT", 0, 16) 
scrollbar:SetMinMaxValues(1, 200) 
scrollbar:SetValueStep(1) 
scrollbar.scrollStep = 1
scrollbar:SetValue(0) 
scrollbar:SetWidth(16) 
scrollbar:SetScript("OnValueChanged", 
function (self, value) 
	self:GetParent():SetVerticalScroll(value) 
end) 
local scrollbg = scrollbar:CreateTexture(nil, "BACKGROUND") 
scrollbg:SetAllPoints(scrollbar) 
scrollbg:SetTexture(0, 0, 0, 0.4) 
NeP.Addon.Interface.OMGUI.scrollbar = scrollbar 
 
--content NeP.Addon.Interface.OMGUI 
local content = CreateFrame("Frame", nil, scrollframe) 
content:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT+500) 
content.texture = texture

local function getText()
    scrollframe.text = tremove(Texts)
    if not scrollframe.text then
        scrollframe.text = scrollframe.content:CreateFontString(nil, "OVERLAY", scrollframe.content)
		scrollframe.text:SetFont("Fonts\\FRIZQT__.TTF", 11)
        scrollframe.text:SetParent(scrollframe.content)
    end
    scrollframe.text:Show()
    table.insert(TextsUsed, scrollframe.text)
    return scrollframe.text
end

local function recycleTexts()
    for i = #TextsUsed, 1, -1 do
        TextsUsed[i]:Hide()
        tinsert(Texts, tremove(TextsUsed))
    end
end

C_Timer.NewTicker(1, (function()

		recycleTexts()
		
		local currentRow = 0
		title.text2:SetText('|cffff0000Total: '..#_objectTable)
		title.text3:SetText('|cffCCCCCC('.._Displaying..')')

		if #_objectTable > 0 then
			for i=1,#_objectTable do
				--if currentRow >= 11 then break end
				local _object = _objectTable[i]
				local guid = UnitGUID(_object.key)
				local _, _, _, _, _, _id, _ = strsplit("-", guid)
				local Text = getText()
				local name = _object.name
				local objectID = (tonumber(_id) or 'UNKNOWN')
				local distance = _object.distance
				scrollframe.text:SetPoint("TOPLEFT", 0, 0+ (currentRow * -15) + -currentRow)
				scrollframe.text:SetText('|cffff0000Name: |r'..name..'|cffCCCCCC( Distance: '..distance..' ID: '..objectID..' )')
				currentRow = currentRow + 1
			end
		end

end), nil)

scrollframe.content = content 
scrollframe:SetScrollChild(content)
NeP.Addon.Interface.OMGUI:Hide()