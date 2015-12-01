--[[
Todo:
* Detect mines/herbs
* Move to object
* Count loot
* Clean up this shit...
]]

local PeFetch = NeP.Core.PeFetch
local LibDraw = LibStub("LibDraw-1.0")

local _Recording = false
local _Playing = false
local _filePath = 'Interface\\AddOns\\NerdPack\\GatheringProfiles'

local currentRoute = {} -- Temp route table.
local filesInDir = {{text = "No Files", key = 'nl'}} -- Our files.
local pX, pY, pZ = 0,0,0,0 -- This is to draw our end point
local wantedObject, wX, wY, wZ = nil, nil, nil, nil -- these are used to display circle in the wanted object.

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
				{ type = "checkbox", text = "Use random favorite mount", key = "favMount", default = true },
				-- Start Button
				{ type = "button", text = "Start", width = 190, height = 20, 
				callback = function(self) 
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
			{ type = "input", text = 'Profile Author:', width = 110,  key = 'authorInput', default = 'ImSoCoolz' },
			{ type = 'spacer' },
			{ type = "button", text = "Record Path", width = 190, height = 20, 
			callback = function(self)
				if FireHack then
					self:SetText("Start Recording")
					if _Recording then
						self:SetText("Stop Recording")
						-- Save the profile to file
						local fileLoc = _filePath..'\\'..currentRoute[1].Name..'.lua'
						local str = json.encode (currentRoute, { indent = true })
						WriteFile(fileLoc, str)
						wipe(currentRoute)
						-- We have to reload for our new file to show up...
							ReloadUI()
					else
						wipe(currentRoute)
						-- Add profile Info
						local weekday, month, day, year = CalendarGetDate()
						currentRoute[1] = {
							Name = PeFetch('GatherBot', 'nameInput'),
							Author = PeFetch('GatherBot', 'authorInput'),
							Date = 'D:'..day..' /M:'..month..' /Y:'..year,
							Zone = GetZoneText()
						}
						-- This is to draw our end point
						pX, pY, pZ = ObjectPosition('player')
					end
					_Recording = not _Recording
				end
			end },
    }
})

local function readProfile()
	if FireHack and PeFetch('GatherBot', 'gProfile') ~= nil then
		local fileLoc = _filePath..'\\'..PeFetch('GatherBot', 'gProfile')
		local str = ReadFile(fileLoc)
		local obj, pos, err = json.decode(str, 1, nil)
		if obj ~= nil then
			return obj
		end
	end
	-- Fail safe...
	return {[1] = {Name = '...', Author = '...', Zone = '...', Date = '...'}}
end

LibDraw.Sync(function()
	if FireHack then
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
			-- Draw our wantec object
			if wantedObject ~= nil then 
				local aX, aY, aZ = ObjectPosition('player')
				LibDraw.Line(aX, aY, aZ, wX, wY, wZ)
				LibDraw.Circle(wX, wY, wZ, 2) 
			end
		end
	end
end)

local function recordPath()
	if _Recording and not _Playing then
		local unitSpeed = GetUnitSpeed('player')
		if unitSpeed ~= 0 then
			local x, y, z = ObjectPosition('player')
			print('saved '..x..', '..y..', '..z)
			currentRoute[#currentRoute+1] = {
				x = x,
				y = y,
				z = z
			}
		end
	end
end

local function LoS(bX, bY, bZ)
	local losFlags =  bit.bor(HitFlags['M2Collision'], HitFlags['WMOCollision'])
	local aX, aY, aZ = ObjectPosition('player')
	return TraceLine(aX, aY, aZ+2.25, bX, bY, bZ+2.25, losFlags)
end

local function pathDistance(x, y, z)
	local aX, aY, aZ = ObjectPosition('player')
	return math.sqrt(((x-aX)^2) + ((y-aY)^2) + ((z-aZ)^2))
end

local function moveToLoc(x, y, z)
	if not LoS(x, y, z) then
		MoveTo(x, y, z)
	-- else -- (FIXME: TODO) Generate a path around the object hitting LoS
	end
end

-- Change this to allow profiles to specify what they want.
local function ObjectIsNear()
	if #NeP.OM.GameObjects > 0 then
		for i=1,#NeP.OM.GameObjects do
			local Obj = NeP.OM.GameObjects[i]
			if ObjectExists(Obj.key) then
				local x, y, z = ObjectPosition(Obj.key)
				local distance = Obj.distance
				if (Obj.is == 'Ore' or Obj.is == 'Herb') and distance < 50 then
					if distance >= 5 then
						-- Replace this with moveToLoc once tuned for moving around things
						MoveTo(x, y, z)
					else
						print('1: '..Obj.name..' / '..distance)
						ObjectInteract(Obj.key)
					end
					wantedObject, wX, wY, wZ = Obj.key, x, y, z
					--wipe(currentRoute)
					return true
				end
			end
		end
	end
	-- Nothing wanted
	wantedObject, wX, wY, wZ = nil, nil, nil, nil
	return false
end

local function playPath()
	if _Playing  then
		-- Make sure we're not recording.
		if _Recording then print('Cant while recording.') return end
		-- If we're in combat, stop and go kill it.
		if not InCombatLockdown() then
			-- Dont run if moving or casting.
			local unitSpeed = GetUnitSpeed('player')
			local casting = UnitCastingInfo("player")
			if unitSpeed == 0 and casting == nil then
				-- Get a random favorite mount.
				if not IsMounted() and PeFetch('GatherBot', 'favMount') then C_MountJournal.Summon(0); return end
				if not ObjectIsNear() then
					-- This takes the route and creates a infinite loop out of it.
					if #currentRoute >= 2 then
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
					else
						if FireHack then
							-- We have to create a temp table so we can remove once we've move there
							currentRoute = readProfile()
						end
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