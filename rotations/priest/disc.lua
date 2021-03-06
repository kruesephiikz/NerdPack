local PeFetch = NeP.Core.PeFetch
local dynEval = NeP.Core.dynEval

NeP.Interface.classGUIs[256] = {
	key = 'NePconfPriestDisc',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Priest Discipline Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{type = 'header', text = 'General Settings:', align = 'center'},
			{type = 'checkbox', text = 'Move Faster', key = 'Feathers', default = true, desc = 'This checkbox enables or disables the automatic use of feathers & others to move faster.'},
			{type = 'spinner', text = 'Power Word: Barrier', key = 'PWB', default = 3,min = 1,max = 5},
			{type = 'spinner', text = 'MassDispell', key = 'MDispell', default = 3,min = 1,max = 5},
			{type = 'dropdown',
				text = 'Pain Suppression', key = 'PainSuppression', 
				list = {
			    	{text = 'Lowest',key = 'Lowest'},
			        {text = 'Tank',key = 'Tank'},
			    	{text = 'Focus',key = 'Focus'}
		    	}, 
		    	default = 'Lowest', 
		    	desc = 'Select Who to use Pain Suppression on.' 
		   },
			{type = 'dropdown',
				text = 'Pain Suppression', key = 'PainSuppressionTG', 
				list = {
			    	{text = 'Allways',key = 'Allways'},
			        {text = 'Boss',key = 'Boss'}
		    	}, 
		    	default = 'Allways', 
		    	desc = 'Select When to use Pain Suppression.' 
		   },
			{type = 'spinner', text = 'Pain Suppression', key = 'PainSuppressionHP', default = 25},
			{type = 'spinner', text = 'Attonement', key = 'Attonement', default = 70,},
			{type = 'spinner', text = 'Saving Grace', key = 'SavingGrace', default = 35,},
			{type = 'spinner', text = 'Emergency Heals', key = 'FastHeals', default = 35,},
		
		-- Tank/Focus
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Tank/Focus Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillTank', default = 100,},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldTank', default = 100,},
			{type = 'spinner', text = 'Penance', key = 'PenanceTank', default = 70,},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealTank', default = 40,},
			{type = 'spinner', text = 'Heal', key = 'HealTank', default = 100,},
		
		-- Player
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Player Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillPlayer', default = 100,},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldPlayer', default = 100,},
			{type = 'spinner', text = 'Penance', key = 'PenancePlayer', default = 60,},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealPlayer', default = 40,},
			{type = 'spinner', text = 'Heal', key = 'HealPlayer', default = 100,},
		
		-- Raid
		{type = 'spacer'},{type = 'rule'},
		{type = 'header', text = 'Raid Settings:', align = 'center'},
			{type = 'spinner', text = 'Clarity Of Will', key = 'ClarityofWillRaid', default = 60,},
			{type = 'spinner', text = 'Power Word: Shield', key = 'PowerShieldRaid', default = 60,},
			{type = 'spinner', text = 'Penance', key = 'PenanceRaid', default = 60,},
			{type = 'spinner', text = 'Flash Heal', key = 'FlashHealRaid', default = 40,},
			{type = 'spinner', text = 'Heal', key = 'HealRaid', default = 100,},
	}
}

local _MassDispell = function()
    if IsUsableSpell('32375') then
		if select(2, GetSpellCooldown('62618')) == 0 then
			local total = 0        
			for i=1,#NeP.OM.unitFriend do
				local object = NeP.OM.unitFriend[i]
				if object.distance <= 40 then
					for j = 1, 40 do
						local debuffName, _,_,_, dispelType, duration, expires,_,_,_,_,_,_, _,_,_ = UnitDebuff(object.key, j)
						if dispelType and dispelType == 'Magic' or dispelType == 'Disease' then
							total = total + 1
						end
					end
				end
				if total >= PeFetch('NePconfPriestDisc', 'MDispell')  then
					NeP.Core.Alert('Mass Dispelled on: '..object.name..' total units:'..total)
					CastGround('32375', object.key)
					return true
				end
			end
		end
	end
	return false
end

