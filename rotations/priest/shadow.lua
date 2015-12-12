local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch
local addonColor = '|cff'..NeP.Interface.addonColor

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
		-- Keybinds
		{type = 'header', text = addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0 },
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Cascade', align = 'right', size = 11, offset = 0 },
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0 },
		
		-- [[ General Settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'General', align = 'center'},
			{ type = "checkbox", text = "Move faster", key = "canMoveF", default = true },
		
		-- [[ Survival settings ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = addonColor..'Survival', align = 'center'},
			-- TODO
	}
}

local lib = function()
	NeP.Splash()
end

local keybinds = {
	 -- Pause
	{'pause', 'modifier.alt'},
	-- Cascade
	{'127632', 'modifier.shift'},
}

local Buffs = {
	-- Power Word: Fortitude
	{'21562', '!player.buffs.stamina'},
	-- Shadowform
	{'15473', 'player.stance = 0'},
	--{'1706', 'player.falling'} -- Levitate
	-- Angelic Feather
	{'121536', {
		'player.movingfor > 3',
		'!player.buff(121557)',
		(function() return PeFetch('NePConfPriestShadow', 'canMoveF') end)
	}, 'player.ground'}
}

local Cooldowns = {
	-- Mindbender
	{'123040'},
	 --Shadowfiend
	{'34433'},
	-- Vampiric Embrace
	{'15286', '@coreHealing.needsHealing(65, 3)'}
}

local Survival = {
	-- PW:Shield
	{'17', '!player.buff(17)', 'player'},
	 -- Flash Heal
	{'2061', 'player.health < 20', 'player'},
}

local AoE = {
	-- Cascade
	{'127632'},
	-- Mind Sear
	{'48045', (function() return NeP.Core.SAoEObject(2) end)},
}

local Moving = {
	-- Shadow Word: Death
	{'Shadow Word: Death', (function() return AutoDots('Shadow Word: Death', 20) end)},
	-- Shadow Word: Pain.
	{'589', (function() return AutoDots('589', 100, 2) end)},
}

local inCombat = {
	-- Cast Devouring Plague with 3 or more Shadow Orbs.
	{'2944', {'player.shadoworbs >= 3', '!target.debuff(2944)'}},

	-- Cast Mind Blast if you have fewer than 5 Shadow Orbs.
	{'8092', {'player.shadoworbs < 5', 'target.ttd > 5'}},

	-- Cast Shadow Word: Death if you have fewer than 5 Shadow Orbs.
	-- Shadow Word: Death is only usable on targets that are below 20% health.
	{'Shadow Word: Death', {'player.shadoworbs < 5', (function() return AutoDots('Shadow Word: Death', 20) end)}},

	-- Cast Insanity on the target when you have the Insanity buff (if you are using the Insanity talent).
	{'Insanity', 'player.buff(Insanity)'},

	-- Cast Mind Spike if you have a Surge of Darkness proc (if you are using this talent).
	{'Mind Spike', 'player.buff(Surge of Darkness)'},

	-- Apply and maintain Shadow Word: Pain.
	{'589', (function() return AutoDots('589', 100, 2) end)},

	-- Apply and maintain Vampiric Touch.
	{'34914', (function() return AutoDots('34914', 100, 3) end)},

	{AoE, (function() return SAoE(3, 40) end)},

	-- Cast Mind Flay as your filler spell.
	{'15407'}

} 

local outCombat = {
	{Buffs},
	{keybinds}
}

ProbablyEngine.rotation.register_custom(258, NeP.Core.GetCrInfo('Priest - Shadow'), 
	{-- In-Combat
		{keybinds},
		{Buffs},
		{Moving, 'player.moving'},
		{Survival, "player.health < 100"},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat},
	}, outCombat, lib)