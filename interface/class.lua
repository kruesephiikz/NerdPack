local _CurrentSpec = nil
local ClassWindow
local _OpenClassWindow = false
local _ShowingClassWindow = false

function NeP.Addon.Interface.ClassGUI()
	_NePClassGUIs = {
		[250] = NeP.Addon.Interface.DkBlood,
		[252] = NeP.Addon.Interface.DkUnholy,
		[103] = NeP.Addon.Interface.DruidFeral,
		[104] = NeP.Addon.Interface.DruidGuard,
		[105] = NeP.Addon.Interface.DruidResto,
		[102] = NeP.Addon.Interface.DruidBalance,
		[257] = NeP.Addon.Interface.PriestHoly,
		[258] = NeP.Addon.Interface.PriestShadow,
		[256] = NeP.Addon.Interface.PriestDisc,
		[70] = NeP.Addon.Interface.PalaRet,
		[66] = NeP.Addon.Interface.PalaProt,
		[65] = NeP.Addon.Interface.PalaHoly,
		[73] = NeP.Addon.Interface.WarrProt,
		[72] = NeP.Addon.Interface.WarrFury,
		[270] = NeP.Addon.Interface.MonkMm,
		[269] = NeP.Addon.Interface.MonkWw,
		[262] = NeP.Addon.Interface.ShamanEle,
		[264] = NeP.Addon.Interface.ShamanResto
	}
	local _Spec = GetSpecializationInfo(GetSpecialization())
	if _Spec ~= nil then
		if _NePClassGUIs[_Spec] ~= nil then
			_CurrentSpec = NeP.Core.BuildGUI(_NePClassGUIs[_Spec])		
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