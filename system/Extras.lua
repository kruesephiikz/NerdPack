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
	return false
end

NeP.Extras = {
	dummyStartedTime = 0,
	dummyLastPrint = 0,
	dummyTimeRemaning = 0
}

--[[-----------------------------------------------
** Automated Movements **
DESC: Moves to a unit.

Build By: MTS
---------------------------------------------------]]
function NeP.Extras.MoveTo()
	local _rangeTable = {
		["HUNTER"] = {style = "ranged", Range = 40},
		["WARLOCK"] = {style = "ranged",  Range = 40},
		["PRIEST"] = {style = "ranged",  Range = 40},
		["PALADIN"] = {style = "melee", Range = 1.5},
		["MAGE"] = {style = "ranged",  Range = 40},
		["ROGUE"] = {style = "melee", Range = 1.5},
		["DRUID"] = {style = "melee", Range = 1.5},
		["SHAMAN"] = {style = "ranged",  Range = 40},
		["WARRIOR"] = {style = "melee", Range = 1.5},
		["DEATHKNIGHT"] = {style = "melee", Range = 1.5},
		["MONK"] = {style = "melee", Range = 1.5},
	}
	local _class, _className = UnitClass('player')
	local _classRange = _rangeTable[_className]
	local unitSpeed, _ = GetUnitSpeed('player')
  	if NeP.Core.PeFetch('NePConf', 'AutoMove') then
  		if UnitExists('target') then
			if UnitIsVisible('target') and not UnitChannelInfo("player") then
				if NeP.Core.LineOfSight('player', 'target') then
					if not _manualMoving() then
						if FireHack then
							local _Range = _classRange.Range + UnitCombatReach('player') + UnitCombatReach('target')
							-- Stop Moving
							if ((_classRange.style == "ranged" and NeP.Core.Distance("player", 'target') < _Range)
							or (_classRange.style == "melee" and NeP.Core.Distance("player", 'target') < _Range))
							and unitSpeed ~= 0 then 
								MoveTo(ObjectPosition('player'))
							-- Start Moving
							elseif NeP.Core.Distance("player", 'target') > _Range then
								NeP.Alert('Moving to: '..GetUnitName('target', false)) 
								MoveTo(ObjectPosition('target'))
							end
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
function NeP.Extras.FaceTo()
	if NeP.Core.PeFetch('NePConf', 'AutoFace') then
		local unitSpeed, _ = GetUnitSpeed('player')
		if not _manualMoving() and unitSpeed == 0 then
			if UnitExists('target') then
				if UnitIsVisible('target') and not UnitChannelInfo("player")then
					if not NeP.Core.Infront('player', 'target') then
						if NeP.Core.LineOfSight('player', 'target') then
							if FireHack then
								NeP.Alert('Facing: '..GetUnitName('target', false)) 
								FaceUnit('target')
							end
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
function NeP.Extras.autoTarget(unit, name)
	if NeP.Core.PeFetch('NePConf', 'AutoTarget') then
		local _forceTarget = {
				-- WOD DUNGEONS/RAIDS
			75966,      -- Defiled Spirit (Shadowmoon Burial Grounds)
			76220,      -- Blazing Trickster (Auchindoun Normal)
			76222,      -- Rallying Banner (UBRS Black Iron Grunt)
			76267,      -- Solar Zealot (Skyreach)
			76518,      -- Ritual of Bones (Shadowmoon Burial Grounds)
			77252,      -- Ore Crate (BRF Oregorger)
			77665,      -- Iron Bomber (BRF Blackhand)
			77891,      -- Grasping Earth (BRF Kromog)
			77893,      -- Grasping Earth (BRF Kromog)
			86752,      -- Stone Pillars (BRF Mythic Kromog)
			78583,      -- Dominator Turret (BRF Iron Maidens)
			78584,      -- Dominator Turret (BRF Iron Maidens)
			79504,      -- Ore Crate (BRF Oregorger)
			79511,      -- Blazing Trickster (Auchindoun Heroic)
			81638,      -- Aqueous Globule (The Everbloom)
			86644,      -- Ore Crate (BRF Oregorger)
			94873,      -- Felfire Flamebelcher (HFC)
			90432,      -- Felfire Flamebelcher (HFC)
			95586,      -- Felfire Demolisher (HFC)
			93851,      -- Felfire Crusher (HFC)
			90410,      -- Felfire Crusher (HFC)
			94840,      -- Felfire Artillery (HFC)
			90485,      -- Felfire Artillery (HFC)
			93435,      -- Felfire Transporter (HFC)
			93717,      -- Volatile Firebomb (HFC)
			188293,     -- Reinforced Firebomb (HFC)
			94865,      -- Grasping Hand (HFC)
			93838,      -- Grasping Hand (HFC)
			93839,      -- Dragging Hand (HFC)
			91368,      -- Crushing Hand (HFC)
			94455,      -- Blademaster Jubei'thos (HFC)
			90387,      -- Shadowy Construct (HFC)
			90508,      -- Gorebound Construct (HFC)
			90568,      -- Gorebound Essence (HFC)
			94996,      -- Fragment of the Crone (HFC)
			95656,      -- Carrion Swarm (HFC)
			91540,      -- Illusionary Outcast (HFC)
			87318
		}
		local NeP_ForcedTarget = false

		if not UnitExists("target") or UnitIsFriend("player", "target") or UnitIsDeadOrGhost("target") then
	
			-- Forced Target
			for i=1,#NeP.ObjectManager.unitCache do
				local _object = NeP.ObjectManager.unitCache[i]
				local _,_,_,_,_,ObjID = strsplit("-", UnitGUID(_object.key))
				for k,v in pairs(_forceTarget) do
					if tonumber(ObjID) == v then 
						NeP.Alert('Targeting (S): '.._object.name) 
						Macro("/target ".._object.key)
						NeP_ForcedTarget = true
						break
					end
				end
			end
			
			-- Auto Target
			if not NeP_ForcedTarget then
				for i=1,#NeP.ObjectManager.unitCache do
					local _object = NeP.ObjectManager.unitCache[i]
					if UnitExists(_object.key) then
						if (UnitAffectingCombat(_object.key) or _object.dummy) then
							if _object.distance <= 40 then
								NeP.Alert('Targeting: '.._object.name) 
								Macro("/target ".._object.key)
								break
							end
						end
					end
				end
			end
			
		end
	end
