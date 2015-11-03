NeP.Interface.classGUIs[70] = {
  key = "NePConfPalaRet",
  profiles = true,
  title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
  subtitle = "Paladin Retribution Settings",
  color = NeP.Core.classColor('player'),
  width = 250,
  height = 500,
  config = {
    {
      type = "dropdown",
      text = "Select a Blessing",
      key = "set_blessing",
      list = {
        {
          text = "Kings",
          key = "20217"
        },
        {
          text = "Might",
          key = "19740"
        },
        {
          text = "none",
          key = "none"
        },
      },

      default = "19740",
    },
    {type = "rule"},
    {
      type = "text",
      text = "Self Healing",
      align = "center",
    },
    { 
      type = "checkspin",
      text = "Enable Flash of Light",
      key = "flashoflight",
      default_spin = 40,
      default_check = true,
      desc = "Only for talent 'Selfless Healer'." 
    },
    { 
      type = "checkspin",
      text = "Enable Word of Glory",
      key = "wordofglory",
      default_spin = 30,
      default_check = true,
      desc = "Requiers 3 Holy Power." 
    },
    { 
      type = "checkspin",
      text = "Enable Healthstone",
      key = "healthstone",
      default_spin = 30,
      default_check = true,
    },
    { 
      type = "checkspin",
      text = "Enable Lay on Hands",
      key = "layonhands",
      default_spin = 12,
      default_check = true,
      desc = "Cast after reaching this HP value." 
    },
    {type = "rule"},
    {
      type = "text",
      text = "Self Survivability",
      align = "center",
    },
    { 
      type = "checkspin",
      text = "Enable Divine Shield",
      key = "DivineShield",
      default_spin = 10,
      default_check = true,
    },
    { 
      type = "checkbox",
      text = "Enable Cleanse",
      key = "cleanse",
      default_check = true,
    },
    { 
      type = "checkbox",
      text = "Maintain Sacred Shield",
      key = "sacredshield",     
      default_check = true,
    },
    { 
      type = "checkbox",
      text = "Maintain Eternal Glory HoT",
      key = "eternalglory",
      default_check = false,
    },
    { 
      type = "checkbox",
      text = "Enable Hand of Freedom",
      key = "handoffreedom",
      default_check = true,
    },
    { 
      type = "checkbox",
      text = "Enable Emancipate",
      key = "emancipate",
      default_check = true,
    },    
    {  
      type = "dropdown", 
      text = "Empowered Seals",  
      key = "twisting",  
      list = { 
        { 
          text = "Justice", 
          key = "justice" 
        }, 
        { 
          text = "Insight", 
          key = "insight" 
        }, 
        { 
          text = "None", 
          key = "none" 
        } 
      }, default = "none", desc = "Select a third Seal to twist." }, 

    {type = "rule"},
    { 
      type = "checkbox",
      text = "Raid Protection",
      key = "raidprotection",
      default_check = true,
      desc = "Allow LoH, FoL, HoP to cast on raid members."
    },
    { 
      type = "checkspin",
      text = "Hand of Protection",
      key = "handoprot",
      default_spin = 10,
      default_check = true,
      desc = "Allow Hand of Protection on raid members"
    },  
    {type = "rule"},
    {
      type = "text",
      text = "Hotkeys",
      align = "center",
    },    
    {
      type = "text",
      text = "Left Control: Light's Hammer mouseover location",
      align = "left",
    },
    {
      type = "text",
      text = "Left Shift: Cleanse on mouseover target",
      align = "left",
    },
    {
      type = "text",
      text = "Left Alt: Pause Rotation",
      align = "left",
    },        
  }
}

local exeOnLoad = function()
	NeP.Splash()
end

	---------------------------------------------------------------------------
	-------------------------- Testing Area -----------------------------------
	---------------------------------------------------------------------------
	--{{ ToDo: Convert to ID's, finish the CR, document and test everything }}

local Survival = {
	{ "Eternal Flame", { 
		"player.buff(Eternal Flame).duration < 3", 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'eternalglory') end) 
	}, "player" },
	{ "Sacred Shield", { 
		"player.buff(Sacred Shield).duration < 7", 
		"target.range > 3", 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'sacredshield') end) 
	}, "player" },
	{ "Hand of Freedom", { 
		"!player.buff", 
		"player.state.snare", 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'handoffreedom') end) 
	}, "player" },
	{ "Emancipate", { 
		"!lastcast(Emancipate)", 
		"player.state.root", 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'emancipate') end) 
	}, "player" },
	{ "Divine Shield", { 
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfPalaRet', 'DivineShield_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'DivineShield_check') end) 
	}},
	{ "Flash of Light", { 
		"player.buff(Selfless Healer).count = 3", 
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfPalaRet', 'flashoflight_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'flashoflight_check') end) 
	}},
	{ "Word of Glory", { 
		"player.holypower >= 3", 
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfPalaRet', 'wordofglory_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'wordofglory_check') end) 
	}},
	{ "Lay on Hands", { 
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfPalaRet', 'layonhands_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'layonhands_check') end) 
	}},
	{ "#5512", { -- Healthstone (5512)
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfPalaRet', 'healthstone_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'healthstone_check') end) 
	}},
}
-- Test these, they came from prot and might not be the same on ret...
local Seals = {
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
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "sealAoE") == 'Insight' end),
			}},
			{ "20154", { -- Seal of Righteousness
				"player.seal != 2",
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "sealAoE") == 'Righteousness' end),
			}},
			{ "31801", { -- Seal of truth
				"player.seal != 1",
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "sealAoE") == 'Truth' end),
			}},
		}, (function() return NeP.Lib.SAoE(3, 40) end) },
		{{ -- Single Target
			{ "20165", { -- Seal of Insigh
				"player.seal != 3",
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "seal") == 'Insight' end),
			}},
			{ "20154", { -- Seal of Righteousness
				"player.seal != 2",
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "seal") == 'Righteousness' end),
			}},
			{ "31801", { -- Seal of truth
				"player.seal != 1",
				(function() return NeP.Core.PeFetch("NePConfPalaProt", "seal") == 'Truth' end),
			}},
		}, "!modifier.multitarget" },
	}, "!talent(7,1)" },
}

