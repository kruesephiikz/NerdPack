local L = ProbablyEngine.locale.get
local DiesalTools = LibStub("DiesalTools-1.0")
local DiesalStyle = LibStub("DiesalStyle-1.0")
local DiesalGUI = LibStub("DiesalGUI-1.0")
local DiesalMenu = LibStub("DiesalMenu-1.0")
local SharedMedia = LibStub("LibSharedMedia-3.0")

local _addonColor = NeP.Addon.Interface.GuiColor
local _tittleGUI = NeP.Addon.Info.Icon..'|cff'.._addonColor..NeP.Addon.Info.Nick..'|r '

local _CacheGUI = { }
local _CacheGUI = DiesalGUI:Create('Window')
_CacheGUI:SetWidth(400)
_CacheGUI:SetHeight(200)
_CacheGUI:Hide()
_CacheGUI:SetTitle(_tittleGUI..'ObjectManager List')

local _CacheScroll = DiesalGUI:Create('ScrollFrame')
_CacheGUI:AddChild(_CacheScroll)
_CacheScroll:SetParent(_CacheGUI.content)
_CacheScroll:SetAllPoints(_CacheGUI.content)
_CacheScroll.parent = _CacheGUI
_CacheGUI:ApplySettings()

local _CacheShow = false

function NeP.friendlyCache()
    _CacheShow = not _CacheShow
    if _CacheShow then
        _CacheGUI:Show()
    else
        _CacheGUI:Hide()
    end
end

local statusBars = { }
local statusBarsUsed = { }

local function getStatusBar()
    local statusBar = tremove(statusBars)
    if not statusBar then
        statusBar = DiesalGUI:Create('StatusBar')
        _CacheScroll:AddChild(statusBar)
        statusBar:SetParent(_CacheScroll.content)
        statusBar.frame:SetStatusBarColor(DiesalTools:GetColor('f42727'))
    end
    statusBar:Show()
    table.insert(statusBarsUsed, statusBar)
    return statusBar
end

local function recycleStatusBars()
    for i = #statusBarsUsed, 1, -1 do
        statusBarsUsed[i]:Hide()
        tinsert(statusBars, tremove(statusBarsUsed))
    end
end

local _objectTable = NeP.ObjectManager.unitFriendlyCache

C_Timer.NewTicker(1, (function()
	
	if _CacheShow then
		recycleStatusBars()

		local currentRow = 0

		_CacheGUI:SetTitle(_tittleGUI..' ObjectManager: Friendly Units List                                  |cffff0000TOTAL: '..#_objectTable)

		if #_objectTable > 0 then
			for i=1,#_objectTable do
				--if currentRow >= 11 then break end
				local _object = _objectTable[i]
				local guid = UnitGUID(_object.key)
				local _, _, _, _, _, _id, _ = strsplit("-", guid)
				local statusBar = getStatusBar()
				local name = _object.name
				local objectID = 'ID: '..(tonumber(_id) or 'UNKNOWN')
				local distance = 'Distance: '.._object.distance

				statusBar.frame:SetPoint("TOPRIGHT", _CacheScroll.frame, "TOPRIGHT", -10, -1 + (currentRow * -15) + -currentRow )
				statusBar.frame:SetPoint("TOPLEFT", _CacheScroll.frame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
				statusBar.frame.Left:SetText(string.sub(name, 1, 30) .. "|cffCCCCCC - ".. distance.. " - " .. objectID)
				statusBar:SetValue(_object.health)
				statusBar.frame.Right:SetText(_object.health .. '%')
				statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(_object.key) end)
				currentRow = currentRow + 1
			end
		end

	end
end), nil)