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
    'html/mapStyles/styleAtlas/0/*.jpg',
    'html/mapStyles/styleAtlas/1/0/*.jpg',
    'html/mapStyles/styleAtlas/1/1/*.jpg',
    'html/mapStyles/styleAtlas/2/0/*.jpg',
    'html/mapStyles/styleAtlas/2/1/*.jpg',
    'html/mapStyles/styleAtlas/2/2/*.jpg',
    'html/mapStyles/styleAtlas/2/3/*.jpg',
    'html/mapStyles/styleAtlas/3/0/*.jpg',
    'html/mapStyles/styleAtlas/3/1/*.jpg',
    'html/mapStyles/styleAtlas/3/2/*.jpg',
    'html/mapStyles/styleAtlas/3/3/*.jpg',
    'html/mapStyles/styleAtlas/3/4/*.jpg',
    'html/mapStyles/styleAtlas/3/5/*.jpg',
    'html/mapStyles/styleAtlas/3/6/*.jpg',
    'html/mapStyles/styleAtlas/3/7/*.jpg',
    'html/mapStyles/styleAtlas/4/0/*.jpg',
    'html/mapStyles/styleAtlas/4/1/*.jpg',
    'html/mapStyles/styleAtlas/4/2/*.jpg',
    'html/mapStyles/styleAtlas/4/3/*.jpg',
    'html/mapStyles/styleAtlas/4/4/*.jpg',
    'html/mapStyles/styleAtlas/4/5/*.jpg',
    'html/mapStyles/styleAtlas/4/6/*.jpg',
    'html/mapStyles/styleAtlas/4/7/*.jpg',
    'html/mapStyles/styleAtlas/4/8/*.jpg',
    'html/mapStyles/styleAtlas/4/9/*.jpg',
    'html/mapStyles/styleAtlas/4/10/*.jpg',
    'html/mapStyles/styleAtlas/4/11/*.jpg',
    'html/mapStyles/styleAtlas/4/12/*.jpg',
    'html/mapStyles/styleAtlas/4/13/*.jpg',
    'html/mapStyles/styleAtlas/4/14/*.jpg',
    'html/mapStyles/styleAtlas/4/15/*.jpg',
    'html/mapStyles/styleAtlas/5/0/*.jpg',
    'html/mapStyles/styleAtlas/5/1/*.jpg',
    'html/mapStyles/styleAtlas/5/2/*.jpg',
    'html/mapStyles/styleAtlas/5/3/*.jpg',
    'html/mapStyles/styleAtlas/5/4/*.jpg',
    'html/mapStyles/styleAtlas/5/5/*.jpg',
    'html/mapStyles/styleAtlas/5/6/*.jpg',
    'html/mapStyles/styleAtlas/5/7/*.jpg',
    'html/mapStyles/styleAtlas/5/8/*.jpg',
    'html/mapStyles/styleAtlas/5/9/*.jpg',
    'html/mapStyles/styleAtlas/5/10/*.jpg',
    'html/mapStyles/styleAtlas/5/11/*.jpg',
    'html/mapStyles/styleAtlas/5/12/*.jpg',
    'html/mapStyles/styleAtlas/5/13/*.jpg',
    'html/mapStyles/styleAtlas/5/14/*.jpg',
    'html/mapStyles/styleAtlas/5/15/*.jpg',
    'html/mapStyles/styleAtlas/5/16/*.jpg',
    'html/mapStyles/styleAtlas/5/17/*.jpg',
    'html/mapStyles/styleAtlas/5/18/*.jpg',
    'html/mapStyles/styleAtlas/5/19/*.jpg',
    'html/mapStyles/styleAtlas/5/20/*.jpg',
    'html/mapStyles/styleAtlas/5/21/*.jpg',
    'html/mapStyles/styleAtlas/5/22/*.jpg',
    'html/mapStyles/styleAtlas/5/23/*.jpg',
    'html/mapStyles/styleAtlas/5/24/*.jpg',
    'html/mapStyles/styleAtlas/5/25/*.jpg',
    'html/mapStyles/styleAtlas/5/26/*.jpg',
    'html/mapStyles/styleAtlas/5/27/*.jpg',
    'html/mapStyles/styleAtlas/5/28/*.jpg',
    'html/mapStyles/styleAtlas/5/29/*.jpg',
    'html/mapStyles/styleAtlas/5/30/*.jpg',
    'html/mapStyles/styleAtlas/5/31/*.jpg',
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