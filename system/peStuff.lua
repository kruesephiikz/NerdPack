--[[-----------------------------------------------		
	** Commands **		
DESC: Slash commands in-game.		
		
Build By: MTS		
--------------------------------------------------]]		
ProbablyEngine.command.register(NeP.Info.Nick, function(msg, box)		
	local command, text = msg:match('^(%S*)%s*(.-)$')
	if command == 'config' or command == 'c' then
		NeP.Core.displayGUI('Settings')
	elseif command == 'class' or command == 'cl' then
		NeP.Interface.ClassGUI('Show')
	elseif command == 'info' or command == 'i' then
		NeP.Core.displayGUI('Info')
	elseif command == 'fish' or command == 'fishingbot' then		
		NeP.Core.displayGUI('fishingBot')
	elseif command == 'pet' or command == 'petbot' then		
		NeP.Core.displayGUI('petBot')
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		if NeP.Core.hiding then
			NeP.Core.hiding = false
			ProbablyEngine.buttons.buttonFrame:Show()
			NeP_Frame:Show()
			NeP.Core.Print('Now Showing everything again.')
		end
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Core.displayGUI('Overlays')
	else
		-- Print all available commands.
		NeP.Core.Print('/config - (Opens General Settings GUI)')
		NeP.Core.Print('/status - (Opens Status GUI)')
		NeP.Core.Print('/class - (Opens Class Settings GUI)')
		NeP.Core.Print('/Info - (Opens Info GUI)')
		NeP.Core.Print('/pet - (Opens Petbot GUI)')
		NeP.Core.Print('/fish - (Opens FishBot GUI)')
		NeP.Core.Print('/hide - (Hides Everything)')
		NeP.Core.Print('/show - (Shows Everything)')
		NeP.Core.Print('/overlays - (Opens Overlays Settings GUI)')
	end
end)

ProbablyEngine.listener.register("LFG_PROPOSAL_SHOW", function()
	if NeP.Core.PeFetch('NePConf', 'AutoLFG') then
		AcceptProposal()
	end
end)

ProbablyEngine.listener.register("LFG_ROLE_CHECK_SHOW", function()
	if NeP.Core.PeFetch('NePConf', 'AutoRole') then
		if NeP.Core.PeFetch('NePConf', 'RoleSet') == 'DPS' then
			RolePollPopupRoleButtonDPS:Click()
		elseif NeP.Core.PeFetch('NePConf', 'RoleSet') == 'TANK' then
			RolePollPopupRoleButtonTank:Click()
		elseif NeP.Core.PeFetch('NePConf', 'RoleSet') == 'HEALER' then
			RolePollPopupRoleButtonHealer:Click()
		end
		RolePollPopupAcceptButton:Click()
		--AcceptProposal()
	end
end)

ProbablyEngine.listener.register("RESURRECT_REQUEST", function()
	if NeP.Core.PeFetch('NePConf', 'AutoARess') then
		StaticPopup1Button1:Click()
	end
end)

ProbablyEngine.condition.register('twohand', function(target)
  return IsEquippedItemType("Two-Hand")
end)

ProbablyEngine.condition.register('onehand', function(target)
  return IsEquippedItemType("One-Hand")
end)

ProbablyEngine.condition.register('elite', function(target)
  return UnitClassification(target) == 'elite'
end)

ProbablyEngine.condition.register("petinmelee", function(target)
   if FireHack then 
		return NeP.Core.Distance('pet', target) < (UnitCombatReach('pet') + UnitCombatReach(target) + 1.5)
	else
		-- Unlockers wich dont have UnitCombatReach like functions...
		return NeP.Core.Distance('pet', target) < 5
	end
end)

ProbablyEngine.condition.register("inMelee", function(target)
   return NeP.Core.UnitAttackRange('player', target, 'melee')
end)

ProbablyEngine.condition.register("inRanged", function(target)
   return NeP.Core.UnitAttackRange('player', target, 'ranged')
end)

ProbablyEngine.condition.register("power.regen", function(target)
  return select(2, GetPowerRegen(target))
end)

ProbablyEngine.condition.register("casttime", function(target, spell)
    local name, rank, icon, cast_time, min_range, max_range = GetSpellInfo(spell)
    return cast_time
end)

ProbablyEngine.condition.register('NePinterrupt', function (target)
	if ProbablyEngine.condition['modifier.toggle']('interrupt') then
		if UnitName('player') == UnitName(target) then return false end
		local stopAt = NeP.Core.PeFetch('NePConf', 'ItA') or 95
		local secondsLeft, castLength = ProbablyEngine.condition['casting.delta'](target)
		return secondsLeft and 100 - (secondsLeft / castLength * 100) > stopAt
	end
	return false
end)

ProbablyEngine.condition.register("isBoss", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("isElite", function (target)
	local boss = LibStub("LibBossIDs")
	local classification = UnitClassification(target)
	if classification == "elite" 
		or classification == "rareelite" 
		or classification == "rare" 
		or classification == "worldboss" 
		or UnitLevel(target) == -1 
		or boss.BossIDs[UnitID(target)] then 
			return true 
		end
    return false
end)

ProbablyEngine.condition.register("NePinfront", function(target)
	return NeP.Core.Infront('player', target)
end)

ProbablyEngine.condition.register("castwithin", function(target, spell)
	local SpellID = select(7, GetSpellInfo(spell))
	for k, v in pairs( ProbablyEngine.actionLog.log ) do
		local id = select(7, GetSpellInfo(v.description))
		if (id and id == SpellID and v.event == "Spell Cast Succeed") or tonumber( k ) == 20 then
			return tonumber( k )
		end
	end
	return 20
end)

ProbablyEngine.condition.register("ShouldRess", function()
	for i=1,#NeP.OM.unitFriendDead do
		local Obj = NeP.OM.unitFriendDead[i]
		if Obj.distance <= 40 then
			if not UnitHasIncomingResurrection(Obj.key) then
				ProbablyEngine.dsl.parsedTarget = Obj.key
				return true
			end
		end
	end
end)