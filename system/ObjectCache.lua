NeP.ObjectManager = {
	unitCache = {}, -- [[ Store Enemy objects ]]
	unitFriendlyCache = {}, -- [[ Store Friendly objects ]]
	objectsCache = {},
	unitCacheTotal = 0, -- [[ Store Friendly Count ]]
	unitCacheFriendlyTotal = 0, -- [[ Store Friendly Count ]]
	objectsCacheTotal = 0
}

local _addonColor = NeP.Addon.Interface.GuiTextColor
local _tittleGUI = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name
local _GUIColor = NeP.Addon.Interface.GuiColor
local OChObjectsTotal = NeP.ObjectManager.objectsCacheTotal
local OChUnitsTotal = NeP.ObjectManager.unitCacheTotal
local OChFriendlyTotal = NeP.ObjectManager.unitCacheFriendlyTotal
local OChUnits = NeP.ObjectManager.unitCache
local OChFriendly = NeP.ObjectManager.unitFriendlyCache
local OChObjects = NeP.ObjectManager.objectsCache

--[[
											LOCAL TABLES
								This is were you insert units/Object ID's 
									either to search or blacklist.
-------------------------------------------------------------------------------------------------------
]]


--[[
	ID's to display LM,
	Used for overlays.
---------------------------------------------------]]
local lumbermillIDs = {
	--[[ //// WOD //// ]]
	234127,
	234193,
	234023,
	234099,
	233634,
	237727,
	234126,
	234111,
	233922,
	234128,
	234000,
	234195,
	234196,
	234097,
	234198,
	234197,
	234123,
	234098,
	234022,
	233604,
	234120,
	234194,
	234021,
	234080,
	234110,
	230964,
	233635,
	234119,
	234122,
	234007,
	234199,
	234124
}

--[[
	ID's to display Ores,
	Used for overlays.
---------------------------------------------------]]
local oresIDs = {
	--[[ //// WOD //// ]]
	228510, --[[ Rich True Iron Deposit ]]
	228493, --[[ True Iron Deposit ]]
	228564, --[[ Rich Blackrock Deposit ]]
	228563, --[[ Blackrock Deposit ]]
	232544, --[[ True Iron Deposit ]]
	232545, --[[ Rich True Iron Deposit ]]
	232542, --[[ Blackrock Deposit ]]
	232543, --[[ Rich Blackrock Deposit ]]
	232541, --[[ Mine Cart ]]
}

--[[
	ID's to display Fish Poles,
	Used for overlays.
---------------------------------------------------]]
local fishIDs = {
	--[[ //// WOD //// ]]
	229072,
	229073,
	229069,
	229068,
	243325,
	243354,
	229070,
	229067,
	236756,
	237295,
	229071,
}

--[[
	ID's to display Herbs,
	Used for overlays.
---------------------------------------------------]]
local herbsIDs = {
	--[[ //// WOD //// ]]
	237400,
	228576,
	235391,
	237404,
	228574,
	235389,
	228575,
	237406,
	235390,
	235388,
	228573,
	237402,
	228571,
	237398,
	233117,
	235376,
	228991,
	235387,
	237396,
	228572
}

--[[
	DESC: Checks if unit has a Blacklisted Debuff.
	This will remove the unit from the OM cache.
---------------------------------------------------]]
local function BlacklistedDebuffs(unit)
	local NeP_ImmuneAuras = {
		-- CROWD CONTROL
		118,        -- Polymorph
		1513,       -- Scare Beast
		1776,       -- Gouge
		2637,       -- Hibernate
		3355,       -- Freezing Trap
		6770,       -- Sap
		9484,       -- Shackle Undead
		19386,      -- Wyvern Sting
		20066,      -- Repentance
		28271,      -- Polymorph (turtle)
		28272,      -- Polymorph (pig)
		49203,      -- Hungering Cold
		51514,      -- Hex
		61025,      -- Polymorph (serpent) -- FIXME: gone ?
		61305,      -- Polymorph (black cat)
		61721,      -- Polymorph (rabbit)
		61780,      -- Polymorph (turkey)
		76780,      -- Bind Elemental
		82676,      -- Ring of Frost
		90337,      -- Bad Manner (Monkey) -- FIXME: to check
		115078,     -- Paralysis
		115268,     -- Mesmerize
		-- MOP DUNGEONS/RAIDS/ELITES
		106062,     -- Water Bubble (Wise Mari)
		110945,     -- Charging Soul (Gu Cloudstrike)
		116994,     -- Unstable Energy (Elegon)
		122540,     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
		123250,     -- Protect (Lei Shi)
		143574,     -- Swelling Corruption (Immerseus)
		143593,     -- Defensive Stance (General Nazgrim)
		-- WOD DUNGEONS/RAIDS/ELITES
		155176,     -- Damage Shield (Primal Elementalists - Blast Furnace)
		155185,     -- Cotainment (Primal Elementalists - BRF)
		155233,     -- Dormant (Blast Furnace)
		155265,     -- Cotainment (Primal Elementalists - BRF)
		155266,     -- Cotainment (Primal Elementalists - BRF)
		155267,     -- Cotainment (Primal Elementalists - BRF)
		157289,     -- Arcane Protection (Imperator Mar'Gok)
		174057,     -- Arcane Protection (Imperator Mar'Gok)
		182055,     -- Full Charge (Iron Reaver)
		184053,     -- Fel Barrier (Socrethar)
	}
	for i = 1, 40 do
		local _,_,_,_,_,_,_,_,_,_,spellId = _G['UnitDebuff'](unit, i)
		for k,v in pairs(NeP_ImmuneAuras) do
			if spellId == v then return true end
		end
	end
end

--[[
	DESC: Checks if Object is a Blacklisted.
	This will remove the Object from the OM cache.
---------------------------------------------------]]
local function BlacklistedObject(unit)
	local BlacklistedObjects = {
		76829,		-- Slag Elemental (BrF - Blast Furnace)
		78463,		-- Slag Elemental (BrF - Blast Furnace)
		60197,      -- Scarlet Monastery Dummy
		64446,      -- Scarlet Monastery Dummy
		93391,      -- Captured Prisoner (HFC)
		93392,      -- Captured Prisoner (HFC)
		93828,      -- Training Dummy (HFC)
		234021,
		234022,
		234023
	}
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	for k,v in pairs(BlacklistedObjects) do
		if tonumber(unitID) == v then return true end
	end
end

--[[
	DESC: Checks if unit is a Dummy.
	This will force the unit from the OM cache.
---------------------------------------------------]]
local function UnitIsDummy(unit)
	local dummyObjects = {
		31144,      -- Training Dummy - Lvl 80
		31146,		-- Raider's Training Dummy - Lvl ??
		32541, 		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
		32542,		-- Disciple's Training Dummy - Lvl 65
		32545,		-- Initiate's Training Dummy - Lvl 55
		32546,		-- Ebon Knight's Training Dummy - Lvl 80
		32666,		-- Training Dummy - Lvl 60
		32667,		-- Training Dummy - Lvl 70
		46647,		-- Training Dummy - Lvl 85
		67127,		-- Training Dummy - Lvl 90
		87318,		-- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
		87761,		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
		87322,		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
		88314,		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
		88836,		-- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
		88288,		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
		87317,		-- Dungeoneer's Training Dummy - Lvl 102 (Lunarfall - Damage)
		87320,		-- Raider's Training Dummy - Lvl ?? (Stormshield - Damage)
		87321,		-- Training Dummy - Lvl 100 (Stormshield, Warspear - Healing)
		87329,		-- Raider's Training Dummy - Lvl ?? (Stormshield - Tank)
		87762,		-- Raider's Training Dummy - Lvl ?? (Warspear - Damage)
		88837,		-- Raider's Training Dummy - Lvl ?? (Warspear - Tank)
		88906,		-- Combat Dummy - Lvl 100 (Nagrand)
		88967,		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
		89078,		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
	}
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	for k,v in pairs(dummyObjects) do
		if tonumber(unitID) == v then return true end
	end
end

--[[
											ObjectManagers
									This contains the specific OM force
											each unlocker.
-------------------------------------------------------------------------------------------------------
]]
--[[
	FireHack OM
---------------------------------------------------]]
local firehackOM = function()
	local totalObjects = ObjectCount()
	for i=1, totalObjects do
		local Obj = ObjectWithIndex(i)
			if ObjectExists(Obj) then
				if ObjectIsType(Obj, ObjectTypes.GameObject) 
				or ObjectIsType(Obj, ObjectTypes.Unit) then
					if not BlacklistedObject(Obj) then		
					local _OName = UnitName(Obj)
					local _OD = NeP.Lib.Distance('player', Obj)
					if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
						-- Objects OM
						if ObjectIsType(Obj, ObjectTypes.GameObject) then
							local guid = UnitGUID(Obj)
							local _, _, _, _, _, _id, _ = strsplit("-", guid)
							local ObID = tonumber(_id)
							-- Lumbermill
							if NeP.Core.PeFetch("NePconf_Overlays", "objectsLM") then
								for k,v in pairs(lumbermillIDs) do
									if ObID == v then
										OChObjectsTotal = OChObjectsTotal + 1
										OChObjects[#OChObjects+1] = {
											key=Obj, 
											distance=_OD, 
											id=ObID, 
											name=_OName, 
											is='LM'
										}
										table.sort(OChObjects, function(a,b) return a.distance < b.distance end)
									end
								end
							end	
							-- Ores
							if NeP.Core.PeFetch("NePconf_Overlays", "objectsOres") then
								for k,v in pairs(oresIDs) do
									if ObID == v then
										OChObjectsTotal = OChObjectsTotal + 1
										OChObjects[#OChObjects+1] = {
											key=Obj, 
											distance=_OD, 
											id=ObID, 
											name=_OName, 
											is='Ore'
										}
										table.sort(OChObjects, function(a,b) return a.distance < b.distance end)
									end
								end
							end
							-- Herbs
							if NeP.Core.PeFetch("NePconf_Overlays", "objectsHerbs") then
								for k,v in pairs(herbsIDs) do
									if ObID == v then
										OChObjectsTotal = OChObjectsTotal + 1
										OChObjects[#OChObjects+1] = {
											key=Obj, 
											distance=_OD, 
											id=ObID, 
											name=_OName, 
											is='Herb'
										}
										table.sort(OChObjects, function(a,b) return a.distance < b.distance end)
									end
								end
							end
							-- Fish
							if NeP.Core.PeFetch("NePconf_Overlays", "objectsFishs") then
								for k,v in pairs(fishIDs) do
									if ObID == v then
										OChObjectsTotal = OChObjectsTotal + 1
										OChObjects[#OChObjects+1] = {
											key=Obj, 
											distance=_OD, 
											id=ObID, 
											name=_OName, 
											is='Fish'
										}
										table.sort(OChObjects, function(a,b) return a.distance < b.distance end)
									end
								end
							end

						-- Units OM
						elseif ObjectIsType(Obj, ObjectTypes.Unit) 
						and ProbablyEngine.condition["alive"](Obj) then
							if not BlacklistedDebuffs(Obj) then
								
								local health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100)
								local maxHealth = UnitHealthMax(Obj)
								local actualHealth = UnitHealth(Obj)
								local _class = UnitClassification(Obj)
												
								-- Friendly Cache
								if UnitIsFriend("player", Obj) then
									-- Enabled on GUI
									if NeP.Core.PeFetch("ObjectCache", "FU") then
										OChUnitsFriendlyTotal = OChUnitsFriendlyTotal + 1
										OChFriendly[#OChFriendly+1] = {
											key=Obj, 
											distance=_OD, 
											health=health, 
											maxHealth=maxHealth, 
											actualHealth=actualHealth, 
											name=_OName
										}
										table.sort(OChFriendly, function(a,b) return a.distance < b.distance end)
									end	
								-- INSERT DUMMYS!
								elseif UnitIsDummy(Obj) then
									if NeP.Core.PeFetch("ObjectCache", "dummys") then
										OChUnitsTotal = OChUnitsTotal + 1
										OChUnits[#OChUnits+1] = {
											key=Obj, 
											distance=_OD, 
											health=health, 
											maxHealth=maxHealth, 
											actualHealth=actualHealth, 
											name=_OName
										}
										table.sort(OChUnits, function(a,b) return a.distance < b.distance end)
									end	
								-- Enemie Units
								else
									-- Enabled on GUI and unit affecting combat
									if NeP.Core.PeFetch("ObjectCache", "EU") then
										OChUnitsTotal = OChUnitsTotal + 1
										OChUnits[#OChUnits+1] = {
											key=Obj, distance=_OD, 
											health=health, maxHealth=maxHealth, 
											actualHealth=actualHealth, 
											name=_OName, 
											class=_class
										}
										table.sort(OChUnits, function(a,b) return a.distance < b.distance end)
									end
								end			
							end
						end			
					end
				end
			end
		end
	end
end

--[[
	Generic OM
---------------------------------------------------]]
local genericOM = function()
	-- If in Group scan frames...
	if IsInGroup() or IsInRaid() then
		local prefix = (IsInRaid() and 'raid') or 'party'
		-- Enemies
		for i = 1, GetNumGroupMembers() do
			local target = prefix..i.."target"
			if NeP.Core.PeFetch("ObjectCache", "EU") then
				if UnitExists(target) 
				and not UnitIsFriend("player", target) then
					if UnitAffectingCombat(target) then
					local _OD = NeP.Lib.Distance('player', target)
						if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) 
						and ProbablyEngine.condition["alive"](target) then
							OChUnitsTotal = OChUnitsTotal + 1
							OChUnits[#OChUnits+1] = {
								key=target, 
								distance=_OD, 
								health=math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100), 
								maxHealth=UnitHealthMax(target), 
								actualHealth=UnitHealth(target), 
								name=UnitName(target)
							}
							table.sort(OChUnits, function(a,b) return a.distance < b.distance end)
						end
					end
				end
			end
		end	
		-- Friendly
		for i = -1, GetNumGroupMembers() - 1 do
			local friendly = (i == 0 and 'player') or prefix .. i
			if NeP.Core.PeFetch("ObjectCache", "FU") then
				local _OD = NeP.Lib.Distance('player', friendly)
				if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) 
				and ProbablyEngine.condition["alive"](friendly) then
					OChUnitsFriendlyTotal = OChUnitsFriendlyTotal + 1
					OChFriendly[#OChFriendly+1] = {
						key=friendly, 
						distance=_OD, 
						health=math.floor((UnitHealth(friendly) / UnitHealthMax(friendly)) * 100), 
						maxHealth=UnitHealthMax(friendly), 
						actualHealth=UnitHealth(friendly), 
						name=UnitName(friendly)
					}
					table.sort(OChFriendly, function(a,b) return a.distance < b.distance end)
				end
			end
		end
	-- Solo Cache self and target
	else
		-- Self
		OChUnitsFriendlyTotal = OChUnitsFriendlyTotal + 1
		OChFriendly[#OChFriendly+1] = {
			key='Player', 
			distance=0, 
			health=math.floor((UnitHealth('player') / UnitHealthMax('player')) * 100), 
			maxHealth=UnitHealthMax('player'), 
			actualHealth=UnitHealth('player'), 
			name=UnitName('player')
		}
		-- Target
		if UnitExists('target') and not UnitIsFriend("player", 'target') then
			if UnitAffectingCombat('target') then
				local _OD = NeP.Lib.Distance('player', 'target')
				if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) 
				and ProbablyEngine.condition["alive"]('target') then
					OChUnitsTotal = OChUnitsTotal + 1
					OChFriendly[#OChFriendly+1] = {
						key='target', 
						distance=_OD, 
						health=math.floor((UnitHealth('target') / UnitHealthMax('target')) * 100), 
						maxHealth=UnitHealthMax('target'), 
						actualHealth=UnitHealth('target'), 
						name=UnitName('target')
					}
				end
			end
		end
		-- Mouseover
		if UnitExists('mouseover') and not UnitIsFriend("player", 'mouseover') then
			if UnitAffectingCombat('mouseover') then
				local _OD = NeP.Lib.Distance('player', 'mouseover')
				if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) 
				and ProbablyEngine.condition["alive"]('mouseover') then
					OChUnitsTotal = OChUnitsTotal + 1
					OChUnits[#OChUnits+1] = {
						key='mouseover', 
						distance=_OD, 
						health=math.floor((UnitHealth('mouseover') / UnitHealthMax('mouseover')) * 100), 
						maxHealth=UnitHealthMax('mouseover'), 
						actualHealth=UnitHealth('mouseover'), 
						name=UnitName('mouseover')
					}
				end
			end
		end		
	end
end

--[[
											ObjectManager GUI
									This contains the code for the GUI.
-------------------------------------------------------------------------------------------------------
]]


--[[
	VARs
---------------------------------------------------]]
local emptyMsg = "" -- [[ Message to display when empty... ]]
local NeP_cacheWindow
local NeP_cacheWindowEmemies
local NeP_cacheWindowFriendly
local NeP_OpenCacheWindow = false
local NeP_ShowingCacheWindow = false
local NeP_cacheWindowUpdating = false

--[[
	Settings GUI
---------------------------------------------------]]
local NeP_ObjectCache = {
    key = "ObjectCache",
    title = _tittleGUI,
    subtitle = "ObjectManager Settings",
    color = _GUIColor,
    width = 210,
    height = 350,
    config = {
    	{ type = 'header', text = _addonColor.."Cache Options:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Use ObjectCache", key = "ObjectCache", default = true },
			{ type = "checkbox", text = "Use Advanced Object Manager", key = "AC", default = true },
			{ type = "checkbox", text = "Cache Friendly Units", key = "FU", default = true },
			{ type = "checkbox", text = "Cache Enemies Units", key = "EU", default = true },
			{ type = "checkbox", text = "Cache Dummys Units", key = "dummys", default = true },
			{ type = "spinner", text = "Cache Distance:", key = "CD", width = 90, min = 10, max = 200, default = 100, step = 5},
		{ type = 'spacer' },{ type = 'spacer' },{ type = 'spacer' },{ type = 'spacer' },{ type = 'spacer' },{ type = 'spacer' },
		{ type = 'header', text = _addonColor.."Objects Counters:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
			{ key = 'current_Cache1Total', type = "text", text = emptyMsg, size = 14, offset = 5},
			{ key = 'current_Cache2Total', type = "text", text = emptyMsg, size = 14, offset = 5},
			{ key = 'current_Cache3Total', type = "text", text = emptyMsg, size = 14, offset = 5},
    }
}

--[[
	Enemies GUI
---------------------------------------------------]]
local NeP_EnemieObjectCache = {
    key = "ObjectCacheEnemy",
    title = _tittleGUI,
    subtitle = "Enemie List",
    color = _GUIColor,
    width = 210,
    height = 350,
    config = {
		{ type = 'header', text = _addonColor.."Enemy Unit Cache:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ key = 'current_Cache1_1', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_2', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_3', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_4', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_5', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_6', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_7', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_8', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_9', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache1_10', type = "text", text = emptyMsg, size = 11, offset = 60 },
    }
}

--[[
	Friendly GUI
---------------------------------------------------]]
local NeP_FriendlyObjectCache = {
    key = "ObjectCacheFriendly",
    title = _tittleGUI,
    subtitle = "Friendly List",
    color = _GUIColor,
    width = 210,
    height = 350,
    config = {
		{ type = 'header', text = _addonColor.."Friendly Unit Cache:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ key = 'current_Cache2_1', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_2', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_3', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_4', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_5', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_6', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_7', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_8', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_9', type = "text", text = emptyMsg, size = 11, offset = 60 },
			{ key = 'current_Cache2_10', type = "text", text = emptyMsg, size = 11, offset = 60 },
    }
}

--[[
	GUIs Manager
---------------------------------------------------]]
function NeP.Addon.Interface.CacheGUI()
    if not NeP_OpenCacheWindow then
        NeP_cacheWindow = ProbablyEngine.interface.buildGUI(NeP_ObjectCache)
		NeP_cacheWindowEmemies = ProbablyEngine.interface.buildGUI(NeP_EnemieObjectCache)
		NeP_cacheWindowFriendly = ProbablyEngine.interface.buildGUI(NeP_FriendlyObjectCache)
		-- [[ If you close any of the 3 windows open, they all close.]]
		NeP_cacheWindow.parent:SetEventListener('OnClose', function()
			NeP_cacheWindowEmemies.parent:Hide()
			NeP_cacheWindowFriendly.parent:Hide()
            NeP_OpenCacheWindow = false
            NeP_ShowingCacheWindow = false
        end)
		NeP_cacheWindowEmemies.parent:SetEventListener('OnClose', function()
			NeP_cacheWindow.parent:Hide()
			NeP_cacheWindowFriendly.parent:Hide()
            NeP_OpenCacheWindow = false
            NeP_ShowingCacheWindow = false
        end)
		NeP_cacheWindowFriendly.parent:SetEventListener('OnClose', function()
			NeP_cacheWindowEmemies.parent:Hide()
			NeP_cacheWindow.parent:Hide()
            NeP_OpenCacheWindow = false
            NeP_ShowingCacheWindow = false
        end)
		NeP_cacheWindowUpdating = true
		NeP_ShowingCacheWindow = true
		NeP_OpenCacheWindow = true
	elseif NeP_OpenCacheWindow and NeP_ShowingCacheWindow then
        NeP_cacheWindowUpdating = false
		NeP_ShowingCacheWindow = false
        NeP_cacheWindow.parent:Hide()
		NeP_cacheWindowEmemies.parent:Hide()
		NeP_cacheWindowFriendly.parent:Hide()
    elseif NeP_OpenCacheWindow and not NeP_ShowingCacheWindow then
        NeP_cacheWindowUpdating = true
		NeP_ShowingCacheWindow = true
        NeP_cacheWindow.parent:Show()
		NeP_cacheWindowEmemies.parent:Show()
		NeP_cacheWindowFriendly.parent:Show()
        
    end
end

--[[
	Update GUIs function
	Needs to improve! (Cleaner)
---------------------------------------------------]]
local OMGUI_Update = function()
	local GUIEnemies = NeP_cacheWindowEmemies.elements
	local GUIFriendly = NeP_cacheWindowFriendly.elements
	if NeP_cacheWindowUpdating then
		-- Totals:
		NeP_cacheWindow.elements.current_Cache1Total:SetText(_addonColor.."Total Enemies:|r "..OChUnitsTotal)
		NeP_cacheWindow.elements.current_Cache2Total:SetText(_addonColor.."Total Friendly:|r "..OChUnitsFriendlyTotal)
		NeP_cacheWindow.elements.current_Cache3Total:SetText(_addonColor.."Total GameObjects:|r "..OChObjectsTotal)
		-- Enemies:
		if OChUnits[1] then
			GUIEnemies.current_Cache1_1:SetText(_addonColor.."1 |r "..OChUnits[1].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[1].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[1].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[1].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[1].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[1].actualHealth)
		else GUIEnemies.current_Cache1_1:SetText(emptyMsg) end
		if OChUnits[2] then
			GUIEnemies.current_Cache1_2:SetText(_addonColor.."2 |r "..OChUnits[2].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[2].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[2].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[2].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[2].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[2].actualHealth)
		else GUIEnemies.current_Cache1_2:SetText(emptyMsg) end
		if OChUnits[3] then
			GUIEnemies.current_Cache1_3:SetText(_addonColor.."3 |r "..OChUnits[3].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[3].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[3].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[3].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[3].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[3].actualHealth)
		else GUIEnemies.current_Cache1_3:SetText(emptyMsg) end
		if OChUnits[4] then
			GUIEnemies.current_Cache1_4:SetText(_addonColor.."4 |r "..OChUnits[4].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[4].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[4].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[4].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[4].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[4].actualHealth)
		else GUIEnemies.current_Cache1_4:SetText(emptyMsg) end
		if OChUnits[5] then
			GUIEnemies.current_Cache1_5:SetText(_addonColor.."5 |r "..OChUnits[5].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[5].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[5].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[5].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[5].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[5].actualHealth)
		else GUIEnemies.current_Cache1_5:SetText(emptyMsg) end
		if OChUnits[6] then
			GUIEnemies.current_Cache1_6:SetText(_addonColor.."6 |r "..OChUnits[6].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[6].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[6].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[6].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[6].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[6].actualHealth)
		else GUIEnemies.current_Cache1_6:SetText(emptyMsg) end
		if OChUnits[7] then
			GUIEnemies.current_Cache1_7:SetText(_addonColor.."7 |r "..OChUnits[7].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[7].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[7].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[7].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[7].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[7].actualHealth)
		else GUIEnemies.current_Cache1_7:SetText(emptyMsg) end
		if OChUnits[8] then
			GUIEnemies.current_Cache1_8:SetText(_addonColor.."8 |r "..OChUnits[8].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[8].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[8].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[8].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[8].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[8].actualHealth)
		else GUIEnemies.current_Cache1_8:SetText(emptyMsg) end
		if OChUnits[9] then
			GUIEnemies.current_Cache1_9:SetText(_addonColor.."9 |r "..OChUnits[9].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[9].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[9].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[9].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[9].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[9].actualHealth)
		else GUIEnemies.current_Cache1_9:SetText(emptyMsg) end
		if OChUnits[10] then
			GUIEnemies.current_Cache1_10:SetText(_addonColor.."10 |r "..OChUnits[10].name.."\n |--> |cff0070DEGUID:|r "..OChUnits[10].key.."\n |--> |cff0070DEDistance:|r "..OChUnits[10].distance.."\n |--> |cff0070DEHealth:|r "..OChUnits[10].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChUnits[10].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChUnits[10].actualHealth)
		else GUIEnemies.current_Cache1_10:SetText(emptyMsg) end
		-- Friendly:
		if OChFriendly[1] then
			GUIFriendly.current_Cache2_1:SetText(_addonColor.."1: |r "..OChFriendly[1].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[1].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[1].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[1].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[1].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[1].actualHealth)
		else GUIFriendly.current_Cache2_1:SetText(emptyMsg) end
		if OChFriendly[2] then
			GUIFriendly.current_Cache2_2:SetText(_addonColor.."2: |r "..OChFriendly[2].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[2].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[2].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[2].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[2].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[2].actualHealth)
		else GUIFriendly.current_Cache2_2:SetText(emptyMsg) end
		if OChFriendly[3] then
			GUIFriendly.current_Cache2_3:SetText(_addonColor.."3: |r "..OChFriendly[3].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[3].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[3].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[3].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[3].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[3].actualHealth)
		else GUIFriendly.current_Cache2_3:SetText(emptyMsg) end
		if OChFriendly[4] then
			GUIFriendly.current_Cache2_4:SetText(_addonColor.."4: |r "..OChFriendly[4].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[4].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[4].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[4].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[4].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[4].actualHealth)
		else GUIFriendly.current_Cache2_4:SetText(emptyMsg) end
		if OChFriendly[5] then
			GUIFriendly.current_Cache2_5:SetText(_addonColor.."5: |r "..OChFriendly[5].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[5].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[5].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[5].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[5].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[5].actualHealth)
		else GUIFriendly.current_Cache2_5:SetText(emptyMsg) end
		if OChFriendly[6] then
			GUIFriendly.current_Cache2_6:SetText(_addonColor.."6: |r "..OChFriendly[6].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[6].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[6].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[6].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[6].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[6].actualHealth)
		else GUIFriendly.current_Cache2_6:SetText(emptyMsg) end
		if OChFriendly[7] then
			GUIFriendly.current_Cache2_7:SetText(_addonColor.."7: |r "..OChFriendly[7].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[7].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[7].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[7].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[7].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[7].actualHealth)
		else GUIFriendly.current_Cache2_7:SetText(emptyMsg) end
		if OChFriendly[8] then
			GUIFriendly.current_Cache2_8:SetText(_addonColor.."8: |r "..OChFriendly[8].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[8].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[8].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[8].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[8].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[8].actualHealth)
		else GUIFriendly.current_Cache2_8:SetText(emptyMsg) end
		if OChFriendly[9] then
			GUIFriendly.current_Cache2_9:SetText(_addonColor.."9: |r "..OChFriendly[9].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[9].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[9].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[9].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[9].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[9].actualHealth)
		else GUIFriendly.current_Cache2_9:SetText(emptyMsg) end
		if OChFriendly[10] then
			GUIFriendly.current_Cache2_10:SetText(_addonColor.."10: |r "..OChFriendly[10].name.."\n |--> |cff0070DEGUID:|r "..OChFriendly[10].key.."\n |--> |cff0070DEDistance:|r "..OChFriendly[10].distance.."\n |--> |cff0070DEHealth:|r "..OChFriendly[10].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..OChFriendly[10].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..OChFriendly[10].actualHealth)
		else GUIFriendly.current_Cache2_10:SetText(emptyMsg) end
	end
end

--[[
									TICKER
-------------------------------------------------------------------------------------------------------
]]
C_Timer.NewTicker(1, (function()
	
	OMGUI_Update()
	-- Wipe Cache
	wipe(OChUnits)
	wipe(OChFriendly)
	wipe(OChObjects)
	OChUnitsTotal = 0
	OChUnitsFriendlyTotal = 0
	OChObjectsTotal = 0
	-- Object Manager Core
	if NeP.Core.CurrentCR then
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			-- Master Toggle
			if NeP.Core.PeFetch("ObjectCache", "ObjectCache")  then
				-- If we're using FireHack...  
				if FireHack and NeP.Core.PeFetch("ObjectCache", "AC") then
					firehackOM()
				else -- Generic Cache
					genericOM()
				end
			end
		end
	end
end), nil)