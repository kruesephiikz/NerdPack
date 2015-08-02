local NeP_OverlaysGUI
local NeP_OverlaysGUI_Open = false
local NeP_OverlaysGUI_Showing = false

NeP.Addon.Interface.Overlays = {
	key = "npconf_Overlays",
	profiles = true,
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name,
	subtitle = "Overlays Settings",
	color = NeP.Addon.Interface.GuiColor,
	width = 250,
	height = 500,
	config = {
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Overlays:", size = 25, align = "Center" },
			{ type = "text", text = "Only Works with FireHack ATM!", size = 11, offset = 0, align = "center" },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Player Overlays:", size = 25, align = "Center" },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Display Player Melee Range", key = "PlayerMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "PlayerCRange", default = false },
			{ type = "checkbox", text = "Display Target Line", key = "TargetLine", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "PlayerInfrontCone", default = false },
		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Target Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Player Melee Range", key = "TargetMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "TargetCRange", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "TargetCone", default = false },
		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Objects Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Herb Objects", key = "objectsHerbs", default = false },
			{ type = "checkbox", text = "Display Ore Objects", key = "objectsOres", default = false },
			{ type = "checkbox", text = "Display Lumbermill Objects", key = "objectsLM", default = false }
	}
}

function NeP.Addon.Interface.OverlaysGUI()
	-- If a frame has not been created, create one...
	if not NeP_OverlaysGUI_Open then
		NeP_OverlaysGUI = NeP.Core.PeBuildGUI(NeP.Addon.Interface.Overlays)
		
		-- This is so the window isn't opened twice :D
		NeP_OverlaysGUI_Open = true
		NeP_OverlaysGUI_Showing = true
		NeP_OverlaysGUI.parent:SetEventListener('OnClose', function()
			NeP_OverlaysGUI_Open = false
			NeP_OverlaysGUI_Showing = false
			end)

	-- If a frame has been created and its showing, hide it.
	elseif NeP_OverlaysGUI_Open == true and NeP_OverlaysGUI_Showing == true then
		NeP_OverlaysGUI.parent:Hide()
		NeP_OverlaysGUI_Showing = false

	-- If a frame has been created and its hiding, show it.
	elseif NeP_OverlaysGUI_Open == true and NeP_OverlaysGUI_Showing == false then
		NeP_OverlaysGUI.parent:Show()
		NeP_OverlaysGUI_Showing = true
	end
	
end
