fx_version 'cerulean'
game 'gta5'
author 'oph3z'
description 'Advanced dispatch system | Made by codeReal'

ui_page {
	'html/index.html',
}

files {
    'html/index.html',
    'html/app.js',
    'html/style.css',
    'html/img/*.png',
    'html/img/*.jpg',
    'html/fonts/*.otf',
}

shared_script{
    'config/config.lua',
    'GetFrameworkObject.lua',
}

client_scripts {
    'config/config_client.lua',
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

lua54 'yes'