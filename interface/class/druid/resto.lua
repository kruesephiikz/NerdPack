NeP.Addon.Interface.DruidResto = {
	key = "npconfDruidResto",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Druid Restoration Settings",
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

		-- Focus
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = 'Focus settings:', 
			align = "center"
		},

			{ 
				type = "spinner", 
				text = "Life Bloom", 
				key = "LifeBloomTank", 
				default = 100
			},
			{ 
				type = "spinner", 
				text = "Swiftmend", 
				key = "SwiftmendTank", 
				default = 80
			},
			{ 
				
				type = "spinner", 
				text = "Rejuvenation", 
				key = "RejuvenationTank", 
				default = 95
			},
			{ 
				type = "spinner", 
				text = "Wild Mushroom", 
				key = "WildMushroomTank", 
				default = 100
			},
			{ 
				type = "spinner", 
				text = "Healing Touch", 
				key = "HealingTouchTank", 
				default = 96
			},

	}
}