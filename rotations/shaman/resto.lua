local exeOnLoad = function()
	NeP.Splash()
  	ProbablyEngine.toggle.create(
  		'dps', 
  		'Interface\\Icons\\Spell_shaman_stormearthfire.png‎', 
  		'Some DPS', 
  		'Do some damage while healing in party/raid.')
end	

local Cooldowns = {
   	{ "114052", { -- Ascendance
		"@coreHealing.needsHealing(65, 3)",
		"!player.totem(108280)" -- Stop if w/ Healing Tide Totem
	}},
	{ "108285", { -- Call of the Elements // TALENT (Reset Totem CD's)
		"talent(3,1)", 
		"@coreHealing.needsHealing(80, 3)", 
		"player.spell(5394).cooldown >= 10"
	}, "player" },
}

local Totems = {
	{{ -- Party

		-- Water
		{{ -- Dont break other Water Totems
			{{ -- Cooldowns
				{ "108280", { -- Healing Tide Totem
					"!player.buff(114052)", -- if wt/ Ascendance
					"@coreHealing.needsHealing(50, 3)"
				}},
			}, "modifier.cooldowns" },
			{"5394", "@coreHealing.needsHealing(85, 3)" }, -- Healing Stream Totem
			{"157153", "@coreHealing.needsHealing(85, 3)" },-- Cloudburst Totem // TALENT
		},{
			"!player.totem(5394)", -- Stop if w/ Healing Stream Totem
			"!player.totem(157153)", -- Stop if w/ Cloudburst Totem
			"!player.totem(108280)" -- Stop if w/ Healing Tide Totem
		}},
		
		-- Air
		{{ -- Dont Break other Air Totems!
			{{ -- Cooldowns
				{ "98008", "player.buff(114052)" }, -- Spirit Link Totem if w/ Ascendance
			}, "modifier.cooldowns" },
			{ "108273", "player.state.root" }, -- Windwalk Totem
			{ "108273", "player.state.snare" }, -- Windwalk Totem
		},{
			"!player.totem(98008)", -- Stop if w/ Spirit Link Totem
			"!player.totem(108273)" -- Stop if w/ Windwalk Totem
		}},

	},{
		"!modifier.members > 5",
		"modifier.party"
	}},
	{{ -- Raid
	
		-- Water
		{{ -- Dont break other Water Totems
			{{ -- Cooldowns
				{ "108280", { -- Healing Tide Totem
					"!player.buff(114052)", -- if wt/ Ascendance
					"@coreHealing.needsHealing(50, 6)"
				}},
			}, "modifier.cooldowns" },
			{"5394", "@coreHealing.needsHealing(85, 6)" }, -- Healing Stream Totem
			{"157153", "@coreHealing.needsHealing(85, 6)" }, -- Cloudburst Totem // TALENT
		},{
			"!player.totem(5394)", -- Stop if w/ Healing Stream Totem
			"!player.totem(157153)", -- Stop if w/ Cloudburst Totem
			"!player.totem(108280)" -- Stop if w/ Healing Tide Totem
		}},
		
		-- Air
		{{ -- Dont Break other Air Totems!
			{{ -- Cooldowns
				{ "98008", "player.buff(114052)" }, -- Spirit Link Totem if w/ Ascendance
			}, "modifier.cooldowns" },
			{ "108273", "player.state.root" }, -- Windwalk Totem
			{ "108273", "player.state.snare" }, -- Windwalk Totem
		},{
			"!player.totem(98008)", -- Stop if w/ Spirit Link Totem
			"!player.totem(108273)" -- Stop if w/ Windwalk Totem
		}},

	},{
		"modifier.members > 5",
		"!modifier.party"
	}},
	
	-- Earth
	{ "108270", { -- Stone Bulwark Totem
		"player.health <= 45",
		"talent(1,2)" 
	}},
}

local General = {

  	-- Keybinds
	{ "73920", { -- Healing Rain if not Ascendance // FIX ME: Automate this...
		"modifier.shift", 
		"!player.buff(114052)"
	}, "ground"},
  	{ "/focus [target=mouseover]", "modifier.lalt" }, -- Mouseover Focus

	-- Buffs
    { "52127", { -- Water Shield
		"!player.buff(52127)", 
		"!player.buff(974)"
	}},
	{"/cancelaura Ghost Wolf",{
		"!player.moving", 
		"player.buff(2645)"
	}},
	{"/cancelaura Ghost Wolf",{
		"player.buff(79206)", 
		"player.buff(2645)"
	}},
	{"2645", { -- Ghost Wolf
		"player.movingfor >= 1", 
		"!player.buff(79206)",
		"!player.buff(2645)"
	}},	

	-- Survival
	{ "108271", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'AstralShift')) end), nil }, -- Astral Shift
	{ "Stoneform", "player.health <= 65" }, -- Stoneform // Dwarf Racial
	{ "59547", "player.health <= 70", "player" }, -- Gift of the Naaru // Draenei Racial

	-- Items
	{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'Healthstone')) end), nil }, -- Healthstone
	{ "#trinket1", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfShamanResto', 'Trinket1')) end), nil }, -- Trinket 1
	{ "#trinket2", (function() return NeP.Core.dynamicEval("player.mana <= " .. NeP.Core.PeFetch('npconfShamanResto', 'Trinket2')) end), nil }, -- Trinket 2		
}

local AoE = {
	{{ -- Party
		{ "1064", "@coreHealing.needsHealing(90, 3)", "lowest" },  -- Chain Heal
	},{
		"!modifier.members > 5",
		"modifier.party"
	}},
	{{ -- Raid
		{ "1064", "@coreHealing.needsHealing(90, 3)", "lowest" },  -- Chain Heal
	},{
		"modifier.members > 5",
		"!modifier.party"
	}},
}

