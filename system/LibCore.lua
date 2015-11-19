--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

-- Local stuff to reduce global calls
local _parse = ProbablyEngine.dsl.parse
local enemieCache = NeP.OM.unitEnemie
local friendlyCache = NeP.OM.unitFriend
local peConfig = NeP.Core.PeConfig
local UnitAffectingCombat = UnitAffectingCombat
local UnitThreatSituation = UnitThreatSituation
local UnitCanAttack = UnitCanAttack
local UnitDebuff = UnitDebuff
local UnitClassification = UnitClassification
local UnitIsTappedByPlayer = UnitIsTappedByPlayer

local function NeP_isElite(unit)
	local boss = LibStub('LibBossIDs')
	local classification = UnitClassification(unit)
	if classification == 'elite' 
		or classification == 'rareelite' 
		or classification == 'rare' 
		or classification == 'worldboss' 
		or UnitLevel(unit) == -1 
		or boss.BossIDs[UnitID(unit)] then 
			return true 
		end
    return false
end

--[[-----------------------------------------------
** dynamicEval **
DESC: Used to get values from GUIs and use them
on PE's conditions

Build By: MTS
---------------------------------------------------]]
function NeP.Core.dynEval(condition, spell)
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

function NeP.Lib.SAoE(Units, Distance)
	if _SAoE_Time == nil or _SAoE_Time + 0.5 <= GetTime() then
		_SAoE_Time = nil
		UnitsTotal = 0
		
		-- Force AoE
		if peConfig.read('button_states', 'multitarget', false) then
			UnitsTotal = UnitsTotal + 99
		
		-- SAoE
		elseif peConfig.read('button_states', 'NeP_SAoE', false) then
			for i=1,#enemieCache do
				local Obj = enemieCache[i]
				if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
					if Obj.distance <= Distance then
						UnitsTotal = UnitsTotal + 1
					end
				end
			end
		end
		
		_SAoE_Time = GetTime()
		return UnitsTotal >= Units
	end
	
	return UnitsTotal >= Units 
end

--[[-----------------------------------------------
** Get Unit Combat Range **
DESC: Returns the units's combat range.

Build By: MTS
---------------------------------------------------]]
local _rangeTable = {
	['melee'] = 1.5,
	['ranged'] = 40,
}

function NeP.Lib.UnitAttackRange(unitA, unitB, _type)
	if FireHack then 
		return _rangeTable[_type] + UnitCombatReach(unitA) + UnitCombatReach(unitB)
	-- Unlockers wich dont have UnitCombatReach like functions...
	else
		return _rangeTable[_type] + 3.5
	end
end

--[[-----------------------------------------------
** Automated Taunting **
DESC: Checks if a enemie in the OM cache can/should
be taunted.

Classifications:
	Elite (Includes all above)
	All

Build By: MTS
---------------------------------------------------]]
function NeP.Lib.canTaunt()
	if NeP.Core.PeFetch('NePConf', 'Taunts') ~= 'Disabled' then
		for i=1,#enemieCache do
			local Obj = enemieCache[i]
			if (NeP.Core.PeFetch('NePConf', 'Taunts') == 'elite' and NeP_isElite(Obj.key)) 
			or NeP.Core.PeFetch('NePConf', 'Taunts') == 'all' then
				if UnitIsTappedByPlayer(Obj.key) and Obj.distance <= 40 then
					if UnitAffectingCombat(Obj.key) then
						if UnitThreatSituation('player', Obj.key) and UnitThreatSituation('player', Obj.key) <= 2 then
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

--[[-----------------------------------------------
** Automated Dispeling **
DESC: Checks if a friendly unit in the OM cache can/should
be dispelled.

Build By: MTS
---------------------------------------------------]]
local blacklistedDebuffs = {
	['Mark of Arrogance'] = '',
	['Displaced Energy'] = ''
}

local LibDispellable = LibStub("LibDispellable-1.0")

function NeP.Lib.Dispel(Spell)
	if NeP.Core.PeFetch('NePConf', 'Dispell') then
		for i=1,#friendlyCache do
			local Obj = friendlyCache[i]
			if Obj.distance <= 40 then
				if LibDispellable:CanDispelWith(Obj.key, tonumber(GetSpellID(GetSpellName(Spell)))) then
					ProbablyEngine.dsl.parsedTarget = Obj.key
					return true
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

function NeP.Lib.AutoDots(Spell, Health, Duration, Distance, Classification)
	
	-- Check if we have the spell before anything else...
	if not IsUsableSpell(Spell) then return false end
	
	-- So we dont need to fill everything
	if Classification == nil then Classification = 'all' end
	if Distance == nil then Distance = 40 end
	if Health == nil then Health = 100 end
	if Duration == nil then Duration = 0 end
	
	for i=1,#enemieCache do
		local Obj = enemieCache[i]
		if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
			
			-- Classification WorkArounds
			local passThruClassification = false
			if (Classification == 'elite' and NeP_isElite(Obj.key)) or Classification == 'all' then passThruClassification = true end
			
			if UnitClassification(Obj.key) == Classification or passThruClassification then
				if Obj.health <= Health then
					local _,_,_,_,_,_,debuff = UnitDebuff(Obj.key, GetSpellInfo(Spell), nil, 'PLAYER')
					if not debuff or debuff - GetTime() < Duration then
						if UnitCanAttack('player', Obj.key)
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
