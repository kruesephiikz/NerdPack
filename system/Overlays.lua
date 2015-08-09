local LibDraw = LibStub("LibDraw-1.0")

local _mediaDir = NeP.Addon.Interface.mediaDir
local alpha = 100
local zOffset = 3
local _addonColor = NeP.Addon.Interface.GuiTextColor

local basicMarker = {
	{ 0.1, 0, 0, -0.1, 0, 0},
	{ 0, 0.1, 0, 0, -0.1, 0},
	{ 0, 0, -0.1, 0, 0, 0.1}
}

local lumbermill = {
	texture = _mediaDir.."mill.blp",
	width = 64, height = 64
}
local lumbermill_big = {
	texture = _mediaDir.."mill.blp",
	width = 58, height = 58, scale = 1
}
local lumbermill_small = {
	texture = _mediaDir.."mill.blp",
	width = 18, height = 18, scale = 1
}

local ore = {
	texture = _mediaDir.."ore.blp",
	width = 64, height = 64
}
local ore_big = {
	texture = _mediaDir.."ore.blp",
	width = 58, height = 58, scale = 1
}
local ore_small = {
	texture = _mediaDir.."ore.blp",
	width = 18, height = 18, scale = 1
}

local herb = {
	texture = _mediaDir.."herb.blp",
	width = 64, height = 64
}
local herb_big = {
	texture = _mediaDir.."herb.blp",
	width = 58, height = 58, scale = 1
}
local herb_small = {
	texture = _mediaDir.."herb.blp",
	width = 18, height = 18, scale = 1
}

local fish = {
	texture = _mediaDir.."fish.blp",
	width = 64, height = 64
}
local fish_big = {
	texture = _mediaDir.."fish.blp",
	width = 58, height = 58, scale = 1
}
local fish_small = {
	texture = _mediaDir.."fish.blp",
	width = 18, height = 18, scale = 1
}

local rare = {
	texture = _mediaDir.."elite.blp",
	width = 64, height = 64
}
local rare_big = {
	texture = _mediaDir.."elite.blp",
	width = 58, height = 58, scale = 1
}
local rare_small = {
	texture = _mediaDir.."elite.blp",
	width = 18, height = 18, scale = 1
}

local mob = {
	texture = _mediaDir.."mob.blp",
	width = 64, height = 64
}
local mob_big = {
	texture = _mediaDir.."mob.blp",
	width = 58, height = 58, scale = 1
}
local mob_small = {
	texture = _mediaDir.."mob.blp",
	width = 18, height = 18, scale = 1
}

local unit = {
	texture = _mediaDir.."player.blp",
	width = 64, height = 64
}
local unit_big = {
	texture = _mediaDir.."player.blp",
	width = 58, height = 58, scale = 1
}
local unit_small = {
	texture = _mediaDir.."player.blp",
	width = 18, height = 18, scale = 1
}

local horde = {
	texture = _mediaDir.."horde.blp",
	width = 64, height = 64
}
local horde_big = {
	texture = _mediaDir.."horde.blp",
	width = 58, height = 58, scale = 1
}
local horde_small = {
	texture = _mediaDir.."horde.blp",
	width = 18, height = 18, scale = 1
}

local ally = {
	texture = _mediaDir.."alliance.blp",
	width = 64, height = 64
}
local ally_big = {
	texture = _mediaDir.."alliance.blp",
	width = 58, height = 58, scale = 1
}
local ally_small = {
	texture = _mediaDir.."alliance.blp",
	width = 18, height = 18, scale = 1
}

