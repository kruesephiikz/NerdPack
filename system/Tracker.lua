ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
	if NeP.Core.PeFetch('NePConf', 'AutoLFG') then
		AcceptProposal()
	end
end)