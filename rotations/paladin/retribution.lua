local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[70] = {
	key = 'NePConfPalaRet',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Paladin Retribution Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- Keybinds
		{type = 'text', text = 'Keybinds', align = 'center'},		
			{type = 'text', text = 'Control: Fist of Justice OR Hammer of Justice', align = 'left'},
			{type = 'text', text = 'Shift: Light\'s hammer', align = 'left'},
			{type = 'text', text = 'Alt: Pause Rotation',align = 'left'},
		-- [[ General ]]
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'General', align = 'center' },
			-- Buff
			{ type = 'dropdown',text = 'Buff:', key = 'Buff', list = {
				{text = 'Kings', key = 'Kings'},
				{text = 'Might', key = 'Might'}
        	}, default = 'Kings' },
        	-- Seals
			{ type = 'dropdown',text = 'Seal (ST):', key = 'SealST', list = {
				{text = 'Truth', key = 'Truth'},
				{text = 'Righteousness', key = 'Righteousness'},
				{text = 'Justice', key = 'Justice'},
				{text = 'Insight', key = 'Insight'},
        	}, default = 'Truth' },
        	{ type = 'dropdown',text = 'Seal (MT):', key = 'SealMT', list = {
				{text = 'Truth', key = 'Truth'},
				{text = 'Righteousness', key = 'Righteousness'},
				{text = 'Justice', key = 'Justice'},
				{text = 'Insight', key = 'Insight'},
        	}, default = 'Righteousness' },
			-- Self Dispel
        	{ type = "checkbox", text = "Self Dispel", key = "SelfDispel", default = true},

	    -- [[ Survival ]]
		{ type = 'spacer' },{ type = 'rule' },
	    {type = 'text', text = 'Survival', align = 'center'},
			-- Healthstone
			{ type = 'spinner', text = 'Healthstone', key = 'HealthStone', default = 90},
			-- Lay on Hands
			{ type = 'spinner', text = 'Lay on Hands', key = 'LayOnHands', default = 20},
			-- Divine Shield
			{ type = 'spinner', text = 'Divine Shield', key = 'DivineShield', default = 10},
			-- Divine Protection
			{ type = 'spinner', text = 'Divine Protection', key = 'DivineProtection', default = 85},
			-- Selfless Healer
			{ type = 'spinner', text = 'Selfless Healer (PLAYER)', key = 'FOLSH', default = 85},
			{ type = 'spinner', text = 'Selfless Healer (RAID)', key = 'FOLSHR', default = 85},
			-- Flash of Heal
			{ type = 'spinner', text = 'Flash of Heal', key = 'FOL', default = 20},
	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local Buffs = {
	-- Kings
	{ '20217', {
		'!player.buffs.stats',
		(function() return PeFetch('NePConfPalaRet', 'Buff') == 'Kings' end)
	}},
	-- Might
	{ '19740', {
		'!player.buffs.mastery',
		(function() return PeFetch('NePConfPalaRet', 'Buff') == 'Might' end)
	}},
}

local Survival = {
	-- Flash of Light with Selfless Healer // Talent
	{'19750', {
		'player.buff(114250).count = 3',
		(function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'FOLSH')) end)
	}, 'player'},
	{'19750', {
		'player.buff(114250).count = 3',
		(function() return dynEval('lowest.health <= '..PeFetch('NePConfPalaRet', 'FOLSHR')) end)
	}, 'lowest'},
	-- Healthstone
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'HealthStone')) end)},
	-- Lay on Hands
	{'633', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'LayOnHands')) end), 'player'},
	-- Divine Shield
	{'642', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'DivineShield')) end), 'player'},
	-- Divine Protection
	{'498', (function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'DivineProtection')) end)},
	-- Flash of Light
	{'19750', {
		'player.buff(114250)',
		(function() return dynEval('player.health <= '..PeFetch('NePConfPalaRet', 'FOL')) end)
	}, 'player'},
	-- Cleanse (Dispell)
	{ '4987', {
		'player.dispellable(4987)',
		(function() return NeP.Core.PeFetch('NePConfPalaRet', 'SelfDispel') end)
	}, 'player' },
}

local Cooldowns = {
	-- Seraphim 
	{'152262', {
		'player.spell(31884).cooldown < 5',
		'player.holypower >= 5'
	}},
	-- Avenging Wrath Use on cooldown for burst damage.
	{'31884', {
		'!player.buff(31884)',
		'player.buff(152262)', -- Seraphim
	}},
	{'31884', {
		'!player.buff(31884)',
		'!talent(7, 2)', -- Seraphim
	}},
	-- Execution Sentence should be used on cooldown against targets that will live long enough to withstand the full duration of the ability.
	{'114157'}, 
}

