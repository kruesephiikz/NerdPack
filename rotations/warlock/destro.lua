NeP.Interface.classGUIs[267] = {
	key = 'NePConfWarlockDestro',
	profiles = true,
	title = '|T'..NeP.Info.Logo..':10:10|t'..NeP.Info.Nick..' Config',
	subtitle = 'Warlock Destruction Settings',
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		{type = 'text', text = 'Keybinds', align = 'center'},		
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'DPS', align = 'center'},
			--stuff
		{type = 'spacer'},{type = 'rule'},
		{type = 'text', text = 'Survival', align = 'center'},
			--stuff
	}
}

local exeOnLoad = function()
	NeP.Splash()
end

local Shared = {
	
}

local Cooldowns = {
	
}

local Moving = {
	
}

local inCombat = {
	
}

local outCombat = {
	{Shared},
}

ProbablyEngine.rotation.register_custom(267, NeP.Core.GetCrInfo('Warlock - Destruction'),
	{ -- In-Combat
		{Shared},
		{Moving, "player.moving"},
		{{ -- Conditions
			{Cooldowns, "modifier.cooldowns"},
			{inCombat}
		}, "!player.moving" },
	},outCombat, exeOnLoad)