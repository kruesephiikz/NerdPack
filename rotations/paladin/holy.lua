local lib = function()
	NeP.Splash()
end

local _All = {
	-- keybinds
	{ "114158", "modifier.shift", "target.ground"}, -- Light´s Hammer
	{ "!/focus [target=mouseover]", "modifier.alt" }, -- Mouseover Focus
	-- Hand of Freedom
	{ "1044", "player.state.root" },
	-- Buffs
	{ "20217", { -- Blessing of Kings
		"!player.buffs.stats",
		(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Kings' end),
	}, nil },
	{ "19740", { -- Blessing of Might
		"!player.buffs.mastery",
		(function() return NeP.Core.PeFetch("npconfPalaHoly", "Buff") == 'Might' end),
	}, nil }, 
	
	-- Seals
	{ "20165", { -- seal of Insigh
		"player.seal != 2", 
		(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Insight' end),
	}, nil }, 
	{ "105361", { -- seal of Command
		"player.seal != 1",
		(function() return NeP.Core.PeFetch("npconfPalaHoly", "seal") == 'Command' end),
	}, nil },
}

local _AoE = {
	{{-- AoE
		-- Light of Dawn
		{ "85222", { -- Party
			"@coreHealing.needsHealing(90, 3)", 
			"player.holypower >= 3",
			"modifier.party" 
		}},
		{ "85222", { -- Raid
			"@coreHealing.needsHealing(90, 5)", 
			"player.holypower >= 3", 
			"modifier.raid", 
		}},
		-- Holy Radiance 
		{ "82327", { -- Holy Radiance - Party
			"@coreHealing.needsHealing(80, 3)", 
			"!player.moving", 
			"modifier.party" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance - Raid
			"@coreHealing.needsHealing(90, 5)", 
			"!player.moving", 
			"modifier.raid", 
		}, "lowest" },  
	}, "modifier.multitarget" },
}

local _InfusionOfLight = {
	{{-- AoE
		{ "82327", { -- Holy Radiance - Party
			"@coreHealing.needsHealing(80, 3)", 
			"!player.moving"
		}, "lowest" }, 
	}, "modifier.multitarget" }, 
	{ "82326", { -- Holy Light
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightIL')) end),
		"!player.moving" 
	}, "lowest" },
}

local _Fast = {
	{ "!633", "lowest.health <= 15", "lowest" }, -- Lay on Hands
	{ "!19750", { -- Flash of Light
		"lowest.health <= 30", 
		"!player.moving" 
	}, "lowest" },
}

local _Tank = {
	{ "633", { -- Lay on Hands
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHandsTank')) end),
		"tank.spell(633).range"
	}, "tank" },
	{ "53563", { -- Beacon of light
		"!tank.buff(53563)", -- Beacon of light
		"!tank.buff(156910)", -- Beacon of Faith
		"tank.spell(53563).range" 
	}, "tank" },
	{ "6940", { -- Hand of Sacrifice
		"tank.spell(6940).range",
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HandofSacrifice')) end)
	}, "tank" }, 
	{ "19750", { -- Flash of Light
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightTank')) end), 
		"!player.moving",
		"tank.spell(19750).range"
	}, "tank" },
	{ "114157", { -- Execution Sentence // Talent
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentenceTank')) end),
		"tank.spell(114157).range"
	}, "tank" },
	{ "148039", { -- Sacred Shield // Talent
		"player.spell(148039).charges >= 1", 
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShieldTank')) end), 
		"!tank.buff(148039)", -- SS
		"tank.range < 40" 
	}, "tank" },
	{ "114163", { -- Eternal Flame // talent
			"player.holypower >= 3", 
		"!tank.buff(114163)",
		"focus.spell(114163).range",
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameTank')) end)
	}, "tank" },
	{ "85673", { -- Word of Glory
		"player.holypower >= 3",
		"focus.spell(85673).range",
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryTank')) end)
	}, "tank"  },
	{ "114165", { -- Holy Prism // Talent
		(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrismTank')) end), 
		"!player.moving",
		"tank.spell(114165).range" 
	}, "tank"},
	{ "82326", { -- Holy Light
		(function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightTank')) end),
		"!player.moving",
		"focus.spell(82326).range" 
	}, "tank" },
}

local _Focus = {
	{ "633", { -- Lay on Hands
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHandsTank')) end),
		"focus.spell(633).range"
	}, "focus" }, 
	{ "6940", { -- Hand of Sacrifice
		"focus.spell(6940).range",
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HandofSacrifice')) end)
	}, "focus" },
	{ "19750", { -- Flash of Light
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightTank')) end), 
		"!player.moving",
		"focus.spell(19750).range"
	}, "focus" },
	{ "114157", { -- Execution Sentence // Talent
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentenceTank')) end),
		"focus.spell(114157).range"
	}, "focus" },
	{ "148039", { -- Sacred Shield // Talent
		"player.spell(148039).charges >= 1", 
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShieldTank')) end), 
		"!focus.buff(148039)", 
		"focus.range < 40" 
	}, "focus" },
	{ "114163", { -- Eternal Flame // talent
		"player.holypower >= 3", 
		"!focus.buff(114163)",
		"focus.spell(114163).range",
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameTank')) end)
	}, "focus" },
	{ "85673", { -- Word of Glory
		"player.holypower >= 3",
		"focus.spell(85673).range",
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryTank')) end) 
	}, "focus" },
	{ "114165", { -- Holy Prism // Talent
		"player.holypower >= 3",
		(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrismTank')) end), 
		"!player.moving",
		"focus.spell(114165).range" 
	}, "focus"},
	{ "82326", { -- Holy Light
		(function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightTank')) end),
		"!player.moving",
		"focus.spell(82326).range" 
	}, "focus" },
}

local _Player = {
	-- Items
	{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Healthstone')) end), nil }, -- Healthstone
	{ "#trinket1", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Trinket1')) end), nil }, -- Trinket 1
	{ "#trinket2", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'Trinket2')) end), nil }, -- Trinket 2
	{{-- Beacon of Faith
		{ "156910", {
			"!player.buff(53563)", -- Beacon of light
			"!player.buff(156910)" -- Beacon of Faith
		}, "player" },
	}, "talent(7,1)" },
	{ "498", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'DivineProtection')) end), nil }, -- Divine Protection
	{ "642", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'DivineShield')) end), nil }, -- Divine Shield
	{ "148039", { -- Sacred Shield // Talent
		"player.spell(148039).charges >= 2", 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShield')) end), 
		"!player.buff(148039)" 
	}, "player" },
}

