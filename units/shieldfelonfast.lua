VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth_mul("shieldfelon","shieldfelonfast")
utils.add_build("bigsillycon","shieldfelonfast")
return utils.copy_tweak("shieldfelon","shieldfelonfast",function (ud)
    ud.name ="Rushing " .. ud.name
    ud.description="Heavy Shield Fast Attacker, use A LOT OF energy to charge"
    ud.metalCost=1200
    local shwd=ud.weaponDefs.SHIELD
    local wd=ud.weaponDefs.SHIELDGUN
    ud.speed=90
    shwd.shieldPower=2600
    shwd.shieldPowerRegen=80
    shwd.shieldPowerRegenEnergy=40
    shwd.shieldRadius=150
    ud.health=800
    ud.autoheal=8

    wd.range=250
    wd.customParams.shield_drain=50
    wd.reloadtime=0.1
    wd.rgbColor=[[1 0 0]]
    wd.explodeAs="ESTOR_BUILDINGEX"
    wd.selfDestructAs="ESTOR_BUILDINGEX"
    utils.set_ded_ATOMIC_BLAST(ud)
end)