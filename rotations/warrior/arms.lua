local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[71] = {
	key = "NePConfigWarrArms",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Warrior Arms Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header',text = "General settings:", align = "center"},
			-- NOTHING IN HERE YET...

		{type = "spacer"},
		{type = 'rule'},
		{type = "header", text = "Survival Settings", align = "center"},
			{type = "spinner", text = "Healthstone", key = "Healthstone", width = 50, default = 75},

	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local Shared = {
	
}

local Keybinds = {
	
}

local Cooldowns = {
	
}

local Interrupts = {
	-- Pummel
	{"6552"},
}

local Survival = {
  	{"#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfigWarrArms', 'Healthstone')) end)}, --Healthstone
}

local AoE = {
	{'Bladestorm'},
	{'Dragon Roar'},
	{'Thunder Clap', 'player.glyph(Glyph of Resonating Power)'},
	{'Whirlwind'},
}

local inCombat_Defensive = {
	--If you have taken the Sudden Death talent, then Execute procs are your highest priority at all times.
	{'Execute', 'talent(3, 2)'},

	{'Rend', 'target.debuff(Rend).duration < 5'},
	{'Ravager'},
	{'Colossus Smash', 'player.rage > 60'},

	{{-- Execute (target bellow < 20)
		{'Execute', 'player.rage >= 80'},
		{'Storm Bolt'},
		{'Dragon Roar'},
	}, 'target.health <= 20' },

	{'Mortal Strike'},
	{'Storm Bolt', 'player.rage < 90'},
	{'Dragon Roar', 'player.rage < 90'},
	{'Thunder Clap', 'player.glyph(Glyph of Resonating Power)'},
	{'Whirlwind', 'player.rage > 40'}
}

local inCombat_Battle = {
	
}

local outCombat = {
	{Shared},
	{Keybinds}
}

ProbablyEngine.rotation.register_custom(71, NeP.Core.GetCrInfo('Warrior - Arms'), 
	{-- In-Combat CR
		{Shared},
		{Keybinds},
		{Interrupts, "target.NePinterrupt"},
		{Survival, 'player.health < 100'},
  		{Cooldowns, "modifier.cooldowns"},
  		{AoE, (function() return NeP.Core.SAoE(3, 40) end)},
		{inCombat_Battle, "player.stance = 1"},
		{inCombat_Defensive, "player.stance = 2"},
		{"57755", "player.range > 10", "target"} -- Heroic Throw
	}, outCombat, exeOnLoad)