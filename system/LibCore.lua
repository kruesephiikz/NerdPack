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
NeP.Lib.AutoDots(_spell, _health, _duration, _distance, _classification)

Classifications:
	elite - Elite
	minus - Minion of another NPC; does not give experience or reputation.
	normal - Normal
	rare - Rare
	rareelite - Rare-Elite
	worldboss - World Boss
	all - All Units
]]
local _lastDotted = nil
NeP.Lib.AutoDots = function(_spell, _health, _duration, _distance, _classification)
	
	-- So we dont need to fill everything
	if not IsUsableSpell(_spell) then return false end
	if _classification == nil then _classification = 'all' end
	if _distance == nil then _distance = 40 end
	if _health == nil then _health = 100 end
	if _duration == nil then _duration = 0 end
	
	for i=1,#enemieCache do
		local _object = enemieCache[i]
		if _lastDotted == _object.key then return false end
		if UnitAffectingCombat(_object.key) then
			if UnitClassification(_object.key) == _classification or _classification == 'all' then
				if _object.health <= _health then
					local _,_,_,_,_,_,debuff = UnitDebuff(_object.key, GetSpellInfo(_spell), nil, "PLAYER")
					if not debuff or debuff - GetTime() < _duration then
						if UnitCanAttack("player", _object.key)
						and _object.distance <= _distance then
							if NeP.Core.Infront('player', _object.key) then
								ProbablyEngine.dsl.parsedTarget = _object.key
								_lastDotted = _object.key
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
