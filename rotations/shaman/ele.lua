NeP.Addon.Interface.ShamanEle = {
	key = "npconfShamanEle",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Shaman Elemental Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
				{
					type = "checkbox",
					default = false,
					text = "Flameshock mouseover target",
					key = "flameshock",
				}, 
				{type = "rule"},
				{
					type = "text",
					text = "Self Healing",
					align = "center",
				},
				{
					type = "checkspin",
					text = "Healthstone",
					key = "healthstone",
					default_spin = 30,
					default_check = true,
				},
				{
					type = "checkspin",
					text = "Healing Stream Totem",
					key = "healingstreamtotem",
					default_spin = 40,
					default_check = false,
				},
				{
					type = "checkspin",
					text = "Healing Surge",
					key = "healingsurge",
					default_spin = 30,
					default_check = true,
				},
				{
					type = "checkspin",
					text = "Healing Surge Out of Combat",
					key = "healingsurgeOCC",
					default_spin = 90,
					default_check = true,
				},
				{type = "rule"},
				{
					type = "text",
					text = "Self Survivability",
					align = "center",
				},
				{
					type = "checkbox",
					default = true,
					text = "Cleanse Spirit",
					key = "cleansespirit",
				},
				{
					type = "checkbox",
					default = true,
					text = "Tremor Totem",
					key = "tremortotem",
				},
				{
					type = "checkbox",
					default = true,
					text = "Windwalk Totem",
					key = "windwalktotem",
				},
				{
					type = "checkbox",
					default = false,
					text = "Shamanistic Rage",
					key = "shamrage",
					desc = "Cast Shamanistic Rage when stunned."
				},
				{
					type = "checkbox",
					default = false,
					text = "Ancestral Guidance",
					key = "guidance",
					desc = "Cast Ancestral Guidance when Ascendance and Spirit Walker's Grace are active."
				},
				{type = "rule"},
				{
					type = "text",
					text = "Proximity Spells",
					align = "center",
				},
				{
					type = "checkbox",
					default = false,
					text = "Earthbind / Earthgrab",
					key = "earthbind",
				},	
				{
					type = "checkbox",
					default = false,
					text = "Thunderstorm",
					key = "thunderstorm",
				},
				{
					type = "checkbox",
					default = false,
					text = "Frostshock",
					key = "frostshock",
					desc = "Requiers talent 'Frozen Power'."
				},
				{type = "rule"},
				{
					type = "text",
					text = "Hotkeys",
					align = "center",
				},		
				{
					type = "text",
					text = "Left Control: Earthquake mouseover location",
					align = "left",
				},
				{
					type = "text",
					text = "Left Shift: Cleanse on mouseover target",
					align = "left",
				},
				{
					type = "text",
					text = "Left Alt: Pause Rotation",
					align = "left",
				},
			}
}

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
	}, (function() return NeP.Core.PeFetch('npconf','Dispell') end) },

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
	}, (function() return NeP.Lib.SAoE(2, 8) end) },
	
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
			(function() return NeP.Lib.SAoE(4, 8) end), 
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
	}, (function() return NeP.Lib.SAoE(8, 5) end) },

	{{	-- Cleave
		{ "Chain Lightning", { 
			"!player.buff(Improved Chain Lightning)", 
			"player.spell(Earthquake).cooldown < 1" 
		}},
		{ "Earthquake", "player.buff(Improved Chain Lightning)", "target.ground" },
	}, { "toggle.cleavemode" } },

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
		(function() return NeP.Lib.SAoE(4, 8) end), 
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

ProbablyEngine.rotation.register_custom(262, NeP.Core.GetCrInfo('Shamman - Elemental'), 
	combat_rotation, oocRotation, exeOnLoad)