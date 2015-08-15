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
	return NeP.Core.Infront('player', target)
end)