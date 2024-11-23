VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorph("staticconarty","staticconsuper",utils.table_replace({
    name                          = [[Super Caretaker]],
    description                   = [[Solve caretakers problem]],
    health=4000,
    metalCost=20000,
    buildDistance=10000,
    workerTime                    = 200,
    customParams={
        def_scale=5
    },
}))