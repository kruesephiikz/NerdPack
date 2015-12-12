NeP.OM = {
	unitEnemie = {},
	unitFriend = {},
}

local addonColor = NeP.Interface.addonColor;
local tittleGUI = '|T'..NeP.Info.Logo..':20:20|t |cff'..addonColor..NeP.Info.Nick;

NeP.Core.BuildGUI('omSettings', {
    key = "ObjectCache",
    title = tittleGUI,
    subtitle = "ObjectManager Settings",
    color = addonColor,
    width = 210,
    height = 350,
    config = {
    	{ type = 'header', text = '|cff'..addonColor.."Cache Options:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Use Advanced Object Manager:", key = "aOM", default = true },
			{ type = "spinner", text = "Cache Distance:", key = "CD", width = 90, min = 10, max = 200, default = 100, step = 5},

			{ type = "text", text = "Enemie Units Cached: ", size = 11, offset = -11 },
			{ key = 'eObjs', type = "text", text = "...", size = 11, align = "right", offset = 0 },

			{ type = "text", text = "Friendly Units Cached: ", size = 11, offset = -11 },
			{ key = 'fObjs', type = "text", text = "...", size = 11, align = "right", offset = 0 },

			--{ type = "button", text = "Objects List", width = 190, height = 20, callback = function() NeP.Interface.OMGUI() end },
    }
})

-- Local stuff to reduce global calls
local peConfig = NeP.Core.PeConfig
local UnitExists = UnitExists
local objectDistance = NeP.Core.Distance

local InfoWindow = NeP.Core.getGUI('omSettings')

local TempOM = {
	unitEnemie = {},
	unitFriend = {},
}

