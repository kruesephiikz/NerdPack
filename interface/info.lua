NeP.Interface.info = {
	key = "npinfo",
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "Information",
	color = NeP.Interface.addonColor,
	width = 350,
	height = 400,
	config = {
		{ type = "texture",texture = NeP.Info.Splash,
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
						OpenURL(NeP.Info.Donate);
					else
						message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Donate);
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
						OpenURL(NeP.Info.Forum);
					else
						message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Forum);
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
				key = 'current_PackProfiles', 
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
					NeP.Interface.InfoGUI()
				end
			},
	}
}

local _infoCreated = false
function NeP.Interface.InfoGUI()
	NeP.Core.BuildGUI('Info', NeP.Interface.info)
	local InfoWindow = NeP.Core.getGUI('Info')
		if not _infoCreated then
			_infoCreated = true
			C_Timer.NewTicker(1.00, (function()
				if InfoWindow.parent:IsShown() then
				-- General Status
				InfoWindow.elements.current_Unlocker:SetText(ProbablyEngine.pmethod == nil and ProbablyEngine.protected.method == nil and "|cffC41F3BYou're not Unlocked, please use an unlocker." or "|cff00FF96You're Unlocked, Using: ".. (ProbablyEngine.pmethod or ProbablyEngine.protected.method))
				InfoWindow.elements.current_PEStatus:SetText(ProbablyEngine.version == NeP.Core.peRecomemded and "|cff00FF96You're using the recommeded PE version." or "|cffC41F3BYou're not using the recommeded PE version.")
				InfoWindow.elements.current_PackProfiles:SetText(NeP.Core.CurrentCR and "|cff00FF96Currently using MTS Profiles" or "|cffC41F3BNot using MTS Profiles")
				-- Advanced Status
				InfoWindow.elements.current_movementStatus:SetText((FireHack or WOWSX_ISLOADED) and NeP.Core.PeFetch('NePConf', 'AutoMove') and "|cff00FF96Able" or "|cffC41F3BUnable")
				InfoWindow.elements.current_facingStatus:SetText((FireHack or oexecute or WOWSX_ISLOADED) and NeP.Core.PeFetch('NePConf', 'AutoFace') and "|cff00FF96Able" or "|cffC41F3BUnable")
			end
		end), nil)
	end
end