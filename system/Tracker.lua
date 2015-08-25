local NeP_inWorld = false

ProbablyEngine.listener.register("PLAYER_ENTERING_WORLD", function(...)
	--(WORKAROUND) // Create Keys // Open
	NeP.Interface.ConfigGUI()
	NeP.Interface.ClassGUI()
	NeP.Interface.CacheGUI()
	NeP.Interface.OverlaysGUI()
	--(WORKAROUND) // Create Keys // Close
	NeP.Interface.ConfigGUI()
	NeP.Interface.ClassGUI()
	NeP.Interface.CacheGUI()
	NeP.Interface.OverlaysGUI()
    -- This is used to only do/load stuff once inside the world
	NeP_inWorld = true
end)

ProbablyEngine.listener.register("ACTIVE_TALENT_GROUP_CHANGED", function(...)
    	if NeP_inWorld then
			-- Open & Close class config to avoid nil keys
			NeP.Interface.ClassGUI()
			NeP.Interface.ClassGUI()
        end
end)

ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
	if NeP.Core.PeFetch('npconf', 'AutoLFG') then
		AcceptProposal()
	end
end)