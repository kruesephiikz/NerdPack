NeP.Interface.MonkMm = {
	key = "NePconfigMonkMm",
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

			{
				type = "spinner",
				text = "Soothing Mist STOP",
				key = "SMSTOP",
				width = 50,
				min = 0,
				max = 100,
				default = 100,
				step = 5
			},
			{
				type = "spinner",
				text = "Soothing Mist Healing",
				key = "SM",
				width = 50,
				min = 0,
				max = 100,
				default = 85,
				step = 5
			},

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},	
			
	}
}

local function Trans()
	local usable, nomana = IsUsableSpell("Transcendence: Transfer");
	local tFound = false;
	for i=1,40 do 
		local B=UnitBuff("player", i); 
		if B=="Transcendence" then tFound = true; break end 
	end
	if not usable or not tFound then return true end
	return false
end

local castBetwenUnits = function(spell)
	if UnitExists('focus') then
		Cast(spell)
		CastAtPosition(GetPositionBetweenObjects('player', 'focus', GetDistanceBetweenObjects('player', 'focus')/2))
		CancelPendingSpell()
		return true
	end
	return false
end

local _SoothingMist_Target = nil

local _SoothingMist_Health = function(ht)
	if _SoothingMist_Target ~= nil then
		local health = math.floor((UnitHealth(_SoothingMist_Target) / UnitHealthMax(_SoothingMist_Target)) * 100)
		if health <= ht then
			return true
		end
	end
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
					print('Found: '..destName)
					_SoothingMist_Target = destName
				end
			end
		end
	end)
end

