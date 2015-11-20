local ConfigWindow
local NeP_OpenConfigWindow = false
local NeP_ShowingConfigWindow = false
local _acSpell, _acTable = nil, nil
local acCraft_Run = false
local _tsText, _tsID, _tsNumber = nil, nil, nil
local _smelt_Run = false
--local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(_smeltingTable[i].ID)

NeP.Core.BuildGUI('itemBot', {
	key = 'NePItemConf',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..' '..NeP.Info.Nick,
	subtitle = 'ItemBot Settings',
	color = NeP.Interface.addonColor,
	width = 250,
	height = 350,
	config = {
		{ type = 'header', text = '|cff'..NeP.Interface.addonColor..'Item Bot:', size = 25,align = 'Center' },
		{ type = 'text', text = 'Requires to have both '..NeP.Info.Nick..' selected on PE & Master Toggle enabled.', align = 'Center' },
		{ type = 'rule' },{ type = 'spacer' },
		-- Open Salvage
		{  type = 'checkbox',  text = 'Auto Open Salvage',  key = 'OpenSalvage',  default = false },
		{ type = 'rule' },{ type = 'spacer' },
		-- Mill
		{ type = 'button', text = 'Start Milling', width = 230, height = 20, callback = function(self, button)
			local _herbsTable = {
				-- WoD
				{ ID = 109124, Name = 'Frostweed', Number = 5 },
				{ ID = 109125, Name = 'Fireweed', Number = 5 },
				{ ID = 109126, Name = 'Gorgrond Flytrap', Number = 5 },
				{ ID = 109127, Name = 'Starflower', Number = 5 },
				{ ID = 109128, Name = 'Nagrand ArRowbloom', Number = 5 },
				{ ID = 109129, Name = 'Talador Orchid', Number = 5 }
			}
			_acSpell, _acTable = 51005, _herbsTable
			acCraft_Run = true
		end},
		-- Prospect
		{ type = 'button', text = 'Start Prospecting', width = 230, height = 20, callback = function(self, button)
				local _oresTable = {
				{ ID = 72092, Name = 'Ghost Iron Ore', Number = 5 },
				{ ID = 52183, Name = 'Pyrite', Number = 5 },
				{ ID = 52183, Name = 'Pyrite', Number = 5 },
				{ ID = 52185, Name = 'Elementium', Number = 5 },
				{ ID = 53038, Name = 'Obsidium', Number = 5 },
				{ ID = 53038, Name = 'Obsidium', Number = 5 },
				{ ID = 36910, Name = 'Titanium', Number = 5 },
				{ ID = 36912, Name = 'Saronite', Number = 5 },
				{ ID = 23426, Name = 'Khorium', Number = 5 },
				{ ID = 23446, Name = 'Hardened Adamantite', Number = 5 },
				{ ID = 36909, Name = 'Cobalt', Number = 5 },
				{ ID = 23427, Name = 'Eternium', Number = 5 },
				{ ID = 23425, Name = 'Adamantite', Number = 5 },
				{ ID = 23424, Name = 'Fel Iron', Number = 5 },
				{ ID = 10620, Name = 'Thorium', Number = 5 },
				{ ID = 7911, Name = 'Truesilver', Number = 5 },
				{ ID = 3858, Name = 'Mithril', Number = 5 },
				{ ID = 2776, Name = 'Gold', Number = 5 },
				{ ID = 2772, Name = 'Iron', Number = 5 },
				{ ID = 2775, Name = 'Silver', Number = 5 },
				{ ID = 2771, Name = 'Tin', Number = 5 },
				{ ID = 2770, Name = 'Copper', Number = 5 }
			}
			_acSpell, _acTable = 31252, _oresTable
			acCraft_Run = true
		end},
		-- Smelting // REQUIRES TWEAKING ( SOME RECIPES REQUIRE 2 MATS )
		{ type = 'button', text = 'Start Smelting', width = 230, height = 20, callback = function(self, button)
			if GetProfessionInfo(8) ~= nil then
				local _allRows = GetNumTradeSkills()
				Cast(2656)
				for i=1, _allRows do
					local _iteamName, _, _itemRepeatTimes = GetTradeSkillInfo(i)
					if IsTradeSkillReady(i) then
						if _itemRepeatTimes > 0 then
							NeP.Core.Print('Smelting: '.._iteamName..' '.._itemRepeatTimes..' times.')
							SelectTradeSkill(i)
							DoTradeSkill(i, _itemRepeatTimes)
							self:SetText('Stop Smelting: ('.._iteamName..GetTradeskillRepeatCount()..')')
							break
						elseif (i == _allRows) and (_itemRepeatTimes == 0) then
							StopTradeSkillRepeat()
							self:SetText('You dont have enough mats.')
							CloseTradeSkill()
						end
					end
				end
			end
		end},
		{ type = 'rule' },{ type = 'spacer' },
		{ type = 'button', text = '!Stop', width = 230, height = 20, callback = function(self, button) 
			acCraft_Run = false 
			_smelt_Run = false
		end},
		
	},
})

local function _autoCraft(spell, _table)
	if acCraft_Run then
		local _craftID = 0
		local _craftName = 0
		local _craftNumber = 0
		local _craftRunning = false
		if IsSpellKnown(spell) then
			for i=1,#_table do
				if _craftID == 0 then
					if GetItemCount(_table[i].ID, false, false) >= _table[i].Number then
						_craftID = _table[i].ID
						_craftName = _table[i].Name
						_craftNumber = _table[i].Number
						_craftRunning = true
						break
					elseif _table[#_table] and GetItemCount(_table[i].ID, false, false) >= _table[i].Number then
						NeP.Core.Print('Stoped crafting, you dont have enough mats.')
						acCraft_Run = false
					end
				end
			end
		else
			NeP.Core.Print('Failed, you dont have the required spell.')
			_craftID = 0
			acCraft_Run = false
		end
		if _craftRunning then
			if GetItemCount(_craftID, false, false) >= _craftNumber then
				Cast(spell) 
				UseItem(_craftID)
				NeP.Core.Print('Crafting: '.._craftName)
			else	
				NeP.Core.Print('Stoped crafting, you ran out of mats.')
				acCraft_Run = false
			end
		end
	end
end

function NeP.Core.OpenSalvage()
	local _salvageTable = {
		{ ID = 114116, Name = 'Bag of Salvaged Goods' },
		{ ID = 114119, Name = 'Crate of Salvage' },
		{ ID = 114120, Name = 'Big Crate of Salvage' }
	}
	for i=1,#_salvageTable do
		local _item = _salvageTable[i]
		if NeP.Core.PeFetch('NePItemConf', 'OpenSalvage') then
			-- Bag of Salvaged Goods
			if GetItemCount(_item.ID, false, false) > 0 then
				NeP.Core.Print('Open Salvage: '.._item.Name)
				UseItem(_item.ID)
			end
		end
	end
end

C_Timer.NewTicker(0.5, (function()
	if NeP.Core.CurrentCR then
		if not ProbablyEngine.module.player.combat then
			if not UnitChannelInfo('player') then
				if NeP.Core.BagSpace() > 2 then
					_autoCraft(_acSpell, _acTable)
					NeP.Core.OpenSalvage()
				end
			end
		end
	end
end), nil)
