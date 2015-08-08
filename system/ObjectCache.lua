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

--[[
											LOCAL TABLES
								This is were you insert units/object ID's 
									either to search or blacklist.
]]


--[[-----------------------------------------------
	ID's to display LM IDs
	Used for overlays.
---------------------------------------------------]]
local lumbermillIDs = {
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

--[[-----------------------------------------------
	ID's to display Ores IDs
	Used for overlays.
---------------------------------------------------]]
local oresIDs = {
	228510,
	228493,
	228564,
	228563,
	232544,
	232545,
	232542,
	232543,
	232541,
}

--[[-----------------------------------------------
	ID's to display Herbs IDs
	Used for overlays.
---------------------------------------------------]]
local herbsIDs = {
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

--[[-----------------------------------------------
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

--[[-----------------------------------------------
DESC: Checks if object is a Blacklisted.
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

--[[-----------------------------------------------
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
]]


--[[-----------------------------------------------
	FireHack OM
---------------------------------------------------]]
local firehackOM = function()
	local totalObjects = ObjectCount()
	
	for i=1, totalObjects do
		local object = ObjectWithIndex(i)
	
			if ObjectExists(object) then
				if ObjectIsType(object, ObjectTypes.GameObject) or ObjectIsType(object, ObjectTypes.Unit) then
					if not BlacklistedObject(object) then
									
					local ObjectName = UnitName(object)
					local objectDistance = NeP.Lib.Distance('player', object)
				
					if objectDistance <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
								
						-- Objects OM
						if ObjectIsType(object, ObjectTypes.GameObject) then

							local guid = UnitGUID(object)
							local objectType, _, _, _, _, _id, _ = strsplit("-", guid)
							local ObjectID = tonumber(_id)
		
							-- Lumbermill
							if NeP.Core.PeFetch("npconf_Overlays", "objectsLM") then
								for k,v in pairs(lumbermillIDs) do
									if ObjectID == v then
										NeP.ObjectManager.objectsCacheTotal = NeP.ObjectManager.objectsCacheTotal + 1
										table.insert(NeP.ObjectManager.objectsCache, {key=object, distance=objectDistance, id=ObjectID, name=ObjectName, is='LM'})
										table.sort(NeP.ObjectManager.objectsCache, function(a,b) return a.distance < b.distance end)
									end
								end
							end	
							-- Ores
							if NeP.Core.PeFetch("npconf_Overlays", "objectsOres") then
								for k,v in pairs(oresIDs) do
									if ObjectID == v then
										NeP.ObjectManager.objectsCacheTotal = NeP.ObjectManager.objectsCacheTotal + 1
										table.insert(NeP.ObjectManager.objectsCache, {key=object, distance=objectDistance, id=ObjectID, name=ObjectName, is='Ore'})
										table.sort(NeP.ObjectManager.objectsCache, function(a,b) return a.distance < b.distance end)
									end
								end
							end
							-- Herbs
							if NeP.Core.PeFetch("npconf_Overlays", "objectsHerbs") then
								for k,v in pairs(herbsIDs) do
									if ObjectID == v then
										NeP.ObjectManager.objectsCacheTotal = NeP.ObjectManager.objectsCacheTotal + 1
										table.insert(NeP.ObjectManager.objectsCache, {key=object, distance=objectDistance, id=ObjectID, name=ObjectName, is='Herb'})
										table.sort(NeP.ObjectManager.objectsCache, function(a,b) return a.distance < b.distance end)
									end
								end
							end
										
						-- Units OM
						elseif ObjectIsType(object, ObjectTypes.Unit) and ProbablyEngine.condition["alive"](object) then
							if not BlacklistedDebuffs(object) then
								
								local health = math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100)
								local maxHealth = UnitHealthMax(object)
								local actualHealth = UnitHealth(object)
												
								-- Friendly Cache
								if UnitIsFriend("player", object) then
									-- Enabled on GUI
									if NeP.Core.PeFetch("ObjectCache", "FU") then
										NeP.ObjectManager.unitCacheFriendlyTotal = NeP.ObjectManager.unitCacheFriendlyTotal + 1
										table.insert(NeP.ObjectManager.unitFriendlyCache, {key=object, distance=objectDistance, health=health, maxHealth=maxHealth, actualHealth=actualHealth, name=ObjectName})
										table.sort(NeP.ObjectManager.unitFriendlyCache, function(a,b) return a.distance < b.distance end)
									end	
								-- INSERT DUMMYS!
								elseif UnitIsDummy(object) then
									if NeP.Core.PeFetch("ObjectCache", "dummys") then
										NeP.ObjectManager.unitCacheTotal = NeP.ObjectManager.unitCacheTotal + 1
										table.insert(NeP.ObjectManager.unitCache, {key=object, distance=objectDistance, health=health, maxHealth=maxHealth, actualHealth=actualHealth, name=ObjectName})
										table.sort(NeP.ObjectManager.unitCache, function(a,b) return a.distance < b.distance end)
									end	
								-- Enemie Units
								else
									-- Enabled on GUI and unit affecting combat
									if NeP.Core.PeFetch("ObjectCache", "EU") then
										NeP.ObjectManager.unitCacheTotal = NeP.ObjectManager.unitCacheTotal + 1
										table.insert(NeP.ObjectManager.unitCache, {key=object, distance=objectDistance, health=health, maxHealth=maxHealth, actualHealth=actualHealth, name=ObjectName})
										table.sort(NeP.ObjectManager.unitCache, function(a,b) return a.distance < b.distance end)
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

--[[-----------------------------------------------
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
				if UnitExists(target) and not UnitIsFriend("player", target) then
					if UnitAffectingCombat(target) then
					local objectDistance = NeP.Lib.Distance('player', target)
						if objectDistance <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) and ProbablyEngine.condition["alive"](target) then
							NeP.ObjectManager.unitCacheTotal = NeP.ObjectManager.unitCacheTotal + 1
							table.insert(NeP.ObjectManager.unitCache, {key=target, distance=objectDistance, health=math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100), maxHealth=UnitHealthMax(target), actualHealth=UnitHealth(target), name=UnitName(target)})
							table.sort(NeP.ObjectManager.unitCache, function(a,b) return a.distance < b.distance end)
						end
					end
				end
			end
		end	
		-- Friendly
		for i = -1, GetNumGroupMembers() - 1 do
			local friendly = (i == 0 and 'player') or prefix .. i
			if NeP.Core.PeFetch("ObjectCache", "FU") then
				local objectDistance = NeP.Lib.Distance('player', friendly)
				if objectDistance <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) and ProbablyEngine.condition["alive"](friendly) then
					NeP.ObjectManager.unitCacheFriendlyTotal = NeP.ObjectManager.unitCacheFriendlyTotal + 1
					table.insert(NeP.ObjectManager.unitFriendlyCache, {key=friendly, distance=objectDistance, health=math.floor((UnitHealth(friendly) / UnitHealthMax(friendly)) * 100), maxHealth=UnitHealthMax(friendly), actualHealth=UnitHealth(friendly), name=UnitName(friendly)})
					table.sort(NeP.ObjectManager.unitFriendlyCache, function(a,b) return a.distance < b.distance end)
				end
			end
		end
	-- Solo Cache self and target
	else
		-- Self
		NeP.ObjectManager.unitCacheFriendlyTotal = NeP.ObjectManager.unitCacheFriendlyTotal + 1
		table.insert(NeP.ObjectManager.unitFriendlyCache, {key='Player', distance=0, health=math.floor((UnitHealth('player') / UnitHealthMax('player')) * 100), maxHealth=UnitHealthMax('player'), actualHealth=UnitHealth('player'), name=UnitName('player')})
		-- Target
		if UnitExists('target') and not UnitIsFriend("player", 'target') then
			if UnitAffectingCombat('target') then
				local objectDistance = NeP.Lib.Distance('player', 'target')
				if objectDistance <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) and ProbablyEngine.condition["alive"]('target') then
					NeP.ObjectManager.unitCacheTotal = NeP.ObjectManager.unitCacheTotal + 1
					table.insert(NeP.ObjectManager.unitCache, {key='target', distance=objectDistance, health=math.floor((UnitHealth('target') / UnitHealthMax('target')) * 100), maxHealth=UnitHealthMax('target'), actualHealth=UnitHealth('target'), name=UnitName('target')})
				end
			end
		end
		-- Mouseover
		if UnitExists('mouseover') and not UnitIsFriend("player", 'mouseover') then
			if UnitAffectingCombat('mouseover') then
				local objectDistance = NeP.Lib.Distance('player', 'mouseover')
				if objectDistance <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) and ProbablyEngine.condition["alive"]('mouseover') then
					NeP.ObjectManager.unitCacheTotal = NeP.ObjectManager.unitCacheTotal + 1
					table.insert(NeP.ObjectManager.unitCache, {key='mouseover', distance=objectDistance, health=math.floor((UnitHealth('mouseover') / UnitHealthMax('mouseover')) * 100), maxHealth=UnitHealthMax('mouseover'), actualHealth=UnitHealth('mouseover'), name=UnitName('mouseover')})
				end
			end
		end		
	end
end

--[[
											ObjectManager GUI
									This contains the code for the GUI.
]]


--[[-----------------------------------------------
	VARs
---------------------------------------------------]]
local emptyMsg = "" -- [[ Message to display when empty... ]]
local NeP_cacheWindow
local NeP_cacheWindowEmemies
local NeP_cacheWindowFriendly
local NeP_OpenCacheWindow = false
local NeP_ShowingCacheWindow = false
local NeP_cacheWindowUpdating = false

--[[-----------------------------------------------
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

--[[-----------------------------------------------
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

--[[-----------------------------------------------
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

--[[-----------------------------------------------
	Update GUIs function
	Needs to improve! (Cleaner)
---------------------------------------------------]]
local OMGUI_Update = function()
	-- Update GUI objects lists
	if NeP_cacheWindowUpdating then
		-- Totals:
		NeP_cacheWindow.elements.current_Cache1Total:SetText(_addonColor.."Total Enemies:|r "..NeP.ObjectManager.unitCacheTotal)
		NeP_cacheWindow.elements.current_Cache2Total:SetText(_addonColor.."Total Friendly:|r "..NeP.ObjectManager.unitCacheFriendlyTotal)
		NeP_cacheWindow.elements.current_Cache3Total:SetText(_addonColor.."Total GameObjects:|r "..NeP.ObjectManager.objectsCacheTotal)
		
		-- Enemies:
		if NeP.ObjectManager.unitCache[1] then
			NeP_cacheWindowEmemies.elements.current_Cache1_1:SetText(_addonColor.."1 |r "..NeP.ObjectManager.unitCache[1].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[1].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[1].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[1].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[1].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[1].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_1:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[2] then
			NeP_cacheWindowEmemies.elements.current_Cache1_2:SetText(_addonColor.."2 |r "..NeP.ObjectManager.unitCache[2].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[2].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[2].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[2].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[2].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[2].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_2:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[3] then
			NeP_cacheWindowEmemies.elements.current_Cache1_3:SetText(_addonColor.."3 |r "..NeP.ObjectManager.unitCache[3].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[3].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[3].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[3].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[3].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[3].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_3:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[4] then
			NeP_cacheWindowEmemies.elements.current_Cache1_4:SetText(_addonColor.."4 |r "..NeP.ObjectManager.unitCache[4].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[4].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[4].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[4].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[4].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[4].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_4:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[5] then
			NeP_cacheWindowEmemies.elements.current_Cache1_5:SetText(_addonColor.."5 |r "..NeP.ObjectManager.unitCache[5].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[5].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[5].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[5].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[5].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[5].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_5:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[6] then
			NeP_cacheWindowEmemies.elements.current_Cache1_6:SetText(_addonColor.."6 |r "..NeP.ObjectManager.unitCache[6].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[6].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[6].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[6].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[6].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[6].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_6:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[7] then
			NeP_cacheWindowEmemies.elements.current_Cache1_7:SetText(_addonColor.."7 |r "..NeP.ObjectManager.unitCache[7].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[7].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[7].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[7].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[7].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[7].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_7:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[8] then
			NeP_cacheWindowEmemies.elements.current_Cache1_8:SetText(_addonColor.."8 |r "..NeP.ObjectManager.unitCache[8].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[8].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[8].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[8].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[8].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[8].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_8:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[9] then
			NeP_cacheWindowEmemies.elements.current_Cache1_9:SetText(_addonColor.."9 |r "..NeP.ObjectManager.unitCache[9].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[9].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[9].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[9].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[9].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[9].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_9:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitCache[10] then
			NeP_cacheWindowEmemies.elements.current_Cache1_10:SetText(_addonColor.."10 |r "..NeP.ObjectManager.unitCache[10].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitCache[10].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitCache[10].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitCache[10].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitCache[10].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitCache[10].actualHealth)
		else
			NeP_cacheWindowEmemies.elements.current_Cache1_10:SetText(emptyMsg)
		end
		
		-- Friendly
		if NeP.ObjectManager.unitFriendlyCache[1] then
			NeP_cacheWindowFriendly.elements.current_Cache2_1:SetText(_addonColor.."1: |r "..NeP.ObjectManager.unitFriendlyCache[1].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[1].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[1].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[1].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[1].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[1].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_1:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[2] then
			NeP_cacheWindowFriendly.elements.current_Cache2_2:SetText(_addonColor.."2: |r "..NeP.ObjectManager.unitFriendlyCache[2].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[2].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[2].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[2].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[2].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[2].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_2:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[3] then
			NeP_cacheWindowFriendly.elements.current_Cache2_3:SetText(_addonColor.."3: |r "..NeP.ObjectManager.unitFriendlyCache[3].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[3].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[3].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[3].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[3].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[3].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_3:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[4] then
			NeP_cacheWindowFriendly.elements.current_Cache2_4:SetText(_addonColor.."4: |r "..NeP.ObjectManager.unitFriendlyCache[4].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[4].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[4].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[4].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[4].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[4].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_4:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[5] then
			NeP_cacheWindowFriendly.elements.current_Cache2_5:SetText(_addonColor.."5: |r "..NeP.ObjectManager.unitFriendlyCache[5].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[5].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[5].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[5].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[5].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[5].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_5:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[6] then
			NeP_cacheWindowFriendly.elements.current_Cache2_6:SetText(_addonColor.."6: |r "..NeP.ObjectManager.unitFriendlyCache[6].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[6].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[6].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[6].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[6].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[6].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_6:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[7] then
			NeP_cacheWindowFriendly.elements.current_Cache2_7:SetText(_addonColor.."7: |r "..NeP.ObjectManager.unitFriendlyCache[7].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[7].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[7].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[7].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[7].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[7].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_7:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[8] then
			NeP_cacheWindowFriendly.elements.current_Cache2_8:SetText(_addonColor.."8: |r "..NeP.ObjectManager.unitFriendlyCache[8].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[8].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[8].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[8].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[8].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[8].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_8:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[9] then
			NeP_cacheWindowFriendly.elements.current_Cache2_9:SetText(_addonColor.."9: |r "..NeP.ObjectManager.unitFriendlyCache[9].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[9].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[9].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[9].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[9].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[9].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_9:SetText(emptyMsg)
		end
		if NeP.ObjectManager.unitFriendlyCache[10] then
			NeP_cacheWindowFriendly.elements.current_Cache2_10:SetText(_addonColor.."10: |r "..NeP.ObjectManager.unitFriendlyCache[10].name.."\n |--> |cff0070DEGUID:|r "..NeP.ObjectManager.unitFriendlyCache[10].key.."\n |--> |cff0070DEDistance:|r "..NeP.ObjectManager.unitFriendlyCache[10].distance.."\n |--> |cff0070DEHealth:|r "..NeP.ObjectManager.unitFriendlyCache[10].health.."%".."\n |--> |cff0070DEMaxHealth:|r "..NeP.ObjectManager.unitFriendlyCache[10].maxHealth.."\n |--> |cff0070DEactualHealth:|r "..NeP.ObjectManager.unitFriendlyCache[10].actualHealth)
		else
			NeP_cacheWindowFriendly.elements.current_Cache2_10:SetText(emptyMsg)
		end
	end
end

--[[-----------------------------------------------
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
									TICKER
]]
C_Timer.NewTicker(1, (function()
	
	OMGUI_Update()
	
	-- Wipe Cache
	wipe(NeP.ObjectManager.unitCache)
	wipe(NeP.ObjectManager.unitFriendlyCache)
	wipe(NeP.ObjectManager.objectsCache)
	
	-- Wipe Counters
	NeP.ObjectManager.unitCacheTotal = 0
	NeP.ObjectManager.unitCacheFriendlyTotal = 0
	NeP.ObjectManager.objectsCacheTotal = 0
	
	-- Object Manager Core
	if NeP.Core.CurrentCR then
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			-- Master Toggle
			if NeP.Core.PeFetch("ObjectCache", "ObjectCache")  then
				-- If we're using FireHack...  
				if FireHack and NeP.Core.PeFetch("ObjectCache", "AC") then
					firehackOM()
				-- Generic Cache
				else
					genericOM()
				end
			end
		end
	end
end), nil)