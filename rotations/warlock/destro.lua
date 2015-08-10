local exeOnLoad = function()
	NeP.Splash()
end

local inCombat = {
	
	-- Keybinds
		{ "Rain of Fire", "modifier.alt", "ground" },

	--Buffs
		{ "Dark Intent", "!player.buff" },
  		{ "Curse of the Elements", "!target.debuff" },

	-- Cooldowns
  		{"Dark Soul: Instability", {"modifier.shift", "modifier.cooldowns"}},
  		{"Summon Terrorguard", {"modifier.control", "modifier.cooldowns"}},
  		{"Summon Doomguard", {"modifier.control", "modifier.cooldowns"}},

	-- Moving
		{ "Incinerate", {"player.spell(Kil'jaeden's Cunning).exists", "player.moving"} },
  		{ "Fel Flame", {"!player.spell(Kil'jaeden's Cunning).exists", "player.moving"} }, 	
		
	-- AoE
		{"Fire and Brimstone", (function() return NeP.Lib.SAoE(3, 40) end), "target"},

  	-- Rotation
	  	{"Shadowburn", "target.health <=20", "target"},
	  	{"Immolate", "target.debuff(Immolate).duration <= 4", "target"},
	  	{"Conflagrate", "player.spell(Conflagrate).charges >= 2", "target"},
	  	{"Chaos Bolt", {"!lastcast(Chaos Bolt)", "player.embers >= 35"}, "target"},
		{"Chaos Bolt", "player.buff(Dark Soul: Instability)", "target"},
		{"Chaos Bolt", "player.buff(Skull Banner)", "target"},
	  	{"Conflagrate" },
	  	{"Incinerate" },


}

local outCombat = {

	--Buffs
		{ "Dark Intent", "!player.buff" },
  		{ "Curse of the Elements", "!target.debuff" },

	-- Keybinds
		{ "Rain of Fire", "modifier.alt", "ground" },

}

ProbablyEngine.rotation.register_custom(267, NeP.Core.GetCrInfo('Warlock - Destruction'),
	inCombat, outCombat, exeOnLoad)