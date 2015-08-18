NeP = {
	Core = {
		peRecomemded = "6.1r16",
		CurrentCR = false,
		hidding = false,
		printColor = "|cffFFFFFF",
		PeFetch = ProbablyEngine.interface.fetchKey,
		PeConfig = ProbablyEngine.config,
		PeBuildGUI = ProbablyEngine.interface.buildGUI
	},
	Interface = {
		
	},
	Addon = {
		Info = {
			Name = 'NerdPack',
			Nick = 'NeP',
			Version = "6.2.1.1",
			Branch = "Beta",
			WoW_Version = "6.2.0",
			Icon = "|TInterface\\AddOns\\NerdPack\\media\\logo.blp:10:10|t",
			Logo = "Interface\\AddOns\\NerdPack\\media\\logo.blp",
			Splash = "Interface\\AddOns\\NerdPack\\media\\splash.blp"
		},
		Interface = {
			GuiColor = "0070DE",
			GuiTextColor = "|cff0070DE",
			addonColor = "|cff0070DE",
			mediaDir = "Interface\\AddOns\\NerdPack\\media\\"
		}
	}
}




NeP.Interface.addText = function(parent)
	local text = parent:CreateFontString(nil, "OVERLAY")
	text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	return text
end

NeP.Interface.addButton = function(parent)
	local Button = CreateFrame("Button", nil, parent)
	Button:SetWidth(100)
	Button:SetHeight(30)
	Button:SetNormalFontObject("GameFontNormal")
	Button.Button1 = Button:CreateTexture()
	Button.Button1:SetTexture(255, 255 ,255 , 0.1)
	Button.Button1:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button1:SetAllPoints() 
	Button.Button2 = Button:CreateTexture()
	Button.Button2:SetTexture(0.5,0.5,0.5,1)
	Button.Button2:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button2:SetAllPoints()
	Button.Button3 = Button:CreateTexture()
	Button.Button3:SetTexture(0,0,0,1)
	Button.Button3:SetTexCoord(0, 0.625, 0, 0.6875)
	Button.Button3:SetAllPoints()
	Button:SetNormalTexture(Button.Button1)
	Button:SetHighlightTexture(Button.Button2)
	Button:SetPushedTexture(Button.Button3)
	Button.text = Button:CreateFontString(nil, "OVERLAY")
	Button.text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	Button.text:SetPoint("CENTER", 0, 0)
	return Button
end

NeP.Interface.addScrollFrame = function(parent)
	local scrollframe = CreateFrame("ScrollFrame", nil, parent) 
	scrollframe.texture = scrollframe:CreateTexture() 
	scrollframe.texture:SetAllPoints() 
	scrollframe.texture:SetTexture(255,255,255,0.3)
	scrollframe.scrollbar = CreateFrame("Slider", "FPreviewScrollBar", scrollframe)
	scrollframe.scrollbar.bg = scrollframe.scrollbar:CreateTexture(nil, "BACKGROUND")
	scrollframe.scrollbar.bg:SetAllPoints(true)
	scrollframe.scrollbar.bg:SetTexture(255, 255, 255, 0.1)
	scrollframe.scrollbar.thumb = scrollframe.scrollbar:CreateTexture(nil, "OVERLAY")
	scrollframe.scrollbar.thumb:SetTexture(255, 255, 255, 0.7)
	scrollframe.scrollbar.thumb:SetSize(16, 16)
	scrollframe.scrollbar.text = scrollframe.scrollbar:CreateFontString(nil, "OVERLAY")
	scrollframe.scrollbar.text:SetFont("Fonts\\FRIZQT__.TTF", 15)
	scrollframe.scrollbar.text:SetSize(16, 16)
	scrollframe.scrollbar.text:SetText('|cff000000=')
	scrollframe.scrollbar.text:SetPoint('CENTER', scrollframe.scrollbar.thumb)
	scrollframe.scrollbar:SetThumbTexture(scrollframe.scrollbar.thumb)
	scrollframe.scrollbar:SetOrientation("VERTICAL");
	scrollframe.scrollbar:SetPoint("TOPLEFT", scrollframe, "TOPRIGHT", 0, 0)
	scrollframe.scrollbar:SetMinMaxValues(0, 0)
	scrollframe.scrollbar:SetValue(0)
	scrollframe.scrollbar:SetScript("OnValueChanged", function(self)
		  scrollframe:SetVerticalScroll(self:GetValue())
	end)
	return scrollframe
end

NeP.Interface.addFrame = function(parent)
	local Frame = CreateFrame("Frame", nil, parent)
	Frame.texture = Frame:CreateTexture() 
	Frame.texture:SetAllPoints() 
	Frame.texture:SetTexture(0,0,0,0.7)
	return Frame
