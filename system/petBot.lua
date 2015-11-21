local isRunning = false

local function PetAttack()
	if C_PetBattles.GetBattleState() == 3 then
		local activePet = C_PetBattles.GetActivePet(1)
		for i = 1, 3 do
			local isUsable, currentCooldown = C_PetBattles.GetAbilityState(1, activePet, i)
			if isUsable then
				C_PetBattles.UseAbility(i)
			end
		end
	end
end

--[[-----------------------------------------------
** GUI table **
DESC: Gets returned to PEs build GUI to create it.

Build By: MTS
---------------------------------------------------]]
NeP.Core.BuildGUI('petBot', {
	key = "NePpetBot",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "PetBot Settings",
	color = NeP.Interface.addonColor,
	width = 250,
	height = 300,
	config = {
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Pet Bot:", size = 25, align = "Center"},
		{ type = "button", text = "test", width = 225, height = 20,callback = function() isRunning = not isRunning end },

	}	
})

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR and isRunning then
		PetAttack()
	end
end), nil)