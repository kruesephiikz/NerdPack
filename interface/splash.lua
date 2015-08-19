local _playerInfo = "|r[|cff"..NeP.Core.classColor('player')..UnitClass('player').." - "..select(2, GetSpecializationInfo(GetSpecialization())).."|r]"
local WoWver, WoWbuild, WoWdate, WoWtoc = GetBuildInfo()
local _addonColor = NeP.Addon.Interface.addonColor
local NePActive = ''
local _time = 0

C_Timer.NewTicker(0.01, (function()
	if _time < GetTime() - 1.0 then
		if npSplash:GetAlpha() == 0 then
			npSplash:Hide()
		else 
			npSplash:SetAlpha(npSplash:GetAlpha() - .05)
		end
	end
	
	if ProbablyEngine.rotation.currentStringComp == NePActive then
		NeP.Core.CurrentCR = true
		NeP_Frame:Show()
		NeP.Addon.Interface.MinimapButton:Show()
	else
		NeP.Core.CurrentCR = false
		NeP_Frame:Hide()
		NeP.Addon.Interface.MinimapButton:Hide()
	end
end), nil)

local _StartEvents = function()
	NePActive = ProbablyEngine.rotation.currentStringComp

	if WoWver ~= NeP.Addon.Info.WoW_Version or ProbablyEngine.version ~= NeP.Core.peRecomemded then
		if WoWver ~= NeP.Addon.Info.WoW_Version then
			NeP.Core.Print("Your WoW Version is not supported by MTSP\n Using: "..WoWver.." while supported version is: "..NeP.Addon.Info.WoW_Version.."\nSomethings might not work until updated.")
		end
		if ProbablyEngine.version ~= NeP.Core.peRecomemded then
			NeP.Core.Print("Your PE Version is not supported by MTSP\n Using: "..ProbablyEngine.version.." while supported version is: "..NeP.Core.peRecomemded.."\nSomethings might not work until updated.")
		end
	else
		NeP.Core.Print("Load successful.")
	end
	
	ProbablyEngine.toggle.create(
		'NeP_SAoE', 
		'Interface\\Icons\\Spell_magic_polymorphrabbit', 
		'Smart AoE', 
		'Enable to use Smart AoE.\nTo force AoE use the multitarget toggle.')
end

function NeP.Splash()
	-- Displays a fancy splash.
	if NeP.Core.PeFetch('npconf', 'Splash') then
		NeP.Alert(_playerInfo .. "|r - [" .. _addonColor .. "Loaded|r]")
		npSplash:SetAlpha(1)
		_time = GetTime()
		npSplash:Show()
		PlaySoundFile("Sound\\Interface\\Levelup.Wav")
		--PlaySound("UnwrapGift", "master");
	end
	
	_StartEvents()
	
end

-- Logo on Center
npSplash = CreateFrame("Frame", nil,UIParent)
npSplash:SetPoint("CENTER",UIParent)
npSplash:SetWidth(512)
npSplash:SetHeight(256)
npSplash:SetBackdrop({ bgFile = NeP.Addon.Info.Splash })
npSplash:SetScript("OnUpdate",onUpdate)
npSplash:Hide()