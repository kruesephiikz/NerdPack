local LibDraw = LibStub('LibDraw-1.0')

local _mediaDir = NeP.Interface.mediaDir
local alpha = 100
local zOffset = 3
local _addonColor = '|cff'..NeP.Interface.addonColor

local basicMarker = {
	{ 0.1, 0, 0, -0.1, 0, 0},
	{ 0, 0.1, 0, 0, -0.1, 0},
	{ 0, 0, -0.1, 0, 0, 0.1}
}

local Textures = {
	-- Rares
	['rare'] = { texture = _mediaDir..'elite.blp', width = 64, height = 64 },
	['rare_big'] = { texture = _mediaDir..'elite.blp', width = 58, height = 58, scale = 1 },
	['rare_small'] = { texture = _mediaDir..'elite.blp', width = 18, height = 18, scale = 1 },
	-- Mobs
	['mob'] = { texture = _mediaDir..'mob.blp', width = 64, height = 64 },
	['mob_big'] = { texture = _mediaDir..'mob.blp', width = 58, height = 58, scale = 1 },
	['mob_small'] = { texture = _mediaDir..'mob.blp', width = 18, height = 18, scale = 1 },
	-- Units (Not bring used...)
	['unit'] = { texture = _mediaDir..'player.blp', width = 64, height = 64 },
	['unit_big'] = { texture = _mediaDir..'player.blp', width = 58, height = 58, scale = 1 },
	['unit_small'] = { texture = _mediaDir..'player.blp', width = 18, height = 18, scale = 1 },
	-- Horde
	['horde'] = { texture = _mediaDir..'horde.blp', width = 64, height = 64 },
	['horde_big'] = { texture = _mediaDir..'horde.blp', width = 58, height = 58, scale = 1 },
	['horde_small'] = { texture = _mediaDir..'horde.blp', width = 18, height = 18, scale = 1 },
	-- Aliance
	['ally'] = { texture = _mediaDir..'alliance.blp', width = 64, height = 64 },
	['ally_big'] = { texture = _mediaDir..'alliance.blp', width = 58, height = 58, scale = 1 },
	['ally_small'] = { texture = _mediaDir..'alliance.blp', width = 18, height = 18, scale = 1 },
}

