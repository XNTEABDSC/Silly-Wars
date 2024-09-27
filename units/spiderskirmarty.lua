VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things


utils.set_morth_mul("silly_morth","spiderskirm","spiderskirmarty")
utils.add_build("silly_build","sillycon","spiderskirmarty")


return utils.copy_tweak("spiderskirm","spiderskirmarty",function (ud)
    ud.name="Ranged " .. ud.name
    ud.description="Ranged " .. ud.description
    ud.speed=ud.speed*0.85
    ud.metalCost=ud.metalCost*2.5
    ud.health=ud.health*1.75
    ud.weaponDefs.ADV_ROCKET.range=1200
    ud.customParams.def_scale=(ud.customParams.def_scale or 1)*1.75
    ud.customParams.tactical_ai_defs_copy="veharty"
    utils.set_ded_BIG_UNIT(ud)
end)