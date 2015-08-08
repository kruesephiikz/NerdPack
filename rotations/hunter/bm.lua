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
		{ "5118", {
			"!player.buff(5118)", 
			"player.moving",
			"player.aggro >= 100"
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

-- FIX-ME: Requires Tweaking!
local focusFire = {
	-- Normal
	{ "82692", "player.buff(19615).count = 5" }, -- Frenzy Stacks
}

local AoE = {
	{ "2643" }, -- Multi-Shot
}

local ST = {
	{ "117050" }, -- Glaive Toss // TALENT
	{ "Barrage" }, -- Barrage // TALENT
	{ "Powershot", "player.timetomax > 2.5", "target" }, -- Powershot // TALENT
	{ "3044", "player.focus > 60", "target" },-- Arcane Shot
	{{ -- Build Focus
		{ "Focusing Shot" }, -- Focusing Shot // TALENT
		{ "77767" }, -- Cobra Shot
	}, "player.focus < 50" }
}

ProbablyEngine.rotation.register_custom(253, NeP.Core.GetCrInfo('Hunter - Beast Mastery'),
	{ -- In-Combat
		{_ALL},
		{{-- Interrupts
			{ "147362" }, -- Counter Shot
			{ "19577" }, -- Intimidation
			{ "19386" }, -- Wyrven Sting
		}, "target.interruptsAt("..(NeP.Core.PeFetch('npconf', 'ItA')  or 40)..")" },
		{Survival, "player.health < 100"},
		{Cooldowns, "modifier.cooldowns"},
		{Pet, { "player.alive", "pet.exists" }},
		{focusFire, { 
			"pet.exists", 
			"!player.buff(Focus Fire)", 
			"!lastcast(Cobra Shot)", 
			"player.buff(19615).count >= 1" 
		}},
		{AoE, "modifier.multitarget" },
		{AoE, "player.area(40).enemies >= 3" },
		{ST, { "target.exists", "target.range <= 40" }}
	}, _All, lib)