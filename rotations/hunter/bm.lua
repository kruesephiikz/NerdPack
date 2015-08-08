local lib = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'ressPet', 
		'Interface\\Icons\\Inv_misc_head_tiger_01.png', 
		'Auto Ress Pet', 
		'Automatically ress your pet when it dies.')
end

local _ALL = {
	-- Pause
	{ "pause", "player.buff(5384)" }, -- Pause for Feign Death
	-- Keybinds
	{ "82939", "modifier.alt", "target.ground" }, -- Explosive Trap
	{ "60192", "modifier.shift", "target.ground" }, -- Freezing Trap
	{ "82941", "modifier.shift", "target.ground" }, -- Ice Trap
	-- Buffs
	{"77769", "!player.buff(77769)"}, -- Trap Launcher
		-- Aspect of the Cheetah
		{ "/cancelaura Aspect of the Cheetah", { 
			"player.buff(5118)",
			"!player.glyph(692)", 
			"!player.moving"
		}},
		{ "/cancelaura Aspect of the Cheetah", { 
			"player.buff(5118)",
			"!player.glyph(692)", 
			"player.aggro >= 100"
		}},
		{ "5118", {
			"!player.buff(5118)", 
			"player.movingfor >= 3",
			"!player.aggro >= 100"
		}},
	-- Missdirect // Focus
	{ "34477", { 
		"focus.exists", 
		"!player.buff(35079)", 
		"target.threat > 60" 
	}, "focus" },
}

local Pet = {
  	{{ -- Pet Dead
		{ "55709", "!player.debuff(55711)"}, -- Heart of the Phoenix
		{ "982" } -- Revive Pet
	}, {"pet.dead", "toggle.ressPet"}},
  	{{ -- Pet Alive
		{ "53271", "player.state.stun" }, -- Master's Call
		{ "53271", "player.state.root" }, -- Master's Call
		{ "53271", { -- Master's Call
			"player.state.snare", 
			"!player.debuff(Dazed)" 
		}},
		{ "53271", "player.state.disorient" }, -- Master's Call
		{ "136", { -- Mend Pet
			"pet.health <= 75", 
			"!pet.buff(136)" 
		}}, 
		{ "34477", { -- Missdirect // PET 
			"!player.buff(35079)", 
			"!focus.exists", 
			"target.threat > 85" 
		}, "pet" },
		{ "!19574", { -- Bestial Wrath
			"player.buff(177668).duration > 4", -- Steady Focus // TALENT
			"player.focus > 35",
			"!player.buff(19574)", -- Bestial Wrath
			"player.spell(19574).cooldown = 0", -- Bestial Wrath
			"player.spell(34026).cooldown <= 2", -- Kill Command
			"talent(4,1)",
		}, "target" },
		{ "!19574", { -- Bestial Wrath
			"!player.buff(19574)", -- Bestial Wrath
			"player.spell(19574).cooldown = 0", -- Bestial Wrath
			"player.spell(Dire Beast).cooldown < 2",
			"player.spell(34026).cooldown <= 2", -- Kill Command
			"talent(4,2)",
		}, "target" },
		{ "34026" }, -- Kill Command
	}, "pet.alive" },
}

local Cooldowns = {
	{ "Stampede", "player.proc.any" },
	{ "Stampede", "player.hashero" },
	{ "Stampede", "player.buff(19615).count >= 4" }, -- wt Frenzy
	{ "131894" }, -- A Murder of Crows
	{ "Lifeblood" },
	{ "Berserking" },
	{ "Blood Fury" },
	{ "#trinket1" },
	{ "#trinket2" },
}

local Survival = {
	{ "5384", { "player.aggro >= 100", "modifier.party", "!player.moving" }}, -- Fake death
	{ "109304", "player.health < 50" }, -- Exhiliration
	{ "Deterrence", "player.health < 10" }, -- Deterrence as a last resort
	{ "#109223", "player.health < 40" }, -- Healing Tonic
	{ "#5512", "player.health < 40" }, -- Healthstone
	{ "#109223", "player.health < 40" }, -- Healing Tonic
}

local focusFire = {	
	{ "82692", {
		"player.buff(19615).count = 5",  -- Frenzy
		"player.spell(19574).cooldown <= 10", -- Bestial Wrath
	}},
	{ "82692", {
		"player.buff(19615).count = 5", -- Frenzy
		"player.spell(19574).cooldown >= 19", -- Bestial Wrath
	}},
	{ "82692", "player.buff(19574).duration >= 3" }, -- Bestial Wrath
	{ "!82692", "player.buff(19615).duration <= 1" }, -- Frenzy
	{ "82692", "player.spell(Stampede).cooldown >= 260" },
	{ "82692", {
		"player.spell(19574).cooldown = 0", -- Bestial Wrath
		"!player.buff(19574)" -- Bestial Wrath
	}},
}

local inCombat = {
	{{ -- Steady Focus // TALENT
		{ "77767", "player.buff(177668).duration < 3", "target" }, -- Cobra Shot
	}, { "talent(4,1)", "lastcast(77767)"} },
	{ "157708", (function() return NeP.Lib.AutoDots(157708, 35) end) },-- Kill Shot
	{ "117050" }, -- Glaive Toss // TALENT
	{ "Barrage" }, -- Barrage // TALENT
	{ "Powershot", "player.timetomax > 2.5", "target" }, -- Powershot // TALENT
	{{ -- AoE
		{ "2643", "player.focus > 60", "target" }, -- Multi-Shot
	}, "modifier.multitarget" },	
	{ "3044", "player.focus > 60", "target" },-- Arcane Shot
	{ "Focusing Shot" }, -- Focusing Shot // TALENT
	{ "77767" }, -- Cobra Shot
}

ProbablyEngine.rotation.register_custom(253, NeP.Core.GetCrInfo('Hunter - Beast Mastery'),
	{ -- In-Combat
		{_ALL},
		{{-- Interrupts
			{ "147362" }, -- Counter Shot
			{ "19577" }, -- Intimidation
			{ "19386" }, -- Wyrven Sting
		}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
		{{ -- General Conditions
			{Survival, "player.health < 100"},
			{Cooldowns, "modifier.cooldowns"},
			{Pet, { "player.alive", "pet.exists" }},
			{focusFire, { 
				"pet.exists", 
				"!player.buff(Focus Fire)", 
				"!lastcast(Cobra Shot)", 
				"player.buff(19615).count >= 1" 
			}},
			{inCombat, { "target.exists", "target.range <= 40" }},
		}, "!player.channeling" }
	}, _All, lib)