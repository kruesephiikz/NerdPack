NeP.Addon.Interface.DruidGuard = {
	key = "npconfDruidGuard",
	profiles = true,
	title = NeP.Addon.Info.Icon..NeP.Addon.Info.Nick.." Config",
	subtitle = "Druid Guardian Settings",
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

			{ 
				type = "checkbox", 
				text = "Buffs", 
				key = "Buffs", 
				default = true, 
				desc = "This checkbox enables or disables the use of automatic buffing."
			},
			{ 
				type = "checkbox", 
				text = "Bear Form", 
				key = "Bear", 
				default = true, 
				desc = "This checkbox enables or disables the use of automatic Bear form."
			},
			{ 
				type = "checkbox", 
				text = "Bear Form OCC", 
				key = "BearOCC", 
				default = false, 
				desc = "This checkbox enables or disables the use of automatic Bear form while out of combat."
			},

		-- Player
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = "Player settings:", 
			align = "center"
		},

			{ 
				type = "spinner", 
				text = "Savage Defense", 
				key = "SavageDefense", 
				default = 95
			},
			{ 
				type = "spinner", 
				text = "Frenzied Regeneration", 
				key = "FrenziedRegeneration", 
				default = 70
			},
			{ 
				type = "spinner", 
				text = "Barkskin", 
				key = "Barkskin", 
				default = 70
			},
			{ 
				type = "spinner", 
				text = "Cenarion Ward", 
				key = "CenarionWard", 
				default = 60
			},
			{ 
				type = "spinner", 
				text = "Survival Instincts", 
				key = "SurvivalInstincts", 
				default = 40 
			},
			{ 
				type = "spinner",
				text = "Renewal", 
				key = "Renewal", 
				default = 40 
			},
			{ 
				type = "spinner", 
				text = "Healthstone", 
				key = "Healthstone", 
				default = 50 
			},
			{ 
				type = "spinner", 
				text = "Healing Tonic", 
				key = "HealingTonic", 
				default = 30 
			},
			{ 
				type = "spinner", 
				text = "Smuggled Tonic", 
				key = "SmuggledTonic", 
				default = 30 
			},	

	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local inCombat = {
	
	--	keybinds
		{ "77761", "modifier.rshift" }, -- Stampeding Roar
		{ "5211", "modifier.lcontrol" }, -- Mighty Bash
		{ "!/focus [target=mouseover]", "modifier.ralt" }, -- Focus
		-- Rebirth
			-- Rebirth
			{ "!/cancelform", { -- remove bear form
				"player.form > 0", 
				"player.spell(20484).cooldown < .001", 
				"modifier.lshift" 
			}}, 
			{ "20484", { -- Rebirth
				"modifier.lshift", 
				"!target.alive" 
			}, "target" }, 
			{ "!/cast Bear Form", {  -- bear form
				"!player.casting", "!player.form = 1", 
				"lastcast(20484)", 
				"modifier.lshift" 
			}},
		
	--	Buffs
		{ "/cancelaura Bear Form", { -- Cancel player form
  			"player.form > 0",  -- Is in any fom
  			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
  			"!player.buff(5215)" -- Not in Stealth
  		}},
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0" -- Player not in form
		}}, 
		{ "5487", { -- Bear Form
  			"player.form != 1", -- Stop if bear
  			"!modifier.lalt", -- Stop if pressing left alt
  			"!player.buff(5215)", -- Not in Stealth
  			(function() return NeP.Core.PeFetch('npconfDruidGuard', 'Bear') end),
  		}},

	{{-- Interrupts
		{ "106839" }, -- Skull Bash
		{ "5211" }, -- Mighty Bash
	}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
	
	-- Items
		{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'Healthstone')) end) }, -- Healthstone
		{ "#109223", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'HealingTonic')) end) }, --  Healing Tonic
		{ "#117415", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'SmuggledTonic')) end) }, --  Smuggled Tonic
	
	-- Cooldowns
		{ "50334", "modifier.cooldowns" }, -- Berserk
		{ "124974", "modifier.cooldowns" }, -- Nature's Vigil
		{ "102558", "modifier.cooldowns" }, -- Incarnation
 
	--Defensive
		{ "62606", { -- Savage Defense
			"!player.buff", 
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'SavageDefense')) end) 
		}},
		{ "22842", { -- Frenzied Regeneration
			"!player.buff",
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'FrenziedRegeneration')) end),
			"player.rage >= 20"
		}},
		{ "22812",  (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'Barkskin')) end) }, -- Barkskin
		{ "102351",  (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'CenarionWard')) end), "player" }, -- Cenarion Ward
		{ "61336",  (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'SurvivalInstincts')) end) }, -- Survival Instincts
		{ "108238", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidGuard', 'Renewal')) end) }, -- Renewal		

	-- Dream of Cenarious
		-- Needs a Rebirth here
		{ "5185", {  -- Healing touch /  RAID/PARTY
			"lowest.health < 90", 
			"!player.health < 90",
			"player.buff(145162)" 
		}, "lowest" },
		{ "5185", {  -- Healing touch / PLAYER
			"player.health < 90", 
			"player.buff(145162)" 
		}, "player" },

	-- Procs
		{ "6807", "player.buff(Tooth and Claw)" }, -- Maul

	-- Rotation
		{ "770", { -- Faerie Fire
			"!target.debuff(770)", 
			"target.boss"
		} },
		{ "158792", { -- Pulverize
			"target.debuff(33745).count >= 3", 
			"player.buff(158792).duration <= 3"
		}},
		{ "33917" }, -- Mangle
		-- AoE
			{ "77758", (function() return NeP.Lib.SAoE(3, 40) end) }, -- Thrash	
		{ "77758", "target.debuff(77758).duration <= 4" }, -- Thrash
		{ "33745" }, -- Lacerate
  
}

local outCombat = {

	--	keybinds
		{ "77761", "modifier.rshift" }, -- Stampeding Roar
		{ "5211", "modifier.lcontrol" }, -- Mighty Bash
		{ "!/focus [target=mouseover]", "modifier.ralt" }, -- Focus
		-- Rebirth
			{ "!/cancelform", { -- remove bear form
				"player.form > 0", 
				"player.spell(20484).cooldown < .001", 
				"modifier.lshift" 
			}}, 
			{ "20484", { -- Rebirth
				"modifier.lshift", 
				"!target.alive" 
			}, "target" }, 
			{ "!/cast Bear Form", {  -- bear form
				"!player.casting", "!player.form = 1", 
				"lastcast(20484)", 
				"modifier.lshift" 
			}},
		
	-- Buffs
  		{ "/cancelaura Bear Form", { -- Cancel player form
  			"player.form > 0",  -- Is in any fom
  			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
  			"!player.buff(5215)" -- Not in Stealth
  		}},
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0" -- Player not in form
		}}, 
		{ "5487", { -- Bear Form
  			"player.form != 1", -- Stop if bear
  			"!modifier.lalt", -- Stop if pressing left alt
  			"!player.buff(5215)", -- Not in Stealth
  			(function() return NeP.Core.PeFetch('npconfDruidGuard', 'BearOCC') end),
  		}},

}

ProbablyEngine.rotation.register_custom(104, NeP.Core.GetCrInfo('Druid - Guardian'), 
	inCombat, outCombat, exeOnLoad)