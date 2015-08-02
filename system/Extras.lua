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
  	if NeP.Core.PeFetch('npconf', 'AutoMove') then
  		if UnitExists('target') and UnitIsVisible('target') then
			local name = GetUnitName('target', false)
			if FireHack then
				local aX, aY, aZ = ObjectPosition('target')
				if NeP.Lib.Distance("player", 'target') >= 6 + (UnitCombatReach('player') + UnitCombatReach('target')) then
					npAlert:message('Moving to: '..name) 
					MoveTo(aX, aY, aZ)
				end
			elseif WOWSX_ISLOADED then
				local aX, aY, aZ = ObjectPosition('target')
				if NeP.Lib.Distance("player", 'target') >= 6 then
					npAlert:message('Moving to: '..name) 
					MoveTo(aX, aY, aZ)
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
	if NeP.Core.PeFetch('npconf', 'AutoFace') then
	local unitSpeed, _ = GetUnitSpeed('player')
	  	if UnitExists('target') and UnitIsVisible('target') and unitSpeed == 0 and not UnitChannelInfo("player") then
			local name = GetUnitName('target', false)
			if not NeP.Lib.Infront('target') then
				if FireHack then
					npAlert:message('Facing: '..name) 
					FaceUnit('target')
				elseif oexecute then
					npAlert:message('Facing: '..name) 
					FaceToUnit('target')
				elseif WOWSX_ISLOADED then
					local radian = ObjectFacing("target")
					npAlert:message('Facing: '..name) 
					Face(radian+PI)
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
	if NeP.Core.PeFetch('npconf', 'AutoTarget') then
		if UnitExists("target") and not UnitIsFriend("player", "target") and not UnitIsDeadOrGhost("target") then
			-- Do nothing
		else
			for i=1,#NeP.ObjectManager.unitCache do
				if NeP.ObjectManager.unitCache[i].name ~= UnitName("player") then
					npAlert:message('Targeting: '..NeP.ObjectManager.unitCache[i].name) 
					Macro("/target "..NeP.ObjectManager.unitCache[i].key)
				end
			end
		end
	end
end

--[[----------------------------------------------- 
    ** Utility - Milling ** 
    DESC: Automatic Draenor herbs milling 
    ToDo: Test it & add some kind of button to start instease of using a
    checkbox on the GUI.
    Oh and possivly add more stuff...

    Build By: MTS
    ---------------------------------------------------]] 
NeP.AutoMilling = false -- [[ VAR for AutoMilling feature ]]
function NeP.Extras.autoMilling()
	local Milling_Herbs = {
		-- Draenor
		109124, -- Frostweed
		109125, -- Fireweed
		109126, -- Gorgrond Flytrap
		109127, -- Starflower
		109128, -- Nagrand Arrowbloom
		109129 -- Talador Orchid
	}
	if NeP.AutoMilling then
		if IsSpellKnown(51005) then
			for i=1,#Milling_Herbs do
				if GetItemCount(Milling_Herbs[i],false,false) >= 5 then 
					Cast(51005) 
					UseItem(Milling_Herbs[i])
					NeP.Core.Print('Milling '..Milling_Herbs[i])
				else	
					NeP.AutoMilling = false
					NeP.Core.Print('Stoped milling, you dont have enough mats.')
				end
			end
		else
			NeP.AutoMilling = false
			NeP.Core.Print('Failed, you are not a miller.')
		end
	end
end

--[[----------------------------------------------- 
    ** Savage ** 
    DESC: Savge Items

    Build By: SVS
    ---------------------------------------------------]]
function NeP.Extras.OpenSalvage()
	if NeP.Core.PeFetch('npconf', 'OpenSalvage') then
		-- Bag of Salvaged Goods
		if GetItemCount(114116, false, false) > 0 then
			UseItem(114116)
		-- Crate of Salvage
		elseif GetItemCount(114119, false, false) > 0 then
			UseItem(114119)
		-- Big Crate of Salvage
		elseif GetItemCount(114120, false, false) > 0 then
			UseItem(114120)
		end
	end
