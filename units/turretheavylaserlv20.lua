Spring.Echo("turretheavylaserlv20.lua")

VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeSetSillyBuildMorphBig("turretheavylaser","turretheavylaserlv20")
return utils_op.CopyTweak("turretheavylaser","turretheavylaserlv20",function (ud)
    to_make_very_op_things.units_level_up(ud,to_make_very_op_things.units_level_up_table,20)
    ud.name=ud.name .. " Lv 20"
    ud.description = "Lv 20 " .. ud.description
    ud.metalCost=4250
    ud.iconType="turretheavylaserlv20"
end)