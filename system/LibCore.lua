--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

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

ProbablyEngine.condition.register("isBoss", function (target, spell)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if spell == "true" and (classification == "rareelite" or classification == "rare") then return true end
    if classification == "worldboss" or UnitLevel(target) == -1 or boss.BossIDs[UnitID(target)] then return true end
    return false
end)

ProbablyEngine.condition.register("NePinfront", function(target, spell)
	return NeP.Lib.Infront('player', target)
end)

function NeP.Core.dynamicEval(condition, spell)
	if not condition then return false end
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

function NeP.Lib.SAoE(units, distance)
	if _SAoE_Time == nil or _SAoE_Time + 0.5 <= GetTime() then
		_SAoE_Time = nil
		UnitsTotal = 0
		if NeP.Core.PeConfig.read('button_states', 'multitarget', false) then
			UnitsTotal = UnitsTotal + 99
		elseif NeP.Core.PeConfig.read('button_states', 'NeP_SAoE', false) then
			for i=1,#NeP.ObjectManager.unitCache do
				local object = NeP.ObjectManager.unitCache[i]
				if object.distance <= distance then
					UnitsTotal = UnitsTotal + 1
				end
			end
		end
		_SAoE_Time = GetTime()
		return UnitsTotal >= units
	end
	return UnitsTotal >= units 
end

--[[-----------------------------------------------
** Distance **
DESC: Sometimes PE's behaves badly,
So here we go...

Build By: MTS
---------------------------------------------------]]
local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function NeP.Lib.Distance(a, b)
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

function NeP.Lib.LineOfSight(a, b)
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
		if TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags) then return false end
		return true
	end
end

function NeP.Lib.Infront(a, b)
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

function NeP.Lib.canTaunt()
	if NeP.Core.PeFetch('npconf', 'Taunts') then
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i].key
			if UnitIsTappedByPlayer(object) and object.distance <= 40 then
				if UnitThreatSituation(object) and UnitThreatSituation(object) >= 2 then
					if NeP.Lib.Infront('player', object) then
						ProbablyEngine.dsl.parsedTarget = object
						return true 
					end
				end
			end
		end
	end
	return false
end

function NeP.Lib.Dispell(dispelTypes)
	local blacklistedDebuffs = {
		'Mark of Arrogance',
		'Displaced Energy'
	}
	if NeP.Core.PeFetch('npconf', 'Dispell') then
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
function NeP.Lib.AutoDots(_spell, _health, _duration, _distance, _classification)
	if _classification == nil then _classification = 'all' end
	if _distance == nil then _distance = 40 end
	if _health == nil then _health = 100 end
	if _duration == nil then _duration = 0 end
	for i=1,#NeP.ObjectManager.unitCache do
		local _object = NeP.ObjectManager.unitCache[i]
		if _lastDotted == _object then return false end
		if UnitClassification(_object) == _classification or _classification == 'all' then
			if _object.health <= _health then
				local _,_,_,_,_,_,debuff = UnitDebuff(_object.key, GetSpellInfo(_spell), nil, "PLAYER")
				if not debuff or debuff - GetTime() < _duration then
					if UnitCanAttack("player", _object.key)
					and _object.distance <= _distance then
						if NeP.Lib.Infront('player', _object.key) then
							ProbablyEngine.dsl.parsedTarget = _object.key
							_lastDotted = _object.key
							return true
						end					 
					end
				end
			end
		end
	end
	return false
end