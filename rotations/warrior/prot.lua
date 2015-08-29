NeP.Interface.WarrProt = {
	key = "NePConfigWarrProt",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Warrior Protection Settings",
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
			
			-- Survival Settings:
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
			{
				type = "spinner",
				text = "Rallying Cry - HP",
				key = "RallyingCry",
				width = 50,
				min = 0,
				max = 100,
				default = 10,
				step = 5
			},
			{
				type = "spinner",
				text = "Last Stand - HP",
				key = "LastStand",
				width = 50,
				min = 0,
				max = 100,
				default = 20,
				step = 5
			},
			{
				type = "spinner",
				text = "Shield Wall - HP",
				key = "ShieldWall",
				width = 50,
				min = 0,
				max = 100,
				default = 30,
				step = 5
			},
			{
				type = "spinner",
				text = "Shield Barrier - Rage",
				key = "ShieldBarrier",
				width = 50,
				min = 0,
				max = 100,
				default = 80,
				step = 5
			},

	}
}

local Battle_Print = false

local exeOnLoad = function()
	NeP.Splash()
end

local inCombat_Defensive = {

	-- Rotation normal
		{ "Heroic Strike", {
			"player.rage > 75", 
			"target.health >=20"
		}, "target"},
		{ "Execute", {
			"player.rage > 75", 
			"target.health <=20"
		}, "target"},
		{ "Shield Slam"},
		{ "Revenge"},
		{ "Devastate"},
		{ "Thunder Clap", "target.debuff(Deep Wounds).duration < 2" },
		
}

local inCombat_Gladiator = {

	{ "Shield Charge", "!player.buff(Shield Charge)" },
	{ "Shield Charge", "spell(Shield Charge).charges >= 2" },
	{ "Heroic Strike", "player.buff(Shield Charge)" },
	{ "Heroic Strike", "player.buff(Ultimatum)" },
	{ "Heroic Strike", "player.rage >= 95" },
	{ "Shield Slam" },
	{ "Revenge" },
	{ "Execute" },
	{ "Devastate" }

}

local inCombat_Battle = {

	{ "/run print('[MTS] This stance is not yet supported! :(')", 
		(function() 
			if Battle_Print == false then 
				Battle_Print = true 
				return true 
			end
			return false
		end)
	},
	{"71", {
		"player.stance != 2",
		(function() 
			Battle_Print = false 
			return true
		end)
	} },

}

local AoE = {
	
	{ "Thunder Clap" },

}

local Survival = {
	
	-- Def Cooldowns
  	{ "Rallying Cry", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrProt', 'RallyingCry')) end) },  
  	{ "Last Stand", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrProt', 'LastStand')) end) },
  	{ "Shield Wall", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrProt', 'ShieldWall')) end) },
  	{ "Shield Block", "!player.buff(Shield Block)" },
  	{ "Shield Barrier", { 
  		"!player.buff(Shield Barrier)",
  		(function() return NeP.Core.dynamicEval("player.rage <= " .. NeP.Core.PeFetch('NePConfigWarrProt', 'ShieldBarrier')) end)
  	}},

  	-- Self Heals
  	{ "Impending Victory", "player.health <= 85" },
  	{ "Victory Rush", "player.health <= 85" },
  	{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrProt', 'Healthstone')) end) }, --Healthstone

}

local Cooldowns = {
	
	{ "Bloodbath" },
  	{ "Avatar" },
  	{ "Recklessness", "target.range <= 8" },
  	{ "Skull Banner" },
  	{ "Bladestorm", "target.range <= 8" },
  	{ "Berserker Rage" },
  	{ "#gloves" },

}

ProbablyEngine.rotation.register_custom(73, NeP.Core.GetCrInfo('Warrior - Protection'), 
	{-- In-Combat CR
		{ "Battle Shout", {
			"!player.buffs.attackpower",
			"player.buff(156291)" -- Gladiator
		}},
		{ "Commanding Shout", {
			"!player.buffs.stamina",
			"!player.buff(156291)" -- Gladiator
		}},
		{ "6544", "modifier.shift", "ground" }, -- Heroic Leap
  		{ "5246", "modifier.control" }, -- Intimidating Shout
		{ "100", {  -- Charge
			"modifier.alt", 
			"target.spell(100).range" 
		}, "target"},
		{{-- Interrupts
			{ "6552" }, -- Pummel
	  		{ "Disrupting Shout", "target.range <= 8", "target" },
	  		{ "114028" }, -- Mass Spell Reflection
	  	}, "target.NePinterrupt" },
  		{ "Will of the Forsaken", "player.state.fear" },
  		{ "Will of the Forsaken", "player.state.charm" },
  		{ "Will of the Forsaken", "player.state.sleep" },
		{ "Heroic Strike", "player.buff(Ultimatum)", "target" },
  		{ "Shield Slam", "player.buff(Sword and Board)", "target" },
  		{ Survival },
  		{ Cooldowns, "modifier.cooldowns" },
  		{ AoE, (function() return NeP.Lib.SAoE(3, 40) end) },
		{{ -- Stance 1
			{ inCombat_Gladiator, "talent(7,3)" },
			{ inCombat_Battle, "!talent(7,3)" },
		}, "player.stance = 1" },
		{ inCombat_Defensive, "player.stance = 2" },
		{ "57755", "player.range > 10", "target" } -- Heroic Throw
	},
	{-- Out-Combat CR
		{ "Battle Shout", {
			"!player.buffs.attackpower",
			"player.buff(156291)" -- Gladiator
		}},
		{ "Commanding Shout", {
			"!player.buffs.stamina",
			"!player.buff(156291)" -- Gladiator
		}},
		{ "6544", "modifier.shift", "ground" }, -- Heroic Leap
  		{ "5246", "modifier.control" }, -- Intimidating Shout
		{ "100", { -- Charge
			"modifier.alt", 
			"target.spell(100).range" 
		}, "target"}, 
	}, exeOnLoad)