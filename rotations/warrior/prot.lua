local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[73] = {
	key = 'NePConfigWarrProt',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warrior Protection Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'header',text = 'General', align = 'center'},
			{type = 'dropdown',text = 'Shout', key = 'Shout', 
				list = {
			    	{text = 'Battle Shout', key = 'Battle Shout'},
			        {text = 'Commanding Shout', key = 'Commanding Shout'},
		    	}, 
		    	default = 'Battle Shout', 
		    	desc = 'Select what buff to use.' 
		   },
		
		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Rallying Cry', key = 'RallyingCry', default = 15,},
			{type = 'spinner',text = 'Last Stand', key = 'LastStand', default = 25,},
			{type = 'spinner',text = 'Shield Wall', key = 'ShieldWall', default = 30,},
			{type = 'spinner',text = 'Shield Barrier - Rage', key = 'ShieldBarrier', default = 80,},
			{type = 'spinner',text = 'Enraged Regeneration', key = 'ERG', default = 60,},

	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local inCombat_Defensive = {
	{'Heroic Strike', {
		'player.rage > 75', 
		'target.health >=20'
	}, 'target'},
	{'Execute', {
		'player.rage > 75', 
		'target.health <=20'
	}, 'target'},
	{'Shield Slam'},
	{'Revenge'},
	{'Devastate'},
	{'Thunder Clap', {
		'target.range <= 4',
		'target.debuff(Deep Wounds).duration < 2'
	}},	
}

local inCombat_Gladiator = {
	{'Shield Charge', '!player.buff(Shield Charge)' },
	{'Shield Charge', 'spell(Shield Charge).charges >= 2' },
	{'Heroic Strike', 'player.buff(Shield Charge)' },
	{'Heroic Strike', 'player.buff(Ultimatum)' },
	{'Heroic Strike', 'player.rage >= 95' },
	{'Shield Slam' },
	{'Revenge' },
	{'Execute' },
	{'Devastate' }
}

local Battle_Print = false

local inCombat_Battle = {
	{ "/run print('[MTS] This stance is not yet supported! :(')", 
		(function() 
			if Battle_Print == false then 
				Battle_Print = true 
				return true 
			end
			return false
		end)
	},
	{'71', {
		'player.stance != 2',
		(function() 
			Battle_Print = false 
			return true
		end)
	}},
}

local AoE = {
	{'Thunder Clap', {
		'target.range <= 4',
		'target.debuff(Deep Wounds).duration < 2'
	}},	
}

local Survival = {
	-- Def Cooldowns
  	{'Rallying Cry', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigWarrProt', 'RallyingCry')) end) },  
  	{'Last Stand', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigWarrProt', 'LastStand')) end) },
  	{'Shield Wall', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigWarrProt', 'ShieldWall')) end) },
  	{'Shield Block', '!player.buff(Shield Block)'},
  	{'Shield Barrier', { 
  		'!player.buff(Shield Barrier)',
  		(function() return dynEval('player.rage >= ' .. PeFetch('NePConfigWarrProt', 'ShieldBarrier')) end)
  	}},

  	-- Self Heals
  	{'Impending Victory', 'player.health <= 85'},
  	{'Victory Rush', 'player.health <= 85'},
  	{'#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigWarrProt', 'Healthstone')) end) }, --Healthstone
	{'Enraged Regeneration', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigWarrProt', 'ERG')) end)},
}

local Cooldowns = {
	{'Bloodbath'},
  	{'Avatar'},
  	{'Recklessness', 'target.range <= 8'},
  	{'Skull Banner'},
  	{'Bladestorm', 'target.range <= 8'},
  	{'Berserker Rage'},
  	{'#gloves'},
}

ProbablyEngine.rotation.register_custom(73, NeP.Core.GetCrInfo('Warrior - Protection'), 
	{-- In-Combat CR
		{'6673', {-- Battle Shout
			'!player.buffs.attackpower',
			(function() return PeFetch('NePConfigWarrProt', 'Shout') == 'Battle Shout' end),
			}},
		{'469', {-- Commanding Shout
			'!player.buffs.stamina',
			(function() return PeFetch('NePConfigWarrProt', 'Shout') == 'Commanding Shout' end),
		}},
		{'6544', 'modifier.shift', 'ground' }, -- Heroic Leap
  		{'5246', 'modifier.control' }, -- Intimidating Shout
		{'100', {  -- Charge
			'modifier.alt', 
			'target.spell(100).range' 
		}, 'target'},
		{{-- Interrupts
			{'6552' }, -- Pummel
	  		{'Disrupting Shout', 'target.range <= 8', 'target' },
	  		{'114028' }, -- Mass Spell Reflection
	  	}, 'target.NePinterrupt' },
  		{'Will of the Forsaken', 'player.state.fear' },
  		{'Will of the Forsaken', 'player.state.charm' },
  		{'Will of the Forsaken', 'player.state.sleep' },
		{'Heroic Strike', 'player.buff(Ultimatum)', 'target' },
  		{'Shield Slam', 'player.buff(Sword and Board)', 'target' },
  		{ Survival },
  		{ Cooldowns, 'modifier.cooldowns' },
  		{ AoE, (function() return NeP.Core.SAoE(3, 40) end) },
		{{ -- Stance 1
			{ inCombat_Gladiator, 'talent(7,3)' },
			{ inCombat_Battle, '!talent(7,3)' },
		}, 'player.stance = 1' },
		{ inCombat_Defensive, 'player.stance = 2' },
		{'57755', 'player.range > 10', 'target' } -- Heroic Throw
	},
	{-- Out-Combat CR
		{'6673', {-- Battle Shout
			'!player.buffs.attackpower',
			(function() return PeFetch('NePConfigWarrProt', 'Shout') == 'Battle Shout' end),
			}},
		{'469', {-- Commanding Shout
			'!player.buffs.stamina',
			(function() return PeFetch('NePConfigWarrProt', 'Shout') == 'Commanding Shout' end),
		}},
		{'6544', 'modifier.shift', 'ground' }, -- Heroic Leap
  		{'5246', 'modifier.control' }, -- Intimidating Shout
		{'100', { -- Charge
			'modifier.alt', 
			'target.spell(100).range' 
		}, 'target'}, 
	}, exeOnLoad)