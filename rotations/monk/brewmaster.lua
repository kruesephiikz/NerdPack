NeP.Interface.MonkWw = {
	key = 'NePConfigMonkBM',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Monk Brewmaster Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- General
		{type = 'header',text = 'General', align = 'center' },
			-- Nothing yet

		-- Survival
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Survival', align = 'center'},
			{type = 'spinner', text = 'Healthstone', key = 'Healthstone', default = 75},
	}
}

local castBetwenUnits = function(spell)
	if UnitExists('target') and FireHack then
		Cast(spell)
		CastAtPosition(GetPositionBetweenObjects('player', 'target', GetDistanceBetweenObjects('player', 'target')/2))
		CancelPendingSpell()
		return true
	end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
end

local _All = {
	-- Keybinds
	{'pause', 'modifier.shift'},
	{'119381', 'modifier.control'}, -- Leg Sweep
	{'122470', 'modifier.alt'}, -- Touch of Karma
	
	-- Buffs
	{'116781', '!player.buffs.stats'}, -- Legacy of the White Tiger
	
	-- FREEDOOM!
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

local _Cooldowns = {

}

local _Survival = {
	{'Expel Harm'},
	{'Guard'},
}

local _Interrupts = {

}

local _Ranged = {

}

local _Melle = {
	{'Elusive Brew', 'player.buff(Elusive Brew).count > 9', 'target'},
	-- Purifying Brew to remove your Stagger DoT when Yellow or Red.
	{'Blackout Kick', '!player.buff(Shuffle)', 'target'},
	{'Blackout Kick', 'player.chi >= 4', 'target' },
	{'Tiger Palm', '!player.buff(Tiger Power)', 'target'},
	{'Keg Smash', 'player.chi <= 2', 'target'},
	{'Jab'}
}

local _AoE = {
}

ProbablyEngine.rotation.register_custom(268, NeP.Core.GetCrInfo('Monk - Brewmaster'),
	{-- In-Combat
		{_All},
		{_Survival, 'player.health < 100'},
		{_Interrupts, 'target.NePinterrupt'},
		{_Cooldowns, 'modifier.cooldowns'},
		-- Summon Black Ox Statue
		{'115315' , {
			'!player.totem(Black Ox Statue)',
			(function() return castBetwenUnits('115313') end)
		}},
		{{-- Conditions
			{_AoE, (function() return NeP.Lib.SAoE(3, 8) end)},
			{_Melle, {'target.inMelee', 'target.NePinfront'}},
			{_Ranged, {'!target.inMelee', 'target.inRanged'}}
		}, {'target.range <= 40', 'target.exists'}}
	}, _All, exeOnLoad)
