

NeP.Addon.Interface.WarrProt = {
	key = "npconfigWarrProt",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Warrior Protection Settings",
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
				text = "Healthstone - HP",
				key = "Healthstone",
				width = 50,
				min = 0,
				max = 100,
				default = 75,
				step = 5
			},
			{
				type = "spinner",
				text = "Rallying Cry - HP",
				key = "RallyingCry",
				width = 50,
				min = 0,
				max = 100,
				default = 10,
				step = 5
			},
			{
				type = "spinner",
				text = "Last Stand - HP",
				key = "LastStand",
				width = 50,
				min = 0,
				max = 100,
				default = 20,
				step = 5
			},
			{
				type = "spinner",
				text = "Shield Wall - HP",
				key = "ShieldWall",
				width = 50,
				min = 0,
				max = 100,
				default = 30,
				step = 5
			},
			{
				type = "spinner",
				text = "Shield Barrier - Rage",
				key = "ShieldBarrier",
				width = 50,
				min = 0,
				max = 100,
				default = 80,
				step = 5
			},

	}
}