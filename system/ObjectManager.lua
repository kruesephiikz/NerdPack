NeP.OM = {
	unitEnemie = {},
	unitFriend = {},
}

-- Local stuff to reduce global calls
local peConfig = NeP.Core.PeConfig
local UnitExists = UnitExists
local objectDistance = NeP.Core.Distance

--[[
	DESC: Checks if unit has a Blacklisted Debuff.
	This will remove the unit from the OM cache.
---------------------------------------------------]]
local BlacklistedAuras = {
		-- CROWD CONTROL
	['118'] = '',        -- Polymorph
	['1513'] = '',       -- Scare Beast
	['1776'] = '',       -- Gouge
	['2637'] = '',       -- Hibernate
	['3355'] = '',       -- Freezing Trap
	['6770'] = '',       -- Sap
	['9484'] = '',       -- Shackle Undead
	['19386'] = '',      -- Wyvern Sting
	['20066'] = '',      -- Repentance
	['28271'] = '',      -- Polymorph (turtle)
	['28272'] = '',      -- Polymorph (pig)
	['49203'] = '',      -- Hungering Cold
	['51514'] = '',      -- Hex
	['61025'] = '',      -- Polymorph (serpent) -- FIXME: gone ?
	['61305'] = '',      -- Polymorph (black cat)
	['61721'] = '',      -- Polymorph (rabbit)
	['61780'] = '',      -- Polymorph (turkey)
	['76780'] = '',      -- Bind Elemental
	['82676'] = '',      -- Ring of Frost
	['90337'] = '',      -- Bad Manner (Monkey) -- FIXME: to check
	['115078'] = '',     -- Paralysis
	['115268'] = '',     -- Mesmerize
		-- MOP DUNGEONS/RAIDS/ELITES
	['106062'] = '',     -- Water Bubble (Wise Mari)
	['110945'] = '',     -- Charging Soul (Gu Cloudstrike)
	['116994'] = '',     -- Unstable Energy (Elegon)
	['122540'] = '',     -- Amber Carapace (Amber Monstrosity - Heat of Fear)
	['123250'] = '',     -- Protect (Lei Shi)
	['143574'] = '',     -- Swelling Corruption (Immerseus)
	['143593'] = '',     -- Defensive Stance (General Nazgrim)
		-- WOD DUNGEONS/RAIDS/ELITES
	['155176'] = '',     -- Damage Shield (Primal Elementalists - Blast Furnace)
	['155185'] = '',     -- Cotainment (Primal Elementalists - BRF)
	['155233'] = '',     -- Dormant (Blast Furnace)
	['155265'] = '',     -- Cotainment (Primal Elementalists - BRF)
	['155266'] = '',     -- Cotainment (Primal Elementalists - BRF)
	['155267'] = '',     -- Cotainment (Primal Elementalists - BRF)
	['157289'] = '',     -- Arcane Protection (Imperator Mar'Gok)
	['174057'] = '',     -- Arcane Protection (Imperator Mar'Gok)
	['182055'] = '',     -- Full Charge (Iron Reaver)
	['184053'] = '',     -- Fel Barrier (Socrethar)
}

local function BlacklistedDebuffs(Obj)
	local isBadDebuff = false
	for i = 1, 40 do
		local spellID = select(11, UnitDebuff(Obj, i))
		if spellID ~= nil then
			if BlacklistedAuras[tostring(spellID)] ~= nil then
				isBadDebuff = true
			end
		end
	end
	return isBadDebuff
end

--[[
	DESC: Checks if Object is a Blacklisted.
	This will remove the Object from the OM cache.
---------------------------------------------------]]
local BlacklistedObjects = {
	['76829'] = '',		-- Slag Elemental (BrF - Blast Furnace)
	['78463'] = '',		-- Slag Elemental (BrF - Blast Furnace)
	['60197'] = '',		-- Scarlet Monastery Dummy
	['64446'] = '',		-- Scarlet Monastery Dummy
	['93391'] = '',		-- Captured Prisoner (HFC)
	['93392'] = '',		-- Captured Prisoner (HFC)
	['93828'] = '',		-- Training Dummy (HFC)
	['234021'] = '',
	['234022'] = '',
	['234023'] = '',
}

local function BlacklistedObject(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj) or '0')
	return BlacklistedObjects[tostring(ObjID)] ~= nil
end

local TrackedDummys = {
	['31144'] = 'dummy',		-- Training Dummy - Lvl 80
	['31146'] = 'dummy',		-- Raider's Training Dummy - Lvl ??
	['32541'] = 'dummy', 		-- Initiate's Training Dummy - Lvl 55 (Scarlet Enclave)
	['32542'] = 'dummy',		-- Disciple's Training Dummy - Lvl 65
	['32545'] = 'dummy',		-- Initiate's Training Dummy - Lvl 55
	['32546'] = 'dummy',		-- Ebon Knight's Training Dummy - Lvl 80
	['32666'] = 'dummy',		-- Training Dummy - Lvl 60
	['32667'] = 'dummy',		-- Training Dummy - Lvl 70
	['46647'] = 'dummy',		-- Training Dummy - Lvl 85
	['67127'] = 'dummy',		-- Training Dummy - Lvl 90
	['87318'] = 'dummy',		-- Dungeoneer's Training Dummy <Damage> ALLIANCE GARRISON
	['87761'] = 'dummy',		-- Dungeoneer's Training Dummy <Damage> HORDE GARRISON
	['87322'] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE ASHRAN BASE
	['88314'] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> ALLIANCE GARRISON
	['88836'] = 'dummy',		-- Dungeoneer's Training Dummy <Tanking> HORDE ASHRAN BASE
	['88288'] = 'dummy',		-- Dunteoneer's Training Dummy <Tanking> HORDE GARRISON
	['87317'] = 'dummy',		-- Dungeoneer's Training Dummy - Lvl 102 (Lunarfall - Damage)
	['87320'] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Stormshield - Damage)
	['87329'] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Stormshield - Tank)
	['87762'] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Warspear - Damage)
	['88837'] = 'dummy',		-- Raider's Training Dummy - Lvl ?? (Warspear - Tank)
	['88906'] = 'dummy',		-- Combat Dummy - Lvl 100 (Nagrand)
	['88967'] = 'dummy',		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
	['89078'] = 'dummy',		-- Training Dummy - Lvl 100 (Lunarfall, Frostwall)
}

