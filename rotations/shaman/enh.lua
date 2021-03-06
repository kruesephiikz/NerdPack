local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[262] = {
	key = 'NePConfShamanEnhance',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Shaman Enhancement Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds:', align = 'center'},		
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Healing:', align = 'center'},
			{type = 'checkspin', text = 'Healthstone', key = 'healthstone', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Stream Totem', key = 'healingstreamtotem', default_spin = 40, default_check = false},
			{type = 'checkspin', text = 'Healing Surge', key = 'healingsurge', default_spin = 30, default_check = true},
			{type = 'checkspin', text = 'Healing Surge Out of Combat', key = 'healingsurgeOCC', default_spin = 90, default_check = true},
			{type = 'checkspin', text = 'Feral Spirit - Glyphed', key = 'fspirit', desc = 'Use only with Glyph of Feral Spirit for Healing.', default_spin = 35, default_check = false},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Self Survivability:', align = 'center'},
			{type = 'checkbox', default = true, text = 'Tremor Totem', key = 'tremortotem'},
			{type = 'checkbox', default = true, text = 'Windwalk Totem', key = 'windwalktotem'},
			{type = 'checkbox', default = false, text = 'Shamanistic Rage', key = 'shamrage', desc = 'Cast Shamanistic Rage when stunned.'},
			{type = 'checkbox', default = false, text = 'Ancestral Guidance', key = 'guidance', desc = 'Cast Ancestral Guidance when Ascendance and Spirit Walker\'s Grace are active.'},
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Proximity Spells:', align = 'center'},
			{type = 'checkbox', default = false, text = 'Earthbind / Earthgrab', key = 'earthbind'},	
			}
}

local exeOnLoad = function()
	NeP.Splash()
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
	{'Unleash Elements'},
	{'Feral Spirit'},
	{'#trinket1', 'player.buff(Ascendance)'}, 
	{'#trinket2', 'player.buff(Ascendance)'}, 
	{'Ascendance', '!player.buff(Ascendance)'}
}

local _Survival = {
	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingsurge_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingsurge_check') end) 
	}},
	{'Feral Spirit', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'fspirit_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'fspirit_check') end) 
	}},
	{'Healing Stream Totem', { 
		'!player.totem(Healing Stream Totem)', 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingstreamtotem_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingstreamtotem_check') end)
	}},
	{'#5512', {-- Healthstone (5512)
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healthstone_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healthstone_check') end)
	}}, 
}

local _totems = {
	{'Ancestral Guidance', { 
		'player.buff(Ascendance)', 
		'player.buff(Spiritwalker\'s Grace)', 
		(function() return PeFetch('NePConfShamanEnhance', 'guidance') end) 
	}},
	{{ -- Windwalk Totem
		{'Windwalk Totem', 'player.state.root'}, 
		{'Windwalk Totem', 'player.state.snare'}, 
	},{
		'!player.buff(Windwalk Totem)', 
		'!player.totem(Windwalk Totem)', 
		(function() return PeFetch('NePConfShamanEnhance', 'windwalktotem') end)
	}},
	{'Shamanistic Rage', { 
		'player.state.stun', 
		(function() return PeFetch('NePConfShamanEnhance', 'shamrage') end) 
	}},
	{'Tremor Totem', { 
		'!player.buff', 
		'player.state.fear', 
		'!player.totem(Tremor Totem)', 
		(function() return PeFetch('NePConfShamanEnhance', 'tremortotem') end) 
	}},
	{{	-- Proximity Survival
		{'Earthbind Totem', { 
			'!player.totem(Earthbind Totem)', 
			'!talent(2, 2)', 
			(function() return PeFetch('NePConfShamanEnhance', 'earthbind') end) 
		}},
  		{'Earthgrab Totem', { 
  			'!player.totem(Earthbind Totem)', 
  			'talent(2, 2)', 
  			(function() return PeFetch('NePConfShamanEnhance', 'earthbind') end) 
  		}},
	}, (function() return NeP.Core.SAoE(2, 8) end)},
}

