local Texts = { }
local TextsUsed = { }
local _objectTable = NeP.ObjectManager.unitFriendlyCache
local _Displaying = 'Friendly List'

local OPTIONS_WIDTH = 510
local OPTIONS_HEIGHT = 210
local scrollMax = 0

local _CacheShow = false

function NeP.Addon.Interface.OMGUI()
	_CacheShow = not _CacheShow
	if _CacheShow then
		mainFrame:Show()
	else
		mainFrame:Hide()
	end
end

--parent mainFrame 
mainFrame = CreateFrame("Frame", "ObjectManager", UIParent) 
mainFrame:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
mainFrame:SetPoint("CENTER") 
mainFrame.texture = mainFrame:CreateTexture() 
mainFrame.texture:SetAllPoints() 
mainFrame.texture:SetTexture(0,0,0,0.7)
mainFrame:SetMovable(true)
mainFrame:RegisterForDrag("LeftButton")
mainFrame:EnableMouse(true)
mainFrame:SetScript("OnDragStart", mainFrame.StartMoving)
mainFrame:SetScript("OnDragStop", mainFrame.StopMovingOrSizing)


local title = CreateFrame("Frame", nil, mainFrame)
title:SetPoint("TOP", mainFrame)
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
local closeButton = CreateFrame("Button", nil, mainFrame)
closeButton:SetPoint("BOTTOMLEFT", 0, 0)
closeButton:SetWidth(100)
closeButton:SetHeight(25)
closeButton:SetText("|cff000000Close")
closeButton:SetNormalFontObject("GameFontNormal")
closeButton:SetScript("OnClick", function(self) mainFrame:Hide() end)
closeButton.closeButton1 = closeButton:CreateTexture()
closeButton.closeButton1:SetTexture(255, 0 ,0 , 1)
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
local enemyButton = CreateFrame("Button", nil, mainFrame)
enemyButton:SetPoint("BOTTOMRIGHT", 0, 0)
enemyButton:SetWidth(100)
enemyButton:SetHeight(25)
enemyButton:SetText("|cffFFFFFFEnemy List")
enemyButton:SetNormalFontObject("GameFontNormal")
enemyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitCache; _Displaying = 'Enemy List' end)
enemyButton.closeButton1 = enemyButton:CreateTexture()
enemyButton.closeButton1:SetTexture(0, 0, 51, 1)
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
local friendlyButton = CreateFrame("Button", nil, mainFrame)
friendlyButton:SetPoint("BOTTOMRIGHT", -100, 0)
friendlyButton:SetWidth(100)
friendlyButton:SetHeight(25)
friendlyButton:SetText("|cffFFFFFFFriendly List")
friendlyButton:SetNormalFontObject("GameFontNormal")
friendlyButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.unitFriendlyCache; _Displaying = 'Friendly List' end)
friendlyButton.closeButton1 = friendlyButton:CreateTexture()
friendlyButton.closeButton1:SetTexture(0, 0, 51, 1)
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
local ObjectButton = CreateFrame("Button", nil, mainFrame)
ObjectButton:SetPoint("BOTTOMRIGHT", -200, 0)
ObjectButton:SetWidth(100)
ObjectButton:SetHeight(25)
ObjectButton:SetText("|cffFFFFFFObjects List")
ObjectButton:SetNormalFontObject("GameFontNormal")
ObjectButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.objectsCache; _Displaying = 'Objects List' end)
ObjectButton.closeButton1 = ObjectButton:CreateTexture()
ObjectButton.closeButton1:SetTexture(0, 0, 51, 1)
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

-- All Button
local AllButton = CreateFrame("Button", nil, mainFrame)
AllButton:SetPoint("BOTTOMRIGHT", -300, 0)
AllButton:SetWidth(50)
AllButton:SetHeight(25)
AllButton:SetText("|cff000000All")
AllButton:SetNormalFontObject("GameFontNormal")
AllButton:SetScript("OnClick", function(self) _objectTable = NeP.ObjectManager.objectsCache; _Displaying = 'All' end)
AllButton.closeButton1 = AllButton:CreateTexture()
AllButton.closeButton1:SetTexture(0, 255, 0, 1)
AllButton.closeButton1:SetTexCoord(0, 0.625, 0, 0.6875)
AllButton.closeButton1:SetAllPoints() 
AllButton.closeButton2 = AllButton:CreateTexture()
AllButton.closeButton2:SetTexture(0.5,0.5,0.5,1)
AllButton.closeButton2:SetTexCoord(0, 0.625, 0, 0.6875)
AllButton.closeButton2:SetAllPoints()
AllButton.closeButton3 = AllButton:CreateTexture()
AllButton.closeButton3:SetTexture(0,0,0,1)
AllButton.closeButton3:SetTexCoord(0, 0.625, 0, 0.6875)
AllButton.closeButton3:SetAllPoints()
AllButton:SetNormalTexture(AllButton.closeButton1)
AllButton:SetHighlightTexture(AllButton.closeButton2)
AllButton:SetPushedTexture(AllButton.closeButton3)

local scrollframe = CreateFrame("ScrollFrame", nil, mainFrame) 
scrollframe:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT - 60)  
scrollframe:SetPoint("TOP", 0, -30) 
 
--contentFrame 
local contentFrame = CreateFrame("Frame") 
contentFrame:SetPoint("TOPLEFT", 0, 0) 
contentFrame:SetPoint("BOTTOMRIGHT", 0, 0) 
contentFrame:SetSize(OPTIONS_WIDTH, 0)
local texture = contentFrame:CreateTexture() 
texture:SetAllPoints() 
texture:SetTexture(0,0,0,0.3)
mainFrame.contentFrame = contentFrame 
 
