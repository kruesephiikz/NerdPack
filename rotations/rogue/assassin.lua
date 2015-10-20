local dynEval = NeP.Core.dynamicEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[259] = {
	key = 'NePConfigRogueAss',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Rogue Assassination Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ 
			type = 'header',
			text = 'General:', 
			align = 'center' 
		},
			-- ...Empty...
			{ 
				type = 'text',
				text = 'Nothing here yet... :C',
				align = 'center'
			},
		-- Poisons
		{ type = "spacer" },{ type = 'rule' },
		{ 
			type = 'header',
			text = 'Poisons:', 
			align = 'center' 
		},
			{ -- Letal Poison
		      	type = 'dropdown',
		      	text = 'Letal Posion',
		      	key = 'LetalPosion',
		      	list = {
			        {
			          text = 'Wound Posion',
			          key = 'Wound'
			        },
			        {
			          text = 'Deadly Posion',
			          key = 'Deadly'
			        },
			    },
		    	default = 'Deadly',
		    	desc = 'Select what Letal Posion to use.'
		    },
			{ -- Non-Letal Poison
		      	type = 'dropdown',
		      	text = 'Non-Letal Posion',
		      	key = 'NoLetalPosion',
		      	list = {
			        {
			          text = 'Crippling Poison',
			          key = 'Crippling'
			        },
			        {
			          text = 'Leeching Posion',
			          key = 'Leeching'
			        },
			    },
		    	default = 'Crippling',
		    	desc = 'Select what Non-Letal Posion to use.'
		    },
		-- Survival
		{ type = 'spacer' },{ type = 'rule' },
		{ 
			type = 'header', 
			text = 'Survival:', 
			align = 'center' 
		},
			{
				type = 'spinner',
				text = 'Healthstone - HP',
				key = 'Healthstone',
				width = 50,
				min = 0,
				max = 100,
				default = 75,
				step = 5
			},
	}
}

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'MfD', 
		'Interface\\Icons\\Ability_hunter_assassinate.png', 
		'Marked for Death', 
		'Use Marked for Death \nBest used for targets that will die under a minute.')
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things!', 
		'Click here to dot all the things.')
end

local Cooldowns = {
	{ '1856', 'player.energy >= 60' }, -- Vanish
	{ 'Shadow Reflection' }, -- Shadow Reflection // TALENT (FIXME: ID)
	{ '14185', 'player.spell(1856).cooldown >= 10' }, -- Preparation
	{ '79140', '!player.moving' }, -- Vendetta
}

local Survival = {
	{ '73651', { -- Recuperate
		'player.combopoints <= 3',
		'player.health < 35',
		'player.buff(73651).duration <= 5'
	}},
	{ '5277', 'player.health < 30' }, -- Evasion
	{ '57934', 'player.aggro > 60', 'tank'}, -- Tricks of the Trade
	{ '57934', 'player.aggro > 60', 'focus'}, -- Tricks of the Trade
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigRogueAss', 'Healthstone')) end) }, --Healthstone
}

local inCombat = {
	{'137619', { -- Marked for Death
		'player.combopoints = 0',
		'toggle.MfD'
	}},
	{{-- Auto Dotting
		{'1943', { -- Rupture
			'player.combopoints >= 5',
			(function() return NeP.Lib.AutoDots('1943', 100, 7, 5) end)
		}, 'target' },
	}, 'toggle.dotEverything' },
	{{ -- Toggle off
		{'1943', { -- Rupture
			'player.combopoints >= 5',
			'target.debuff(1943).duration <= 7'
		}, 'target' },
	}, '!toggle.dotEverything' },
	{ '32645', 'player.combopoints >= 5', 'target' }, -- Envenom
	{ '111240', 'target.health <= 35', 'target' }, -- Dispatch
	{ '111240', 'player.buff(121153)', 'target' }, -- Dispatch w/ Proc Blindside
	-- AoE
		{ '51723', (function() return NeP.Lib.SAoE(3, 10) end)}, -- Fan of Knives
	{ '1329', 'target.health >= 35', 'target' }, -- Mutilate
}

local outCombat = {
	{'8676', { -- Ambush after vanish
		'target.alive',
		'lastcast(1856)' -- Vanish
	}, 'target' },

	-- Letal Poisons
	{'2823', { -- Deadly Poison / Letal
		'!lastcast(2823)',
		'!player.buff(2823)',
		(function() return NeP.Core.PeFetch('NePConfigRogueAss', 'LetalPosion') == 'Deadly' end)
	}},
	{'8679', { -- Deadly Poison / Letal
		'!lastcast(8679)',
		'!player.buff(8679)',
		(function() return NeP.Core.PeFetch('NePConfigRogueAss', 'LetalPosion') == 'Wound' end)
	}},
	
	-- Non-Letal Poisons
	{'3408', { -- Crippling Poison / Non-Letal
		'!lastcast(3408)',
		'!player.buff(3408)',
		(function() return NeP.Core.PeFetch('NePConfigRogueAss', 'NoLetalPosion') == 'Crippling' end)
	}},
	{'108211', { -- Leeching Poison / Non-Letal
		'!lastcast(108211)',
		'!player.buff(108211)',
		(function() return NeP.Core.PeFetch('NePConfigRogueAss', 'NoLetalPosion') == 'Leeching' end)
	}}
}

ProbablyEngine.rotation.register_custom(259, NeP.Core.GetCrInfo('Rogue - Assassination'), 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ '1766' }, -- Kick
			}, 'target.NePinterrupt' },
			{Survival},
			{Cooldowns, 'modifier.cooldowns' },
			{inCombat},
		}, { '!player.buff(1856)', 'target.range < 7' } },
	}, outCombat, exeOnLoad)