local function isDummy(Obj)
	local _,_,_,_,_,ObjID = strsplit('-', UnitGUID(Obj) or '0')
	return TrackedDummys[tostring(ObjID)] ~= nil
end

--[[
	DESC: Places the object in its correct place.
	This is done in a seperate function so we dont have
	to repeate code over and over again for all unlockers.
---------------------------------------------------]]
local function addToOM(Obj, Dist)
	if not BlacklistedObject(Obj) and ProbablyEngine.condition['alive'](Obj) then
		if not BlacklistedDebuffs(Obj) then
			-- Friendly
			if UnitIsFriend('player', Obj) then
				NeP.OM.unitFriend[#NeP.OM.unitFriend+1] = {
					key = Obj, 
					distance = Dist, 
					health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
					maxHealth = UnitHealthMax(Obj), 
					actualHealth = UnitHealth(Obj), 
					name = UnitName(Obj),
					is = 'friendly'
				}
			-- Enemie
			elseif UnitCanAttack('player', Obj) then
				NeP.OM.unitEnemie[#NeP.OM.unitEnemie+1] = {
					key = Obj, 
					distance = Dist, 
					health = math.floor((UnitHealth(Obj) / UnitHealthMax(Obj)) * 100), 
					maxHealth = UnitHealthMax(Obj), 
					actualHealth = UnitHealth(Obj), 
					name = UnitName(Obj),
					is = isDummy(Obj) and 'dummy' or 'enemie'
				}
			end
		end
	end
end

local function NeP_FireHackOM()
	local totalObjects = ObjectCount()
	for i=1, totalObjects do
		local Obj = ObjectWithIndex(i)
		if UnitGUID(Obj) ~= nil and ObjectExists(Obj) then
			if ObjectIsType(Obj, ObjectTypes.Unit) then
				local ObjDistance = objectDistance('player', Obj)
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(Obj, ObjDistance)
				end
			end
		end
	end
end

