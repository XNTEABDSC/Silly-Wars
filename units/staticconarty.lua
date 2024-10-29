VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

return utils.copy_tweak_silly_build_morth("staticcontanky","staticconarty","bigsillycon",utils.table_replace({
    name                          = [[Long-Range Caretaker]],
    description                   = [[Long-Range Construction Assistant]],
    health=3000,
    metalCost=5000,
    buildDistance=5600,
    workerTime                    = 150,

    explodeAs                     = [[ATOMIC_BLAST]],
    selfDestructAs                = [[ATOMIC_BLAST]],
    customParams={
        def_scale=3
    },
    buildoptions=utils.table_replace_nil
}))