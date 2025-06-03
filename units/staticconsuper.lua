VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("staticconarty","staticconsuper",utils.table_replace({
    name                          = [[Invisible big hand]],
    description                   = [[Long-Range Nanoframe Projector. Can't reclaim]],
    health=8000,
    metalCost=30000,
    buildDistance=10000,
    workerTime                    = 400,
    customParams={
        def_scale=5
    },
    canReclaim=false,
    translations=[=[
    {
        en={
            name="Invisible big hand",
            description="Long-Range Nanoframe Projector. Can't reclaim",
            helptext="Invisible big hand is a superweapon about buildpower. It can build and repair at a long distance.",
        }
    }
    ]=]
}))