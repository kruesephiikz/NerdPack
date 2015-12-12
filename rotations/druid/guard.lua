local dynEval 	= NeP.Core.dynEval
local PeFetch	= NeP.Core.PeFetch
local SAoE 		= NeP.Core.SAoE
local canTaunt 	= NeP.Core.canTaunt
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
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0},
			-- Shift
			{type = 'text', text = addonColor..'Shift:', align = 'left', size = 11, offset = -11},
			{type = 'text', text = '...', align = 'right', size = 11, offset = 0},
			-- Alt
			{type = 'text', text = addonColor..'Alt:',align = 'left', size = 11, offset = -11},
			{type = 'text', text = 'Pause Rotation', align = 'right', size = 11, offset = 0},

		-- General
		{type = 'rule'},
		{type = 'header', text = "General", align = "center"},
			{type = "checkbox", text = "Bear Form", key = "Bear", default = true, 
				desc = "This checkbox enables or disables the use of automatic Bear form."
			},

		-- Player
		{type = 'rule'},
		{type = 'header', text = "Survival", align = "center"},
			{type = "spinner", text = "Healthstone", key = "Healthstone", default = 50},
	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local keybinds = {
	-- Pause
	{'pause', 'modifier.alt'},
}

local Shared = {
	-- Cancel player form ( Needed before buffing )
  	{"/cancelaura Bear Form", '!player.buffs.stats'},
  	-- Mark of the Wild
	{"Mark of the Wild", '!player.buffs.stats'}, 
}

local Interrupts = {
	-- Skull Bash
	{"Skull Bash"},
	-- Mighty Bash
	{"Mighty Bash"},
}

local Survival = {
	-- Healthstone
	{"#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfDruidGuard', 'Healthstone')) end)},
}

local Cooldowns = {
	--[[Frenzied Regeneration converts up to 60 Rage into health. 
	The ability has a 1.5 second cooldown (but this is affected by your Haste).]]
	{'Frenzied Regeneration'},
	
	--[[Savage Defense increases your dodge chance by 45% for 6 seconds and reduces your Physical damage taken by 25% for the same duration. 
	This ability works on a charge system. 
	You can have a maximum of 2 charges, and it has a 12-second recharge time.]]
	{'Savage Defense'},

	--[[Survival Instincts reduces all damage taken by 50% for 6 seconds. 
	It works a charge system. 
	It has a maximum of 2 charges, and it has a 2-minute recharge time.]]
	{'Survival Instincts'},

	--[[Barkskin is a simple 20% damage reduction, lasting 12 seconds, with a 1-minute cooldown.]]
	{'Barkskin'},
}

local inCombat = {
	-- Trash (AOE)
	{'Thrash', (function() return SAoE(3, 8) end)},
	-- Growl (Taunt)
	{'Growl', (function() return canTaunt() end)},
	-- Use Mangle on cooldown (its cooldown has a chance to be reset by Lacerate, so you need to watch out for this).
	{'Mangle'},
	-- Use Lacerate until it has 3 stacks on the target.
	{'Lacerate', '!target.debuff(Lacerate).count > 3'}, -- Lacerate
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
	{'Lacerate'},
}

local outCombat = {
	{keybinds},
	{Shared}
}

ProbablyEngine.rotation.register_custom(104, NeP.Core.GetCrInfo('Druid - Guardian'), 
	{-- Incombat
		{keybinds},
		{Shared},
		{Survival, 'player.health < 100'},
		-- Bear Form
		{"5487", {
	  		"player.form != 1", 	-- Stop if bear
	  		"!player.buff(5215)", 	-- Not in Stealth
	  		(function() return PeFetch('NePConfDruidGuard', 'Bear') end),
	  	}},	
		{Interrupts, "target.NePinterrupt"},
		{Cooldowns, 'modifier.cooldowns'},
		{inCombat}
	}, outCombat, exeOnLoad)