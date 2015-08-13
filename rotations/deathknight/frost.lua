local _DarkSimUnit = function(unit)
	local _darkSimSpells = {
		-- Siege of Orgrimmar
		"Froststorm Bolt",
		"Arcane Shock",
		"Rage of the Empress",
		"Chain Lightning",
		-- PvP
		"Hex",
		"Mind Control",
		"Cyclone",
		"Polymorph",
		"Pyroblast",
		"Tranquility",
		"Divine Hymn",
		"Hymn of Hope",
		"Ring of Frost",
		"Entangling Roots"
	}
	for index,spellName in pairs(_darkSimSpells) do
		if ProbablyEngine.condition["casting"](unit, spellName) then
			return true 
		end
	end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'defcd', 
		'Interface\\Icons\\Spell_deathknight_iceboundfortitude.png', 
		'Defensive Cooldowns', 
		'Enable or Disable Defensive Cooldowns.')
	ProbablyEngine.toggle.create(
		'run', 
		'Interface\\Icons\\Inv_boots_plate_dungeonplate_c_05.png', 
		'Enable Unholy Presence Outside of Combat', 
		'Enable/Disable Unholy Presence Outside of Combat \nMakes you run/fly faster when outside of combat.')
end

local inCombat = {

	-- Keybinds
	{ "42650", "modifier.alt" }, -- Army of the Dead
	{ "49576", "modifier.control" }, -- Death Grip
	{ "43265", "modifier.shift", "target.ground" }, -- Death and Decay
	{ "152280", "modifier.shift", "target.ground" }, -- Defile
	
	-- Presence
	{ "48266", "player.seal != 2" }, -- frost
	
	--Racials
        -- Dwarves
		{ "20594", "player.health <= 65" },
		-- Humans
		{ "59752", "player.state.charm" },
		{ "59752", "player.state.fear" },
		{ "59752", "player.state.incapacitate" },
		{ "59752", "player.state.sleep" },
		{ "59752", "player.state.stun" },
		-- Draenei
		{ "28880", "player.health <= 70", "player" },
		-- Gnomes
		{ "20589", "player.state.root" },
		{ "20589", "player.state.snare" },
		-- Forsaken
		{ "7744", "player.state.fear" },
		{ "7744", "player.state.charm" },
		{ "7744", "player.state.sleep" },
		-- Goblins
		{ "69041", "player.moving" },

	-- Buffs
	{ "57330", "!player.buffs.attackpower" }, -- Horn of Winter

	-- Items
	{ "#5512", "player.health < 70" }, --healthstone

	{{-- Def cooldowns // heals
		{ "48792", "player.health <= 40", "player" }, -- Icebound Fortitude
		{ "48743", "player.health <= 50" }, -- Death Pact
		{{ -- Runic Power for LB
			{ "49039", { -- Lichborne //fear
				"player.state.fear", 
				"player.spell.exists(49039)" 
			}}, 
			{ "49039", { -- Lichborne //sleep
				"player.state.sleep", 
				"player.spell.exists(49039)" 
			}}, 
			{ "49039", { -- Lichborne //charm
				"player.state.charm", 
				"player.spell.exists(49039)" 
			}},
		}, "player.runicpower >= 40" },
		{ "108196", "player.health < 60" }, -- Death Siphon
	}, "toggle.defcd" },

	{{-- Cooldowns
		--{ "61999", "player.health <= 30", "mouseover" }, -- Raise Ally
		{ "47568", { -- Empower Rune Weapon 
			"player.runes(death).count < 1", 
			"player.runes(frost).count < 1", 
			"player.runes(unholy).count < 1", 
			"player.runicpower < 30" 
		}}, 
		{ "51271" }, -- Pilar of frost
		{ "115989", "target.debuff(55095)" }, -- Unholy Blight
		{ "115989", "target.debuff(55078)" }, -- Unholy Blight
		{ "#gloves"},
	}, "modifier.cooldowns" },

	{{-- Interrupts
		{ "47528" }, -- Mind freeze
		{ "47476", "!lastcast(47528)", "target" }, -- Strangulate
		{ "108194", "!lastcast(47528)", "target" }, -- Asphyxiate
	}, "target.NePinterrupt" },

	-- Spell Steal
	{ "77606", (function() return _DarkSimUnit('target') end), "target" }, -- Dark Simulacrum
	{ "77606", (function() return _DarkSimUnit('focus') end), "focus" },  -- Dark Simulacrum

	-- Plague Leech
	{ "123693", {
		"target.debuff(55095)",-- Target With Frost Fever
		"target.debuff(55078)",-- Target With Blood Plague
		"player.runes(unholy).count = 0",-- With 0 Unholy Runes
		"player.runes(frost).count = 0",-- With 0 Frost Runes
		"player.runes(death).count = 0",-- With 0 Death Runes
		"!lastcast(123693)"
	}}, 

	-- Diseases
	{ "77575", "target.debuff(55095).duration < 2" }, -- Outbreak
	{ "77575", "target.debuff(55078).duration < 2" }, -- Outbreak
	{ "45462", "target.debuff(55078).duration < 2", "target" }, -- Plague Strike

	-- Soul Reaper
	{ "114866", "target.health < 35", "target"  },
	
	-- AoE
	{ "49184", (function() return NeP.Lib.SAoE(3, 40) end), "target" }, -- Howling Blast

	{{ -- 1-hand
		{ "49143", "player.buff(51128)", "target"  },-- Frost Strike / Killing Machine
	    { "49143", "player.runicpower >= 80", "target" },-- Frost Strike
	    { "49184", "player.runes(death).count > 1", "target"  },-- Howling Blast
	    { "49184", "player.runes(frost).count > 1", "target" },-- Howling Blast
	    { "49184", "player.buff(59052)", "target"  }, -- Howling Blast / Freezing Fog
	    { "49143", "player.runicpower > 76", "target"  },-- Frost Strike
	    { "49998", "player.buff(Dark Succor)", "target"  }, -- Death Strike
	    { "49998", "player.health <= 65", "target"  }, -- Death Strike
	    { "49020", { -- Obliterate
			"player.runes(unholy).count > 0", 
			"!player.buff(51128)" -- Killing Machine
		}, "target" }, 
	    { "49184" },--Howling Blast
	    { "49143", "player.runicpower >= 40", "target" },-- Frost Strike
	 }, "player.onehand" },

	{{ -- 2-Hand
	    { "49184", "player.buff(59052)" }, -- Howling Blast / Freezing Fog
	    -- If player less then 65% health
			{ "49998", {
				"player.buff(51128)", -- Killing Machine
				"player.health < 65"
			}, "target" }, -- Death Strike
	        { "49998", {
				"player.runicpower <= 75", 
				"player.health < 65"
			}, "target" }, -- Death Strike
		-- If player more then 65% health
		    { "49020", { -- Obliterate
				"player.buff(51128)", -- Killing Machine
				"player.health > 65"
			}, "target" },
			{ "49020", { -- Obliterate
				"player.runicpower <= 75", 
				"player.health > 65"
			}, "target" }, -- Obliterate
	    { "49143", "!player.buff(51128)", "target" }, -- Frost Strike / Killing Machine
	    { "49143", "player.spell(49020).cooldown >= 4", "target" }, -- Frost Strike
	}, "player.twohand" },
	
	
	{{ -- Blood Tap
		{ "45529", "player.runes(unholy).count = 0" }, --Blood Tap
		{ "45529", "player.runes(frost).count = 0" }, -- Blood Tap
		{ "45529", "player.runes(blood).count = 0" }, -- Blood Tap
	},{ 
		"player.buff(Blood Charge).count >= 5", 
		"player.runes(death).count = 0", 
		"!lastcast(45529)"
	}},
  
}

local outCombat = {

	-- Buffs
	{ "48266", { -- frost
		"player.seal != 2 ", 
		"!toggle.run" 
	}}, 
	{ "48265", { -- unholy // moves faster out of combat...
		"player.seal != 3", 
		"toggle.run" 
	}}, 
	{ "57330", "!player.buffs.attackpower" }, -- Horn of Winter
  
}

ProbablyEngine.rotation.register_custom(251, NeP.Core.GetCrInfo('Deathknight - Frost'), 
	inCombat, outCombat, exeOnLoad)