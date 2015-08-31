--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

local _parse = ProbablyEngine.dsl.parse

NeP.Core.dynamicEval = function(condition, spell)
	if not condition then return false end
	return _parse(condition, spell or '')
end

--[[-----------------------------------------------
** ISKAR HELPER (WoD - HellFire) **
DESC: This is a function im building to handle iskar's eye
completly automated.

Build By: MTS
---------------------------------------------------
local iskarHelper_Created = false
NeP.Lib.IskarHelper = function()

	local spellTable = {
		-- Healers Spells
		[105] = { dispel = '', interrupt = '' }, -- Druid Resto
		[257] = { dispel = '' , interrupt = '' }, -- Priest Holy
		[256] = { dispel = '' , interrupt = '' }, -- Priest Disc
		[65] = { dispel = '' , interrupt = '' }, -- Paladin Holy
		[270] = { dispel = '' , interrupt = '' }, -- Monk MistWeaver
		[264] = { dispel = '' , interrupt = '' } -- Shaman Resto
	}
	local eye_ID = GetSpellInfo(179202) -- Eye of Anzu
	local Shadowfel_Warden_ID = 91541
	local aura_phantasmal_wounds = GetSpellInfo(182325) -- Phantasmal Wounds
	local aura_phantasmal_winds = GetSpellInfo(181957) -- Phantasmal Winds
	local aura_fel_chakram = GetSpellInfo(182178) -- Fel Chakram
	local aura_phantasmal_corruption = GetSpellInfo(181824) -- Phantasmal Corruption
	local aura_fel_bomb = GetSpellInfo(181753) -- Fel Bomb
	local aura_phantasmal_bomb = GetSpellInfo(179219) -- Phantasmal Fel Bomb
	local aura_dark_bindings = GetSpellInfo(185510) -- Dark Bindings
	local aura_focused_chaos = GetSpellInfo(185014) -- Focused Chaos
	local spell_fel_conduit = GetSpellInfo(181827) -- Fel Conduit
	local spell_fel_bomb = GetSpellInfo(179218) -- Phantasmal obliteration
	local PlayerSpell = spellTable[GetSpecializationInfo(GetSpecialization())]

	if not iskarHelper_Created then
		
		C_Timer.NewTicker(0.1, (function()
			
			for i=1,#NeP.ObjectManager.unitFriendlyCache do
				local object = NeP.ObjectManager.unitFriendlyCache[i]
				local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_,_,_,_ = UnitDebuff(object.key, i)
				local _role = UnitGroupRolesAssigned(object.key)
				
				-- Healer Stuff
				if _role == 'HEALER' then
					
					-- Dispell's
					if debuffName == spell_fel_bomb or debuffName == spell_fel_bomb then
						Cast(PlayerSpell.dispell, object.key)
					elseif UnitExists('target') and --target casting fel conduit then
						Cast(PlayerSpell.interrupt, 'target')
					end
				
				-- Tank
				elseif _role == 'TANK' then
				
				end
				
				-- If not Adds
				if not #NeP.ObjectManager.unitCache > 1 then
					
					-- Pass the Eye to other unit
					if debuffName == aura_phantasmal_winds then
						Cast(eye_ID, object.key)
					end

				-- IF Adds
				else
					
					-- Pass the eye to other healer
					if _role == 'HEALER' then
						-- If player has 4 stacks of ...(forgot name...)
						if -- FIX ME then
							Cast(eye_ID, object.key)
						end
					end
					
				end
				
			end
			
		end), nil)
	
	end
end]]

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
		if NeP.Core.PeConfig.read('button_states', 'multitarget', false) then
			UnitsTotal = UnitsTotal + 99
		elseif NeP.Core.PeConfig.read('button_states', 'NeP_SAoE', false) then
			for i=1,#NeP.ObjectManager.unitCache do
				local object = NeP.ObjectManager.unitCache[i]
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

NeP.Lib.getUnitRange = function(a, t)
	local _rangeTable = {
		["melee"] = 1.5,
		["ranged"] = 40,
	}
	if FireHack then 
		return _rangeTable[t] + UnitCombatReach('player') + UnitCombatReach(a)
	else
		return _rangeTable[t] + 3.5
	end
end

NeP.Lib.canTaunt = function()
	if NeP.Core.PeFetch('NePConf', 'Taunts') then
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i].key
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

NeP.Lib.Dispell = function(dispelTypes)
	local blacklistedDebuffs = {
		'Mark of Arrogance',
		'Displaced Energy'
	}
	if NeP.Core.PeFetch('NePConf', 'Dispell') then
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitFriendlyCache[i]
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
	if not IsUsableSpell(_spell) then return false end
	if _classification == nil then _classification = 'all' end
	if _distance == nil then _distance = 40 end
	if _health == nil then _health = 100 end
	if _duration == nil then _duration = 0 end
	for i=1,#NeP.ObjectManager.unitCache do
		local _object = NeP.ObjectManager.unitCache[i]
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
