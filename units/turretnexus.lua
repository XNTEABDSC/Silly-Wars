VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.set_morth("silly_morth","turretheavylaserlv20","turretnexus")
utils.add_build("silly_build","bigsillycon","turretnexus")
return {turretnexus={
    name = [[Nexus Turret]],
    description = [[Nexus Turret, from Zero Wars]],
    activateWhenBuilt = true,
    metalCost = 5500,
    builder = false,
    buildingGroundDecalDecaySpeed = 30,
    buildingGroundDecalSizeX = 5,
    buildingGroundDecalSizeY = 5,
    buildingGroundDecalType = [[turretsunlance_decal.dds]],
    buildPic = [[turretsunlance.png]],
    canGuard = true,
    category = [[FLOAT TURRET]],
    corpse = [[DEAD]],
    explodeAs = [[LARGE_BUILDINGEX]],
    floater = true,
    footprintX = 4,
    footprintZ = 4,
    iconType = [[staticassault]],
    levelGround = false,
    maxDamage = 28000,
    maxSlope = 18,
    minCloakDistance = 150,
    noAutoFire = false,
    noChaseCategory = [[FIXEDWING LAND SHIP SATELLITE SWIM GUNSHIP SUB HOVER]],
    objectName = [[heavyturret.s3o]],
    script = [[turretnexus.lua]],
    selfDestructAs = [[LARGE_BUILDINGEX]],
    reclaimable = false,
    canSelfD = false,
    capturable = false,
    sfxtypes = {
        explosiongenerators = {
            [[custom:none]]
        }
    },
    sightDistance = 450,
    useBuildingGroundDecal = true,
    workerTime = 0,
    yardMap = [[oooo oooo oooo oooo]],
    weapons = {
        {
            def = [[DISRUPTOR]],
            badTargetCategory = [[FIXEDWING]],
            onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
        },
        {
            def = [[SHIELD]]
        },
        {def = [[ARMRL_MISSILE]]}
    },
    weaponDefs = {
        DISRUPTOR = {
            name = [[Disruptor Pulse Beam]],
            areaOfEffect = 64,
            beamdecay = 0.9,
            beamTime = 1 / 30,
            beamttl = 30,
            coreThickness = 0.3,
            craterBoost = 0,
            craterMult = 0.25,
            customParams = {
                timeslow_damagefactor = [[2]]
            },
            damage = {
                default = 500
            },
            explosionGenerator = [[custom:flash2purple]],
            fireStarter = 30,
            impulseBoost = 0,
            impulseFactor = 0.4,
            interceptedByShieldType = 1,
            largeBeamLaser = true,
            laserFlareSize = 4.33,
            minIntensity = 1,
            noSelfDamage = true,
            range = 600,
            reloadtime = 1.5,
            rgbColor = [[0.3 0 0.4]],
            soundStart = [[weapon/laser/heavy_laser5]],
            soundStartVolume = 5,
            soundTrigger = true,
            sweepfire = false,
            texture1 = [[largelaser]],
            texture2 = [[flare]],
            texture3 = [[flare]],
            texture4 = [[smallflare]],
            thickness = 16,
            tolerance = 18000,
            turret = true,
            weaponType = [[BeamLaser]],
            weaponVelocity = 500
        },
        SHIELD = {
            name = [[Energy Shield]],
            damage = {
                default = 10
            },
            exteriorShield = true,
            shieldAlpha = 0.2,
            shieldBadColor = [[1 0.1 0.1 1]],
            shieldGoodColor = [[0.1 1 0.1 1]],
            shieldInterceptType = 3,
            shieldPower = 12500,
            shieldPowerRegen = 32,
            shieldPowerRegenEnergy = 0,
            shieldRadius = 80,
            shieldRepulser = false,
            shieldStartingPower = 12500,
            smartShield = true,
            visibleShield = false,
            visibleShieldRepulse = false,
            weaponType = [[Shield]]
        },
        ARMRL_MISSILE = {
            name                    = [[Homing Missiles (x0.2 vs ground)]],
            areaOfEffect            = 8,
            avoidFeature            = true,
            cegTag                  = [[missiletrailyellow]],
            craterBoost             = 0,
            craterMult              = 0,
            cylinderTargeting       = 5,
      
            customParams            = {
              burst = Shared.BURST_RELIABLE,
      
              isaa = [[1]],
              --script_reload = [[12.5]],
              --script_burst = [[5]], -- not implemented in script is useless
              prevent_overshoot_fudge = 45, -- projectile speed is 25 elmo/frame
      
              light_camera_height = 2000,
              light_radius = 200,
            },
      
            damage                  = {
              default = 104.001,
              planes = 500
            },
      
            explosionGenerator      = [[custom:FLASH2]],
            fireStarter             = 70,
            flightTime              = 1,
            impactOnly              = true,
            impulseBoost            = 0,
            impulseFactor           = 0.4,
            interceptedByShieldType = 2,
            metalpershot            = 0,
            model                   = [[hobbes.s3o]], -- Model radius 150 for QuadField fix.
            noSelfDamage            = true,
            range                   = 610,
            reloadtime              = 0.5,
            smokeTrail              = true,
            soundHit                = [[explosion/ex_small13]],
            soundStart              = [[weapon/missile/missile_fire11]],
            startVelocity           = 500,
            texture1                = [[flarescale01]],
            texture2                = [[lightsmoketrail]],
            tolerance               = 10000,
            tracks                  = true,
            turnRate                = 60000,
            turret                  = true,
            weaponAcceleration      = 300,
            weaponType              = [[MissileLauncher]],
            weaponVelocity          = 750,
          },      
    },
    featureDefs = {
        DEAD = {
            blocking = true,
            featureDead = [[HEAP]],
            footprintX = 3,
            footprintZ = 3,
            object = [[heavyturret_dead.s3o]]
        },
        HEAP = {
            blocking = false,
            footprintX = 3,
            footprintZ = 3,
            object = [[debris4x4b.s3o]]
        }
    }
}
}