end

function NeP.Extras.AutoBait()
	if NeP.Core.PeFetch('npconf', 'bait') ~= "none" then
		-- Jawless Skulker Bait
		if NeP.Core.PeFetch('npconf', 'bait') == "jsb" and not UnitBuff("player", GetSpellInfo(158031)) and GetItemCount(110274, false, false) > 0 then
			UseItem(110274)
		-- Fat Sleeper Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "fsb" and not UnitBuff("player", GetSpellInfo(158034)) and GetItemCount(110289, false, false) > 0 then
			UseItem(110289)
		-- Blind Lake Sturgeon Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "blsb" and not UnitBuff("player", GetSpellInfo(158035)) and GetItemCount(110290, false, false) > 0 then
			UseItem(110290)
		-- Fire Ammonite Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "fab" and not UnitBuff("player", GetSpellInfo(158036)) and GetItemCount(110291, false, false) > 0 then
			UseItem(110291)
		-- Sea Scorpion Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "ssb" and not UnitBuff("player", GetSpellInfo(158037)) and GetItemCount(110292, false, false) > 0 then
			UseItem(110292)
		-- Abyssal Gulper Eel Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "ageb" and not UnitBuff("player", GetSpellInfo(158038)) and GetItemCount(110293, false, false) > 0 then
			UseItem(110293)
		-- Blackwater Whiptail Bait
		elseif NeP.Core.PeFetch('npconf', 'bait') == "bwb" and not UnitBuff("player", GetSpellInfo(158039)) and GetItemCount(110294, false, false) > 0 then
			UseItem(110294)
		end
	end
end
 
local function CarpDestruction()
	if NeP.Core.PeFetch('npconf', 'LunarfallCarp') and GetItemCount(116158, false, false) > 0 then
		for bag = 0, NUM_BAG_SLOTS do
			for slot = 1, GetContainerNumSlots(bag) do
				currentItemID = GetContainerItemID(bag, slot)
				if currentItemID == 116158 then
					PickupContainerItem(bag, slot)
						if CursorHasItem() then
							DeleteCursorItem();
						end
					return true
				end
			end
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
	local TimeRemaning = NeP.Core.PeFetch('npconf', 'testDummy') - (minutes-NeP.Extras.dummyStartedTime)
	NeP.Extras.dummyTimeRemaning = TimeRemaning
	
	-- If Disabled PE while runing a test, abort.
	if NeP.Extras.dummyStartedTime ~= 0 and not ProbablyEngine.config.read('button_states', 'MasterToggle', false) then
		NeP.Extras.dummyStartedTime = 0
		message('|r[|cff9482C9MTS|r] You have Disabled PE while running a dummy test. \n[|cffC41F3BStoped dummy test timer|r].')
		StopAttack()
	end
	-- If not Calling for refresh, then start it.
	if key ~= 'Refresh' then
		NeP.Extras.dummyStartedTime = minutes
		message('|r[|cff9482C9MTS|r] Dummy test started! \n[|cffC41F3BWill end in: '..NeP.Core.PeFetch('npconf', 'testDummy').."m|r]")
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
		if minutes >= NeP.Extras.dummyStartedTime + NeP.Core.PeFetch('npconf', 'testDummy') then
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

--[[-----------------------------------------------
** Ticker **
DESC: SMASH ALL BUTTONS :)
This calls stuff in a define time (used for refreshing stuff).

Build By: MTS
---------------------------------------------------]]
C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR then
		NeP.Extras.dummyTest('Refresh')
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			if ProbablyEngine.module.player.combat then
				NeP.Extras.MoveTo()
				NeP.Extras.FaceTo()
				NeP.Extras.autoTarget()
			end
			if not ProbablyEngine.module.player.combat then
				if not UnitChannelInfo("player") then
					CarpDestruction()
					if NeP.Core.BagSpace() > 2 then
						NeP.Extras.autoMilling()
						NeP.Extras.OpenSalvage()
						NeP.Extras.AutoBait()
					end
				end
			end
		end
	end
end), nil)