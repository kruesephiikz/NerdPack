local WoWver, WoWbuild, WoWdate, WoWtoc = GetBuildInfo()
local _addonColor = '|cff'..NeP.Interface.addonColor
local NePActive = ''
local _time = 0

C_Timer.NewTicker(0.01, (function()
	if _time < GetTime() - 1.0 then
		if NeP_Splash:GetAlpha() == 0 then
			NeP_Splash:Hide()
		else 
			NeP_Splash:SetAlpha(NeP_Splash:GetAlpha() - .05)
		end
	end
	
	if ProbablyEngine.rotation.currentStringComp == NePActive then
		if not NeP.Core.CurrentCR then
			NeP.Core.CurrentCR = true
			NeP_Frame:Show()
		end
	else
		if NeP.Core.CurrentCR then
			NeP.Core.CurrentCR = false
			NeP_Frame:Hide()
		end
	end
end), nil)

local _StartEvents = function()
	NePActive = ProbablyEngine.rotation.currentStringComp

	if WoWver ~= NeP.Info.WoW_Version or ProbablyEngine.version ~= NeP.Core.peRecomemded then
		if WoWver ~= NeP.Info.WoW_Version then
			NeP.Core.Print("Your WoW Version is not supported by MTSP\n Using: "..WoWver.." while supported version is: "..NeP.Info.WoW_Version.."\nSomethings might not work until updated.")
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
	if NeP.Core.PeFetch('NePConf', 'Splash') then
		local _playerInfo = "|r[|cff"..NeP.Core.classColor('player')..UnitClass('player').." - "..select(2, GetSpecializationInfo(GetSpecialization())).."|r]"
		NeP.Alert(_playerInfo .. "|r - [" .. _addonColor .. "Loaded|r]")
		NeP_Splash:SetAlpha(1)
		_time = GetTime()
		NeP_Splash:Show()
		PlaySoundFile("Sound\\Interface\\Levelup.Wav")
		--PlaySound("UnwrapGift", "master");
	end
	
	_StartEvents()
	
end

-- Logo on Center
NeP_Splash = CreateFrame("Frame", nil,UIParent)
NeP_Splash:SetPoint("CENTER",UIParent)
NeP_Splash:SetWidth(512)
NeP_Splash:SetHeight(256)
NeP_Splash:SetBackdrop({ bgFile = NeP.Info.Splash })
NeP_Splash:SetScript("OnUpdate",onUpdate)
NeP_Splash:Hide()