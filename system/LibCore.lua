--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

-- Local stuff to reduce gobal calls
local _parse = ProbablyEngine.dsl.parse
local enemieCache = NeP.ObjectManager.unitCache
local friendlyCache = NeP.ObjectManager.unitFriendlyCache
local peConfig = NeP.Core.PeConfig
local UnitAffectingCombat = UnitAffectingCombat
local UnitThreatSituation = UnitThreatSituation
local UnitCanAttack = UnitCanAttack
local UnitDebuff = UnitDebuff
local UnitClassification = UnitClassification
local UnitIsTappedByPlayer = UnitIsTappedByPlayer

--[[-----------------------------------------------
** dynamicEval **
DESC: Used to get values from GUIs and use them
on PE's conditions

Build By: MTS
---------------------------------------------------]]
NeP.Core.dynamicEval = function(condition, spell)
	return _parse(condition, spell or '')
end

--[[-----------------------------------------------
** Smart AoE **
DESC: PE's way to handle smart AoE does not provide
support for generic unlockers, using this + my OM makes it work
across all unlockers.

Build By: MTS
---------------------------------------------------]]
local _SAoE_Time = nil
local UnitsTotal = 0

NeP.Lib.SAoE = function(units, distance)
	if _SAoE_Time == nil or _SAoE_Time + 0.5 <= GetTime() then
		_SAoE_Time = nil
		UnitsTotal = 0
		
		-- Force AoE
		if peConfig.read('button_states', 'multitarget', false) then
			UnitsTotal = UnitsTotal + 99
		
		-- SAoE
		elseif peConfig.read('button_states', 'NeP_SAoE', false) then
			for i=1,#enemieCache do
				local object = enemieCache[i]
				if UnitAffectingCombat(object.key) then
					if object.distance <= distance then
						UnitsTotal = UnitsTotal + 1
					end
				end
			end
		end
		
		_SAoE_Time = GetTime()
		return UnitsTotal >= units
	end
	
	return UnitsTotal >= units 
end

--[[-----------------------------------------------
** Get Unit Combat Range **
DESC: Returns the units's combat range.

Build By: MTS
---------------------------------------------------]]
local _rangeTable = {
	["melee"] = 1.5,
	["ranged"] = 40,
}

NeP.Lib.getUnitRange = function(a, t)
	if FireHack then 
		return _rangeTable[t] + UnitCombatReach('player') + UnitCombatReach(a)
	-- Unlockers wich dont have UnitCombatReach like functions...
	else
		return _rangeTable[t] + 3.5
	end
end

--[[-----------------------------------------------
** Automated Taunting **
DESC: Checks if a enemie in the OM cache can/should
be taunted.

Build By: MTS
---------------------------------------------------]]
NeP.Lib.canTaunt = function()
	if NeP.Core.PeFetch('NePConf', 'Taunts') then
		for i=1,#enemieCache do
			local object = enemieCache[i].key
			if UnitIsTappedByPlayer(object) and object.distance <= 40 then
				if UnitAffectingCombat(object) then
					if UnitThreatSituation(object) and UnitThreatSituation(object) >= 2 then
						if NeP.Core.Infront('player', object) then
							ProbablyEngine.dsl.parsedTarget = object
							return true 
						end
					end
				end
			end
		end
	end
	
	return false
end

--[[-----------------------------------------------
** Automated Dispeling **
DESC: Checks if a friendly unit in the OM cache can/should
be dispelled.

Build By: MTS
---------------------------------------------------]]
local blacklistedDebuffs = {
	'Mark of Arrogance',
	'Displaced Energy'
}

NeP.Lib.Dispell = function(dispelTypes)
	if NeP.Core.PeFetch('NePConf', 'Dispell') then
		for i=1,#friendlyCache do
			local object = friendlyCache[i]
			if object.distance <= 40 then
				for j = 1, 40 do
					local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_,_,_,_ = UnitDebuff(object.key, j)
					if dispelType and dispelTypes then
						local ignore = false
						for k = 1, #blacklistedDebuffs do
							if debuffName ~= blacklistedDebuffs[k] then
								ProbablyEngine.dsl.parsedTarget = object.key
								return true
							end
						end
					end
				end
			end
		end
	end
	
	return false
end

--[[
Usage:
NeP.Lib.AutoDots(Spell, Health, Duration, Distance, Classification)

Classifications:
	elite - Elite
	minus - Minion of another NPC; does not give experience or reputation.
	normal - Normal
	rare - Rare
	rareelite - Rare-Elite
	worldboss - World Boss
	all - All Units
]]
local function NeP_isElite(unit)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(unit)
	if classification == "elite" 
		or classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(unit) == -1 
		or boss.BossIDs[UnitID(unit)] then 
			return true 
		end
    return false
end

NeP.Lib.AutoDots = function(Spell, Health, Duration, Distance, Classification)
	
	-- Check if we have the spell before anything else...
	if not IsUsableSpell(Spell) then return false end
	
	-- Classification Hacks
	local passThruClassification = false
	
	-- So we dont need to fill everything
	if Classification == nil then Classification = 'elite' end
	if Distance == nil then Distance = 40 end
	if Health == nil then Health = 100 end
	if Duration == nil then Duration = 0 end
	
	for i=1,#enemieCache do
		local Obj = enemieCache[i]
		if UnitAffectingCombat(Obj.key) then
			if (Classification == 'elite' and NeP_isElite(Obj.key)) or Classification == 'all' then passThruClassification = true end
			if UnitClassification(Obj.key) == Classification or passThruClassification then
				if Obj.health <= Health then
					local _,_,_,_,_,_,debuff = UnitDebuff(Obj.key, GetSpellInfo(Spell), nil, "PLAYER")
					if not debuff or debuff - GetTime() < Duration then
						if UnitCanAttack("player", Obj.key)
						and Obj.distance <= Distance then
							if NeP.Core.Infront('player', Obj.key) then
								ProbablyEngine.dsl.parsedTarget = Obj.key
								return true
							end					 
						end
					end
				end
			end
		end
	end
	
	return false
end
