local isRunning = false

local function PetAttack()
	if C_PetBattles.GetBattleState() == 3 then
		local activePet = C_PetBattles.GetActivePet(1)
		for i=3,1,-1 do
			local isUsable, currentCooldown = C_PetBattles.GetAbilityState(1, activePet, i)
			local id, name, icon, maxcooldown, desc, numTurns, abilityPetType, nostrongweak = C_PetBattles.GetAbilityInfo(1, activePet, i)
			if isUsable and not nostrongweak then
				NeP.Core.Print('Casting: |T'..icon..':10:10|t'..name)
				C_PetBattles.UseAbility(i)
				break
			end
		end
		C_PetBattles.SkipTurn()
	end
end

local function PetSwap()
	for i=1,3 do
		local canSwap = C_PetBattles.CanPetSwapIn(i)
		if canSwap then
			C_PetBattles.ChangePet(i)
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
		{ type = "button", text = "Start", width = 225, height = 20,callback = function(self, button)
				isRunning = not isRunning
				if isRunning then
					self:SetText("Stop")
				else
					self:SetText("Start")
				end
			end
		},

	}	
})

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR and isRunning then
		local activePet = C_PetBattles.GetActivePet(1)
		if C_PetBattles.GetHealth(1, activePet) <= 15 then
			PetSwap()
		end
		PetAttack()
	end
end), nil)