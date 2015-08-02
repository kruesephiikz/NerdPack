local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'cleavemode', 
		'Interface\\Icons\\spell_nature_chainlightning', 'Enable Cleaves', 
		'Enables casting of earthquake and chain lightning for cleaves.')
	ProbablyEngine.toggle.create(
		'mouseovers', 
		'Interface\\Icons\\spell_fire_flameshock', 
		'Enable Mouseovers', 
		'Enable flameshock on mousover targets.')
	ProbablyEngine.toggle.create(
		'smartae', 
		'Interface\\Icons\\spell_holy_sealofrighteousness', 
		'Enable Smart AE', 
		'Enable automatic detection of AE and cleave rotations.')
	ProbablyEngine.toggle.create(
		'burn', 
		'Interface\\Icons\\spell_holy_sealofblood', 
		'Single Target Burn', 
		'Force single target rotation for burn phases.')
end

local combat_rotation = {
	-- Rotation Utilities
	{ "pause", "modifier.lalt" },


{{ -- Not Burn

	-- Buffs
	{ "Lightning Shield", "!player.buff(Lightning Shield)" },

	-- Mouseovers
	{ "Earthquake", "modifier.lcontrol", "mouseover.ground" },
	{ "Cleanse Spirit", { 
		"modifier.lshift", 
		"!lastcast(Cleanse Spirit)", 
		"mouseover.exists", 
		"mouseover.alive", 
		"mouseover.friend", 
		"mouseover.range <= 40", 
		"mouseover.dispellable(Cleanse Spirit)" 
	}, "mouseover" },
	
	{{-- Interrupt
		{ "Wind Shear" },
	}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },

	-- Dispell
	{{ -- Dispell all?
		{ "77130", (function() return NeP.Lib.Dispell(function() return dispelType == 'Curse' end) end) },
	}, (function() return NeP.Core.PeFetch('npconfShamanEle', 'Dispells') end) },

	-- Self Heals
	{ "Healing Surge", { 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanEle', 'healingsurge_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'healingsurge_check') end) 
	}},
	{ "Healing Stream Totem", { 
		"!player.totem(Healing Stream Totem)", 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanEle', 'healingstreamtotem_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'healingstreamtotem_check') end) 
	}},
	{ "#5512", {-- Healthstone (5512)
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanEle', 'healthstone_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'healthstone_check') end)
	}}, 

 	--Survival Abilities
	{ "Ancestral Guidance", { 
		"player.buff(Ascendance)", 
		"player.buff(Spiritwalker's Grace)", 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'guidance') end) 
	}},	
 	{ "Windwalk Totem", { 
 		"!player.buff", 
 		"player.state.root", 
 		"!player.totem(Windwalk Totem)", 
 		(function() return NeP.Core.PeFetch('npconfShamanEle', 'windwalktotem') end) 
 	}}, 
	{ "Windwalk Totem", { 
		"!player.buff", 
		"player.state.snare", 
		"!player.totem(Windwalk Totem)", 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'windwalktotem') end) 
	}}, 
	{ "Shamanistic Rage", { 
		"player.state.stun", 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'shamrage') end) 
	}},
	{ "Tremor Totem", { 
		"!player.buff", 
		"player.state.fear", 
		"!player.totem(Tremor Totem)", 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'tremortotem') end) 
	}},
	
	{{	-- Proximity Survival
		{ "Earthbind Totem", { 
			"!player.totem(Earthbind Totem)", 
			"!talent(2, 2)", 
			(function() return NeP.Core.PeFetch('npconfShamanEle', 'earthbind') end) 
		}},
  		{ "Earthgrab Totem", { 
  			"!player.totem(Earthbind Totem)", 
  			"talent(2, 2)", 
  			(function() return NeP.Core.PeFetch('npconfShamanEle', 'earthbind') end) 
  		}},
		{ "Frostshock", { 
			"talent(2, 1)", 
			"target.debuff(Flame Shock)", 
			(function() return NeP.Core.PeFetch('npconfShamanEle', 'frostshock') end) 
		}},  
		{ "Thunderstorm", (function() return NeP.Core.PeFetch('npconfShamanEle', 'thunderstorm') end) }
	}, "player.area(8).enemies >= 1" },
	
	-- Control Toggles
	{ "Flame Shock", { 
		"!modifier.multitarget", 
		"mouseover.enemy", 
		"mouseover.alive", 
		"mouseover.debuff(Flame Shock).duration <= 9", 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'flameshock') end) 
	}, "mouseover" },

}, "!toggle.burn" }, --Force single target rotation
	
{{	-- Cooldowns
	{ "Ancestral Swiftness" },  
	{ "Fire Elemental Totem" }, 
	{ "Storm Elemental Totem" },  
	{ "Elemental Mastery" },  
	{ "#trinket1", "player.buff(Ascendance)" }, 
	{ "#trinket2", "player.buff(Ascendance)" }, 
	{ "Ascendance", "!player.buff(Ascendance)" }
}, "modifier.cooldowns" },

