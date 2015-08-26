local OBJECT_BOBBING_OFFSET = 0x1e0
local OBJECT_CREATOR_OFFSET = 0x30

local ConfigWindow
local NeP_OpenConfigWindow = false
local NeP_ShowingConfigWindow = false
local _fishRun = false

NeP.Interface.Fishing = {
	key = "NePFishingConf",
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'.." "..NeP.Info.Name,
	subtitle = "Fising Settings",
	color = NeP.Interface.addonColor,
	width = 250,
	height = 350,
	config = {
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor.."Fishing Bot:", size = 25, align = "Center"},
		{ type = 'text', text = "Requires FireHack and to have both "..NeP.Info.Nick..' selected on PE & Master Toggle enabled.', align = "Center" },
		{ type = 'rule' },{ type = 'spacer' },
		{
			type = "checkbox", 
			text = "Use Worm Supreme", 
			key = "WormSupreme", 
			default = true, 
		},
		{  
			type = "checkbox",  
			 text = "Use Sharpened Fish Hook",  
			 key = "SharpenedFishHook",  
			default = false,  
		},
		{  
			type = "checkbox",  
			text = "Destroy Lunarfall Carp",  
			key = "LunarfallCarp",  
			default = false,  
		},
		{ type = 'spacer' },
		{ 
			type = "dropdown",
			text = "Bait:", 
			key = "bait",
			width = 170,
			list = {
				{text = "None",key = "none"},	
				{text = "Jawless Skulker",key = "jsb"},
				{text = "Fat Sleeper",key = "fsb"},
				{text = "Blind Lake Sturgeon",key = "blsb"},
				{text = "Fire Ammonite",key = "fab"},
				{text = "Sea Scorpion",key = "ssb"},
				{text = "Abyssal Gulper Eel",key = "ageb"},
				{text = "Blackwater Whiptail",key = "bwb"},
			}, 
			default = "none" 
		},
		{ type = 'rule' },{ type = 'spacer' },
		{ type = "button", text = "Start Fishing", width = 230, height = 20, callback = function(self, button)
			_fishRun = not _fishRun
			if _fishRun then
				self:SetText("Stop Fishing")
			else
				self:SetText("Start Fishing")
			end
		end},
	}
}

function NeP.Interface.FishingGUI()
	-- If a frame has not been created, create one...
	if not NeP_OpenConfigWindow then
		ConfigWindow = NeP.Core.PeBuildGUI(NeP.Interface.Fishing)
		-- This is so the window isn't opened twice :D
		NeP_OpenConfigWindow = true
		NeP_ShowingConfigWindow = true
		ConfigWindow.parent:SetEventListener('OnClose', function()
			NeP_OpenConfigWindow = false
			NeP_ShowingConfigWindow = false
			_fishRun = false
		end)
	
	-- If a frame has been created and its showing, hide it.
	elseif NeP_OpenConfigWindow == true and NeP_ShowingConfigWindow == true then
		ConfigWindow.parent:Hide()
		NeP_ShowingConfigWindow = false
	
	-- If a frame has been created and its hiding, show it.
	elseif NeP_OpenConfigWindow == true and NeP_ShowingConfigWindow == false then
		ConfigWindow.parent:Show()
		NeP_ShowingConfigWindow = true
	
	end
end

function GetObjectGUID(object)
  return tonumber(ObjectDescriptor(object, 0, Types.ULong))
end

function IsObjectCreatedBy(owner, object)
  return tonumber(ObjectDescriptor(object, OBJECT_CREATOR_OFFSET, Types.ULong)) == GetObjectGUID(owner)
end

local function getBobber()
	local BobberName = "Fishing Bobber"
	local BobberDescriptor = nil
	
	for i = 1, ObjectCount(TYPE_GAMEOBJECT) do
		local Object = ObjectWithIndex(i)
		local ObjectName = ObjectName(ObjectPointer(Object))

		if IsObjectCreatedBy("player", Object) then
			if ObjectName == BobberName then
				return Object
			end
		end

	end
end

local function _startFish()
	local BobberObject = getBobber()
	if BobberObject then
		local bobbing = ObjectField(getBobber(), OBJECT_BOBBING_OFFSET, Types.Short)
		if bobbing == 1 then
			ObjectInteract(getBobber())
		end
	else
		Cast(131474)
	end
end

local function _AutoBait()
	if NeP.Core.PeFetch('NePFishingConf', 'bait') ~= "none" then
		local _baitsTable = {
			{ ID = 110274, Debuff = 158031, Name = 'Jawless Skulker Bait', Key = 'jsb' },
			{ ID = 110289, Debuff = 158034, Name = 'Fat Sleeper Bait', Key = 'fsb' },
			{ ID = 110290, Debuff = 158035, Name = 'Blind Lake Sturgeon Bait', Key = 'blsb' },
			{ ID = 110291, Debuff = 158036, Name = 'Fire Ammonite Bait', Key = 'fab' },
			{ ID = 110292, Debuff = 158037, Name = 'Sea Scorpion Bait', Key = 'ssb' },
			{ ID = 110293, Debuff = 158038, Name = 'Abyssal Gulper Eel Bait', Key = 'ageb' },
			{ ID = 110294, Debuff = 158039, Name = 'Blackwater Whiptail Bait', Key = 'bwb' }
		}
		for i=1,#_baitsTable do
			local _Bait = _baitsTable[i]
			if NeP.Core.PeFetch('NePFishingConf', 'bait') == _Bait.Key then
				if GetItemCount(_Bait.ID, false, false) > 0 and not UnitBuff("player", GetSpellInfo(_Bait.Debuff)) then
					UseItem(_Bait.ID)
				end
			end
		end
	end
end

local function _CarpDestruction()
	if NeP.Core.PeFetch('NePFishingConf', 'LunarfallCarp') then
		NeP.Extras.deleteItem(116158, 0)
	end
end

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR then
		if NeP.Extras.BagSpace() > 2 then
			_AutoBait()
			_CarpDestruction()
			if _fishRun and FireHack then
				_startFish()
			end
		end
	end
end), nil)
