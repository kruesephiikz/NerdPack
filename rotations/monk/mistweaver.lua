NeP.Interface.MonkMm = {
	key = "npconfigMonkMm",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Monk Mistweaver Settings",
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

			-- NOTHING IN HERE YET...

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},
			
			-- Survival Settings:
			{
				type = "spinner",
				text = "Soothing Mist",
				key = "SM",
				width = 50,
				min = 0,
				max = 100,
				default = 100,
				step = 5
			},
			
	}
}

local function Trans()
	usable, nomana = IsUsableSpell("Transcendence: Transfer");
	if not usable then
		return true
	end
	tFound=false
	for i=1,40 do local B=UnitBuff("player",i); 
		if B=="Transcendence" then tFound=true end 
	end
	
	if not tFound then
		return true
	end
	
	return false
end

local NeP_SoothingMist_Target = nil

local NeP_soothingMist = function (ht)
	if NeP_SoothingMist_Target ~= nil then
		local health = math.floor((UnitHealth(NeP_SoothingMist_Target) / UnitHealthMax(NeP_SoothingMist_Target)) * 100)
		if health >= ht then
			return true
		end
	end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'trans', 
		'Interface\\Icons\\Inv_boots_plate_dungeonplate_c_05.png', 
		'Enable Casting Transcendence Outside of Combat', 
		'Enable/Disable Casting Transcendence Outside of Combat \nIf you forget to cast it and need help -- not a bad idea!.')
	ProbablyEngine.listener.register("COMBAT_LOG_EVENT_UNFILTERED", function(...)
		local timeStamp, event, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, spellID = ...
		if event == "SPELL_CAST_SUCCESS" then
			if sourceGUID == UnitGUID("player") then
				-- Monk MW // Soothing Mist
				if spellID == 115175 then
					NeP_SoothingMist_Target = targetName
				end
			end
		end
	end)
end
							-- [[ !!!Stance of the Wise Serpent!!!]]