local _PWBarrier = function()
	if IsUsableSpell('62618') then
		if select(2, GetSpellCooldown('62618')) == 0 then
			local minHeal = GetSpellBonusDamage(2) * 1.125
			local total = 0
			for i=1,#NeP.OM.unitFriend do
				local object = NeP.OM.unitFriend[i]
				if object.distance <= 40 then
					if max(0, object.maxHealth - object.actualHealth) > minHeal then
						total = total + 1
					end
				end
				if total >= PeFetch('NePconfPriestDisc', 'PWB')  then
					NeP.Core.Alert('Power Word: Barrier on: '..object.name..' total units:'..total)
					CastGround('62618', object.key)
					return true
				end
			end
		end
	end
	return false
end

local _holyNova = function()
	local minHeal = GetSpellBonusDamage(2) * 1.125
	local total = 0
		for i=1,#NeP.OM.unitFriend do
			local object = NeP.OM.unitFriend[i]
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
			subgroups[subgroup] = subgroups[subgroup] + (min(minHeal, ProbablyEngine.raid.roster[i].healthMissing) or 0)
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

local Keybinds = {
	{'32375', 'modifier.lshift', 'ground'}, -- MassDispell
	{'62618', 'modifier.lcontrol', 'ground'}, -- Power Word: Barrier
}

local Tank = {
	{'47540', (function() return dynEval('tank.health < '..PeFetch('NePconfPriestDisc', 'PenanceTank')) end), 'tank'}, -- Penance
	{'17', { --Power Word: Shield
		(function() return dynEval('tank.health < '..PeFetch('NePconfPriestDisc', 'PowerShieldTank')) end),
		'!focus.debuff(6788).any', 
		'!focus.buff(17).any',
	}, 'focus'},
	{'2061', (function() return dynEval('tank.health < '..PeFetch('NePconfPriestDisc', 'FlashHealTank')) end), 'tank'}, --Flash Heal
	{'2060', (function() return dynEval('tank.health < '..PeFetch('NePconfPriestDisc', 'HealTank')) end), 'tank'}, -- Heal
}

local Focus = {
	{'47540', (function() return dynEval('focus.health < '..PeFetch('NePconfPriestDisc', 'PenanceTank')) end), 'focus'}, -- Penance
	{'17', { --Power Word: Shield
		(function() return dynEval('focus.health < '..PeFetch('NePconfPriestDisc', 'PowerShieldTank')) end),
		'!focus.debuff(6788).any', 
		'!focus.buff(17).any',
	}, 'focus'},
	{'2061', (function() return dynEval('focus.health < '..PeFetch('NePconfPriestDisc', 'FlashHealTank')) end), 'focus'}, --Flash Heal
	{'2060', (function() return dynEval('focus.health < '..PeFetch('NePconfPriestDisc', 'HealTank')) end), 'focus'}, -- Heal
}

local Player = {
	{'19236', 'player.health <= 20', 'player'}, --Desperate Prayer
	{'#5512', 'player.health <= 35'}, -- Health Stone
	{'586', 'target.threat >= 80'}, -- Fade
	
	{'123040', 'player.mana < 85', 'target'}, -- Mindbender
	{'34433', 'player.mana < 85', 'target'}, -- Shadowfiend
	
	-- Heals
	{'47540', (function() return dynEval('player.health < '..PeFetch('NePconfPriestDisc', 'PenancePlayer')) end), 'player'}, -- Penance
	{'17', { --Power Word: Shield
		(function() return dynEval('player.health < '..PeFetch('NePconfPriestDisc', 'PowerShieldPlayer')) end),
		'!player.debuff(6788).any', 
		'!player.buff(17).any',
	}, 'player'},
	{'2061', (function() return dynEval('player.health < '..PeFetch('NePconfPriestDisc', 'FlashHealPlayer')) end), 'player'}, --Flash Heal
	{'2060', (function() return dynEval('player.health < '..PeFetch('NePconfPriestDisc', 'HealPlayer')) end), 'player'}, -- Heal
}

