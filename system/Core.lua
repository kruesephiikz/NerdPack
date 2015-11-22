--[[-----------------------------------------------
	** Main Tables. **
---------------------------------------------------]]
NeP = {
	Core = {
		CurrentCR = false,
		hiding = false,
		--[[
				** PE Abstract's **
			These are used to have a easly way to update stuff related
			to ProbablyEngine.
		]]
		peRecomemded = '6.1r16',
		PeFetch = ProbablyEngine.interface.fetchKey,
		PeConfig = ProbablyEngine.config,
		PeBuildGUI = ProbablyEngine.interface.buildGUI
	},
	Interface = {
		addonColor = '0070DE',
		printColor = '|cffFFFFFF',
		mediaDir = 'Interface\\AddOns\\NerdPack\\media\\',
		classGUIs = {},
	},
	Info = {
		Name = 'NerdPack',
		Nick = 'NeP',
		Author = 'MrTheSoulz',
		Version = '6.2.3.1',
		Branch = 'Stable',
		WoW_Version = '6.2.3',
		Logo = 'Interface\\AddOns\\NerdPack\\media\\logo.blp',
		Splash = 'Interface\\AddOns\\NerdPack\\media\\splash.blp',
		Forum = 'http://www.ownedcore.com/forums/world-of-warcraft/world-of-warcraft-bots-programs/probably-engine/combat-routines/532241-pe-nerdpack.html',
		Donate = 'http://goo.gl/yrctPO'
	}
}

--[[-----------------------------------------------
	** Locals **
---------------------------------------------------]]
local _addonColor = '|cff'..NeP.Interface.addonColor
-- Local stuff to reduce global calls
local peConfig = NeP.Core.PeConfig
local UnitAffectingCombat = UnitAffectingCombat
local UnitIsVisible = UnitIsVisible
local UnitExists = UnitExists
local _parse = ProbablyEngine.dsl.parse
local UnitThreatSituation = UnitThreatSituation
local UnitCanAttack = UnitCanAttack
local UnitDebuff = UnitDebuff
local UnitClassification = UnitClassification
local UnitIsTappedByPlayer = UnitIsTappedByPlayer

