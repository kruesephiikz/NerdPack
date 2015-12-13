--[[
Todo:
* Move objects hiting LoS
* Count loot
* Clean up this shit...
]]

local PeFetch = NeP.Core.PeFetch
local addonColor = '|cff'..NeP.Interface.addonColor
local LibDraw = LibStub("LibDraw-1.0")

local _Recording = false
local _Playing = false
local _filePath = 'Interface\\AddOns\\NerdPack\\GatheringProfiles'
local _mediaDir = NeP.Interface.mediaDir

local currentRoute = {} -- Temp route table.
local filesInDir = {{text = "No Files", key = 'nl'}} -- Our files.
local pX, pY, pZ = 0,0,0,0 -- This is to draw our end point
local wantedObject, wX, wY, wZ = nil, nil, nil, nil -- these are used to display circle in the wanted object.

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

-- Get our files in the dir.
if FireHack then
	wipe(filesInDir)
	for key,value in pairs({GetDirectoryFiles(_filePath..'\\*.lua')}) do
		filesInDir[#filesInDir+1] = {
			text = value, 
			key = value
		}
	end
end

local objLM = {
	--[[ //// WOD //// ]]
	[234127] = { is = 'LM', name = '???' },
	[234193] = { is = 'LM', name = '???' },
	[234023] = { is = 'LM', name = '???' },
	[234099] = { is = 'LM', name = '???' },
	[233634] = { is = 'LM', name = '???' },
	[237727] = { is = 'LM', name = '???' },
	[234126] = { is = 'LM', name = '???' },
	[234111] = { is = 'LM', name = '???' },
	[233922] = { is = 'LM', name = '???' },
	[234128] = { is = 'LM', name = '???' },
	[234000] = { is = 'LM', name = '???' },
	[234195] = { is = 'LM', name = '???' },
	[234196] = { is = 'LM', name = '???' },
	[234097] = { is = 'LM', name = '???' },
	[234198] = { is = 'LM', name = '???' },
	[234197] = { is = 'LM', name = '???' },
	[234123] = { is = 'LM', name = '???' },
	[234098] = { is = 'LM', name = '???' },
	[234022] = { is = 'LM', name = '???' },
	[233604] = { is = 'LM', name = '???' },
	[234120] = { is = 'LM', name = '???' },
	[234194] = { is = 'LM', name = '???' },
	[234021] = { is = 'LM', name = '???' },
	[234080] = { is = 'LM', name = '???' },
	[234110] = { is = 'LM', name = '???' },
	[230964] = { is = 'LM', name = '???' },
	[233635] = { is = 'LM', name = '???' },
	[234119] = { is = 'LM', name = '???' },
	[234122] = { is = 'LM', name = '???' },
	[234007] = { is = 'LM', name = '???' },
	[234199] = { is = 'LM', name = '???' },
	[234124] = { is = 'LM', name = '???' },
}

local objOre = {
	--[[ //// Classic //// ]]
	[1731] = { is = 'Ore', name = 'Copper Vein' },
	--[[ //// WOD //// ]]
	[228510] = { is = 'Ore', name = 'Rich True Iron Deposit' },
	[228493] = { is = 'Ore', name = 'True Iron Deposit' },
	[228564] = { is = 'Ore', name = 'Rich Blackrock Deposit' },
	[228563] = { is = 'Ore', name = 'Blackrock Deposit' },
	[232544] = { is = 'Ore', name = 'True Iron Deposit' },
	[232545] = { is = 'Ore', name = 'Rich True Iron Deposit' },
	[232542] = { is = 'Ore', name = 'Blackrock Deposit' },
	[232543] = { is = 'Ore', name = 'Rich Blackrock Deposit' },
	[232541] = { is = 'Ore', name = 'Mine Cart' },
}

local objHerb = {
	--[[ //// WOD //// ]]
	[237400] = { is = 'Herb', name = '???' },
	[228576] = { is = 'Herb', name = '???' },
	[235391] = { is = 'Herb', name = '???' },
	[237404] = { is = 'Herb', name = '???' },
	[228574] = { is = 'Herb', name = '???' },
	[235389] = { is = 'Herb', name = '???' },
	[228575] = { is = 'Herb', name = '???' },
	[237406] = { is = 'Herb', name = '???' },
	[235390] = { is = 'Herb', name = '???' },
	[235388] = { is = 'Herb', name = '???' },
	[228573] = { is = 'Herb', name = '???' },
	[237402] = { is = 'Herb', name = '???' },
	[228571] = { is = 'Herb', name = '???' },
	[237398] = { is = 'Herb', name = '???' },
	[233117] = { is = 'Herb', name = '???' },
	[235376] = { is = 'Herb', name = '???' },
	[228991] = { is = 'Herb', name = '???' },
	[235387] = { is = 'Herb', name = '???' },
	[237396] = { is = 'Herb', name = '???' },
	[228572] = { is = 'Herb', name = '???' },
}

local objFish = {
	--[[ //// WOD //// ]]
	[229072] = { is = 'Fish', name = '???' },
	[229073] = { is = 'Fish', name = '???' },
	[229069] = { is = 'Fish', name = '???' },
	[229068] = { is = 'Fish', name = '???' },
	[243325] = { is = 'Fish', name = '???' },
	[243354] = { is = 'Fish', name = '???' },
	[229070] = { is = 'Fish', name = '???' },
	[229067] = { is = 'Fish', name = '???' },
	[236756] = { is = 'Fish', name = '???' },
	[237295] = { is = 'Fish', name = '???' },
	[229071] = { is = 'Fish', name = '???' },
}

NeP.Core.BuildGUI('GatherBot', {
    key = "GatherBot",
    title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
    subtitle = "GatherBot Settings",
    color = NeP.Interface.addonColor,
    width = 210,
    height = 350,
    config = {
	    	-- Select Profile
			{ type = "dropdown", text = "Profile:", key = "gProfile", list = filesInDir, default = 'nl' },
			-- Profile Info
			{ type = 'spacer' },{ type = 'rule' },
			{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Profile Information:", size = 25, align = "Center"},
				-- Name
				{ type = "text", text = "|cff"..NeP.Interface.addonColor.."Profile Name: ", size = 11, offset = -11 },
				{ key = 'profileName', type = "text", text = "...", size = 11, align = "right", offset = 0 },
				-- Author
				{ type = "text", text = "|cff"..NeP.Interface.addonColor.."Profile Author: ", size = 11, offset = -11 },
				{ key = 'profileAuthor', type = "text", text = "...", size = 11, align = "right", offset = 0 },
				-- Date
				{ type = "text", text = "|cff"..NeP.Interface.addonColor.."Profile Date: ", size = 11, offset = -11 },
				{ key = 'profileDate', type = "text", text = "...", size = 11, align = "right", offset = 0 },
				-- Zone
				{ type = "text", text = "|cff"..NeP.Interface.addonColor.."Profile Zone: ", size = 11, offset = -11 },
				{ key = 'profileZone', type = "text", text = "...", size = 11, align = "right", offset = 0 },
			-- controls
			{ type = 'spacer' },
				-- Draw waypoint checkbox
				{ type = "checkbox", text = "Draw Waypoint", key = "drawWay", default = false },
				{ type = "checkbox", text = "Draw Objects", key = "drawObjs", default = true },
				{ type = "checkbox", text = "Use random favorite mount", key = "favMount", default = false },
				-- Start Button
				{ type = "button", text = "Start", width = 190, height = 20, 
				callback = function(self) 
					if _Recording then NeP.Core.Print('Cant while recording, please stop the bot.'); return end
					if FireHack then
						wipe(currentRoute)
						self:SetText("Start")
						_Playing = not _Playing
						if _Playing then
							self:SetText("Stop")
						end
					end
				end },
		-- Build Profile tools
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Create a profile:", size = 25, align = "Center"},
			{ type = 'spacer' },
			{ type = "input", text = 'Profile Name:', width = 110, key = 'nameInput', default = 'profile1' },
			{ type = "input", text = 'Profile Author:', width = 110, key = 'authorInput', default = 'ImSoCoolz' },
			{ type = "input", text = 'Gather ID:', width = 110, key = 'idInput', default = 'ores' },
			{ type = 'spacer' },
			{ type = "button", text = "Record Path", width = 190, height = 20, 
			callback = function(self)
				if FireHack then
					self:SetText("Start Recording")
					if _Playing then NeP.Core.Print('Cant while running, please stop the bot.'); return end
					if _Recording then
						-- Save the profile to file
						local fileLoc = _filePath..'\\'..currentRoute[1].Name..'.lua'
						local str = json.encode (currentRoute, { indent = true })
						WriteFile(fileLoc, str)
						-- We have to reload for our new file to show up...
						for i=1,#filesInDir+1 do
							if i == #filesInDir+1 then 
								wipe(currentRoute)
								ReloadUI()
							elseif filesInDir[i].key == currentRoute[1].Name..'.lua' then 
								wipe(currentRoute)
								break
							end
						end
					else
						self:SetText("Stop Recording")
						wipe(currentRoute)
						-- Add profile Info
						local weekday, month, day, year = CalendarGetDate()
						currentRoute[1] = {
							Name = PeFetch('GatherBot', 'nameInput'),
							Author = PeFetch('GatherBot', 'authorInput'),
							Date = 'D:'..day..' /M:'..month..' /Y:'..year,
							Zone = GetZoneText(),
							ids = {[PeFetch('GatherBot', 'idInput')]={Name = 'NAMEHERE'}}
						}
						-- This is to draw our end point
						pX, pY, pZ = ObjectPosition('player')
					end
					_Recording = not _Recording
				end
			end },
		-- Debug tools
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Debug Tools:", size = 25, align = "Center"},
			{ type = "checkbox", text = "Draw all object IDs:", key = "debugAllObjsIDs", default = false },
    }
})

local function readProfile()
	if FireHack and PeFetch('GatherBot', 'gProfile') ~= nil then
		local fileLoc = _filePath..'\\'..PeFetch('GatherBot', 'gProfile')
		local str = ReadFile(fileLoc)
		if str ~= nil then
			local obj, pos, err = json.decode(str, 1, nil)
			if obj ~= nil then
				return obj
			end
		end
	end
	-- Fail safe...
	return {[1] = {Name = '...', Author = '...', Zone = '...', Date = '...'}}
end

local function recordPath()
	if _Recording then
		local unitSpeed = GetUnitSpeed('player')
		if unitSpeed ~= 0 then
			local x, y, z = ObjectPosition('player')
			currentRoute[#currentRoute+1] = {
				x = x,
				y = y,
				z = z
			}
		end
	end
end

local function LoS(aX, aY, aZ, bX, bY, bZ)
	local losFlags =  bit.bor(HitFlags['M2Collision'], HitFlags['WMOCollision'])
	return TraceLine(aX, aY, aZ+2.25, bX, bY, bZ+2.25, losFlags)
end

local function pathDistance(x, y, z)
	local aX, aY, aZ = ObjectPosition('player')
	return round(math.sqrt(((x-aX)^2) + ((y-aY)^2) + ((z-aZ)^2)))
end

local function moveToLoc(x, y, z)
	local aX, aY, aZ = ObjectPosition('player')
	local bX, bY, bZ = x, y, z
	-- If nothing is in the way
	if not LoS(aX, aY, aZ, bX, bY, bZ) then
		MoveTo(bX, bY, bZ)
	--else
		-- FIXME: Generate a path around
	end
end

-- Change this to allow profiles to specify what they want.
local function SetWantedObj(Obj)
	local x, y, z = ObjectPosition(Obj)
	local distance = pathDistance(x, y, z)
	if distance < 50 then
		-- Draw a circle in the object we want
		wantedObject, wX, wY, wZ = Obj, x, y, z
		-- Move close enough
		if distance >= 6 then
			moveToLoc(x, y, z)
		else
			-- Stop and interact
			MoveTo(ObjectPosition('player'))
			ObjectInteract(Obj)
		end
	end
end

local function ObjectIsNear()
	local totalObjects = #NeP.OM.GameObjects
	for i=1, totalObjects do
		local Obj = totalObjects[i]
		if UnitGUID (Obj.key) ~= nil and ObjectExists(Obj.key) then
			local ObjID = Obj.id
			-- If the profile wants all known ores.
			if currentRoute[1].ids['ores'] then
				if objOre[tonumber(Obj.key)] then
					SetWantedObj(Obj.key)
					return true
				end
			-- If the profile wants all known herbs.
			elseif currentRoute[1].ids['herbs'] then
				if objHerb[tonumber(ObjID)] then
					SetWantedObj(Obj.key)
					return true
				end
			-- If the profile is looking for specific IDs.
			--[[FIXME:
			else
				for k=1,#currentRoute[1].ids do
					if currentRoute[k].ids[tonumber(ObjID)] ~= nil then
						SetWantedObj(Obj.key)
						return true
					end
				end]]
			end
		end
	end
	-- Nothing wanted
	wantedObject, wX, wY, wZ = nil, nil, nil, nil
	return false
end

local function playPath()
	if _Playing then
		-- If we're in combat, stop and go kill it.
		if not InCombatLockdown() then
			-- Dont run if moving or casting.
			local unitSpeed = GetUnitSpeed('player')
			local casting = UnitCastingInfo("player")
			if unitSpeed == 0 and casting == nil then
				-- Get a random favorite mount.
				if not IsMounted() and PeFetch('GatherBot', 'favMount') then C_MountJournal.Summon(0); return end
				-- This takes the route and creates a infinite loop out of it.
				if #currentRoute >= 2 then
					-- If a object is near, get it instead.
					if not ObjectIsNear() then
						-- Figure out the nearest waypoint
						local _rtable = {}
						for i=2,#currentRoute do
							local bX, bY, bZ = currentRoute[i].x, currentRoute[i].y, currentRoute[i].z
							local distance = pathDistance(bX, bY, bZ)
							_rtable[#_rtable+1] = {
								x = bX,
								y = bY,
								z = bZ,
								dis = distance,
								id = i
							}
						end
						table.sort(_rtable, function(a,b) return a.dis < b.dis end)
						-- Move to nearest waypoint
						if _rtable[1].dis >= 10 then
							local _bX, _bY, _bZ = _rtable[1].x + math.random(-0.5, 0.5), _rtable[1].y + math.random(-0.5, 0.5), _rtable[1].z
							moveToLoc(_bX, _bY, _bZ)
						end
						-- Remove the used waypoint from our temp route
						table.remove(currentRoute, _rtable[1].id)
					end
				else
					if FireHack then
						-- We have to create a temp table so we can remove once we've move there
						currentRoute = readProfile()
					end
				end
			end
		else
			if UnitExists('target') then
				-- Dismount if mounted
				if IsMounted() then Dismount() end
				-- Wipe our current path and generate another one
				wipe(currentRoute)
				moveToLoc(ObjectPosition('target'))
			end
		end
	end
end

-- Run functions
C_Timer.NewTicker(0.01, (function() playPath() end), nil)
C_Timer.NewTicker(0.5, (function() recordPath() end), nil)

-- Update GUI
local gthGUI = NeP.Core.getGUI('GatherBot')
C_Timer.NewTicker(1, (function()
	if gthGUI.parent:IsShown() and FireHack then
		local obj = readProfile()
		gthGUI.elements.profileName:SetText(obj[1].Name)
		gthGUI.elements.profileAuthor:SetText(obj[1].Author)
		gthGUI.elements.profileZone:SetText(obj[1].Zone)
		gthGUI.elements.profileDate:SetText(obj[1].Date)
	end
end), nil)

local Textures = {
	-- LM
	["lumbermill"] = { texture = _mediaDir.."mill.blp", width = 64, height = 64 },
	["lumbermill_big"] = { texture = _mediaDir.."mill.blp", width = 58, height = 58, scale = 1 },
	["lumbermill_small"] = { texture = _mediaDir.."mill.blp", width = 18, height = 18, scale = 1 },
	-- Ore
	["ore"] = { texture = _mediaDir.."ore.blp", width = 64, height = 64 },
	["ore_big"] = { texture = _mediaDir.."ore.blp", width = 58, height = 58, scale = 1 },
	["ore_small"] = { texture = _mediaDir.."ore.blp", width = 18, height = 18, scale = 1 },
	-- Herb
	["herb"] = { texture = _mediaDir.."herb.blp", width = 64, height = 64 },
	["herb_big"] = { texture = _mediaDir.."herb.blp", width = 58, height = 58, scale = 1 },
	["herb_small"] = { texture = _mediaDir.."herb.blp", width = 18, height = 18, scale = 1 },
	-- Fish
	["fish"] = { texture = _mediaDir.."fish.blp", width = 64, height = 64 },
	["fish_big"] = { texture = _mediaDir.."fish.blp", width = 58, height = 58, scale = 1 },
	["fish_small"] = { texture = _mediaDir.."fish.blp", width = 18, height = 18, scale = 1 },
}

local function drawObj(Obj, oX, oY, oZ, distance)
	if distance < 50 then
		LibDraw.Texture(Textures[Obj.."_big"], oX, oY, oZ + 3, 1)
	elseif distance > 200 then
		LibDraw.Texture(Textures[Obj.."_small"], oX, oY, oZ + 3, 1)
	else
		LibDraw.Texture(Textures[Obj], oX, oY, oZ + 3, 1)
	end
end

LibDraw.Sync(function()
	if gthGUI.parent:IsShown() and FireHack then
		
		-- Set line style
		LibDraw.SetColorRaw(1, 1, 1, alpha)
		
		-- draw Objects (Ores/Herbs/LM)
		if PeFetch('GatherBot', 'drawObjs') then
			local totalObjects = #NeP.OM.GameObjects
			for i=1, #totalObjects do
				local Obj = totalObjects[i]
				if UnitGUID(Obj.key) ~= nil and ObjectExists(Obj.key) then
						local oX, oY, oZ = ObjectPosition(Obj.key)
						local distance = NeP.Core.Round(Obj.distance)
						local name = Obj.name
						local ID = Obj.id
						local _text = addonColor..name.."|r\n"..distance..' yards'
						-- Debug
						if PeFetch('GatherBot', 'debugAllObjsIDs') then
							LibDraw.Text(addonColor..name..'|r ID:'..ID..'\n Distance: '..distance, "SystemFont_Tiny", oX, oY, oZ+1)
						end
						-- Lumbermill
						if objLM[ID] ~= nil then
							drawObj('lumbermill', oX, oY, oZ, distance)
							LibDraw.Text(_text, "SystemFont_Tiny", oX, oY, oZ+1)
						-- Ores
						elseif objOre[ID] ~= nil then
							drawObj('ore', oX, oY, oZ, distance)
							LibDraw.Text(_text, "SystemFont_Tiny", oX, oY, oZ+1)
						-- Herbs
						elseif objHerb[ID] ~= nil then
							drawObj('herb', oX, oY, oZ, distance)
							LibDraw.Text(_text, "SystemFont_Tiny", oX, oY, oZ+1)
						-- Fish Poles
						elseif objFish[ID] ~= nil then
							drawObj('fish', oX, oY, oZ, distance)
							LibDraw.Text(_text, "SystemFont_Tiny", oX, oY, oZ+1)
						end
				end
			end
		end

		-- Set line style
		LibDraw.SetColorRaw(1.0, 0.96, 0.41, 0.50)
		LibDraw.SetWidth(10)

		-- Draw a end point
		if _Recording then
			LibDraw.Text('END HERE!', "SystemFont_Tiny", pX, pY, pZ + 6)
			LibDraw.Circle(pX, pY, pZ, 2)				 
		end

		-- Create a visual route
		if PeFetch('GatherBot', 'drawWay') then
			-- Draw our route
			for i=2,#currentRoute-1 do
				local aX, aY, aZ = currentRoute[i].x, currentRoute[i].y, currentRoute[i].z
				local bX, bY, bZ = currentRoute[i+1].x, currentRoute[i+1].y, currentRoute[i+1].z
				LibDraw.Line(aX, aY, aZ, bX, bY, bZ)	 
			end
			-- Draw our wanted object
			if wantedObject ~= nil then 
				local aX, aY, aZ = ObjectPosition('player')
				LibDraw.Line(aX, aY, aZ, wX, wY, wZ)
				LibDraw.Circle(wX, wY, wZ, 2) 
			end
		end

	end
end)