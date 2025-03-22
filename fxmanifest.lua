fx_version 'cerulean'
game 'gta5'
lua54 'yes'

version '1.0.0'


shared_scripts {
	'@ox_lib/init.lua',
}


client_scripts {
    "tools/client/**",
    "configs/**",

    "properties/shared/**/**",
    "properties/client/doors/*.lua",
    "properties/client/*.lua",
    "properties/client/shell/*.lua",
    "properties/client/classes/**",
    "properties/client/managers/**",
    "properties/client/utils/**",
    "properties/client/managers/**",

    "realtor/client/**/**",

    "properties/bridge/*.lua",
    "properties/bridge/multi/client/**",
    "properties/bridge/ox/client/**/**",
}



server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "database/*lua",

    "configs/**",
    "properties/shared/**/**",
    "properties/server/*.lua",
    "properties/server/classes/**",
    "properties/server/managers/**",
    "properties/server/utils/**",

    "realtor/server/**",

    "properties/bridge/*.lua",
    "properties/bridge/multi/server/**",
    "properties/bridge/ox/server/**/**",
}



ui_page 'realtor/html/index.html'

files {
	"realtor/html/**/**",
}