NeP.Interface.MonkWw = {
	key = "NePConfigMonkBM",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Monk Brewmaster Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ 
			type = 'header',
			text = "General settings:", 
			align = "center" 
		},
			{ 
				type = "checkbox", 
				text = "SEF", 
				key = "SEF", 
				default = true,
			},

			-- NOTHING IN HERE YET...

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},
			
			-- Survival Settings:
			
			
	}
}

local n,r = GetSpellInfo('137639')

local _SEF = function()
	if NeP.Lib.SAoE(3, 40) then
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i]
			if ProbablyEngine.condition["deathin"](object.key) >= 10 then
				if UnitGUID('target') ~= UnitGUID(object.key) then
					if UnitAffectingCombat(object.key) then
						local _,_,_,_,_,_,debuff = UnitDebuff(object.key, GetSpellInfo(137639), nil, "PLAYER")
						if not debuff and NeP.Core.dynamicEval("!player.buff(137639).count = 2") then
							if NeP.Core.Infront('player', object.key) then
								ProbablyEngine.dsl.parsedTarget = object.key
								return true 
							end
						end
					end
				end
			end
		end
	end
	return false
end

local castBetwenUnits = function(spell)
	if UnitExists('target') then
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
	{ "pause", "modifier.shift" },
	{ "119381", "modifier.control" }, -- Leg Sweep
	{ "122470", "modifier.alt" }, -- Touch of Karma
	
	-- Buffs
	{ "115921", "!player.buffs.stats"},-- Legacy of the Emperor
	
	-- FREEDOOM!
	{ "137562", "player.state.disorient" }, -- Nimble Brew = 137562
	{ "116841", "player.state.disorient" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.fear" }, -- Nimble Brew = 137562
	{ "116841", "player.state.stun" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.stun" }, -- Nimble Brew = 137562
	{ "137562", "player.state.root" }, -- Nimble Brew = 137562
	{ "116841", "player.state.root" }, -- Tiger's Lust = 116841
	{ "137562", "player.state.horror" }, -- Nimble Brew = 137562
	{ "137562", "player.state.snare" }, -- Nimble Brew = 137562
	{ "116841", "player.state.snare" }, -- Tiger's Lust = 116841
}

local _Cooldowns = {

}

local _Survival = {
	{ "Expel Harm" },
	{ "Guard" },
}

local _Interrupts = {

}

local _SEF = {
	{ "137639", (function() return _SEF() end) },
	{ "/cancelaura "..n, "target.debuff(137639)", "target"}, -- Storm, Earth, and Fire
}

local _Ranged = {

}

local _Melle = {
	{ "Elusive Brew", "player.spell(Elusive Brew).stacks > 9", "target" },
	-- Purifying Brew to remove your Stagger DoT when Yellow or Red.
	{ "Blackout Kick", "!player.buff(Shuffle)", "target" },
	{ "Blackout Kick", "player.chi >= 4", "target"  },
	{ "Tiger Palm", "!player.buff(Tiger Power)", "target" },
	{ "Keg Smash", "player.chi <= 2", "target" },
	{ "Jab" }
}

local _AoE = {
}

ProbablyEngine.rotation.register_custom(268, NeP.Core.GetCrInfo('Monk - Brewmaster'),
	{ -- In-Combat
		{_All},
		{_Survival, 'player.health < 100'},
		{_Interrupts, "target.NePinterrupt"},
		{_Cooldowns, "modifier.cooldowns"},
		-- Summon Black Ox Statue
		{ "115315" , {
			"!player.totem(Black Ox Statue)",
			(function() return castBetwenUnits("115313") end)
		}},
		{_SEF, (function() return NeP.Core.PeFetch('NePConfigMonkBM', 'SEF') end)},
		{{ -- Conditions
			{_AoE, (function() return NeP.Lib.SAoE(3, 8) end)},
			{_Melle, { "target.inMelee", "target.NePinfront" }},
			{_Ranged, { "!target.inMelee", "target.inRanged" }}
		}, {"target.range <= 40", "target.exists"} }
	}, _All, exeOnLoad)
