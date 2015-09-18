--[[-----------------------------------------------
	** Main Tables. **
---------------------------------------------------]]
NeP = {
	Core = {
		CurrentCR = false,
		hiding = false,
		--[[
				** PE Warps **
			These are used to have a easly way to update stuff related
			to ProbablyEngine.
		]]
		peRecomemded = "6.1r16",
		PeFetch = ProbablyEngine.interface.fetchKey,
		PeConfig = ProbablyEngine.config,
		PeBuildGUI = ProbablyEngine.interface.buildGUI
	},
	Interface = {
		addonColor = "0070DE",
		printColor = "|cffFFFFFF",
		mediaDir = "Interface\\AddOns\\NerdPack\\media\\"
		classGUIs = {
			--[[ DEPRECATED //  FIXME: 
				keep this untill all CRs have been updated.
				The new way dosent need to mess with this anymore, 
				instead just add [ NeP.Interface.classGUIs[SPECID] = SpecLocalTable ].
			]]
			[250] = NeP.Interface.DkBlood,
			[252] = NeP.Interface.DkUnholy,
			[103] = NeP.Interface.DruidFeral,
			[104] = NeP.Interface.DruidGuard,
			[105] = NeP.Interface.DruidResto,
			[102] = NeP.Interface.DruidBalance,
			[257] = NeP.Interface.PriestHoly,
			[258] = NeP.Interface.PriestShadow,
			[256] = NeP.Interface.PriestDisc,
			[70] = NeP.Interface.PalaRet,
			[66] = NeP.Interface.PalaProt,
			[65] = NeP.Interface.PalaHoly,
			--[73] = NeP.Interface.WarrProt,
			--[72] = NeP.Interface.WarrFury,
			--[71] = NeP.Interface.WarrArms,
			[270] = NeP.Interface.MonkMm,
			[269] = NeP.Interface.MonkWw,
			[262] = NeP.Interface.ShamanEle,
			[264] = NeP.Interface.ShamanResto
		},
	},
	Info = {
		Name = 'NerdPack',
		Nick = 'NeP',
		Version = "6.2.1.1",
		Branch = "Beta5",
		WoW_Version = "6.2.0",
		Logo = "Interface\\AddOns\\NerdPack\\media\\logo.blp",
		Splash = "Interface\\AddOns\\NerdPack\\media\\splash.blp",
		Forum = "http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/532241-pe-nerdpack.html",
		Donate = "http://goo.gl/yrctPO"
	}
}

--[[-----------------------------------------------
	** Locals **
---------------------------------------------------]]
local _addonColor = '|cff'..NeP.Interface.addonColor

--[[-----------------------------------------------
	** Class GUI **
DESC: Decide wich class/spec we're then build ONLY the GUI for
That class.

Build By: MTS
---------------------------------------------------]]
function NeP.Interface.ClassGUI()
	local _Spec = GetSpecializationInfo(GetSpecialization())
	if _Spec ~= nil then
		if NeP.Interface.classGUIs[_Spec] ~= nil then
			NeP.Core.BuildGUI(_Spec, NeP.Interface.classGUIs[_Spec])		
		end
	end
end

--[[-----------------------------------------------
	** NePData **
DESC: Saved variables.

Build By: MTS
---------------------------------------------------]]
NeP.Config = {
	defaults = {
		['CONFIG'] = {
			['test'] = false,
		},
	}
}

local LoadNePData = CreateFrame("Frame")
LoadNePData:RegisterEvent("VARIABLES_LOADED")
LoadNePData:SetScript("OnEvent", function(self, event, addon)
	
	-- IF NePData does not exist, then create it with defaults
	if not NePData or NePData == nil then 
	 	NePData = NeP.Config.defaults; 
	end
	
	-- Functions to handle VARIABLES.
	NeP.Config.resetConfig = function(config)
		NePData[config] = NeP.Config.defaults[config]
	end

	NeP.Config.readKey = function(config, key)
		if NePData[config] ~= nil then
			if NePData[config][key] ~= nil then
				return NePData[config][key]
			else
				NePData[config][key] = NeP.Config.defaults[config][key] 
			end
		else
			NePData[config] = NeP.Config.defaults[config]
		end
	end

	NeP.Config.writeKey = function(config, key, value)
		NePData[config][key] = value
	end

	NeP.Config.toggleKey = function(config, key)
		if NePData[config][key] ~= nil then
			NePData[config][key] = not NePData[config][key]
		else
			NePData[config][key] = NeP.Config.defaults[config][key] 
		end
	end
	
	-- GUI's wich depend on NePData
	StatusGUI_RUN();
	OMGUI_RUN()

end)

--[[-----------------------------------------------
	** Commands **
DESC: Slash commands in-game.

Build By: MTS
---------------------------------------------------]]
ProbablyEngine.command.register(NeP.Info.Nick, function(msg, box)
	local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == 'config' or command == 'c' then
		NeP.Interface.ConfigGUI()
	elseif command == 'class' or command == 'cl' then
		NeP.Interface.ClassGUI()
	elseif command == 'info' or command == 'i' then
		NeP.Interface.InfoGUI()
	elseif command == 'cache' or command == 'cch' or command == 'om' then
		NeP.Interface.CacheGUI()
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		if NeP.Core.hiding then
			NeP.Core.hiding = false
			ProbablyEngine.buttons.buttonFrame:Show()
			NeP_Frame:Show()
			NeP.Core.Print('Now Showing everything again.')
		end
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Interface.OverlaysGUI()
	elseif command == 'test' then
		NeP.Interface.OMGUI()
	else 
		NeP.Core.Print('/config - (Opens General Settings GUI)')
		NeP.Core.Print('/status - (Opens Status GUI)')
		NeP.Core.Print('/class - (Opens Class Settings GUI)')
		NeP.Core.Print('/Info - (Opens Info GUI)')
		NeP.Core.Print('/cache - (Opens OM Settings GUI)')
		NeP.Core.Print('/hide - (Hides Everything)')
		NeP.Core.Print('/show - (Shows Everything)')
		NeP.Core.Print('/overlays - (Opens Overlays Settings GUI)')
	end
end)

