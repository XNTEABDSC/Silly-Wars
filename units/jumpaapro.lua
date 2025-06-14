VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweakSillyBuildMorphAuto("jumpaa","jumpaapro",function (ud)
    ud.name="Pro Toad"
    ud.description="AA Strider, with burst slow beam and flak"
    ud.metalCost=4000
    ud.health=16000
    ud.speed=48
    ud.sightDistance=1200
    ud.customParams.def_scale=2.5
    ud.customParams.translations_copy_from="jumpaa"
    ud.customParams.translations=[==[
    {
        en={
            name="Pro Toad",
            description = "Advanced Toad, an AA Strider, with burst slow beam and flak",
            helptext= "Pro Toad uses a burst slow beam to slow enemy air instantly then uses flak to kill it. Itself is slow but tanky."
        }
    }
    ]==]
    utils.table_replace({
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
    utils.table_replace({
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
    udcp.tactical_ai_defs_copy="jumpaa"
    ud.iconType="jumpaapro"
end)