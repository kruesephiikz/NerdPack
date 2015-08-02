NeP.Lib.Monk = {}

function NeP.Lib.Monk.SEF()
	for i=1,#NeP.ObjectManager.unitCache do
		local object = NeP.ObjectManager.unitCache[i]
		if UnitGUID('target') ~= UnitGUID(object.key) 
		and IsSpellInRange(GetSpellInfo(137639), object.key) then
		local _,_,_,_,_,_,debuff = UnitDebuff(object.key, GetSpellInfo(137639), nil, "PLAYER")
			if not debuff and NeP.Core.dynamicEval("!player.buff(137639).count = 2") then
				if NeP.Lib.Infront(object.key) then
					ProbablyEngine.dsl.parsedTarget = object.key
					return true 
				end
			end
		end
	end
	return false
end