LibDraw.Sync(function()
	if NeP.Core.CurrentCR and FireHack then
		-- Reset
		LibDraw.clearCanvas()

		local playerX, playerY, playerZ = ObjectPosition('player')
		local cx, cy, cz = GetCameraPosition()

		if UnitExists('target') then
			local targetX, targetY, targetZ = ObjectPosition("target")
			local distance = NeP.Lib.Distance('player', 'target')
			local name = UnitName("target")
			local playerRotation = ObjectFacing("player")
			local targetRotation = ObjectFacing("target")
			LibDraw.SetWidth(2)
			-- Target Line
			if NeP.Core.PeFetch("NePconf_Overlays", "TargetLine") then
				LibDraw.SetColorRaw(1, 1, 1, alpha)
				LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", targetX, targetY, targetZ + 6)
				LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
			end
			-- Player Infront Cone
			if NeP.Core.PeFetch("NePconf_Overlays", "PlayerInfrontCone") then
				if NeP.Lib.Infront('target') then
					LibDraw.SetColor(101, 255, 87, 70)
				else
					LibDraw.SetColor(255, 87, 87, 70)
				end
				LibDraw.Arc(playerX, playerY, playerZ, 10, 180, playerRotation)
			end
			-- Player Melee Range
			if NeP.Core.PeFetch("NePconf_Overlays", "PlayerMRange") then
				if NeP.Lib.Distance('player', 'target') <= 5 then
					LibDraw.SetColor(101, 255, 87, 70)
				else
					LibDraw.SetColor(255, 87, 87, 70)
				end
				LibDraw.Circle(playerX, playerY, playerZ, 5)
			end
			-- Player Caster Range
			if NeP.Core.PeFetch("NePconf_Overlays", "PlayerCRange") then
				if NeP.Lib.Distance('player', 'target') <= 40 then
					LibDraw.SetColor(101, 255, 87, 50)
				else
					LibDraw.SetColor(255, 87, 87, 50)
				end
				LibDraw.Circle(playerX, playerY, playerZ, 45)
			end
			-- Target Infront Cone
			if NeP.Core.PeFetch("NePconf_Overlays", "TargetCone") then
				LibDraw.SetColorRaw(1, 1, 1, alpha)
				LibDraw.Arc(targetX, targetY, targetZ, 10, 180, targetRotation)
			end
			-- Target Melee Range
			if NeP.Core.PeFetch("NePconf_Overlays", "TargetMRange") then
				if NeP.Lib.Distance('player', 'target') <= 5 then
					LibDraw.SetColor(101, 255, 87, 70)
				else
					LibDraw.SetColor(255, 87, 87, 70)
				end
				LibDraw.Circle(targetX, targetY, targetZ, 5)
			end
			-- Target Caster Range
			if NeP.Core.PeFetch("NePconf_Overlays", "TargetCRange") then
				if NeP.Lib.Distance('player', 'target') <= 40 then
					LibDraw.SetColor(101, 255, 87, 50)
				else
					LibDraw.SetColor(255, 87, 87, 50)
				end
				LibDraw.Circle(targetX, targetY, targetZ, 45)
			end
		end	
		-- Objects (Ores/Herbs/LM)
		for i=1,#NeP.ObjectManager.objectsCache do
			local object = NeP.ObjectManager.objectsCache[i]
			if ObjectExists(object.key) then
				local distance = object.distance
				local ox, oy, oz = ObjectPosition(object.key)
				local name = object.name
				local id = object.is

				-- Lumbermill
				if id == 'LM' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsLM") then
						if distance < 50 then
							LibDraw.Texture(lumbermill_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(lumbermill_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(lumbermill, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				-- Ores
				elseif id == 'Ore' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsOres") then
						if distance < 50 then
							LibDraw.Texture(ore_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(ore_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(ore, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				-- Herbs
				elseif id == 'Herb' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsHerbs") then
						if distance < 50 then
							LibDraw.Texture(herb_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(herb_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(herb, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				-- Fish Poles
				elseif id == 'Fish' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsFishs") then
						local ox, oy, oz = ObjectPosition(object)
						if distance < 50 then
							LibDraw.Texture(fish_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(fish_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(fish, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				end
			end
		end
		-- Enemie Units
		for i=1,#NeP.ObjectManager.unitCache do
			local object = NeP.ObjectManager.unitCache[i]
			if ObjectExists(object.key) then
				local distance = object.distance
				local ox, oy, oz = ObjectPosition(object.key)
				local name = object.name
				local _class = object.class
				-- Elites
				if _class == 'elite' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsElite") then
						if distance < 50 then
							LibDraw.Texture(mob_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(mob_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(mob, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				-- WorldBoss
				elseif _class == 'worldboss' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsWorldBoss") then
						if distance < 50 then
							LibDraw.Texture(mob_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(mob_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(mob, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				-- Rares
				elseif _class == 'rareelite' then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsRares") then
						if distance < 50 then
							LibDraw.Texture(mob_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(mob_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(mob, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
				end
			end
		end
		-- Friendly Units
		for i=1,#NeP.ObjectManager.unitFriendlyCache do
			local object = NeP.ObjectManager.unitFriendlyCache[i]
				if ObjectExists(object.key) then
				local distance = object.distance
				local ox, oy, oz = ObjectPosition(object.key)
				local name = object.name
				local _class = object.class
				-- Players
				if UnitIsPlayer(object.key) then
					if NeP.Core.PeFetch("NePconf_Overlays", "objectsPlayers") then
						if name ~= UnitName('player') then
							local factionGroup, factionName = UnitFactionGroup(object.key)
							if factionGroup == 'Horde' then
								if distance < 50 then
									LibDraw.Texture(horde_big, ox, oy, oz + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(horde_small, ox, oy, oz + zOffset, alpha)
								else
									LibDraw.Texture(horde, ox, oy, oz + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
							elseif factionGroup == 'Alliance' then
								if distance < 50 then
									LibDraw.Texture(ally_big, ox, oy, oz + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(ally_small, ox, oy, oz + zOffset, alpha)
								else
									LibDraw.Texture(ally, ox, oy, oz + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
							end
						end
					end
				end
			end
		end
	end
end)


local NeP_OverlaysGUI
local NeP_OverlaysGUI_Open = false
local NeP_OverlaysGUI_Showing = false

NeP.Addon.Interface.Overlays = {
	key = "NePconf_Overlays",
	profiles = true,
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Name,
	subtitle = "Overlays Settings",
	color = NeP.Addon.Interface.GuiColor,
	width = 250,
	height = 500,
	config = {
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Overlays:", size = 25, align = "Center" },
			{ type = "text", text = "Only Works with FireHack ATM!", size = 11, offset = 0, align = "center" },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Player Overlays:", size = 25, align = "Center" },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Display Player Melee Range", key = "PlayerMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "PlayerCRange", default = false },
			{ type = "checkbox", text = "Display Target Line", key = "TargetLine", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "PlayerInfrontCone", default = false },
		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Target Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Player Melee Range", key = "TargetMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "TargetCRange", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "TargetCone", default = false },
		{ type = 'rule' },
		{ type = 'spacer' },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Objects Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Herb Objects", key = "objectsHerbs", default = false },
			{ type = "checkbox", text = "Display Ore Objects", key = "objectsOres", default = false },
			{ type = "checkbox", text = "Display Lumbermill Objects", key = "objectsLM", default = false },
			{ type = "checkbox", text = "Display Fish Objects", key = "objectsFish", default = false },
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Units Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Player Units", key = "objectsPlayers", default = false },
			{ type = "checkbox", text = "Display Rare Units", key = "objectsRares", default = false },
			{ type = "checkbox", text = "Display WorldBoss Units", key = "objectsWorldBoss", default = false },
			{ type = "checkbox", text = "Display Elite Units", key = "objectsElite", default = false },
	}
}

function NeP.Addon.Interface.OverlaysGUI()
	-- If a frame has not been created, create one...
	if not NeP_OverlaysGUI_Open then
		NeP_OverlaysGUI = NeP.Core.PeBuildGUI(NeP.Addon.Interface.Overlays)
		
		-- This is so the window isn't opened twice :D
		NeP_OverlaysGUI_Open = true
		NeP_OverlaysGUI_Showing = true
		NeP_OverlaysGUI.parent:SetEventListener('OnClose', function()
			NeP_OverlaysGUI_Open = false
			NeP_OverlaysGUI_Showing = false
			end)

	-- If a frame has been created and its showing, hide it.
	elseif NeP_OverlaysGUI_Open == true and NeP_OverlaysGUI_Showing == true then
		NeP_OverlaysGUI.parent:Hide()
		NeP_OverlaysGUI_Showing = false

	-- If a frame has been created and its hiding, show it.
	elseif NeP_OverlaysGUI_Open == true and NeP_OverlaysGUI_Showing == false then
		NeP_OverlaysGUI.parent:Show()
		NeP_OverlaysGUI_Showing = true
	end
	
end