local _All = {
	-- Buffs
  	{ "115921", "!player.buffs.stats"},-- Legacy of the Emperor
	
	-- Keybinds
  	{ "115313" , "modifier.shift", "tank.ground" },-- Summon Jade Serpent Statue
	
	-- FREEDOOM!
	{ "137562", "player.state.disorient" }, -- Nimble Brew = 137562
	{ "116841", "player.state.disorient" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.fear" }, -- Nimble Brew = 137562
	{ "116841", "player.state.stun" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.stun" }, -- Nimble Brew = 137562
	{ "137562", "player.state.root" }, -- Nimble Brew = 137562
	{ "116841", "player.state.root" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.horror" }, -- Nimble Brew = 137562
	{ "137562", "player.state.snare" }, -- Nimble Brew = 137562
	{ "116841", "player.state.snare" }, -- Tiger's Lust = 116841
	{"119996", "player.health < 35"}, --Transcendence: Transfer
	{"Transcendence", {
		(function() return Trans() end), 
		"toggle.trans"
	}},
}

local inCombatSerpente = {

	-- FIX ME: Need to recast the statue if far away...

	-- Summon Jade Serpent Statue
  	{ "115313" , {
		"!player.totem(Jade Serpent Statue)",
		(function() return castBetwenUnits("115313") end)
	}},
	
	{{ -- Dispell all?
		{ "115450", (function() return NeP.Lib.Dispell(
			function() return dispelType == 'Magic' or dispelType == 'Posion' or dispelType == 'Disease' end
		) end) },
	}},

	{{-- Cooldowns
		{ "116849", "lowest.health <= 25" },-- Life Coccon
	}, "modifier.cooldowns" },

	{{ -- Soothing Mist Healing
	
		-- Cancel SoothingMistHealing (Max Health)
		{ "/stopcasting", (function() return not _SoothingMist_Health(NeP.Core.PeFetch('NePconfigMonkMm', 'SMSTOP')) end) }, 	
		-- Cancel SoothingMistHealing (Someone else needs more) (MIN HEALTH 60%)
		{ "/stopcasting", (function() if not _SoothingMist_Health(60) then return NeP.Core.dynamicEval("lowest.health < "..math.floor((UnitHealth(_SoothingMist_Target) / UnitHealthMax(_SoothingMist_Target)) * 100)) end end)},
		{ "124682", { -- Enveloping Mist (Dump Chi)
			"player.chi >= 5",
			(function() return _SoothingMist_Health(95) end)
		}, "lowest" },
		{ "124682", { -- Enveloping Mist
			"player.chi >= 3",
			(function() return _SoothingMist_Health(70) end)
		}, "lowest" },
		{ "115151", { -- Renewing Mist
			(function() return NeP.Core.dynamicEval(_SoothingMist_Target..".buff(119611).duration <= 2") end),
			(function() return _SoothingMist_Health(95) end),
		}}, 
		{ "116694", { -- Surging Mist
			(function() return _SoothingMist_Health(90) end)
			"player.chi < 5"
		}},
		
	}, "player.casting(115175)" },
	
	{{ -- Normal Healing
	
		{{ -- Survival 
			{ "115072", { -- Expel Harm
				"player.health <= 80", 
				"player.chi < 5",
				"!player.glyph(146950)"
			}},
			{ "115203", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
			  "player.health < 30",
			  "!player.buff(122783)", -- Diffuse Magic
			  "!player.buff(122278) "-- Dampen Harm
			}}, 
			{ "#5512", "player.health < 40" }, -- Healthstone
		}, "player.health < 100" },
		
		{{ -- AoE
			{ "115098", "@coreHealing.needsHealing(90, 3)", "lowest" }, -- Chi Wave
			{ "115310", "@coreHealing.needsHealing(60, 3)" }, -- Revival
			{ "116680", { -- Uplift with Thunder Focus Tea Condition
				"@coreHealing.needsHealing(80, 3)",
				"player.chi >= 3", 
				"!player.buff(116680)"
			}},
		}, "modifier.multitarget" },
		
		-- Renewing Mist
		{ "115151", {
			"lowest.buff(119611).duration <= 2",
			"lowest.health <= 80",
		}}, 
		
		-- Expel Harm (Glyped)
		{ "115072", { 
			"lowest.health <= 80", 
			"lowest.chi < 5",
			"player.glyph(146950)"
		}, "lowest" },
		
		{{ -- Not Moving
			-- Soothing Mist
			{ "115175", (function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfigMonkMm', 'SM')) end), "lowest" },
			{ "124682", { -- Enveloping Mist(Dump CHI)
				"player.chi >= 5",
				"lowest.health < 95"
			}, "lowest" },
			{ "124682", { -- Enveloping Mist
				"player.chi >= 3",
				"lowest.health < 70"
			}, "lowest" },
			{ "116694", { -- Surging Mist
				"lowest.health < 85",
				"player.chi < 5"
			}},
		}, "!player.moving" },
		
	}, "!player.casting(115175)" },
}

local inCombatCrane = {
	{{-- Cooldowns
		{ "116849", "lowest.health <= 25" },-- Life Coccon
	}, "modifier.cooldowns" },

		
	{{-- Survival
		{ "115072", { "player.health <= 80", "player.chi < 5" }}, -- Expel Harm
		{ "115098", "player.health <= 75" }, -- Chi Wave
		{ "115203", { -- Forifying Brew at < 30% health and when DM & DH buff is not up
		  "player.health < 30",
		  "!player.buff(122783)", -- Diffuse Magic
		  "!player.buff(122278)"-- Dampen Harm
		}}, 
		{ "#5512", "player.health < 40" }, -- Healthstone
	}, "player.health < 100" },
	
	-- TO BE DONE...
}

local outCombat = {
	-- heals
	{ "115151", { -- Renewing Mist
		"lowest.buff(119611).duration <= 2", 
		"lowest.health < 100"
	}, "lowest"}, 
	  { "115175", {-- Soothing Mist
	  	(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfigMonkMm', 'SM')) end), 
	  	"!player.moving"
	}, "lowest" },
	{"Transcendence", (function() return Trans() end) },
}

local _SharedIncombat = {
	-- Give me Mana
	{ "115294", { -- mana tea
		"player.mana < 95", 
		"player.buff(115867).count >= 2" 
	}},
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
}

ProbablyEngine.rotation.register_custom(270, NeP.Core.GetCrInfo('Monk - Mistweaver'), 
	{ -- In-Combat Change CR dyn
		{_All},
		{_SharedIncombat},
		{ inCombatSerpente, "player.stance = 1" }, -- Serpent Stance
		{ inCombatCrane, "player.stance = 2" }, -- Crane Stance
	},
  	{ -- Out-Combat
		{_All},
		{outCombat}
	}, exeOnLoad)