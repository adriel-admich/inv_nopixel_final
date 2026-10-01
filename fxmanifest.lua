fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'inv_nopixel_final'
author 'adriel-admich'
description 'Inventário inspirado em NoPixel com compatibilidade Qbox/ox_inventory'
version '1.0.0'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/items.lua'
}

client_scripts {
    'client/main.lua',
    'client/utils.lua'
}

server_scripts {
    'server/bridge.lua',
    'server/main.lua'
}

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

dependencies {
    'ox_lib'
}