--[[-----------------------------------------------
	** Class Color **
DESC: Decide wich class we're then return the
proper class color.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.classColor(unit)
	if UnitIsPlayer(unit) then
		local _classColors = {
			["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, Hex = "abd473" },
			["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, Hex = "9482c9" },
			["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, Hex = "ffffff" },
			["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, Hex = "f58cba" },
			["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, Hex = "69ccf0" },
			["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, Hex = "fff569" },
			["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, Hex = "ff7d0a" },
			["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, Hex = "0070de" },
			["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, Hex = "c79c6e" },
			["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23, Hex = "c41f3b" },
			["MONK"] = { r = 0.0, g = 1.00 , b = 0.59, Hex = "00ff96" },
		}
		local _class, className = UnitClass(unit)
		local _color = _classColors[className]
		return _color.Hex
	else
		return "FFFFFF"
	end
end

--[[-----------------------------------------------
	** GetCrInfo **
DESC: This is used to easly change the name of
every CR at the same time.
Requires manual class/spec insert.
Example: [ NeP.Core.GetCrInfo('Warrior - Arms') ]

Build By: MTS
---------------------------------------------------]]
function NeP.Core.GetCrInfo(txt)
	local _nick = _addonColor..NeP.Info.Nick
	local _classColor = NeP.Core.classColor('Player')
	return '|T'..NeP.Info.Logo..':10:10|t'.. '|r[' .. _nick .. "|r]|r[|cff" .. _classColor .. txt .. "|r]"
end

--[[-----------------------------------------------
	** HideAll **
DESC: Hide everything, you might need this for
livestreams or recording.
While hiding all alerts/notifications, sounds &
prints should not be displayed.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.HideAll()
	if not NeP.Core.hiding then
		NeP.Core.Print("Now hiding everything, to re-enable use the command ( "..NeP.Info.Nick.." show ).")
		ProbablyEngine.buttons.buttonFrame:Hide()
		NeP_Frame:Hide()
		NeP.Core.hiding = true
	else
		NeP.Core.hiding = false
		ProbablyEngine.buttons.buttonFrame:Show()
		NeP_Frame:Show()
		NeP.Core.Print('Now Showing everything again.')
	end
end

--[[-----------------------------------------------
	** Print **
DESC: Print to chat window a message, this adds a
prefix and checks if it should print.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Print(txt)
	if not NeP.Core.hiding and NeP.Core.PeFetch('NePConf', 'Prints') then
		local _name = _addonColor..NeP.Info.Nick
		print("|r[".._name.."|r]: "..NeP.Interface.printColor..txt)
	end
end

--[[-----------------------------------------------
	** Round **
DESC: Round a number.
Example: [ if < 4.5 then return 4, else if >= 4.5 return 5 ].

Build By: MTS
---------------------------------------------------]]
local function NeP.Core.Round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--[[-----------------------------------------------
	** Distance **
DESC: returns the distance betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Distance(a, b)
	if UnitExists(a) and UnitExists(b) then
		-- FireHack
		if FireHack then
			local ax, ay, az = ObjectPosition(b)
			local bx, by, bz = ObjectPosition(a)
			return NeP.Core.Round(math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
		else
			return ProbablyEngine.condition["distance"](b)
		end
	end
	return 0
end

--[[-----------------------------------------------
	** LineOfSight **
DESC: returns the LineOfSight betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.LineOfSight(a, b)
	
	-- Workaround LoS issues.
	local aCheck = select(6,strsplit("-",UnitGUID(a)))
	local bCheck = select(6,strsplit("-",UnitGUID(b)))
	local ignoreLOS = {
		[76585] = true,     -- Ragewing the Untamed (UBRS)
		[77063] = true,     -- Ragewing the Untamed (UBRS)
		[77182] = true,     -- Oregorger (BRF)
		[77891] = true,     -- Grasping Earth (BRF)
		[77893] = true,     -- Grasping Earth (BRF)
		[78981] = true,     -- Iron Gunnery Sergeant (BRF)
		[81318] = true,     -- Iron Gunnery Sergeant (BRF)
		[83745] = true,     -- Ragewing Whelp (UBRS)
		[86252] = true,     -- Ragewing the Untamed (UBRS)
	}
	if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
	if ignoreLOS[tonumber(bCheck)] ~= nil then return true end
	
	if FireHack then
		if UnitExists(a) and UnitExists(b) then
			local ax, ay, az = ObjectPosition(a)
			local bx, by, bz = ObjectPosition(b)
			local losFlags =  bit.bor(0x10, 0x100)
			return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
		end
	end
	
	return false
end

--[[-----------------------------------------------
	** Infront **
DESC: returns if a unit is infront of other or not.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Infront(a, b)
	if (UnitExists(a) and UnitExists(b)) then
		-- FireHack
		if FireHack then
			local aX, aY, aZ = ObjectPosition(b)
			local bX, bY, bZ = ObjectPosition(a)
			local playerFacing = GetPlayerFacing()
			local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
			return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
		-- Fallback to PE's
		else
			return ProbablyEngine.condition["infront"](b)
		end
	end
end