--[[
	Generic OM
---------------------------------------------------]]
local function GenericFilter(unit, objectDis)
	if UnitExists(unit) then
		local objectName = UnitName(unit)
		local alreadyExists = false
		-- Friendly Filter
		if UnitCanAttack('player', unit) then
			for i=1, #NeP.OM.unitEnemie do
				local object = NeP.OM.unitEnemie[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		-- Enemie Filter
		elseif UnitIsFriend('player', unit) then
			for i=1, #NeP.OM.unitFriend do
				local object = NeP.OM.unitFriend[i]
				if object.distance == objectDis and object.name == objectName then
					alreadyExists = true
				end
			end
		end
		if not alreadyExists then return true end
	end
	return false
end

local function NeP_GenericOM()
	-- Self
	addToOM('player', 5)
	-- Mouseover
	if UnitExists('mouseover') then
		local object = 'mouseover'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object, ObjDistance)
			end
		end
	end
	-- Target Cache
	if UnitExists('target') then
		local object = 'target'
		local ObjDistance = objectDistance('player', object)
		if GenericFilter(object, ObjDistance) then
			if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
				addToOM(object, ObjDistance)
			end
		end
	end
	-- If in Group scan frames...
	if IsInGroup() or IsInRaid() then
		local prefix = (IsInRaid() and 'raid') or 'party'
		for i = 1, GetNumGroupMembers() do
			-- Enemie
			local target = prefix..i..'target'
			local ObjDistance = objectDistance('player', target)
			if GenericFilter(target, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(target, ObjDistance)
				end
			end
			-- Friendly
			local friendly = prefix..i
			local ObjDistance = objectDistance('player', friendly)
			if GenericFilter(friendly, ObjDistance) then
				if ObjDistance <= (NeP.Core.PeFetch('ObjectCache', 'CD') or 100) then
					addToOM(friendly, ObjDistance)
				end
			end
		end
	end
end

--[[
									TICKER
-------------------------------------------------------------------------------------------------------
]]
C_Timer.NewTicker(1, (function()

	-- Wipe Cache
	wipe(NeP.OM.unitEnemie)
	wipe(NeP.OM.unitFriend)

	if NeP.Core.CurrentCR and peConfig.read('button_states', 'MasterToggle', false) then
		-- Master Toggle
		if NeP.Core.PeFetch('ObjectCache', 'ObjectCache') then
			-- FireHack OM
			if FireHack then
				NeP_FireHackOM()
			-- Generic Cache
			else 
				NeP_GenericOM()
			end
		end
		-- Sort by distance
		table.sort(NeP.OM.unitEnemie, function(a,b) return a.distance < b.distance end)
		table.sort(NeP.OM.unitFriend, function(a,b) return a.distance < b.distance end)
	end
end), nil)

NeP.Config.Defaults['OMList'] = {
	['ShowDPS'] = false,
	['ShowInfoText'] = true,
	['ShowHealthBars'] = true,
	['ShowHealthText'] = true,
	['POS_1'] = 'CENTER',
	['POS_2'] = 0,
	['POS_3'] = 0
}

-- Tables to Control Status Bars Used
local statusBars = { }
local statusBarsUsed = { }

-- Vars
local OPTIONS_WIDTH = 500;
local OPTIONS_HEIGHT = 300;
local SETTINGS_WIDTH = 200;
local _objectTable = NeP.OM.unitFriend;
local _Displaying = 'Friendly List';
local scrollMax = 0;

-- Locals
local DiesalGUI = LibStub("DiesalGUI-1.0");
local _addonColor = NeP.Interface.addonColor;
local _tittleGUI = '|T'..NeP.Info.Logo..':20:20|t |cff'.._addonColor..NeP.Info.Nick;

function OMGUI_RUN()
	
	NeP_OMLIST = NeP.Interface.addFrame(UIParent)
	NeP_OMLIST:SetSize(OPTIONS_WIDTH, OPTIONS_HEIGHT) 
	NeP_OMLIST:SetPoint(NeP.Config.readKey('OMList', 'POS_1'), NeP.Config.readKey('OMList', 'POS_2'), NeP.Config.readKey('OMList', 'POS_3'))
	NeP_OMLIST:SetMovable(true)
	NeP_OMLIST:SetFrameLevel(0)
	NeP_OMLIST:RegisterForDrag("LeftButton")
	NeP_OMLIST:EnableMouse(true)
	NeP_OMLIST:RegisterForDrag('LeftButton')
	NeP_OMLIST:SetScript('OnDragStart', NeP_OMLIST.StartMoving)
	NeP_OMLIST:SetScript('OnDragStop', function(self)
		local from, _, to, x, y = self:GetPoint()
		self:StopMovingOrSizing()
		NeP.Config.writeKey('OMList', 'POS_1', from)
		NeP.Config.writeKey('OMList', 'POS_2', x)
		NeP.Config.writeKey('OMList', 'POS_3', y)
	end)
	-- Title
	local titleText1 = NeP.Interface.addText(NeP_OMLIST)
	titleText1:SetPoint("TOPLEFT", 0, -7)
	titleText1:SetText('OM')
	local titleText2 = NeP.Interface.addText(NeP_OMLIST)
	titleText2:SetPoint("TOP", 0, -7)
	titleText2:SetText('')
	local titleText3 = NeP.Interface.addText(NeP_OMLIST)
	titleText3:SetPoint("TOPRIGHT", -35, -7)
	titleText3:SetText('')

		-- Settings Frame
		local settingsFrame = NeP.Interface.addFrame(NeP_OMLIST)
		settingsFrame:SetSize(200, NeP_OMLIST:GetHeight()) 
		settingsFrame:SetPoint("BOTTOMRIGHT", 200, 0)
		settingsFrame:Hide()

			-- Tittle
			local SettingsText = NeP.Interface.addText(settingsFrame)
			SettingsText:SetPoint("TOP", 0, -7)
			SettingsText:SetText('Settings:')
			SettingsText:SetSize(settingsFrame:GetWidth(), 15)
			
			-- Settings Scroll Frame
			local SettingsScroll = NeP.Interface.addScrollFrame(settingsFrame)
			SettingsScroll:SetSize(settingsFrame:GetWidth()-16, settingsFrame:GetHeight()-60)  
			SettingsScroll:SetPoint("TOPLEFT", 0, -30)
			--SettingsScroll.scrollbar:SetMinMaxValues(0, 400-NeP_OMLIST:GetHeight())
			SettingsScroll.scrollbar:SetSize(16, settingsFrame:GetHeight()-60)  

			-- Settings Content Frame 
			local settingsContentFrame = NeP.Interface.addFrame(SettingsScroll)
			settingsContentFrame:SetPoint("TOP", 0, 0) 
			settingsContentFrame:SetSize(SettingsScroll:GetWidth(), SettingsScroll:GetHeight())

				-- Settings Content
				local _SettinsCount = 0
				
				-- Status Text checkbox
				local StatusTextCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				StatusTextCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowInfoText'));
				StatusTextCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				StatusTextCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowInfoText', self:GetChecked());
				end);
				local StatusText = NeP.Interface.addText(settingsContentFrame)
				StatusText:SetSize(SETTINGS_WIDTH-31, 10)
				StatusText:SetText('Show Status Text')
				StatusText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				StatusText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
				-- Health Text checkbox
				local HealthTextCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				HealthTextCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthText'));
				HealthTextCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				HealthTextCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowHealthText', self:GetChecked());
				end);
				local HealthText = NeP.Interface.addText(settingsContentFrame)
				HealthText:SetSize(SETTINGS_WIDTH-31, 10)
				HealthText:SetText('Show Health Text')
				HealthText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				HealthText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
				-- Health Bars checkbox
				local HealthBarCheckbox = NeP.Interface.addCheckButton(settingsContentFrame)
				_SettinsCount = _SettinsCount + 1
				HealthBarCheckbox:SetChecked(NeP.Config.readKey('OMList', 'ShowHealthBars'));
				HealthBarCheckbox:SetPoint("TOPLEFT", 10, -15*_SettinsCount)
				HealthBarCheckbox:SetScript("OnClick", function(self)
					NeP.Config.writeKey('OMList', 'ShowHealthBars', self:GetChecked());
				end);
				local HealthBarText = NeP.Interface.addText(settingsContentFrame)
				HealthBarText:SetSize(SETTINGS_WIDTH-31, 10)
				HealthBarText:SetText('Enable Health Bars')
				HealthBarText:SetFont("Fonts\\FRIZQT__.TTF", 10)
				HealthBarText:SetPoint("TOPRIGHT", 10, -15*_SettinsCount)
				
			-- Settings Frame Close Button
			local settingsCloseButton = NeP.Interface.addButton(settingsFrame)
			settingsCloseButton:SetSize(settingsFrame:GetWidth(), 30)
			settingsCloseButton.text:SetText("Close Settings")
			settingsCloseButton:SetPoint("BOTTOM", 0, 0)
			settingsCloseButton:SetScript("OnClick", function(self) 
				settingsFrame:Hide();
				settingsButton.text:SetText(": »")
				--titleFrame:SetSize(NeP_OMLIST:GetWidth()-30, 30); 
				settingsButton:SetPoint("TOPRIGHT", 0, 0) 
			end)	
			
		SettingsScroll:SetScrollChild(settingsContentFrame)
	
	-- Settings Button
	settingsButton = NeP.Interface.addButton(NeP_OMLIST)
	settingsButton:SetPoint("TOPRIGHT", 0, 0)
	settingsButton:SetSize(30, 30)
	settingsButton.text:SetText("»")
	settingsButton:SetScript("OnClick", function()
		if settingsFrame:IsShown() then
			settingsFrame:Hide()
			settingsButton.text:SetText("S: »")
		else
			settingsButton.text:SetText("S: «")
			settingsFrame:Show()
		end
	end)

	-- Enemy Button
	local enemieButton = NeP.Interface.addButton(NeP_OMLIST)
	enemieButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	enemieButton.text:SetText("Enemie List")
	enemieButton:SetPoint("BOTTOMRIGHT", 0, 0)
	enemieButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.unitEnemie; 
		_Displaying = 'Enemy List' 
	end)

	-- Friendly Button
	local friendlyButton = NeP.Interface.addButton(NeP_OMLIST)
	friendlyButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	friendlyButton.text:SetText("Friendly List")
	friendlyButton:SetPoint("BOTTOM", 0, 0)
	friendlyButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.unitFriend; 
		_Displaying = 'Friendly List' 
	end)

	-- Object Button
	local objectButton = NeP.Interface.addButton(NeP_OMLIST)
	objectButton:SetSize(NeP_OMLIST:GetWidth()/3, 30)
	objectButton.text:SetText("Objects List")
	objectButton:SetPoint("BOTTOMLEFT", 0, 0)
	objectButton:SetScript("OnClick", function(self) 
		_objectTable = NeP.OM.GameObjects; 
		_Displaying = 'Objects List' 
	end)

		-- Objects Scroll Frame
		local ObjectScroll = NeP.Interface.addScrollFrame(NeP_OMLIST)
		ObjectScroll:SetSize(NeP_OMLIST:GetWidth()-16, NeP_OMLIST:GetHeight() - 60)  
		ObjectScroll:SetPoint("TOPLEFT", 0, -30)
		ObjectScroll.scrollbar:SetSize(16, NeP_OMLIST:GetHeight() - 60)  

		-- Content Frame 
		local objectsContentFrame = NeP.Interface.addFrame(ObjectScroll)
		objectsContentFrame:SetSize(NeP_OMLIST:GetWidth()-16, 0)
		objectsContentFrame:SetPoint("TOPLEFT", 0, 0)

		ObjectScroll:SetScrollChild(objectsContentFrame)

	local function getStatusBar()
		local statusBar = tremove(statusBars)
		if not statusBar then
			statusBar = DiesalGUI:Create('NePStatusBar')
			statusBar:SetParent(objectsContentFrame)
			statusBar.frame:SetHeight(15)
			statusBar.frame.Left:SetPoint("LEFT", statusBar.frame)
			statusBar.frame:SetStatusBarColor(255, 255, 255, 0.5)
			statusBar.frame.Left:SetFont("Fonts\\FRIZQT__.TTF", 13)
			statusBar.frame.Left:SetShadowColor(0,0,0, 0)
			statusBar.frame.Left:SetShadowOffset(-1,-1)
			statusBar.frame.Right:SetPoint("RIGHT", statusBar.frame)
			statusBar.frame.Right:SetFont("Fonts\\FRIZQT__.TTF", 13)
			statusBar.frame.Right:SetShadowColor(0, 0, 0 , 0)
			statusBar.frame.Right:SetShadowOffset(0, 0)
		end
		statusBar:Show()
		table.insert(statusBarsUsed, statusBar)
		return statusBar
	end

	local function recycleStatusBars()
		for i = #statusBarsUsed, 1, -1 do
			statusBarsUsed[i]:Hide()
			tinsert(statusBars, tremove(statusBarsUsed))
		end
	end
	
	local ST_Color = "|cfff28f0d"
	
	C_Timer.NewTicker(0.01, (function()
		if NeP.Core.CurrentCR and NeP_OMLIST:IsShown() then
			if NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
				
				recycleStatusBars()
				
				local height = 0
				local currentRow = 0
				titleText3:SetText('|cffCCCCCC('.._Displaying..')')

					titleText2:SetText('|cffff0000Total: '..#_objectTable)
						if #_objectTable > 0 then
							for i=1,#_objectTable do
							local Obj = _objectTable[i]
							local name = Obj.name or ""
							local health = Obj.health or 100
							local distance = Obj.distance or ""
							local guid = UnitGUID(Obj.key) or ""
							local _id = tonumber(guid:match("-(%d+)-%x+$"), 10) or ""
							local statusBar = getStatusBar()

							statusBar.frame:SetPoint("TOPLEFT", objectsContentFrame, "TOPLEFT", 2, -1 + (currentRow * -15) + -currentRow )
							statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name..ST_Color..' (ID:'.._id..' D:'..distance..')')
							
							if NeP.Config.readKey('OMList', 'ShowInfoText') then
								statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name..ST_Color..' (ID:'.._id..' \ D:'..distance..')')
							else
								statusBar.frame.Left:SetText('|cff'..NeP.Core.classColor(Obj.key)..name)
							end
							
							if NeP.Config.readKey('OMList', 'ShowHealthText') then
								statusBar.frame.Right:SetText('(H:'..(health)..'%'..')')
								statusBar.frame.Right:Show()
							else
								statusBar.frame.Right:Hide()
							end
							
							if NeP.Config.readKey('OMList', 'ShowHealthBars') then
								statusBar:SetValue(health)
							else
								statusBar:SetValue(0)
							end
							
							statusBar.frame:SetScript("OnMouseDown", function(self) TargetUnit(Obj.key) end)
							height = height + 16
							currentRow = currentRow + 1
						end
					end
				
				if height > NeP_OMLIST:GetHeight() then
					scrollMax = height - (NeP_OMLIST:GetHeight()-60)
				else
					scrollMax = 0
				end
				
				objectsContentFrame:SetSize(NeP_OMLIST:GetWidth()-16, height)
				ObjectScroll.scrollbar:SetMinMaxValues(0, scrollMax)

			end
		end
	end), nil)

-- Hide frame
NeP_OMLIST:Hide()
	
end

NeP.Core.BuildGUI('omSettings', {
    key = "ObjectCache",
    title = _tittleGUI,
    subtitle = "ObjectManager Settings",
    color = _addonColor,
    width = 210,
    height = 350,
    config = {
    	{ type = 'header', text = '|cff'.._addonColor.."Cache Options:", size = 25, align = "Center", offset = 0 },
		{ type = 'rule' },
		{ type = 'spacer' },
			{ type = "checkbox", text = "Use ObjectCache", key = "ObjectCache", default = true },
			{ type = "checkbox", text = "Use Advanced Object Manager", key = "AC", default = true },
			{ type = "checkbox", text = "Cache Friendly Units", key = "FU", default = true },
			{ type = "checkbox", text = "Cache Enemies Units", key = "EU", default = true },
			{ type = "checkbox", text = "Cache Dummys Units", key = "dummys", default = true },
			{ type = "spinner", text = "Cache Distance:", key = "CD", width = 90, min = 10, max = 200, default = 100, step = 5},
			{ type = "button", text = "Objects List", width = 190, height = 20, callback = function() NeP.Interface.OMGUI() end },
    }
})