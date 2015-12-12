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
		Branch = 'Release',
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
	-- FireHack
	if FireHack then
		-- Dont crash if invalid pointers
		if ObjectExists(a) and ObjectExists(b) then
			local ax, ay, az = ObjectPosition(b)
			local bx, by, bz = ObjectPosition(a)
			return math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2))
		end
	else
		return ProbablyEngine.condition['distance'](b)
	end
	return 0
end

--[[-----------------------------------------------
	** LineOfSight **
DESC: returns the LineOfSight betwen 2 units/objetcs.

Build By: MTS
---------------------------------------------------]]
local ignoreLOS = {
	[76585] = '',	-- Ragewing the Untamed (UBRS)
	[77063] = '',	-- Ragewing the Untamed (UBRS)
	[77182] = '',	-- Oregorger (BRF)
	[77891] = '',	-- Grasping Earth (BRF)
	[77893] = '',	-- Grasping Earth (BRF)
	[78981] = '',	-- Iron Gunnery Sergeant (BRF)
	[81318] = '',	-- Iron Gunnery Sergeant (BRF)
	[83745] = '',	-- Ragewing Whelp (UBRS)
	[86252] = '',	-- Ragewing the Untamed (UBRS)
	[56173] = '',	-- Deathwing (DragonSoul)
	[56471] = '',	-- Mutated Corruption (Dragon Soul: The Maelstrom)
	[57962] = '',	-- Deathwing (Dragon Soul: The Maelstrom)
	[55294] = '',	-- Ultraxion (DragonSoul)
	[56161] = '',	-- Corruption (DragonSoul)
	[52409] = '',	-- Ragnaros (FireLands)
	[87761] = '',
}

local losFlags =  bit.bor(0x10, 0x100)
function NeP.Core.LineOfSight(a, b)
	if UnitExists(a) and UnitExists(b) then
		-- Workaround LoS issues.
		local aCheck = select(6,strsplit('-',UnitGUID(a)))
		local bCheck = select(6,strsplit('-',UnitGUID(b)))
		if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
		if ignoreLOS[tonumber(bCheck)] ~= nil then return true end
		
		if FireHack then
			-- Dont crash if invalid pointers
			if ObjectExists(a) and ObjectExists(b) then
				local ax, ay, az = ObjectPosition(a)
				local bx, by, bz = ObjectPosition(b)
				return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
			end
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
			-- Dont crash if invalid pointers
			if ObjectExists(a) and ObjectExists(b) then
				local aX, aY, aZ = ObjectPosition(b)
				local bX, bY, bZ = ObjectPosition(a)
				local playerFacing = GetPlayerFacing()
				local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
				return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
			end
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

-- test
local function getUnitsAround(unit)
	local numberUnits = 0
	for i=1,#NeP.OM.unitEnemie do
		local Obj = NeP.OM.unitEnemie[i]
		if UnitAffectingCombat(unit) and NeP.Core.Distance(unit, Obj.key) <= 10 then
			numberUnits = numberUnits + 1
		end
	end
	return numberUnits
end

function NeP.Core.SAoEObject(Units)
	local UnitsAroundObject = {}
	for i=1,#NeP.OM.unitEnemie do
		local Obj = NeP.OM.unitEnemie[i]
		if UnitAffectingCombat(Obj.key) and Obj.distance <= 40 then
			UnitsAroundObject[#UnitsAroundObject+1] = {
				unitsAround = getUnitsAround(Obj.key),
				key = Obj.key
			}
		end
	end
	table.sort(UnitsAroundObject, function(a,b) return a.unitsAround < b.unitsAround end)
	if UnitsAroundObject[1].unitsAround > Units then
		-- set PEs parsed Target and return true
		ProbablyEngine.dsl.parsedTarget = UnitsAroundObject[1].key
		return true
	end
	return false
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