end

NeP.Interface.addCheckButton = function(parent)
	local createCheckBox = CreateFrame("CheckButton", "UICheckButtonTemplateTest", parent, "UICheckButtonTemplate")
	createCheckBox:ClearAllPoints();
	createCheckBox:SetSize(15, 15)
	createCheckBox.text = parent:CreateFontString(nil, "OVERLAY")
	
	return createCheckBox
end





local defaults = {
	['CONFIG'] = {
		['test'] = false,
	},
	['OMList'] = {
		['test'] = false,
		['ShowDPS'] = false,
		['ShowHealthText'] = true,
		['ShowHealthBars'] = true,
	}
}

NeP.Config = {}

local MyAddonFrame = CreateFrame("Frame")
MyAddonFrame:RegisterEvent("VARIABLES_LOADED")
MyAddonFrame:SetScript("OnEvent", function(self, event, addon)
	if not NePData then 
	 	NePData = defaults; 
	end
	CreateFrame_VARIABLES_LOADED();
end)

NeP.Config.resetConfig = function(config)
	NePData[config] = defaults[config]
end

NeP.Config.readKey = function(config, key)
	if NePData[config] ~= nil then
		if NePData[config][key] ~= nil then
			return NePData[config][key]
		else
			NePData[config][key] = defaults[config][key] 
		end
	else
		NePData[config] = defaults[config]
	end
end

NeP.Config.writeKey = function(config, key, value)
	NePData[config][key] = value
end

NeP.Config.toggleKey = function(config, key)
	if NePData[config][key] ~= nil then
		NePData[config][key] = not NePData[config][key]
	else
		NePData[config][key] = defaults[config][key] 
	end
end

--[[-----------------------------------------------
									** Commands **
							DESC: Slash commands in-game.
---------------------------------------------------]]
ProbablyEngine.command.register(NeP.Addon.Info.Nick, function(msg, box)
	local command, text = msg:match("^(%S*)%s*(.-)$")
	if command == 'config' or command == 'c' then
		NeP.Addon.Interface.ConfigGUI()
	elseif command == 'class' or command == 'cl' then
		NeP.Addon.Interface.ClassGUI()
	elseif command == 'info' or command == 'i' then
		NeP.Addon.Interface.InfoGUI()
	elseif command == 'cache' or command == 'cch' or command == 'om' then
		NeP.Addon.Interface.CacheGUI()
	elseif command == 'hide' then
		NeP.Core.HideAll()
	elseif command == 'show' then
		NeP.Core.HideAll()
	elseif command == 'overlay' or command == 'ov' or command == 'overlays' then
		NeP.Addon.Interface.OverlaysGUI()
	elseif command == 'test' then
		NeP.Addon.Interface.OMGUI()
	else 
		NeP.Core.Print('/config - (Opens General Settings GUI)')
		NeP.Core.Print('/status - (Opens Status GUI)')
		NeP.Core.Print('/class - (Opens Class Settings GUI)')
		NeP.Core.Print('/Info - (Opens Info GUI)')
		NeP.Core.Print('/cache - (Opens OM Settings GUI)')
		NeP.Core.Print('/hide - (Hides Everything)')
		NeP.Core.Print('/show - (Shows Everything)')
		NeP.Core.Print('/overlays - (Opens Overlays Settings GUI)')
	end
end)

--[[-----------------------------------------------
									** Gobal's **
								DESC: Global functions.
---------------------------------------------------]]
function NeP.Core.classColor(unit)
	if UnitIsPlayer(unit) then
		local _classColors = {
			["HUNTER"] = { r = 0.67, g = 0.83, b = 0.45, Hex = "abd473" },
			["WARLOCK"] = { r = 0.58, g = 0.51, b = 0.79, Hex = "9482c9" },
			["PRIEST"] = { r = 1.0, g = 1.0, b = 1.0, Hex = "ffffff" },
			["PALADIN"] = { r = 0.96, g = 0.55, b = 0.73, Hex = "f58cba" },
			["MAGE"] = { r = 0.41, g = 0.8, b = 0.94, Hex = "69ccf0" },
			["ROGUE"] = { r = 1.0, g = 0.96, b = 0.41, Hex = "fff569" },
			["DRUID"] = { r = 1.0, g = 0.49, b = 0.04, Hex = "ff7d0a" },
			["SHAMAN"] = { r = 0.0, g = 0.44, b = 0.87, Hex = "0070de" },
			["WARRIOR"] = { r = 0.78, g = 0.61, b = 0.43, Hex = "c79c6e" },
			["DEATHKNIGHT"] = { r = 0.77, g = 0.12 , b = 0.23, Hex = "c41f3b" },
			["MONK"] = { r = 0.0, g = 1.00 , b = 0.59, Hex = "00ff96" },
		}
		local _class, className = UnitClass(unit)
		local _color = _classColors[className]
		return _color.Hex
	else
		return NeP.Addon.Interface.GuiColor
	end
