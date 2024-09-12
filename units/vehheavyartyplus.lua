VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("vehheavyarty","vehheavyartyplus")
utils.add_build("sillycon","vehheavyartyplus")
return utils.copy_tweak("vehheavyarty","vehheavyartyplus",function (ud)
    ud.metalCost=1800
    ud.health=2000
    ud.name="S.L.A.M " .. ud.name
    ud.description="Throws S.L.A.M"
    local wd=ud.weaponDefs.CORTRUCK_ROCKET
    utils.do_tweak({
        name="S.L.A.M",
        areaOfEffect            = 160,
	    cegTag                  = [[slam_trail]],
        collisionSize           = 1,
        craterBoost             = 800,
        craterMult              = 1.0,
        damage={
            default=2500
        },
        range=1200,
        edgeEffectiveness       = 1,
        explosionGenerator      = [[custom:slam]],
        flightTime              = 16,
        impactOnly              = false,
        impulseBoost            = 0,
        impulseFactor           = 0.2,
        interceptedByShieldType = 2,
        model                   = [[wep_m_phoenix_nonhax.s3o]],
        reloadtime              = 30,
        smokeTrail              = false,
        soundHit                = [[weapon/bomb_hit]],
        soundStart              = [[weapon/missile/missile_fire2]],
        startVelocity           = 0,
        tolerance               = 4000,
        weaponTimer             = 4.4,
        weaponAcceleration      = 75,
        weaponType              = [[StarburstLauncher]],
        weaponVelocity          = 1125,
        commandfire             = true,
    })(wd)
    ud.speed=54
    ud.customParams={
        def_scale=1.4
    }
end)