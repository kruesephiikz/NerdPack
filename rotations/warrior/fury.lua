NeP.Interface.WarrFury = {
	key = "NePConfigWarrFury",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Warrior Fury Settings",
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

			-- NOTHING IN HERE YET...

		{ type = "spacer" },
		{ type = 'rule' },
		{ 
			type = "header", 
			text = "Survival Settings", 
			align = "center" 
		},
			
			-- Survival Settings:
			{ 
				type = "dropdown",
				text = "Shout", 
				key = "Shout", 
				list = {
			    	{
			          text = "Battle Shout",
			          key = "Battle Shout"
			        },
			        {
			          text = "Commanding Shout",
			          key = "Commanding Shout"
			    	},
		    	}, 
		    	default = "Battle Shout", 
		    	desc = "Select what buff to use." 
		    },
			{
				type = "spinner",
				text = "Rallying Cry - HP",
				key = "RallyingCry",
				width = 50,
				min = 0,
				max = 100,
				default = 15,
				step = 5
			},
			{
				type = "spinner",
				text = "Die by the Sword - HP",
				key = "DBTS",
				width = 50,
				min = 0,
				max = 100,
				default = 25,
				step = 5
			},
			{
				type = "spinner",
				text = "Impending Victory - HP",
				key = "IVT",
				width = 50,
				min = 0,
				max = 100,
				default = 100,
				step = 5
			},
			{
				type = "spinner",
				text = "Enraged Regeneration - HP",
				key = "ERG",
				width = 50,
				min = 0,
				max = 100,
				default = 60,
				step = 5
			},

	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local All = {

		{ "6673", {----------------------------------------------- Battle Shout
			"!player.buffs.attackpower",
			(function() return NeP.Core.PeFetch("NePConfigWarrFury", "Shout") == 'Battle Shout' end),
		}},
		{ "469", {------------------------------------------------ Commanding Shout
			"!player.buffs.stamina",
			(function() return NeP.Core.PeFetch("NePConfigWarrFury", "Shout") == 'Commanding Shout' end),
		}}, 
		{ "6544", "modifier.shift", "target.ground" }, 			-- Heroic Leap // FH
	  	{ "5246", "modifier.control" }, 						-- Intimidating Shout
		{ "100", { 		------------------------------------------ Charge
			"modifier.alt", 			-- Holding Alt Key
			"target.spell(100).range" 	-- Spell in range
		}, "target"},
		
}

local racials = {
	
	-- Dwarves
	{ "20594", "player.health <= 65" },
	-- Humans
	{ "59752", "player.state.charm" },
	{ "59752", "player.state.fear" },
	{ "59752", "player.state.incapacitate" },
	{ "59752", "player.state.sleep" },
	{ "59752", "player.state.stun" },
	-- Draenei
	{ "28880", "player.health <= 70", "player" },
	-- Gnomes
	{ "20589", "player.state.root" },
	{ "20589", "player.state.snare" },
	-- Forsaken
	{ "7744", "player.state.fear" },
	{ "7744", "player.state.charm" },
	{ "7744", "player.state.sleep" },
	-- Goblins
	{ "69041", "player.moving" },

}

local Cooldowns = {
	
	-- Cooldowns
		{ "12292" },							-- Bloodbath // Talent
  		{ "107574" },							-- Avatar // Talent
  		{ "152277", nil, "target.ground" }, 	-- Ravager // Talent
  		{ "107570" }, 							-- Storm Bolt // Talent
  		{ "118000" }, 							-- Dragon Roar // Talent
  		{ "176289" },							-- Siegebreaker // Talent
  		{ "1719" }, 							-- Recklessness Use as often as possible. Stack with other DPS cooldowns.
  		{ "46924" }, 							-- Bladestorm // Talent
  		{ "18499" },							-- Berserker Rage Use as needed to maintain Enrage.
  		{ "#gloves" },
	
	--[[ Items
		{ "#5512" }, --Healthstone ]]

}

local Survival = {
	
	{ "97462", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrFury', 'RallyingCry')) end) }, -- Rallying Cry
  	{ "118038", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrFury', 'DBTS')) end) }, 		-- Die by the Sword
  	{ "103840", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrFury', 'IVT')) end) }, 		-- Impending Victory
	{ "55694", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePConfigWarrFury', 'ERG')) end) }, 		-- Enraged Regeneration

}

--[[ ///---INFO---////
With 3 or less targets, you should use Bloodthirst on cooldown to maintain Enrage. 
Use Whirlwind with >= 80 Rage and to stack the Raging Blow buff. 
Use Raging Blow when there are 2-3 stacks of the buff. 
Use Wild Strike as needed to consume Bloodsurge procs. 
With 4+ targets, place a higher emphasis on Whirlwind and continue to use it to dump Rage even with max Raging Blow stacks.
  ///---INFO---////  ]]
local AoE = {

	{ "152277", nil, "target.ground" }, 			-- Ravager // Talent
	{ "118000" }, 									-- Dragon Roar // Talent
	{ "23881" }, 									-- Bloodthirst on cooldown to maintain Enrage. Procs Bloodsurge.
	{ "1680", "player.rage >= 70" }, 				-- Whirlwind as a Rage dump and to build Raging Blow stacks.
	{ "85288" }, 									-- Raging Blow with Raging Blow stacks.
	{ "46924" }, 									-- Blade Storm // Talent

}

--[[ ///---INFO---////
The Execute priorty is similar to the Normal priority but places more emphasis on the use of Execute. 
To follow this priority, use Execute instead of Wild Strike to prevent capping your Rage. 
Continue to use Bloodthirst on cooldown when not Enraged in order to proc Enrage and Bloodsurge. 
Now, use Execute while Enrage or whenever you go above 60 Rage. 
Finally, continue to use Wild Strike while Enrage or to consume Bloodsurge procs.
  ///---INFO---////  ]]
local Execute = {

	{ "5308", "player.rage >= 80", "target" }, 		-- Execute to prevent capping your Rage.
	{ "23881" }, 									-- Bloodthirst on cooldown to maintain Enrage. Procs Bloodsurge.
	{ "5308", "player.rage >= 60", "target" }, 		-- Execute while Enrage.
	{ "5308", "player.buff(Enraged)", "target" }, 	-- Execute with >= 60 Rage.
	{ "100130", "player.buff(Enraged)", "target" }, -- Wild Strike while Enrage or with Bloodsurge procs.

}

--[[ ///---INFO---////
The Normal rotation should be followed while your target is above 20% health and 
  then you should switch to the Exectue rotation when your target drops below 20% health.
The Normal priority uses Wild Strike when necessary to prevent capping your Rage. 
After this, use Bloodthirst on cooldown when not Enraged in order to try and proc Enrage as well as Bloodsurge. 
Next, use Raging Blow whenever available. 
Also, use Wild Strike when Enraged or to consume Bloodsurge procs.
  ///---INFO---////  ]]
local Normal = {

	{ "100130", "player.rage > 80", "target" },	 	-- Wild Strike to prevent capping your Rage.
	{ "23881", "!player.buff(Enraged)", "target" }, -- Bloodthirst on cooldown when not Enraged. Procs Bloodsurge.
	{ "100130", "player.buff(Enraged)", "target" }, -- Wild Strike when Enraged.

}

ProbablyEngine.rotation.register_custom(72, NeP.Core.GetCrInfo('Warrior - Fury'), 
	{-- Incombat
		{ "57755", "player.range > 10", "target" }, 	-- Heroic Throw // Ranged
		{ "2457", "player.seal != 1" }, 				-- Battle Stance
		{{-- Interrupt
			{ "6552", (function() return NeP.Core.dynamicEval("target.interruptsAt(" .. NeP.Core.PeFetch('NePConf', 'ItA') or 40)..")" end) }, 			-- Pummel
			{ "23920", (function() return NeP.Core.dynamicEval("target.interruptsAt(" .. NeP.Core.PeFetch('NePConf', 'ItA') or 40)..")" end) }, 		-- Spell Reflection
		}, "target.NePinterrupt" },
		{ All },										-- Shared across all
		{ Survival },									-- Survival
		{ Cooldowns, "modifier.cooldowns" },			-- Cooldowns
		{ "5308", "player.buff(52437)", "target" }, 	-- Proc // Execute, Sudden Death
		{ "34428" }, 									-- Victory Rush
		{ "100130", "player.buff(46916)", "target" },	-- Wild Strike to consume Bloodsurge procs.
		{ "85288" }, 									-- Raging Blow when available.
		{ Execute, "target.health <= 20" },				-- Execute
		{ AoE, (function() return NeP.Lib.SAoE(3, 40) end) },-- AoE Forced
		{ Normal, "target.health >= 20" }				-- Normal CR
	}, 
	{ -- Out Combat
		{ "2457", "player.seal != 1" }, 				-- Battle Stance
		{ All }
	}, 
	exeOnLoad)