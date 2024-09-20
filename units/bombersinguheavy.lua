VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("silly_morth","bombersingu","bombersinguheavy")
utils.add_build("silly_build","bigsillycon","bombersinguheavy")

return utils.copy_tweak("bombersingu","bombersinguheavy",function (ud)
    ud.name="Singu Likho"
    ud.description="Throw Singu, 4000 stockpile cost"
    ud.metalCost=24000
    ud.health=20000
    ud.speed=ud.speed*0.85
    local wd=ud.weaponDefs.ARM_PIDR

    Spring.Utilities.CopyTable(utils.get_unit_lua("energysingu").weaponDefs.SINGULARITY,true,wd)
    wd.stockpile               = true
    wd.stockpileTime           = 10^5

    ud.customParams.reammoseconds=[[90]]
    ud.customParams.light_radius=7500
    ud.customParams.stockpiletime  = [[90]]
    ud.customParams.stockpilecost  = [[4000]]
    ud.customParams.priority_misc  = 1
    ud.customParams.def_scale=2
end)

