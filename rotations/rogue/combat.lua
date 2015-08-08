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
		'Click here to dot all (Rupture) the things while in Single Target.')
end

local Cooldowns = {
	{ "Vanish" },
	{ "Preparation", "player.spell(Vanish).cooldown >= 10" },
	{ "Adrenaline Rush", "player.energy < 20" },
	{ "Killing Spree", {
		"player.energy < 20",
		"player.spell(Adrenaline Rush).cooldown >= 10"
	}},
}

local AoE = {
	{{-- Force
		{ "Blade Flurry" },
		{"Crimson Tempest", {
			"player.combopoints >= 5",
		}, "target"},
	}, "modifier.multitarget" },
	
	{ "Blade Flurry", "player.area(10).enemies > 1" },
	{"Crimson Tempest", {
		"player.combopoints >= 5",
		(function() return NeP.Lib.AutoDots('Crimson Tempest', 100, 7, 5) end),
		"player.area(10).enemies > 6"
	}},
}

local ST = {
	{{-- Auto Dotting
		{"Rupture", {
			"player.combopoints >= 5",
			(function() return NeP.Lib.AutoDots('Rupture', 100, 7, 5) end)
		}, "target" },
	}, "toggle.dotEverything" },
	{ "Ambush" },
	{ "Revealing Strike", "!target.debuff(Revealing Strike)", "target" },
	{ "Slice and Dice", {
		"!player.buff(Slice and Dice)",
		"player.combopoints < 4"
	}},
	{ "Eviscerate", "player.combopoints >= 5", "target" },
	{ "Sinister Strike" }
}

local outCombat = {
	-- Auto Attack after vanish
	{"Ambush", {
		"target.alive",
		"lastcast(Vanish)",
	}, "target" },

	-- Poison's
		-- Letal
		{"Instant Poison", {
			"!lastcast(Instant Poison)",
			"!player.buff(Instant Poison)"
		}},
		
		-- Non-Letal
		{"Crippling Poison", {
			"!lastcast(Crippling Poison)",
			"!player.buff(Crippling Poison)"
		}},
}

ProbablyEngine.rotation.register_custom(260, NeP.Core.GetCrInfo('Rogue - Combat'), 
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
			{AoE, "modifier.multitarget" },
			{ST},
		}, {"!player.buff(Vanish)", "target.range < 7"} },
	}, outCombat, exeOnLoad)