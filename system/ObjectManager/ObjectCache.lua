NeP.OM = {
	unitEnemie = {},
	unitEnemieDead = {},
	unitFriend = {},
	unitFriendDead = {},
	GameObjects = {},
}

-- Local stuff to reduce global calls
local peConfig = NeP.Core.PeConfig
local UnitExists = UnitExists
local objectDistance = NeP.Core.Distance

--[[
	DESC: Checks if unit has a Blacklisted Debuff.
	This will remove the unit from the OM cache.
---------------------------------------------------]]
local NeP_ImmuneAuras = {
		-- CROWD CONTROL
	[118] = "",        -- Polymorph
	[1513] = "",       -- Scare Beast
	[1776] = "",       -- Gouge
	[2637] = "",       -- Hibernate
	[3355] = "",       -- Freezing Trap
	[6770] = "",       -- Sap
	[9484] = "",       -- Shackle Undead
	[19386] = "",      -- Wyvern Sting
	[20066] = "",      -- Repentance
	[28271] = "",      -- Polymorph (turtle)
	[28272] = "",      -- Polymorph (pig)
	[49203] = "",      -- Hungering Cold
	[51514] = "",      -- Hex
	[61025] = "",      -- Polymorph (serpent) -- FIXME: gone ?
	[61305] = "",      -- Polymorph (black cat)
	[61721] = "",      -- Polymorph (rabbit)
	[61780] = "",      -- Polymorph (turkey)
	[76780] = "",      -- Bind Elemental
	[82676] = "",      -- Ring of Frost
	[90337] = "",      -- Bad Manner (Monkey) -- FIXME: to check
	[115078] = "",     -- Paralysis
	[115268] = "",     -- Mesmerize
		-- MOP DUNGEONS/RAIDS/ELITES
	[106062] = "",     -- Water Bubble (Wise Mari)
	[110945] = "",     -- Charging Soul (Gu Cloudstrike)
	[116994] = "",     -- Unstable Energy (Elegon)
	[122540] = "",     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
	[123250] = "",     -- Protect (Lei Shi)
	[143574] = "",     -- Swelling Corruption (Immerseus)
	[143593] = "",     -- Defensive Stance (General Nazgrim)
		-- WOD DUNGEONS/RAIDS/ELITES
	[155176] = "",     -- Damage Shield (Primal Elementalists - Blast Furnace)
	[155185] = "",     -- Cotainment (Primal Elementalists - BRF)
	[155233] = "",     -- Dormant (Blast Furnace)
	[155265] = "",     -- Cotainment (Primal Elementalists - BRF)
	[155266] = "",     -- Cotainment (Primal Elementalists - BRF)
	[155267] = "",     -- Cotainment (Primal Elementalists - BRF)
	[157289] = "",     -- Arcane Protection (Imperator Mar'Gok)
	[174057] = "",     -- Arcane Protection (Imperator Mar'Gok)
	[182055] = "",     -- Full Charge (Iron Reaver)
	[184053] = "",     -- Fel Barrier (Socrethar)
}

local function BlacklistedDebuffs(Obj)
	for i = 1, 40 do
		local _,_,_,_,_,_,_,_,_,_, spellID = UnitDebuff(Obj, i)
		if NeP_ImmuneAuras[spellID] ~= nil then return true end
	end
end

--[[
	DESC: Checks if Object is a Blacklisted.
	This will remove the Object from the OM cache.
---------------------------------------------------]]
local BlacklistedObjects = {
	[76829] = "",		-- Slag Elemental (BrF - Blast Furnace)
	[78463] = "",		-- Slag Elemental (BrF - Blast Furnace)
	[60197] = "",		-- Scarlet Monastery Dummy
	[64446] = "",		-- Scarlet Monastery Dummy
	[93391] = "",		-- Captured Prisoner (HFC)
	[93392] = "",		-- Captured Prisoner (HFC)
	[93828] = "",		-- Training Dummy (HFC)
	[234021] = "",
	[234022] = "",
	[234023] = "",
}

local function BlacklistedObject(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj))
	if BlacklistedObjects[ObjID] ~= nil then return true end
end

local TrackGameObjects = {
	--[[ //// lumbermillIDs //// ]]
			--[[ //// WOD //// ]]
		[234127] = 'LM',
		[234193] = 'LM',
		[234023] = 'LM',
		[234099] = 'LM',
		[233634] = 'LM',
		[237727] = 'LM',
		[234126] = 'LM',
		[234111] = 'LM',
		[233922] = 'LM',
		[234128] = 'LM',
		[234000] = 'LM',
		[234195] = 'LM',
		[234196] = 'LM',
		[234097] = 'LM',
		[234198] = 'LM',
		[234197] = 'LM',
		[234123] = 'LM',
		[234098] = 'LM',
		[234022] = 'LM',
		[233604] = 'LM',
		[234120] = 'LM',
		[234194] = 'LM',
		[234021] = 'LM',
		[234080] = 'LM',
		[234110] = 'LM',
		[230964] = 'LM',
		[233635] = 'LM',
		[234119] = 'LM',
		[234122] = 'LM',
		[234007] = 'LM',
		[234199] = 'LM',
		[234124] = 'LM',
	--[[ //// oresIDs //// ]]
			--[[ //// WOD //// ]]
		[228510] = 'Ore', 		--[[ Rich True Iron Deposit ]]
		[228493] = 'Ore', 		--[[ True Iron Deposit ]]
		[228564] = 'Ore', 		--[[ Rich Blackrock Deposit ]]
		[228563] = 'Ore', 		--[[ Blackrock Deposit ]]
		[232544] = 'Ore', 		--[[ True Iron Deposit ]]
		[232545] = 'Ore', 		--[[ Rich True Iron Deposit ]]
		[232542] = 'Ore',		--[[ Blackrock Deposit ]]
		[232543] = 'Ore',		--[[ Rich Blackrock Deposit ]]
		[232541] = 'Ore',		--[[ Mine Cart ]]
	--[[ //// herbsIDs //// ]]
			--[[ //// WOD //// ]]
		[237400] = 'Herb',
		[228576] = 'Herb',
		[235391] = 'Herb',
		[237404] = 'Herb',
		[228574] = 'Herb',
		[235389] = 'Herb',
		[228575] = 'Herb',
		[237406] = 'Herb',
		[235390] = 'Herb',
		[235388] = 'Herb',
		[228573] = 'Herb',
		[237402] = 'Herb',
		[228571] = 'Herb',
		[237398] = 'Herb',
		[233117] = 'Herb',
		[235376] = 'Herb',
		[228991] = 'Herb',
		[235387] = 'Herb',
		[237396] = 'Herb',
		[228572] = "Herb",
	--[[ //// fishIDs //// ]]
			--[[ //// WOD //// ]]
		[229072] = 'Fish',
		[229073] = 'Fish',
		[229069] = 'Fish',
		[229068] = 'Fish',
		[243325] = 'Fish',
		[243354] = 'Fish',
		[229070] = 'Fish',
		[229067] = 'Fish',
		[236756] = 'Fish',
		[237295] = 'Fish',
		[229071] = 'Fish',
	--[[ //// dummyIDs //// ]]
		[31144] = "dummy",		-- Training Dummy - Lvl 80
		[31146] = "dummy",		-- Raider's Training Dummy - Lvl ??
		[32541] = "dummy", 		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
		[32542] = "dummy",		-- Disciple's Training Dummy - Lvl 65
		[32545] = "dummy",		-- Initiate's Training Dummy - Lvl 55
		[32546] = "dummy",		-- Ebon Knight's Training Dummy - Lvl 80
		[32666] = "dummy",		-- Training Dummy - Lvl 60
		[32667] = "dummy",		-- Training Dummy - Lvl 70
		[46647] = "dummy",		-- Training Dummy - Lvl 85
		[67127] = "dummy",		-- Training Dummy - Lvl 90
		[87318] = "dummy",		-- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
		[87761] = "dummy",		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
		[87322] = "dummy",		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
		[88314] = "dummy",		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
		[88836] = "dummy",		-- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
		[88288] = "dummy",		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
		[87317] = "dummy",		-- Dungeoneer's Training Dummy - Lvl 102 (Lunarfall - Damage)
		[87320] = "dummy",		-- Raider's Training Dummy - Lvl ?? (Stormshield - Damage)
		[87321] = "dummy",		-- Training Dummy - Lvl 100 (Stormshield, Warspear - Healing)
		[87329] = "dummy",		-- Raider's Training Dummy - Lvl ?? (Stormshield - Tank)
		[87762] = "dummy",		-- Raider's Training Dummy - Lvl ?? (Warspear - Damage)
		[88837] = "dummy",		-- Raider's Training Dummy - Lvl ?? (Warspear - Tank)
		[88906] = "dummy",		-- Combat Dummy - Lvl 100 (Nagrand)
		[88967] = "dummy",		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
		[89078] = "dummy",		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
}

local function isGameObject(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj))
	if TrackGameObjects[ObjID] ~= nil then
		return TrackGameObjects[ObjID], true
	end
	return 'nothing', false
end

--[[
	DESC: Places the object in its correct place.
	This is done in a seperate function so we dont have
	to repeate code over and over again for all unlockers.
---------------------------------------------------]]
local function addToOM(Obj, Dist)
	if not BlacklistedObject(Obj) then
		-- Game Object
		local _type, isGameObject = isGameObject(Obj)
		if isGameObject then
			NeP.OM.GameObjects[#NeP.OM.GameObjects+1] = {
				key = Obj, 
				distance = Dist, 
				health = 1, 
				maxHealth = 1, 
				actualHealth = 1, 
				name = UnitName(Obj),
				is = _type
			}
		-- Unit
		elseif ProbablyEngine.condition['alive'](Obj) then
			if not BlacklistedDebuffs(Obj) then
				-- Friendly
				if UnitIsFriend('player', Obj) then
					if NeP.Core.PeFetch('ObjectCache', 'FU') then
						NeP.OM.unitFriend[#NeP.OM.unitFriend+1] = {
							key = Obj, 
							distance = Dist, 
							health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
							maxHealth = UnitHealthMax(Obj), 
							actualHealth = UnitHealth(Obj), 
							name = UnitName(Obj),
							is = 'friendly'
						}
					end
				-- Enemie
				elseif UnitCanAttack('player', Obj) then
					if NeP.Core.PeFetch('ObjectCache', 'EU') then
						NeP.OM.unitEnemie[#NeP.OM.unitEnemie+1] = {
							key = Obj, 
							distance = Dist, 
							health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
							maxHealth = UnitHealthMax(Obj), 
							actualHealth = UnitHealth(Obj), 
							name = UnitName(Obj),
							is = 'enemie'
						}
					end
				end
			end
		-- Dead Units (For Ressing and Skills (Example: skining))
		elseif UnitIsDeadOrGhost(Obj) then
			-- Friendly
			if UnitIsFriend('player', Obj) then
				NeP.OM.unitFriend[#NeP.OM.unitFriendDead+1] = {
					key = Obj, 
					distance = Dist, 
					health = 0, 
					maxHealth = UnitHealthMax(Obj), 
					actualHealth = 0, 
					name = UnitName(Obj),
					is = 'friendly'
				}
			-- Enemie
			elseif UnitCanAttack('player', Obj) then
				NeP.OM.unitEnemie[#NeP.OM.unitEnemieDead+1] = {
					key = Obj, 
					distance = Dist, 
					health = 0, 
					maxHealth = UnitHealthMax(Obj), 
					actualHealth = 0, 
					name = UnitName(Obj),
					is = 'enemie'
				}
			end
		end
	end
end

local function NeP_FireHackOM()
	local totalObjects = ObjectCount()
	for i=1, totalObjects do
		local Obj = ObjectWithIndex(i)
		if ObjectExists(Obj) then
			if ObjectIsType(Obj, ObjectTypes.Unit) or ObjectIsType(Obj, ObjectTypes.GameObject) then
				local ObjDistance = objectDistance('player', Obj)
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(Obj, ObjDistance)
				end
			end
		end
	end
end

--[[
	Generic OM
---------------------------------------------------]]
local function GenericFilter(unit, objectDis)
	if UnitExists(unit) then
		local objectName = UnitName(unit)
		local alreadyExists = false
		-- Friendly Filter
		if UnitCanAttack('player', unit) then
			for i=1, #NeP.OM.unitEnemie do
				local object = NeP.OM.unitEnemie[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		-- Enemie Filter
		elseif UnitIsFriend('player', unit) then
			for i=1, #NeP.OM.unitFriend do
				local object = NeP.OM.unitFriend[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		end
		if not alreadyExists then return true end
	end
	return false
end

local function NeP_GenericOM()
	-- Self
	addToOM('player', 5)
	-- Mouseover
	if UnitExists('mouseover') then
		local object = 'mouseover'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object, ObjDistance)
			end
		end
	end
	-- Target Cache
	if UnitExists('target') then
		local object = 'target'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object, ObjDistance)
			end
		end
	end
	-- If in Group scan frames...
	if IsInGroup() or IsInRaid() then
		local prefix = (IsInRaid() and 'raid') or 'party'
		for i = 1, GetNumGroupMembers() do
			-- Enemie
			local target = prefix..i..'target'
			local ObjDistance = objectDistance('player', target)
			if GenericFilter(target, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(target, ObjDistance)
				end
			end
			-- Friendly
			local friendly = prefix..i
			local ObjDistance = objectDistance('player', friendly)
			if GenericFilter(friendly, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(friendly, ObjDistance)
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
	wipe(NeP.OM.unitEnemie)
	wipe(NeP.OM.unitEnemieDead)
	wipe(NeP.OM.unitFriend)
	wipe(NeP.OM.unitFriendDead)
	wipe(NeP.OM.GameObjects)

	if NeP.Core.CurrentCR and peConfig.read('button_states', 'MasterToggle', false) then
		-- Master Toggle
		if NeP.Core.PeFetch('ObjectCache', 'ObjectCache') then
			-- FireHack OM
			if FireHack then
				NeP_FireHackOM()
			-- Generic Cache
			else 
				NeP_GenericOM()
			end
		end
	end
	
	-- Sort by distance
	table.sort(NeP.OM.unitEnemie, function(a,b) return a.distance < b.distance end)
	table.sort(NeP.OM.unitEnemieDead, function(a,b) return a.distance < b.distance end)
	table.sort(NeP.OM.unitFriend, function(a,b) return a.distance < b.distance end)
	table.sort(NeP.OM.unitFriendDead, function(a,b) return a.distance < b.distance end)
	table.sort(NeP.OM.GameObjects, function(a,b) return a.distance < b.distance end)
	
end), nil)