function NeP.Core.AutoDots(Spell, refreshAt)
	-- Check if we have the spell before anything else...
	if not IsUsableSpell(Spell) then return false end
	local Spellname, Spellrank, Spellicon, SpellcastingTime, SpellminRange, SpellmaxRange, SpellID = GetSpellInfo(Spell)
	local SpellcastingTime = SpellcastingTime * 0.001
	-- If toggle is enabled, do automated
	if peConfig.read('button_states', 'NeP_ADots', false) then
		-- Iterate thru OM
		for i=1,#NeP.OM.unitEnemie do
			local Obj = NeP.OM.unitEnemie[i]
			-- Affecting combat or Dummy and is elite or above
			if (UnitAffectingCombat(Obj.key) or Obj.is == 'dummy') and Obj.class >= 3 then	
				-- Sanity checks
				if UnitCanAttack('player', Obj.key)
				and NeP.Core.Infront('player', Obj.key)
				and IsSpellInRange(Spellname, Obj.key)then
					-- Do we have the debuff and is it expiring?
					local _,_,_,_,_,_,debuffDuration = UnitDebuff(Obj.key, Spellname, nil, 'PLAYER')
					if not debuffDuration or  - GetTime() < refreshAt then
						-- Dont cast if the targedebuffDurationt is going to die
						-- FIXME: Add a proper TTD
						if debuffDuration == nil then debuffDuration = 0 end
						if ProbablyEngine.condition['ttd'](Obj.key) > (debuffDuration + SpellcastingTime) then
							-- set PEs parsed Target and return true
							ProbablyEngine.dsl.parsedTarget = Obj.key
							return true
						end
					end
				end
			end
		end
	else
		-- Fallback to PEs
		local _,_,_,_,_,_,debuffDuration = UnitDebuff('target', Spellname, nil, 'PLAYER')
		if not debuffDuration or  - GetTime() < refreshAt then
			if debuffDuration == nil then debuffDuration = 0 end
			if IsSpellInRange(Spellname, 'target')
			and NeP.Core.Infront('player', 'target')
			-- FIXME: Add a proper TTD
			and ProbablyEngine.condition['ttd']('target') > (debuffDuration + SpellcastingTime) then
				return true
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
	if NeP.Core.PeFetch('NePConf', 'AutoMove') and FireHack then
		if UnitIsVisible('target') and not UnitChannelInfo('player') then
			if not _manualMoving() and NeP.Core.LineOfSight('player', 'target') then
				local _Range = NeP.Core.UnitAttackRange('player', 'target', NeP_rangeTable[select(2, UnitClass('player'))])
				local unitSpeed = GetUnitSpeed('player')
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

