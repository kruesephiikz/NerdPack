NeP.Interface.PalaProt = {
  key = "npconfPalaProt",
  profiles = true,
  title = NeP.Info.Icon..NeP.Info.Nick.." Config",
  subtitle = "Paladin Protection Settings",
  color = NeP.Core.classColor('player'),
  width = 250,
  height = 500,
  config = {
    
    -- General
    { type = 'rule' },
    { type = 'header', text = "General settings:", align = "center"},

      -- Run Faster
      { type = "checkbox", text = "Run Faster", key = "RunFaster", default = false , desc =
       "This checkbox enables or disables the use of Speed of Light to move faster."},
      
       -- Buff Might//Kinds
      { type = "dropdown",text = "Buff:", key = "Buff", list = {
        {
          text = "Kings",
          key = "Kings"
        },{
          text = "Might",
          key = "Might"
        }}, default = "Kings", desc = "Select What buff to use The moust..." },

      -- Seal
      { type = "dropdown",text = "Seal:", key = "seal", list = {
        {
          text = "Insight",
          key = "Insight"
        },{
          text = "Righteousness",
          key = "Righteousness"
        },{
          text = "Truth",
          key = "Truth"
        }}, default = "Insight", desc = "Select What Seal to use..." },

      -- Seal AoE
      { type = "dropdown",text = "Seal AoE:", key = "sealAoE", list = {
        {
          text = "Insight",
          key = "Insight"
        },{
          text = "Righteousness",
          key = "Righteousness"
        },{
          text = "Truth",
          key = "Truth"
        }}, default = "Righteousness", desc = "Select What Seal to use while in AoE..." },

    -- Def CD's
    { type = 'rule' },
    { type = 'header', text = 'Defensive Cooldowns Settings:', align = "center"},

      -- Sacred Shield
      { type = "spinner", text = "Sacred Shield", key = "SacredShield", default = 95},

      -- Ardent Defender
      { type = "spinner", text = "ArdentDefender", key = "ArdentDefender", default = 30},

      -- Divine Protection
      { type = "spinner", text = "Divine Protection", key = "DivineProtection", default = 95},

      -- Guardian of Ancient Kings
      { type = "spinner", text = "Guardian of Ancient Kings", key = "GuardianofAncientKings", default = 50},

  -- Survival
    { type = 'rule' },
    { type = 'header', text = 'Survival Settings:', align = "center"},

      -- Healthstone
      { type = "spinner", text = "Healthstone", key = "Healthstone", default = 60},

      -- Lay on Hands
      { type = "spinner", text = "Lay on Hands", key = "LayonHands", default = 20},

      -- Eternal Flame
      { type = "spinner", text = "Eternal Flame", key = "EternalFlame", default = 85},

      -- Word of Glory
      { type = "spinner", text = "Word of Glory", key = "WordofGlory", default = 40},

  -- Raid Heals
    { type = 'rule' },
    { 
      type = 'header', 
      text = 'Survival Settings:', 
      align = "center"
    },
      { 
        type = "spinner", 
        text = "Flash of Light", 
        key = "FlashOfLightRaid", 
        default = 40, 
        desc = "Only with 3 stacks of Selfless Healer"
      },
      { 
        type = "spinner", 
        text = "Lay on Hands", 
        key = "LayOnHandsRaid", 
        default = 10
      },
      { 
        type = "spinner", 
        text = "Hand of Protection", 
        key = "HandOfProtectionRaid", 
        default = 30
      },

  }
}

local exeOnLoad = function()
	NeP.Splash()
end

