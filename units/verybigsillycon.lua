
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

return
    utils.copy_tweak("bigsillycon","verybigsillycon",utils.table_replace(
        {
            metalCost=5000,
            health=15000,
            workertime=100,
            name="Very Very Silly Con",
            customParams={
                def_scale=2
            }
        }
    ))
--{["bigsillycon"]=ud}\