LibDraw.Sync(function()
	
	if NeP.Core.CurrentCR and FireHack then
		if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then

			local pX, pY, pZ = ObjectPosition('player')
			--local cx, cy, cz = GetCameraPosition()

			if UnitGUID('target') ~= nil and ObjectExists('target') then
				local tX, tY, tZ = ObjectPosition('target')
				local distance = NeP.Core.Round(NeP.Core.Distance('player', 'target'))
				local name = UnitName('target')
				local playerRotation = ObjectFacing('player')
				local targetRotation = ObjectFacing('target')
				LibDraw.SetWidth(2)
				-- Target Line
				if NeP.Core.PeFetch('NePconf_Overlays', 'TargetLine') then
					LibDraw.SetColorRaw(1, 1, 1, alpha)
					LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', tX, tY, tZ + 6)
					LibDraw.Line(pX, pY, pZ, tX, tY, tZ)
				end
				-- Player Infront Cone
				if NeP.Core.PeFetch('NePconf_Overlays', 'PlayerInfrontCone') then
					if NeP.Core.Infront('player', 'target') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Arc(pX, pY, pZ, 10, 180, playerRotation)
				end
				-- Player Melee Range
				if NeP.Core.PeFetch('NePconf_Overlays', 'PlayerMRange') then
					if NeP.Core.Distance('player', 'target') <= NeP.Core.UnitAttackRange('player', 'target', 'melee') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(pX, pY, pZ, NeP.Core.UnitAttackRange('player', 'target', 'melee'))
				end
				-- Player Caster Range
				if NeP.Core.PeFetch('NePconf_Overlays', 'PlayerCRange') then
					if NeP.Core.Distance('player', 'target') <= NeP.Core.UnitAttackRange('player', 'target', 'ranged') then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(pX, pY, pZ, NeP.Core.UnitAttackRange('player', 'target', 'ranged'))
				end
				-- Target Infront Cone
				if NeP.Core.PeFetch('NePconf_Overlays', 'TargetCone') then
					LibDraw.SetColorRaw(1, 1, 1, alpha)
					LibDraw.Arc(tX, tY, tZ, 10, 180, targetRotation)
				end
				-- Target Melee Range
				if NeP.Core.PeFetch('NePconf_Overlays', 'TargetMRange') then
					if NeP.Core.Distance('player', 'target') <= NeP.Core.UnitAttackRange('player', 'target', 'melee') then
						LibDraw.SetColor(101, 255, 87, 70)
					else
						LibDraw.SetColor(255, 87, 87, 70)
					end
					LibDraw.Circle(tX, tY, tZ, NeP.Core.UnitAttackRange('player', 'target', 'melee'))
				end
				-- Target Caster Range
				if NeP.Core.PeFetch('NePconf_Overlays', 'TargetCRange') then
					if NeP.Core.Distance('player', 'target') <= NeP.Core.UnitAttackRange('player', 'target', 'ranged') then
						LibDraw.SetColor(101, 255, 87, 50)
					else
						LibDraw.SetColor(255, 87, 87, 50)
					end
					LibDraw.Circle(tX, tY, tZ, NeP.Core.UnitAttackRange('player', 'target', 'ranged'))
				end
			end
			
			-- Enemie Units
			for i=1,#NeP.OM.unitEnemie do
				local Obj = NeP.OM.unitEnemie[i]
				if UnitGUID(Obj.key) ~= nil and ObjectExists(Obj.key) then --Calling ObjectExists in FireHack 2.1.4 with nil can crash the client. Fixed in FireHack 2.2.
					local distance = NeP.Core.Round(Obj.distance)
					local oX, oY, oZ = ObjectPosition(Obj.key)
					local name = Obj.name
					local _class = Obj.class

					if NeP.Core.PeFetch('NePconf_Overlays', 'enemieTTD') then
						LibDraw.Text(_addonColor..'TTD:|cffFFFFFF '..NeP.Core.Round(ProbablyEngine.condition['ttd'](Obj.key)), 'SystemFont_Tiny', oX, oY, oZ + 3)
					end
					
					-- Elites
					if _class == 'elite' then
						if NeP.Core.PeFetch('NePconf_Overlays', 'objectsElite') then
							if distance < 50 then
								LibDraw.Texture(Textures['mob_big'], oX, oY, oZ + zOffset, alpha)
							elseif distance > 200 then
								LibDraw.Texture(Textures['mob_small'], oX, oY, oZ + zOffset, alpha)
							else
								LibDraw.Texture(Textures['mob'], oX, oY, oZ + zOffset, alpha)
							end
							LibDraw.SetColorRaw(1, 1, 1, alpha)
							LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
						end
					-- WorldBoss
					elseif _class == 'worldboss' then
						if NeP.Core.PeFetch('NePconf_Overlays', 'objectsWorldBoss') then
							if distance < 50 then
								LibDraw.Texture(Textures['mob_big'], oX, oY, oZ + zOffset, alpha)
							elseif distance > 200 then
								LibDraw.Texture(Textures['mob_small'], oX, oY, oZ + zOffset, alpha)
							else
								LibDraw.Texture(Textures['mob'], oX, oY, oZ + zOffset, alpha)
							end
							LibDraw.SetColorRaw(1, 1, 1, alpha)
							LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
						end
					-- Rares
					elseif _class == 'rareelite' then
						if NeP.Core.PeFetch('NePconf_Overlays', 'objectsRares') then
							if distance < 50 then
								LibDraw.Texture(Textures['mob_big'], oX, oY, oZ + zOffset, alpha)
							elseif distance > 200 then
								LibDraw.Texture(Textures['mob_small'], oX, oY, oZ + zOffset, alpha)
							else
								LibDraw.Texture(Textures['mob'], oX, oY, oZ + zOffset, alpha)
							end
							LibDraw.SetColorRaw(1, 1, 1, alpha)
							LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
						end
					elseif UnitIsPlayer(Obj.key) then
						if NeP.Core.PeFetch('NePconf_Overlays', 'objectsEnemiePlayers') then
							local factionGroup, factionName = UnitFactionGroup(Obj.key)
							if factionGroup == 'Alliance' then
								if distance < 50 then
									LibDraw.Texture(Textures['ally_big'], oX, oY, oZ + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(Textures['ally_small'], oX, oY, oZ + zOffset, alpha)
								else
									LibDraw.Texture(Textures['ally'], oX, oY, oZ + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
							elseif factionGroup == 'Horde' then
								if distance < 50 then
									LibDraw.Texture(Textures['horde_big'], oX, oY, oZ + zOffset, alpha)
								elseif distance > 200 then
									LibDraw.Texture(Textures['horde_small'], oX, oY, oZ + zOffset, alpha)
								else
									LibDraw.Texture(Textures['horde'], oX, oY, oZ + zOffset, alpha)
								end
								LibDraw.SetColorRaw(1, 1, 1, alpha)
								LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
							end
						end
					end
				end
			end
			
			-- Friendly Units
			for i=1,#NeP.OM.unitFriend do
				local Obj = NeP.OM.unitFriend[i]
				if UnitGUID(Obj.key) ~= nil and ObjectExists(Obj.key) then --Calling ObjectExists in FireHack 2.1.4 with nil can crash the client. Fixed in FireHack 2.2.
					local distance = NeP.Core.Round(Obj.distance)
					local oX, oY, oZ = ObjectPosition(Obj.key)
					local name = Obj.name
					local _class = Obj.class
					-- Players
					if UnitIsPlayer(Obj.key) then
						if NeP.Core.PeFetch('NePconf_Overlays', 'objectsFriendlyPlayers') then
							if name ~= UnitName('player') then
								local factionGroup, factionName = UnitFactionGroup(Obj.key)
								if factionGroup == 'Alliance' then
									if distance < 50 then
										LibDraw.Texture(Textures['ally_big'], oX, oY, oZ + zOffset, alpha)
									elseif distance > 200 then
										LibDraw.Texture(Textures['ally_small'], oX, oY, oZ + zOffset, alpha)
									else
										LibDraw.Texture(Textures['ally'], oX, oY, oZ + zOffset, alpha)
									end
									LibDraw.SetColorRaw(1, 1, 1, alpha)
									LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
								elseif factionGroup == 'Horde' then
									if distance < 50 then
										LibDraw.Texture(Textures['horde_big'], oX, oY, oZ + zOffset, alpha)
									elseif distance > 200 then
										LibDraw.Texture(Textures['horde_small'], oX, oY, oZ + zOffset, alpha)
									else
										LibDraw.Texture(Textures['horde'], oX, oY, oZ + zOffset, alpha)
									end
									LibDraw.SetColorRaw(1, 1, 1, alpha)
									LibDraw.Text(_addonColor..name..'|r\n' .. distance .. ' yards', 'SystemFont_Tiny', oX, oY, oZ + 1)
								end
							end
						end
					end
				end
			end
		end
	end

end)

NeP.Core.BuildGUI('Overlays', {
	key = 'NePconf_Overlays',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..' '..NeP.Info.Name,
	subtitle = 'Overlays Settings',
	color = NeP.Interface.addonColor,
	width = 250,
	height = 500,
	config = {
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor..'Overlays:', size = 25, align = 'Center' },
			{ type = 'text', text = 'Only Works with FireHack ATM!', size = 11, offset = 0, align = 'center' },
		
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor..'Player Overlays:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Display Melee Range', key = 'PlayerMRange', default = false },
			{ type = 'checkbox', text = 'Display Caster Range', key = 'PlayerCRange', default = false },
			{ type = 'checkbox', text = 'Display Target Line', key = 'TargetLine', default = false },
			{ type = 'checkbox', text = 'Display Infront Cone', key = 'PlayerInfrontCone', default = false },
		
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor..'Target Overlays:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Display Melee Range', key = 'TargetMRange', default = false },
			{ type = 'checkbox', text = 'Display Caster Range', key = 'TargetCRange', default = false },
			{ type = 'checkbox', text = 'Display Infront Cone', key = 'TargetCone', default = false },
		
		{ type = 'spacer' },{ type = 'rule' },
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor..'Units Overlays:', size = 25, align = 'Center' },
			{ type = 'checkbox', text = 'Display Friendly Player Units', key = 'objectsFriendlyPlayers', default = false },
			{ type = 'checkbox', text = 'Display Enemie Player Units', key = 'objectsEnemiePlayers', default = false },
			{ type = 'checkbox', text = 'Display Rare Units', key = 'objectsRares', default = false },
			{ type = 'checkbox', text = 'Display WorldBoss Units', key = 'objectsWorldBoss', default = false },
			{ type = 'checkbox', text = 'Display Elite Units', key = 'objectsElite', default = false },
			{ type = 'checkbox', text = 'Display TimeToDie', key = 'enemieTTD', default = false },
	}
})
