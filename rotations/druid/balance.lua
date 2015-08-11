NeP.Addon.Interface.DruidBalance = {
	key = "npconfDruidBalance",
	profiles = true,
	title = NeP.Addon.Info.Icon..NeP.Addon.Info.Nick.." Config",
	subtitle = "Druid Balance Settings",
	color = NeP.Core.classColor("player"),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = "rule" },
		{ type = "header", text = "General settings:", align = "center" },

			-- Buff
			{ type = "checkbox", text = "Buffs", key = "Buffs", default = true, desc =
			 "This checkbox enables or disables the use of automatic buffing." },

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
			          text = "Boomkin",
			          key = "4"
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
		    	default = "4", 
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
			          text = "Boomkin",
			          key = "4"
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
		    	default = "4", 
		    	desc = "Select What form to use while out of combat" 
		    },

	}
}

local exeOnLoad = function()
	NeP.Splash()
  	ProbablyEngine.toggle.create(
		"dotEverything", 
		"Interface\\Icons\\Ability_creature_cursed_05.png", 
		"Dot All The Things!", 
		"Click here to dot all the things!\nSome Spells require Multitarget enabled also.\nOnly Works if using FireHack.")
end

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
		(function() return NeP.Core.PeFetch("npconfDruidBalance", "Buffs", true) end),
	}},
	--Shared Stuff
	{ "20484", { -- Rebirth
		"modifier.lshift", 
		"!mouseover.alive" 
	}, "mouseover" },
}

local BoomkinForm = {
			
	{{-- Interrupts
		{ "78675" }, -- Solar Beam
	}, "target.interruptsAt("..(NeP.Core.PeFetch("npconf", "ItA", 40))..")" },
	
	-- Items
	{ "#5512", "player.health < 50" }, --Healthstone
	
	{{-- Cooldowns
		{ "112071" }, --Celestial Alignment
		{ "#trinket1" }, --trinket 1
		{ "#trinket2" }, --trinket 2
		{ "#57723", "player.hashero" }, --  Int Pot on lust
	}, "modifier.cooldowns" },
 
	--Defensive
	{ "Barkskin", "player.health <= 50", "player" },
	{ "#5512", "player.health < 40" }, --Healthstone when less than 40% health
	{ "108238", "player.health < 60", "player" }, --Instant renewal when less than 40% health
	
	{{ -- Auto Dotting	
		{ "164812", (function() return NeP.Lib.AutoDots("164812", 100, 2) end) }, -- moonfire
		{ "164815", (function() return NeP.Lib.AutoDots("164815", 100, 2) end) }, --SunFire
	}, "toggle.dotEverything" },

	-- AoE
	{ "48505", { (function() return NeP.Lib.SAoE(8, 40) end), "!player.buff(184989)" }}, -- Starfall
	
	-- Proc's
	{ "78674", "player.buff(Shooting Stars)", "target" }, --Starsurge with Shooting Stars Proc
	{ "164815", "player.buff(Solar Peak)", "target" }, --SunFire on proc
	{ "164812", "player.buff(Lunar Peak)", "target" }, --MoonFire on proc
	
	-- Rotation
	{ "78674", { --StarSurge with more then 2 charges
		"player.spell(78674).charges >= 2", 
		"!lastcast(78674)" 
	}},
	{ "78674", { --StarSurge with Celestial Alignment buff
		"player.buff(112071)", 
		"!lastcast(78674)" 
	}},
	{ "164812", "target.debuff(Moonfire).duration <= 2" }, --MoonFire
	{ "164815", "target.debuff(Sunfire).duration <= 2" }, --SunFire
	{ "2912", "player.buff(Lunar Empowerment).count >= 1" }, --Starfire with Lunar Empowerment
	{ "5176", "player.buff(Solar Empowerment).count >= 1" }, --Wrath with Solar Empowerment
	{ "2912", { -- StarFire
		( function() return UnitPower( "player", SPELL_POWER_ECLIPSE ) <= 20 end ), 
		"player.lunar" 
	}},
	{ "5176", { -- Wrath
		( function() return UnitPower( "player", SPELL_POWER_ECLIPSE ) >= -20 end ), 
		"player.solar" 
	}}, 
	{ "2912", { -- StarFire
		( function() return UnitPower( "player", SPELL_POWER_ECLIPSE ) <= 0 end ), 
		"player.solar" 
	}},
	{ "5176", { --Wrath
		( function() return UnitPower( "player", SPELL_POWER_ECLIPSE ) >= 0 end ), 
		"player.lunar" 
	}},
	--{ "2912" }, --StarFire Filler
}

local inCombat = {
	-- Form Handling Logic
	{ "/run CancelShapeshiftForm()", (function() 
	  	if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "MANUAL" then
	  		return false
	  	elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "0" then
	  		return true
	  	else
	  		return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch("npconfDruidBalance", "Form", "4"))
	  	end
	end) },
	{ "768", { -- catform
	  	"player.form != 2", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "2" end),
	}},
	{ "783", { -- Travel
	  	"player.form != 3", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "3" end),
	}},
	{ "5487", { -- catform
	  	"player.form != 1", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "1" end),
	}},
	{ "24858", { -- boomkin
	  	"player.form != 4", -- Stop if boomkin
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "Form", "4") == "4" end),
	}},
}

local outCombat = {
	-- Form Handling Logic
	{ "/run CancelShapeshiftForm()", (function() 
		if NeP.Core.dynamicEval("player.form = 0") or NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "MANUAL" then
			return false
		elseif NeP.Core.dynamicEval("player.form != 0") and NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "0" then
			return true
		else
			return NeP.Core.dynamicEval("player.form != " .. NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4"))
		end
	end) },
	{ "768", { -- catform
	  	"player.form != 2", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "2" end),
	}},
	{ "783", { -- Travel
	  	"player.form != 3", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "3" end),
	}},
	{ "5487", { -- catform
		"player.form != 1", -- Stop if cat
	  	"!modifier.lalt", -- Stop if pressing left alt
	  	"!player.buff(5215)", -- Not in Stealth
	  	(function() return NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "1" end),
	}},
	{ "24858", { -- boomkin
		"player.form != 4", -- Stop if boomkin
		"!modifier.lalt", -- Stop if pressing left alt
		"!player.buff(5215)", -- Not in Stealth
	(function() return NeP.Core.PeFetch("npconfDruidBalance", "FormOCC", "4") == "4" end),
	}},
}

ProbablyEngine.rotation.register_custom(102, NeP.Core.GetCrInfo("Druid - Balance"), 
	{ -- In Combat
		{_All},
		{inCombat},
	  	{{ -- Boomkin Form
	  		{ BoomkinForm },
		}, "player.form = 4" },
	}, 
	{ -- Out Combat
	  	{_All},
		{outCombat}
	}, exeOnLoad)
