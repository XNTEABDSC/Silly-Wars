VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("gunshipkrow","gunshiptff")
utils.add_build("bigsillycon","gunshiptff")

return utils.copy_tweak("gunshipkrow","gunshiptff",function (ud)
    for _,i in pairs({1,2,4})do
        ud.weapons[i].def=nil
        ud.weapons[i].name="turretheavy_plasma"
    end
    ud.weaponDefs.CLUSTERBOMB=utils.get_unit_lua("gunshipskirm").weaponDefs.VTOL_ROCKET
    local missilewd=ud.weaponDefs.CLUSTERBOMB
    ud.weaponDefs.KROWLASER=nil
    
    missilewd.range=600
    missilewd.reloadtime=3
    missilewd.damage                  = {
        default = 1200.1,
    }
    missilewd.size=2
    missilewd.weaponVelocity=500
    missilewd.flightTime=5
    ud.script=[[gunshiptff.lua]]
    ud.metalCost=17500
    ud.health=45000
    ud.speed=80
    ud.name="The Flying Fortress"
    ud.description="The Flying Fortress"
    ud.customParams={
        def_scale=2
    }
end)