end

function NeP.Extras.pickupItem(item)
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

function NeP.Extras.BagSpace()
	local freeslots = 0
	for lbag = 0, NUM_BAG_SLOTS do
		numFreeSlots, BagType = GetContainerNumFreeSlots(lbag)
		freeslots = freeslots + numFreeSlots
	end
	return freeslots
end

function NeP.Extras.deleteItem(ID, number)
	if GetItemCount(ID, false, false) > number then
		NeP.Extras.pickupItem(ID)
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
function NeP.Extras.dummyTest(key)
	local hours, minutes = GetGameTime()
	local TimeRemaning = NeP.Core.PeFetch('NePConf', 'testDummy') - (minutes-NeP.Extras.dummyStartedTime)
	NeP.Extras.dummyTimeRemaning = TimeRemaning
	
	-- If Disabled PE while runing a test, abort.
	if NeP.Extras.dummyStartedTime ~= 0 
	and not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		NeP.Extras.dummyStartedTime = 0
		message('|r[|cff9482C9MTS|r] You have Disabled PE while running a dummy test. \n[|cffC41F3BStoped dummy test timer|r].')
		StopAttack()
	end
	-- If not Calling for refresh, then start it.
	if key ~= 'Refresh' then
		NeP.Extras.dummyStartedTime = minutes
		message('|r[|cff9482C9MTS|r] Dummy test started! \n[|cffC41F3BWill end in: '..NeP.Core.PeFetch('NePConf', 'testDummy').."m|r]")
		-- If PE not enabled, then enable it.
		if not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
			ProbablyEngine.buttons.toggle('MasterToggle')
		end
		StartAttack("target")
	end
	-- Check If time is up.
	if NeP.Extras.dummyStartedTime ~= 0 and key == 'Refresh' then
		-- Tell the user how many minutes left.
		if NeP.Extras.dummyLastPrint ~= TimeRemaning then
			NeP.Extras.dummyLastPrint = TimeRemaning
			NeP.Core.Print('Dummy Test minutes remaning: '..TimeRemaning)
		end
		if minutes >= NeP.Extras.dummyStartedTime + NeP.Core.PeFetch('NePConf', 'testDummy') then
			NeP.Extras.dummyStartedTime = 0
			message('|r[|cff9482C9MTS|r] Dummy test ended!')
			-- If PE enabled, then Disable it.
			if ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
				ProbablyEngine.buttons.toggle('MasterToggle')
			end
			StopAttack()
		end
	end
end

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR and NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
		NeP.Extras.dummyTest('Refresh')
		if ProbablyEngine.module.player.combat then
			NeP.Extras.MoveTo()
			NeP.Extras.FaceTo()
			NeP.Extras.autoTarget()
		end
	end
end), nil)