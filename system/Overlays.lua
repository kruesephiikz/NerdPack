local LibDraw = LibStub("LibDraw-1.0")

local _mediaDir = NeP.Interface.mediaDir
local alpha = 100
local zOffset = 3
local _addonColor = '|cff'..NeP.Interface.addonColor

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
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then

			local playerX, playerY, playerZ = ObjectPosition('player')
			--local cx, cy, cz = GetCameraPosition()

			if UnitExists('target') then
				local targetX, targetY, targetZ = ObjectPosition("target")
				local distance = NeP.Core.Distance('player', 'target')
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
					if NeP.Core.Infront('player', 'target') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Arc(playerX, playerY, playerZ, 10, 180, playerRotation)
				end
				-- Player Melee Range
				if NeP.Core.PeFetch("NePconf_Overlays", "PlayerMRange") then
					if NeP.Core.Distance('player', 'target') <= NeP.Lib.getUnitRange('target', 'melee') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(playerX, playerY, playerZ, NeP.Lib.getUnitRange('target', 'melee'))
				end
				-- Player Caster Range
				if NeP.Core.PeFetch("NePconf_Overlays", "PlayerCRange") then
					if NeP.Core.Distance('player', 'target') <= NeP.Lib.getUnitRange('target', 'ranged') then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(playerX, playerY, playerZ, NeP.Lib.getUnitRange('target', 'ranged'))
				end
				-- Target Infront Cone
				if NeP.Core.PeFetch("NePconf_Overlays", "TargetCone") then
					LibDraw.SetColorRaw(1, 1, 1, alpha)
					LibDraw.Arc(targetX, targetY, targetZ, 10, 180, targetRotation)
				end
				-- Target Melee Range
				if NeP.Core.PeFetch("NePconf_Overlays", "TargetMRange") then
					if NeP.Core.Distance('player', 'target') <= NeP.Lib.getUnitRange('target', 'melee') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(targetX, targetY, targetZ, NeP.Lib.getUnitRange('target', 'melee'))
				end
				-- Target Caster Range
				if NeP.Core.PeFetch("NePconf_Overlays", "TargetCRange") then
					if NeP.Core.Distance('player', 'target') <= NeP.Lib.getUnitRange('target', 'ranged') then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(targetX, targetY, targetZ, NeP.Lib.getUnitRange('target', 'ranged'))
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
					elseif UnitIsPlayer(object.key) then
						if NeP.Core.PeFetch("NePconf_Overlays", "objectsEnemiePlayers") then
							local factionGroup, factionName = UnitFactionGroup(object.key)
							if factionGroup == 'Alliance' then
								if distance < 50 then
									LibDraw.Texture(ally_big, ox, oy, oz + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(ally_small, ox, oy, oz + zOffset, alpha)
								else
									LibDraw.Texture(ally, ox, oy, oz + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
							elseif factionGroup == 'Horde' then
								if distance < 50 then
									LibDraw.Texture(horde_big, ox, oy, oz + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(horde_small, ox, oy, oz + zOffset, alpha)
								else
									LibDraw.Texture(horde, ox, oy, oz + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
							end
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
						if NeP.Core.PeFetch("NePconf_Overlays", "objectsFriendlyPlayers") then
							if name ~= UnitName('player') then
								local factionGroup, factionName = UnitFactionGroup(object.key)
								if factionGroup == 'Alliance' then
									if distance < 50 then
										LibDraw.Texture(ally_big, ox, oy, oz + zOffset, alpha)
									elseif distance > 200 then
										LibDraw.Texture(ally_small, ox, oy, oz + zOffset, alpha)
									else
										LibDraw.Texture(ally, ox, oy, oz + zOffset, alpha)
									end
									LibDraw.SetColorRaw(1, 1, 1, alpha)
									LibDraw.Text(_addonColor..name.."|r\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
								elseif factionGroup == 'Horde' then
									if distance < 50 then
										LibDraw.Texture(horde_big, ox, oy, oz + zOffset, alpha)
									elseif distance > 200 then
										LibDraw.Texture(horde_small, ox, oy, oz + zOffset, alpha)
									else
										LibDraw.Texture(horde, ox, oy, oz + zOffset, alpha)
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
	end

end)

NeP.Interface.Overlays = {
	key = "NePconf_Overlays",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "Overlays Settings",
	color = NeP.Interface.addonColor,
	width = 250,
	height = 500,
	config = {
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Overlays:", size = 25, align = "Center" },
			{ type = "text", text = "Only Works with FireHack ATM!", size = 11, offset = 0, align = "center" },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Player Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Player Melee Range", key = "PlayerMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "PlayerCRange", default = false },
			{ type = "checkbox", text = "Display Target Line", key = "TargetLine", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "PlayerInfrontCone", default = false },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Target Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Player Melee Range", key = "TargetMRange", default = false },
			{ type = "checkbox", text = "Display Player Caster Range", key = "TargetCRange", default = false },
			{ type = "checkbox", text = "Display Infront Cone", key = "TargetCone", default = false },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Objects Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Herb Objects", key = "objectsHerbs", default = false },
			{ type = "checkbox", text = "Display Ore Objects", key = "objectsOres", default = false },
			{ type = "checkbox", text = "Display Lumbermill Objects", key = "objectsLM", default = false },
			{ type = "checkbox", text = "Display Fish Objects", key = "objectsFish", default = false },
		{ type = 'spacer' },
		{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Units Overlays:", size = 25, align = "Center" },
			{ type = "checkbox", text = "Display Friendly Player Units", key = "objectsFriendlyPlayers", default = false },
			{ type = "checkbox", text = "Display Enemie Player Units", key = "objectsEnemiePlayers", default = false },
			{ type = "checkbox", text = "Display Rare Units", key = "objectsRares", default = false },
			{ type = "checkbox", text = "Display WorldBoss Units", key = "objectsWorldBoss", default = false },
			{ type = "checkbox", text = "Display Elite Units", key = "objectsElite", default = false },
	}
}

function NeP.Interface.OverlaysGUI()
	NeP.Core.BuildGUI('Overlays', NeP.Interface.Overlays)
end