local InCombat = {

	-- Buff's
	{ "20217", { -- Kings
		"!player.buffs.stats",
		(function() return NeP.Core.PeFetch("npconfPalaProt", "Buff") == 'Kings' end)
	}},
	{ "19740", { -- Might
		"!player.buffs.mastery",
		(function() return NeP.Core.PeFetch("npconfPalaProt", "Buff") == 'Might' end)
	}},
	
	-- Defensive Cooldowns
	{ "20925", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'SacredShield')) end), "player" }, 	-- Sacred Shield
	{ "31850", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'ArdentDefender')) end) }, 			-- Ardent Defender
	{ "498", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'DivineProtection')) end) }, 			-- Divine Protection
	{ "86659", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'GuardianofAncientKings')) end) }, 	-- Guardian of Ancient Kings

	-- Heals
	{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'Healthstone')) end) }, 		-- Healthstone
	{ "633", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'LayonHands')) end), "player"}, -- Lay on Hands
	{ "114163", { ---------------------------------------------------------------------------------------------------------------- Eternal Flame
		"!player.buff(114163)", 
		"player.buff(114637).count = 5", 
		"player.holypower >= 3",
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'EternalFlame')) end)
	}, "player"},
	{ "85673", { ---------------------------------------------------------------------------------------------------------------- Word of Glory
		"player.buff(114637).count = 5", 
		"player.holypower >= 3",
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'WordofGlory')) end)
	}, "player" },

	-- Raid Heals
	{ "Flash of Light", { 
		"player.buff(Selfless Healer).count = 3", 
		(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'FlashOfLightRaid')) end), 
	}, "lowest" },		
	{ "Lay on Hands", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'LayOnHandsRaid')) end), "lowest" },
	--{ "Hand of Protection", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'HandOfProtectionRaid')) end), "lowest" },

	-- Keybinds
	
	{ "105593", "modifier.control", "target" }, 				-- Fist of Justice
	{ "853", "modifier.control", "target" }, 					-- Hammer of Justice
	{ "114158", "modifier.shift", "target.ground" }, 			-- Light´s Hammer

	{{-- Interrumpts
		{ "96231" }, 				-- Rebuke
	}, "target.NePinterrupt" },

	{{ -- Empowered Seals
		{ "31801", { -- Seal of Truth
			"player.seal != 1", 					-- Seal of Truth
			"!player.buff(156990).duration > 3", 	-- Maraad's Truth
			"player.spell(20271).cooldown <= 1" 	-- Judment  CD less then 1
		}},
		{ "20154", { -- Seal of Righteousness
			"player.seal != 2", 					-- Seal of Righteousness
			"!player.buff(156989).duration > 3", 	-- Liadrin's Righteousness
			"player.buff(156990)", 					-- Maraad's Truth
			"player.spell(20271).cooldown <= 1" 	-- Judment  CD less then 1
		}},
		{ "20165", { -- Seal of Insigh
			"player.seal != 3", 					-- Seal of Insigh
			"!player.buff(156988).duration > 3", 	-- Uther's Insight
			"player.buff(156990)", 					-- Maraad's Truth
			"player.buff(156989)", 					-- Liadrin's Righteousness
			"player.spell(20271).cooldown <= 1" 	-- Judment  CD less then 1
		}},
			
		------------------------------------------------------------------------------ Judgment
		{ "20271", {
			"player.buff(156990).duration < 3", -- Maraad's Truth
			"player.seal = 1"
		}},
		{ "20271", { 
			"player.buff(156989).duration < 3", -- Liadrin's Righteousness
			"player.seal = 2"
		}},
		{ "20271", {
			"player.buff(156988).duration < 3", -- Uther's Insight
			"player.seal = 3"
		}},
	}, "talent(7,1)" },

	{{ -- Normal Seals
		{{ -- AoE
			{ "20165", { -- Seal of Insigh
				"player.seal != 3",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "sealAoE") == 'Insight' end),
			}},
			{ "20154", { -- Seal of Righteousness
				"player.seal != 2",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "sealAoE") == 'Righteousness' end),
			}},
			{ "31801", { -- Seal of truth
				"player.seal != 1",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "sealAoE") == 'Truth' end),
			}},
		}, (function() return NeP.Lib.SAoE(3, 40) end) },
		{{ -- Single Target
			{ "20165", { -- Seal of Insigh
				"player.seal != 3",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "seal") == 'Insight' end),
			}},
			{ "20154", { -- Seal of Righteousness
				"player.seal != 2",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "seal") == 'Righteousness' end),
			}},
			{ "31801", { -- Seal of truth
				"player.seal != 1",
				(function() return NeP.Core.PeFetch("npconfPalaProt", "seal") == 'Truth' end),
			}},
		}, "!modifier.multitarget" },
	}, "!talent(7,1)" },

	{{ -- Cooldowns
		{ "31884" }, 											-- Avenging Wrath
		{ "105809" }, 											-- Holy Avenger
		{ "114158", "target.range <= 30", "target.ground" }, 	-- Light´s Hammer
		{ "#gloves" },											-- Gloves
		{{ ------------------------------------------------------- Seraphim
			{ "Seraphim" },   -- Seraphim
			{ "Holy Avenger", { ------------------- Holy Avenger
				"player.holypower < 3",  -- 3 Holy Power
				"player.buff(Seraphim)", -- Buff Seraphin
			}},
		}, "talent(7, 2)" },
	}, "modifier.cooldowns" },

	-- Proc's
	{ "31935", "player.buff(Grand Crusader)", "target" }, 		-- Avenger's Shield // Proc

	{{-- AoE
		{ "53595", "target.spell(Crusader Strike).range", "target" }, 	-- Hammer of the Righteous
		{ "31935" }, 													-- Avenger's Shield
		{ "26573", { 	-------------------------------------------------- Consecration 
			"target.range <= 10",  	-- range less then 10
			"!player.moving" 		-- Not Moving
		}},
		{ "119072", "target.range <= 10" }, 
	}, (function() return NeP.Lib.SAoE(3, 40) end) },

	-- Normal
	{ "53600", { 				------------------------------ Shield of Righteous
		"target.spell(53600).range", 	-- Spell in range
		"player.holypower > 3"			-- 3 Holy Power
	}, "target" },
	{ "35395", "target.spell(35395).range", "target" }, 	-- Crusader Strike
	{ "20271", "target.spell(20271).range", "target" }, 	-- Judgment
	{ "31935", "target.spell(31935).range", "target" }, 	-- Avenger´s Shield
	{ "24275", "target.health <= 20", "target" }, 			-- Hammer of Wrath
	{ "26573", "target.range <= 6", "ground" }, 			-- consecration
	{ "119072", "target.range <= 10" }, 					-- Holy Wrath
	{ "114165", { 				------------------------------ Holy Prism
		"target.spell(114165).range", 	-- Spell in Range
		"talent(5, 1)" 					-- Got Talent
	}, "target"},
	{ "114157", "target.spell(114157).range", "target" }, 	-- Execution Sentence

}

