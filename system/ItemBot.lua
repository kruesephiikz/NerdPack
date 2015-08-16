local ConfigWindow
local NeP_OpenConfigWindow = false
local NeP_ShowingConfigWindow = false
local _acSpell, _acTable = nil, nil
local acCraft_Run = false

NeP.Addon.Interface.Items = {
	key = "NePItemConf",
	profiles = true,
	title = NeP.Addon.Info.Icon.." "..NeP.Addon.Info.Nick,
	subtitle = "Fising Settings",
	color = NeP.Addon.Interface.GuiColor,
	width = 250,
	height = 350,
	config = {
		{ type = 'header', text = NeP.Addon.Interface.GuiTextColor.."Item Bot:", size = 25,align = "Center" },
		{ type = 'text', text = "Requires to have both "..NeP.Addon.Info.Nick..' selected on PE & Master Toggle enabled.', align = "Center" },
		{ type = 'rule' },{ type = 'spacer' },
		-- Open Salvage
		{  type = "checkbox",  text = "Auto Open Salvage",  key = "OpenSalvage",  default = false },
		{ type = 'rule' },{ type = 'spacer' },
		-- Mill
		{ type = "button", text = "Start Milling", width = 230, height = 20, callback = function(self, button)
			acCraft_Run = not acCraft_Run
			if acCraft_Run then
				local _table = {
					-- WoD
					{ ID = 109124, Name = 'Frostweed', Number = 5 },
					{ ID = 109125, Name = 'Fireweed', Number = 5 },
					{ ID = 109126, Name = 'Gorgrond Flytrap', Number = 5 },
					{ ID = 109127, Name = 'Starflower', Number = 5 },
					{ ID = 109128, Name = 'Nagrand Arrowbloom', Number = 5 },
					{ ID = 109129, Name = 'Talador Orchid', Number = 5 }
				}
				_acSpell, _acTable = 51005, _table
			end
		end},
		-- Prospect
		{ type = "button", text = "Start Prospecting", width = 230, height = 20, callback = function(self, button)
			acCraft_Run = not acCraft_Run
			if acCraft_Run then
				local _table = {
					-- MoP
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
				_acSpell, _acTable = 31252, _table
			end
		end},
		-- Smelting // REQUIRES TWEAKING ( SOME RECIPES REQUIRE 2 MATS )
		{ type = "button", text = "Start Smelting", width = 230, height = 20, callback = function(self, button)
			acCraft_Run = not acCraft_Run
			if acCraft_Run then
				local _table = {
					{ ID = 72092, Name = 'Ghost Iron Ore', Number = 5 },
					{ ID = 52183, Name = 'Pyrite', Number = 2 },
					{ ID = 52183, Name = 'Pyrite', Number = 2 },
					{ ID = 52185, Name = 'Elementium', Number = 2 },
					{ ID = 53038, Name = 'Obsidium', Number = 2 },
					{ ID = 53038, Name = 'Obsidium', Number = 2 },
					{ ID = 36910, Name = 'Titanium', Number = 2 },
					{ ID = 36912, Name = 'Saronite', Number = 2 },
					{ ID = 23426, Name = 'Khorium', Number = 2 },
					{ ID = 23446, Name = 'Hardened Adamantite', Number = 10 },
					{ ID = 36909, Name = 'Cobalt', Number = 1 },
					{ ID = 23427, Name = 'Eternium', Number = 2 },
					{ ID = 23425, Name = 'Adamantite', Number = 2 },
					{ ID = 23424, Name = 'Fel Iron', Number = 2 },
					{ ID = 10620, Name = 'Thorium', Number = 1 },
					{ ID = 7911, Name = 'Truesilver', Number = 1 },
					{ ID = 3858, Name = 'Mithril', Number = 1 },
					{ ID = 2776, Name = 'Gold', Number = 1 },
					{ ID = 2772, Name = 'Iron', Number = 1 },
					{ ID = 2775, Name = 'Silver', Number = 1 },
					{ ID = 2771, Name = 'Tin', Number = 1 },
					{ ID = 2770, Name = 'Copper', Number = 1 }
				}
				_acSpell, _acTable = 2656, _table
			end
		end},
	},
}

function NeP.Addon.Interface.itemsBotGUI()
	-- If a frame has not been created, create one...
	if not NeP_OpenConfigWindow then
		ConfigWindow = NeP.Core.PeBuildGUI(NeP.Addon.Interface.Items)
		-- This is so the window isn't opened twice :D
		NeP_OpenConfigWindow = true
		NeP_ShowingConfigWindow = true
		ConfigWindow.parent:SetEventListener('OnClose', function()
			NeP_OpenConfigWindow = false
			NeP_ShowingConfigWindow = false
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

function NeP.Extras.autoCraft(spell, number, _table)
	if acCraft_Run then
		local _craftID = 0
		local _craftName = 0
		local _craftNumber = 0
		local _craftRunning = false
		if IsSpellKnown(spell) then
			for i=1,#_table do
				local _item = _table[i]
				if _craftID == 0 then
					if GetItemCount(_item.ID, false, false) >= _item.Number then
						_craftID = _item.ID
						_craftName = _item.Name
						_craftNumber = _item.Number
						_craftRunning = true
						break
					else
						NeP.Core.Print('Stoped crafting, you dont have enough mats.')
						acCraft_Run = false
						break
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

function NeP.Extras.OpenSalvage()
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
	if NeP.Core.CurrentCR and NeP.Core.PeConfig.read('button_states', 'MasterToggle', false) then
		if not ProbablyEngine.module.player.combat then
			if not UnitChannelInfo("player") then
				if NeP.Extras.BagSpace() > 2 then
					NeP.Extras.autoCraft(_acSpell, _acSpeNum, _acTable)
					NeP.Extras.OpenSalvage()
				end
			end
		end
	end
end), nil)
