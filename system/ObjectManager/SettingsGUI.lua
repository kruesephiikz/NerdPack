local _addonColor = NeP.Addon.Interface.GuiColor
local _tittleGUI = NeP.Addon.Info.Icon..NeP.Addon.Info.Nick

local NeP_cacheWindow
local NeP_OpenCacheWindow = false
local NeP_ShowingCacheWindow = false
local NeP_cacheWindowUpdating = false

local NeP_ObjectCache = {
    key = "ObjectCache",
    title = _tittleGUI,
    subtitle = "ObjectManager Settings",
    color = _addonColor,
    width = 210,
    height = 350,
    config = {
    	{ type = 'header', text = _addonColor.."Cache Options:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Use ObjectCache", key = "ObjectCache", default = true },
			{ type = "checkbox", text = "Use Advanced Object Manager", key = "AC", default = true },
			{ type = "checkbox", text = "Cache Friendly Units", key = "FU", default = true },
			{ type = "checkbox", text = "Cache Enemies Units", key = "EU", default = true },
			{ type = "checkbox", text = "Cache Dummys Units", key = "dummys", default = true },
			{ type = "spinner", text = "Cache Distance:", key = "CD", width = 90, min = 10, max = 200, default = 100, step = 5},
			{ type = "button", text = "Enemie Units List", width = 190, height = 20, callback = function() NeP.enemieCache() end },
			{ type = "button", text = "Friendly Units List", width = 190, height = 20, callback = function() NeP.friendlyCache() end },
			{ type = "button", text = "Objects List", width = 190, height = 20, callback = function() NeP.objectCache() end },
    }
}

function NeP.Addon.Interface.CacheGUI()
    if not NeP_OpenCacheWindow then
        NeP_cacheWindow = ProbablyEngine.interface.buildGUI(NeP_ObjectCache)
		NeP_cacheWindow.parent:SetEventListener('OnClose', function()
            NeP_OpenCacheWindow = false
            NeP_ShowingCacheWindow = false
        end)
		NeP_cacheWindowUpdating = true
		NeP_ShowingCacheWindow = true
		NeP_OpenCacheWindow = true
	elseif NeP_OpenCacheWindow and NeP_ShowingCacheWindow then
        NeP_cacheWindowUpdating = false
		NeP_ShowingCacheWindow = false
        NeP_cacheWindow.parent:Hide()
    elseif NeP_OpenCacheWindow and not NeP_ShowingCacheWindow then
        NeP_cacheWindowUpdating = true
		NeP_ShowingCacheWindow = true
        NeP_cacheWindow.parent:Show()
        
    end
end