--[[-----------------------------------------------
** Automated Facing **
DESC: Checks if unit can/should be faced.

Build By: MTS
---------------------------------------------------]]
function NeP.Core.FaceTo()
	if NeP.Core.PeFetch('NePConf', 'AutoFace') and FireHack then
		local unitSpeed, _ = GetUnitSpeed('player')
		if not _manualMoving() and unitSpeed == 0 then
			if UnitIsVisible('target') and not UnitChannelInfo('player')then
				if not NeP.Core.Infront('player', 'target') and NeP.Core.LineOfSight('player', 'target') then
					NeP.Core.Alert('Facing: '..GetUnitName('target', false)) 
					FaceUnit('target')
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
	[75966] = 100,      -- Defiled Spirit (Shadowmoon Burial Grounds)
	[76220] = 100,      -- Blazing Trickster (Auchindoun Normal)
	[76222] = 100,      -- Rallying Banner (UBRS Black Iron Grunt)
	[76267] = 100,      -- Solar Zealot (Skyreach)
	[76518] = 100,      -- Ritual of Bones (Shadowmoon Burial Grounds)
	[77252] = 100,      -- Ore Crate (BRF Oregorger)
	[77665] = 100,      -- Iron Bomber (BRF Blackhand)
	[77891] = 100,      -- Grasping Earth (BRF Kromog)
	[77893] = 100,      -- Grasping Earth (BRF Kromog)
	[86752] = 100,      -- Stone Pillars (BRF Mythic Kromog)
	[78583] = 100,      -- Dominator Turret (BRF Iron Maidens)
	[78584] = 100,      -- Dominator Turret (BRF Iron Maidens)
	[79504] = 100,      -- Ore Crate (BRF Oregorger)
	[79511] = 100,      -- Blazing Trickster (Auchindoun Heroic)
	[81638] = 100,      -- Aqueous Globule (The Everbloom)
	[86644] = 100,      -- Ore Crate (BRF Oregorger)
	[94873] = 100,      -- Felfire Flamebelcher (HFC)
	[90432] = 100,      -- Felfire Flamebelcher (HFC)
	[95586] = 100,      -- Felfire Demolisher (HFC)
	[93851] = 100,      -- Felfire Crusher (HFC)
	[90410] = 100,      -- Felfire Crusher (HFC)
	[94840] = 100,      -- Felfire Artillery (HFC)
	[90485] = 100,      -- Felfire Artillery (HFC)
	[93435] = 100,      -- Felfire Transporter (HFC)
	[93717] = 100,      -- Volatile Firebomb (HFC)
	[188293] = 100,     -- Reinforced Firebomb (HFC)
	[94865] = 100,      -- Grasping Hand (HFC)
	[93838] = 100,      -- Grasping Hand (HFC)
	[93839] = 100,      -- Dragging Hand (HFC)
	[91368] = 100,      -- Crushing Hand (HFC)
	[94455] = 100,      -- Blademaster Jubei'thos (HFC)
	[90387] = 100,      -- Shadowy Construct (HFC)
	[90508] = 100,      -- Gorebound Construct (HFC)
	[90568] = 100,      -- Gorebound Essence (HFC)
	[94996] = 100,      -- Fragment of the Crone (HFC)
	[95656] = 100,      -- Carrion Swarm (HFC)
	[91540] = 100,      -- Illusionary Outcast (HFC)
}

local function getTargetPrio(Obj)
	local objectType, _, _, _, _, _id, _ = strsplit("-", UnitGUID(Obj))
	local ID = tonumber(_id) or '0'
	local prio = 1
	-- if its elite
	if NeP_isElite(Obj) then
		prio = prio + 10
	end
	-- If its forced
	if NeP_forceTarget[tonumber(Obj)] ~= nil then
		prio = prio + NeP_forceTarget[tonumber(Obj)] 
	end
	return prio
end

-- FIXME: Add forced targets
function NeP.Core.autoTarget(unit, name)
	if NeP.Core.PeFetch('NePConf', 'AutoTarget') then
		-- If dont have a target, target is friendly or dead
		if not UnitExists('target') or UnitIsFriend('player', 'target') or UnitIsDeadOrGhost('target') then
			local setPrio = {}
			for i=1,#NeP.OM.unitEnemie do
				local Obj = NeP.OM.unitEnemie[i]
				if UnitExists(Obj.key) and Obj.distance <= 40 then
					if UnitAffectingCombat(Obj.key) or Obj.is == 'dummy' then
						setPrio[#setPrio+1] = {
							key = Obj.key,
							bonus = getTargetPrio(Obj.key),
							name = Obj.name
						}
					end
				end
			end
			table.sort(setPrio, function(a,b) return a.bonus > b.bonus end)
			if setPrio[1] ~= nil then
				NeP.Core.Alert('Targeting: '..setPrio[1].name) 
				Macro('/target '..setPrio[1].key)
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
	StatusGUI_RUN()
	OMGUI_RUN()

	--[[
		PE's Overwrites.
		Somethings on PE have issues or could be better,
		until they're fixed in PE itself we overwrite them.
	]]
	LineOfSight = NeP.Core.LineOfSight

end)
