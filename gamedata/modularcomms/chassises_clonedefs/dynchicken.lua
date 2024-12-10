
VFS.Include("LuaRules/Utilities/wacky_utils.lua")

local utils=Spring.Utilities.wacky_utils
local nomainstates={
    collisionvolumescales=true,
    modelradius=true,
    explodeas=true,
    selfdestructas=true,
    footprintx=true,
    footprintz=true,
    movementclass=true
}
return {
    dynchicken1 = {
		dynchicken0 = {
			level = 0,
			customparams = {shield_emit_height = 30},
            nomainstats=nomainstates,
		},
		dynchicken2 = {
			level = 2,
			mainstats = {health = 4600},
			customparams = {def_scale=1.1},
            nomainstats=nomainstates,
		},
		dynchicken3 = {
			level = 3,
			mainstats = {health = 5200},
			customparams = {def_scale=1.2},
            nomainstats=nomainstates,
		},
		dynchicken4 = {
			level = 4,
			mainstats = {health = 5800},
			customparams = {def_scale=1.3},
            nomainstats=nomainstates,
		},
		dynchicken5 = {
			level = 5,
			mainstats = {health = 6400},
			customparams = {def_scale=1.4},
            nomainstats=nomainstates,
		},
	},
}