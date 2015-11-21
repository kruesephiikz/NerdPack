local PeFetch = NeP.Core.PeFetch
local C_PB = C_PetBattles
local C_PJ = C_PetJournal
local isRunning = false

local function getPetHealth(owner, index)
	return math.floor((C_PB.GetHealth(owner, index) / C_PB.GetMaxHealth(owner, index)) * 100)
end

local function PetAttack()
	if C_PB.GetBattleState() == 3 then
		local activePet = C_PB.GetActivePet(1)
		local petAmount = C_PB.GetNumPets(1)
		for i=petAmount,1,-1 do
			local isUsable, currentCooldown = C_PB.GetAbilityState(1, activePet, i)
			local id, name, icon, maxcooldown, desc, numTurns, abilityPetType, nostrongweak = C_PB.GetAbilityInfo(1, activePet, i)
			if isUsable and not nostrongweak then
				NeP.Core.Print('Casting: |T'..icon..':10:10|t'..name)
				C_PB.UseAbility(i)
				break
			end
		end
		C_PB.SkipTurn()
	end
end

local function PetSwap()
	local petAmount = C_PB.GetNumPets(1)
	local activePet = C_PB.GetActivePet(1)
	for i=1,petAmount do
		if i ~= activePet then
			local canSwap = C_PB.CanPetSwapIn(i)
			if canSwap and getPetHealth(1, activePet) <= PeFetch('NePpetBot', 'swapHealth') then
				C_PB.ChangePet(i)
				break
			end
		end
	end
	return false
end

local maxPetLvl = 0

local function scanLoadOut()
	local petTable = {}
	local maxAmount, petAmount = C_PJ.GetNumPets()
	for i=1,petAmount do
		local guid, id, _, _, lvl, _ , _, name = C_PJ.GetPetInfoByIndex(i)
		petTable[#petTable+1]={
			guid = guid,
			id = id,
			lvl = lvl,
			name = name
		}
	end
	table.sort(petTable, function(a,b) return a.lvl > b.lvl end)
	maxPetLvl = petTable[1].lvl
	return petTable
end

local function buildTeam()
	petTable = scanLoadOut()
	for i=1,#petTable do
		if not C_PJ.PetIsSlotted(petTable[i].guid) and (petTable[i].lvl >= maxPetLvl and PeFetch('NePpetBot', 'teamtype') == 'BattleTeam' or petTable[i].lvl < maxPetLvl and PeFetch('NePpetBot', 'teamtype') == 'LvlngTeam') then
			for k=1,3 do
				local petID, petSpellID_slot1, petSpellID_slot2, petSpellID_slot3, locked = C_PJ.GetPetLoadOutInfo(k)
				local speciesID, customName, level, xp, maxXp, displayID, isFavorite, petName, petIcon, petType, creatureID, sourceText, description, isWild, canBattle, tradable, unique = C_PJ.GetPetInfoByPetID(petID)
				local health, maxHealth, attack, speed, rarity = C_PJ.GetPetStats(petID)
				local healthPercentage = math.floor((health / maxHealth) * 100)
				if (level >= maxPetLvl and PeFetch('NePpetBot', 'teamtype') == 'LvlngTeam' or level < maxPetLvl and PeFetch('NePpetBot', 'teamtype') == 'BattleTeam') or healthPercentage <= 25 then
					NeP.Core.Print('Changing pet: '..k..' to: |T'..petIcon..':10:10|t'..petName)
					C_PJ.SetPetLoadOutInfo(k, petTable[i].guid)
					break
				end
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
		{ type = "spinner", text = "Change Pet at Health %:", key = "swapHealth", width = 70, min = 10, max = 100, default = 15, step = 1 },
		{ type = "checkbox", text = "Auto Trap", key = "trap", default = false },
		{ type = "dropdown", text = "Team type:", key = "teamtype", list = {
			{ text = "Battle Team", key = "BattleTeam" },
			{ text = "Leveling Team", key = "LvlngTeam" },
		}, default = "BattleTeam" },
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
		local activePet = C_PB.GetActivePet(1)
		local enemieActivePet = C_PB.GetActivePet(2)
		if not C_PB.IsInBattle() then
			buildTeam()
		else
			-- Trap
			if getPetHealth(2, enemieActivePet) <= 35 and PeFetch('NePpetBot', 'trap') and C_PB.IsWildBattle() and C_PB.IsTrapAvailable() then
				C_PB.UseTrap()
			-- Swap
			elseif not PetSwap() then
				PetAttack()
			end
		end
	end
end), nil)

--local modifier = C_PB.GetAttackModifier(select(7, C_PB.GetAbilityInfo(1, 1, 2)), select(7, C_PB.GetAbilityInfo(2, 1, 1)))
-- C_PB.ForfeitGame