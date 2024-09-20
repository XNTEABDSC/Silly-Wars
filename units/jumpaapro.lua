VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth_mul("silly_morth","jumpaa","jumpaapro")
utils.add_build("silly_build","bigsillycon","jumpaapro")

return utils.copy_tweak("jumpaa","jumpaapro",function (ud)
    ud.name="Pro Toad"
    ud.description="AA Strider"
    ud.metalCost=4000
    ud.health=20000
    ud.speed=48
    ud.sightDistance=1200
    ud.customParams.def_scale=2.5
    utils.do_tweak({
        beamttl                 = 10,
        customParams={
            --script_burst_salvo_count=20,
            --script_burst_salvo_reload=0.5,
            script_reload = [[15]],
            script_burst = [[15]],
            timeslow_damagefactor = 2,
            timeslow_overslow_frames = 2*30,
            reaim_time=1,
        },
        damage                  = {
            default = 30.01,
            planes  = 300.1,
        },
        --reloadtime=0.1,
        --burst=20,
        --burstRate=0.0333,
        reloadtime=0.1,
        rgbColor = [[0.3 0 0.4]],
        largeBeamLaser          = true,
        texture1                = [[largelaser]],
        texture2                = [[flare]],
        texture3                = [[flare]],
        texture4                = [[smallflare]],
        thickness               = 6,
        range=950
    })(ud.weaponDefs.LASER)
    local gun=ud.weaponDefs.EMG
    utils.do_tweak({
        name                    = [[Flak Cannon]],
        areaOfEffect            = 128,
        cegTag                  = [[flak_trail]],
        craterBoost             = 0,
        craterMult              = 0,
        cylinderTargeting       = 1,
        damage                  = {
            default = 13.21,
            planes = 132.1,
        },
        edgeEffectiveness       = 0.5,
        explosionGenerator      = [[custom:flakplosion]],
        impulseBoost            = 0,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        range                   = 1000,
        reloadtime              = 0.1,
        soundHit                = [[weapon/flak_hit]],
        soundStart              = [[weapon/flak_fire]],
        turret                  = true,
        weaponType              = [[Cannon]],
        weaponVelocity          = 2000,
        burnBlow=true,
        --projectiles=2,
        sprayAngle=400,
        customParams={
            
            reaim_time=1,
        }
    })(gun)
    ud.script="jumpaapro.lua"
    local udcp=ud.customParams
    udcp.canjump            = nil
    udcp.jump_range         = nil
    udcp.jump_speed         = nil
    udcp.jump_reload        = nil
    udcp.jump_from_midair   = nil
end)