VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeSetSillyMorph("gunshipheavyskirm","gunshipheavyskirmplus")
utils_op.MakeAddSillyBuild("gunshipheavyskirmplus")
return utils_op.CopyTweak("gunshipheavyskirm","gunshipheavyskirmplus",function (ud)
    utils.table_replace({
        name="Flak Nimbus",
        description="Flying Flak",
        metalCost=2500,
        health=5000,
        speed=80,
    })(ud)
    local wd=ud.weaponDefs.EMG
    utils.table_replace({
        name                    = [[Flak Cannon]],
        accuracy                = 500,
        areaOfEffect            = 128,
        cegTag                  = [[flak_trail]],
        craterBoost             = 0,
        craterMult              = 0,
        cylinderTargeting       = 1,
        damage                  = {
            default = 132.1,
        },
        edgeEffectiveness       = 0.5,
        explosionGenerator      = [[custom:flakplosion]],
        impulseBoost            = 0,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        range                   = 1000,
        reloadtime              = 0.5,
        soundHit                = [[weapon/flak_hit]],
        soundStart              = [[weapon/flak_fire]],
        --turret                  = true,
        weaponType              = [[Cannon]],
        weaponVelocity          = 2000,
    })(wd)
    wd.burst=nil
    wd.burstrate=nil
    wd.customparams.combatrange=900
    wd.myGravity=0
    wd.sprayAngle=nil
    ud.customParams.def_scale=2
    ud.airStrafe              = 0
    
    utils_op.set_ded_ATOMIC_BLAST(ud)
end)