NeP.Interface.classGUIs[103] = {
	key = "NePConfDruidFeral",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Druid Feral Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General settings:", align = "center"},

			-- Buff
			{ type = "checkbox", text = "Buffs", key = "Buffs", default = true, desc =
			 "This checkbox enables or disables the use of automatic buffing."},

			{ 
		      	type = "dropdown",
		      	text = "Form", 
		      	key = "Form", 
		      	list = {
			        {
			          text = "Cat",
			          key = "2"
			        },
			        {
			          text = "Bear",
			          key = "1"
			        },
			        {
			          text = "Travel",
			          key = "3"
			        },
			        {
			          text = "Normal",
			          key = "0"
			        },
			        {
			          text = "MANUAL",
			          key = "MANUAL"
			        }
			    }, 
		    	default = "2", 
		    	desc = "Select What form to use while in of combat" 
		    },
			{ 
		      	type = "dropdown",
		      	text = "Form OOC", 
		      	key = "FormOCC", 
		      	list = {
			        {
			          text = "Cat",
			          key = "2"
			        },
			        {
			          text = "Bear",
			          key = "1"
			        },
			        {
			          text = "Travel",
			          key = "3"
			        },
			        {
			          text = "Normal",
			          key = "0"
			        },
			        {
			          text = "MANUAL",
			          key = "MANUAL"
			        }
			    }, 
		    	default = "0", 
		    	desc = "Select What form to use while out of combat" 
		    },

			-- Prowl
			{ type = "checkbox", text = "Prowl", key = "Prowl", default = false, desc =
			 "This checkbox enables or disables the use of automatic Prowl when out of combat."},

		-- Player
		{ type = 'rule' },
		{ type = 'header', text = "Player settings:", align = "center"},

			-- Tiger's Fury
			{ type = "spinner", text = "Tigers Fury", key = "TigersFury", default = 35},

			-- Renewal
			{ type = "spinner", text = "Renewal", key = "Renewal", default = 30},

			-- Cenarion Ward
			{ type = "spinner", text = "Cenarion Ward", key = "CenarionWard", default = 75},

			-- Survival Instincts
			{ type = "spinner", text = "Survival Instincts", key = "SurvivalInstincts", default = 75},

			-- Healing Touch
			{ type = "spinner", text = "Healing Touch", key = "HealingTouch", default = 70, Desc=
			"When player as buff (Predatory Swiftness)."},		

	}
}

