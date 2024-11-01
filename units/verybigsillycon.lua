
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

return
    utils.copy_tweak("bigsillycon","verybigsillycon",utils.table_replace(
        {
            metalCost=4000,
            health=12000,
            workertime=80,
            name="Very Very Silly Con",
            customParams={
                def_scale=2
            }
        }
    ))
--{["bigsillycon"]=ud}\