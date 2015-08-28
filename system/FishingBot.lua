local OBJECT_BOBBING_OFFSET = 0x1e0
local OBJECT_CREATOR_OFFSET = 0x30
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
			text = "Use Fishing Hat", 
			key = "FshHat", 
			default = true, 
		},
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
				{text = "None", key = "none"},	
				{text = "Jawless Skulker", key = "jsb"},
				{text = "Fat Sleeper", key = "fsb"},
				{text = "Blind Lake Sturgeon", key = "blsb"},
				{text = "Fire Ammonite", key = "fab"},
				{text = "Sea Scorpion", key = "ssb"},
				{text = "Abyssal Gulper Eel", key = "ageb"},
				{text = "Blackwater Whiptail", key = "bwb"},
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
	NeP.Core.BuildGUI('fishing', NeP.Interface.Fishing)
end

local function GetObjectGUID(object)
  return tonumber(ObjectDescriptor(object, 0, Types.ULong))
end

local function IsObjectCreatedBy(owner, object)
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

local WormSpellID, WormItemID, nexttry = 5386, 118391, 0
local function _WormSupreme()
	if NeP.Core.PeFetch('NePFishingConf', 'WormSupreme') and GetTime() > nexttry then
		if select(7, GetItemInfo(GetInventoryItemLink("player", 16))) == "Fishing Poles" then
			local hasEnchant, timeleft, _, enchantID = GetWeaponEnchantInfo()
			if hasEnchant and timeleft / 1000 > 20 and enchantID == WormSpellID then return end
			nexttry = GetTime() + 5 -- it seems to be chain casting it otherwise :S
			UseItem(WormItemID)
		end
	end
end

local function _findHats()
	local hatsTable = {
		[1] = { Name = "Lucky Fishing Hat", ID = 19972, Bonus = 5 },
		[2] = { Name = "Nat's Hat", ID = 88710, Bonus = 5 },
		[3] = { Name = "Darkmoon Fishing Cap", ID = 93732, Bonus = 5 },
		[4] = { Name = "Nat's Drinking Hat", ID = 117405, Bonus = 10  },
		[5] = { Name = "Hightfish Cap", ID = 118380, Bonus = 100 },
		[6] = { Name = "Tentacled Hat", ID = 118393, Bonus = 100 },
	}
	local hatsFound = {}
	for i = 1, #hatsTable do
		if GetItemCount(hatsTable[i].ID, false, false) > 0 then
			hatsFound[#hatsFound+1] = {
				ID = hatsTable[i].ID,
				Name = hatsTable[i].Name,
				Bonus = hatsTable[i].Bonus
			}
		end
	end
	table.sort(hatsFound, function(a,b) return a.Bonus < b.Bonus end)
	return hatsFound
end

local function _equitHat()
	if NeP.Core.PeFetch('NePFishingConf', 'FshHat') then
		local hatsFound = _findHats()
		if #hatsFound > 0 then
			local headItemID = GetInventoryItemID("player", 1)
			local bestHat = hatsFound[1]
			if headItemID ~= bestHat then
				NeP.Extras.pickupItem(bestHat)
				AutoEquipCursorItem()
			end
		end
	end
end

local function _AutoBait()
	if NeP.Core.PeFetch('NePFishingConf', 'bait') ~= "none" or NeP.Core.PeFetch('NePFishingConf', 'bait') ~= nil then
		local _baitsTable = {
			['jsb'] = { ID = 110274, Debuff = 158031, Name = 'Jawless Skulker Bait' },
			['fsb'] = { ID = 110289, Debuff = 158034, Name = 'Fat Sleeper Bait' },
			['blsb'] = { ID = 110290, Debuff = 158035, Name = 'Blind Lake Sturgeon Bait' },
			['fab'] = { ID = 110291, Debuff = 158036, Name = 'Fire Ammonite Bait' },
			['ssb'] = { ID = 110292, Debuff = 158037, Name = 'Sea Scorpion Bait' },
			['ageb'] = { ID = 110293, Debuff = 158038, Name = 'Abyssal Gulper Eel Bait' },
			['bwb'] = { ID = 110294, Debuff = 158039, Name = 'Blackwater Whiptail Bait' }
		}
		if _baitsTable[NeP.Core.PeFetch('NePFishingConf', 'bait')] ~= nil then
			local _Bait = _baitsTable[NeP.Core.PeFetch('NePFishingConf', 'bait')]
			if GetItemCount(_Bait.ID, false, false) > 0 and not UnitBuff("player", GetSpellInfo(_Bait.Debuff)) then
				NeP.Core.Print('Used Bait: '.._Bait.ID)
				NeP.Core.Print('Used Bait: '.._Bait.Name)
				UseItem(_Bait.ID)
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
			_CarpDestruction()
			if _fishRun then
				_equitHat()
				_AutoBait()
				_WormSupreme()
				if FireHack then
					-- Only Works with FH atm...
					_startFish()
				end
			end
		end
	end
end), nil)
