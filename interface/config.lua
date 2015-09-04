local ConfigWindow
local NeP_OpenConfigWindow = false
local NeP_ShowingConfigWindow = false

NeP.Interface.General = {
	key = "NePConf",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "General Settings",
	color = NeP.Interface.addonColor,
	width = 250,
	height = 500,
	config = {
			-- [[HEADER]]		
			{ 
				type = "texture",
				texture = NeP.Info.Splash,
				width = 200, 
				height = 100, 
				offset = 90, 
				y = 42, 
				center = true 
			},
				-- [[General]]
				{ type = 'rule' },
				{ 
					type = 'header', 
					text = '|cff'..NeP.Interface.addonColor.."General:", 
					size = 25,
					align = "Center",
				},
					{ type = 'spacer' },
					{
						type = "spinner",
						text = "Interrupt At:",
						key = "ItA",
						width = 150,
						min = 1,
						max = 100,
						default = 40,
						step = 1,
						desc ="Choose the percentage when to Interrupt."
					},
					{ 
						type = "checkbox", 
						text = "Dispell Everything", 
						key = "Dispell", 
						default = true,
						desc = "Enables the use of automated dispelling."
					},
					{
						type = "dropdown",
						text = "Automated Tauting",
						desc = "Enables or disables using smart automatic taunting.",
						key = "Taunts",
						list = {
							{
								text = "All",
								key = "all"
							},
							{
								text = "Elites",
								key = "elite"
							},
							{
								text = "Disabled",
								key = "Disabled"
							},
						},
						default = "elite",
					},
					{ 
						type = "checkbox", 
						text = "Splash", 
						key = "Splash", 
						default = true, 
						desc =  "Enables or disables MrTheSoulz splash."
					},
					{ 
						type = "checkbox", 
						text = "Alerts", 
						key = "Alerts", 
						default = true, 
						desc = "Enables or disables using Alerts when a special event occurs."
					},
					{ 
						type = "checkbox", 
						text = "Chat Prints", 
						key = "Prints", 
						default = true, 
						desc = "Enables or disables using Chat Prints when a special event occurs."
					},
					{ 
						type = "checkbox", 
						text = "Sounds", 
						key = "Sounds", 
						default = true, 
						desc ="Enables or disables using sounds."
					},
				-- [[Advanced]]
				{ type = 'rule' },
				{ 
					type = 'header', 
					text = '|cff'..NeP.Interface.addonColor.."Advanced:", 
					size = 25,
					align = "Center",
				},
					{ type = 'spacer' },
					{ 
						type = "checkbox", 
						text = "Auto Moving", 
						key = "AutoMove", 
						default = false, 
						desc = "Follows your current target if its an enemie.\nChecks for LoS and range."
					},
					{ 
						type = "checkbox", 
						text = "Auto Facing", 
						key = "AutoFace", 
						default = true, 
						desc ="Face your current target.\nChecks for LoS and range."
					},
					{ 
						type = "checkbox", 
						text = "Auto Targets", 
						key = "AutoTarget", 
						default = true, 
						desc = "Enables or disables the use of automatic targets."
					},
				-- [[Extras]]
				{ type = 'rule' },
				{ 
					type = 'header', 
					text = '|cff'..NeP.Interface.addonColor.."Extras:", 
					size = 25,
					align = "Center",
				},
					{ type = 'spacer' },
					{
						type = "checkbox", 
						text = "Auto Accept LFG Queue", 
						key = "AutoLFG", 
						default = false, 
						desc = "Automatic accept LFG proposal."
					},
					{ 
						type = "spinner", 
						text = "Dummy Testing Time:", 
						key = "testDummy",
						width = 100,
						min = 1,
						max = 30,
						default = 5,
						step = 1,
						desc = "Set how long to run dumy testing for in mintes."
					},
	}
}

function NeP.Interface.ConfigGUI()
	NeP.Core.BuildGUI('config', NeP.Interface.General)
end