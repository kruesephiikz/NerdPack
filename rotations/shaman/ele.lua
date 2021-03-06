local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[262] = {
	key = 'NePConfShamanEle',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Shaman Elemental Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds:', align = 'center'},		
			{type = 'text', text = 'Control: Earthquake mouseover location', align = 'left'},
			{type = 'text', text = 'Shift: Cleanse on mouseover target', align = 'left'},
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Healing:', align = 'center'},
			{type = 'checkspin', text = 'Healthstone', key = 'healthstone', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Stream Totem', key = 'healingstreamtotem', default_spin = 40, default_check = false},
			{type = 'checkspin', text = 'Healing Surge', key = 'healingsurge', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Surge Out of Combat', key = 'healingsurgeOCC', default_spin = 90, default_check = true},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Survivability:', align = 'center'},
			{type = 'checkbox', default = true, text = 'Tremor Totem', key = 'tremortotem'},
			{type = 'checkbox', default = true, text = 'Windwalk Totem', key = 'windwalktotem'},
			{type = 'checkbox', default = false, text = 'Shamanistic Rage', key = 'shamrage', desc = 'Cast Shamanistic Rage when stunned.'},
			{type = 'checkbox', default = false, text = 'Ancestral Guidance', key = 'guidance', desc = 'Cast Ancestral Guidance when Ascendance and Spirit Walker\'s Grace are active.'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Proximity Spells:', align = 'center'},
			{type = 'checkbox', default = false, text = 'Earthbind / Earthgrab', key = 'earthbind'},	
			{type = 'checkbox', default = false, text = 'Thunderstorm', key = 'thunderstorm'},
			{type = 'checkbox', default = false, text = 'Frostshock', key = 'frostshock', desc = 'Requiers talent (Frozen Power).'},
	}
}

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'cleavemode', 
		'Interface\\Icons\\spell_nature_chainlightning', 'Enable Cleaves', 
		'Enables casting of earthquake and chain lightning for cleaves.')
	ProbablyEngine.toggle.create(
		'autoDots', 
		'Interface\\Icons\\spell_fire_flameshock', 
		'Enable Automated Dotting', 
		'Cast flameshock on all elite (or above) enemie units.')
	ProbablyEngine.toggle.create(
		'totems', 
		'Interface\\Icons\\spell_fire_flameshock', 
		'Enable Automated use of totems', 
		'Enable Automated use of totems.') -- Better DESC needed
end

local _ALL = {
	-- Buffs
	{'Lightning Shield', '!player.buff(Lightning Shield)'},

	-- Keybinds
	{'pause', 'modifier.lalt'},
}

local _Cooldowns = {
	{'Ancestral Swiftness'},  
	{'Fire Elemental Totem'}, 
	{'Storm Elemental Totem'},  
	{'Elemental Mastery'},  
	{'#trinket1', 'player.buff(Ascendance)'}, 
	{'#trinket2', 'player.buff(Ascendance)'}, 
	{'Ascendance', '!player.buff(Ascendance)'}
}

local _Survival = {
	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingsurge_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingsurge_check') end) 
	}},
	{'Healing Stream Totem', { 
		'!player.totem(Healing Stream Totem)', 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingstreamtotem_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingstreamtotem_check') end) 
	}},
	{'#5512', {-- Healthstone (5512)
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healthstone_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healthstone_check') end)
	}}, 
}