--[[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]]
local inCombatSerpente = {

	{ "/stopcasting", {
		(function() return NeP_soothingMist(NeP.Core.PeFetch('npconfigMonkMm', 'SM')) end),
		"player.casting(115175)" -- Soothing Mist
	} },

	-- Buffs
  	{ "116781", {-- Legacy of the White Tiger
      	"!player.buff(116781)",
      	"!player.buff(17007)",
      	"!player.buff(1459)",
      	"!player.buff(61316)",
      	"!player.buff(24604)",
      	"!player.buff(90309)",
      	"!player.buff(126373)",
      	"!player.buff(126309)"
    }},
  	{ "117666", {-- Legacy of the Emperor
      	"!player.buff(117666)",
      	"!player.buff(1126)",
      	"!player.buff(20217)",
      	"!player.buff(90363)"
    }},

	-- Keybinds
		--{"101546", "modifier.shift"}, -- Spinning Crane Kick
  		{ "115313" , "modifier.control", "tank.ground" },-- Summon Jade Serpent Statue
  
  	{{-- Interrupts
	  	{ "115078", { -- Paralysis when SHS, and Quaking Palm are all on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"player.spell(107079).cooldown > 0", -- Quaking Palm
	     	"!lastcast(116705)", -- Spear Hand Strike
	    }},
	  	{ "116844", { -- Ring of Peace when SHS is on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"!lastcast(116705)", -- Spear Hand Strike
	    }},
	  	{ "119381", { -- Leg Sweep when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 5",
	     	"!lastcast(116705)",
	    }},
	  	{ "119392", { -- Charging Ox Wave when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 30",
	     	"!lastcast(116705)",
	    }},
	  	{ "116705" }, -- Spear Hand Strike
	}, "target.NePinterrupt" },
	
	{{ -- Dispell all?
		{ "115450", (function() return NeP.Lib.Dispell(
			function() return dispelType == 'Magic' or dispelType == 'Posion' or dispelType == 'Disease' end
		) end) },
	}},

	-- Cooldowns
  		{ "116849", "lowest.health <= 25" },-- Life Coccon

	-- Give me Mana
		{ "115294", { -- mana tea
			"player.mana < 95", 
			"player.buff(115867).count >= 2" 
		}},

	-- FREEDOOM!
		{ "137562", "player.state.disorient" }, -- Nimble Brew = 137562
		{ "137562", "player.state.fear" },
		{ "137562", "player.state.stun" },
		{ "137562", "player.state.root" },
		{ "137562", "player.state.horror" },
		{ "137562", "player.state.snare" },
		{ "116841", "player.state.disorient" }, -- Tiger's Lust = 116841
		{ "116841", "player.state.stun" },
		{ "116841", "player.state.root" },
		{ "116841", "player.state.snare" },
		{"Escape Artist", "player.state.snare" },
		{"Escape Artist", "player.state.root" },
		{ "115080", "player.buff(121125)" }, -- Touch of Death, Death Note
		{"Transcendence", {
			(function() return Trans() end), 
			"toggle.trans"
		} },

	-- Survival
		{ "115072", { "player.health <= 80", "player.chi < 4" }}, -- Expel Harm
		{ "115098", "player.health <= 75" }, -- Chi Wave
		{ "115203", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
		  "player.health < 30",
		  "!player.buff(122783)", -- Diffuse Magic
		  "!player.buff(122278)"-- Dampen Harm
		}}, 
		{ "#5512", "player.health < 40" }, -- Healthstone
		{"119996", "player.health < 35"}, --Transcendence: Transfer

	-- AoE
		{ "115310", "@coreHealing.needsHealing(50, 9)", nil }, -- Revival
  		{ "116680", { -- Uplift with Thunder Focus Tea Condition
  			"@coreHealing.needsHealing(80, 3)",
  			"player.chi >= 3", 
  			"!player.buff(116680)"
  		}},
	    { "115098", "@coreHealing.needsHealing(90, 2)", "lowest" },
		
	-- Enveloping Mist
		{ "124682", { 
			"focus.chi >= 3",
			"focus.health < 90",
			"player.casting(115175)" -- Soothing Mist
		}, "focus" },
		{ "124682", {
			"player.chi >= 3",
			"tank.health < 90",
			"player.casting(115175)" -- Soothing Mist
		}, "tank" },
		{ "124682", {
			"player.casting(115175)", -- Soothing Mist
			"player.chi >= 3", 
			"lowest.health < 90" 
		}, "lowest" }, 

	-- Surging Mist
		{ "116694", { 
			"player.casting(Soothing Mist)", 
			"focus.health <= 99" 
		}, "focus" },
		{ "116694", {
			"player.casting(Soothing Mist)", 
			"tank.health <= 99" 
		}, "tank" }, 
		{ "116694", {
			"player.casting(Soothing Mist)", 
			"lowest.health <= 95", 
			"!lowest.buff(119611)"
		}, "lowest" }, 

	--Expel Harm
		{"115072", "player.health < 70", "player"},

	-- Renewing Mist
		{ "115151", {
			"lowest.buff(119611).duration <= 2", 
			"lowest.health < 100"
		}, "lowest"}, 

	-- Soothing Mist
	  	{ "115175", {
	  		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfigMonkMm', 'SM')) end), 
	  		"!player.moving"
	  	}, "lowest" },

}

								-- [[ !!!Stance of the Spirited Crane!!!]]
--[[!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!]]

