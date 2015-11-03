local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[64] = {
	key = 'NePConfigMageFrost',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Mage Frost Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ 
			type = 'header',
			text = 'General settings:', 
			align = 'center' 
		},
			--Empty
		{ type = 'spacer' },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = 'Survival Settings', 
			align = 'center' 
		},
			
			-- Survival Settings:
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

local lib = function()
	NeP.Splash()
  	ProbablyEngine.toggle.create(
  		'cleave', 
  		'Interface\\Icons\\spell_frost_frostbolt', 
  		'Disable Cleaves', 
  		'Disable casting of Cone of Cold and Ice Nova for Procs.')
end


local Survival = {
	{ '#5512', (function() return dynEval('player.health <= ' .. PeFetch('NePConfigMageFrost', 'Healthstone')) end) }, --Healthstone
	{ '1953', 'player.state.root' }, -- Blink
	{ '475', { -- Remove Curse
		'!lastcast(475)', 
		'player.dispellable(475)' 
	}, 'player' }, 
}

local Cooldowns = {
	{ 'Rune of Power', { '!player.buff(Rune of Power)', '!player.moving' }, 'player.ground' }, 
	{ '12472' },--Icy Veins
	{ 'Mirror Image' },
}

local inCombat = {

	-- Moving
	{ 'Ice Floes', 'player.moving' },

	-- Procs
	{ '44614', 'player.buff(Brain Freeze)', 'target' },-- Frostfire Bolt
	{ '30455', 'player.buff(Fingers of Frost)', 'target' },-- Ice Lance

	-- Frost Bomb
	{ 'Frost Bomb', { 
		'target.debuff(Frost Bomb).duration <= 3', 
		'talent(5, 1)' 
	}},

	-- AoE
	{ '84714', (function() return NeP.Lib.SAoE(3, 40) end) },--Frozen Orb
	{ 'Ice Nova', { 
		(function() return NeP.Lib.SAoE(3, 40) end), 
		'talent(5, 3)' 
	}},
	{ '120', (function() return NeP.Lib.SAoE(3, 40) end) },--Cone of Cold
	{ '10', (function() return NeP.Lib.SAoE(3, 40) end), 'target.ground' },--Blizzard

	-- Main Rotation
	{ '84714', '!toggle.cleave' }, -- Frozen Orb
	{ 'Ice Nova', { '!toggle.cleave', 'talent(5, 3)' } },
	{ '120', { '!toggle.cleave' } },--Cone of Cold
	{ '116' },--Frostbolt
	
}

local outCombat = {
	-- Buffs
	{ 'Arcane Brilliance', '!player.buff(Arcane Brilliance)' },
	{ 'Summon Water Elemental', '!pet.exists'}
}

ProbablyEngine.rotation.register_custom(64, NeP.Core.GetCrInfo('Mage - Frost'),
	{ -- In-Combat
		-- Rotation Utilities
		{ 'pause', 'modifier.lalt' },
		{ 'Rune of Power', 'modifier.lcontrol', 'player.ground' },
		{ '2139', 'target.NePinterrupt' },--Counterspell
		{Survival, 'player.health < 100'},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat, { 'target.NePinfront', 'target.exists', 'target.range <= 40' }},
	}, outCombat, lib)