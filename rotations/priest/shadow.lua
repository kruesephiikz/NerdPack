local SAoE = NeP.Core.SAoE
local AutoDots = NeP.Core.AutoDots

NeP.Interface.classGUIs[258] = {
	key = 'NePConfPriestShadow',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Priest Shadow Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- [[ Keybinds ]]
		{type = 'text', text = 'Keybinds', align = 'center'},		
			{type = 'text', text = 'Control: ', align = 'left'},
			{type = 'text', text = 'Shift: ', align = 'left'},
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		-- [[ General Settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'General', align = 'center'},
			-- TODO
		-- [[ Survival settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			-- TODO
	}
}

local lib = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'autoDots', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot Elites', 
		'Click here to dot all the things!')
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_06.png', 
		'Dot all (no VT))', 
		'Click here to dot all the things!')
end

local keybinds = {
	{'pause', 'modifier.alt'}, -- Pause
	{'127632', 'modifier.lshift'}, -- Cascade (any # of targets)
}

local Buffs = {
	{'215262', '!player.buff(21562)'}, -- Power Word: Fortitude
	{'15473', {'player.stance = 0', 'player.health >=40'}}, -- Shadowform
	--{'1706', 'player.falling'} -- Levitate
}

local Cooldowns = {
	{'123040'}, -- Mindbender
	{'34433'}, --Shadowfiend
	{'15286', '@coreHealing.needsHealing(65, 3)'} -- Vampiric Embrace
}

local Survival = {
	{'2061', 'player.health < 20', 'player'}, -- Flash Heal
}

local Dots = {
	{{-- Toggle ALL
		{'!32379', (function() return AutoDots('32379', 20) end)}, -- SW:D
		{'589', (function() return AutoDots('589', 100, 2) end)}, -- SW:P
		--{'34914', (function() return AutoDots('34914', 100, 3) end)}, -- Vampiric Touch
	}, 'toggle.dotEverything'},
	
	{{-- Toggle Elites
		{'!32379', (function() return AutoDots('32379', 20, nil, nil, 'elite') end)}, -- SW:D
		{'589', (function() return AutoDots('589', 100, 2, nil, 'elite') end)}, -- SW:P
		{'34914', (function() return AutoDots('34914', 100, 3, nil, 'elite') end)} -- Vampiric Touch
	}, 'toggle.autoDots'},
	
	{{-- Toggle off
		{'!32379', 'target.health < 20', 'target'}, -- SW:D
		{'589', '!target.debuff(589)', 'target'}, -- SW:P
		{'34914', '!target.debuff(34914)', 'target'} -- Vampiric Touch
	}, {'!toggle.autoDots', '!toggle.dotEverything'}},
}

local AoE = {
	{'127632'}, -- Cascade (best target 4+)
	{'2944', { 'player.shadoworbs >= 3', (function() return AutoDots('2944', 100) end)}}, -- Devouring Plague
	{'48045',}, -- Mind Sear
}

local inCombat = {
	{'2944', {'player.shadoworbs = 5', (function() return AutoDots('2944', 100) end)}}, -- Devouring Plague
	{'73510', 'player.buff(Surge of Darkness).count = 3'}, -- Mind Spike

	--Dots	
	{Dots},
	
	{'8092'}, -- Mind Blast
	{'73510', 'player.buff(Surge of Darkness)'}, -- Mind Spike
	{'2944', {'player.shadoworbs >= 3', (function() return AutoDots('2944', 100) end)}}, -- Devouring Plague
	{'129197', 'player.buff(Insanity)'}, -- Mind Flay
	{'15407'},  -- Mind Flay
} 

local outCombat = {
	{Buffs},
	{keybinds}
}

ProbablyEngine.rotation.register_custom(258, NeP.Core.GetCrInfo('Priest - Shadow'), 
	{-- In-Combat
		{keybinds},
		{'17', '!player.buff(17)', 'player'}, -- PW:Shield
		{Buffs},
		{Survival, "player.health < 100"},
		{Cooldowns, , 'modifier.cooldowns'},
		{AoE, (function() return SAoE(3, 40) end)},
		{inCombat}
	}, outCombat, lib)