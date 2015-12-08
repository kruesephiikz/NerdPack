local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch
local addonColor = NeP.Interface.addonColor

NeP.Interface.classGUIs[268] = {
	key = 'NePConfigMonkBM',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Monk Brewmaster Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- Keybinds
		{type = 'header', text = "|cff"..addonColor..'Keybinds:', align = 'center'},
			-- Control
			{type = 'text', text = "|cff"..addonColor..'Control: ', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = "right", size = 11, offset = 0 },
			-- Shift
			{type = 'text', text = "|cff"..addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = "right", size = 11, offset = 0 },
			-- Alt
			{type = 'text', text = "|cff"..addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = "right", size = 11, offset = 0 },

		-- General
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = "|cff"..addonColor..'General', align = 'center' },
			-- Nothing yet

		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = "|cff"..addonColor..'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 75},
	}
}

local castBetwenUnits = function(spell)
	if UnitExists('target') and FireHack then
		Cast(spell)
		CastAtPosition(GetPositionBetweenObjects('target', 'player', 10))
		CancelPendingSpell()
		return true
	end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
end

local All = {
	-- Keybinds
	{'pause', 'modifier.alt'},
	
	-- Buffs
	{'116781', '!player.buffs.stats'}, -- Legacy of the White Tiger
}

local FREEDOOM = {
	{'137562', 'player.state.disorient'}, -- Nimble Brew = 137562
	{'116841', 'player.state.disorient'}, -- Tiger's Lust = 116841
	{'137562', 'player.state.fear'}, -- Nimble Brew = 137562
	{'116841', 'player.state.stun'}, -- Tiger's Lust = 116841
	{'137562', 'player.state.stun'}, -- Nimble Brew = 137562
	{'137562', 'player.state.root'}, -- Nimble Brew = 137562
	{'116841', 'player.state.root'}, -- Tiger's Lust = 116841
	{'137562', 'player.state.horror'}, -- Nimble Brew = 137562
	{'137562', 'player.state.snare'}, -- Nimble Brew = 137562
	{'116841', 'player.state.snare'}, -- Tiger's Lust = 116841
}

local Cooldowns = {

}

local Survival = {
	-- Expel Harm
	{'115072'},
	-- Guard
	{'115295'},
	--Healthstone
	{'#5512', (function() return dynEval('player.health <= '..PeFetch('NePConfigMonkBM', 'Healthstone')) end)},
	-- Fortifying Brew
	{'115203', 'player.health < 30'},
}

local Interrupts = {
	-- Spear Hand Strike
	{'116705'},
}

local Ranged = {
	-- Crackling Jade Lightning
	{'117952'},
}

local Taunts = {
	-- Provoke
	{'115546', 'target.range <= 35'},
}

local Melle = {
	--[[Use Blackout Kick, to maintain high uptime on Shuffle, the self-buff that it applies.]]
	{'100784', '!player.buff(Shuffle)'},

	--[[Use Keg Smash on cooldown (it generates 2 Chi, so only use when you have 2 or less).]]
	{'121253', 'player.chi <= 2'},

	--[[Use Jab. This is your default Chi builder, and your primary source of dumping Energy. 
	It should only be used when you have around 80 Energy, to prevent capping it.]]
	{'108557', 'player.energy >= 80'},

	--[[Use Tiger Palm to fill any spare global cooldowns. 
	The ability has no resource cost, and it has the benefit of applying a damage-increasing (rather, armor-ignoring) 
	self-buff called Tiger Power. Make sure to maintain 100% uptime on this buff.]]
	{'100787'},
}

local AoE = {
	-- Cast Keg Smash.
	{'121253'},
	
	-- Use Rushing Jade Wind, if you have taken this talent.
	{'Rushing Jade Wind'},

	-- If you have not taken Rushing Jade Wind, use Spinning Crane Kick as a filler.]]
	{'101546'},

	--[[If you have taken Chi Explosion as your tier 7 talent, then use this with 2 Chi in order to build Shuffle, 
	and once you have enough duration on Shuffle (or you do not need it), use Chi Explosion with 4 Chi.]]

	--[[Breath of Fire should only be used against adds that you wish to prevent from casting spells, 
	but it should not otherwise be part of your rotation.]]
}

ProbablyEngine.rotation.register_custom(268, NeP.Core.GetCrInfo('Monk - Brewmaster'),
	{-- In-Combat
		{All},
		{Survival, 'player.health < 100'},
		{Interrupts, 'target.NePinterrupt'},
		{FREEDOOM},
		{Taunts, (function() return NeP.Core.canTaunt() end)},
		{Cooldowns, 'modifier.cooldowns'},
		-- Elusive Brew
		{'115308', 'player.buff(115308).count >= 10'},
		{{-- Conditions
			{AoE, (function() return NeP.Core.SAoE(3, 8) end)},
			{Melle, {'target.inMelee', 'target.NePinfront'}},
			--{Ranged, {'!target.inMelee', 'target.inRanged'}}
		}, {'target.range <= 40', 'target.exists'}}
	}, All, exeOnLoad)
