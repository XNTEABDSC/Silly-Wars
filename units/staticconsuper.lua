VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

return utils.copy_tweak_silly_build_morth("staticconarty","staticconsuper","verybigsillycon",utils.table_replace({
    name                          = [[Super Caretaker]],
    description                   = [[Solve caretakers problem]],
    health=4000,
    metalCost=15000,
    buildDistance=10000,
    workerTime                    = 400,
    customParams={
        def_scale=5
    },
}))