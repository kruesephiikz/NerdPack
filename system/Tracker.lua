local NeP_inWorld = false
local NeP_SoothingMist_Target = nil

function NeP_soothingMist(ht)
	if NeP_SoothingMist_Target ~= nil then
		local health = math.floor((UnitHealth(NeP_SoothingMist_Target) / UnitHealthMax(NeP_SoothingMist_Target)) * 100)
			if health >= ht then
				return true
			end
	end
	return false
end

ProbablyEngine.listener.register("PLAYER_ENTERING_WORLD", function(...)
	--(WORKAROUND) // Create Keys // Open
	NeP.Addon.Interface.ConfigGUI()
	NeP.Addon.Interface.ClassGUI()
	NeP.Addon.Interface.CacheGUI()
	NeP.Addon.Interface.OverlaysGUI()
	--(WORKAROUND) // Create Keys // Close
	NeP.Addon.Interface.ConfigGUI()
	NeP.Addon.Interface.ClassGUI()
	NeP.Addon.Interface.CacheGUI()
	NeP.Addon.Interface.OverlaysGUI()
    -- This is used to only do/load stuff once inside the world
	NeP_inWorld = true
end)

ProbablyEngine.listener.register("ACTIVE_TALENT_GROUP_CHANGED", function(...)
    	if NeP_inWorld then
			-- Open & Close class config to avoid nil keys
			NeP.Addon.Interface.ClassGUI()
			NeP.Addon.Interface.ClassGUI()
        end
end)

ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
  	local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = ...
  	if event == "SPELL_CAST_SUCCESS" then
		if sourceGUID == UnitGUID("player") then
			-- Monk MW // Soothing Mist
			if spellID == 115175 then
				NeP_SoothingMist_Target = targetName
			end
		end
  	end
end)

ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
	if NeP.Core.PeFetch('npconf', 'AutoLFG') then
		AcceptProposal()
	end
end)