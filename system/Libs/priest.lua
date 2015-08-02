NeP.Lib.Priest = {}

--[[-----------------------------------------------
** Priest - Prayer of Healing **
DESC: Uses Unit cache to verify if enough people need healing
and are in range of Holy Nova.

Build By: Mirakuru
Modified by: MTS
---------------------------------------------------]]
function NeP.Lib.Priest.holyNova()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
		local object = NeP.ObjectManager.unitFriendlyCache[i]
		local healthMissing = max(0, object.maxHealth - object.actualHealth)
			if healthMissing > minHeal and UnitIsFriend("player", object.key) then
				if object.distance <= 12 then
				total = total + 1
				end
			end
		end
	return total > 3
end

--[[-----------------------------------------------
** Priest - Prayer of Healing **
DESC: Checks if a party group needs to be healed.
Bugs: Counts dead people's health.

Build By: woe
---------------------------------------------------]]
function NeP.Lib.Priest.PoH()
	local minHeal = GetSpellBonusDamage(2) * 2.21664
	local GetRaidRosterInfo, min, subgroups, member = GetRaidRosterInfo, math.min, {}, {}
	local lowest, lowestHP, _, subgroup = false, 0
	local start, groupMembers = 0, GetNumGroupMembers()
		if IsInRaid() then
			start = 1
		elseif groupMembers > 0 then
			groupMembers = groupMembers - 1
		end
		for i = start, groupMembers do
			local _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			if not subgroups[subgroup] then
				subgroups[subgroup] = 0
				member[subgroup] = ProbablyEngine.raid.roster[i].unit
			end
				subgroups[subgroup] = subgroups[subgroup] + min(minHeal, ProbablyEngine.raid.roster[i].healthMissing)
		end
			for i = 1, #subgroups do
				if subgroups[i] > minHeal * 4 and subgroups[i] > lowestHP then
				lowest = i
				lowestHP = subgroups[i]
				end
			end
			if lowest then
				ProbablyEngine.dsl.parsedTarget = member[lowest]
			return true
		end
	return false
end

--[[-----------------------------------------------
** Mass Dispel **
DESC: Checks if units around player needs to be dispelled.

Build By: MTS
---------------------------------------------------]]
function NeP.Lib.Priest.MassDispell()
	local prefix = (IsInRaid() and 'raid') or 'party'
	local total = 0        
	for i = -1, GetNumGroupMembers() - 1 do
		local unit = (i == -1 and 'target') or (i == 0 and 'player') or prefix .. i
			if IsSpellInRange('Mass Dispell', unit) then
				for j = 1, 40 do
					local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_, _,_,_ = UnitDebuff(unit, j)
					if dispelType and dispelType == 'Magic' or dispelType == 'Disease' then
						if NeP.Lib.Distance('player', unit) then
							total = total + 1
						end
					end
					if total >= 5 then
						NeP.Core.Print("Mass Dispelled: "..debuffName.." on: "..unit.." total units:"..total)
						ProbablyEngine.dsl.parsedTarget = unit
						return true
					end
				end
			end
		end
	return false
end

--[[-----------------------------------------------
** Power word Barrier **
DESC: Checks if units around tank have enough missing heal to use this.

Build By: MTS
---------------------------------------------------]]
function NeP.Lib.Priest.PWBarrier()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
	for i=1,#NeP.ObjectManager.unitFriendlyCache do
		local object = NeP.ObjectManager.unitFriendlyCache[i]
		local healthMissing = max(0, object.maxHealth - object.actualHealth)
		if healthMissing > minHeal 
		and UnitIsFriend("player", object.key) then
			if NeP.Lib.Distance("focus", object.key) <= 12 then
				total = total + 1
			end
		end
	end
	return total > 3
end

-- Clarity of Purpose
function NeP.Lib.Priest.ClarityOfPurpose()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
	for i=1,#NeP.ObjectManager.unitFriendlyCache do
		local object = NeP.ObjectManager.unitFriendlyCache[i]
		local healthMissing = max(0, object.maxHealth - object.actualHealth)
		if healthMissing > minHeal 
		and UnitIsFriend("player", object.key) then
			if object.distance <= 10 then
				total = total + 1
			end
		end
	end
	return total > 3
end