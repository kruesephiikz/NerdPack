local _mediaDir = NeP.Addon.Interface.mediaDir
local alpha = 100
local zOffset = 3

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

C_Timer.NewTicker(0.01, (function()
	if NeP.Core.CurrentCR then
		if FireHack then
			
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
				LibDraw.SetWidth(3)
				
				-- Target Line
				if NeP.Core.PeFetch("npconf_Overlays", "TargetLine") then
					LibDraw.SetColorRaw(1, 1, 1, alpha)
					LibDraw.Text(name .. "\n" .. distance .. ' yards', "SystemFont_Tiny", targetX, targetY, targetZ + 6)
					LibDraw.Line(playerX, playerY, playerZ, targetX, targetY, targetZ)
				end
				
				-- Player Infront Cone
				if NeP.Core.PeFetch("npconf_Overlays", "PlayerInfrontCone") then
					if NeP.Lib.Infront('target') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Arc(playerX, playerY, playerZ, 10, 180, playerRotation)
				end
				
				-- Player Melee Range
				if NeP.Core.PeFetch("npconf_Overlays", "PlayerMRange") then
					if NeP.Lib.Distance('player', 'target') <= 5 then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(playerX, playerY, playerZ, 5)
				end
				
				-- Player Caster Range
				if NeP.Core.PeFetch("npconf_Overlays", "PlayerCRange") then
					if NeP.Lib.Distance('player', 'target') <= 40 then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(playerX, playerY, playerZ, 45)
				end
				
				-- Target Infront Cone
				if NeP.Core.PeFetch("npconf_Overlays", "TargetCone") then
					LibDraw.SetColorRaw(1, 1, 1, alpha)
					LibDraw.Arc(targetX, targetY, targetZ, 10, 180, targetRotation)
				end
				
				-- Target Melee Range
				if NeP.Core.PeFetch("npconf_Overlays", "TargetMRange") then
					if NeP.Lib.Distance('player', 'target') <= 5 then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(targetX, targetY, targetZ, 5)
				end
				
				-- Target Caster Range
				if NeP.Core.PeFetch("npconf_Overlays", "TargetCRange") then
					if NeP.Lib.Distance('player', 'target') <= 40 then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(targetX, targetY, targetZ, 45)
				end
				
			end
			
		-- Objects (Ores/Herbs/LM)
			-- Dont do anything if everything is disabled...
			if NeP.Core.PeFetch("npconf_Overlays", "objectsHerbs") 
			or NeP.Core.PeFetch("npconf_Overlays", "objectsOres")
			or NeP.Core.PeFetch("npconf_Overlays", "objectsLM") then
				
				for i=1,#NeP.ObjectManager.objectsCache do
					local object = NeP.ObjectManager.objectsCache[i]
					local distance = object.distance
					local ox, oy, oz = ObjectPosition(object.key)
					local name = object.name
					local id = object.is
					
					-- Lumbermill
					if id == 'LM' then
						if distance < 50 then
							LibDraw.Texture(lumbermill_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(lumbermill_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(lumbermill, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(name .. "\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end

					-- Ores
					if id == 'Ore' then
						if distance < 50 then
							LibDraw.Texture(ore_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(ore_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(ore, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(name .. "\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end

					-- Herbs
					if id == 'Herb' then
						if distance < 50 then
							LibDraw.Texture(herb_big, ox, oy, oz + zOffset, alpha)
						elseif distance > 200 then
							LibDraw.Texture(herb_small, ox, oy, oz + zOffset, alpha)
						else
							LibDraw.Texture(herb, ox, oy, oz + zOffset, alpha)
						end
						LibDraw.SetColorRaw(1, 1, 1, alpha)
						LibDraw.Text(name .. "\n" .. distance .. ' yards', "SystemFont_Tiny", ox, oy, oz + 1)
					end
					
				end
			end
		end
	end
end), nil)