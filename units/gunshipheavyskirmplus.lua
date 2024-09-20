VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("silly_morth","gunshipheavyskirm","gunshipheavyskirmplus")
utils.add_build("silly_build","sillycon","gunshipheavyskirmplus")
return utils.copy_tweak("gunshipheavyskirm","gunshipheavyskirmplus",function (ud)
    utils.do_tweak({
        name="Flak Nimbus",
        description="Flying Flak",
        metalCost=2500,
        health=3500,
        speed=80,
    })(ud)
    local wd=ud.weaponDefs.EMG
    utils.do_tweak({
        name                    = [[Flak Cannon]],
        accuracy                = 500,
        areaOfEffect            = 128,
        cegTag                  = [[flak_trail]],
        craterBoost             = 0,
        craterMult              = 0,
        cylinderTargeting       = 1,
        damage                  = {
            default = 132,
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
        turret                  = true,
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
    
    utils.set_ded_ATOMIC_BLAST(ud)
end)