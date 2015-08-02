NeP.Lib.DK = {}

--[[-----------------------------------------------
** DarkSim **
DESC: copys a spell from a unit.

Build By: FORGOTTEN
Modifyed by: MTS
---------------------------------------------------]]
function NeP.Lib.DK.DarkSimUnit(unit)
	local _darkSimSpells = {
		-- Siege of Orgrimmar
		"Froststorm Bolt",
		"Arcane Shock",
		"Rage of the Empress",
		"Chain Lightning",
		-- PvP
		"Hex",
		"Mind Control",
		"Cyclone",
		"Polymorph",
		"Pyroblast",
		"Tranquility",
		"Divine Hymn",
		"Hymn of Hope",
		"Ring of Frost",
		"Entangling Roots"
	}
	for index,spellName in pairs(_darkSimSpells) do
		if ProbablyEngine.condition["casting"](unit, spellName) then
			return true 
		end
	end
	return false
end