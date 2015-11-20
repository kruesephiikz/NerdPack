local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

local n = GetSpellInfo('5118')

NeP.Interface.classGUIs[254] = {
	key = 'NePConfigHunterMM',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Hunter Marksmanship Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--To be added
		
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			
			-- Survival Settings:
			{type = 'spinner', text = 'Healthstone - HP', key = 'Healthstone', default = 75},
	}
}

local lib = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'ressPet', 
		'Interface\\Icons\\Inv_misc_head_tiger_01.png', 
		'Auto Ress Pet', 
		'Automatically ress your pet when it dies.')
end

local _ALL = {
	-- Pause
	{'pause', 'player.buff(5384)'}, -- Pause for Feign Death
	-- Keybinds
	{'82939', 'modifier.alt', 'target.ground'}, -- Explosive Trap
	{'60192', 'modifier.shift', 'target.ground'}, -- Freezing Trap
	{'82941', 'modifier.shift', 'target.ground'}, -- Ice Trap
	-- Buffs
	{'77769', '!player.buff(77769)'}, -- Trap Launcher
		-- Aspect of the Cheetah
		{  '/cancelaura '..n, { 
			'player.buff(5118)',
			'!player.glyph(692)', 
			'!player.moving'
		}},
		{  '/cancelaura '..n, { 
			'player.buff(5118)',
			'!player.glyph(692)', 
			'player.aggro >= 100'
		}},
		{'5118', {
			'!player.buff(5118)', 
			'player.movingfor >= 3',
			'!player.aggro >= 100'
		}},
	-- Missdirect // Focus
	{'34477', { 
		'focus.exists', 
		'!player.buff(35079)', 
		'target.threat > 60' 
	}, 'focus'},
}

local Pet = {
	{'/cast Call Pet 1', '!pet.exists'},
  	{{ -- Pet Dead
		{'55709', '!player.debuff(55711)'}, -- Heart of the Phoenix
		{'982'} -- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},	
}

local Pet_inCombat = {
	{'53271', 'player.state.stun'}, -- Master's Call
	{'53271', 'player.state.root'}, -- Master's Call
	{'53271', { -- Master's Call
		'player.state.snare', 
		'!player.debuff(Dazed)' 
	}},
	{'53271', 'player.state.disorient'}, -- Master's Call
	{'136', { -- Mend Pet
		'pet.health <= 75', 
		'!pet.buff(136)' 
	}}, 
	{'34477', { -- Missdirect // PET 
		'!player.buff(35079)', 
		'!focus.exists', 
		'target.threat > 85' 
	}, 'pet'},
}

local Cooldowns = {
	{'82939', nil, 'target.ground'}, -- Explosive Trap
	{'121818', 'player.proc.any'}, -- Stampede
	{'121818', 'player.hashero'}, -- Stampede
	{'121818', 'player.buff(19615).count >= 4'}, --Stampede w/ Frenzy
	{'131894'}, -- A Murder of Crows
	{'3045'}, -- Rapid Fire
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1'},
	{'#trinket2'},
}

local Survival = {
	{'5384', {'player.aggro >= 100', 'modifier.party', '!player.moving'}}, -- Fake death
	{'109304', 'player.health < 50'}, -- Exhiliration
	{'Deterrence', 'player.health < 10'}, -- Deterrence as a last resort
	{'#109223', 'player.health < 40'}, -- Healing Tonic
	{'#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigHunterMM', 'Healthstone')) end)}, --Healthstone
	{'#109223', 'player.health < 40'}, -- Healing Tonic
}

local focusFire = {	
	{'82692', 'player.buff(19615).count = 5'}, -- Frenzy
	{'!82692', 'player.buff(19615).duration <= 1'}, -- Frenzy
	{'82692', 'player.spell(121818).cooldown >= 260'}, -- Stampede
}

local inCombat = {
	{{ -- Steady Focus // TALENT
		{'Steady Shot', 'player.buff(177667).duration < 3', 'target'}, -- Cobra Shot
	}, {'talent(4,1)', 'lastcast(77767)'} },
	{'157708', (function() return NeP.Core.AutoDots('157708', 35) end)},-- Kill Shot
	{'53209'}, -- Chimaera Shot
	{'117050'}, -- Glaive Toss // TALENT
	{{ -- AoE
		{'2643', 'player.focus > 60', 'target'}, -- Multi-Shot
	}, (function() return NeP.Core.SAoE(3, 40) end)},
	{'19434', 'player.focus > 60', 'target'}, -- Aimed Shot
	{'163485', '!player.moving', 'target'}, -- Focusing Shot // TALENT
	{'Steady Shot'}
}

local outCombat = {
	{_All},
	{Pet}
}

ProbablyEngine.rotation.register_custom(254, NeP.Core.GetCrInfo('Hunter - Marksmanship'),
	{ -- In-Combat
		{_ALL},
		{{-- Interrupts
			{'!147362'}, -- Counter Shot
			{'!19577'}, -- Intimidation
			{'!19386'}, -- Wyrven Sting
		}, 'target.NePinterrupt'},
		{{ -- General Conditions
			{Survival, 'player.health < 100'},
			{Cooldowns, 'modifier.cooldowns'},
			{Pet},
			{Pet_inCombat, {'player.alive', 'pet.exists'} },
			{focusFire, { 
				'pet.exists', 
				'!player.buff(Focus Fire)', 
				'!lastcast(Cobra Shot)', 
				'player.buff(19615).count >= 1' 
			}},
			{inCombat, {'target.NePinfront', 'target.range <= 40'}},
		}, '!player.channeling'}
	}, outCombat, lib)