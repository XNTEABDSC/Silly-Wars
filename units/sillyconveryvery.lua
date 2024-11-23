VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return
    utils_op.CopyTweak("sillyconvery","sillyconveryvery",utils.table_replace(
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