--[[-----------------------------------------------
	** Round **
DESC: Round a number.
Example: [ if < 4.5 then return 4, else if >= 4.5 return 5 ].

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

--[[-----------------------------------------------
	** Distance **
DESC: returns the distance betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Distance(a, b)
	if UnitExists(a) and UnitExists(b) then
		-- FireHack
		if FireHack then
			local ax, ay, az = ObjectPosition(b)
			local bx, by, bz = ObjectPosition(a)
			return NeP.Core.Round(math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
		else
			return ProbablyEngine.condition['distance'](b)
		end
	end
	return 0
end

--[[-----------------------------------------------
	** LineOfSight **
DESC: returns the LineOfSight betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
local ignoreLOS = {
	['76585'] = '',	-- Ragewing the Untamed (UBRS)
	['77063'] = '',	-- Ragewing the Untamed (UBRS)
	['77182'] = '',	-- Oregorger (BRF)
	['77891'] = '',	-- Grasping Earth (BRF)
	['77893'] = '',	-- Grasping Earth (BRF)
	['78981'] = '',	-- Iron Gunnery Sergeant (BRF)
	['81318'] = '',	-- Iron Gunnery Sergeant (BRF)
	['83745'] = '',	-- Ragewing Whelp (UBRS)
	['86252'] = '',	-- Ragewing the Untamed (UBRS)
	['56173'] = '',	-- Deathwing (DragonSoul)
	['56471'] = '',	-- Mutated Corruption (Dragon Soul: The Maelstrom)
	['57962'] = '',	-- Deathwing (Dragon Soul: The Maelstrom)
	['55294'] = '',	-- Ultraxion (DragonSoul)
	['56161'] = '',	-- Corruption (DragonSoul)
	['52409'] = '',	-- Ragnaros (FireLands)
	['87761'] = '',
}

local losFlags =  bit.bor(0x10, 0x100)
function NeP.Core.LineOfSight(a, b)
	if UnitExists(a) and UnitExists(b) then
		-- Workaround LoS issues.
		local aCheck = select(6,strsplit('-',UnitGUID(a)))
		local bCheck = select(6,strsplit('-',UnitGUID(b)))
		if ignoreLOS[tostring(aCheck)] ~= nil then return true end
		if ignoreLOS[tostring(bCheck)] ~= nil then return true end
		
		if FireHack then
			local ax, ay, az = ObjectPosition(a)
			local bx, by, bz = ObjectPosition(b)
			return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
		else
			-- Since other unlockers dont have LoS, return true
			return true
		end
	end
	return false
end

--[[-----------------------------------------------
	** Infront **
DESC: returns if a unit is infront of other or not.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.Infront(a, b)
	if (UnitExists(a) and UnitExists(b)) then
		-- FireHack
		if FireHack then
			local aX, aY, aZ = ObjectPosition(b)
			local bX, bY, bZ = ObjectPosition(a)
			local playerFacing = GetPlayerFacing()
			local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
			return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
		-- Fallback to PE's
		else
			return ProbablyEngine.condition['infront'](b)
		end
	end
end

local function NeP_isElite(unit)
	local boss = LibStub('LibBossIDs')
	local classification = UnitClassification(unit)
	if classification == 'elite' 
		or classification == 'rareelite' 
		or classification == 'rare' 
		or classification == 'worldboss' 
		or UnitLevel(unit) == -1 
		or boss.BossIDs[UnitID(unit)] then 
			return true 
		end
    return false
end

--[[-----------------------------------------------
** dynamicEval **
DESC: Used to get values from GUIs and use them
on PE's conditions

Build By: MTS
---------------------------------------------------]]
function NeP.Core.dynEval(condition, spell)
	return _parse(condition, spell or '')
end

--[[-----------------------------------------------
** Smart AoE **
DESC: PE's way to handle smart AoE does not provide
support for generic unlockers, using this + my OM makes it work
across all unlockers.

Build By: MTS
---------------------------------------------------]]
local _SAoE_Time = nil
local UnitsTotal = 0

function NeP.Core.SAoE(Units, Distance)
	if _SAoE_Time == nil or _SAoE_Time + 0.5 <= GetTime() then
		_SAoE_Time = nil
		UnitsTotal = 0
		
		-- Force AoE
		if peConfig.read('button_states', 'multitarget', false) then
			UnitsTotal = UnitsTotal + 99
		
		-- SAoE
		elseif peConfig.read('button_states', 'NeP_SAoE', false) then
			for i=1,#NeP.OM.unitEnemie do
				local Obj = NeP.OM.unitEnemie[i]
				if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
					if Obj.distance <= Distance then
						UnitsTotal = UnitsTotal + 1
					end
				end
			end
		end
		
		_SAoE_Time = GetTime()
		return UnitsTotal >= Units
	end
	
	return UnitsTotal >= Units 
end

--[[-----------------------------------------------
** Get Unit Combat Range **
DESC: Returns the units's combat range.

Build By: MTS
---------------------------------------------------]]
local _rangeTable = {
	['melee'] = 1.5,
	['ranged'] = 40,
}

function NeP.Core.UnitAttackRange(unitA, unitB, _type)
	if FireHack then 
		return _rangeTable[_type] + UnitCombatReach(unitA) + UnitCombatReach(unitB)
	-- Unlockers wich dont have UnitCombatReach like functions...
	else
		return _rangeTable[_type] + 3.5
	end
end

--[[-----------------------------------------------
** Automated Taunting **
DESC: Checks if a enemie in the OM cache can/should
be taunted.

Classifications:
	Elite (Includes all above)
	All

Build By: MTS
---------------------------------------------------]]
function NeP.Core.canTaunt()
	if NeP.Core.PeFetch('NePConf', 'Taunts') ~= 'Disabled' then
		for i=1,#NeP.OM.unitEnemie do
			local Obj = NeP.OM.unitEnemie[i]
			if (NeP.Core.PeFetch('NePConf', 'Taunts') == 'elite' and NeP_isElite(Obj.key)) 
			or NeP.Core.PeFetch('NePConf', 'Taunts') == 'all' then
				if UnitIsTappedByPlayer(Obj.key) and Obj.distance <= 40 then
					if UnitAffectingCombat(Obj.key) then
						if UnitThreatSituation('player', Obj.key) and UnitThreatSituation('player', Obj.key) <= 2 then
							if NeP.Core.Infront('player', Obj.key) then
								ProbablyEngine.dsl.parsedTarget = Obj.key
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

--[[-----------------------------------------------
** Automated Dispeling **
DESC: Checks if a friendly unit in the OM cache can/should
be dispelled.

Build By: MTS
---------------------------------------------------]]
local blacklistedDebuffs = {
	['Mark of Arrogance'] = '',
	['Displaced Energy'] = ''
}

local LibDispellable = LibStub("LibDispellable-1.0")

function NeP.Core.Dispel(Spell)
	if NeP.Core.PeFetch('NePConf', 'Dispell') then
		for i=1,#NeP.OM.unitFriend do
			local Obj = NeP.OM.unitFriend[i]
			if Obj.distance <= 40 then
				if LibDispellable:CanDispelWith(Obj.key, tonumber(GetSpellID(GetSpellName(Spell)))) then
					ProbablyEngine.dsl.parsedTarget = Obj.key
					return true
				end
			end
		end
	end
	
	return false
end

--[[
Usage:
NeP.Core.AutoDots(Spell, Health, Duration, Distance, Classification)

Classifications:
	elite - Elite
	minus - Minion of another NPC; does not give experience or reputation.
	normal - Normal
	rare - Rare
	rareelite - Rare-Elite
	worldboss - World Boss
	all - All Units
]]

function NeP.Core.AutoDots(Spell, Health, Duration, Distance, Classification)
	
	-- Check if we have the spell before anything else...
	if not IsUsableSpell(Spell) then return false end
	
	-- So we dont need to fill everything
	if Classification == nil then Classification = 'all' end
	if Distance == nil then Distance = 40 end
	if Health == nil then Health = 100 end
	if Duration == nil then Duration = 0 end
	
	for i=1,#NeP.OM.unitEnemie do
		local Obj = NeP.OM.unitEnemie[i]
		if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
			
			-- Classification WorkArounds
			local passThruClassification = false
			if (Classification == 'elite' and NeP_isElite(Obj.key)) or Classification == 'all' then passThruClassification = true end
			
			if UnitClassification(Obj.key) == Classification or passThruClassification then
				if Obj.health <= Health then
					local _,_,_,_,_,_,debuff = UnitDebuff(Obj.key, GetSpellInfo(Spell), nil, 'PLAYER')
					if not debuff or debuff - GetTime() < Duration then
						if UnitCanAttack('player', Obj.key)
						and Obj.distance <= Distance then
							if NeP.Core.Infront('player', Obj.key) then
								ProbablyEngine.dsl.parsedTarget = Obj.key
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

--[[-----------------------------------------------
** Automated Movements **
DESC: Moves to a unit.

Build By: MTS
---------------------------------------------------]]
local NeP_rangeTable = {
	['HUNTER'] = 'ranged',
	['WARLOCK'] = 'ranged',
	['PRIEST'] = 'ranged',
	['PALADIN'] = 'melee',
	['MAGE'] = 'ranged', 
	['ROGUE'] = 'melee',
	['DRUID'] = 'melee',
	['SHAMAN'] = 'ranged',
	['WARRIOR'] = 'melee',
	['DEATHKNIGHT'] = 'melee',
	['MONK'] = 'melee'
}

local function _manualMoving()
	if FireHack then
		local a, _ = GetKeyState('65')
		local s, _ = GetKeyState('83')
		local d, _ = GetKeyState('68')
		local w, _ = GetKeyState('87') 
		if a or s or d or w then
			return true
		end
	end
	
	-- There are no other unlocker wich can get key states yet...
	return false
end

function NeP.Core.MoveTo()
	if NeP.Core.PeFetch('NePConf', 'AutoMove') then
		if UnitIsVisible('target') and not UnitChannelInfo('player') then
			if not _manualMoving() then
				if NeP.Core.LineOfSight('player', 'target') then
					local _Range = NeP.Core.UnitAttackRange('player', 'target', NeP_rangeTable[select(2, UnitClass('player'))])
					local unitSpeed = GetUnitSpeed('player')
					if FireHack then
						-- Stop Moving
						if _Range > NeP.Core.Distance('player', 'target') and unitSpeed ~= 0 then 
							MoveTo(ObjectPosition('player'))
						-- Start Moving
						elseif _Range < NeP.Core.Distance('player', 'target') then
							NeP.Core.Alert('Moving to: '..GetUnitName('target', false)) 
							MoveTo(ObjectPosition('target'))
						end
					end
				end
			end
		end
	end
end

--[[-----------------------------------------------
** Automated Facing **
DESC: Checks if unit can/should be faced.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.FaceTo()
	if NeP.Core.PeFetch('NePConf', 'AutoFace') then
		local unitSpeed, _ = GetUnitSpeed('player')
		if not _manualMoving() and unitSpeed == 0 then
			if UnitIsVisible('target') and not UnitChannelInfo('player')then
				if not NeP.Core.Infront('player', 'target') then
					if NeP.Core.LineOfSight('player', 'target') then
						if FireHack then
							NeP.Core.Alert('Facing: '..GetUnitName('target', false)) 
							FaceUnit('target')
						end
					end
				end
			end
		end
	end
end

--[[-----------------------------------------------
** Automated Targets **
DESC: Checks if unit can/should be targeted.

Build By: MTS & StinkyTwitch
---------------------------------------------------]]
local NeP_forceTarget = {
		-- WOD DUNGEONS/RAIDS
	['75966'] = '',      -- Defiled Spirit (Shadowmoon Burial Grounds)
	['76220'] = '',      -- Blazing Trickster (Auchindoun Normal)
	['76222'] = '',      -- Rallying Banner (UBRS Black Iron Grunt)
	['76267'] = '',      -- Solar Zealot (Skyreach)
	['76518'] = '',      -- Ritual of Bones (Shadowmoon Burial Grounds)
	['77252'] = '',      -- Ore Crate (BRF Oregorger)
	['77665'] = '',      -- Iron Bomber (BRF Blackhand)
	['77891'] = '',      -- Grasping Earth (BRF Kromog)
	['77893'] = '',      -- Grasping Earth (BRF Kromog)
	['86752'] = '',      -- Stone Pillars (BRF Mythic Kromog)
	['78583'] = '',      -- Dominator Turret (BRF Iron Maidens)
	['78584'] = '',      -- Dominator Turret (BRF Iron Maidens)
	['79504'] = '',      -- Ore Crate (BRF Oregorger)
	['79511'] = '',      -- Blazing Trickster (Auchindoun Heroic)
	['81638'] = '',      -- Aqueous Globule (The Everbloom)
	['86644'] = '',      -- Ore Crate (BRF Oregorger)
	['94873'] = '',      -- Felfire Flamebelcher (HFC)
	['90432'] = '',      -- Felfire Flamebelcher (HFC)
	['95586'] = '',      -- Felfire Demolisher (HFC)
	['93851'] = '',      -- Felfire Crusher (HFC)
	['90410'] = '',      -- Felfire Crusher (HFC)
	['94840'] = '',      -- Felfire Artillery (HFC)
	['90485'] = '',      -- Felfire Artillery (HFC)
	['93435'] = '',      -- Felfire Transporter (HFC)
	['93717'] = '',      -- Volatile Firebomb (HFC)
	['188293'] = '',     -- Reinforced Firebomb (HFC)
	['94865'] = '',      -- Grasping Hand (HFC)
	['93838'] = '',      -- Grasping Hand (HFC)
	['93839'] = '',      -- Dragging Hand (HFC)
	['91368'] = '',      -- Crushing Hand (HFC)
	['94455'] = '',      -- Blademaster Jubei'thos (HFC)
	['90387'] = '',      -- Shadowy Construct (HFC)
	['90508'] = '',      -- Gorebound Construct (HFC)
	['90568'] = '',      -- Gorebound Essence (HFC)
	['94996'] = '',      -- Fragment of the Crone (HFC)
	['95656'] = '',      -- Carrion Swarm (HFC)
	['91540'] = '',      -- Illusionary Outcast (HFC)
}

function NeP.Core.autoTarget(unit, name)
	if NeP.Core.PeFetch('NePConf', 'AutoTarget') then
		local NeP_ForcedTarget = false
		-- If dont have a target, or target is friendly or dead then
		if not UnitExists('target') or UnitIsFriend('player', 'target') or UnitIsDeadOrGhost('target') then
			-- Forced Target
			for i=1,#NeP.OM.unitEnemie do
				local Obj = NeP.OM.unitEnemie[i]
				local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj.key) or '0')
				if NeP_forceTarget[tostring(ObjID)] ~= nil then 
					NeP.Core.Alert('Targeting (S): '..Obj.name) 
					Macro('/target '..Obj.key)
					NeP_ForcedTarget = true
					break
				end

			end
			-- Auto Target
			if not NeP_ForcedTarget then 
				for i=1,#NeP.OM.unitEnemie do
					local Obj = NeP.OM.unitEnemie[i]
					if UnitExists(Obj.key) then
						if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
							if Obj.distance <= 40 then
								NeP.Core.Alert('Targeting: '..Obj.name) 
								Macro('/target '..Obj.key)
								break
							end
						end
					end
				end
			end	
		end
	end
end

--[[-----------------------------------------------
** Bag/item Functions **
DESC: Functions to control items or Bags

Build By: MTS
---------------------------------------------------]]
function NeP.Core.pickupItem(item)
	if GetItemCount(item, false, false) > 0 then
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				currentItemID = GetContainerItemID(bag, slot)
				if currentItemID == item then
					PickupContainerItem(bag, slot)
				end
			end
		end
	end
end

function NeP.Core.BagSpace()
	local freeslots = 0
	for lbag = 0, NUM_BAG_SLOTS do
		numFreeSlots, BagType = GetContainerNumFreeSlots(lbag)
		freeslots = freeslots + numFreeSlots
	end
	return freeslots
end

function NeP.Core.deleteItem(ID, number)
	if GetItemCount(ID, false, false) > number then
		NeP.Core.pickupItem(ID)
		if CursorHasItem() then
			DeleteCursorItem();
		end
	end
end

--[[----------------------------------------------- 
    ** Dummy Testing ** 
    DESC: Automatic timer for dummy testing
    ToDo: rename/cleanup 

    Build By: MTS
    ---------------------------------------------------]]
local DummyTest = {
	['StartedTime'] = 0,
	['LastPrint'] = 0,
	['TimeRemaning'] = 0
}

function NeP.Core.dummyTest(key)
	local hours, minutes = GetGameTime()
	local TimeRemaning = NeP.Core.PeFetch('NePConf', 'testDummy') - (minutes-DummyTest['StartedTime'])
	DummyTest['TimeRemaning'] = TimeRemaning
	
	-- If Disabled PE while runing a test, abort.
	if DummyTest['StartedTime'] ~= 0 
	and not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		DummyTest['StartedTime'] = 0
		NeP.Core.Print('You have Disabled PE while running a dummy test. \n[|cffC41F3BStoped dummy test timer|r].')
		StopAttack()
	end
	-- If not Calling for refresh, then start it.
	if key ~= 'Refresh' then
		DummyTest['StartedTime'] = minutes
		NeP.Core.Print('Dummy test started! \n[|cffC41F3BWill end in: '..NeP.Core.PeFetch('NePConf', 'testDummy')..'m|r]')
		-- If PE not enabled, then enable it.
		if not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
			ProbablyEngine.buttons.toggle('MasterToggle')
		end
		StartAttack('target')
	end
	-- Check If time is up.
	if DummyTest['StartedTime'] ~= 0 and key == 'Refresh' then
		-- Tell the user how many minutes left.
		if DummyTest['LastPrint'] ~= TimeRemaning then
			DummyTest['LastPrint'] = TimeRemaning
			NeP.Core.Print('Dummy Test minutes remaning: '..TimeRemaning)
		end
		if minutes >= DummyTest['StartedTime'] + NeP.Core.PeFetch('NePConf', 'testDummy') then
			DummyTest['StartedTime'] = 0
			NeP.Core.Print('Dummy test ended!')
			-- If PE enabled, then Disable it.
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
				ProbablyEngine.buttons.toggle('MasterToggle')
			end
			StopAttack()
		end
	end
end

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR and peConfig.read('button_states', 'MasterToggle', false) then
		NeP.Core.dummyTest('Refresh')
		if ProbablyEngine.module.player.combat then
			if UnitExists('target') then
				NeP.Core.MoveTo()
				NeP.Core.FaceTo()
			end
			NeP.Core.autoTarget()
		end
	end
end), nil)

--[[-----------------------------------------------
	** Class Color **
DESC: Decide wich class we're then return the
proper class color.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.classColor(unit, _type)
	if _type == nil then _type = 'HEX' end
	if UnitIsPlayer(unit) then
		local _classColors = {
			['HUNTER'] = { r = 0.67, g = 0.83, b = 0.45, Hex = 'abd473' },
			['WARLOCK'] = { r = 0.58, g = 0.51, b = 0.79, Hex = '9482c9' },
			['PRIEST'] = { r = 1.0, g = 1.0, b = 1.0, Hex = 'ffffff' },
			['PALADIN'] = { r = 0.96, g = 0.55, b = 0.73, Hex = 'f58cba' },
			['MAGE'] = { r = 0.41, g = 0.8, b = 0.94, Hex = '69ccf0' },
			['ROGUE'] = { r = 1.0, g = 0.96, b = 0.41, Hex = 'fff569' },
			['DRUID'] = { r = 1.0, g = 0.49, b = 0.04, Hex = 'ff7d0a' },
			['SHAMAN'] = { r = 0.0, g = 0.44, b = 0.87, Hex = '0070de' },
			['WARRIOR'] = { r = 0.78, g = 0.61, b = 0.43, Hex = 'c79c6e' },
			['DEATHKNIGHT'] = { r = 0.77, g = 0.12 , b = 0.23, Hex = 'c41f3b' },
			['MONK'] = { r = 0.0, g = 1.00 , b = 0.59, Hex = '00ff96' },
		}
		local _class, className = UnitClass(unit)
		local _color = _classColors[className]
		
		if _type == 'HEX' then
			return _color.Hex
		elseif _type == 'RBG' then
			return _color.r, _color.g, _color.b
		end
	else
		return 'FFFFFF'
	end
end

--[[-----------------------------------------------
	** GetCrInfo **
DESC: This is used to easly change the name of
every CR at the same time.
Requires manual class/spec insert.
Example: [ NeP.Core.GetCrInfo('Warrior - Arms') ]

Build By: MTS
---------------------------------------------------]]
function NeP.Core.GetCrInfo(txt)
	local _nick = _addonColor..NeP.Info.Nick
	local _classColor = NeP.Core.classColor('Player')
	return '|T'..NeP.Info.Logo..':10:10|t'.. '|r[' .. _nick .. '|r]|r[|cff' .. _classColor .. txt .. '|r]'
end

--[[-----------------------------------------------
	** HideAll **
DESC: Hide everything, you might need this for
livestreams or recording.
While hiding all alerts/notifications, sounds &
prints should not be displayed.

Could be improved...

Build By: MTS
---------------------------------------------------]]
function NeP.Core.HideAll()
	if not NeP.Core.hiding then
		NeP.Core.Print('Now hiding everything, to re-enable use the command ( '..NeP.Info.Nick..' show ).')
		ProbablyEngine.buttons.buttonFrame:Hide()
		NeP_Frame:Hide()
		NeP.Core.hiding = true
	else
		NeP.Core.hiding = false
		ProbablyEngine.buttons.buttonFrame:Show()
		NeP_Frame:Show()
		NeP.Core.Print('Now Showing everything again.')
	end
end

--[[-----------------------------------------------
	** Print **
DESC: Print to chat window a message, this adds a
prefix and checks if it should print.

Build By: MTS
---------------------------------------------------]]
local lastPrint = ''
function NeP.Core.Print(txt)
	if txt ~= lastPrint then
		if not NeP.Core.hiding and NeP.Core.PeFetch('NePConf', 'Prints') then
			local _name = _addonColor..NeP.Info.Nick
			lastPrint = txt
			print('|r['.._name..'|r]: '..NeP.Interface.printColor..txt)
		end
	end
end

--[[-----------------------------------------------
	** Alert **
DESC: Display a alert on the main frame.

Build By: MTS
---------------------------------------------------]]
NeP.Interface.Alerts = {}
local lastAlert = ''
function NeP.Core.Alert(txt)
	if txt ~= lastPrint then
		if not NeP.Core.hiding and NeP.Core.PeFetch('NePConf', 'Alerts') then
			lastAlert = txt
			table.insert(NeP.Interface.Alerts, txt)
		end
	end
end

--[[-----------------------------------------------
	** NePData **
DESC: Saved variables.

Build By: MTS
---------------------------------------------------]]
NeP.Config = {
	Defaults = {}
}

local LoadNePData = CreateFrame('Frame')
LoadNePData:RegisterEvent('VARIABLES_LOADED')
LoadNePData:SetScript('OnEvent', function(self, event, addon)
	
	-- IF NePData does not exist, then create it with defaults
	if not NePData or NePData == nil then 
	 	NePData = NeP.Config.Defaults
	end

	-- Reset
	function NeP.Config.resetConfig(config)
		NePData[config] = NeP.Config.Defaults[config]
	end
	
	-- Read
	function NeP.Config.readKey(config, key)
		if NePData[config] ~= nil then
			if NePData[config][key] ~= nil then
				return NePData[config][key]
			else
				NePData[config][key] = NeP.Config.Defaults[config][key] 
			end
		else
			NePData[config] = NeP.Config.Defaults[config]
		end
	end

	-- Write
	function NeP.Config.writeKey(config, key, value)
		NePData[config][key] = value
	end

	-- Toggle
	function NeP.Config.toggleKey(config, key)
		if NePData[config][key] ~= nil then
			NePData[config][key] = not NePData[config][key]
		else
			NePData[config][key] = NeP.Config.Defaults[config][key] 
		end
	end
	
	--[[
		Run GUI's wich depend on NePData.
		This is the best way i could think of to make sure nothing
		wich depends on NePData gets loaded too early.
	]]
	StatusGUI_RUN();
	OMGUI_RUN()

	--[[
		PE's Overwrites.
		Somethings on PE have issues or could be better,
		until they're fixed in PE itself we overwrite them.
	]]
	LineOfSight = NeP.Core.LineOfSight

end)

--[[-----------------------------------------------		
	** Commands **		
DESC: Slash commands in-game.		
		
Build By: MTS		
--------------------------------------------------]]		
ProbablyEngine.command.register(NeP.Info.Nick, function(msg, box)		
	local command, text = msg:match('^(%S*)%s*(.-)$')
	if command == 'config' or command == 'c' then
		NeP.Core.displayGUI('Settings')
	elseif command == 'class' or command == 'cl' then
		NeP.Interface.ClassGUI('Show')
	elseif command == 'info' or command == 'i' then
		NeP.Core.displayGUI('Info')
	elseif command == 'fish' or command == 'fishingbot' then		
		NeP.Core.displayGUI('fishingBot')
	elseif command == 'pet' or command == 'petbot' then		
		NeP.Core.displayGUI('petBot')
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		if NeP.Core.hiding then
			NeP.Core.hiding = false
			ProbablyEngine.buttons.buttonFrame:Show()
			NeP_Frame:Show()
			NeP.Core.Print('Now Showing everything again.')
		end
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Core.displayGUI('Overlays')
	else
		-- Print all available commands.
		NeP.Core.Print('/config - (Opens General Settings GUI)')
		NeP.Core.Print('/status - (Opens Status GUI)')
		NeP.Core.Print('/class - (Opens Class Settings GUI)')
		NeP.Core.Print('/Info - (Opens Info GUI)')
		NeP.Core.Print('/pet - (Opens Petbot GUI)')
		NeP.Core.Print('/fish - (Opens FishBot GUI)')
		NeP.Core.Print('/hide - (Hides Everything)')
		NeP.Core.Print('/show - (Shows Everything)')
		NeP.Core.Print('/overlays - (Opens Overlays Settings GUI)')
	end
end)

ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
	if NeP.Core.PeFetch('NePConf', 'AutoLFG') then
		AcceptProposal()
	end
end)

ProbablyEngine.condition.register('twohand', function(target)
  return IsEquippedItemType("Two-Hand")
end)

ProbablyEngine.condition.register('onehand', function(target)
  return IsEquippedItemType("One-Hand")
end)

ProbablyEngine.condition.register('elite', function(target)
  return UnitClassification(target) == 'elite'
end)

ProbablyEngine.condition.register("petinmelee", function(target)
   return (IsSpellInRange(GetSpellInfo(2649), target) == 1)
end)

ProbablyEngine.condition.register("inMelee", function(target)
   return NeP.Core.UnitAttackRange('player', target, 'melee')
end)

ProbablyEngine.condition.register("inRanged", function(target)
   return NeP.Core.UnitAttackRange('player', target, 'ranged')
end)

ProbablyEngine.condition.register("power.regen", function(target)
  return select(2, GetPowerRegen(target))
end)

ProbablyEngine.condition.register("casttime", function(target, spell)
    local name, rank, icon, cast_time, min_range, max_range = GetSpellInfo(spell)
    return cast_time
end)

ProbablyEngine.condition.register('NePinterrupt', function (target)
	if ProbablyEngine.condition['modifier.toggle']('interrupt') then
		if UnitName('player') == UnitName(target) then return false end
		local stopAt = NeP.Core.PeFetch('NePConf', 'ItA') or 95
		local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
		return secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt
	end
	return false
end)

ProbablyEngine.condition.register("isBoss", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("isElite", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "elite" 
		or classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("NePinfront", function(target)
	return NeP.Core.Infront('player', target)
end)

ProbablyEngine.condition.register("castwithin", function(target, spell)
	local SpellID = select(7, GetSpellInfo(spell))
	for k, v in pairs( ProbablyEngine.actionLog.log ) do
		local id = select(7, GetSpellInfo(v.description))
		if (id and id == SpellID and v.event == "Spell Cast Succeed") or tonumber( k ) == 20 then
			return tonumber( k )
		end
	end
	return 20
end)

ProbablyEngine.condition.register("ShouldRess", function()
	for i=1,#NeP.OM.unitFriendDead do
		local Obj = NeP.OM.unitFriendDead[i]
		if Obj.distance <= 40 then
			if not UnitHasIncomingResurrection(Obj.key) then
				ProbablyEngine.dsl.parsedTarget = Obj.key
				return true
			end
		end
	end
end)