local Raid = {
	{'47540', (function() return dynEval('lowest.health < '..PeFetch('NePconfPriestDisc', 'PenanceRaid')) end), 'lowest'}, -- Penance
	{'17', { --Power Word: Shield
		(function() return dynEval('lowest.health < '..PeFetch('NePconfPriestDisc', 'PowerShieldRaid')) end),
		'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest'},
	{'2061', (function() return dynEval('lowest.health < '..PeFetch('NePconfPriestDisc', 'FlashHealRaid')) end), 'lowest'}, --Flash Heal
	{'2060', {-- Heal
		(function() return dynEval('lowest.health < '..PeFetch('NePconfPriestDisc', 'HealRaid')) end),
		'!player.moving'
	}, 'lowest'}, 
}

local Attonement = {
	{'14914', 'player.mana > 20', 'target'}, -- Holy Fire
	{'47540'} ,-- Penance
	{'585'}, --Smite
}

local HealFast = {
	{'Gift of the Naaru', nil, 'lowest'},
	{'!47540', nil, 'lowest'}, -- Penance
	{'!17', { -- Power Word: Shield
		'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest'},
	{'!2061', nil, 'lowest'}, --Flash Heal
}

local AoE = {
	{'121135', '@coreHealing.needsHealing(95, 3)', 'lowest'}, -- Cascade
	{'33076', {--Prayer of Mending // FIXME needs TWeaking
		'tank.health <= 80',
		'@coreHealing.needsHealing(90, 3)',
		'!player.moving', 
		'tank.spell(33076).range' 
	}, 'tank'},
 	{'596', (function() return _PoH() end)},-- Prayer of Healing
   	{'132157', (function() return _holyNova() end), nil}, -- Holy Nova
}

local Shared = {
	-- Buffs
	{'21562', '!player.buffs.stamina'}, -- Fortitude
	
	{{-- LoOk aT It GOoZ!!!
		{'121536', {
			'player.movingfor > 2', 
			'!player.buff(121557)', 
			'player.spell(121536).charges >= 1' 
		}, 'player.ground'},
		{'17', {
			'talent(2, 1)', 
			'player.movingfor > 2', 
			'!player.buff(17)',
		}, 'player'},
	}, (function() return PeFetch('NePconfPriestDisc', 'Feathers') end),},
}

local SpiritShell = {
   	{'596', (function() return _PoH() end)}, -- Prayer of Healing
	{'!2061', 'lowest.health <= 40', 'lowest'}, -- Flash Heal
	{'2060', 'lowest.health >= 40', 'lowest'}, -- Heal
}

local ClarityOfWill = {
	-- tank
	{'152118', {-- Clarity of Will
		(function() return dynEval('tank.health <= '..PeFetch('NePconfPriestDisc', 'ClarityofWillTank')) end),
		'!tank.buff(152118).any'	
	}, 'tank'},
	-- focus
	{'152118', {-- Clarity of Will
		(function() return dynEval('focus.health <= '..PeFetch('NePconfPriestDisc', 'ClarityofWillTank')) end),
		'!focus.buff(152118).any'	
	}, 'focus'},
	-- player
	{'152118', {-- Clarity of Will
		(function() return dynEval('player.health <= '..PeFetch('NePconfPriestDisc', 'ClarityofWillPlayer')) end),
		'!player.buff(152118).any'	
	}, 'player'},
	-- raid
	{'152118', {-- Clarity of Will
		(function() return dynEval('lowest.health <= '..PeFetch('NePconfPriestDisc', 'ClarityofWillRaid')) end),
		'!lowest.buff(152118).any'		
	}, 'lowest'},
}

local SavingGrace = {
	{'!152116', (function() return dynEval('tank.health <= '..PeFetch('NePconfPriestDisc', 'SavingGrace')) end), 'tank'}, -- Saving Grace
	{'!152116', (function() return dynEval('focus.health <= '..PeFetch('NePconfPriestDisc', 'SavingGrace')) end), 'lowest'}, -- Saving Grace
	{'!152116', (function() return dynEval('player.health <= '..PeFetch('NePconfPriestDisc', 'SavingGrace')) end), 'lowest'}, -- Saving Grace
	{'!152116', (function() return dynEval('lowest.health <= '..PeFetch('NePconfPriestDisc', 'SavingGrace')) end), 'lowest'}, -- Saving Grace
}

local Cooldowns = {
	{'10060', 'player.mana < 80'},-- Power Infusion
	{'109964', {-- Spirit Shell // Party
		'@coreHealing.needsHealing(60, 3)',
		'modifier.party'
	}},
	{'109964', {-- Spirit Shell // Raid
		'@coreHealing.needsHealing(60, 5)',
		'modifier.raid'
	}},
}

local PainSuppression = {	
		{{-- ALL
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Focus' end),
			(function() return dynEval('focus.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'focus'},
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Tank' end),
			(function() return dynEval('tank.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'tank'},
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Lowest' end),
			(function() return dynEval('lowest.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end)
		}, 'lowest'},
	}, (function() return PeFetch('NePconfPriestDisc', 'PainSuppressionTG') == 'Allways' end)},

	{{-- Boss
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Focus' end),
			(function() return dynEval('focus.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'focus'},
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Tank' end),
			(function() return dynEval('tank.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'tank'},
		{'33206', {
			(function() return PeFetch('NePconfPriestDisc', 'PainSuppression') == 'Lowest' end),
			(function() return dynEval('lowest.health <= '..PeFetch('NePconfPriestDisc', 'PainSuppressionHP')) end),
		}, 'lowest'},
	}, {'target.boss', (function() return PeFetch('NePconfPriestDisc', 'PainSuppressionTG') == 'Boss' end)}}
}

local Solo = {
	{'32379', (function() return NeP.Core.AutoDots('32379', 0, 20) end)}, -- SW:D
	{'589', (function() return NeP.Core.AutoDots('589') end)}, -- SW:P 

  	-- CD's
	{'10060', 'modifier.cooldowns'}, --Power Infusion 
	{'585'}, --Smite
}

local Moving = {
	{'17', { -- Power Word: Shield
		'lowest.health <= 30',
		'!lowest.debuff(6788).any', 
		'!lowest.buff(17).any',
	}, 'lowest'},
	{'47540', 'lowest.health <= 30', 'lowest'}, -- Penance
}

local BorrowedTime = {
	{'17', {
		'!tank.debuff(6788).any',
		'!tank.buff(10).any',
		'tank.range <= 40',
	}, 'tank'},
	{'17', {
		'!focus.debuff(6788).any',
		'!focus.buff(10).any',
		'focus.range <= 40',
	}, 'focus'}, 
	{'17', {
		'!player.debuff(6788).any',
		'!player.buff(10).any',
	}, 'player'},
	{'17', {
		'lowest.health < 100',
		'!lowest.debuff(6788).any',
		'!lowest.buff(10).any',
	}, 'lowest'}, 
}

local outCombat = {
	{Keybinds},
	{Shared}
}

ProbablyEngine.rotation.register_custom(256, NeP.Core.GetCrInfo('Priest - Discipline'), 
	{-- In-Combat
		{Shared},
		{Keybinds},
		{{-- Party/Raid
			{'527', (function() return NeP.Core.Dispel('527') end)},-- Dispell ALl
			{{-- Auto Ground ON
				{'32375', (function() return _MassDispell() end)}, -- MassDispell
				{'62618', (function() return _PWBarrier() end)}, -- Power Word: Barrier
			}, 'toggle.autoGround'},
			{'81700', 'player.buff(81661).count = 5'}, -- Archangel
			-- Power Word: Solace
			{'129250', 'target.range <= 30', 'target'},
			{Moving, 'player.moving'},
			{{-- Conditions
				{SavingGrace, {-- Saving Grace // Talent
					'talent(7,3)',
					'!player.debuff(155274) >= 3',
				}}, 
				{ClarityOfWill, 'talent(7,1)'}, -- Clarity of Will // Talent
		 		{BorrowedTime, 'player.buff(59889).duration <= 2'}, -- BorrowedTime // Passive Buff
		 		{SpiritShell, 'player.buff(109964)'}, -- SpiritShell // Talent
				{HealFast, {
					(function() return dynEval('lowest.health <= '..PeFetch('NePconfPriestDisc', 'FastHeals')) end),
					'!player.casting.percent >= 40', 
				}},
				{Cooldowns, 'modifier.cooldowns'},
				{PainSuppression},
				{Attonement, {
					'lowest.health >= 60',
					'toggle.focusDps',
					'target.range < 30'
				}},
				{Attonement, {
					(function() return dynEval('lowest.health >= '..PeFetch('NePconfPriestDisc', 'Attonement')) end), 
					'!player.buff(81661).count = 5', 
					'!player.mana <= 20', 
					'target.range < 30'
				}},
				{AoE, 'modifier.multitarget'},
				{Tank, {'tank.health < 100', 'tank.range <= 40'}},
				{Focus, {'focus.health < 100', 'focus.range <= 40'}},
				{Player, 'player.health < 100'},
				{Raid, 'lowest.health < 100'}
			}, '!player.moving'},
		}, 'modifier.party'},
		{{-- Solo
			{Player, 'player.health <= 60'},
			{Solo, 'target.range < 30'}
		}, '!modifier.party'},
	}, outCombat, exeOnLoad)