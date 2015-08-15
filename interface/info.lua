local InfoWindow
local NeP_OpenInfoWindow = false
local NeP_ShowingInfoWindow = false
local NeP_InfoUpdating = false

NeP.Addon.Interface.info = {
	key = "npinfo",
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name,
	subtitle = "Information",
	color = NeP.Addon.Interface.GuiColor,
	width = 350,
	height = 400,
	config = {
		{ type = "texture",texture = NeP.Addon.Info.Splash,
			width = 400, 
			height = 200, 
			offset = 190, 
			y = 94, 
			center = true 
		},
			{ 
				type = "button", 
				text = "Donate", 
				width = 325, 
				height = 20,
				callback = function()
					if FireHack then
						OpenURL("http://goo.gl/yrctPO");
					else
						message("|cff00FF96Please Visit:|cffFFFFFF\nhttp://goo.gl/yrctPO");
					end
				end
			},
			{ 
				type = "button", 
				text = "Forums", 
				width = 325, 
				height = 20,
				callback = function()
					if FireHack then
						OpenURL("http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/498642-pe-mrthesoulzpack.html");
					else
						message("|cff00FF96Please Visit:|cffFFFFFF\nhttp://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/498642-pe-mrthesoulzpack.html");
					end
				end
			},

		-- General Status
		{ type = 'spacer' },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = "|cff9482C9MrTheSoulz General Status:", 
			align = "center"
		},
		{ type = 'spacer' },

			{ 
				type = "text", 
				text = "Unlocker Status: ", 
				size = 11, 
				offset = -11 
			},
			{ 
				key = 'current_Unlocker', 
				type = "text", 
				text = "Loading...", 
				size = 11, 
				align = "right", 
				offset = 0 
			},
			{ 
				type = "text", 
				text = "PE Version Status: ", 
				size = 11, 
				offset = -11 
			},
			{ 
				key = 'current_PEStatus', 
				type = "text", 
				text = "Loading...", 
				size = 11, 
				align = "right", 
				offset = 0 
			},
			{ 
				type = "text", 
				text = "Using MTS Profiles: ", 
				size = 11, 
				offset = -11 
			},
			{ 
				key = 'current_MTSProfiles', 
				type = "text", 
				text = "Loading...", 
				size = 11, 
				align = "right", 
				offset = 0 
			},
			{ 
				type = "button", 
				text = "Test Unlocker (If you jump, it works)", 
				width = 325, 
				height = 20,
				callback = function()
					JumpOrAscendStart();
				end
			},
		
		-- Advanced Status
		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = "|cff9482C9MrTheSoulz Advanced Status:", align = "center"},
		{ type = 'spacer' },

			{ type = "text", text = "Automated Movement: ", size = 11, offset = -11 },
			{ key = 'current_movementStatus', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },

			{ type = "text", text = "Automated Facing: ", size = 11, offset = -11 },
			{ key = 'current_facingStatus', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },

		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = "|cff9482C9MrTheSoulz Pack Information:", align = "center"},
		{ type = 'spacer' },

			{ type = 'text', text = "This pack been created for personal use and shared to help others with the same needs." },
			{ type = 'text', text = "If you have any issues while using it and the Status say they are okay, please visit: |cffC41F3Bhttp://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/498642-pe-mrthesoulzpack.html|r for futher help."},
			{ type = 'text', text = "Created By: MrTheSoulz" },

			{ type = 'spacer' },
			{ 
				type = "button", 
				text = "Close", 
				width = 325, 
				height = 20,
				callback = function()
					NeP.Addon.Interface.InfoGUI()
				end
			},
	}
}

-- Update Text for Info GUI
local function NeP_updateLiveInfo()
	-- General Status
	InfoWindow.elements.current_Unlocker:SetText(ProbablyEngine.pmethod == nil and ProbablyEngine.protected.method == nil and "|cffC41F3BYou're not Unlocked, please use an unlocker." or "|cff00FF96You're Unlocked, Using: ".. (ProbablyEngine.pmethod or ProbablyEngine.protected.method))
	InfoWindow.elements.current_PEStatus:SetText(ProbablyEngine.version == NeP.Core.peRecomemded and "|cff00FF96You're using the recommeded PE version." or "|cffC41F3BYou're not using the recommeded PE version.")
	InfoWindow.elements.current_MTSProfiles:SetText(NeP.Core.CurrentCR and "|cff00FF96Currently using MTS Profiles" or "|cffC41F3BNot using MTS Profiles")
	-- Advanced Status
	InfoWindow.elements.current_movementStatus:SetText((FireHack or WOWSX_ISLOADED) and NeP.Core.PeFetch('npconf', 'AutoMove') and "|cff00FF96Able" or "|cffC41F3BUnable")
	InfoWindow.elements.current_facingStatus:SetText((FireHack or oexecute or WOWSX_ISLOADED) and NeP.Core.PeFetch('npconf', 'AutoFace') and "|cff00FF96Able" or "|cffC41F3BUnable")
end

function NeP.Addon.Interface.InfoGUI()
	if not NeP_OpenInfoWindow then
		InfoWindow = NeP.Core.PeBuildGUI(NeP.Addon.Interface.info)
		NeP_InfoUpdating = true
		NeP_OpenInfoWindow = true
		NeP_ShowingInfoWindow = true
		InfoWindow.parent:SetEventListener('OnClose', function()
			NeP_OpenInfoWindow = false
			NeP_ShowingInfoWindow = false
			NeP_InfoUpdating = false
		end)
	elseif NeP_OpenInfoWindow == true 
	and NeP_ShowingInfoWindow == true then
		NeP_ShowingInfoWindow = false
		NeP_InfoUpdating = false
		InfoWindow.parent:Hide()
	elseif NeP_OpenInfoWindow == true 
	and NeP_ShowingInfoWindow == false then
		NeP_ShowingInfoWindow = true
		NeP_InfoUpdating = true
		InfoWindow.parent:Show()
	end
	
	if NeP_InfoUpdating then
		C_Timer.NewTicker(1.00, NeP_updateLiveInfo, nil)
	end
end