local _Cooldowns = {
	{ "#gloves" }, -- gloves
	{ "31821", "@coreHealing.needsHealing(40, 5)", nil }, -- Devotion Aura	
	{ "31884", "@coreHealing.needsHealing(95, 4)", nil }, -- Avenging Wrath
	{ "86669", "@coreHealing.needsHealing(85, 4)", nil }, -- Guardian of Ancient Kings
	{ "31842", "@coreHealing.needsHealing(90, 4)", nil }, -- Divine Favor
	{ "105809", "talent(5, 1)", nil }, -- Holy Avenger
}

local inCombat = {
	{{-- Interrupts
		{ "96231", "target.range <= 6", "target" },-- Rebuke
	}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
	{ "35395", { -- Crusader Strike
		"target.range < 5",
		"target.infront",
		(function() return NeP.Core.PeFetch('npconfPalaHoly', 'CrusaderStrike') end) 
	}, "target" },
}

local _BeaconOfInsight = {
	{ "157007", nil, "lowest" },
	{ "19750", { -- flash of light
		"lowest.health <= 40", 
		"!player.moving" 
	}, "lowest" },
	{ "82326", { -- Holy Light
		"lowest.health < 80",
		"!player.moving" 
	}, "lowest" },
}

local _DivinePurpose = {
	{ "85222", { -- Light of Dawn
		"@coreHealing.needsHealing(90, 3)", 
		"player.holypower >= 1",
		"modifier.party" 
	}},
	{ "85673", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGloryDP')) end), "lowest"  }, -- Word of Glory
	{ "114163", { -- Eternal Flame
		"!lowest.buff(114163)", 
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlameDP')) end) 
	}, "lowest" },
}

local _SelflessHealer = {
	{ "20271", "target.spell(20271).range", "target" }, -- Judgment
	{{ -- If got buff
		{ "19750", { -- Flash of light
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLightSH')) end),  
			"!player.moving" 
		}, "lowest" }, 
	}, "player.buff(114250).count = 3" }
}

local _Raid = {
	-- Lay on Hands
	{ "633", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'LayonHands')) end), "lowest" }, 
	{ "19750", { -- Flash of Light
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'FlashofLight')) end), 
		"!player.moving" 
	}, "lowest" },
	-- Execution Sentence // Talent
	{ "114157", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'ExecutionSentence')) end), "lowest" },
	{ "148039", { -- Sacred Shield // Talent
		"player.spell(148039).charges >= 2", 
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'SacredShield')) end), 
		"!lowest.buff(148039)" 
	}, "lowest" },
	{ "114163", { -- Eternal Flame // talent
		"player.holypower >= 1", 
		"!lowest.buff(114163)", 
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'EternalFlame')) end)
	}, "lowest" },
	{ "85673", { -- Word of Glory
		"player.holypower >= 3", 
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'WordofGlory')) end)
	}, "lowest"  },
	{ "114165", { -- Holy Prism // Talent
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyPrism')) end), 
		"!player.moving" 
	}, "lowest"},
	{ "82326", { -- Holy Light
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLight')) end),
		"!player.moving" 
	}, "lowest" },
}