end

function NeP.Core.GetCrInfo(txt)
	local _nick = NeP.Addon.Interface.addonColor..NeP.Addon.Info.Nick
	local _classColor = NeP.Core.classColor('Player')
	return NeP.Addon.Info.Icon.. '|r[' .. _nick .. "|r]|r[|cff" .. _classColor .. txt .. "|r]"
end

function NeP.Core.HideAll()
	if not NeP.Core.hidding then
		NeP.Core.Print('Now Hidding everything, to re-enable use the command "/np show".')
		ProbablyEngine.buttons.buttonFrame:Hide()
		NeP_MinimapButton:Hide()
		NeP.Core.hidding = true
	else
		NeP.Core.hidding = false
		ProbablyEngine.buttons.buttonFrame:Show()
		NeP_MinimapButton:Show()
		NeP.Core.Print('Now Showing everything again.')
	end
end

function NeP.Core.Print(txt)
	if not NeP.Core.hidding and NeP.Core.PeFetch('npconf', 'Prints') then
		local _name = NeP.Addon.Interface.addonColor..NeP.Addon.Info.Name
		print("|r[".._name.."|r]: "..NeP.Core.printColor..txt)
	end
end

function NeP.Core.Alert(txt)
	if not NeP.Core.hidding and NeP.Core.PeFetch('npconf', 'Alerts') then
		if NeP.Core.PeFetch('npconf', 'Sounds') then
			PlaySoundFile("Interface\\AddOns\\Probably_MrTheSoulz\\media\\beep.mp3")
		end
		npAlert:message("|r["..NeP.Addon.Interface.addonColor.."MTS|r]: "..NeP.Core.printColor..txt)
	end
end

local function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function NeP.Core.Distance(a, b)
	-- FireHack
	if FireHack then
		local ax, ay, az = ObjectPosition(b)
		local bx, by, bz = ObjectPosition(a)
		return round(math.sqrt(((bx-ax)^2) + ((by-ay)^2) + ((bz-az)^2)))
	else
		return ProbablyEngine.condition["distance"](b)
	end
	return 0
end

function NeP.Core.LineOfSight(a, b)
	if FireHack then
		if UnitExists(a) and UnitExists(b) then
			local ax, ay, az = ObjectPosition(a)
			local bx, by, bz = ObjectPosition(b)
			local losFlags =  bit.bor(0x10, 0x100)
			local aCheck = select(6,strsplit("-",UnitGUID(a)))
			local bCheck = select(6,strsplit("-",UnitGUID(b)))
			local ignoreLOS = {
				[76585] = true,     -- Ragewing the Untamed (UBRS)
				[77063] = true,     -- Ragewing the Untamed (UBRS)
				[77182] = true,     -- Oregorger (BRF)
				[77891] = true,     -- Grasping Earth (BRF)
				[77893] = true,     -- Grasping Earth (BRF)
				[78981] = true,     -- Iron Gunnery Sergeant (BRF)
				[81318] = true,     -- Iron Gunnery Sergeant (BRF)
				[83745] = true,     -- Ragewing Whelp (UBRS)
				[86252] = true,     -- Ragewing the Untamed (UBRS)
			}
			if ignoreLOS[tonumber(aCheck)] ~= nil then return true end
			if ignoreLOS[tonumber(bCheck)] ~= nil then return true end
			if ax == nil or ay == nil or az == nil or bx == nil or by == nil or bz == nil then return false end
			return not TraceLine(ax, ay, az+2.25, bx, by, bz+2.25, losFlags)
		end
	end
	return false
end

function NeP.Core.Infront(a, b)
	if (UnitExists(a) and UnitExists(b)) then
		-- FireHack
		if FireHack then
			local aX, aY, aZ = ObjectPosition(b)
			local bX, bY, bZ = ObjectPosition(a)
			local playerFacing = GetPlayerFacing()
			local facing = math.atan2(bY - aY, bX - aX) % 6.2831853071796
			return math.abs(math.deg(math.abs(playerFacing - (facing)))-180) < 90
		-- Fallback to PE's
		else
			return ProbablyEngine.condition["infront"](b)
		end
	end
end