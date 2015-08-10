local WoWver, WoWbuild, WoWdate, WoWtoc = GetBuildInfo()
local _time = 0

local function onUpdate(npStart,elapsed) 
	if _time < GetTime() - 5.0 then
		if npStart:GetAlpha() == 0 then
			npStart:Hide()
			npSplash:Hide()
		else 
			npStart:SetAlpha(npStart:GetAlpha() - .05)
			npSplash:SetAlpha(npStart:GetAlpha() - .05)
		end
	end
end

local _StartEvents = function()
	NeP.Core.CurrentCR = true

	if NeP.Core.PeFetch('npconf', 'LiveGUI') then
		NeP.ShowStatus()
	end

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
		local _playerInfo = function()
			local _class = UnitClass('player')
			local _ClassColor = NeP.Core.classColor('player')
			local _spec = (GetSpecialization() or '#unknown')
			local _specName = select(2, GetSpecializationInfo(_spec))
			local _specIcon = "|T"..select(4, GetSpecializationInfo(_spec))..":13:13|t "
			return "|r[|cff".._ClassColor.._class.." - ".._specIcon.._specName.."|r]"
		end
		local _addonColor = NeP.Addon.Interface.addonColor
		local _nick = _addonColor .. NeP.Addon.Info.Nick
		local _infoCR = NeP.Addon.Info.Icon.. '|r[' .. _nick.. "|r]" .. _playerInfo()
		npStart.text:SetText(_infoCR .. "|r - [" .. _addonColor .. "Loaded|r]")
		npStart:SetAlpha(1)
		npSplash:SetAlpha(1)
		_time = GetTime()
		npStart:Show()
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

-- Text on Top
npStart = CreateFrame("Frame",nil,UIParent)
npStart:SetWidth(600)
npStart:SetHeight(30)
npStart:Hide()
npStart:SetScript("OnUpdate",onUpdate)
npStart:SetPoint("TOP",0,0)
npStart.text = npStart:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
npStart.text:SetAllPoints()
npStart.texture = npStart:CreateTexture()
npStart.texture:SetAllPoints()
npStart.texture:SetTexture(0,0,0,0.7)