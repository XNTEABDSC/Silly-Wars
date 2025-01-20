VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("staticconarty","staticconsuper",utils.table_replace({
    name                          = [[Nanoframe Projector]],
    description                   = [[Throw BP. Can't reclaim]],
    health=8000,
    metalCost=30000,
    buildDistance=10000,
    workerTime                    = 400,
    customParams={
        def_scale=5
    },
    canReclaim=false,
}))