local Seals = {
	{{ -- AoE
		-- Seal of Truth
		{'31801', {
			'player.seal != 1',
			(function() return PeFetch('NePConfPalaRet', 'SealMT') == 'Truth' end)
		}},
		-- Seal of Righteousness
		{'20154', {
			'player.seal != 2',
			(function() return PeFetch('NePConfPalaRet', 'SealMT') == 'Righteousness' end)
			
		}},
		-- Seal of Justice
		{'20164', {
			'player.seal != 3',
			(function() return PeFetch('NePConfPalaRet', 'SealMT') == 'Justice' end)
		}},
		-- Seal of Insight
		{'20165', {
			'player.seal != 4',
			(function() return PeFetch('NePConfPalaRet', 'SealMT') == 'Insight' end)
			
		}},
	}, (function() return NeP.Lib.SAoE(3, 8) end) },

	{{ -- ST
		-- Seal of Truth
		{'31801', {
			'player.seal != 1',
			(function() return PeFetch('NePConfPalaRet', 'SealST') == 'Truth' end)
		}},
		-- Seal of Righteousness
		{'20154', {
			'player.seal != 2',
			(function() return PeFetch('NePConfPalaRet', 'SealST') == 'Righteousness' end)
			
		}},
		-- Seal of Justice
		{'20164', {
			'player.seal != 3',
			(function() return PeFetch('NePConfPalaRet', 'SealST') == 'Justice' end)
		}},
		-- Seal of Insight
		{'20165', {
			'player.seal != 4',
			(function() return PeFetch('NePConfPalaRet', 'SealST') == 'Insight' end)
			
		}},
	}, (function() return not NeP.Lib.SAoE(3, 8) end) },
}

local EmpoweredSeals = {
	-- Seal of Truth
	{'31801', {
		'player.seal != 1', -- Seal of Truth
		'!player.buff(156990).duration > 3', -- Maraad's Truth
		'player.spell(20271).cooldown <= 1' -- Judment  CD less then 1
	}},
	-- Seal of Righteousness
	{'20154', {
		'player.seal != 2', -- Seal of Righteousness
		'!player.buff(156989).duration > 3', -- Liadrin's Righteousness
		'player.buff(156990)', -- Maraad's Truth
		'player.spell(20271).cooldown <= 1' -- Judment  CD less then 1
	}},
	-- Seal of Insigh
	{'20165', {
		'player.seal != 4', -- Seal of Insight
		'!player.buff(156988).duration > 3', -- Uther's Insight
		'player.buff(156990)', -- Maraad's Truth
		'player.buff(156989)', -- Liadrin's Righteousness
		'player.spell(20271).cooldown <= 1' -- Judment  CD less then 1
	}},		
					
	-- Judgment		
	{ '20271', {
		'player.buff(156990).duration < 3', -- Maraad's Truth		
			'player.seal = 1'		
	}},
	{ '20271', {
		'player.buff(156989).duration < 3', -- Liadrin's Righteousness		
		'player.seal = 2'		
	}},
	{ '20271', {
		'player.buff(156988).duration < 3', -- Uther's Insight		
		'player.seal = 4'		
	}},
}

local AoE = {
	-- Divine Storm to spend Holy Power.
	{'53385', 'player.holypower >= 3', 'target'},
	-- Hammer of the Righteous to build Holy Power.
	{'53595', nil, 'target'},
	-- Judgment to build Holy Power.
	{'20271', nil, 'target'},
	-- Exorcism to build Holy Power.
	{'879', nil, 'target'},
}

local ST = {
	-- Templar's Verdict with >= 5 Holy Power.
	{'85256', 'player.holypower >= 5', 'target'},
	-- Final Verdict with >= 5 Holy Power // TALENT (Replaces: Templar's Verdict).
	{'157048', 'player.holypower >= 5', 'target'},
	-- Crusader Strike to build Holy Power.
	{'35395', nil, 'target'},
	-- Judgment to build Holy Power.
	{'20271', nil, 'target'},
	-- Exorcism to build Holy Power.
	{'879', nil, 'target'},
}

local Keybinds = {
	{'pause', 'modifier.alt'},
	-- Fist of Justice
	{'105593', 'modifier.control'},
	-- Hammer of Justice
	{'105593', 'modifier.control'},
	-- Light's Hammer
	{'114158', 'modifier.shift', 'target.ground'},
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Seals},
}

ProbablyEngine.rotation.register_custom(70, NeP.Core.GetCrInfo('Paladin - Retribution'), 
	{-- In-Combat
		{Keybinds},
		{All},
		{Survival, 'player.health < 100'},
		-- Rebuke // Interrupt
		{'96231', 'target.NePinterrupt'},
		{EmpoweredSeals, 'talent(7, 1)'},
		{Seals},
		{Cooldowns, 'modifier.cooldowns'},
		-- Divine Storm with Divine Crusader proc.
		{'53385', 'player.buff(144595)', 'target'},
		-- Hammer of Wrath when target is below or equal 35% Health or with Avenging Wrath.
		{'158392', 'target.health <= 35', 'target'},
		{'158392', 'player.buff(31884)', 'target'},
		{AoE, (function() return NeP.Lib.SAoE(3, 8) end)},
		{ST}
	}, outCombat, exeOnLoad)