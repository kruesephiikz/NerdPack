local _addonColor = '|cff'..NeP.Interface.addonColor

NeP.Core.BuildGUI('Info', {
	key = "npinfo",
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "Information",
	color = NeP.Interface.addonColor,
	width = 350,
	height = 400,
	config = {
		{ type = "texture", texture = NeP.Info.Splash, width = 400, height = 200, offset = 205, y = 94, center = true },
		{ type = 'rule' },
		{ type = 'header', text =  _addonColor..NeP.Info.Nick.. " Information:", align = "center"},
		{ type = 'spacer' },
			{ type = 'text', text = "NeP is a evolution of MTSP, ive created this project using PEs engine & custom libs. NePs goal is to be light but with advanced features.", size = 13},
			{ type = 'text', text = "If you have any issues while using it and the Status say they are okay, please visit: ".._addonColor..NeP.Info.Forum.."|r for futher help.", size = 13},
			{ type = 'text', text = "Created By: "..NeP.Info.Author, align = "right", size = 10 },
		
		-- General Status
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = _addonColor.." General Status:", align = "center" },
		{ type = 'spacer' },

			{ type = "text", text = "Unlocker Status: ", size = 11, offset = -11 },
			{ key = 'current_Unlocker', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },
			{ type = "text", text = "PE Version Status: ", size = 11, offset = -11 },
			{ key = 'current_PEStatus', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },
			{ type = "text", text = "Using "..NeP.Info.Nick.." Profiles: ", size = 11, offset = -11 },
			{ key = 'current_PackProfiles', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },
			{ type = 'spacer' },
			{ type = "button", text = "Test Unlocker (If you jump, it works)", width = 325, height = 20,callback = function()
				JumpOrAscendStart();
			end },
		
		-- Advanced Status
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = _addonColor.."Advanced Features Status:", align = "center"},
		{ type = 'spacer' },

			{ type = "text", text = "Automated Movement: ", size = 11, offset = -11 },
			{ key = 'current_movementStatus', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },
			{ type = "text", text = "Automated Facing: ", size = 11, offset = -11 },
			{ key = 'current_facingStatus', type = "text", text = "Loading...", size = 11, align = "right", offset = 0 },
			{ type = 'spacer' },{ type = 'spacer' },{ type = 'rule' },
			{ type = "button", text = "Donate", width = 325, height = 20, callback = function()
				if FireHack then
					OpenURL(NeP.Info.Donate);
				else
					message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Donate);
				end
			end },
			{ type = "button", text = "Forums", width = 325, height = 20, callback = function()
				if FireHack then
					OpenURL(NeP.Info.Forum);
				else
					message("|cff00FF96Please Visit:|cffFFFFFF\n"..NeP.Info.Forum);
				end
			end },
			{ type = "button", text = "Close", width = 325, height = 20,callback = function()
				NeP.Interface.InfoGUI()
			end },
	}
})

local peRecomemded = NeP.Core.peRecomemded
local PE_Ver = ProbablyEngine.version
local _infoCreated = false
local InfoWindow = NeP.Core.getGUI('Info')

C_Timer.NewTicker(1.00, (function()
	local pmethod = ProbablyEngine.pmethod or ProbablyEngine.protected.method
	local CurrentCR = NeP.Core.CurrentCR
	if InfoWindow.parent:IsShown() then
		-- General Status
		InfoWindow.elements.current_Unlocker:SetText(pmethod == nil and "|cffC41F3BYou're not Unlocked, please use an unlocker." or "|cff00FF96You're Unlocked, Using: ".. pmethod)
		InfoWindow.elements.current_PEStatus:SetText(PE_Ver == peRecomemded and "|cff00FF96You're using the recommeded PE version." or "|cffC41F3BYou're not using the recommeded PE version.")
		InfoWindow.elements.current_PackProfiles:SetText(CurrentCR and "|cff00FF96Currently using MTS Profiles" or "|cffC41F3BNot using MTS Profiles")
		-- Advanced Status
		InfoWindow.elements.current_movementStatus:SetText((FireHack or WOWSX_ISLOADED) and NeP.Core.PeFetch('NePConf', 'AutoMove') and "|cff00FF96Able" or "|cffC41F3BUnable")
		InfoWindow.elements.current_facingStatus:SetText((FireHack or oexecute or WOWSX_ISLOADED) and NeP.Core.PeFetch('NePConf', 'AutoFace') and "|cff00FF96Able" or "|cffC41F3BUnable")
	end
end), nil)