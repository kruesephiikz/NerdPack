local exeOnLoad = function()
	NeP.Splash()
end

local _General = {
	-- Keybinds
	{ "Rain of Fire", "modifier.alt", "ground" },

	--Buffs
	{ "Dark Intent", "!player.buff" },
	{ "Curse of the Elements", "!target.debuff" },
}

local _Cooldowns = {
	{"Dark Soul: Instability", "modifier.shift"},
  	{"Summon Terrorguard", "modifier.control"},
  	{"Summon Doomguard", "modifier.control"},
}

local _Moving = {
	{ "Incinerate", {
		"player.spell(Kil'jaeden's Cunning).exists", 
		"player.moving"
	}, "target" },
  	{ "Fel Flame", {
		"!player.spell(Kil'jaeden's Cunning).exists", 
		"player.moving"
	}, "target" }, 
}

local inCombat = {
	-- AoE
	{"Fire and Brimstone", (function() return NeP.Core.SAoE(3, 40) end), "target"},

  	-- Rotation
	{"Shadowburn", "target.health <=20", "target"},
	{"Immolate", "target.debuff(Immolate).duration <= 4", "target"},
	{"Conflagrate", "player.spell(Conflagrate).charges >= 2", "target"},
	{"Chaos Bolt", {
		"!lastcast(Chaos Bolt)", 
		"player.embers >= 35"
	}, "target"},
	{"Chaos Bolt", "player.buff(Dark Soul: Instability)", "target"},
	{"Chaos Bolt", "player.buff(Skull Banner)", "target"},
	{"Conflagrate" },
	{"Incinerate" },
}

local outCombat = {

}

ProbablyEngine.rotation.register_custom(267, NeP.Core.GetCrInfo('Warlock - Destruction'),
	{ -- In-Combat
		{_Moving, "player.moving"},
		{{ -- Conditions
			{_Cooldowns, "modifier.cooldowns"},
			{inCombat}
		}, "!player.moving" },
	},{ -- Out-Combat
		{_General},
		{outCombat}
	}, exeOnLoad)