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
end

local keybinds = {
	 -- Pause
	{'pause', 'modifier.alt'},
	-- Cascade
	{'127632', 'modifier.lshift'},
}

local Buffs = {
	{'215262', '!player.buff(21562)'}, -- Power Word: Fortitude
	{'15473', {'player.stance = 0', 'player.health >=40'}}, -- Shadowform
	--{'1706', 'player.falling'} -- Levitate
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
	{'127632'}, -- Cascade
	{'48045'}, -- Mind Sear
}

local inCombat = {
	-- Cast Devouring Plague with 3 or more Shadow Orbs.
	{'Devouring Plague', {'player.shadoworbs >= 3', '!target.debuff(2944)'}},

	-- Cast Mind Blast if you have fewer than 5 Shadow Orbs.
	{'Devouring Plague', 'player.shadoworbs < 5'},

	-- Cast Shadow Word: Death if you have fewer than 5 Shadow Orbs.
	-- Shadow Word: Death is only usable on targets that are below 20% health.
	{'Shadow Word: Death', {'player.shadoworbs < 5', (function() return AutoDots('Shadow Word: Death', 20) end)}},

	-- Cast Insanity on the target when you have the Insanity buff (if you are using the Insanity talent).
	{'Insanity', 'player.buff(Insanity)'},

	-- Cast Mind Spike if you have a Surge of Darkness proc (if you are using this talent).
	{'Mind Spike', 'player.buff(Surge of Darkness)'},

	-- Apply and maintain Shadow Word: Pain.
	{'Shadow Word: Pain', (function() return AutoDots('Shadow Word: Pain', 100, 2) end)},

	-- Apply and maintain Vampiric Touch.
	{'Vampiric Touch', (function() return AutoDots('Vampiric Touch', 100, 3) end)},

	{AoE, (function() return SAoE(3, 40) end)},

	-- Cast Mind Flay as your filler spell.
	{'Mind Flay'}

} 

local outCombat = {
	{Buffs},
	{keybinds}
}

ProbablyEngine.rotation.register_custom(258, NeP.Core.GetCrInfo('Priest - Shadow'), 
	{-- In-Combat
		{keybinds},
		{Buffs},
		{Survival, "player.health < 100"},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat}
	}, outCombat, lib)