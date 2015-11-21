local isRunning = false

local function PetAttack()
	if C_PetBattles.GetBattleState() == 3 then
		local activePet = C_PetBattles.GetActivePet(1)
		local petAmount = C_PetBattles.GetNumPets(1)
		for i=petAmount,1,-1 do
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
	local petAmount = C_PetBattles.GetNumPets(1)
	for i=1,petAmount do
		local canSwap = C_PetBattles.CanPetSwapIn(i)
		if canSwap then
			C_PetBattles.ChangePet(i)
		end
	end
end

local function getPetHealth(owner, index)
	return math.floor((C_PetBattles.GetHealth(owner, index) / C_PetBattles.GetMaxHealth(owner, index)) * 100)
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
		{ type = "spinner", text = "Change Pet at Health %:", key = "swapHealth", width = 70, min = 10, max = 100, default = 15, step = 1 },
		{ type = "checkbox", text = "Auto Trap", key = "trap", default = false },
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
		local enemieActivePet = C_PetBattles.GetActivePet(2)
		-- Trap
		if getPetHealth(2, enemieActivePet) <= 35 and NeP.Core.PeFetch('NePpetBot', 'trap') and C_PetBattles.IsWildBattle() and C_PetBattles.IsTrapAvailable() then
			C_PetBattles.UseTrap()
		-- Swap
		elseif getPetHealth(1, activePet) <= NeP.Core.PeFetch('NePpetBot', 'swapHealth') then
			PetSwap()
		else -- Attack
			PetAttack()
		end
	end
end), nil)

--local modifier = C_PetBattles.GetAttackModifier(select(7, C_PetBattles.GetAbilityInfo(1, 1, 2)), select(7, C_PetBattles.GetAbilityInfo(2, 1, 1)))