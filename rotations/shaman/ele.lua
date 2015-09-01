NeP.Interface.ShamanEle = {
	key = "NePConfShamanEle",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
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
end

local _Cooldowns = {
	{ "Ancestral Swiftness" },  
	{ "Fire Elemental Totem" }, 
	{ "Storm Elemental Totem" },  
	{ "Elemental Mastery" },  
	{ "#trinket1", "player.buff(Ascendance)" }, 
	{ "#trinket2", "player.buff(Ascendance)" }, 
	{ "Ascendance", "!player.buff(Ascendance)" }
}

local _Moving = {
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
}

local _Cleave = {
	{ "Chain Lightning" },
	{ "Chain Lightning", { 
		"!player.buff(Enhanced Chain Lightning)", 
		"player.spell(Earthquake).cooldown < 1" 
	}},
	{ "Earthquake", "player.buff(Enhanced Chain Lightning)", "target.ground" },
}

local _AoE = {
	{ "Lava Beam", "player.buff(Ascendance)" },
	{ "Chain Lightning", "!player.buff(Enhanced Chain Lightning)" },
	{ "Earthquake", "player.buff(Enhanced Chain Lightning)", "target.ground" },
	{ "Earth Shock", { 
		"player.buff(Lightning Shield)", 
		"player.buff(Lightning Shield).count >= 18" 
	}},
	{ "Chain Lightning" },
}

local _mouseOvers = {
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
	{ "Flame Shock", { 
		"!modifier.multitarget", 
		"mouseover.enemy", 
		"mouseover.alive", 
		"mouseover.debuff(Flame Shock).duration <= 9", 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'flameshock') end) 
	}, "mouseover" },
}

local _ALL = {
	-- Buffs
	{ "Lightning Shield", "!player.buff(Lightning Shield)" },
	
	-- Self Heals
	{ "Healing Surge", { 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfShamanEle', 'healingsurge_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'healingsurge_check') end) 
	}},
	{ "Healing Stream Totem", { 
		"!player.totem(Healing Stream Totem)", 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfShamanEle', 'healingstreamtotem_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'healingstreamtotem_check') end) 
	}},
	{ "#5512", {-- Healthstone (5512)
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfShamanEle', 'healthstone_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'healthstone_check') end)
	}}, 
}

local _Survival = {
	{ "Ancestral Guidance", { 
		"player.buff(Ascendance)", 
		"player.buff(Spiritwalker's Grace)", 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'guidance') end) 
	}},	
 	{ "Windwalk Totem", { 
 		"!player.buff", 
 		"player.state.root", 
 		"!player.totem(Windwalk Totem)", 
 		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'windwalktotem') end) 
 	}}, 
	{ "Windwalk Totem", { 
		"!player.buff", 
		"player.state.snare", 
		"!player.totem(Windwalk Totem)", 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'windwalktotem') end) 
	}}, 
	{ "Shamanistic Rage", { 
		"player.state.stun", 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'shamrage') end) 
	}},
	{ "Tremor Totem", { 
		"!player.buff", 
		"player.state.fear", 
		"!player.totem(Tremor Totem)", 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'tremortotem') end) 
	}},
	{{	-- Proximity Survival
		{ "Earthbind Totem", { 
			"!player.totem(Earthbind Totem)", 
			"!talent(2, 2)", 
			(function() return NeP.Core.PeFetch('NePConfShamanEle', 'earthbind') end) 
		}},
  		{ "Earthgrab Totem", { 
  			"!player.totem(Earthbind Totem)", 
  			"talent(2, 2)", 
  			(function() return NeP.Core.PeFetch('NePConfShamanEle', 'earthbind') end) 
  		}},
		{ "Frostshock", { 
			"talent(2, 1)", 
			"target.debuff(Flame Shock)", 
			(function() return NeP.Core.PeFetch('NePConfShamanEle', 'frostshock') end) 
		}},  
		{ "Thunderstorm", (function() return NeP.Core.PeFetch('NePConfShamanEle', 'thunderstorm') end) }
	}, (function() return NeP.Lib.SAoE(2, 8) end) },
}

local inCombat = {
	{{-- Interrupt
		{ "Wind Shear" },
	}, "target.NePinterrupt" },

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
	{ "Lightning Bolt" },
}

local outCombat = {
	{ "Healing Surge", { 
		(function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfShamanEle', 'healingsurgeOCC_spin')) end), 
		(function() return NeP.Core.PeFetch('NePConfShamanEle', 'healingsurgeOCC_check') end) 
	}},
}

ProbablyEngine.rotation.register_custom(262, NeP.Core.GetCrInfo('Shamman - Elemental'), 
	{ -- In-Combat
		{ "pause", "modifier.lalt" },
		{_Moving, { "player.moving", "!player.buff(Spiritwalker's Grace)" }},
		{{ -- Conditions
			{_ALL},
			{_Cooldowns},
			{_Survival},
			{_mouseOvers, "toggle.mouseovers"},
			{_AoE, (function() return NeP.Lib.SAoE(8, 5) end)},
			{_Cleave, "toggle.cleavemode"},
			{inCombat},
		}, { "!player.moving", --[[INSERT BUFF CHECK FOR WOLF]] } },
	},{ -- Out-Combat
		{_ALL},
		{outCombat}
	}, exeOnLoad)