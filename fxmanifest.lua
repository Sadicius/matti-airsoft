fx_version("cerulean")
game("gta5")

author("MattiVboiii")
description("Simple & basic airsoft script")
version("1.1.0")

lua54("yes")

client_scripts({
	"client.lua",
	"@PolyZone/client.lua",
	"@PolyZone/CircleZone.lua",
})

server_scripts({
	"server.lua",
})

shared_scripts({
	"config.lua",
	"@qb-core/shared/locale.lua",
	"locales/*.lua",
	"@ox_lib/init.lua",
})
