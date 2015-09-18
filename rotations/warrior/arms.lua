local dynEval = NeP.Core.dynamicEval
local PeFetch = NeP.Core.PeFetch

local GUI_WarrArms = {
	key = "NePConfigWarrArms",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Warrior Arms Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ 
			type = 'header',
			text = "General settings:", 
			align = "center" 
		},

			-- NOTHING IN HERE YET...

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},
			{
				type = "spinner",
				text = "Healthstone - HP",
				key = "Healthstone",
				width = 50,
				min = 0,
				max = 100,
				default = 75,
				step = 5
			},

	}
}

NeP.Interface.classGUIs[71] = GUI_WarrArms

local exeOnLoad = function()
	NeP.Splash()
end

local inCombat_Defensive = {
	--[[ To be done... ]]
}

local inCombat_Battle = {
	--[[ To be done... ]]
}

local AoE = {
	{ "Thunder Clap" },
}

local Survival = {
  	{ "#5512", (function() return dynEval("player.health <= " .. PeFetch('NePConfigWarrArms', 'Healthstone')) end) }, --Healthstone
}

local Cooldowns = {
	--[[ To be done... ]]
}

ProbablyEngine.rotation.register_custom(71, NeP.Core.GetCrInfo('Warrior - Arms'), 
	{-- In-Combat CR
		
		{{-- Interrupts
			{ "6552" }, -- Pummel
	  	}, "target.NePinterrupt" },
		
  		{ Survival },
  		{ Cooldowns, "modifier.cooldowns" },
  		{ AoE, (function() return NeP.Lib.SAoE(3, 40) end) },
		
		{ inCombat_Battle, "player.stance = 1" },
		{ inCombat_Defensive, "player.stance = 2" },
		
		{ "57755", "player.range > 10", "target" } -- Heroic Throw

	},
	{-- Out-Combat CR
		
		--[[ To be done... ]]
		
	}, exeOnLoad)