-- Create the slider that will be used to scroll through the results
local scrollbar = CreateFrame("Slider", "FPreviewScrollBar", mainFrame)
if not scrollbar.bg then
   scrollbar.bg = scrollbar:CreateTexture(nil, "BACKGROUND")
   scrollbar.bg:SetAllPoints(true)
   scrollbar.bg:SetTexture(0, 0, 0, 0.5)
end
if not scrollbar.thumb then
   scrollbar.thumb = scrollbar:CreateTexture(nil, "OVERLAY")
   scrollbar.thumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob")
   scrollbar.thumb:SetSize(25, 25)
   scrollbar:SetThumbTexture(scrollbar.thumb)
end
--local scrollMax = 10
scrollbar:SetOrientation("VERTICAL");
scrollbar:SetSize(16, OPTIONS_HEIGHT)
scrollbar:SetPoint("TOPLEFT", mainFrame, "TOPRIGHT", 0, 0)
scrollbar:SetMinMaxValues(0, scrollMax)
scrollbar:SetValue(0)
scrollbar:SetScript("OnValueChanged", function(self)
      scrollframe:SetVerticalScroll(self:GetValue())
end)

scrollframe:SetScrollChild(contentFrame)

local function getText()
    contentFrame.text = tremove(Texts)
    if not contentFrame.text then
        contentFrame.text = contentFrame:CreateFontString(nil, "OVERLAY", contentFrame)
		contentFrame.text:SetFont("Fonts\\FRIZQT__.TTF", 11)
        contentFrame.text:SetParent(contentFrame)
		contentFrame.texture = contentFrame:CreateTexture() 
    end
    contentFrame.text:Show()
    table.insert(TextsUsed, contentFrame.text)
    return contentFrame.text
end

local function recycleTexts()
    for i = #TextsUsed, 1, -1 do
        TextsUsed[i]:Hide()
        tinsert(Texts, tremove(TextsUsed))
    end
end

C_Timer.NewTicker(0.1, (function()
	if NeP.Core.CurrentCR and _CacheShow then
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			recycleTexts()
			
			local height = 0
			local currentRow = 0
			title.text3:SetText('|cffCCCCCC('.._Displaying..')')

			if _Displaying == 'All' then
				if FireHack then
					local totalObjects = ObjectCount()
					title.text2:SetText('|cffff0000Total: '..totalObjects)
					for i=1, totalObjects do
						local Obj = ObjectWithIndex(i)
						if ObjectExists(Obj) then
							-- Objects OM
							--if ObjectIsType(Obj, ObjectTypes.GameObject) then
								local Text = getText()
								local distance = NeP.Core.Distance('player', Obj)
								local name = (UnitName(Obj) or 'UNKNOWN')
								local guid = UnitGUID(Obj)
								local _, _, _, _, _, _id, _ = strsplit("-", guid)
								local objectID = (tonumber(_id) or 'UNKNOWN')
								contentFrame.text:SetPoint("TOPLEFT", 0, 0+ (currentRow * -15) + -currentRow)
								contentFrame.text:SetText(name..' |cffCCCCCC( Distance: '..distance..' ID: '..objectID..' )')
								currentRow = currentRow + 1
								height = height + contentFrame.text:GetStringHeight() + 5
							--end
						end
					end
				end
			else
				title.text2:SetText('|cffff0000Total: '..#_objectTable)
					if #_objectTable > 0 then
						for i=1,#_objectTable do
						--if currentRow >= 11 then break end
						local Text = getText()
						local _object = _objectTable[i]
						local guid = UnitGUID(_object.key)
						local _, _, _, _, _, _id, _ = strsplit("-", guid)
						local name = (_object.name or 'UNKNOWN')
						local health = (_object.health or 'UNKNOWN')
						local objectID = (tonumber(_id) or 'UNKNOWN')
						local distance = (_object.distance or 'UNKNOWN')
						contentFrame.text:SetPoint("TOPLEFT", 0, 0+ (currentRow * -15) + -currentRow)
						contentFrame.text:SetText(name..' |cffCCCCCC( Distance: '..distance..' ID: '..objectID..' Health: '..health..'% )')
						--contentFrame.text:SetScript("OnMouseDown", function(self) TargetUnit(_object.key) end)
						height = height + contentFrame.text:GetStringHeight() + 5
						currentRow = currentRow + 1
					end
				end
			end
			
			if height > OPTIONS_HEIGHT then
				scrollMax = height - (OPTIONS_HEIGHT-70)
			else
				scrollMax = 0
			end
			contentFrame:SetSize(OPTIONS_WIDTH, height)
			scrollbar:SetMinMaxValues(0, scrollMax)
		end
	end
end), nil)

contentFrame:EnableMouseWheel(true)
contentFrame:SetScript("OnMouseWheel", function(self, delta)
      local current = scrollbar:GetValue()
       
      if IsShiftKeyDown() and (delta > 0) then
         scrollbar:SetValue(0)
      elseif IsShiftKeyDown() and (delta < 0) then
         scrollbar:SetValue(scrollMax)
      elseif (delta < 0) and (current < scrollMax) then
         scrollbar:SetValue(current + 20)
      elseif (delta > 0) and (current > 1) then
         scrollbar:SetValue(current - 20)
      end
end)

mainFrame:Hide()