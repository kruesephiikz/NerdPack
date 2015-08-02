local NeP_StatusGUI
local NeP_StatusGUI_Open = false
local NeP_StatusGUI_Showing = false
local NeP_StatusGUI_Updating = false

local NeP_live = {
	key = "nplive",
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name,
	color = NeP.Addon.Interface.GuiColor,
	width = 200,
	height = 100,
	resize = false,
	config = {

		{ type = "text", text = "Unlocked: ", size = 13, offset = -13 },
		{ key = 'current_Unlocker', type = "text", text = "Loading...", size = 13, align = "right", offset = 0 },
		
		-- Current Spell
		{ type = "text", text = "Last: ", size = 13, offset = -13 },
		{ key = 'current_spell', type = "text", text = NeP.Addon.Interface.GuiTextColor.."Loading...", size = 13, align = "right", offset = 0 },
		
		-- AoE
		{ type = "text", text = "AoE: ", size = 13, offset = -13 },
		{ key = 'current_AoE', type = "text", text = NeP.Addon.Interface.GuiTextColor.."Loading...", size = 13, align = "right", offset = 0 },

		-- Interrupts
		{ type = "text", text = "Interrupts: ", size = 13, offset = -13 },
		{ key = 'current_Interrupts', type = "text", text = NeP.Addon.Interface.GuiTextColor.."Loading...", size = 13, align = "right", offset = 0 },

		-- Cooldowns
		{ type = "text", text = "Cooldowns: ", size = 13, offset = -13 },
		{ key = 'current_Cooldowns', type = "text", text = NeP.Addon.Interface.GuiTextColor.."Loading...", size = 13, align = "right", offset = 0},
	}
}

-- Update Text for Status GUI
local function NeP_updateLiveGUI()
	NeP_StatusGUI.elements.current_spell:SetText(ProbablyEngine.parser.lastCast == "" and NeP.Addon.Interface.GuiTextColor.."..." or NeP.Addon.Interface.GuiTextColor..ProbablyEngine.parser.lastCast)
	NeP_StatusGUI.elements.current_Unlocker:SetText(ProbablyEngine.pmethod == nil and ProbablyEngine.protected.method == nil and "|cffC41F3BYou're not Unlocked." or "|cff00FF96Yes, using: (".. (ProbablyEngine.pmethod or ProbablyEngine.protected.method)..')')
	NeP_StatusGUI.elements.current_AoE:SetText(ProbablyEngine.config.read('button_states', 'multitarget', false) == true and "\124cff0070DEON" or "\124cffC41F3BOFF")
	NeP_StatusGUI.elements.current_Interrupts:SetText(ProbablyEngine.config.read('button_states', 'interrupt', false) == true and "\124cff0070DEON" or "\124cffC41F3BOFF")
	NeP_StatusGUI.elements.current_Cooldowns:SetText(ProbablyEngine.config.read('button_states', 'cooldowns', false) == true and "\124cff0070DEON" or "\124cffC41F3BOFF")
end

function NeP.ShowStatus()
	if not NeP_StatusGUI_Open and NeP.Core.PeFetch('npconf','LiveGUI') then
		NeP_StatusGUI = ProbablyEngine.interface.buildGUI(NeP_live)
		NeP_StatusGUI_Updating = true
		NeP_StatusGUI_Open = true
		NeP_StatusGUI_Showing = true
		NeP_StatusGUI.parent:SetEventListener('OnClose', function()
			NeP_StatusGUI_Open = false
			NeP_StatusGUI_Updating = false
			NeP_StatusGUI_Showing = false
		end)
	
	elseif NeP_StatusGUI_Open and NeP_StatusGUI_Showing then
		NeP_StatusGUI_Showing = false
		NeP_StatusGUI_Updating = false
		NeP_StatusGUI.parent:Hide()
	
	elseif NeP_StatusGUI_Open == true and NeP_StatusGUI_Showing == false then
		NeP_StatusGUI_Showing = true
		NeP_StatusGUI_Updating = true
		NeP_StatusGUI.parent:Show()
	end
end

C_Timer.NewTicker(1.0, (function()
	if NeP_StatusGUI_Updating then
		NeP_updateLiveGUI()
	end
end), nil)