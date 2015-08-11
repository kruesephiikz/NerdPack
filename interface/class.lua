local _CurrentSpec = nil
local ClassWindow
local _OpenClassWindow = false
local _ShowingClassWindow = false

function NeP.Addon.Interface.ClassGUI()
	local _Spec = GetSpecialization()
	
	if _Spec ~= nil then
		local _SpecID =  (GetSpecializationInfo(_Spec) or nil)
		-- Check wich spec the player is to return the correct window.	
		if _SpecID == 250 and not _OpenClassWindow then -- DK Blood
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DkBlood)
		elseif _SpecID == 252 and not _OpenClassWindow  then -- DK Unholy
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DkUnholy)
		elseif _SpecID == 103 and not _OpenClassWindow  then -- Druid Feral
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DruidFeral)
		elseif _SpecID == 104 and not _OpenClassWindow  then -- Druid Guardian
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DruidGuard)
		elseif _SpecID == 105 and not _OpenClassWindow  then -- Druid Resto
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DruidResto)
		elseif _SpecID == 102 and not _OpenClassWindow  then -- Druid Balance
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.DruidBalance)
		elseif _SpecID == 257 and not _OpenClassWindow  then -- Priest holy
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PriestHoly)
		elseif _SpecID == 258 and not _OpenClassWindow  then -- Priest Shadow
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PriestShadow)
		elseif _SpecID == 256 and not _OpenClassWindow  then -- Priest Disc
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PriestDisc)
		elseif _SpecID == 70 and not _OpenClassWindow  then -- Pala Retribution
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PalaRet)
		elseif _SpecID == 66 and not _OpenClassWindow  then -- Pala Protection
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PalaProt)
		elseif _SpecID == 65 and not _OpenClassWindow  then -- Pala Holy
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.PalaHoly)	
		elseif _SpecID == 73 and not _OpenClassWindow  then -- Warrior Protection
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.WarrProt)
		elseif _SpecID == 72 and not _OpenClassWindow  then -- Warrior Fury
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.WarrFury)	
		elseif _SpecID == 270 and not _OpenClassWindow  then -- Monk Mistweaver
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.MonkMm)
		elseif _SpecID == 269 and not _OpenClassWindow  then -- Monk WindWalker
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.MonkWw)
		elseif _SpecID == 262 and not _OpenClassWindow  then -- Shamman Elemental
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.ShamanEle)
		elseif _SpecID == 264 and not _OpenClassWindow  then -- Shamman Resto
			_CurrentSpec = NeP.Core.PeBuildGUI(NeP.Addon.Interface.ShamanResto)		
		end
	end

	-- If no window been created, create one...
	if not _OpenClassWindow and _CurrentSpec ~= nil then
		_OpenClassWindow = true
		_ShowingClassWindow = true
		_CurrentSpec.parent:SetEventListener('OnClose', function()
			_OpenClassWindow = false
			_ShowingClassWindow = false
		end)

	-- If a windows has been created and its showing then hide it...	
	elseif _OpenClassWindow == true and _ShowingClassWindow == true then
		_CurrentSpec.parent:Hide()
		_ShowingClassWindow = false

	-- If a windows has been created and its hidden then show it...		
	elseif _OpenClassWindow == true and _ShowingClassWindow == false then
		_CurrentSpec.parent:Show()
		_ShowingClassWindow = true
	end

end