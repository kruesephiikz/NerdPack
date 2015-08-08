local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
	'dotEverything', 
	'Interface\\Icons\\Ability_creature_cursed_05.png', 
	'Dot All The Things! (SOLO)', 
	'Click here to dot all the things while in Solo mode!\nSome Spells require Multitarget enabled also.\nOnly Works if using FireHack.')
	
end

local inCombat = {
	
  	--[[ Chakra ]]
  		{ "81208", {--Serenity
  			"player.chakra != 3",
  			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Serenity' end),
  			}, nil },

		{ "81206", {--Sanctuary
			"player.chakra != 2",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Sanctuary' end),
			}, nil },
		
		{ "81209", {--Serenity
			"player.chakra != 1",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Chastise' end),
		}, nil },

  	-- buffs
		{ "21562", { -- Fortitude
			(function() return NeP.Core.PeFetch('npconfPriestHoly','Buff') end),
			"!player.buffs.stamina"
		}},

  	--[[ keybinds ]]
		{ "32375", "modifier.rcontrol", "player.ground" }, --Mass Dispel
	 	{ "48045", "modifier.ralt", "tank" }, -- Mind Sear
		{ "120517", "modifier.lcontrol", "player" }, --Halo
		{ "110744", "modifier.lcontrol", "player" }, --Divine Star
	
	-- PW:S
		{ "129250" },
	
	{{-- LoOk aT It GOoZ!!!
		{ "121536", { 
			"player.movingfor > 2", 
			"!player.buff(121557)", 
			"player.spell(121536).charges >= 1" 
		}, "player.ground" },
		{ "17", {
			"talent(2, 1)", 
			"player.movingfor > 2", 
			"!player.buff(6788)",
		}, "player" },
	}, -- We only want to run these on unlockers that can cast on unit.ground
		(function()
			if FireHack or oexecute then
				return NeP.Core.PeFetch('npconfPriestHoly', 'Feathers') 
			end
		end)  
	},

  	-- HEALTHSTONE 
		{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'Healthstone')) end) },

  	-- Aggro
		{ "586", "target.threat >= 80" }, -- Fade
 
  	-- Dispel's
	 	{{ -- Dispell all?
			{ "527", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Disease' end) end) },-- Dispel Everything
		}, (function() return NeP.Core.PeFetch('npconfPriestHoly','Dispels') end) },

  	-- CD's
		{ "10060", "modifier.cooldowns" }, --Power Infusion
		{ "123040", { --Mindbender
			"player.mana < 75", 
			"target.spell(123040).range",
			 "modifier.cooldowns"
			 }, "target" },
	-- Proc's
		{ "596", { -- Prayer of healing // Divine Insigt
			"@coreHealing.needsHealing(95, 3)",
			"player.buff(123267)",
			"!player.moving",
			"modifier.party", 
			"!modifier.raid"
			}, "lowest" },
		{ "2061", { -- Flash heal // Surge of light
			"lowest.health < 100",
			"player.buff(114255)",
			"!player.moving"
			}, "lowest" },

	-- Player dead (Spirit)
		{ "88684", { -- Holy Word Serenity
			"lowest.health <= 80", 
			"player.buff(27827)" -- Player Dead
			}, "lowest" },
		{ "2061", { --Flash Heal
			"lowest.health < 100", 
			"player.buff(27827)" -- Player Dead
			}, "lowest" },
		{ "34861", { -- Circle of Healing
			"@coreHealing.needsHealing(95, 3)", 
			"player.buff(27827)" -- Player Dead
			}, "lowest"},
		{ "121135", { -- cascade
			"@coreHealing.needsHealing(95, 3)", 
			"player.buff(27827)"
			}},
		{ "596", { --Prayer of Healing
			"@coreHealing.needsHealing(95, 3)", 
			"player.buff(27827)", -- Player Dead
			"modifier.party",  -- Player is in Party
			"!modifier.raid"  -- Player os not in raid
			}, "lowest" },

	{{-- AOE
   		{ "34861", "@coreHealing.needsHealing(90, 3)", "lowest"}, -- Circle of Healing
		{ "121135", { -- cascade
			"@coreHealing.needsHealing(95, 3)", 
			"!player.moving"
		}, "lowest"},
		-- Divine Hymn
			{ "64843", { -- Divine Hymn
				"@coreHealing.needsHealing(50, 3)", 
				"modifier.party" 
			}},
			{ "64843", { -- Divine Hymn
				"@coreHealing.needsHealing(60, 5)", 
				"modifier.raid", 
				"!modifier.members > 10" 
			}},
			{ "64843", {  -- Divine Hymn
				"@coreHealing.needsHealing(60, 8)", 
				"modifier.raid", 
				"modifier.members > 10" 
			}},
		{ "596", (function() return NeP.Lib.Priest.PoH() end) },-- Prayer of Healing
   		{ "155245", (function() return NeP.Lib.Priest.ClarityOfPurpose() end), "lowest" },-- Clarity Of Purpose
	}, "modifier.multitarget" },

	{{-- Heal Fast Bitch!!
		-- Desperate Prayer
			{ "!19236",  --Desperate Prayer
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'DesperatePrayer')) end),
				"player" },

		-- Holy Word Serenity
			{ "!88684", { -- Holy Word Serenity
				(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HolyWordSerenityTank')) end),
				"focus.spell(88684).range"
				}, "focus" },
			{ "!88684", { -- Holy Word Serenity
				(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HolyWordSerenityTank')) end),
				"tank.spell(88684).range"
				}, "tank" },
			{ "!88684", -- Holy Word Serenity
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HolyWordSerenityPlayer')) end), 
				"player" }, 
			{ "!88684", -- Holy Word Serenity
				(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HolyWordSerenityRaid')) end),
				"lowest" }, 

		-- Flash Heal
			{ "!2061", { --Flash Heal
				(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealTank')) end),
				"focus.spell(2061).range",
				"!player.moving"
				}, "focus" },
			{ "!2061", { --Flash Heal
				(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealTank')) end),
				"tank.spell(2061).range",
				"!player.moving"
				}, "tank" },
			{ "!2061", { --Flash Heal
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealPlayer')) end),
				"!player.moving"
				}, "player" },
			{ "!2061", { --Flash Heal
				(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealRaid')) end),
				"!player.moving"
				}, "lowest" },
	}, "!player.casting.percent >= 50" },

	-- shields
		{ "17", {  --Power Word: Shield
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldTank')) end),
			"!focus.debuff(6788).any", 
			"focus.spell(17).range"
			}, "focus" },
		{ "17", {  --Power Word: Shield
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldTank')) end),
			"!tank.debuff(6788).any",
			"tank.spell(17).range"
			}, "tank" },
		{ "17", { --Power Word: Shield
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldPlayer')) end),
			"!player.debuff(6788).any", 
			"!player.buff(17).any"
			}, "player" }, 
		{ "17", { --Power Word: Shield
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldRaid')) end),
		 	"!lowest.debuff(6788).any", 
		 	"!lowest.buff(17).any",  
		 	}, "lowest" },

	-- renew
		{ "139", { --renew
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewTank')) end),
			"!focus.buff(139)", 
			"focus.spell(139).range"
			}, "focus" },
		{ "139", { --renew
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewTank')) end),
			"!tank.buff(139)", 
			"tank.spell(139).range"
			}, "tank" },
		{ "139", { --renew
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewPlayer')) end), 
			"!player.buff(139)"
			}, "player" },
		{ "139", { --renew
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewRaid')) end),
			"!lowest.buff(139)"
			}, "lowest" },

	-- Prayer of Mending
		{ "33076", { --Prayer of Mending
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'PrayerofMendingTank')) end),
			"focus.spell(33076).range",
			"!player.moving"
			}, "focus" },
		{ "33076", { --Prayer of Mending
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'PrayerofMendingTank')) end),
			"tank.spell(33076).range",
			"!player.moving"
			}, "tank" },

	-- binding heal
		{ "32546", {
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'BindingHealTank')) end),
			"player.health < 60",
			"focus.spell(32546).range",
			"!player.moving"
			}, "focus" },
		{ "32546", {
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'BindingHealTank')) end),
			"player.health <= 60", 
			"tank.spell(32546).range",
			"!player.moving"
			}, "tank" },
		{ "32546", {
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'BindingHealRaid')) end),
			"player.health < 60",
			"!player.moving"
			}, "lowest" },

	-- heal
		{ "2060", { -- Heal
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HealTank')) end), 
			"focus.spell(2060).range",
			"!player.moving"
			}, "focus" },
		{ "2060", { -- Heal
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HealTank')) end), 
			"tank.spell(2060).range",
			"!player.moving"
			}, "tank" },
		{ "2060", { -- Heal	
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'Heal')) end),
			"!player.moving"
			}, "player" },
		{ "2060", { -- Heal	
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HealRaid')) end),
			"!player.moving"
			}, "lowest" },

}

