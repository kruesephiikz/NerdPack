NeP = {
	Core = {
		peRecomemded = "6.1r16",
		CurrentCR = false,
		hidding = false,
		printColor = "|cffFFFFFF",
		PeFetch = ProbablyEngine.interface.fetchKey,
		PeConfig = ProbablyEngine.config,
		PeBuildGUI = ProbablyEngine.interface.buildGUI
	},
	Addon = {
		Info = {
			Name = 'NerdPack',
			Nick = 'NeP',
			Version = "6.2.1.1",
			Branch = "Beta",
			WoW_Version = "6.2.0",
			Icon = "|TInterface\\AddOns\\NerdPack\\media\\logo.blp:10:10|t",
			Logo = "Interface\\AddOns\\NerdPack\\media\\logo.blp",
			Splash = "Interface\\AddOns\\NerdPack\\media\\splash.blp"
		},
		Interface = {
			GuiColor = "0070DE",
			GuiTextColor = "|cff0070DE",
			addonColor = "|cff0070DE",
			mediaDir = "Interface\\AddOns\\NerdPack\\media\\"
		}
	}
}

local defaults = {
	['CONFIG'] = {
		['test'] = false,
	},
	['OMList'] = {
		['test'] = false,
		['ShowDPS'] = false,
		['ShowHealthText'] = true,
		['ShowHealthBars'] = true,
	}
}

NeP.Config = {}

local MyAddonFrame = CreateFrame("Frame")
MyAddonFrame:RegisterEvent("VARIABLES_LOADED")
MyAddonFrame:SetScript("OnEvent", function(self, event, addon)
	if not NePData then 
	 	NePData = defaults; 
	end
	CreateFrame_VARIABLES_LOADED();
end)

NeP.Config.resetConfig = function(config)
	NePData[config] = defaults[config]
end

NeP.Config.readKey = function(config, key)
	if NePData[config] ~= nil then
		if NePData[config][key] ~= nil then
			return NePData[config][key]
		else
			NePData[config][key] = defaults[config][key] 
		end
	else
		NePData[config] = defaults[config]
	end
end

NeP.Config.writeKey = function(config, key, value)
	NePData[config][key] = value
end

NeP.Config.toggleKey = function(config, key)
	if NePData[config][key] ~= nil then
		NePData[config][key] = not NePData[config][key]
	else
		NePData[config][key] = defaults[config][key] 
	end
end

--[[-----------------------------------------------
									** Commands **
							DESC: Slash commands in-game.
---------------------------------------------------]]
ProbablyEngine.command.register(NeP.Addon.Info.Nick, function(msg, box)
	local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == 'config' or command == 'c' then
		NeP.Addon.Interface.ConfigGUI()
	elseif command == 'class' or command == 'cl' then
		NeP.Addon.Interface.ClassGUI()
	elseif command == 'info' or command == 'i' then
		NeP.Addon.Interface.InfoGUI()
	elseif command == 'cache' or command == 'cch' or command == 'om' then
		NeP.Addon.Interface.CacheGUI()
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		NeP.Core.HideAll()
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Addon.Interface.OverlaysGUI()
	elseif command == 'test' then
		NeP.Addon.Interface.OMGUI()
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
									** Gobal's **
								DESC: Global functions.
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
		return NeP.Addon.Interface.GuiColor
	end
end

function NeP.Core.GetCrInfo(txt)
	local _nick = NeP.Addon.Interface.addonColor..NeP.Addon.Info.Nick
	local _classColor = NeP.Core.classColor('Player')
	return NeP.Addon.Info.Icon.. '|r[' .. _nick .. "|r]|r[|cff" .. _classColor .. txt .. "|r]"
end

function NeP.Core.HideAll()
	if not NeP.Core.hidding then
		NeP.Core.Print('Now Hidding everything, to re-enable use the command "/np show".')
		ProbablyEngine.buttons.buttonFrame:Hide()
		NeP_MinimapButton:Hide()
		NeP.Core.hidding = true
	else
		NeP.Core.hidding = false
		ProbablyEngine.buttons.buttonFrame:Show()
		NeP_MinimapButton:Show()
		NeP.Core.Print('Now Showing everything again.')
	end
end

function NeP.Core.Print(txt)
	if not NeP.Core.hidding and NeP.Core.PeFetch('npconf', 'Prints') then
		local _name = NeP.Addon.Interface.addonColor..NeP.Addon.Info.Name
		print("|r[".._name.."|r]: "..NeP.Core.printColor..txt)
	end
end

function NeP.Core.Alert(txt)
	if not NeP.Core.hidding and NeP.Core.PeFetch('npconf', 'Alerts') then
		if NeP.Core.PeFetch('npconf', 'Sounds') then
			PlaySoundFile("Interface\\AddOns\\Probably_MrTheSoulz\\media\\beep.mp3")
		end
		npAlert:message("|r["..NeP.Addon.Interface.addonColor.."MTS|r]: "..NeP.Core.printColor..txt)
	end
end

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function NeP.Core.Distance(a, b)
	-- FireHack
	if FireHack then
		local ax, ay, az = ObjectPosition(b)
		local bx, by, bz = ObjectPosition(a)
		return round(math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
	else
		return ProbablyEngine.condition["distance"](b)
	end
	return 0
end

function NeP.Core.LineOfSight(a, b)
	if FireHack then
		if UnitExists(a) and UnitExists(b) then
			local ax, ay, az = ObjectPosition(a)
			local bx, by, bz = ObjectPosition(b)
			local losFlags =  bit.bor(0x10, 0x100)
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
			if ax == nil or ay == nil or az == nil or bx == nil or by == nil or bz == nil then return false end
			return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
		end
	end
	return false
end

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