NeP.ObjectManager = {
	unitCache = {},
	unitFriendlyCache = {},
	objectsCache = {},
}

local _addonColor = NeP.Addon.Interface.GuiTextColor
local _tittleGUI = NeP.Addon.Info.Icon..NeP.Addon.Info.Nick
local _GUIColor = NeP.Addon.Interface.GuiColor
local OChUnits = NeP.ObjectManager.unitCache
local OChFriendly = NeP.ObjectManager.unitFriendlyCache
local OChObjects = NeP.ObjectManager.objectsCache
local _UnitDistance = NeP.Core.Distance

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

local function UnitIsSpecial(unit)
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
	}
	local _,_,_,_,_,unitID = strsplit("-", UnitGUID(unit))
	for k,v in pairs(_forceTarget) do
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
	Generic OM
---------------------------------------------------]]
local function GenericFilter(unit)
	if UnitExists(unit) then
		if ProbablyEngine.condition["alive"](unit) then
			if not BlacklistedObject(unit) then
				if not BlacklistedDebuffs(unit) then
					if UnitCanAttack('player', unit) then
						for i=1,#NeP.ObjectManager.unitCache do
							local object = NeP.ObjectManager.unitCache[i]
							if object.health == math.floor((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
							and object.name == UnitName(unit) then
								return false
							end
						end
					elseif UnitIsFriend("player", unit) then
						for i=1,#NeP.ObjectManager.unitFriendlyCache do
							local object = NeP.ObjectManager.unitFriendlyCache[i]
							if object.health == math.floor((UnitHealth(unit) / UnitHealthMax(unit)) * 100)
							and object.name == UnitName(unit) then
								return false
							end
						end
						return true
					end
				end
			end
		end
	end
end

--[[
									TICKER
-------------------------------------------------------------------------------------------------------
]]
C_Timer.NewTicker(1, (function()

	-- Wipe Cache
	wipe(OChUnits)
	wipe(OChFriendly)
	wipe(OChObjects)
	
	-- Object Manager Core
	if NeP.Core.CurrentCR then
		--if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
			-- Master Toggle
			if NeP.Core.PeFetch("ObjectCache", "ObjectCache")  then
				-- If we're using FireHack...  
				if FireHack then
					local totalObjects = ObjectCount()
					for i=1, totalObjects do
						local Obj = ObjectWithIndex(i)
						if ObjectExists(Obj) then
							-- Objects OM
							if ObjectIsType(Obj, ObjectTypes.GameObject) then
								local _OD = _UnitDistance('player', Obj)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
									local guid = UnitGUID(Obj)
									local _, _, _, _, _, _id, _ = strsplit("-", guid)
									local ObID = tonumber(_id)
									-- Lumbermill
									if NeP.Core.PeFetch("NePconf_Overlays", "objectsLM") then
										for k,v in pairs(lumbermillIDs) do
											if ObID == v then
												OChObjects[#OChObjects+1] = {
													key=Obj, 
													distance=_OD, 
													id=ObID, 
													name = UnitName(Obj), 
													is='LM'
												}
											end
										end
									end	
									-- Ores
									if NeP.Core.PeFetch("NePconf_Overlays", "objectsOres") then
										for k,v in pairs(oresIDs) do
											if ObID == v then
												OChObjects[#OChObjects+1] = {
													key=Obj, 
													distance=_OD, 
													id=ObID, 
													name = UnitName(Obj), 
													is='Ore'
												}
											end
										end
									end
									-- Herbs
									if NeP.Core.PeFetch("NePconf_Overlays", "objectsHerbs") then
										for k,v in pairs(herbsIDs) do
											if ObID == v then
												OChObjects[#OChObjects+1] = {
													key=Obj, 
													distance=_OD, 
													id=ObID, 
													name = UnitName(Obj), 
													is='Herb'
												}
											end
										end
									end
									-- Fish
									if NeP.Core.PeFetch("NePconf_Overlays", "objectsFishs") then
										for k,v in pairs(fishIDs) do
											if ObID == v then
												OChObjects[#OChObjects+1] = {
													key=Obj, 
													distance=_OD, 
													id=ObID, 
													name = UnitName(Obj), 
													is='Fish'
												}
											end
										end
									end
								end
							-- Units OM
							elseif ObjectIsType(Obj, ObjectTypes.Unit) then
								local _OD = _UnitDistance('player', Obj)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then	
									if not BlacklistedObject(Obj) and ProbablyEngine.condition["alive"](Obj) then
										if not BlacklistedDebuffs(Obj) then
											-- Friendly Cache
											if UnitIsFriend("player", Obj) then
												-- Enabled on GUI
												if NeP.Core.PeFetch("ObjectCache", "FU") then
													OChFriendly[#OChFriendly+1] = {
														key=Obj, 
														distance=_OD, 
														health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
														maxHealth = UnitHealthMax(Obj),
														actualHealth = UnitHealth(Obj),
														name = UnitName(Obj),
													}
												end	
											-- INSERT DUMMYS!
											elseif UnitIsDummy(Obj) then
												if NeP.Core.PeFetch("ObjectCache", "dummys") then
													OChUnits[#OChUnits+1] = {
														key=Obj, 
														distance=_OD, 
														health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
														maxHealth = UnitHealthMax(Obj),
														actualHealth = UnitHealth(Obj),
														name = UnitName(Obj),
														dummy = true
													}
												end	
											-- Enemie Units
											elseif UnitCanAttack('player', Obj) then
												-- Enabled on GUI and unit affecting combat
												if NeP.Core.PeFetch("ObjectCache", "EU") then
													OChUnits[#OChUnits+1] = {
														key=Obj, 
														distance=_OD, 
														health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
														maxHealth = UnitHealthMax(Obj),
														actualHealth = UnitHealth(Obj),
														name = UnitName(Obj), 
														class = UnitClassification(Obj)
													}
												end
											end	
										end			
									end
								end
							end
						end
					end
				-- Generic Cache
				else 
					-- Self
					OChFriendly[#OChFriendly+1] = {
						key='Player', 
						distance=0, 
						health=math.floor((UnitHealth('player') / UnitHealthMax('player')) * 100), 
						maxHealth=UnitHealthMax('player'), 
						actualHealth=UnitHealth('player'), 
						name=UnitName('player')
					}
					-- If in Group scan frames...
					if IsInGroup() or IsInRaid() then
						local prefix = (IsInRaid() and 'raid') or 'party'
						for i = 1, GetNumGroupMembers() do
							-- Enemie
							local target = prefix..i.."target"
							if GenericFilter(target) then
								local _OD = _UnitDistance('player', object)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
									if NeP.Core.PeFetch("ObjectCache", "EU") then
										if UnitCanAttack('player', target) then
										
											OChUnits[#OChUnits+1] = {
												key=target, 
												distance=_OD, 
												health=math.floor((UnitHealth(target) / UnitHealthMax(target)) * 100), 
												maxHealth=UnitHealthMax(target), 
												actualHealth=UnitHealth(target), 
												name=UnitName(target)
											}
										end
									end
								end
							end
							-- Friendly
							local friendly = prefix..i
							if NeP.Core.PeFetch("ObjectCache", "FU") then
								if GenericFilter(target) then
									local _OD = _UnitDistance('player', object)
									if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
										OChFriendly[#OChFriendly+1] = {
											key=friendly, 
											distance=_OD, 
											health=math.floor((UnitHealth(friendly) / UnitHealthMax(friendly)) * 100), 
											maxHealth=UnitHealthMax(friendly), 
											actualHealth=UnitHealth(friendly), 
											name=UnitName(friendly)
										}
									end
								end
							end
						end
						-- Mouseover
						if UnitExists('mouseover') then
							local object = 'mouseover'
							if GenericFilter(object) then
								local _OD = _UnitDistance('player', object)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
									-- Friendly
									if UnitIsFriend("player", object) then
										if NeP.Core.PeFetch("ObjectCache", "FU") then
											OChFriendly[#OChFriendly+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object)
											}
										end
									-- Enemie
									elseif UnitCanAttack('player', object) then
										if NeP.Core.PeFetch("ObjectCache", "EU") then
											OChUnits[#OChUnits+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object)
											}
										end
									end
								end
							end
						end
					-- Solo Cache
					else
						-- Target
						if UnitExists('target') then
							local object = 'target'
							if GenericFilter(object) then
								local _OD = _UnitDistance('player', object)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
									-- Friendly
									if UnitIsFriend("player", object) then
										if NeP.Core.PeFetch("ObjectCache", "FU") then
											OChFriendly[#OChFriendly+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object)
											}
										end
									-- Enemie
									elseif UnitCanAttack('player', object) then
										if NeP.Core.PeFetch("ObjectCache", "EU") then
												OChUnits[#OChUnits+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object)
											}
										end
									end
								end
							end
						end
						-- Mouseover
						if UnitExists('mouseover') then
							local object = 'mouseover'
							if GenericFilter(object) then
								local _OD = _UnitDistance('player', object)
								if _OD <= (NeP.Core.PeFetch("ObjectCache", "CD") or 100) then
									-- Friendly
									if UnitIsFriend("player", object) then
										if NeP.Core.PeFetch("ObjectCache", "FU") then
											OChFriendly[#OChFriendly+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object)
											}
										end
									-- Enemie
									elseif UnitCanAttack('player', object) then
										if NeP.Core.PeFetch("ObjectCache", "EU") then
											OChUnits[#OChUnits+1] = {
												key=object, 
												distance=_OD, 
												health=math.floor((UnitHealth(object) / UnitHealthMax(object)) * 100), 
												maxHealth=UnitHealthMax(object), 
												actualHealth=UnitHealth(object), 
												name=UnitName(object),
											}
										end
									end
								end
							end
						end
					end
				end
			end
		--end
	end
	table.sort(OChUnits, function(a,b) return a.distance < b.distance end)
	table.sort(OChFriendly, function(a,b) return a.distance < b.distance end)
	table.sort(OChObjects, function(a,b) return a.distance < b.distance end)
end), nil)