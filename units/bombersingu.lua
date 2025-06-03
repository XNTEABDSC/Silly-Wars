VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("bomberheavy","bombersingu",function (ud)
    ud.name="Impulse Likho"
    ud.description="Impulse Bomber"
    ud.metalCost=3000
    ud.health=3000
    local wd=ud.weaponDefs.ARM_PIDR
    wd.damage = {
        default = 800.1,
        planes  = 800.1,
    }
    wd.areaOfEffect=280
    --wd.impulseboost=-1
    wd.impulseFactor=-40
    wd.explosionSpeed=280*4
    wd.edgeEffectiveness=0.5
    ud.fireState=0
    ud.customParams.translations=[=[{
        en={
            name="Impulse Likho",
            description="Impulse Bomber",
            helptext="Singu Likho can drop a small singularity to its enemy and throw then into air."
        }
    }]=]
end)