local outCombat = {
	-- Start
	{ "20473", "lowest.health < 100", "lowest" }, -- Holy Shock
	{{-- AoE
		-- Light of Dawn
		{ "85222", { -- Party
			"@coreHealing.needsHealing(90, 3)", 
			"player.holypower >= 3",
			"modifier.party" 
		}},
		{ "85222", { -- Raid
			"@coreHealing.needsHealing(90, 5)", 
			"player.holypower >= 3", 
			"modifier.raid", 
			"!modifier.raid" 
		}}, 
		-- Holy Radiance 
		{ "82327", { -- Holy Radiance - Party
			"@coreHealing.needsHealing(80, 3)", 
			"!player.moving", 
			"modifier.party" 
		}, "lowest" }, 
		{ "82327", { -- Holy Radiance - Raid
			"@coreHealing.needsHealing(90, 5)",  
			"!player.moving", 
			"modifier.raid", 
		}, "lowest" },
	}, "modifier.multitarget" },
	-- Holy Light
	{ "82326", { 
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfPalaHoly', 'HolyLightOCC')) end),
		"!player.moving" 
	}, "lowest" },
}

ProbablyEngine.rotation.register_custom(65, NeP.Core.GetCrInfo('Paladin - Holy'), 
	{ -- In-Combat
		{_All},
		{{ -- Dispell all?
			{ "4987", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Posion' or dispelType == 'Disease' end) end) },-- Dispel Everything
		}, (function() return NeP.Core.PeFetch('npconf','Dispell') end) },
		-- Holy Shock
		{ "20473", "lowest.health < 100", "lowest" }, 
		{_Fast},
		{inCombat},
		{_BeaconOfInsight, "talent(7,2)"},
		{_InfusionOfLight, "player.buff(54149)"},
		{_DivinePurpose, "player.buff(86172)"},
		{_SelflessHealer, "talent(3, 1)"},
		{_Cooldowns, "modifier.cooldowns"},
		{_AoE},
		{_Tank},
		{_Focus},
		{_Player},
		{_Raid}
	},{ -- Out-Combat
		{_All},
		{outCombat}
	}, lib)