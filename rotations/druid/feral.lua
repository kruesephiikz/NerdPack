local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'NeP_SAoE', 
		'Interface\\AddOns\\Probably_MrTheSoulz\\media\\toggle.blp', 
		'Smart AoE', 
		'Smart AoE\nTo Force AoE enable multitarget toggle.')
end

local CatForm = {

	-- rake // prowl with glyph
	{ "1822", {
		"player.buff(5215)", -- prowl
		"player.glyph(127540)" -- Savage Roar
	}, "target" },

  	--	keybinds
  		{{ -- Shift
  			{ "106839", { -- Skull Bash
  				"target.exists",
  				"target.range <= 13"
  			}, "target" },
		  	{ "Mighty Bash", {
  				"target.exists",
  				"target.range <= 13"
  			}, "target" },
		  	{ "77764", "modifier.party" }, -- Stampending Roar
		  	{ "1850" } -- Dash
	  	}, "modifier.shift" },
	  	{{-- Control
	  		{ "Mass Entanglement" },
	  		{ "Ursol's Vortex", "target.exists", "mouseover.ground" }, -- Ursol's Vortex
	  		{ "339" }, -- Entangling Roots
	  	}, "modifier.control" },
	  	{ "Typhoon", { 
	  		"modifier.alt", 
	  		"target.exists"
	  	}, "target" },

  	-- Survival
	  	{ "Renewal", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidFeral', 'Renewal')) end) }, -- Renewal
	  	{ "Cenarion Ward", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidFeral', 'CenarionWard')) end) }, -- Cenarion Ward
	  	{ "61336",(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidFeral', 'SurvivalInstincts')) end) }, -- Survival Instincts
	  	
	-- Predatory Swiftness (Passive Proc)
	  	{ "5185", {  -- Healing Touch Player
	  		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfDruidFeral', 'HealingTouch')) end),
	  		"player.buff(Predatory Swiftness)",
	  		"!talent(7,2)"
	  	}, "player" },
	  	{ "5185", {  -- Healing Touch Lowest
	  		"lowest.health < 70",
	  		"!talent(7,2)",
	  		"player.buff(Predatory Swiftness)" 
	  	}, "lowest" },
	  	{ "5185", {  -- Healing Touch Lowest (BooldTalons TALENT)
	  		"talent(7,2)",
	  		"player.combopoints = 5",
	  		"player.buff(Predatory Swiftness)"
	  	}, "lowest" },
	  	{ "5185", { -- Healing Touch EXPIRE
	  		"player.buff(Predatory Swiftness)", 
	  		"player.buff(Predatory Swiftness).duration <= 3"
	  	}, "lowest" },

  	--Cooldowns
	  	{ "106737", {  --Force of Nature
	  		"player.spell(106737).charges > 2", 
	  		"!lastcast(106737)", 
	  		"player.spell(106737).exists" 
	  	}},
	  	{ "106951", "modifier.cooldowns" }, -- Beserk
	  	{ "124974", "modifier.cooldowns" }, -- Nature's Vigil
	  	{ "102543", "modifier.cooldowns" }, -- incarnation
  	
	-- buffs
		{ "5217", (function() return NeP.Core.dynamicEval("player.energy <= " .. NeP.Core.PeFetch('npconfDruidFeral', 'TigersFury')) end) }, -- Tiger's Fury

		-- Proc's
	  		{ "106830", "player.buff(Omen of Clarity)", "target" }, -- Free Thrash

	  	-- Finish
	  		{ "52610", { -- Savage Roar
	  			"player.buff(52610).duration <= 4", -- Savage Roar
	  			"player.buff(174544).duration <= 4", -- Savage Roar GLYPH
	  			"player.combopoints <= 2" 
	  		}, "target"},
	  		{{ -- 5 CP
			  	{ "1079", { -- Rip // bellow 25% if target does not have debuff
					"target.health < 25", 
					"!target.debuff(1079)" -- stop if target as rip debuff
				}, "target"},
				{ "1079", { -- Rip // more then 25% to refresh
					"target.health > 25", 
					"target.debuff(1079).duration <= 7"
				}, "target"},
				{ "22568", { -- Ferocious Bite to refresh Rip when target at <= 25% health.
				    "target.health < 25", 
				    "target.debuff(1079).duration < 5" -- RIP
				}, "target"},
				{ "22568", { -- Ferocious Bite // Max Combo and Rip or Savage Roar do not need refreshed
				    "target.debuff(1079).duration > 7", -- RIP
				    "player.buff(52610).duration > 4" -- Savage Roar
				}, "target"},
				{ "22568", { -- Ferocious Bite // Max Combo and Rip or Savage Roar GLYPH do not need refreshed
				    "target.debuff(1079).duration > 7", -- RIP
				    "player.buff(174544).duration > 4" -- Savage Roar GLYPH
				}, "target"},
			}, "player.combopoints = 5" },

	  	-- AOE
		  	{{-- Forced
				{ "106830", "target.debuff(106830).duration < 5", "target" }, -- Tharsh
				{ "106785" }, -- Swipe
			}, "modifier.multitarget" },
			{{ -- Smart
				{ "106830", { -- Tharsh
					"player.area(8).enemies >= 3", 
					"target.debuff(106830).duration < 5"
				}, "target" },
				{ "106785", "player.area(8).enemies >= 3" },-- Swipe
			}, "toggle.NeP_SAoE" },

	 	-- Single Rotation
	  		{ "1822", "target.debuff(155722).duration <= 4", "target" }, -- rake
	  		{ "155625", { -- MoonFire // Lunar Inspiration (TALENT)
	  			"target.debuff(155625).duration <= 4",
	  			"talent(7, 1)"
	  		}, "target" },
		    { "5221" }, -- Shred
  
}


ProbablyEngine.rotation.register_custom(103, NeP.Core.GetCrInfo('Druid - Feral'), 
	{ ------------------------------------------------------------------------------------------------------------------ In Combat
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0", -- Player not in form
			(function() return NeP.Core.PeFetch('npconfDruidFeral','Buffs') end),
		}},
		{ "Ursol's Vortex", {"modifier.shift", "target.exists"}, "mouseover.ground" }, -- Ursol's Vortex
	  	{ "Disorienting Roar", "modifier.shift" },
	  	{ "Mighty Bash", {"modifier.control", "target.exists"}, "target" },
	  	{ "Typhoon", {"modifier.alt", "target.exists"}, "target" },
	  	{ "Mass Entanglement", "modifier.shift" },
	  	{ "/run CancelShapeshiftForm();", (function() 
	  		if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch('npconfDruidFeral', 'Form') == 'MANUAL' then
	  			return false
	  		elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch('npconfDruidFeral', 'Form') == '0' then
	  			return true
	  		else
	  			return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch('npconfDruidFeral', 'Form'))
	  		end
	  	end) },
		{ "768", { -- catform
	  		"player.form != 2", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','Form') == '2' end),
	  	}},
	  	{ "783", { -- Travel
	  		"player.form != 3", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','Form') == '3' end),
	  	}},
	  	{ "5487", { -- catform
	  		"player.form != 1", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','Form') == '1' end),
	  	}},
	  	{{ --------------------------------------------------------------------------------- Cat Form
	  		{{
		  		{ "106839" },	-- Skull Bash
				{ "5211" }, 	-- Mighty Bash
			}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
			{ CatForm },
		}, "player.form = 2" },
	}, 
	{ ------------------------------------------------------------------------------------------------------------------ Out Combat
		{ "1126", {  -- Mark of the Wild
			"!player.buff(20217).any", -- kings
			"!player.buff(115921).any", -- Legacy of the Emperor
			"!player.buff(1126).any",   -- Mark of the Wild
			"!player.buff(90363).any",  -- embrace of the Shale Spider
			"!player.buff(69378).any",  -- Blessing of Forgotten Kings
			"!player.buff(5215)",-- Not in Stealth
			"player.form = 0", -- Player not in form
			(function() return NeP.Core.PeFetch('npconfDruidFeral','Buffs') end),
		}},
		{ "Ursol's Vortex", {"modifier.shift", "target.exists"}, "mouseover.ground" }, -- Ursol's Vortex
	  	{ "Disorienting Roar", "modifier.shift" },
	  	{ "Mighty Bash", {"modifier.control", "target.exists"}, "target" },
	  	{ "Typhoon", {"modifier.alt", "target.exists"}, "target" },
	  	{ "Mass Entanglement", "modifier.shift" },
	  	{ "/run CancelShapeshiftForm();", (function() 
	  		if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch('npconfDruidFeral', 'FormOCC') == 'MANUAL' then
	  			return false
	  		elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch('npconfDruidFeral', 'FormOCC') == '0' then
	  			return true
	  		else
	  			return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch('npconfDruidFeral', 'FormOCC'))
	  		end
	  	end) },
		{ "768", { -- catform
	  		"player.form != 2", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','FormOCC') == '2' end),
	  	}},
	  	{ "783", { -- Travel
	  		"player.form != 3", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','FormOCC') == '3' end),
	  	}},
	  	{ "5487", { -- catform
	  		"player.form != 1", -- Stop if cat
	  		"!modifier.lalt", -- Stop if pressing left alt
	  		"!player.buff(5215)", -- Not in Stealth
	  		(function() return NeP.Core.PeFetch('npconfDruidFeral','FormOCC') == '1' end),
	  	}},
	  	{{ --------------------------------------------------------------------------------- Cat Form
	  		{ "5215", { -- Stealth
		  		"player.form = 2", -- If cat
		  		"!player.buff(5215)", -- Not in Stealth
		  		(function() return NeP.Core.PeFetch('npconfDruidFeral','Prowl') end),
		  	}},
		}, "player.form = 2" },
	}, exeOnLoad)
