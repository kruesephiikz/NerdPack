--[[-----------------------------------------------
	** Main Tables. **
---------------------------------------------------]]
NeP = {
	Core = {
		CurrentCR = false,
		hiding = false,
		--[[
				** PE Abstract's **
			These are used to have a easly way to update stuff related
			to ProbablyEngine.
		]]
		peRecomemded = '6.1r16',
		PeFetch = ProbablyEngine.interface.fetchKey,
		PeConfig = ProbablyEngine.config,
		PeBuildGUI = ProbablyEngine.interface.buildGUI
	},
	Interface = {
		addonColor = '0070DE',
		printColor = '|cffFFFFFF',
		mediaDir = 'Interface\\AddOns\\NerdPack\\media\\',
		classGUIs = {},
	},
	Info = {
		Name = 'NerdPack',
		Nick = 'NeP',
		Author = 'MrTheSoulz',
		Version = '6.2.3.1',
		Branch = 'Stable',
		WoW_Version = '6.2.3',
		Logo = 'Interface\\AddOns\\NerdPack\\media\\logo.blp',
		Splash = 'Interface\\AddOns\\NerdPack\\media\\splash.blp',
		Forum = 'http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/532241-pe-nerdpack.html',
		Donate = 'http://goo.gl/yrctPO'
	}
}

--[[-----------------------------------------------
	** Locals **
---------------------------------------------------]]
local _addonColor = '|cff'..NeP.Interface.addonColor

