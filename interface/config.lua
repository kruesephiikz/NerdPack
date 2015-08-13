local ConfigWindow
local NeP_OpenConfigWindow = false
local NeP_ShowingConfigWindow = false

NeP.Addon.Interface.General = {
	key = "npconf",
	profiles = true,
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name,
	subtitle = "General Settings",
	color = NeP.Addon.Interface.GuiColor,
	width = 250,
	height = 500,
	config = {
			-- [[HEADER]]		
			{ 
				type = "texture",
				texture = NeP.Addon.Info.Splash,
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
					text = NeP.Addon.Interface.GuiTextColor.."General:", 
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
						type = "checkbox", 
						text = "Automated Taunting", 
						key = "Taunts", 
						default = false, 
						desc = "Enables or disables using smart automatic taunts."
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
					text = NeP.Addon.Interface.GuiTextColor.."Advanced:", 
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
					text = NeP.Addon.Interface.GuiTextColor.."Extras:", 
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
					{  
						type = "checkbox",  
						text = "Auto Open Salvage",  
						key = "OpenSalvage",  
						default = false,  
						desc = "Automatic salvage bags/crates opening." 
					},
				-- [[Fishing]] (new section)
				{ type = 'rule' },
				{ 
					type = 'header', 
					text = NeP.Addon.Interface.GuiTextColor.."Fishing:", 
					size = 25,
					align = "Center",
				},
					{
						type = "checkbox", 
						text = "Use Worm Supreme", 
						key = "WormSupreme", 
						default = true, 
						desc = "Enable automatic usage of Worm Supreme."
					},
					{  
					        type = "checkbox",  
					        text = "Use Sharpened Fish Hook",  
					        key = "SharpenedFishHook",  
					        default = false,  
					        desc = "Enable automatic usage of Sharpened Fish Hook." 
					},
					{  
						type = "checkbox",  
						text = "Destroy Lunarfall Carp",  
						key = "LunarfallCarp",  
						default = false,  
						desc = "Enable automatic destruction of Lunarfall Carp." 
					},			    
					{ 
						type = "dropdown",
						text = "Bait:", 
						key = "bait", 
						list = {
								{
									text = "None",
									key = "none"
								},	
								{
									text = "Jawless Skulker",
									key = "jsb"
								},
								{
									text = "Fat Sleeper",
									key = "fsb"
								},
								{
									text = "Blind Lake Sturgeon",
									key = "blsb"
								},
								{
									text = "Fire Ammonite",
									key = "fab"
								},
								{
									text = "Sea Scorpion",
									key = "ssb"
								},
								{
									text = "Abyssal Gulper Eel",
									key = "ageb"
								},
								{
									text = "Blackwater Whiptail",
									key = "bwb"
								},
							}, 
						default = "none" 
					},
	}
}

function NeP.Addon.Interface.ConfigGUI()
	-- If a frame has not been created, create one...
	if not NeP_OpenConfigWindow then
		ConfigWindow = NeP.Core.PeBuildGUI(NeP.Addon.Interface.General)
		-- This is so the window isn't opened twice :D
		NeP_OpenConfigWindow = true
		NeP_ShowingConfigWindow = true
		ConfigWindow.parent:SetEventListener('OnClose', function()
			NeP_OpenConfigWindow = false
			NeP_ShowingConfigWindow = false
		end)
	
	-- If a frame has been created and its showing, hide it.
	elseif NeP_OpenConfigWindow == true and NeP_ShowingConfigWindow == true then
		ConfigWindow.parent:Hide()
		NeP_ShowingConfigWindow = false
	
	-- If a frame has been created and its hiding, show it.
	elseif NeP_OpenConfigWindow == true and NeP_ShowingConfigWindow == false then
		ConfigWindow.parent:Show()
		NeP_ShowingConfigWindow = true
	
	end
end
