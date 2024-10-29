VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
local op=Spring.Utilities.to_make_very_op_things
utils.set_morth_mul("silly_morth","turretheavylaser","turretheavylaserlv20")
utils.add_build("silly_build","bigsillycon","turretheavylaserlv20")
return utils.copy_tweak("turretheavylaser","turretheavylaserlv20",function (ud)
    op.units_level_up(ud,op.units_level_up_table,20)
    ud.name=ud.name .. " Lv 20"
    ud.description = "Lv 20 " .. ud.description
    ud.metalCost=4250
    ud.iconType="turretheavylaserlv20"
end)