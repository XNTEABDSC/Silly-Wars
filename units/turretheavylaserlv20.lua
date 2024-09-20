VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local op=GG.to_make_very_op_things
utils.set_morth_mul("silly_morth","turretheavylaser","turretheavylaserlv20")
return utils.copy_tweak("turretheavylaser","turretheavylaserlv20",function (ud)
    op.units_level_up(ud,op.units_level_up_table,20)
    ud.name=ud.name .. " Lv 20"
    ud.description = "Lv 20 " .. ud.description
    ud.metalCost=3500
end)