local outCombat = {

	-- Buff's
	{ "20217", { -- Kings
		"!player.buffs.stats",
		(function() return NeP.Core.PeFetch("npconfPalaProt", "Buff") == 'Kings' end)
	}},
	{ "19740", { -- Might
		"!player.buffs.mastery",
		(function() return NeP.Core.PeFetch("npconfPalaProt", "Buff") == 'Might' end)
	}},

	-- Keybinds
	{ "105593", "modifier.control", "target" }, 				-- Fist of Justice
	{ "853", "modifier.control", "target" }, 					-- Hammer of Justice
	{ "114158", "modifier.shift", "target.ground" }, 			-- Light´s Hammer
	
	-- Heals
	{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'Healthstone')) end) }, 		-- Healthstone
	{ "633", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'LayonHands')) end), "player"}, -- Lay on Hands
	{ "114163", { ---------------------------------------------------------------------------------------------------------------- Eternal Flame
		"!player.buff(114163)", 
		"player.buff(114637).count = 5", 
		"player.holypower >= 3",
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'EternalFlame')) end)
	}, "player"},
	{ "85673", { ---------------------------------------------------------------------------------------------------------------- Word of Glory
		"player.buff(114637).count = 5", 
		"player.holypower >= 3",
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPalaProt', 'WordofGlory')) end)
	}, "player" },

}

ProbablyEngine.rotation.register_custom(66, NeP.Core.GetCrInfo('Paladin - Protection'), 
	InCombat, outCombat, exeOnLoad)