-- Refresh OM
C_Timer.NewTicker(0.25, (function()
	-- Wipe Cache
	wipe(NeP.OM.unitEnemie)
	wipe(NeP.OM.unitFriend)
	--Refresh Enemine
	for i=1,#TempOM.unitEnemie do
		local Obj = TempOM.unitEnemie[i]
		if FireHack and ObjectExists(Obj.key) or not FireHack and UnitExists(Obj.key) then
			NeP.OM.unitEnemie[#NeP.OM.unitEnemie+1] = {
				key = Obj.key,
				name = Obj.Name,
				is = Obj.is,
				distance = objectDistance('player', Obj.key),
				health = math.floor((UnitHealth(Obj.key) / UnitHealthMax(Obj.key)) * 100), 
				maxHealth = UnitHealthMax(Obj.key), 
				actualHealth = UnitHealth(Obj.key), 
				name = UnitName(Obj.key)
			}
		end
	end
	--Refresh Friendly
	for i=1,#TempOM.unitFriend do
		local Obj = TempOM.unitFriend[i]
		if FireHack and ObjectExists(Obj.key) or not FireHack and UnitExists(Obj.key) then
			NeP.OM.unitFriend[#NeP.OM.unitFriend+1] = {
				key = Obj.key,
				name = Obj.Name,
				is = Obj.is,
				distance = objectDistance('player', Obj.key),
				health = math.floor((UnitHealth(Obj.key) / UnitHealthMax(Obj.key)) * 100), 
				maxHealth = UnitHealthMax(Obj.key), 
				actualHealth = UnitHealth(Obj.key), 
				name = UnitName(Obj.key)
			}
		end
	end
	-- Update UI info
	if InfoWindow.parent:IsShown() then
		InfoWindow.elements.eObjs:SetText(#NeP.OM.unitEnemie)
		InfoWindow.elements.fObjs:SetText(#NeP.OM.unitFriend)
	end
end), nil)

--[[
	DESC: Checks if unit has a Blacklisted Debuff.
	This will remove the unit from the OM cache.
---------------------------------------------------]]
local BlacklistedAuras = {
		-- CROWD CONTROL
	[118] = '',        -- Polymorph
	[1513] = '',       -- Scare Beast
	[1776] = '',       -- Gouge
	[2637] = '',       -- Hibernate
	[3355] = '',       -- Freezing Trap
	[6770] = '',       -- Sap
	[9484] = '',       -- Shackle Undead
	[19386] = '',      -- Wyvern Sting
	[20066] = '',      -- Repentance
	[28271] = '',      -- Polymorph (turtle)
	[28272] = '',      -- Polymorph (pig)
	[49203] = '',      -- Hungering Cold
	[51514] = '',      -- Hex
	[61025] = '',      -- Polymorph (serpent) -- FIXME: gone ?
	[61305] = '',      -- Polymorph (black cat)
	[61721] = '',      -- Polymorph (rabbit)
	[61780] = '',      -- Polymorph (turkey)
	[76780] = '',      -- Bind Elemental
	[82676] = '',      -- Ring of Frost
	[90337] = '',      -- Bad Manner (Monkey) -- FIXME: to check
	[115078] = '',     -- Paralysis
	[115268] = '',     -- Mesmerize
		-- MOP DUNGEONS/RAIDS/ELITES
	[106062] = '',     -- Water Bubble (Wise Mari)
	[110945] = '',     -- Charging Soul (Gu Cloudstrike)
	[116994] = '',     -- Unstable Energy (Elegon)
	[122540] = '',     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
	[123250] = '',     -- Protect (Lei Shi)
	[143574] = '',     -- Swelling Corruption (Immerseus)
	[143593] = '',     -- Defensive Stance (General Nazgrim)
		-- WOD DUNGEONS/RAIDS/ELITES
	[155176] = '',     -- Damage Shield (Primal Elementalists - Blast Furnace)
	[155185] = '',     -- Cotainment (Primal Elementalists - BRF)
	[155233] = '',     -- Dormant (Blast Furnace)
	[155265] = '',     -- Cotainment (Primal Elementalists - BRF)
	[155266] = '',     -- Cotainment (Primal Elementalists - BRF)
	[155267] = '',     -- Cotainment (Primal Elementalists - BRF)
	[157289] = '',     -- Arcane Protection (Imperator Mar'Gok)
	[174057] = '',     -- Arcane Protection (Imperator Mar'Gok)
	[182055] = '',     -- Full Charge (Iron Reaver)
	[184053] = '',     -- Fel Barrier (Socrethar)
}

local function BlacklistedDebuffs(Obj)
	local isBadDebuff = false
	for i = 1, 40 do
		local spellID = select(11, UnitDebuff(Obj, i))
		if spellID ~= nil then
			if BlacklistedAuras[tonumber(spellID)] ~= nil then
				isBadDebuff = true
			end
		end
	end
	return isBadDebuff
end

--[[
	DESC: Checks if Object is a Blacklisted.
	This will remove the Object from the OM cache.
---------------------------------------------------]]
local BlacklistedObjects = {
	[76829] = '',		-- Slag Elemental (BrF - Blast Furnace)
	[78463] = '',		-- Slag Elemental (BrF - Blast Furnace)
	[60197] = '',		-- Scarlet Monastery Dummy
	[64446] = '',		-- Scarlet Monastery Dummy
	[93391] = '',		-- Captured Prisoner (HFC)
	[93392] = '',		-- Captured Prisoner (HFC)
	[93828] = '',		-- Training Dummy (HFC)
	[234021] = '',
	[234022] = '',
	[234023] = '',
}

local function BlacklistedObject(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj) or '0')
	return BlacklistedObjects[tonumber(ObjID)] ~= nil
end

local TrackedDummys = {
	[31144] = 'dummy',		-- Training Dummy - Lvl 80
	[31146] = 'dummy',		-- Raider's Training Dummy - Lvl ??
	[32541] = 'dummy', 		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
	[32542] = 'dummy',		-- Disciple's Training Dummy - Lvl 65
	[32545] = 'dummy',		-- Initiate's Training Dummy - Lvl 55
	[32546] = 'dummy',		-- Ebon Knight's Training Dummy - Lvl 80
	[32666] = 'dummy',		-- Training Dummy - Lvl 60
	[32667] = 'dummy',		-- Training Dummy - Lvl 70
	[46647] = 'dummy',		-- Training Dummy - Lvl 85
	[67127] = 'dummy',		-- Training Dummy - Lvl 90
	[87318] = 'dummy',		-- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
	[87761] = 'dummy',		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
	[87322] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
	[88314] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
	[88836] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
	[88288] = 'dummy',		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
	[87317] = 'dummy',		-- Dungeoneer's Training Dummy - Lvl 102 (Lunarfall - Damage)
	[87320] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Stormshield - Damage)
	[87329] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Stormshield - Tank)
	[87762] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Warspear - Damage)
	[88837] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Warspear - Tank)
	[88906] = 'dummy',		-- Combat Dummy - Lvl 100 (Nagrand)
	[88967] = 'dummy',		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
	[89078] = 'dummy',		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
}

