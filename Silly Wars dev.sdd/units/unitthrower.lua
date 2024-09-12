VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.add_build("bigsillycon","unitthrower")

return utils.copy_tweak("amphlaunch","unitthrower",function (ud)
    ud.name="Unit Thrower"
    ud.description="Throw Units"
    ud.canMove=false
    ud.canGuard=false
    ud.customParams.thrower_gather=450
    ud.speed=0
    ud.weaponDefs.TELEPORT_GUN.range=2700-- WHYYYY
    ud.weaponDefs.TELEPORT_GUN.reloadtime=10
    ud.weaponDefs.BOGUS_TELEPORTER_GUN.range=2700
    ud.weaponDefs.BOGUS_TELEPORTER_GUN.reloadtime=10
    ud.metalCost=8000
    ud.health=12000
    utils.set_ded_ATOMIC_BLAST(ud)
end)