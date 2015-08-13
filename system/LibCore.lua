--[[
	This is a Lib containing shared conditions
	Across all Scripts.
]]
NeP.Lib = {}

local _parse = ProbablyEngine.dsl.parse

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