local _totems = {
	{'Ancestral Guidance', { 
		'player.buff(Ascendance)', 
		'player.buff(Spiritwalker\'s Grace)', 
		(function() return PeFetch('NePConfShamanEle', 'guidance') end) 
	}},
	{{ -- Windwalk Totem
		{'Windwalk Totem', 'player.state.root'}, 
		{'Windwalk Totem', 'player.state.snare'}, 
	},{
		'!player.buff(Windwalk Totem)', 
		'!player.totem(Windwalk Totem)', 
		(function() return PeFetch('NePConfShamanEle', 'windwalktotem') end)
	}},
	{'Shamanistic Rage', { 
		'player.state.stun', 
		(function() return PeFetch('NePConfShamanEle', 'shamrage') end) 
	}},
	{'Tremor Totem', { 
		'!player.buff', 
		'player.state.fear', 
		'!player.totem(Tremor Totem)', 
		(function() return PeFetch('NePConfShamanEle', 'tremortotem') end) 
	}},
	{{	-- Proximity Survival
		{'Earthbind Totem', { 
			'!player.totem(Earthbind Totem)', 
			'!talent(2, 2)', 
			(function() return PeFetch('NePConfShamanEle', 'earthbind') end) 
		}},
  		{'Earthgrab Totem', { 
  			'!player.totem(Earthbind Totem)', 
  			'talent(2, 2)', 
  			(function() return PeFetch('NePConfShamanEle', 'earthbind') end) 
  		}},
		{'Frostshock', { 
			'talent(2, 1)', 
			'target.debuff(Flame Shock)', 
			(function() return PeFetch('NePConfShamanEle', 'frostshock') end) 
		}},  
		{'Thunderstorm', (function() return PeFetch('NePConfShamanEle', 'thunderstorm') end)}
	}, (function() return NeP.Core.SAoE(2, 8) end)},
}

local _Moving = {
	{'Spiritwalker\'s Grace', 'player.buff(Ascendance)'},
	{'Spiritwalker\'s Grace', 'glyph(Glyph of Spiritwalker\'s Focus)'},
	{'Unleash Flame'},
	{'Lava Burst', 'player.buff(Lava Surge)'},
	{'Flame Shock', { 
		'player.buff(Unleash Flame)', 
		'target.debuff(Flame Shock).duration < 19' 
	}},
	{'Flame Shock', 'target.debuff(Flame Shock).duration < 9'},
	{'Earth Shock'},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{{ -- Ancestral Swiftness
		{'Chain Lightning', (function() return NeP.Core.SAoE(4, 8) end)},
		{'Lava Burst'},
		{'Elemental Blast'},
	}, 'player.buff(Ancestral Swiftness)'},
}

local _AoE = {
	{'Lava Beam', 'player.buff(Ascendance)'},
	{'Chain Lightning', '!player.buff(Enhanced Chain Lightning)'},
	{'Earthquake', 'player.buff(Enhanced Chain Lightning)', 'target.ground'},
	{'Earth Shock', { 
		'player.buff(Lightning Shield)', 
		'player.buff(Lightning Shield).count >= 18' 
	}},
	{'Chain Lightning'},
}

local _Cleave = {
	{'Chain Lightning'},
	{'Chain Lightning', { 
		'!player.buff(Enhanced Chain Lightning)', 
		'player.spell(Earthquake).cooldown < 1' 
	}},
	{'Earthquake', 'player.buff(Enhanced Chain Lightning)', 'target.ground'},
}

local ST = {
	{'Flame Shock', '!target.debuff(Flame Shock)'},
	{'Unleash Flame', 'talent(6, 1)'},
	{'Lava Burst'},
	{'Elemental Blast'},  
	{'Earth Shock', { 
		'player.buff(Lightning Shield)', 
		'player.buff(Lightning Shield).count >= 15', 
		'target.debuff(Flame Shock).duration >= 9' 
	}},
	{'Flame Shock', 'target.debuff(Flame Shock).duration < 9'},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Lightning Bolt'},
}

local outCombat = {
	{_ALL},

	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEle', 'healingsurgeOCC_spin')) end), 
		(function() return PeFetch('NePConfShamanEle', 'healingsurgeOCC_check') end) 
	}},
}

ProbablyEngine.rotation.register_custom(262, NeP.Core.GetCrInfo('Shamman - Elemental'), 
	{ -- In-Combat
		{_Moving, {'player.moving', '!player.buff(Spiritwalker\'s Grace)'}},
		{{ -- Conditions
			{_ALL},
			{'Wind Shear', 'target.NePinterrupt'},
			{_Cooldowns, 'modifier.cooldowns'},
			{_Survival, 'player.health < 100'},
			{_totems, 'toggle.totems'},
			{'Earth Shock', { 
				(function() return NeP.Core.AutoDots('Earth Shock') end),
				'toggle.autoDots'
			}},
			{_AoE, (function() return NeP.Core.SAoE(8, 5) end)},
			{_Cleave, 'toggle.cleavemode'},
			{ST},
		}, {'!player.moving', --[[INSERT BUFF CHECK FOR WOLF]] } },
	}, outCombat, exeOnLoad)