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

ProbablyEngine.condition.register("inMelee", function(target)
   return NeP.Lib.getUnitRange(target, 'melee')
end)

ProbablyEngine.condition.register("inRanged", function(target)
   return NeP.Lib.getUnitRange(target, 'ranged')
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
		local stopAt = NeP.Core.PeFetch('NePConf', 'ItA') or 95
		local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
		return secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt
	end
	return false
end)

ProbablyEngine.condition.register("isBoss", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("isElite", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "elite" 
		or classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("NePinfront", function(target)
	return NeP.Core.Infront('player', target)
end)

ProbablyEngine.condition.register("castwithin", function(target, spell)
	local SpellID = select(7, GetSpellInfo(spell))
	for k, v in pairs( ProbablyEngine.actionLog.log ) do
		local id = select(7, GetSpellInfo(v.description))
		if (id and id == SpellID and v.event == "Spell Cast Succeed") or tonumber( k ) == 20 then
			return tonumber( k )
		end
	end
	return 20
end)

ProbablyEngine.condition.register("ShouldRess", function()
	for i=1,#NeP.OM.unitFriendDead do
		local Obj = NeP.OM.unitFriendDead[i]
		if Obj.distance <= 40 then
			if not UnitHasIncomingResurrection(Obj.key) then
				ProbablyEngine.dsl.parsedTarget = Obj.key
				return true
			end
		end
	end
end)