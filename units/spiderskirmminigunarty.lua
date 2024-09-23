VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

local ud=utils.get_unit_lua("spiderskirm")
ud.metalCost=ud.metalCost*10
ud.health=ud.health*7

local wd=ud.weaponDefs.ADV_ROCKET
wd.burst=nil
wd.burstrate=nil
wd.reloadtime=0.1666
ud.speed=ud.speed*0.9
ud.name=ud.name .. " Minigun"
ud.customParams.def_scale=2.5
ud.customParams.tactical_ai_defs_copy="spiderskirm"

utils.set_morth_mul("silly_morth","spiderskirmminigun","spiderskirmminigunarty")
utils.add_build("silly_build","bigsillycon","spiderskirmminigunarty")


return utils.copy_tweak("spiderskirmminigun","spiderskirmminigunarty",function (ud)
    ud.name="Ranged " .. ud.name
    ud.description="Ranged " .. ud.description
    ud.speed=ud.speed*0.85
    ud.metalCost=ud.metalCost*2.5
    ud.health=ud.health*1.75
    ud.weaponDefs.ADV_ROCKET.range=1200
    ud.customParams.def_scale=3.5
    utils.set_ded_ATOMIC_BLAST(ud)
end)