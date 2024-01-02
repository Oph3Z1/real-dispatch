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
    'config.lua',
    'GetFrameworkObject.lua',
}

client_scripts {
    'client/*.lua',
}

server_scripts {
	-- '@mysql-async/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'mysql-async'.⚠️
    '@oxmysql/lib/MySQL.lua', --⚠️PLEASE READ⚠️; Uncomment this line if you use 'oxmysql'.⚠️
    'server/*.lua',
}

lua54 'yes'