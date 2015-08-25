NeP.Interface.PriestDisc = {
	key = "NePconfPriestDisc",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick.." Config",
	subtitle = "Priest Discipline Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ 
			type = 'header', 
			text = "General Settings:", 
			align = "center" 
		},
			{ 
				type = "spinner", 
				text = "Power Word: Barrier - Party", 
				key = "PWBParty", 
				default = 3,
				min = 1,
				max = 5
			},
			{ 
				type = "spinner", 
				text = "MassDispell - Party", 
				key = "MDispellParty", 
				default = 3,
				min = 1,
				max = 5
			},
			{ 
				type = "spinner", 
				text = "Power Word: Barrier - Raid", 
				key = "PWBRaid", 
				default = 5,
				min = 1,
				max = 20
			},
			{ 
				type = "spinner", 
				text = "MassDispell - Raid", 
				key = "MDispellRaid", 
				default = 5,
				min = 1,
				max = 20
			},
			{ 
				type = "checkbox", 
				text = "Move Faster", 
				key = "Feathers", 
				default = true, 
				desc = "This checkbox enables or disables the automatic use of feathers & others to move faster."
			},
			{ 
				type = "dropdown",
				text = "Pain Suppression", 
				key = "PainSuppression", 
				list = {
			    	{
			          text = "Lowest",
			          key = "Lowest"
			        },
			        {
			          text = "Tank",
			          key = "Tank"
			    	},
			    	{
			    	  text = "Focus",
			          key = "Focus"
			    	}
		    	}, 
		    	default = "Lowest", 
		    	desc = "Select Who to use Pain Suppression on." 
		    },
			{ 
				type = "dropdown",
				text = "Pain Suppression", 
				key = "PainSuppressionTG", 
				list = {
			    	{
			          text = "Allways",
			          key = "Allways"
			        },
			        {
			          text = "Boss",
			          key = "Boss"
			    	}
		    	}, 
		    	default = "Allways", 
		    	desc = "Select When to use Pain Suppression." 
		    },
			{ 
				type = "spinner", 
				text = "Pain Suppression", 
				key = "PainSuppressionHP", 
				default = 25
			},
			{ 
				type = "spinner", 
				text = "Attonement", 
				key = "Attonement", 
				default = 70,
			},
			{ 
				type = "spinner", 
				text = "Saving Grace", 
				key = "SavingGrace", 
				default = 35,
			},
			{ 
				type = "spinner", 
				text = "Emergency Heals", 
				key = "FastHeals", 
				default = 35,
			},
		-- Tank/Focus
		{ type = 'Spacer' },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = "Tank/Focus Settings:", 
			align = "center" 
		},
			{ 
				type = "spinner", 
				text = "Clarity Of Will", 
				key = "ClarityofWillTank", 
				default = 100,
			},
			{ 
				type = "spinner", 
				text = "Power Word: Shield", 
				key = "PowerShieldTank", 
				default = 100,
			},
			{ 
				type = "spinner", 
				text = "Penance", 
				key = "PenanceTank", 
				default = 70,
			},
			{ 
				type = "spinner", 
				text = "Flash Heal", 
				key = "FlashHealTank", 
				default = 40,
			},
			{ 
				type = "spinner", 
				text = "Heal", 
				key = "HealTank", 
				default = 100,
			},
		-- Player
		{ type = 'Spacer' },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = "Player Settings:", 
			align = "center" 
		},
			{ 
				type = "spinner", 
				text = "Clarity Of Will", 
				key = "ClarityofWillPlayer", 
				default = 100,
			},
			{ 
				type = "spinner", 
				text = "Power Word: Shield", 
				key = "PowerShieldPlayer", 
				default = 100,
			},
			{ 
				type = "spinner", 
				text = "Penance", 
				key = "PenancePlayer", 
				default = 60,
			},
			{ 
				type = "spinner", 
				text = "Flash Heal", 
				key = "FlashHealPlayer", 
				default = 40,
			},
			{ 
				type = "spinner", 
				text = "Heal", 
				key = "HealPlayer", 
				default = 100,
			},
		-- Raid
		{ type = 'Spacer' },
		{ type = 'rule' },
		{ 
			type = 'header', 
			text = "Raid Settings:", 
			align = "center" 
		},
			{ 
				type = "spinner", 
				text = "Clarity Of Will", 
				key = "ClarityofWillRaid", 
				default = 60,
			},
			{ 
				type = "spinner", 
				text = "Power Word: Shield", 
				key = "PowerShieldRaid", 
				default = 60,
			},
			{ 
				type = "spinner", 
				text = "Penance", 
				key = "PenanceRaid", 
				default = 60,
			},
			{ 
				type = "spinner", 
				text = "Flash Heal", 
				key = "FlashHealRaid", 
				default = 40,
			},
			{ 
				type = "spinner", 
				text = "Heal", 
				key = "HealRaid", 
				default = 100,
			},
	}
}

