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
			Version = "6.2.0.1",
			Branch = "Alpha",
			WoW_Version = "6.2.0",
			Icon = "|TInterface\\AddOns\\NerdPack\\media\\logo.blp:20:20|t",
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

local _parse = ProbablyEngine.dsl.parse

--[[-----------------------------------------------
									** Conditions **
								DESC: Add condicions to PE.
---------------------------------------------------]]
ProbablyEngine.condition.register('twohand', function(target)
  return IsEquippedItemType("Two-Hand")
end)

ProbablyEngine.condition.register('onehand', function(target)
  return IsEquippedItemType("One-Hand")
end)

ProbablyEngine.condition.register('elite', function(target)
  return UnitClassification(target) == 'elite'
end)

ProbablyEngine.condition.register("petinmelee", function(target)
   return (IsSpellInRange(GetSpellInfo(2649), target) == 1)
end)

ProbablyEngine.condition.register("power.regen", function(target)
  return select(2, GetPowerRegen(target))
end)

ProbablyEngine.condition.register("casttime", function(target, spell)
    local name, rank, icon, cast_time, min_range, max_range = GetSpellInfo(spell)
    return cast_time
end)

ProbablyEngine.condition.register('NePinterrupt', function (target)
	if ProbablyEngine.condition['modifier.toggle']('interrupt') then
		if UnitName('player') == UnitName(target) then return false end
		local stopAt = NeP.Core.PeFetch('npconf', 'ItA') or 95
		local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
		return secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt
	end
	return false
end)

--[[-----------------------------------------------
									** Commands **
							DESC: Slash commands in-game.
---------------------------------------------------]]
ProbablyEngine.command.register(NeP.Addon.Info.Nick, function(msg, box)
	local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == 'config' or command == 'c' then
		NeP.Addon.Interface.ConfigGUI()
    elseif command == 'status' or command == 's' then
		NeP.ShowStatus()
	elseif command == 'class' or command == 'cl' then
		NeP.Addon.Interface.ClassGUI()
	elseif command == 'info' or command == 'i' then
		NeP.Addon.Interface.InfoGUI()
	elseif command == 'mill' or command == 'ml' then
		if NeP.AutoMilling then
			NeP.AutoMilling = false
			NeP.Core.Print('Stoped Milling...')
		else
			NeP.AutoMilling = true
			NeP.Core.Print('Started Milling...')
		end
	elseif command == 'cache' or command == 'cch' or command == 'om' then
		NeP.Addon.Interface.CacheGUI()
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		NeP.Core.HideAll()
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Addon.Interface.OverlaysGUI()
	else 
		NeP.Core.Print('/config - (Opens General Settings GUI)')
		NeP.Core.Print('/status - (Opens Status GUI)')
		NeP.Core.Print('/class - (Opens Class Settings GUI)')
		NeP.Core.Print('/Info - (Opens Info GUI)')
		NeP.Core.Print('/mill - (Starts Auto Milling)')
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

function NeP.Core.dynamicEval(condition, spell)
	if not condition then return false end
	return _parse(condition, spell or '')
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

function NeP.Core.BagSpace()
	local freeslots = 0
	for lbag = 0, NUM_BAG_SLOTS do
		numFreeSlots, BagType = GetContainerNumFreeSlots(lbag)
		freeslots = freeslots + numFreeSlots
	end
	return freeslots
end