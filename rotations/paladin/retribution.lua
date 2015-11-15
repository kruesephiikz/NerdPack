local dynEval = NeP.Core.dynEval
local PeFetch = NeP.Core.PeFetch

NeP.Interface.classGUIs[70] = {
	key = "NePConfPalaRet",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Paladin Retribution Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		-- [[ General ]]
		{type = "text", text = "General", align = "center" },
			-- Buff
			{ type = "dropdown",text = "Buff:", key = "Buff", list = {
				{text = "Kings", key = "Kings"},
				{text = "Might", key = "Might"}
        	}, default = "Kings", desc = "Select What buff to use The moust..." },
       
        -- [[ DPS ]]
		{type = "rule"},
		{type = "text", text = "DPS", align = "center"},


	    -- [[ Healing ]]
		{type = "rule"},
	    {type = "text", text = "Healing", align = "center"},
			-- Healthstone
			{ type = "spinner", text = "Healthstone", key = "Healthstone", default = 60},
			-- Lay on Hands
			{ type = "spinner", text = "Lay on Hands", key = "LayonHands", default = 20},
	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local All = {
	-- Kings
	{ "20217", {
		"!player.buffs.stats",
		(function() return NeP.Core.PeFetch("NePConfPalaRet", "Buff") == 'Kings' end)
	}},
	-- Might
	{ "19740", {
		"!player.buffs.mastery",
		(function() return NeP.Core.PeFetch("NePConfPalaRet", "Buff") == 'Might' end)
	}},
}

local Survival = {
	-- Healthstone
	{ "#5512", (function() return dynEval("player.health <= "..PeFetch('NePConfPalaRet', 'Healthstone')) end) },
	-- Lay on Hands
	{ "633", (function() return dynEval("player.health <= "..PeFetch('NePConfPalaRet', 'LayonHands')) end), "player"},
}

local Cooldowns = {
	-- Avenging Wrath Use on cooldown for burst damage.
	{"31884", "!player.buff(31884)"},
	-- Execution Sentence should be used on cooldown against targets that will live long enough to withstand the full duration of the ability.
	{"114157"}, 
}

local Seals = {
	-- Seal of Righteousness
	{"20154", {
		"player.seal != 2",
		(function() return NeP.Lib.SAoE(3, 8) end)
	}},
	-- Seal of Truth
	{"31801", {
		"player.seal != 1",
		(function() return not NeP.Lib.SAoE(3, 8) end)
	}},
}

local AoE = {
	-- Divine Storm to spend Holy Power.
	{"53385", "player.holypower >= 3", "target"},
	-- Hammer of the Righteous to build Holy Power.
	{"53595", nil, "target"},
	-- Judgment to build Holy Power.
	{"20271", nil, "target"},
	-- Exorcism to build Holy Power.
	{"879", nil, "target"},
}

local ST = {
	-- Templar's Verdict with >= 5 Holy Power.
	{"Templar's Verdict", "player.holypower >= 5", "target"},
	-- Final Verdict with >= 5 Holy Power // TALENT (Replaces: Templar's Verdict).
	{"157048", "player.holypower >= 5", "target"},
	-- Crusader Strike to build Holy Power.
	{"35395", nil, "target"},
	-- Judgment to build Holy Power.
	{"20271", nil, "target"},
	-- Exorcism to build Holy Power.
	{"879", nil, "target"},
}

local outCombat = {
	-- Shared things
	{All},

	-- Things to do only outside of combat
		-- Nothing yet...
}

ProbablyEngine.rotation.register_custom(70, NeP.Core.GetCrInfo('Paladin - Retribution'), 
	{-- In-Combat
		{All},
		{Survival, "player.health < 100"},
		-- Rebuke // Interrupt
		{"96231", "target.NePinterrupt"},
		{Seals},
		{Cooldowns, "modifier.cooldowns"},
		-- Divine Storm with Divine Crusader proc.
		{"53385", "player.buff(144595)", "target"},
		-- Hammer of Wrath when target is below or equal 35% Health or with Avenging Wrath.
		{"158392", "target.health <= 35", "target"},
		{"158392", "player.buff(31884)", "target"},
		{AoE, (function() return NeP.Lib.SAoE(3, 8) end)},
		{ST}
	}, outCombat, exeOnLoad)