

NeP.Addon.Interface.ShamanResto = {
	key = "npconfShamanResto",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Shaman-Resto Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {	
		{ 
			type = 'header', 
			text = NeP.Addon.Interface.GuiTextColor.."General Settings:", 
			align = "center"
		},
			{ 
				type = "dropdown",
				text = "Earth Shield on ...", 
				key = "ESo", 
				list = {
				   {
					  text = "Tank",
					  key = "1"
					},
					{
					  text = "Focus",
					  key = "2"
					},
					{
					  text = "Manual",
					  key = "3"
					}
				}, 
				default = "1", 
				desc = "Select target to cast Earth Shield on." 
			},	
		{ type = "Spacer" },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = NeP.Addon.Interface.GuiTextColor.."Items Settings:", 
			align = "center"
		},
			{ 
				type = "spinner", 
				text = "Healthstone", 
				key = "Healthstone", 
				default = 50 
			},
			{ 
				type = "spinner", 
				text = "Trinket 1", 
				key = "Trinket1", 
				default = 85, 
				desc = "Use Trinket when player mana is equal to..." 
			}, 
			{ 
				type = "spinner", 
				text = "Trinket 2", 
				key = "Trinket2",
				default = 85, 
				desc = "Use Trinket when player mana is equal to..." 
			},
		{ type = "Spacer" },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = NeP.Addon.Interface.GuiTextColor.."Tank/Focus Settings:", 
			align = "center"
		},
			{ 
				type = "checkbox", 
				text = "EathShield", 
				key = "EarthShieldTank", 
				default = true, 
			},
			{ 
				type = "checkbox", 
				text = "Riptide", 
				key = "RiptideTank", 
				default = true, 
			},
			{ 
				type = "spinner", 
				text = "Healing Surge #Health",
				key = "HealingSurgeTank",
				min = 5,
				max = 100,
				default = 45,
				step = 5,
			},
			{ 
				type = "spinner", 
				text = "Healing Wave #Health",
				key = "HealingWaveTank",
				min = 5,
				max = 100,
				default = 75,
				step = 5,
			},
		{ type = "Spacer" },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = NeP.Addon.Interface.GuiTextColor.."Player Settings:", 
			align = "center"
		},
			{ 
				type = "spinner", 
				text = "Astral Shift", 
				key = "AstralShift", 
				default = 50
			},
			{ 
				type = "spinner", 
				text = "Ancestral Swiftness", 
				key = "AncestralSwiftnessPlayer", 
				default = 35
			},
			{ 
				type = "spinner", 
				text = "Ancestral Swiftness", 
				key = "HealingSurgePlayer", 
				default = 35
			},
			{ 
				type = "spinner", 
				text = "Riptide", 
				key = "RiptidePlayer", 
				default = 95
			},
			{ 
				type = "spinner", 
				text = "Healing Wave", 
				key = "HealingWavePlayer", 
				default = 65
			},
		{ type = "Spacer" },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = NeP.Addon.Interface.GuiTextColor.."Raid Settings:", 
			align = "center"
		},
			{ 
				type = "spinner", 
				text = "Healing Wave", 
				key = "HealingWaveRaid", 
				default = 90
			},
			{ 
				type = "spinner", 
				text = "Riptide", 
				key = "RiptideRaid", 
				default = 95
			},
			{ 
				type = "spinner", 
				text = "Unleash Life", 
				key = "UnleashLifeRaid", 
				default = 25
			},
			{ 
				type = "spinner", 
				text = "Ancestral Swiftness", 
				key = "AncestralSwiftnessRaid", 
				default = 35
			},
			{ 
				type = "spinner", 
				text = "Healing Surge", 
				key = "HealingSurgeRaid", 
				default = 35
			},
	}
}