{{ -- Burn
	{{	-- Movement Rotation
		{ "Spiritwalker's Grace", "player.buff(Ascendance)" },
		{ "Spiritwalker's Grace", "glyph(Glyph of Spiritwalker's Focus)" },
		{ "Unleash Flame" },
		{ "Lava Burst", "player.buff(Lava Surge)" },
		{ "Flame Shock", { 
			"player.buff(Unleash Flame)", 
			"target.debuff(Flame Shock).duration < 19" 
		}},
		{ "Flame Shock", "target.debuff(Flame Shock).duration < 9" },
		{ "Earth Shock" },
		{ "Searing Totem", { 
			"!player.totem(Fire Elemental Totem)", 
			"!player.totem(Searing Totem)", 
			"target.ttd >= 10"
		}},
		
		{ "Chain Lightning", { 
			"modifier.multitarget", 
			"player.buff(Ancestral Swiftness)" 
		}},
		{ "Chain Lightning", { 
			"target.area(6).enemies >= 4", 
			"player.buff(Ancestral Swiftness)" 
		}},
		{ "Lava Burst", "player.buff(Ancestral Swiftness)" },
		{ "Elemental Blast", "player.buff(Ancestral Swiftness)" }
	}, { "player.moving", "!player.buff(Spiritwalker's Grace)" } },
				
	{{	-- AoE
		{ "Lava Beam", "player.buff(Ascendance)" },
		{ "Chain Lightning", "!player.buff(Improved Chain Lightning)" },
		{ "Earthquake", "player.buff(Improved Chain Lightning)", "target.ground" },
		{ "Earth Shock", { 
			"player.buff(Lightning Shield)", 
			"player.buff(Lightning Shield).count >= 18" 
		}},
		{ "Chain Lightning" }
	}, "modifier.multitarget" },

	{{	-- Smart AoE
		{ "Lava Beam", "player.buff(Ascendance)" },
		{ "Chain Lightning", "!player.buff(Improved Chain Lightning)" },
		{ "Earthquake", "player.buff(Improved Chain Lightning)", "target.ground" },
		{ "Earth Shock", { 
			"player.buff(Lightning Shield)", 
			"player.buff(Lightning Shield).count >= 18" 
		}},
		{ "Chain Lightning" }
	}, { "toggle.smartae", "target.area(8).enemies >= 5" } },

	{{	-- Cleave
		{ "Chain Lightning", { 
			"!player.buff(Improved Chain Lightning)", 
			"player.spell(Earthquake).cooldown < 1" 
		}},
		{ "Earthquake", "player.buff(Improved Chain Lightning)", "target.ground" },
	}, { "toggle.cleavemode" } },

	{{	-- SmartAE Cleave 2
		{ "Chain Lightning", { 
			"!player.buff(Improved Chain Lightning)", 
			"player.spell(Earthquake).cooldown < 1" 
		}},
		{ "Earthquake", "player.buff(Improved Chain Lightning)", "target.ground" },
	}, { "target.area(8).enemies >= 2", "toggle.smartae" } },

}, "!toggle.burn" }, --Force single target rotation

	-- Main Rotation
	{ "Flame Shock", "!target.debuff(Flame Shock)" },
	{ "Unleash Flame", "talent(6, 1)" },
	{ "Lava Burst" },
	{ "Elemental Blast" },  
	{ "Earth Shock", { 
		"player.buff(Lightning Shield)", 
		"player.buff(Lightning Shield).count >= 15", 
		"target.debuff(Flame Shock).duration >= 9" 
	}},
	{ "Flame Shock", "target.debuff(Flame Shock).duration < 9" },
	{ "Searing Totem", { 
		"!player.totem(Fire Elemental Totem)", 
		"!player.totem(Searing Totem)", 
		"target.ttd >= 10"
	}},
	{ "Chain Lightning", { 
		"target.area(8).enemies >= 4", 
		"toggle.smartae", 
		"!toggle.burn" 
	}},
	{ "Chain Lightning", { 
		"toggle.cleavemode", 
		"!toggle.burn" 
	}},
	{ "Lightning Bolt" },
}

local oocRotation = {

	-- Buffs
	{ "Lightning Shield", "!player.buff(Lightning Shield)" },

	-- Heals
	{ "Healing Surge", { 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('npconfShamanEle', 'healingsurgeOCC_spin')) end), 
		(function() return NeP.Core.PeFetch('npconfShamanEle', 'healingsurgeOCC_check') end) 
	}},
}

ProbablyEngine.rotation.register_custom(262, NeP.Core.CrInfo(), 
	combat_rotation, oocRotation, exeOnLoad)