local inCombatCrane = {

	-- Buffs
	  	{ "116781", {-- Legacy of the White Tiger
	      	"!player.buff(116781)",
	      	"!player.buff(17007)",
	      	"!player.buff(1459)",
	      	"!player.buff(61316)",
	      	"!player.buff(24604)",
	      	"!player.buff(90309)",
	      	"!player.buff(126373)",
	      	"!player.buff(126309)"
	    }},
	  	{ "117666", {-- Legacy of the Emperor
	      	"!player.buff(117666)",
	      	"!player.buff(1126)",
	      	"!player.buff(20217)",
	      	"!player.buff(90363)"
	    }},	
		
	-- Cooldowns
  		{ "116849", "lowest.health <= 25" },-- Life Coccon

	-- Give me Mana
		{ "115294", { "player.mana < 95", "player.buff(115867).count >= 2" }}, -- mana tea
		
	-- Survival
		{ "115072", { "player.health <= 80", "player.chi < 4" }}, -- Expel Harm
		{ "115098", "player.health <= 75" }, -- Chi Wave
		{ "115203", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
		  "player.health < 30",
		  "!player.buff(122783)", -- Diffuse Magic
		  "!player.buff(122278)"-- Dampen Harm
		 }}, 
		{ "#5512", "player.health < 40" }, -- Healthstone
		
		
	{{-- Interrupts
	  	{ "115078", { -- Paralysis when SHS, and Quaking Palm are all on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"player.spell(107079).cooldown > 0", -- Quaking Palm
	     	"!lastcast(116705)", -- Spear Hand Strike
	    }},
	  	{ "116844", { -- Ring of Peace when SHS is on CD
	     	"!target.debuff(116705)", -- Spear Hand Strike
	     	"player.spell(116705).cooldown > 0", -- Spear Hand Strike
	     	"!lastcast(116705)", -- Spear Hand Strike
	    }},
	  	{ "119381", { -- Leg Sweep when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 5",
	     	"!lastcast(116705)",
	    }},
	  	{ "119392", { -- Charging Ox Wave when SHS is on CD
	     	"player.spell(116705).cooldown > 0",
	     	"target.range <= 30",
	     	"!lastcast(116705)",
	    }},
	  	{ "116705" }, -- Spear Hand Strike
	}, "target.NePinterrupt" },
		
	-- FREEDOOM!
		{ "137562", "player.state.disorient" }, -- Nimble Brew = 137562
		{ "137562", "player.state.fear" },
		{ "137562", "player.state.stun" },
		{ "137562", "player.state.root" },
		{ "137562", "player.state.horror" },
		{ "137562", "player.state.snare" },
		{ "116841", "player.state.disorient" }, -- Tiger's Lust = 116841
		{ "116841", "player.state.stun" },
		{ "116841", "player.state.root" },
		{ "116841", "player.state.snare" },
		{"Escape Artist", "player.state.snare" },
		{"Escape Artist", "player.state.root" },
		
		
		{ "115098", "target.range >= 15" }, -- Chi Wave (40yrd range!)
		{ "115080", "player.buff(121125)" }, -- Touch of Death, Death Note
		{"119996", "player.health < 35"}, --Transcendence: Transfer
		{"Transcendence", {
			(function() return Trans() end), 
			"toggle.trans"
		} },
		{ "115313" , "modifier.control", "tank.ground" }, -- Summon Jade Serpent Statue
}

local outCombat = {

	{ "/stopcasting", {
		(function() return NeP_soothingMist(NeP.Core.PeFetch('npconfigMonkMm', 'SM')) end),
		"player.casting(115175)" -- Soothing Mist
	} },

	-- Buffs
	  	{ "116781", {-- Legacy of the White Tiger
	      	"!player.buff(116781)",
	      	"!player.buff(17007)",
	      	"!player.buff(1459)",
	      	"!player.buff(61316)",
	      	"!player.buff(24604)",
	      	"!player.buff(90309)",
	      	"!player.buff(126373)",
	      	"!player.buff(126309)"
	    }},
	  	{ "117666", {-- Legacy of the Emperor
	      	"!player.buff(117666)",
	      	"!player.buff(1126)",
	      	"!player.buff(20217)",
	      	"!player.buff(90363)"
	    }},

	-- Keybinds
		--{"101546", "modifier.shift"}, -- Spinning Crane Kick
  		{ "115313" , "modifier.control", "tank.ground" },-- Summon Jade Serpent Statue

	-- heals
		{ "115151", { -- Renewing Mist
			"lowest.buff(119611).duration <= 2", 
			"lowest.health < 100"
		}, "lowest"}, 
	  	{ "115175", {-- Soothing Mist
	  		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('npconfigMonkMm', 'SM')) end), 
	  		"!player.moving"
	  	}, "lowest" },
	
		{"Transcendence", (function() return Trans() end) },
}
 


ProbablyEngine.rotation.register_custom(270, NeP.Core.GetCrInfo('Monk - Mistweaver'), 
	{-- Change CR dyn
		{ inCombatSerpente, "player.stance = 1" },
		{ inCombatCrane, "player.stance = 2" },
	},
  	outCombat, exeOnLoad)