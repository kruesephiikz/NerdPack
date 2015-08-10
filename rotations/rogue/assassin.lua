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
		'Dot All The Things!', 
		'Click here to dot all the things.')
end

local Cooldowns = {
	{ "1856", "player.energy >= 60" }, -- Vanish
	{ "Shadow Reflection" }, -- Shadow Reflection // TALENT (FIXME: ID)
	{ "14185", "player.spell(1856).cooldown >= 10" }, -- Preparation
	{ "79140", "!player.moving" }, -- Vendetta
}

local Survival = {
	{ "73651", { -- Recuperate
		"player.combopoints <= 3",
		"player.health < 35",
		"player.buff(73651).duration <= 5"
	}},
	{ "5277", "player.health < 30" }, -- Evasion
	{ "57934", "player.aggro > 60", "tank"}, -- Tricks of the Trade
	{ "57934", "player.aggro > 60", "focus"}, -- Tricks of the Trade
}

local inCombat = {
	{"137619", { -- Marked for Death
		"player.combopoints = 0",
		"toggle.MfD"
	}},
	{{-- Auto Dotting
		{"1943", { -- Rupture
			"player.combopoints >= 5",
			(function() return NeP.Lib.AutoDots('1943', 100, 7, 5) end)
		}, "target" },
	}, "toggle.dotEverything" },
	{{ -- Toggle off
		{"1943", { -- Rupture
			"player.combopoints >= 5",
			"target.debuff(1943).duration <= 7"
		}, "target" },
	}, "!toggle.dotEverything" },
	{ "32645", "player.combopoints >= 5", "target" }, -- Envenom
	{ "111240", "target.health <= 35", "target" }, -- Dispatch
	{ "111240", "player.buff(121153)", "target" }, -- Dispatch w/ Proc Blindside
	-- AoE
		{ "51723", (function() return NeP.Lib.SAoE(3, 10) end)}, -- Fan of Knives
	{ "1329", "target.health >= 35", "target" }, -- Mutilate
}

local outCombat = {
	-- Auto Attack after vanish
	{"8676", { -- Ambush
		"target.alive",
		"lastcast(1856)"
	}, "target" },

	-- Poison
		-- Letal
		{"2823", { -- Deadly Poison
			"!lastcast(2823)",
			"!player.buff(2823)"
		}},
		-- Non-Letal
		{"3408", { -- Crippling Poison
			"!lastcast(3408)",
			"!player.buff(3408)"
		}},
}

ProbablyEngine.rotation.register_custom(259, NeP.Core.GetCrInfo('Rogue - Assassination'), 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ "1766" }, -- Kick
			}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
			{Survival},
			{Cooldowns, "modifier.cooldowns" },
			{inCombat},
		}, { "!player.buff(1856)", "target.range < 7" } },
	}, outCombat, exeOnLoad)