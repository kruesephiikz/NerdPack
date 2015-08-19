local GetCursorPosition = GetCursorPosition
local InterfaceOptionsFrame_OpenToCategory = InterfaceOptionsFrame_OpenToCategory
local _addonColor = NeP.Addon.Interface.addonColor
local _addonName = _addonColor..NeP.Addon.Info.Name

NeP.Addon.Interface.MinimapButton = {}

local minimap = NeP.Addon.Interface.MinimapButton

local function reposition()
	minimap.button:SetPoint('TOPLEFT', Minimap, 'TOPLEFT', 52 - (80 * cos(minimap.position)), (80 * sin(minimap.position)) - 52)
end

local function onUpdate()
	local xpos, ypos = GetCursorPosition()
	local xmin, ymin = Minimap:GetLeft(), Minimap:GetBottom()
	xpos = xmin - xpos / UIParent:GetScale() + 70
	ypos = ypos / UIParent:GetScale() - ymin - 70
	minimap.position = math.floor(math.deg(math.atan2(ypos, xpos)))
	reposition()
end

local function onDragStart(self)
	self:LockHighlight()
	self:StartMoving()
	self:SetScript('OnUpdate', onUpdate)
end

local function onDragStop(self)
	self:SetScript('OnUpdate', nil)
	self:StopMovingOrSizing()
	self:UnlockHighlight()
	ProbablyEngine.config.write('NeP_minimap_position', minimap.position)
end


NeP_MinimapButton_Dropdown = function(self)
	local info = {}
	
		info.isTitle = 1
		info.notCheckable = 1
	
	info.text = '|T'..NeP.Addon.Info.Logo..':15:15|t '.._addonName.."\nQuick Menu"
	UIDropDownMenu_AddButton(info)
	
	info.text = ''
	UIDropDownMenu_AddButton(info)
	
	info.text = _addonColor..'Version:|cffFFFFFF '..NeP.Addon.Info.Version
	UIDropDownMenu_AddButton(info)
	
	info.text = _addonColor..'Branch:|cffFFFFFF '..NeP.Addon.Info.Branch
	UIDropDownMenu_AddButton(info)
	
	info.text = ''
	UIDropDownMenu_AddButton(info)
	
	info.text = 'Interface:'
	UIDropDownMenu_AddButton(info)
		
		info.disabled     = nil
		info.isTitle      = nil
	
	info.text = "Information"
	info.func = function() NeP.Addon.Interface.InfoGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "ObjectsManager List"
	info.func = function() NeP.Addon.Interface.OMGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "ObjectsManager Settings"
	info.func = function() NeP.Addon.Interface.CacheGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "General Configuration"
	info.func = function() NeP.Addon.Interface.ConfigGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "Class Configuration"
	info.func = function() NeP.Addon.Interface.ClassGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "Hide Everything"
	info.func = function() NeP.Core.HideAll() end
	UIDropDownMenu_AddButton(info)
	
		info.isTitle = 1
		info.notCheckable = 1
	
	info.text = ''
	UIDropDownMenu_AddButton(info)
	
	info.text = 'Extras:'
	UIDropDownMenu_AddButton(info)
	
		info.disabled     = nil
		info.isTitle      = nil
	
	info.text = "Overlays"
	info.func = function() NeP.Addon.Interface.OverlaysGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "Fishing Bot"
	info.func = function() NeP.Addon.Interface.FishingGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "Items Bot"
	info.func = function() NeP.Addon.Interface.itemsBotGUI() end
	UIDropDownMenu_AddButton(info)
	
	info.text = "Dummy Testing"
	info.func = function() NeP.Extras.dummyTest() end
	UIDropDownMenu_AddButton(info)
		
		info.isTitle = 1
		info.notCheckable = 1
	
	info.text = ''
	UIDropDownMenu_AddButton(info)
	
		info.disabled     = nil
		info.isTitle      = nil
	
	info.text         = 'Close'
	info.func         = function() CloseDropDownMenus() end
	info.checked      = nil
	UIDropDownMenu_AddButton(info)
end

local function onClick(self, button)
	local dropdown = CreateFrame("Frame", "Test_DropDown", self, "UIDropDownMenuTemplate");
	UIDropDownMenu_Initialize(dropdown, NeP_MinimapButton_Dropdown, "MENU");
	ToggleDropDownMenu(1, nil, dropdown, self, 0, 0);
end

local function onEnter(self)
	GameTooltip:SetOwner( self, 'ANCHOR_BOTTOMLEFT')
	GameTooltip:AddLine('|T'..NeP.Addon.Info.Logo..':15:15|t '.._addonName)
	GameTooltip:AddLine(_addonColor..'Version:|cffFFFFFF '..NeP.Addon.Info.Version)
	GameTooltip:AddLine(_addonColor..'Branch:|cffFFFFFF '..NeP.Addon.Info.Branch)
	GameTooltip:AddLine(_addonColor..'Click to Open Quick Menu')
	GameTooltip:Show()
end

local function onLeave(self)
	GameTooltip:Hide()
end

NeP.Addon.Interface.MinimapButton = CreateFrame('Button', 'NeP_Minimap', Minimap)
NeP.Addon.Interface.MinimapButton:SetFrameStrata('MEDIUM')
NeP.Addon.Interface.MinimapButton:SetSize(33, 33)
NeP.Addon.Interface.MinimapButton:RegisterForClicks('anyUp')
NeP.Addon.Interface.MinimapButton:RegisterForDrag('LeftButton', 'RightButton')
NeP.Addon.Interface.MinimapButton:SetMovable(true)
NeP.Addon.Interface.MinimapButton:SetHighlightTexture('Interface\\Minimap\\UI-Minimap-ZoomButton-Highlight')
local overlay = NeP.Addon.Interface.MinimapButton:CreateTexture(nil, 'OVERLAY')
overlay:SetSize(56, 56)
overlay:SetTexture('Interface\\Minimap\\MiniMap-TrackingBorder')
overlay:SetPoint('TOPLEFT')
local icon = NeP.Addon.Interface.MinimapButton:CreateTexture(nil, 'BACKGROUND')
icon:SetSize(21, 21)
icon:SetTexture(NeP.Addon.Info.Logo)
icon:SetPoint('TOPLEFT', 7, -6)
NeP.Addon.Interface.MinimapButton.icon = icon
NeP.Addon.Interface.MinimapButton:SetScript('OnDragStart', onDragStart)
NeP.Addon.Interface.MinimapButton:SetScript('OnDragStop', onDragStop)
NeP.Addon.Interface.MinimapButton:SetScript('OnClick', onClick)
NeP.Addon.Interface.MinimapButton:SetScript('OnEnter', onEnter)
NeP.Addon.Interface.MinimapButton:SetScript('OnLeave', onLeave)
minimap.button = NeP.Addon.Interface.MinimapButton
minimap.position = ProbablyEngine.config.read('NeP_minimap_position', -36)
reposition()