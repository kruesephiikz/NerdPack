

NeP.Addon.Interface.MonkMm = {
	key = "npconfigMonkMm",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Monk Mistweaver Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ 
			type = 'header',
			text = "General settings:", 
			align = "center" 
		},

			-- NOTHING IN HERE YET...

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},
			
			-- Survival Settings:
			{
				type = "spinner",
				text = "Soothing Mist",
				key = "SM",
				width = 50,
				min = 0,
				max = 100,
				default = 100,
				step = 5
			},
			
	}
}