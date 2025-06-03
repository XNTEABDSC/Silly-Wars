VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorphBig("shieldfelon","shieldfelonfast",function (ud)
    ud.name = "Rushing Felon"
    ud.description="Heavy Shield Fast Attacker, use A LOT OF energy to charge"
    ud.metalCost=1500
    local shwd=ud.weaponDefs.SHIELD
    local wd=ud.weaponDefs.SHIELDGUN
    ud.speed=81
    shwd.shieldPower=3600
    shwd.shieldPowerRegen=120
    shwd.shieldPowerRegenEnergy=60
    shwd.shieldRadius=150
    ud.autoHeal=8

    wd.range=320
    wd.customParams.shield_drain=50
    wd.reloadtime=0.1
    wd.rgbColor=[[1 0 0]]
    utils_op.set_ded(ud,"BIG_UNIT")

    ud.customParams.translations=[=[{
        en={
            name = "Rushing Felon",
            description = "Heavy Shield Fast Attacker, use A LOT OF energy to charge",
            helptext = "Rushing Felon has a high dps and efficiency shield gun, and a shield to protect itself. To keep aggressive when alone, Rushing Felon uses a fast but low efficiency generator to power its shield"
        }
    }]=]
    --ud.explodeAs="ESTOR_BUILDINGEX"
    --ud.selfDestructAs="ESTOR_BUILDINGEX"
    --utils.set_ded_ATOMIC_BLAST(ud)
end)