local dynEval 	= NeP.Core.dynEval
local PeFetch	= NeP.Core.PeFetch
local SAoE 		= NeP.Core.SAoE
local AutoDots 	= NeP.Core.AutoDots
local addonColor = '|cff'..NeP.Interface.addonColor

NeP.Interface.classGUIs[104] = {
	key = "NePConfDruidGuard",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Druid Guardian Settings",
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
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0 },
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0 },

		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General", align = "center"},
			{type = "checkbox", text = "Bear Form", key = "Bear", default = true, 
				desc = "This checkbox enables or disables the use of automatic Bear form."
			},

		-- Player
		{ type = 'rule' },
		{ type = 'header', text = "Survival", align = "center"},
			{type = "spinner", text = "Savage Defense", key = "SavageDefense", default = 95},
			{type = "spinner", text = "Frenzied Regeneration", key = "FrenziedRegeneration", default = 70},
			{type = "spinner", text = "Barkskin", key = "Barkskin", default = 70},
			{type = "spinner", text = "Cenarion Ward", key = "CenarionWard", default = 60},
			{type = "spinner", text = "Survival Instincts", key = "SurvivalInstincts", default = 40 },
			{type = "spinner", text = "Renewal", key = "Renewal", default = 40 },
			{type = "spinner", text = "Healthstone", key = "Healthstone", default = 50 },
			{type = "spinner", text = "Healing Tonic", key = "HealingTonic", default = 30 },
			{type = "spinner", text = "Smuggled Tonic", key = "SmuggledTonic", default = 30 },	

	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local keybinds = {
	{ "77761", "modifier.rshift" }, -- Stampeding Roar
	{ "5211", "modifier.lcontrol" }, -- Mighty Bash
	{ "!/focus [target=mouseover]", "modifier.ralt" }, -- Focus
	-- Rebirth
	{ "!/cancelform", { -- remove bear form
		"player.form > 0", 
		"player.spell(20484).cooldown < .001", 
		"modifier.lshift" 
	}}, 
	{ "20484", { -- Rebirth
		"modifier.lshift", 
		"!target.alive" 
	}, "target" }, 
	{ "!/cast Bear Form", {  -- bear form
		"!player.casting", "!player.form = 1", 
		"lastcast(20484)", 
		"modifier.lshift" 
	}},
}

local Shared = {
-- Buffs
  	{ "/cancelaura Bear Form", { 	-- Cancel player form
  		"player.form > 0",  		-- Is in any fom
  		"!player.buff(20217).any", 	-- kings
		"!player.buff(115921).any", -- Legacy of the Emperor
		"!player.buff(1126).any",   -- Mark of the Wild
		"!player.buff(90363).any",  -- embrace of the Shale Spider
		"!player.buff(69378).any",  -- Blessing of Forgotten Kings
  		"!player.buff(5215)" 		-- Not in Stealth
  	}},
	{ "1126", {  -- Mark of the Wild
		"!player.buff(20217).any", 	-- kings
		"!player.buff(115921).any", -- Legacy of the Emperor
		"!player.buff(1126).any",   -- Mark of the Wild
		"!player.buff(90363).any",  -- embrace of the Shale Spider
		"!player.buff(69378).any",  -- Blessing of Forgotten Kings
		"!player.buff(5215)",		-- Not in Stealth
		"player.form = 0" 			-- Player not in form
	}}, 

}

local Interrupts = {
	{ "106839" }, -- Skull Bash
	{ "5211" }, -- Mighty Bash
}

local Survival = {
-- Items
	{ "#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'Healthstone')) end) }, -- Healthstone
	{ "#109223", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'HealingTonic')) end) }, --  Healing Tonic
	{ "#117415", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'SmuggledTonic')) end) }, --  Smuggled Tonic

-- Def Cooldowns
	{ "62606", { -- Savage Defense
		"!player.buff", 
		(function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'SavageDefense')) end) 
	}},
	{ "22842", { -- Frenzied Regeneration
		"!player.buff",
		(function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'FrenziedRegeneration')) end),
		"player.rage >= 20"
	}},
	{ "22812",  (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'Barkskin')) end) }, -- Barkskin
	{ "102351", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'CenarionWard')) end), "player" }, -- Cenarion Ward
	{ "61336",  (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'SurvivalInstincts')) end) }, -- Survival Instincts
	{ "108238", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'Renewal')) end) }, -- Renewal	

	-- Dream of Cenarious
	{ "5185", {  -- Healing touch /  RAID/PARTY
		"lowest.health < 90", 
		"!player.health < 90",
		"player.buff(145162)" 
	}, "lowest" },
	{ "5185", {  -- Healing touch / PLAYER
		"player.health < 90", 
		"player.buff(145162)" 
	}, "player" },
}

local Cooldowns = {
	{ "50334"}, -- Berserk
	{ "124974"}, -- Nature's Vigil
	{ "102558"}, -- Incarnation
}

local inCombat = {
	-- Trash (AOE)
	{ 'Thrash', (function() return NeP.Core.SAoE(3, 8) end)},
	-- Growl (Taunt)
	{'Growl', (function() return NeP.Core.canTaunt() end)},
	-- Use Mangle on cooldown (its cooldown has a chance to be reset by Lacerate, so you need to watch out for this).
	{'Mangle'},
	-- Use Lacerate until it has 3 stacks on the target.
	{ 'Lacerate', '!target.debuff(Lacerate).count > 3' }, -- Lacerate
	-- Use Pulverize (consuming the Lacerate stacks).
	{'Pulverize'},
	-- Keep up the Thrash bleed (lasts 16 seconds).
	{'Thrash', '!target.debuff(Thrash)'},
	-- Use Maul only when
		--* you are under the effect of a Tooth and Claw proc;
		{'Maul', 'player.buff(Tooth and Claw)'},
	 	--* you are at or very close to maximum Rage;
	 	{'Maul', 'player.rage >= 80'},
		--* you do not need to use your active mitigation.
			-- FIXME: TODO
	-- Re-stack Lacerate to 3 before the 12-second buff from Pulverize expires.
	{ 'Lacerate' },
}

local outCombat = {
	{keybinds},
	{Shared}
}

ProbablyEngine.rotation.register_custom(104, NeP.Core.GetCrInfo('Druid - Guardian'), 
	{ -- Incombat
		{keybinds},
		{Shared},
		{Survival, 'player.health < 100'},
		-- Bear Form
		{ "5487", { 
	  		"player.form != 1", 	-- Stop if bear
	  		"!player.buff(5215)", 	-- Not in Stealth
	  		(function() return PeFetch('NePConfDruidGuard', 'Bear') end),
	  	}},	
		{Interrupts, "target.NePinterrupt"},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat}
	}, outCombat, exeOnLoad)