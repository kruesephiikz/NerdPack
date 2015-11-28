NeP.Interface.classGUIs[265] = {
	key = 'NePConfWarlockAff',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warlock Affliction Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds', align = 'center'},		
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'DPS', align = 'center'},
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Survival', align = 'center'},
			--stuff
	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local Shared = {
	-- Buff
	{'Dark Intent', '!player.buff(Dark Intent)'},
}

local Cooldowns = {
	
}

local Moving = {
	
}

local AoE = {
	{{-- Against 4 or more enemies, 
		-- you should start replacing Drain Soul with Seed of Corruption as your filler spell. 
			-- FIXME: TO BE DONE
		-- Use Soulburn Icon Soulburn+Seed of Corruption to apply Corruption and prioritise maintaining Agony over Unstable Affliction. 
			-- FIXME: TO BE DONE
		-- If you need burst AoE damage, you should simply spam Seed of Corruption, as DoTs will not have enough time to tick.
			-- FIXME: TO BE DONE
		-- If Cataclysm is your Tier 7 talent, then you need to use it on cooldown.
		{'Cataclysm', nil, 'target.ground'},
	}, (function() return NeP.Core.SAoE(4, 40) end) },

	{{-- Against 2 and 3 enemies, 
		-- use your normal rotation on one of them and keep your DoTs up on the others.
		{'Agony', (function() return NeP.Core.AutoDots('Agony') end)},
		{'Corruption', (function() return NeP.Core.AutoDots('Corruption') end)},
		{'Unstable Affliction', (function() return NeP.Core.AutoDots('Unstable Affliction') end)},
	}, (function() return NeP.Core.SAoE(2, 40) end) },
}

local inCombat = {
	-- Apply Agony and refresh it when it has less than 7.2 seconds remaining.
	{'Agony', 'target.debuff(Agony).duration <= 7.2', 'target'},
	-- Apply Corruption and refresh it when it has less than 5.4 seconds remaining.
	{'Corruption', 'target.debuff(Corruption).duration <= 5.4', 'target'},
	-- Apply Unstable Affliction and refresh it when it has less than 4.2 seconds remaining.
	{'Unstable Affliction', 'target.debuff(Unstable Affliction).duration <= 4.2', 'target'},
	
	{{ -- Cast Haunt Icon Haunt when: one of the following is true
		-- you have a trinket proc;
			-- FIXME: TO BE DONE
		-- Dark Soul: Misery Icon Dark Soul: Misery is up;
		{'Haunt', 'player.buff(Dark Soul: Misery)', 'target'},
		-- the boss is approaching death;
		{'Haunt', {
			'target.boss',
			'target.ttd < 15'
		}, 'target'},
		-- you have at least 3 Soul Shards (so that you have Soul Shards left when Dark Soul is up).
		{'Haunt', 'player.soulshards >= 3', 'target'},
	},{
		{'!target.debuff(Haunt)'},
		{'player.soulshards >= 4'},
	}},
	
	-- Cast Drain Soul as a filler.
	{'Drain Soul'},
}

local outCombat = {
	{Shared},
}

ProbablyEngine.rotation.register_custom(265, NeP.Core.GetCrInfo('Warlock - Affliction'),
	{ -- In-Combat
		{Shared},
		{Moving, "player.moving"},
		{{ -- Conditions
			{Cooldowns, "modifier.cooldowns"},
			{'Life Tap', {'player.mana < 20', '!player.health < 30'}},
			{AoE},
			{inCombat}
		}, "!player.moving" },
	},outCombat, exeOnLoad)