--[[-----------------------------------------------
	** Round **
DESC: Round a number.
Example: [ if < 4.5 then return 4, else if >= 4.5 return 5 ].

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Round(num, idp)
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
			return ProbablyEngine.condition['distance'](b)
		end
	end
	return 0
end

--[[-----------------------------------------------
	** LineOfSight **
DESC: returns the LineOfSight betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
local ignoreLOS = {
	['76585'] = '',	-- Ragewing the Untamed (UBRS)
	['77063'] = '',	-- Ragewing the Untamed (UBRS)
	['77182'] = '',	-- Oregorger (BRF)
	['77891'] = '',	-- Grasping Earth (BRF)
	['77893'] = '',	-- Grasping Earth (BRF)
	['78981'] = '',	-- Iron Gunnery Sergeant (BRF)
	['81318'] = '',	-- Iron Gunnery Sergeant (BRF)
	['83745'] = '',	-- Ragewing Whelp (UBRS)
	['86252'] = '',	-- Ragewing the Untamed (UBRS)
	['56173'] = '',	-- Deathwing (DragonSoul)
	['56471'] = '',	-- Mutated Corruption (Dragon Soul: The Maelstrom)
	['57962'] = '',	-- Deathwing (Dragon Soul: The Maelstrom)
	['55294'] = '',	-- Ultraxion (DragonSoul)
	['56161'] = '',	-- Corruption (DragonSoul)
	['52409'] = '',	-- Ragnaros (FireLands)
	['87761'] = '',
}

local losFlags =  bit.bor(0x10, 0x100)
function NeP.Core.LineOfSight(a, b)
	if UnitExists(a) and UnitExists(b) then
		-- Workaround LoS issues.
		local aCheck = select(6,strsplit('-',UnitGUID(a)))
		local bCheck = select(6,strsplit('-',UnitGUID(b)))
		if ignoreLOS[tostring(aCheck)] ~= nil then return true end
		if ignoreLOS[tostring(bCheck)] ~= nil then return true end
		
		if FireHack then
			local ax, ay, az = ObjectPosition(a)
			local bx, by, bz = ObjectPosition(b)
			return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
		else
			-- Since other unlockers dont have LoS, return true
			return true
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
			return ProbablyEngine.condition['infront'](b)
		end
	end
end

--[[-----------------------------------------------
	** Class Color **
DESC: Decide wich class we're then return the
proper class color.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.classColor(unit, _type)
	if _type == nil then _type = 'HEX' end
	if UnitIsPlayer(unit) then
		local _classColors = {
			['HUNTER'] = { r = 0.67, g = 0.83, b = 0.45, Hex = 'abd473' },
			['WARLOCK'] = { r = 0.58, g = 0.51, b = 0.79, Hex = '9482c9' },
			['PRIEST'] = { r = 1.0, g = 1.0, b = 1.0, Hex = 'ffffff' },
			['PALADIN'] = { r = 0.96, g = 0.55, b = 0.73, Hex = 'f58cba' },
			['MAGE'] = { r = 0.41, g = 0.8, b = 0.94, Hex = '69ccf0' },
			['ROGUE'] = { r = 1.0, g = 0.96, b = 0.41, Hex = 'fff569' },
			['DRUID'] = { r = 1.0, g = 0.49, b = 0.04, Hex = 'ff7d0a' },
			['SHAMAN'] = { r = 0.0, g = 0.44, b = 0.87, Hex = '0070de' },
			['WARRIOR'] = { r = 0.78, g = 0.61, b = 0.43, Hex = 'c79c6e' },
			['DEATHKNIGHT'] = { r = 0.77, g = 0.12 , b = 0.23, Hex = 'c41f3b' },
			['MONK'] = { r = 0.0, g = 1.00 , b = 0.59, Hex = '00ff96' },
		}
		local _class, className = UnitClass(unit)
		local _color = _classColors[className]
		
		if _type == 'HEX' then
			return _color.Hex
		elseif _type == 'RBG' then
			return _color.r, _color.g, _color.b
		end
	else
		return 'FFFFFF'
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
	return '|T'..NeP.Info.Logo..':10:10|t'.. '|r[' .. _nick .. '|r]|r[|cff' .. _classColor .. txt .. '|r]'
end

--[[-----------------------------------------------
	** HideAll **
DESC: Hide everything, you might need this for
livestreams or recording.
While hiding all alerts/notifications, sounds &
prints should not be displayed.

Could be improved...

Build By: MTS
---------------------------------------------------]]
function NeP.Core.HideAll()
	if not NeP.Core.hiding then
		NeP.Core.Print('Now hiding everything, to re-enable use the command ( '..NeP.Info.Nick..' show ).')
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
local lastPrint = ''
function NeP.Core.Print(txt)
	if txt ~= lastPrint then
		if not NeP.Core.hiding and NeP.Core.PeFetch('NePConf', 'Prints') then
			local _name = _addonColor..NeP.Info.Nick
			lastPrint = txt
			print('|r['.._name..'|r]: '..NeP.Interface.printColor..txt)
		end
	end
end

--[[-----------------------------------------------
	** Alert **
DESC: Display a alert on the main frame.

Build By: MTS
---------------------------------------------------]]
NeP.Interface.Alerts = {}
local lastAlert = ''
function NeP.Core.Alert(txt)
	if txt ~= lastPrint then
		if not NeP.Core.hiding and NeP.Core.PeFetch('NePConf', 'Alerts') then
			lastAlert = txt
			table.insert(NeP.Interface.Alerts, txt)
		end
	end
end

--[[-----------------------------------------------
	** NePData **
DESC: Saved variables.

Build By: MTS
---------------------------------------------------]]
NeP.Config = {
	Defaults = {}
}

local LoadNePData = CreateFrame('Frame')
LoadNePData:RegisterEvent('VARIABLES_LOADED')
LoadNePData:SetScript('OnEvent', function(self, event, addon)
	
	-- IF NePData does not exist, then create it with defaults
	if not NePData or NePData == nil then 
	 	NePData = NeP.Config.Defaults
	end

	-- Reset
	function NeP.Config.resetConfig(config)
		NePData[config] = NeP.Config.Defaults[config]
	end
	
	-- Read
	function NeP.Config.readKey(config, key)
		if NePData[config] ~= nil then
			if NePData[config][key] ~= nil then
				return NePData[config][key]
			else
				NePData[config][key] = NeP.Config.Defaults[config][key] 
			end
		else
			NePData[config] = NeP.Config.Defaults[config]
		end
	end

	-- Write
	function NeP.Config.writeKey(config, key, value)
		NePData[config][key] = value
	end

	-- Toggle
	function NeP.Config.toggleKey(config, key)
		if NePData[config][key] ~= nil then
			NePData[config][key] = not NePData[config][key]
		else
			NePData[config][key] = NeP.Config.Defaults[config][key] 
		end
	end
	
	--[[
		Run GUI's wich depend on NePData.
		This is the best way i could think of to make sure nothing
		wich depends on NePData gets loaded too early.
	]]
	StatusGUI_RUN();
	OMGUI_RUN()

	--[[
		PE's Overwrites.
		Somethings on PE have issues or could be better,
		until they're fixed in PE itself we overwrite them.
	]]
	LineOfSight = NeP.Core.LineOfSight

end)