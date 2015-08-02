local WoWver, WoWbuild, WoWdate, WoWtoc = GetBuildInfo()
local addonColor = NeP.Addon.Interface.addonColor

local function onUpdate(npStart,elapsed) 
	if npStart.time < GetTime() - 5.0 and npSplash.time < GetTime() - 5.0 then
		if npStart:GetAlpha() == 0 and  npSplash:GetAlpha() then
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
end

function NeP.Splash()
	-- Displays a fancy splash.
	if NeP.Core.PeFetch('npconf', 'Splash') then
		npStart.text:SetText(NeP.Core.CrInfo().."|r - ".."[|r"..addonColor.."Loaded|r]", 5.0)
		npStart:SetAlpha(1)
		npSplash:SetAlpha(1)
		npStart.time = GetTime()
		npSplash.time = GetTime()
		npStart:Show()
		npSplash:Show()
		PlaySoundFile("Sound\\Interface\\Levelup.Wav")
		--PlaySound("UnwrapGift", "master");
	end
	
	_StartEvents()
	
end

npSplash = CreateFrame("Frame", nil,UIParent)
npSplash:SetPoint("CENTER",UIParent)
npSplash:SetWidth(512)
npSplash:SetHeight(256)
npSplash:SetBackdrop({ bgFile = NeP.Addon.Info.Splash })
npSplash:SetScript("OnUpdate",onUpdate)
npSplash:Hide()
npSplash.time = 0
	
npStart = CreateFrame("Frame",nil,UIParent)
npStart:SetWidth(600)
npStart:SetHeight(30)
npStart:Hide()
npStart:SetScript("OnUpdate",onUpdate)
npStart:SetPoint("TOP",0,0)
npStart.text = npStart:CreateFontString(nil,"OVERLAY","MovieSubtitleFont")
npStart.text:SetAllPoints()
npStart.time = 0