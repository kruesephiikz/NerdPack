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
local currentPath = {} -- Temp for recording ( gets saved into a file and wiped )
local afTable = {} -- Temp for looping the selected route

local function readProfile()
	-- Requires a check if file exists
	local fileLoc = 'Interface\\AddOns\\NerdPack\\Gathering Profiles\\profile'..PeFetch('GatherBot', 'gProfile')..'.lua'
	local str = ReadFile(fileLoc)
	local obj, pos, err = json.decode(str, 1, nil)
	return obj
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
			{ type = "dropdown", text = "Profile:", key = "gProfile", width = 170, list = {
				{text = "1", key = 1},	
				{text = "2", key = 2},
				{text = "3", key = 3},
				{text = "4", key = 4},
				{text = "5", key = 5},
				{text = "6", key = 6},
				{text = "7", key = 7},
				{text = "8", key = 8},
				{text = "9", key = 9},
			}, default = 1 },
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
				-- Start Button
				{ type = "button", text = "Start", width = 190, height = 20, callback = function(self) 
				if not _Recording then
					if _Playing then
						self:SetText("Start")
					else
						-- Create a visual route
						if PeFetch('GatherBot', 'drawWay') then
							LibDraw.Sync(function()
								if _Playing then
									local obj = readProfile()
									for i=2,#obj-1 do
										LibDraw.Line(obj[i].x, obj[i].y, obj[i].z, obj[i+1].x, obj[i+1].y, obj[i+1].z)
									end		 
								end
							end)
						end
						LibDraw.clearCanvas()
						self:SetText("Stop")
					end
					wipe(afTable)
					_Playing = not _Playing
				end 
			end },
		-- Build Profile tools
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Create a profile:", size = 25, align = "Center"},
			{ type = 'spacer' },
			{ type = "input", text = 'Profile Name:', key = 'nameInput', default = '???' },
			{ type = "input", text = 'Profile Author:', key = 'authorInput', default = '???' },
			{ type = 'spacer' },
			{ type = "button", text = "Record Path", width = 190, height = 20, callback = function(self)
				if not _Playing then
					if _Recording then
						self:SetText("Start Recording")
						local fileLoc = 'Interface\\AddOns\\NerdPack\\Gathering Profiles\\profile'..PeFetch('GatherBot', 'gProfile')..'.lua'
						local str = json.encode (currentPath, { indent = true })
						WriteFile(fileLoc, str)
					else
						-- Add profile Info
						local weekday, month, day, year = CalendarGetDate()
						currentPath[1] = {
							Name = PeFetch('GatherBot', 'nameInput'),
							Author = PeFetch('GatherBot', 'authorInput'),
							Date = 'D:'..day..' /M:'..month..' /Y:'..year,
							Zone = GetZoneText()
						}
						-- Draw a end point
						local x, y, z = ObjectPosition('player')
						LibDraw.Sync(function()
							if _Recording then
								LibDraw.Text('END HERE!', "SystemFont_Tiny", x, y, z + 6)
								LibDraw.Circle(x, y, z, 2)				 
							end
						end)
						LibDraw.clearCanvas()
						self:SetText("Stop Recording")
					end
					wipe(currentPath)
					_Recording = not _Recording
				end
			end },
    }
})

local function recordPath()
	if _Recording and not _Playing then
		local x, y, z = ObjectPosition('player')
		print('saved '..x..', '..y..', '..z)
		currentPath[#currentPath+1] = {
			x = x,
			y = y,
			z = z
		}
	end
end

local function ObjectIsNear()
	-- not build yet...
	return false
end

local function playPath()
	if _Playing and not _Recording then
		-- If we're in combat, stop and go kill it.
		if not InCombatLockdown() then
			if not ObjectIsNear() then
				-- Make sure we have positions to move to. (Needs some tweaks...)
				local unitSpeed = GetUnitSpeed('player')
				if unitSpeed == 0 then
					-- This takes the route and creates a infinite loop out of it.
					if #afTable >= 2 then
						-- Figure out the nearest waypoint
						local aX, aY, aZ = ObjectPosition('player')
						local _rtable = {}
						for i=2,#afTable do
							local bX, bY, bZ = afTable[i].x, afTable[i].y, afTable[i].z
							local distance = math.sqrt(((bX-aX)^2) + ((bY-aY)^2) + ((bZ-aZ)^2))
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
						local _bX, _bY, _bZ = _rtable[1].x + math.random(-0.5, 0.5), _rtable[1].y + math.random(-0.5, 0.5), _rtable[1].z
						MoveTo(_bX, _bY, _bZ)
						-- Remove the used waypoint from our temp route
						table.remove(afTable, _rtable[1].id)
					else
						-- We have to create a temp table so we can remove once we've move there
						afTable = readProfile()
					end
				end
			else
				MoveTo(ObjectPosition(FIXME))
			end
		else
			if UnitExists('target') then
				MoveTo(ObjectPosition('target'))
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
	local obj = readProfile()
	if obj[1] ~= nil then
		gthGUI.elements.profileName:SetText(obj[1].Name)
		gthGUI.elements.profileAuthor:SetText(obj[1].Author)
		gthGUI.elements.profileZone:SetText(obj[1].Zone)
		gthGUI.elements.profileDate:SetText(obj[1].Date)
	end
end), nil)