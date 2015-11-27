NeP.Core.BuildGUI('Settings', {
	key = "NePConf",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "General Settings",
	color = NeP.Interface.addonColor,
	width = 250,
	height = 500,
	config = {
		-- [[HEADER]]		
		{ type = "texture",texture = NeP.Info.Splash, width = 200, height = 100, offset = 90, y = 42, center = true },
		-- [[GUIs]]
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."GUIs:", size = 25, align = "Center" },
			-- NeP Frame
			{ type = "checkbox", text = "Enable NeP Frame", key = "NePFrame", default = true, desc = "|cfffd1c15[Warning]|r Disabling this may mean you no longer have acess to some or all GUIs." }, 
			-- NeP Frame Move
			{ type = "checkbox",  text = "Enable Moving NeP Frame", key = "NePFrameMove", default = true },
			-- NeP Frame Size
			{ type = "spinner", text = "NeP Frame Size:", key = "NePFrameSize", width = 150, min = 10, max = 100, default = 20, step = 1 },
			-- NeP Frame Color
			{ type = "dropdown", text = "NeP Frame Color", key = "NePFrameColor", list = {
				{ text = "Black", key = "black" },
				{ text = "White", key = "white" },
				{ text = "Blue", key = "blue" },
				{ text = "Green", key = "green" },
				{ text = "Red", key = "red" },
				{ text = "Class Color", key = "class" },
			}, default = "black" },
			-- Reload BT
			{ type = 'spacer' },
			{ type = "button", text = "Apply", width = 225, height = 20, callback = function() ReloadUI(); end },
		-- [[General]]
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."General:", size = 25, align = "Center" },
			{ type = "spinner", text = "Interrupt At:", key = "ItA", width = 150, min = 1,max = 100, default = 40, step = 1, desc ="Choose the percentage when to Interrupt." },
			{ type = "checkbox", text = "Dispell Everything", key = "Dispell", default = true, desc = "Enables the use of automated dispelling." },
			{ type = "dropdown", text = "Automated Tauting", desc = "Enables or disables using smart automatic taunting.", key = "Taunts", list = {
				{ text = "All", key = "all" },
				{ text = "Elites", key = "elite" },
				{ text = "Disabled", key = "Disabled" },
			}, default = "elite" },
			{ type = "checkbox", text = "Splash", key = "Splash", default = true, desc =  "Enables or disables MrTheSoulz splash." },
			{ type = "checkbox", text = "Alerts", key = "Alerts", default = true, desc = "Enables or disables using Alerts when a special event occurs." },
			{ type = "checkbox", text = "Chat Prints", key = "Prints", default = true, desc = "Enables or disables using Chat Prints when a special event occurs." },
			{ type = "checkbox", text = "Sounds", key = "Sounds", default = true, desc ="Enables or disables using sounds." },
		-- [[Advanced]]
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Advanced:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Auto Moving", key = "AutoMove", default = false, desc = "Follows your current target if its an enemie.\nChecks for LoS and range." },
			{ type = "checkbox", text = "Auto Facing", key = "AutoFace", default = true, desc ="Face your current target.\nChecks for LoS and range." },
			{ type = "checkbox", text = "Auto Targets", key = "AutoTarget", default = true, desc = "Enables or disables the use of automatic targets." },
		-- [[Extras]]
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Extras:", size = 25, align = "Center" },
			{ type = 'spacer' },
			{ type = "checkbox", text = "Auto Accept Ressurect", key = "AutoARess", default = false, desc = "Auto accept Ressurect request." },
			{ type = "checkbox", text = "Auto Accept LFG Queue", key = "AutoLFG", default = false, desc = "Auto accept LFG proposal." },
			{ type = "checkbox", text = "Auto Accept Role Check", key = "AutoRole", default = false, desc = "Auto accept Role Check." },
			{ type = "dropdown", text = "Role", key = "RoleSet", list = {
				{ text = "DPS", key = "DPS" },
				{ text = "TANK", key = "TANK" },
				{ text = "HEALER", key = "HEALER" },
			}, default = "DPS" },
			{ type = "spinner", text = "Dummy Testing Time:", key = "testDummy", width = 100, min = 1, max = 30, default = 5, step = 1, desc = "Set how long to run dumy testing for in mintes."},
	}
})