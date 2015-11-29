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
local currentPath = {}

local function getRoute()
	local fileLoc = 'Interface\\AddOns\\NerdPack\\Gathering Profiles\\profile'..PeFetch('GatherBot', 'gProfile')..'.lua'
	-- Requires a check if file exists
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
				-- Start Button
				{ type = 'spacer' },
				{ type = "button", text = "Start", width = 190, height = 20, callback = function(self) 
				if not _Recording then
					if _Playing then
						self:SetText("Start")
					else
						-- Create a visual route
						LibDraw.Sync(function()
							if _Playing then
								local obj = getRoute()
								for i=2,#obj-1 do
									LibDraw.Line(obj[i].x, obj[i].y, obj[i].z, obj[i+1].x, obj[i+1].y, obj[i+1].z)
								end
							else
								 LibDraw.clearCanvas()
							end
						end)
						self:SetText("Stop")
					end
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
						wipe(currentPath)
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
							else
								 LibDraw.clearCanvas()
							end
						end)
						self:SetText("Stop Recording")
					end
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

local afTable = {}
local function playPath()
	if _Playing and not _Recording then
		-- This takes the router and creates a infinite loop out of it.
		if #afTable <= 1 then afTable = getRoute() end
		local unitSpeed = GetUnitSpeed('player')
		-- If we're in combat, stop and go kill it.
		if not InCombatLockdown() then
			if not ObjectIsNear() then
				-- Make sure we have positions to move to.
				-- Need some tweaks...
				if unitSpeed == 0 and #afTable >= 2 then
					MoveTo(afTable[2].x, afTable[2].y, afTable[2].z)
					table.remove(afTable, 2)
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
	local obj = getRoute()
	if obj[1] ~= nil then
		gthGUI.elements.profileName:SetText(obj[1].Name)
		gthGUI.elements.profileAuthor:SetText(obj[1].Author)
		gthGUI.elements.profileZone:SetText(obj[1].Zone)
		gthGUI.elements.profileDate:SetText(obj[1].Date)
	end
end), nil)