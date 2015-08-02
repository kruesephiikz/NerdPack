

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'MfD', 
		'Interface\\Icons\\Ability_hunter_assassinate.png', 
		'Marked for Death', 
		'Use Marked for Death \nBest used for targets that will die under a minute.')
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (SOLO)', 
		'Click here to dot all the things while in single target.')
end

local Cooldowns = {
	{ "Vanish" },
	{ "Shadow Reflection" },
	{ "Preparation", "player.spell(Vanish).cooldown >= 10" },
	{ "Vendetta", "!player.moving" },
}

local inCombat = {
	{{-- Auto Dotting
		{"Rupture", {
			"player.combopoints >= 5",
			(function() return NeP.Lib.AutoDots('Rupture', 7, 100) end)
		}, "target" },
	}, "toggle.dotEverything" },
	{"Rupture", {
		"player.combopoints >= 5",
		"target.debuff(Rupture).duration <= 7"
	}, "target" },
	{"Envenom", "player.combopoints >= 5", "target" },
	{"Dispatch", "target.health <= 35", "target" },
	{"Dispatch", "player.buff(Blindside)", "target" },
	
	-- SAoE
	{"Fan of Knives", "player.area(10).enemies > 3"},
	
	-- Force AoE
	{"Fan of Knives", "modifier.multitarget"},
	
	{{-- ST
		{"Mutilate", "target.health >= 35", "target" },
	}, {"!modifier.multitarget", "!player.area(10).enemies > 3"} },
}

local outCombat = {
	-- Auto Attack after vanish
	{"Ambush", {
		"target.alive",
		"lastcast(Vanish)"
	}, "target" },

	-- Poison
		-- Letal
		{"Deadly Poison", {
			"!lastcast(Deadly Poison)",
			"!player.buff(Deadly Poison)"
		}},
		-- Non-Letal
		{"Crippling Poison", {
			"!lastcast(Crippling Poison)",
			"!player.buff(Crippling Poison)"
		}},
}

ProbablyEngine.rotation.register_custom(259, NeP.Core.CrInfo(), 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ "Kick" },
			}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
			{"Recuperate",{
				"player.combopoints <= 3",
				"player.health < 35",
				"player.buff(Recuperate).duration <= 5"
			}},
			{"Marked for Death", {
				"player.combopoints = 0",
				"toggle.MfD"
			}},
			{"Tricks of the Trade", "player.aggro > 60", "tank"},
			{"Evasion", "player.health < 30"},
			{Cooldowns, "modifier.cooldowns" },
			{inCombat},
		}, {"!player.buff(Vanish)", "target.range < 7"} },
	}, outCombat, exeOnLoad)