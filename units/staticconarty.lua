VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("staticcontanky","staticconarty",utils.table_replace({
    name                          = [[Long-Range Caretaker]],
    description                   = [[Long-Range Construction Assistant]],
    health=1000,
    metalCost=1000,
    buildDistance=1200,
    workerTime                    = 20,

    explodeAs                     = [[ATOMIC_BLAST]],
    selfDestructAs                = [[ATOMIC_BLAST]],
    customParams={
        def_scale=2,
        integral_menu_be_in_tab=utils.None
    },
    buildoptions=utils.None,
    translations=[=[
    {
        en={
            name="Long-Range Caretaker",
            description="Long-Range Construction Assistant",
            helptext="Long-Range Caretaker",
        }
    }
    ]=]
}))