local function isDummy(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj) or '0')
	return TrackedDummys[tonumber(ObjID)] ~= nil
end

--[[
	DESC: Places the object in its correct place.
	This is done in a seperate function so we dont have
	to repeate code over and over again for all unlockers.
---------------------------------------------------]]
local function addToOM(Obj)
	if not BlacklistedObject(Obj) and ProbablyEngine.condition['alive'](Obj) then
		if not BlacklistedDebuffs(Obj) then
			-- Friendly
			if UnitIsFriend('player', Obj) then
				TempOM.unitFriend[#TempOM.unitFriend+1] = {
					key = Obj,
					name = UnitName(Obj),
					distance = objectDistance('player', Obj.key),
					is = 'friendly'
				}
			-- Enemie
			elseif UnitCanAttack('player', Obj) then
				TempOM.unitEnemie[#TempOM.unitEnemie+1] = {
					key = Obj,
					name = UnitName(Obj),
					distance = objectDistance('player', Obj.key),
					is = isDummy(Obj) and 'dummy' or 'enemie'
				}
			end
		end
	end
end

local function NeP_FireHackOM()
	local totalObjects = ObjectCount()
	for i=1, totalObjects do
		local Obj = ObjectWithIndex(i)
		if UnitGUID(Obj) ~= nil and ObjectExists(Obj) then
			if ObjectIsType(Obj, ObjectTypes.Unit) then
				local ObjDistance = objectDistance('player', Obj)
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(Obj)
				end
			end
		end
	end
end

--[[
	Generic OM
---------------------------------------------------]]
local function GenericFilter(unit, objectDis)
	if UnitExists(unit) then
		local objectName = UnitName(unit)
		local alreadyExists = false
		-- Friendly Filter
		if UnitCanAttack('player', unit) then
			for i=1, #NeP.OM.unitEnemie do
				local object = NeP.OM.unitEnemie[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		-- Enemie Filter
		elseif UnitIsFriend('player', unit) then
			for i=1, #NeP.OM.unitFriend do
				local object = NeP.OM.unitFriend[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		end
		if not alreadyExists then return true end
	end
	return false
end

local function NeP_GenericOM()
	-- Self
	addToOM('player', 5)
	-- Mouseover
	if UnitExists('mouseover') then
		local object = 'mouseover'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object)
			end
		end
	end
	-- Target Cache
	if UnitExists('target') then
		local object = 'target'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object)
			end
		end
	end
	-- If in Group scan frames...
	if IsInGroup() or IsInRaid() then
		local prefix = (IsInRaid() and 'raid') or 'party'
		for i = 1, GetNumGroupMembers() do
			-- Enemie
			local target = prefix..i..'target'
			local ObjDistance = objectDistance('player', target)
			if GenericFilter(target, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(target)
				end
			end
			-- Friendly
			local friendly = prefix..i
			local ObjDistance = objectDistance('player', friendly)
			if GenericFilter(friendly, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(friendly)
				end
			end
		end
	end
end

-- Create a Temp OM contating all Objects
C_Timer.NewTicker(1, (function()
	-- Wipe Cache
	wipe(TempOM.unitEnemie)
	wipe(TempOM.unitFriend)
	-- Make sure we're running
	if NeP.Core.CurrentCR and peConfig.read('button_states', 'MasterToggle', false) then
		-- Master Toggle
		if NeP.Core.PeFetch('ObjectCache', 'ObjectCache') then
			-- FireHack OM
			if FireHack then
				NeP_FireHackOM()
			-- Generic Cache
			else 
				NeP_GenericOM()
			end
		end
		-- Sort by distance
		table.sort(TempOM.unitEnemie, function(a,b) return a.distance < b.distance end)
		table.sort(TempOM.unitFriend, function(a,b) return a.distance < b.distance end)
	end
end), nil)