local exeOnLoad = function()
	NeP.Splash()
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
	{ "Renewal", (function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfDruidFeral', 'Renewal')) end) }, -- Renewal
	{ "Cenarion Ward", (function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfDruidFeral', 'CenarionWard')) end) }, -- Cenarion Ward
	{ "61336",(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfDruidFeral', 'SurvivalInstincts')) end) }, -- Survival Instincts
	  	
	-- Predatory Swiftness (Passive Proc)
	{ "5185", {  -- Healing Touch Player
		(function() return NeP.Core.dynEval("player.health <= " .. NeP.Core.PeFetch('NePConfDruidFeral', 'HealingTouch')) end),
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

  	{{--Cooldowns
		{ "106737", {  --Force of Nature
			"player.spell(106737).charges > 2", 
			"!lastcast(106737)", 
			"player.spell(106737).exists" 
		}},
		{ "106951" }, -- Beserk
		{ "124974" }, -- Nature's Vigil
		{ "102543" }, -- incarnation
	}, "modifier.cooldowns" },
  	
	-- Buffs
	{ "5217", (function() return NeP.Core.dynEval("player.energy <= " .. NeP.Core.PeFetch('NePConfDruidFeral', 'TigersFury')) end) }, -- Tiger's Fury

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

	{{-- AoE
		{ "106830", "target.debuff(106830).duration < 5", "target" }, -- Tharsh
		{ "106785" }, -- Swipe
	}, (function() return NeP.Core.SAoE(3, 40) end) },

	-- Single Rotation
	{ "1822", "target.debuff(155722).duration <= 4", "target" }, -- rake
	{ "155625", { -- MoonFire // Lunar Inspiration (TALENT)
		"target.debuff(155625).duration <= 4",
		"talent(7, 1)"
	}, "target" },
	{ "5221" }, -- Shred
}

local _All = {
	-- Buff
	{ "1126", {  -- Mark of the Wild
		"!player.buff(20217).any", -- kings
		"!player.buff(115921).any", -- Legacy of the Emperor
		"!player.buff(1126).any",   -- Mark of the Wild
		"!player.buff(90363).any",  -- embrace of the Shale Spider
		"!player.buff(69378).any",  -- Blessing of Forgotten Kings
		"!player.buff(5215)",-- Not in Stealth
		"player.form = 0", -- Player not in form
		(function() return NeP.Core.PeFetch('NePConfDruidFeral','Buffs') end),
	}},
	
	{ "Ursol's Vortex", {
		"modifier.shift", 
		"target.exists"
	}, "mouseover.ground" }, -- Ursol's Vortex
	{ "Disorienting Roar", "modifier.shift" },
	{ "Mighty Bash", {
		"modifier.control", 
		"target.exists"
	}, "target" },
	{ "Typhoon", {
		"modifier.alt", 
		"target.exists"
	}, "target" },
	{ "Mass Entanglement", "modifier.shift" },
}

local inCombat = {
	-- Form Hadling Logic
	{ "/run CancelShapeshiftForm();", (function() 
	  	if NeP.Core.dynEval("player.form = 0") or NeP.Core.PeFetch('NePConfDruidFeral', 'Form') == 'MANUAL' then
	  		return false
	  	elseif NeP.Core.dynEval("player.form != 0") and NeP.Core.PeFetch('NePConfDruidFeral', 'Form') == '0' then
	  		return true
	  	else
	  		return NeP.Core.dynEval("player.form != " .. NeP.Core.PeFetch('NePConfDruidFeral', 'Form'))
	  	end
	end) },
	{ "768", { -- catform
	  	"player.form != 2", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch('NePConfDruidFeral','Form') == '2' end),
	}},
	{ "783", { -- Travel
	  	"player.form != 3", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch('NePConfDruidFeral','Form') == '3' end),
	}},
	{ "5487", { -- catform
	  	"player.form != 1", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch('NePConfDruidFeral','Form') == '1' end),
	}},
}

local outCombat = {
	-- Form Handling Logic
	{ "/run CancelShapeshiftForm();", (function() 
		if NeP.Core.dynEval("player.form = 0") or NeP.Core.PeFetch('NePConfDruidFeral', 'FormOCC') == 'MANUAL' then
	  		return false
	  	elseif NeP.Core.dynEval("player.form != 0") and NeP.Core.PeFetch('NePConfDruidFeral', 'FormOCC') == '0' then
	  		return true
	  	else
	  		return NeP.Core.dynEval("player.form != " .. NeP.Core.PeFetch('NePConfDruidFeral', 'FormOCC'))
	  	end
	end) },
	{ "768", { -- catform
	  	"player.form != 2", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
		(function() return NeP.Core.PeFetch('NePConfDruidFeral','FormOCC') == '2' end),
	}},
	{ "783", { -- Travel
	  	"player.form != 3", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch('NePConfDruidFeral','FormOCC') == '3' end),
	}},
	{ "5487", { -- catform
	  	"player.form != 1", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch('NePConfDruidFeral','FormOCC') == '1' end),
	}},
}

ProbablyEngine.rotation.register_custom(103, NeP.Core.GetCrInfo('Druid - Feral'), 
	{ -- In Combat
		{_All},
		{inCombat},
	  	{{ -- Cat Form
	  		{{
		  		{ "106839" },	-- Skull Bash
				{ "5211" }, 	-- Mighty Bash
			}, "target.NePinterrupt" },
			{ CatForm },
		}, "player.form = 2" },
	}, 
	{ -- Out Combat
		{_All},
		{outCombat},
	  	{{ -- Cat Form
	  		{ "5215", { -- Stealth
		  		"player.form = 2", -- If cat
		  		"!player.buff(5215)", -- Not in Stealth
		  		(function() return NeP.Core.PeFetch('NePConfDruidFeral','Prowl') end),
		  	}},
		}, "player.form = 2" },
	}, exeOnLoad)