local inCombat = {
	{{ -- Cooldowns
		{ "Execution Sentence", "target.enemy", "target" },
		{ "Light's Hammer", nil, "target.ground" },
		{ "#trinket1" },
		{ "#trinket2" },
	}, "modifier.cooldowns" },

	{{ -- Talent / Final Verdict
		{ "Divine Storm", { 
			"player.buff(Final Verdict)", 
			"player.buff(Divine Crusader)", 
			"player.holypower >= 5" 
		}},
		{ "Final Verdict", { 
			"player.buff(Divine Purpose).duration < 3", 
			"player.buff(Divine Purpose)" 
		}},
		{ "Final Verdict", { 
			"player.buff(Holy Avenger)", 
			"player.holypower >= 3" 
		}}, 
		{ "Divine Storm", { 
			"player.buff(Divine Crusader).duration < 3", 
			"player.buff(Divine Crusader)" 
		}},
		{ "Final Verdict", "player.holypower >= 5" }
	}, "talent(7, 3)" },
	
	{{ -- Talent / Seraphim
		{ "Templar's Verdict", "player.buff(Avenging Wrath)" },
		{ "Templar's Verdict", "player.health < 20" },
		{ "Final Verdict", "player.buff(Avenging Wrath)" },
		{ "Final Verdict", "player.health < 20" }
	}, { "talent(7, 2)", "player.spell(Seraphim).cooldown >= 8" }},
	
	{{ -- Talent / Empowered Seals
		{ "Templar's Verdict", "player.buff(Avenging Wrath)" },
		{ "Templar's Verdict", "player.health < 20" }
	}, "talent(7, 1)" },
}

-- Solo Target
local ST = {
	{ "Avenging Wrath", "modifier.cooldowns" },
	{ "Holy Avenger", "modifier.cooldowns" },
	{ "Execution Sentence", "target.health.actual > 100000" },
	{ "Templar's Verdict", "player.buff(Divine Purpose)" },
	{ "Final Verdict", "player.buff(Divine Purpose)" },
	{ "Templar's Verdict", "player.holypower = 5" },
	{ "Final Verdict", "player.holypower = 5" },
	{ "Divine Storm", {
		"player.buff(Final Verdict)",
		"player.buff(Divine Crusader)"
	}},
	{ "Hammer of Wrath" },
	{ "Crusader Strike" },
	{ "Judgment" },
	{ "Exorcism" },
	{ "Templar's Verdict", "player.holypower >= 3" },
	{ "Final Verdict", "player.holypower >= 3" },
}

-- AoE
local AoE = {
	{ "Avenging Wrath", "modifier.cooldowns" },
	{ "Holy Avenger", "modifier.cooldowns" },
	{ "Execution Sentence", "target.health.actual > 100000" },
	{ "Divine Storm", {
		"player.buff(Final Verdict)",
		"player.buff(Divine Crusader)"
	}},
	{ "Divine Storm", "player.buff(Divine Purpose)" },
	{ "Divine Storm", "player.buff(Final Verdict)" },
	{ "Divine Storm", "player.holypower = 5" },
	{ "Hammer of the Righteous" },
	{ "Exorcism" },
	{ "Hammer of Wrath" },
	{ "Judgment" },
	{ "Divine Storm", "player.holypower >= 3" },
}

local outCombat = {
	{ "Seal of Truth", { 
		"!modifier.multitarget", 
		"player.seal != 1" 
	}},
	{ "Seal of Righteousness", { 
		(function() return NeP.Lib.SAoE(3, 40) end), 
		"player.seal != 2" 
	}},
}

ProbablyEngine.rotation.register_custom(70, NeP.Core.GetCrInfo('Paladin - Retribution'), 
	{-- In-Combat
		{{-- Interrupts
			{ "Rebuke" },
		}, "target.NePinterrupt" },
		{ "Cleanse", {
			"player.dispellable(Cleanse)", 
			(function() return NeP.Core.PeFetch('NePConfPalaRet', 'cleanse') end) 
		}, "player" },
		{ Survival, "player.health < 100" },
		{ Seals },
		{ inCombat },
		-- FIXME: Needs smart AOE
		{ AoE, (function() return NeP.Lib.SAoE(3, 40) end) },
		{ ST },
	}, outCombat_Testing, exeOnLoad)