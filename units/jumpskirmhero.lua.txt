VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeSetSillyMorph("jumpskirm","jumpskirmhero")
utils_op.MakeAddSillyBuild("jumpskirmhero")

return utils_op.CopyTweak("jumpskirm","jumpskirmhero",utils.table_replace(
    {
        name                = [[Hero Moderator]],
        description         = [[Hero Disruptor Skirmisher Walker, From Zero War]],
        script="jumpskirmhero.lua",
        metalCost=8000,
        health=1200*(1+0.25*16)+800*2,
        sightDistance = 500,
        canManualFire = true,
        customParams={
            def_scale=2,
            tactical_ai_defs_copy="jumpskirm",
        },
        weapons={
            [2]={
                def = [[DISRUPTOR_BOMB]],
                badTargetCategory = [[FIXEDWING]],
                onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
            }
        },
        weaponDefs          = {
            DISRUPTOR_BEAM = {
                customparams={
                    timeslow_damagefactor= 1,
                    def_scale=0.85*(1+0.08*16)
                },
                damage = {default = 400*(1+0.35*4)},
                reloadtime=1*1/(1+0.25*4),
                range=420*(1+0.15*2),
            },DISRUPTOR_BOMB = {
                name = [[Disruptor Bomb]],
                accuracy = 256,
                areaOfEffect = 300,
                cegTag = [[beamweapon_muzzle_purple]],
                commandFire = true,
                craterBoost = 0,
                craterMult = 0,

                customParams = {
                    timeslow_damagefactor = [[6]],
                    muzzleEffectFire = [[custom:RAIDMUZZLE]],
                    nofriendlyfire = "needs hax",

                    light_camera_height = 2500,
                    light_color = [[1.5 0.75 1.8]],
                    light_radius = 280,
                    reaim_time = 1
                },

                damage = {default = 750*(1+0.5*3)},

                explosionGenerator = [[custom:riotballplus2_purple]],
                explosionSpeed = 5,
                fireStarter = 100,
                impulseBoost = 0,
                impulseFactor = 0,
                interceptedByShieldType = 2,
                model = [[wep_b_fabby.s3o]],
                range = 450,
                reloadtime = 25,
                smokeTrail = true,
                soundHit = [[weapon/aoe_aura2]],
                soundHitVolume = 8,
                soundStart = [[weapon/cannon/cannon_fire3]],
                startVelocity           = 350,
                trajectoryHeight        = 0.3,
                turret = true,
                weaponType = [[Cannon]],
                weaponVelocity = 350
            }
        },
    }
))