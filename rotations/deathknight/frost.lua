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
end

local _All = {

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
}

local _Cooldowns = {
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
}

local _Survival = {
	-- Items
	{ "#5512", "player.health < 70" }, --healthstone

	-- Def cooldowns // heals
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
}

local _outBreak = {
	{ "Outbreak", {
		"target.debuff(Frost Fever).duration < 3", 
		"target.debuff(Blood Plague).duration < 3", 
	}, "target" },
}


local _bloodTap = {
	{{ -- Blood Tap
		{ "45529", "player.runes(unholy).count = 0" }, --Blood Tap
		{ "45529", "player.runes(frost).count = 0" }, -- Blood Tap
		{ "45529", "player.runes(blood).count = 0" }, -- Blood Tap
	}, "player.buff(Blood Charge).count >= 5" },
}

local _plagueLeech = {
	{{ 
		{{
			{ "Plague Leech", "player.runes(unholy) <= 1" },
			{ "Plague Leech", "player.runes(frost) <= 1" },
			{ "Plague Leech", "player.runes(blood) <= 1" },
		}, "player.spell(Outbreak).cooldown = 0" },
		{{
			{ "Plague Leech", "player.runes(unholy) <= 1" },
			{ "Plague Leech", "player.runes(frost) <= 1" },
			{ "Plague Leech", "player.runes(blood) <= 1" },
		}, "target.debuff(Blood Plague).duration < 3" },
	},{ "target.debuff(Blood Plague)", "target.debuff(Frost Fever)" }},
}

local _oneHand_AoE = {

}

local _oneHand_ST = {
	{ "Frost Strike", "player.buff(Killing Machine)", "target" },
	{ "Frost Strike", "player.runicpower > 75", "target" },
	{ "Howling Blast ", "player.buff(Rime)", "target" },
	{ "Howling Blast", "player.buff(Freezing Fog)" },
	{ "Howling Blast", "player.runes(death) >= 1", "target" },
	{ "Howling Blast", "player.runes(frost) >= 1", "target" },
	{ "Obliterate", "player.runes(unholy) >= 1", "target" },
	{ "Frost Strike", nil, "target" },
}

local _twoHand_AoE = {

}

local _twoHand_ST = {
	{ "Obliterate", "player.buff(Killing Machine)", "target" },
	{ "Obliterate", {
		"player.runes(unholy) >= 1",
		"player.runes(frost) >= 1",
	}, "target" },
	{ "Frost Strike", "player.runicpower > 75", "target" },
	{ "Howling Blast ", "player.buff(Rime)", "target" },
	{ "Howling Blast", "player.buff(Freezing Fog)" },
	{ "Frost Strike", nil, "target" },
}

ProbablyEngine.rotation.register_custom(251, NeP.Core.GetCrInfo('Deathknight - Frost'), 
	{ -- In-Combat
		{_All},
		{_Survival},
		{{-- Interrupts
			{ "47528" }, -- Mind freeze
			{ "47476", "!lastcast(47528)", "target" }, -- Strangulate
			{ "108194", "!lastcast(47528)", "target" }, -- Asphyxiate
		}, "target.NePinterrupt" },
		{ "77606", (function() return _DarkSimUnit('target') end), "target" }, -- Dark Simulacrum
		{ "77606", (function() return _DarkSimUnit('focus') end), "focus" }, -- Dark Simulacrum
		{_Cooldowns, "modifier.cooldowns"},
		{_outBreak},
		{ "Soul Reaper", "target.health < 35", "target" },
		{ _plagueLeech },
		{{ -- 1 Hand
			{_oneHand_AoE, (function() return NeP.Lib.SAoE(3, 10) end)},
			{_oneHand_ST}
		}, "player.onehand" },
		{{ -- 2 Hand
			{_twoHand_AoE, (function() return NeP.Lib.SAoE(3, 10) end)},
			{_twoHand_ST}
		}, "player.twohand" },
		{{ -- Blood Tap
		{ "45529", "player.runes(unholy).count = 0" }, --Blood Tap
		{ "45529", "player.runes(frost).count = 0" }, -- Blood Tap
		{ "45529", "player.runes(blood).count = 0" }, -- Blood Tap
		},{ 
			"player.buff(114851).count >= 5", -- Blood Charge
			"player.runes(death).count = 0", 
			"!lastcast(45529)"
		}},
	}, _All, exeOnLoad)