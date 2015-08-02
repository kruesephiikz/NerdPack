NeP.Addon.Interface.DruidBalance = {
	key = "npconfDruidBalance",
	profiles = true,
	title = NeP.Addon.Info.Icon.."MrTheSoulz Config",
	subtitle = "Druid Balance Settings",
	color = NeP.Core.classColor('player'),
	width = 250,
	height = 500,
	config = {
		
		-- General
		{ type = 'rule' },
		{ type = 'header', text = "General settings:", align = "center"},

			-- Buff
			{ type = "checkbox", text = "Buffs", key = "Buffs", default = true, desc =
			 "This checkbox enables or disables the use of automatic buffing."},

			{ 
		      	type = "dropdown",
		      	text = "Form", 
		      	key = "Form", 
		      	list = {
			        {
			          text = "Cat",
			          key = "2"
			        },
			        {
			          text = "Bear",
			          key = "1"
			        },
			        {
			          text = "Travel",
			          key = "3"
			        },
			        {
			          text = "Boomkin",
			          key = "4"
			        },
			        {
			          text = "Normal",
			          key = "0"
			        },
			        {
			          text = "MANUAL",
			          key = "MANUAL"
			        }
			    }, 
		    	default = "4", 
		    	desc = "Select What form to use while in of combat" 
		    },
			{ 
		      	type = "dropdown",
		      	text = "Form OOC", 
		      	key = "FormOCC", 
		      	list = {
			        {
			          text = "Cat",
			          key = "2"
			        },
			        {
			          text = "Bear",
			          key = "1"
			        },
			        {
			          text = "Travel",
			          key = "3"
			        },
			        {
			          text = "Boomkin",
			          key = "4"
			        },
			        {
			          text = "Normal",
			          key = "0"
			        },
			        {
			          text = "MANUAL",
			          key = "MANUAL"
			        }
			    }, 
		    	default = "4", 
		    	desc = "Select What form to use while out of combat" 
		    },

	}
}