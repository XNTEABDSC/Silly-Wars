VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweak("striderhub","customunithub",function (ud)
    ud.name="Custom Unit Hub"
    ud.description="Build Custom Unit"
    --- what max cost can it build (prepare for greed tech)
    ud.customParams.custom_unit_buildcost_range=100000

    ud.buildoptions=nil
end)
--customunithub