local _Echo = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)',
		(function() return NeP.Core.SAoE(2, 12) end) 
	}},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Stormstrike', {
		'!player.buff(Ascendance)',
		'player.spell(Stormstrike).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Stormstrike).recharge < 1.3'
	}},
	{'Windstrike', {
		'player.buff(Ascendance)',
		'player.spell(Windstrike).charges >= 1',
		'player.spell(Windstrike).recharge < 1.3'
	}},
	{'Lava Lash', {
		'player.spell(Lava Lash).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Lava Lash).recharge < 1.3'
	}},
	{'Lightning Bolt', {
		(function() return not NeP.Core.SAoE(2, 15) end),
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Chain Lightning', {
		(function() return NeP.Core.SAoE(2, 12) end),
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Unleash Elements'},
	{'Fire Nova', {
		(function() return NeP.Core.SAoE(2, 12) end)
	}},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
	}},
	{'Frost Shock',{
		(function() return not NeP.Core.SAoE(3, 15) end)
	}},
}

local _AoE = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)'
	}},
	{'Chain Lightning', {
		'player.buff(Maelstrom Weapon).count <= 5',
	}},
	{'Unleash Elements'},
	{'Fire Nova'},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
	}},
	{'Stormstrike', {
		'talent(4, 3)',
		'!player.buff(Ascendance)',
		'player.spell(Stormstrike).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Stormstrike).recharge < 1.3'
	}},
	{'Windstrike', {
		'talent(4, 3)',
		'player.buff(Ascendance)',
		'player.spell(Windstrike).charges >= 1',
		'player.spell(Windstrike).recharge < 1.3'
	}},
	{'Lava Lash', {
		'talent(4, 3)',
		'player.spell(Lava Lash).charges >= 1',
		'target.ttd <= 5',
		'player.spell(Lava Lash).recharge < 1.3'
	}},
}
	
local ST = {
	{'Magma Totem', {
		'!player.totem(Fire Elemental Totem)',
		'!player.totem(Magma Totem)',
		(function() return NeP.Core.SAoE(2, 12) end) 
	}},
	{'Searing Totem', { 
		'!player.totem(Fire Elemental Totem)', 
		'!player.totem(Searing Totem)', 
		'target.ttd >= 10'
	}},
	{'Chain Lightning', {
		'player.buff(Maelstrom Weapon).count <= 5',
		(function() return NeP.Core.SAoE(2, 12) end)
	}},
	{'Unleash Elements'},
	{'Fire Nova', {
		(function() return NeP.Core.SAoE(2, 12) end)
	}},
	{'Flame Shock', { 
		'target.debuff(Flame Shock).duration < 9',
		'player.buff(Unleash Flame)'
		}},
	{'Lightning Bolt', {
		(function() return not NeP.Core.SAoE(2, 15) end),
		'player.buff(Maelstrom Weapon).count <= 5'
	}},
	{'Stormstrike', '!player.buff(Ascendance)'},
	{'Windstrike', 'player.buff(Ascendance)'},
	{'Lava Lash'},  
	{'Frost Shock',{
		(function() return not NeP.Core.SAoE(3, 15) end)
	}},
}

local outCombat = {
	{_ALL},

	{'Healing Surge', { 
		(function() return dynEval('player.health <= '..PeFetch('NePConfShamanEnhance', 'healingsurgeOCC_spin')) end), 
		(function() return PeFetch('NePConfShamanEnhance', 'healingsurgeOCC_check') end) 
	}},
}

ProbablyEngine.rotation.register_custom(262, NeP.Core.GetCrInfo('Shamman - Enhancement'), 
	{ -- In-Combat
		{{ -- Conditions
			{_ALL},
			{'Wind Shear', 'target.NePinterrupt'},
			{_Cooldowns, 'modifier.cooldowns'},
			{_Survival, 'player.health < 100'},
			{_totems, 'toggle.totems'},
			{_AoE, (function() return NeP.Core.SAoE(3, 12) end)},
			{_Echo, 'talent(4, 3)'},
			{ST},
		}, {'!player.moving', --[[INSERT BUFF CHECK FOR WOLF]] } },
	}, outCombat, exeOnLoad)