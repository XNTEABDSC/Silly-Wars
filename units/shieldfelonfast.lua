VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorphAuto("shieldfelon","shieldfelonfast",function (ud)
    ud.name ="Rushing " .. ud.name
    ud.description="Heavy Shield Fast Attacker, use A LOT OF energy to charge"
    ud.metalCost=1200
    local shwd=ud.weaponDefs.SHIELD
    local wd=ud.weaponDefs.SHIELDGUN
    ud.speed=81
    shwd.shieldPower=2800
    shwd.shieldPowerRegen=80
    shwd.shieldPowerRegenEnergy=40
    shwd.shieldRadius=150
    ud.health=1200
    ud.autoHeal=8

    wd.range=250
    wd.customParams.shield_drain=50
    wd.reloadtime=0.1
    wd.rgbColor=[[1 0 0]]
    utils_op.set_ded(ud,"BIG_UNIT")
    --ud.explodeAs="ESTOR_BUILDINGEX"
    --ud.selfDestructAs="ESTOR_BUILDINGEX"
    --utils.set_ded_ATOMIC_BLAST(ud)
end)