local _MassDispell = function()
	local start, duration, enabled = GetSpellCooldown('32375')
    if duration == 0 then
		local _Count = 0
		if IsInGroup() or IsInRaid() then
			_Count = NeP.Core.PeFetch("NePconfPriestDisc", "MDispellRaid")
		else 
			_Count = NeP.Core.PeFetch("NePconfPriestDisc", "MDispellParty") 
		end
		local total = 0        
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitFriendlyCache[i]
			if object.distance <= 40 then
				for j = 1, 40 do
					local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_, _,_,_ = UnitDebuff(object.key, j)
					if dispelType and dispelType == 'Magic' or dispelType == 'Disease' then
						total = total + 1
					end
				end
			end
			if total >= _Count then
				NeP.Core.Print("Mass Dispelled on: "..object.name.." total units:"..total)
				CastGround('32375', object.key)
				return true
			end
		end
	end
	return false
end

local _PWBarrier = function()
	local start, duration, enabled = GetSpellCooldown('62618')
    if duration == 0 then
		local _Count = 0
		if IsInGroup() or IsInRaid() then
			_Count = NeP.Core.PeFetch("NePconfPriestDisc", "PWBRaid")
		else 
			_Count = NeP.Core.PeFetch("NePconfPriestDisc", "PWBParty") 
		end
		local minHeal = GetSpellBonusDamage(2) * 1.125
		local total = 0
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitFriendlyCache[i]
			if object.distance <= 40 then
				if max(0, object.maxHealth - object.actualHealth) > minHeal then
					total = total + 1
				end
			end
			if total >= _Count then
				NeP.Core.Print("Power Word: Barrier on: "..object.name.." total units:"..total)
				CastGround('62618', object.key)
				return true
			end
		end
	end
	return false
end

local _holyNova = function()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitFriendlyCache[i]
			if object.distance <= 12 then
				if max(0, object.maxHealth - object.actualHealth) > minHeal then
					total = total + 1
				end
			end
		end
	return total > 3
end

local _PoH = function()
	local minHeal = GetSpellBonusDamage(2) * 2.21664
	local GetRaidRosterInfo, min, subgroups, member = GetRaidRosterInfo, math.min, {}, {}
	local lowest, lowestHP, _, subgroup = false, 0
	local start, groupMembers = 0, GetNumGroupMembers()
		if IsInRaid() then
			start = 1
		elseif groupMembers > 0 then
			groupMembers = groupMembers - 1
		end
		for i = start, groupMembers do
			local _, _, subgroup, _, _, _, _, _, _, _, _ = GetRaidRosterInfo(i)
			if not subgroups[subgroup] then
				subgroups[subgroup] = 0
				member[subgroup] = ProbablyEngine.raid.roster[i].unit
			end
				subgroups[subgroup] = subgroups[subgroup] + min(minHeal, ProbablyEngine.raid.roster[i].healthMissing)
		end
			for i = 1, #subgroups do
				if subgroups[i] > minHeal * 4 and subgroups[i] > lowestHP then
				lowest = i
				lowestHP = subgroups[i]
				end
			end
			if lowest then
				ProbablyEngine.dsl.parsedTarget = member[lowest]
			return true
		end
	return false
