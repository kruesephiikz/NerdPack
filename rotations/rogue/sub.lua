local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
	'MfD', 
	'Interface\\Icons\\Ability_hunter_assassinate.png', 
	'Marked for Death', 
	'Use Marked for Death \nBest used for targets that will die under a minute.')
end

local Cooldowns = {
	{"Shadow Reflection"},
	{"Preparation", "player.spell(Vanish).cooldown <= 0"},
	{"Shadow Dance", "player.energy > 75"},
	{"Vanish", "player.spell(Premeditation).cooldown <= 0"},
}

local AoE = {
	{"Slice and Dice", { -- Slice and Dice // Refresh
		"player.buff(Slice and Dice).duration <= 3",
		"player.combopoints >= 3"
	}},
	{"Crimson Tempest", "player.combopoints >= 5"}, -- Crimson Tempest // DUMP CP
	{"Hemorrhage", "target.debuff(Hemorrhage).duration <= 7"}, -- Hemorrhage to apply dot
	{"Ambush"},
	{"Fan of Knives"},
}

local ST = {
	-- Slice and Dice // Refresh
	{"Slice and Dice", {
		"player.buff(Slice and Dice).duration <= 3",
		"player.combopoints <= 2"
	}},
	-- Rupture to apply dot
	{"Rupture", {
		"player.combopoints >= 5",
		"target.debuff(Rupture).duration <= 7"
	}},
	-- Eviscerate // Dump CP
	{"Eviscerate", {
		"player.combopoints >= 5",
	}},
	-- Hemorrhage to apply dot
	{"Hemorrhage", {
		"target.debuff(Hemorrhage).duration <= 7",
	}},
	{"Ambush"},
	{"Backstab", "player.behind"},
}

local outCombat = {
	-- Auto Attack after vanish
	{"Ambush", {
		"target.alive",
		"lastcast(Vanish)",
		"player.health > 15"
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

ProbablyEngine.rotation.register_custom(261, NeP.Core.GetCrInfo('Rogue - Subtlety'), 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ "Kick" },
			}, "target.NePinterrupt" },
			{"Recuperate",{
				"player.combopoints <= 3",
				"player.health < 35",
				"player.buff(Recuperate).duration <= 5"
			}},
			{"Marked for Death", {
				"player.combopoints = 0",
				"toggle.MfD"
			}},
			{"Premeditation", "player.buff(Vanish)"},
			{"Premeditation", "player.buff(Shadow Dance)"},
			{"Tricks of the Trade", "player.aggro > 60", "tank"},
			{"Evasion", "player.health < 30"},
			{Cooldowns, "modifier.cooldowns" },
			{AoE, (function() return NeP.Lib.SAoE(3, 10) end) },
			{ST, "!modifier.multitarget" },
		}, {"!player.buff(Vanish)", "target.range < 7"} },
	}, outCombat, exeOnLoad)