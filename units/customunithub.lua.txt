VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweak("striderhub","customunithub",function (ud)
    ud.name="Custom Unit Hub"
    ud.description="Build Custom Unit"

    ud.customParams.custom_unit_is_custom_unit_builder=1
    ud.buildoptions=nil
end)
--customunithub

