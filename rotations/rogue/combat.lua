local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[260] = {
	key = 'NePConfigRogueCombat',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Rogue Combat Settings',
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
		'Dot All The Things! (SOLO)', 
		'Click here to dot all (Rupture) the things while in Single Target.')
end

local Cooldowns = {
	{ 'Vanish' },
	{ 'Preparation', 'player.spell(Vanish).cooldown >= 10' },
	{ 'Adrenaline Rush', 'player.energy < 20' },
	{ 'Killing Spree', {
		'player.energy < 20',
		'player.spell(Adrenaline Rush).cooldown >= 10'
	}},
}

local Survival = {
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigRogueCombat', 'Healthstone')) end) }, --Healthstone
	{'Recuperate',{
		'player.combopoints <= 3',
		'player.health < 35',
		'player.buff(Recuperate).duration <= 5'
	}},
	{'Tricks of the Trade', 'player.aggro > 60', 'tank'},
}

local AoE = {
	{ 'Blade Flurry' },
	{'Crimson Tempest', {
		'player.combopoints >= 5',
	}, 'target'},
}

local ST = {
	{{-- Auto Dotting
		{'Rupture', {
			'player.combopoints >= 5',
			(function() return NeP.Lib.AutoDots('Rupture', 100, 7, 5) end)
		}, 'target' },
	}, 'toggle.dotEverything' },
	{ 'Ambush' },
	{ 'Revealing Strike', '!target.debuff(Revealing Strike)', 'target' },
	{ 'Slice and Dice', {
		'!player.buff(Slice and Dice)',
		'player.combopoints < 4'
	}},
	{ 'Eviscerate', 'player.combopoints >= 5', 'target' },
	{ 'Sinister Strike' }
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
		(function() return NeP.Core.PeFetch('NePConfigRogueCombat', 'LetalPosion') == 'Deadly' end)
	}},
	{'8679', { -- Deadly Poison / Letal
		'!lastcast(8679)',
		'!player.buff(8679)',
		(function() return NeP.Core.PeFetch('NePConfigRogueCombat', 'LetalPosion') == 'Wound' end)
	}},
	
	-- Non-Letal Poisons
	{'3408', { -- Crippling Poison / Non-Letal
		'!lastcast(3408)',
		'!player.buff(3408)',
		(function() return NeP.Core.PeFetch('NePConfigRogueCombat', 'NoLetalPosion') == 'Crippling' end)
	}},
	{'108211', { -- Leeching Poison / Non-Letal
		'!lastcast(108211)',
		'!player.buff(108211)',
		(function() return NeP.Core.PeFetch('NePConfigRogueCombat', 'NoLetalPosion') == 'Leeching' end)
	}},
}

ProbablyEngine.rotation.register_custom(260, NeP.Core.GetCrInfo('Rogue - Combat'), 
	{-- In-Combat
		{{ -- Dont Break Sealth && Melee Range
			{{-- Interrupts
				{ 'Kick' },
			}, 'target.NePinterrupt' },
			{'Marked for Death', {
				'player.combopoints = 0',
				'toggle.MfD'
			}},
			{'Evasion', 'player.health < 30'},
			{Cooldowns, 'modifier.cooldowns' },
			{AoE, (function() return NeP.Lib.SAoE(6, 10) end) },
			{ST},
		}, {'!player.buff(Vanish)', 'target.range < 7'} },
	}, outCombat, exeOnLoad)