local solo = {
	
  	--[[ Chakra ]]
  		{ "81208", {--Serenity
  			"player.chakra != 3",
  			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Serenity' end),
  			}, nil },

		{ "81206", {--Sanctuary
			"player.chakra != 2",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Sanctuary' end),
			}, nil },
		
		{ "81209", {--Serenity
			"player.chakra != 1",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Chastise' end),
			}, nil },

  	-- buffs
		{ "21562", { -- Fortitude
			(function() return NeP.Core.PeFetch('npconfPriestHoly','Buff') end),
			"!player.buffs.stamina"
			}},
	
	{{-- LoOk aT It GOoZ!!!
		{ "121536", { 
			"player.movingfor > 2", 
			"!player.buff(121557)", 
			"player.spell(121536).charges >= 1" 
		}, "player.ground" },
		{ "17", {
			"talent(2, 1)", 
			"player.movingfor > 2", 
			"!player.buff(6788)",
		}, "player" },
	}, -- We only want to run these on unlockers that can cast on unit.ground
		(function()
			if FireHack or oexecute then
				return NeP.Core.PeFetch('npconfPriestHoly', 'Feathers') 
			end
		end)  
	},

  	-- HEALTHSTONE 
		{ "#5512", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'Healthstone')) end) },
 
  	-- Dispel's
	 	{{ -- Dispell all?
			{ "527", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Disease' end) end) },-- Dispel Everything
		}, (function() return NeP.Core.PeFetch('npconfPriestHoly','Dispels') end) },

  	-- CD's
		{ "10060", "modifier.cooldowns" }, --Power Infusion
		
		{ "123040", { --Mindbender
			"player.mana < 75", 
			"target.spell(123040).range",
			 "modifier.cooldowns"
			 }, "target" },

	-- Proc's
		{ "596", { -- Prayer of healing // Divine Insigt
			"@coreHealing.needsHealing(95, 3)",
			"player.buff(123267)",
			"!player.moving",
			"modifier.party", 
			"!modifier.raid"
			}, "lowest" },
		{ "2061", { -- Flash heal // Surge of light
			"lowest.health < 100",
			"player.buff(114255)",
			"!player.moving"
			}, "lowest" },

	-- Heal Fast Bitch!!
		-- Desperate Prayer
			{ "19236",  --Desperate Prayer
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'DesperatePrayer')) end),
				"player" },

		-- Holy Word Serenity
			{ "88684", -- Holy Word Serenity
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HolyWordSerenityPlayer')) end), 
				"player" },

		-- Flash Heal
			{ "2061", { --Flash Heal
				(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealPlayer')) end),
				"!player.moving"
				}, "player" },

	-- shields
		{ "17", { --Power Word: Shield
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldPlayer')) end),
			"!player.debuff(6788).any", 
			"!player.buff(17).any"
			}, "player" },

	-- renew
		{ "139", { --renew
			(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewPlayer')) end), 
			"!player.buff(139)"
			}, "player" },
	
	{{-- Auto Dotting
		{ "32379", (function() return NeP.Lib.AutoDots(32379, 0, 20) end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots(589, 2, 100) end) }, -- SW:P 
	}, "toggle.dotEverything" },
	
	-- DPS
		-- AoE FH
		{ "48045", "target.area(10).enemies >= 3", "target" }, -- mind sear
		
		-- AoE
		{ "48045", "modifier.multitarget", "target" }, -- mind sear
			
		-- Single
		{ "129250" }, -- PW:S
		{ "589", "!target.debuff(589)", "target" }, -- SW:P
		{ "585", {  --Smite
			"!player.moving", 
			"target.spell(585).range" 
			}, "target" },

}

local outCombat = {
		
	--[[ Chakra ]]
  		{ "81208", {--Serenity
  			"player.chakra != 3",
  			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Serenity' end),
  			}, nil },

		{ "81206", {--Sanctuary
			"player.chakra != 2",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Sanctuary' end),
			}, nil },
		
		{ "81209", {--Serenity
			"player.chakra != 1",
			(function() return NeP.Core.PeFetch("npconfPriestHoly", "Chakra") == 'Chastise' end),
			}, nil },

	{{-- AOE
   		{ "34861", "@coreHealing.needsHealing(90, 3)", "lowest"}, -- Circle of Healing
		{ "121135", { -- cascade
			"@coreHealing.needsHealing(95, 3)", 
			"!player.moving"
		}, "lowest"},
		-- Divine Hymn
			{ "64843", { -- Divine Hymn
				"@coreHealing.needsHealing(50, 3)", 
				"modifier.party" 
			}},
			{ "64843", { -- Divine Hymn
				"@coreHealing.needsHealing(60, 5)", 
				"modifier.raid", 
				"!modifier.members > 10" 
			}},
			{ "64843", {  -- Divine Hymn
				"@coreHealing.needsHealing(60, 8)", 
				"modifier.raid", 
				"modifier.members > 10" 
			}},
		{ "596", (function() return NeP.Lib.Priest.PoH() end) },-- Prayer of Healing
   		{ "155245", (function() return NeP.Lib.Priest.ClarityOfPurpose() end), "lowest" },-- Clarity Of Purpose
	}, "modifier.multitarget" },
		
	-- shields 
		{ "17", { --Power Word: Shield
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldTank')) end),
			"!focus.debuff(6788).any", 
			"focus.spell(17).range", 
			"focus.spell(17).range" 
			}, "focus" },
			
		{ "17", {  --Power Word: Shield
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'ShieldTank')) end),
			"!tank.debuff(6788).any", 
			"tank.spell(17).range", 
			"modifier.party" 
			}, "tank" },
	   	
	-- heals
		{ "139", {  --renew
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'RenewRaid')) end),
			"!lowest.buff(139)"
		}, "lowest" },	
			
		{ "2061", {  --Flash Heal
			"!player.moving", 
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'FlashHealRaid')) end),
		}, "lowest" },
			
		{ "2060", { -- Heal
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('npconfPriestHoly', 'HealRaid')) end),
			"!player.moving"
		}, "lowest" },
		
	-- buffs
		{ "21562", { -- Fortitude
			(function() return NeP.Core.PeFetch('npconfPriestHoly','Buff') end),
			"!player.buffs.stamina"
		}},
	
	{{-- LoOk aT It GOoZ!!!
		{ "121536", { 
			"player.movingfor > 2", 
			"!player.buff(121557)", 
			"player.spell(121536).charges >= 1" 
		}, "player.ground" },
		{ "17", {
			"talent(2, 1)", 
			"player.movingfor > 2", 
			"!player.buff(6788)",
		}, "player" },
	}, -- We only want to run these on unlockers that can cast on unit.ground
		(function()
			if FireHack or oexecute then
				return NeP.Core.PeFetch('npconfPriestHoly', 'Feathers') 
			end
		end)  
	},

}

	
ProbablyEngine.rotation.register_custom(257, NeP.Core.GetCrInfo('Priest - Holy'), 
	{-- Dyn Change CR
		{ inCombat, "modifier.party" },
		{ solo, "!modifier.party" },
	}, 
 	outCombat, exeOnLoad)