end

local exeOnLoad = function()
	NeP.Splash()
	ProbablyEngine.toggle.create(
		'dotEverything', 
		'Interface\\Icons\\Ability_creature_cursed_05.png', 
		'Dot All The Things! (SOLO)', 
		'Click here to dot all the things while in Solo mode!\nSome Spells require Multitarget enabled also.')
	ProbablyEngine.toggle.create(
		'autoGround', 
		'Interface\\Icons\\Ability_priest_bindingprayers.png', 
		'Automated Ground Spells', 
		'Enable the use of automated ground spells like MassDispell & Power Word: Barrier.\nOnly Works if using a Advanced Unlocker.')
	ProbablyEngine.toggle.create(
		'focusDps', 
		'Interface\\Icons\\Ability_priest_atonement.png', 
		'Enable Agressive Mode', 
		'Will only heal if lowest is bellow 60%.')
end

local _Tank = {
	{ "47540", (function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PenanceTank')) end), "tank" }, -- Penance
	{ "17", {  --Power Word: Shield
		(function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PowerShieldTank')) end),
		"!focus.debuff(6788).any", 
		"!focus.buff(17).any",
	}, "focus" },
	{ "2061", (function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'FlashHealTank')) end), "tank" }, --Flash Heal
	{ "2060", (function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'HealTank')) end), "tank" }, -- Heal
}

local _Focus = {
	{ "47540", (function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PenanceTank')) end), "focus" }, -- Penance
	{ "17", {  --Power Word: Shield
		(function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PowerShieldTank')) end),
		"!focus.debuff(6788).any", 
		"!focus.buff(17).any",
	}, "focus" },
	{ "2061", (function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'FlashHealTank')) end), "focus" }, --Flash Heal
	{ "2060", (function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'HealTank')) end), "focus" }, -- Heal
}

