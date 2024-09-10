fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'Jayson Liu'
description '小偷插件（盗窃快递包裹）'
version '1.0.0'

shared_scripts {
    'locales/cn.lua',
    'locales/*.lua',
    'config/config.lua',
    'config/*.lua',
}

client_scripts {
    'client/main.lua',
    'client/vehicles.lua',
}

server_scripts {
    'server/main.lua',
    'server/functions.lua',
}

files {
    'images/*.png',
}

dependency 'qb-target'
