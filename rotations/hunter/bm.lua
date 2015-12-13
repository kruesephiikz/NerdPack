local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[253] = {
	key = 'NePConfigHunterBM',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Hunter Beast Mastery Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'rule'},
		{type = 'header', text = 'General:', align = 'center'},
			--To be added
		
		-- Survival
		{type = 'spacer'},{ type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 75},
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

local Keybinds = {
	-- Explosive Trap
	{'82939', 'modifier.alt', 'target.ground'},
	-- Freezing Trap
	{'60192', 'modifier.shift', 'target.ground'},
	-- Ice Trap
	{'82941', 'modifier.shift', 'target.ground'},
}

local Shared = {
	-- Trap Launcher
	{'77769', '!player.buff(77769)'}, 
}

local Pet = {
	{'/cast Call Pet 1', '!pet.exists'},
  	{{ -- Pet Dead
		{'55709', '!player.debuff(55711)'}, -- Heart of the Phoenix
		{'982'} -- Revive Pet
	}, {'pet.dead', 'toggle.ressPet'}},
}

local Pet_InCombat = {
	-- Master's Call
	{'53271', 'player.state.stun'}, 
	{'53271', 'player.state.root'},
	{'53271', 'player.state.disorient'},
	{'53271', {'player.state.snare', '!player.debuff(Dazed)'}},
	-- Mend Pet
	{'136', { 
		'pet.health <= 75', 
		'!pet.buff(136)' 
	}}, 
	-- Missdirect // PET 
	{'34477', { 
		'!player.buff(35079)', 
		'!focus.exists', 
		'target.threat > 85' 
	}, 'pet'},
	-- Missdirect // Focus
	{'34477', { 
		'focus.exists', 
		'!player.buff(35079)', 
		'target.threat > 60' 
	}, 'focus'},
}

local Cooldowns = {
	{'Stampede', 'player.proc.any'},
	{'Stampede', 'player.hashero'},
	{'Stampede', 'player.buff(19615).count >= 4'}, -- wt Frenzy
	{'131894'}, -- A Murder of Crows
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1'},
	{'#trinket2'},
}

local Survival = {
	-- Fake death
	{'5384', {
		'player.aggro >= 100', 
		'modifier.party', 
		'!player.moving'
	}},
	-- Healthstone
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfigHunterBM', 'Healthstone')) end)},
}

local AoE = {
	--Cast Multi-Shot, as often as needed to keep up the Beast Cleave buff on your pet.
	{'Multi-Shot', 'player.focus > 60'},
	--Use Barrage.
	{'Barrage'},
	--Use Explosive Trap.
	{'Explosive Trap', nil, 'target.ground'}
}

local inCombat = {
	--Keep Steady Focus up, if you have taken this talent.
	{'Cobra Shot', {
		'player.buff(177668).duration < 3',
		'talent(4,1)',
		'lastcast(Cobra Shot)'
	}, 'target'},
	-- AoE
	{AoE, (function() return NeP.Core.SAoE(3, 40) end)},
	--Cast Kill Command.
	{'Kill Command', 'pet.exists'},
	--Cast Kill Shot,Only available when the target is below 20% health.
	{'Kill Shot', (function() return NeP.Core.AutoDots('Kill Shot', 0, 35) end)},
	--Use Barrage, if you have taken this talent.
	{'Barrage'},
	--Cast Arcane Shot to dump any excess Focus.
	{'Arcane Shot', 'player.focus >= 80'},
	--Cast Cobra Shot to generate Focus.
	{'Cobra Shot'},
	-- Steady Shot for low lvl's
	{'Steady Shot'},
}

local Interrupts = {
	-- Counter Shot
	{'!147362'},
	-- Intimidation
	{'!19577'},
	-- Wyrven Sting
	{'!19386'},
}

local outCombat = {
	{Keybinds},
	{Shared},
	{Pet}
}

ProbablyEngine.rotation.register_custom(253, NeP.Core.GetCrInfo('Hunter - Beast Mastery'),
	{ -- In-Combat
		-- Pause for Feign Death
		{'pause', 'player.buff(5384)'},
		{Keybinds},
		{Shared},
		{Interrupts, 'target.NePinterrupt'},
		{{ -- General Conditions
			{Survival, 'player.health < 100'},
			{Pet},
			{Cooldowns, 'modifier.cooldowns'},
			{Pet_InCombat, {'player.alive', 'pet.exists'} },
			{inCombat, {'target.NePinfront', 'target.exists', 'target.range <= 40'}},
		}, '!player.channeling'}
	}, outCombat, lib)