local _Player = {
	{ "19236", "player.health <= 20", "player" }, --Desperate Prayer
	{ "#5512", "player.health <= 35" }, -- Health Stone
	{ "586", "target.threat >= 80" }, -- Fade
	
	{ "123040", "player.mana < 85", "target" }, -- Mindbender
	{ "34433", "player.mana < 85", "target" }, -- Shadowfiend
	
	-- Heals
	{ "47540", (function() return NeP.Core.dynamicEval("player.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PenancePlayer')) end), "player" }, -- Penance
	{ "17", {  --Power Word: Shield
		(function() return NeP.Core.dynamicEval("player.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PowerShieldPlayer')) end),
		"!player.debuff(6788).any", 
		"!player.buff(17).any",
	}, "player" },
	{ "2061", (function() return NeP.Core.dynamicEval("player.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'FlashHealPlayer')) end), "player" }, --Flash Heal
	{ "2060", (function() return NeP.Core.dynamicEval("player.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'HealPlayer')) end), "player" }, -- Heal
}

local _Raid = {
	{ "47540", (function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PenanceRaid')) end), "lowest" }, -- Penance
	{ "17", {  --Power Word: Shield
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PowerShieldRaid')) end),
		"!lowest.debuff(6788).any", 
		"!lowest.buff(17).any",
	}, "lowest" },
	{ "2061", (function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'FlashHealRaid')) end), "lowest" }, --Flash Heal
	{ "2060", {-- Heal
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'HealRaid')) end),
		"!player.moving"
	}, "lowest" }, 
}

local _Attonement = {
	{ "14914", "player.mana > 20", "target" }, -- Holy Fire
	{ "47540" } ,-- Penance
	{ "585" }, --Smite
}

local _Fast = {
	{ "Gift of the Naaru", nil, "lowest" },
	{ "!47540", nil, "lowest" }, -- Penance
	{ "!17", {  -- Power Word: Shield
		"!lowest.debuff(6788).any", 
		"!lowest.buff(17).any",
	}, "lowest" },
	{ "!2061", nil, "lowest" }, --Flash Heal
}

local _AoE = {
	{ "121135", "@coreHealing.needsHealing(95, 3)", "lowest"}, -- Cascade
	{ "33076", { --Prayer of Mending // FIXME needs TWeaking
		"tank.health <= 80",
		"@coreHealing.needsHealing(90, 3)",
		"!player.moving", 
		"tank.spell(33076).range" 
	}, "tank" },
 	{ "596", (function() return _PoH() end) },-- Prayer of Healing
   	{ "132157", (function() return _holyNova() end), nil }, -- Holy Nova
}

local _All = {
	-- Buffs
	{ "21562", "!player.buffs.stamina" }, -- Fortitude
	
	{{-- LoOk aT It GOoZ!!!
		{ "121536", { 
			"player.movingfor > 2", 
			"!player.buff(121557)", 
			"player.spell(121536).charges >= 1" 
		}, "player.ground" },
		{ "17", {
			"talent(2, 1)", 
			"player.movingfor > 2", 
			"!player.buff(17)",
		}, "player" },
	}, (function() return NeP.Core.PeFetch("NePconfPriestDisc", "Feathers") end), },
}

local _SpiritShell = {
   	{ "596", (function() return _PoH() end) }, -- Prayer of Healing
	{ "!2061", "lowest.health <= 40", "lowest" }, -- Flash Heal
	{ "2060", "lowest.health >= 40", "lowest" }, -- Heal
}

local _ClarityOfWill = {
	-- tank
	{ "152118", { -- Clarity of Will
		(function() return NeP.Core.dynamicEval("tank.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'ClarityofWillTank')) end),
		"!tank.buff(152118).any"	
	}, "tank" },
	-- focus
	{ "152118", { -- Clarity of Will
		(function() return NeP.Core.dynamicEval("focus.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'ClarityofWillTank')) end),
		"!focus.buff(152118).any"	
	}, "focus" },
	-- player
	{ "152118", { -- Clarity of Will
		(function() return NeP.Core.dynamicEval("player.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'ClarityofWillPlayer')) end),
		"!player.buff(152118).any"	
	}, "player" },
	-- raid
	{ "152118", { -- Clarity of Will
		(function() return NeP.Core.dynamicEval("lowest.health < " .. NeP.Core.PeFetch('NePconfPriestDisc', 'ClarityofWillRaid')) end),
		"!lowest.buff(152118).any"		
	}, "lowest" },
}

local _SavingGrace = {
	{ "!152116", (function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'SavingGrace')) end), "tank" }, -- Saving Grace
	{ "!152116", (function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'SavingGrace')) end), "lowest" }, -- Saving Grace
	{ "!152116", (function() return NeP.Core.dynamicEval("player.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'SavingGrace')) end), "lowest" }, -- Saving Grace
	{ "!152116", (function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'SavingGrace')) end), "lowest" }, -- Saving Grace
}

local _Cooldowns = {
	{ "10060", "player.mana < 80" },-- Power Infusion
	{ "109964", {-- Spirit Shell // Party
		"@coreHealing.needsHealing(60, 3)",
		"modifier.party"
	}},
	{ "109964", {-- Spirit Shell // Raid
		"@coreHealing.needsHealing(60, 5)",
		"modifier.raid"
	}},
}

local _PainSuppression = {	
		{{-- ALL
		{ "33206", { 
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Focus' end),
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, "focus" },
		{ "33206", {
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Tank' end),
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, "tank" },
		{ "33206", {
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Lowest' end),
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, "lowest" },
	}, (function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppressionTG") == 'Allways' end) },

	{{-- Boss
		{ "33206", { 
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Focus' end),
			(function() return NeP.Core.dynamicEval("focus.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, "focus" },
		{ "33206", {
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Tank' end),
			(function() return NeP.Core.dynamicEval("tank.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, "tank" },
		{ "33206", {
			(function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppression") == 'Lowest' end),
			(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, "lowest" },
	}, {"target.boss", (function() return NeP.Core.PeFetch("NePconfPriestDisc", "PainSuppressionTG") == 'Boss' end)} }
}

local _Solo = {
	{{-- Auto Dotting
		{ "32379", (function() return NeP.Lib.AutoDots('32379', 20) end) }, -- SW:D
		{ "589", (function() return NeP.Lib.AutoDots('589', 100) end) }, -- SW:P 
	}, "toggle.dotEverything" },

  	-- CD's
	{ "10060", "modifier.cooldowns" }, --Power Infusion 
	{ "585" }, --Smite
}

local _Moving = {
	{ "17", {  -- Power Word: Shield
		"lowest.health <= 30",
		"!lowest.debuff(6788).any", 
		"!lowest.buff(17).any",
	}, "lowest" },
	{ "47540", "lowest.health <= 30", "lowest" }, -- Penance
}

local _BorrowedTime = {
	{ "17", {
		"!tank.debuff(6788).any",
		"!tank.buff(10).any",
		"tank.range <= 40",
	}, "tank" },
	{ "17", { 
		"!focus.debuff(6788).any",
		"!focus.buff(10).any",
		"focus.range <= 40",
	}, "focus" }, 
	{ "17", {
		"!player.debuff(6788).any",
		"!player.buff(10).any",
	}, "player" },
	{ "17", {
		"lowest.health < 100",
		"!lowest.debuff(6788).any",
		"!lowest.buff(10).any",
	}, "lowest" }, 

}

ProbablyEngine.rotation.register_custom(256, NeP.Core.GetCrInfo('Priest - Discipline'), 
	{ -- In-Combat
		{{ -- Party/Raid
			{ "527", (function() return NeP.Lib.Dispell(function() return dispelType == 'Magic' or dispelType == 'Disease' end) end) },-- Dispell ALl
			{{ -- Auto Ground ON
				{ "32375", (function() return _MassDispell() end) }, -- MassDispell
				{ "62618", _PWBarrier },
			}, "toggle.autoGround" },
			{{ -- Auto Ground Off
				{ "32375", "modifier.lshift", "ground" }, -- MassDispell
				{ "62618", "modifier.lcontrol", "ground" },
			}, "!toggle.autoGround" },
			{ "81700", "player.buff(81661).count = 5" }, -- Archangel
			{ _All },
			{ "129250", "target.range < 30", "target" },
			{ _Moving, "player.moving"},
			{{ -- Conditions
				{ _SavingGrace, { -- Saving Grace // Talent
					"talent(7,3)",
					"!player.debuff(155274) >= 3",
				}}, 
				{ _ClarityOfWill, "talent(7,1)" }, -- Clarity of Will // Talent
		 		{ _BorrowedTime, "player.buff(59889).duration <= 2" }, -- BorrowedTime // Passive Buff
		 		{ _SpiritShell, "player.buff(109964)" }, -- SpiritShell // Talent
				{_Fast, {
					(function() return NeP.Core.dynamicEval("lowest.health <= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'FastHeals')) end),
					"!player.casting.percent >= 40", 
				}},
				{_Cooldowns, "modifier.cooldowns"},
				{_PainSuppression},
				{_Attonement, {
					"lowest.health >= 60",
					"toggle.focusDps",
					"target.range < 30"
				}},
				{_Attonement, {
					(function() return NeP.Core.dynamicEval("lowest.health >= " .. NeP.Core.PeFetch('NePconfPriestDisc', 'Attonement')) end), 
					"!player.buff(81661).count = 5", 
					"!player.mana <= 20", 
					"target.range < 30"
				}},
				{_AoE, "modifier.multitarget"},
				{_Tank, {"tank.health < 100", "tank.range <= 40"}},
				{_Focus, {"focus.health < 100", "focus.range <= 40"}},
				{_Player, "player.health < 100"},
				{_Raid, "lowest.health < 100"}
			}, "!player.moving" },
		}, "modifier.party" },
		{{ -- Solo
			{_All},
			{_Player, "player.health <= 60"},
			{_Solo, "target.range < 30"}
		}, "!modifier.party" },
	},  
	{ -- Out-Combat
		{_All},
	}, exeOnLoad)