local Tank = {
	-- Tank
	{ "974", { -- Earth Shield
		(function() return NeP.Core.PeFetch("npconfShamanResto", "ESo") == '1' end),
		(function() return NeP.Core.PeFetch("npconfShamanResto", "EarthShieldTank") end),
		"!tank.buff(974)"
	}, "tank" },
	{ "61295", { -- Riptide
	    (function() return NeP.Core.PeFetch("npconfShamanResto", "ESo") == '1' end),
		(function() return NeP.Core.PeFetch("npconfShamanResto", "RiptideTank") end)
	    "tank.buff(61295).duration <= 3" -- Riptide
	}, "tank" },
	{ "8004", (function() return NeP.Core.dynamicEval("tank.health <= "..NeP.Core.PeFetch("npconfShamanResto", "HealingSurgeTank")) end), "tank" }, -- Healing Surge
	{ "77472", (function() return NeP.Core.dynamicEval("tank.health <= "..NeP.Core.PeFetch("npconfShamanResto", "HealingWaveTank")) end), "tank" }, -- Healing Wave
}

local Focus = {					
    { "974", { -- Earth Shield
    	(function() return NeP.Core.PeFetch("npconfShamanResto", "ESo") == '2' end),
		(function() return NeP.Core.PeFetch("npconfShamanResto", "EarthShieldTank") end),
    	"!focus.buff(974)"
    }, "focus" },
	{ "61295", { -- Riptide
	    (function() return NeP.Core.PeFetch("npconfShamanResto", "ESo") == '2' end),
		(function() return NeP.Core.PeFetch("npconfShamanResto", "RiptideTank") end),
	    "focus.buff(61295).duration <= 3" -- Riptide
	}, "focus" },
	{ "8004", (function() return NeP.Core.dynamicEval("focus.health <= "..NeP.Core.PeFetch("npconfShamanResto", "HealingSurgeTank")) end), "focus" }, -- Healing Surge
	{ "77472", (function() return NeP.Core.dynamicEval("focus.health <= "..NeP.Core.PeFetch("npconfShamanResto", "HealingWaveTank")) end), "focus" }, -- Healing Wave
}

local RaidHealing = {
	{ "73685",{	-- Unleash Life	
		"!player.buff(73685)",
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'UnleashLifeRaid')) end)
	}},
	{ "16188", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'AncestralSwiftnessRaid')) end), "lowest" }, -- Ancestral Swiftness
	{ "8004", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'HealingSurgeRaid')) end), "lowest" }, -- Healing Surge
	{ "77472", { -- Healing Wave
		"lowest.health <= 60",
		"lowest.buff(61295)" -- Riptide
	}, "lowest" },
	{ "61295", { -- Riptide
		"!player.buff(53390)", -- Tidal Waves
		"!lowest.buff(61295)", -- Riptide
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'RiptideRaid')) end)
	}, "lowest" },
	{ "77472", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'HealingWaveRaid')) end), "lowest" }, -- Healing Wave
}

local SelfHealing = {
	{ "16188", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'AncestralSwiftnessPlayer')) end), "player" }, -- Ancestral Swiftness
	{ "8004", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'HealingSurgePlayer')) end), "player" }, -- Healing Surge
	{ "61295", { -- Riptide
		"!player.buff(53390)", -- Tidal Waves
		"!player.buff(61295)", -- Riptide
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'RiptidePlayer')) end),
		"!lowest.health <= 50" -- Dont use it on sealf if someone needs it more!
	}, "player" },
	{ "77472", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanResto', 'HealingWavePlayer')) end), "player" }, -- Healing Wave
}

local DPS= {
	{ "2894", { -- Fire Elemental Totem
		"!talent(6, 2)", 
		"modifier.cooldowns" 
	}}, 
	{ "3599", { -- Searing Totem // Fire Elemental Totem
		"!player.totem(3599)", 
		"!player.totem(2894)" 
	}},
	{ "117014", "talent(6, 3)" },
	{ "8050", "!target.debuff(8050)" },
	{ "51505" },
	{ "421", { 
		"modifier.multitarget", 
		"target.area(10).enemies > 2"
	}},
	{ "403" }, -- Lightning Bolt	
}

local outCombat = {
	{ "61295", { -- Riptide
		"!player.buff(53390)", -- Tidal Waves
		"!lowest.buff(61295)", -- Riptide
		"lowest.health < 100"
	}, "lowest" },
	{ "77472", "lowest.health <= 70", "lowest" }, -- Healing Wave
}

ProbablyEngine.rotation.register_custom(264, NeP.Core.CrInfo(), 
	{ -- In-Combat
		{{ -- Solo
			{SelfHealing},
			{DPS, "toggle.dps"}
		}, "!modifier.party" },
		{{ -- Party/Raid
			{General},
			{{ -- Stop if moving
				{{ -- Dispel
					{ "77130", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Curse' end) end) }, -- Dispel Everything
				}, (function() return NeP.Core.PeFetch('npconfShamanResto','Dispels') end) }, 
				{{-- Interrupt
					{ "57994" }, -- Wind Shear
				}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
				{Cooldowns, "modifier.cooldowns"},
				{Totems},
				{Tank, "tank.range <= 40"},
				{Focus, "focus.range <= 40"},
				{AoE},
				{SelfHealing},
				{RaidHealing},
				{DPS, {
					"toggle.dps",
					"target.infront",
					"target.range < 40"
				}},
			}, "!player.moving" },
		}, "modifier.party" },
	}, outCombat, exeOnLoad)
