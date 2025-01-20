

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

utils_op.MakeSetSillyBuildMorphBig("spiderassault","bunkerbuster")

return { bunkerbuster = {
    name                   = [[Bunker Buster]],
    description            = [[All Terrain Assault Bomb. Need 5 sec to prepare. From robot survival]],
    acceleration           = 2.1,
    brakeRate              = 12.6,
    metalCost              = 1000,
    buildPic               = [[spiderassault.png]],
    canGuard               = true,
    canMove                = true,
    canPatrol              = true,
    category               = [[LAND SINK]],
    collisionVolumeOffsets = [[0 -3 0]],
    collisionVolumeScales  = [[24 30 24]],
    collisionVolumeType    = [[cylY]],
    corpse                 = [[DEAD]],

    customParams           = {
      bait_level_default = 0,
      modelradius    = [[12]],
      cus_noflashlight = 1,
      model_rescale=2,
      combat_slowdown = 0.25,
      oneclick_weapon_defs=[=[
      {
        { functionToCall = "Detonate", name = "Detonate", tooltip = "Detonate: Kill selected bomb units. Need 5s. Slowdown and decloak.", texture = "LuaUI/Images/Commands/Bold/detonate.png",},
      }
      ]=],
    },

    explodeAs              = [[CRAWL_BLASTSML]],
    footprintX             = 2,
    footprintZ             = 2,
    iconType               = [[spiderassault]],
    leaveTracks            = true,
    health                 = 11000,
    maxSlope               = 36,
    speed                  = 45,
    maxWaterDepth          = 5000,
    movementClass          = [[TKBOT3]],
    noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE SUB DRONE]],
    objectName             = [[hermit.s3o]],
    selfDestructAs         = [[bunkerbuster_SELFD]],
    script                 = [[bunkerbuster.lua]],

    sfxtypes               = {
      explosiongenerators = {
        [[custom:RAIDMUZZLE]],
        [[custom:RAIDDUST]],
        [[custom:THUDDUST]],
      },
    },

    sightDistance          = 420,
    trackOffset            = 0,
    trackStrength          = 8,
    trackStretch           = 1,
    trackType              = [[ChickenTrackPointy]],
    trackWidth             = 30,
    turnRate               = 1920,

    weapons                = {

      {
        def                = "BOGUS_FAKE_TARGETER",
        badTargetCategory  = "FIXEDWING",
        onlyTargetCategory = "FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER",
      },
  
    },

    weaponDefs = {
      bunkerbuster_SELFD = {
        areaOfEffect       = 300,
        craterBoost        = 4,
        craterMult         = 5,
        edgeEffectiveness  = 0.9,
        explosionGenerator = "custom:NUKE_150",
        explosionSpeed     = 20000,
        impulseBoost       = 0,
        impulseFactor      = 0.1,
        name               = "Explosion",
        soundHit           = "explosion/mini_nuke",

        customParams       = {
          burst = Shared.BURST_UNRELIABLE,
          lups_explodelife = 1.5,
        },
        damage = {
          default          = 8002.4,
        },
      },
      
      BOGUS_FAKE_TARGETER = {
        name                    = [[Bogus Fake Targeter]],
        avoidGround             = false, -- avoid nothing, else attempts to move out to clear line of fine
        avoidFriendly           = false,
        avoidFeature            = false,
        avoidNeutral            = false,
  
        damage                  = {
          default = 11.34,
          planes  = 11.34,
        },
  
        explosionGenerator      = [[custom:FLASHPLOSION]],
        noSelfDamage            = true,
        range                   = 900,
        reloadtime              = 1,
        tolerance               = 5000,
        turret                  = true,
        weaponType              = [[StarburstLauncher]],
        weaponVelocity          = 500,
      },
    },
    featureDefs            = {
      DEAD  = {
        blocking         = true,
        featureDead      = [[HEAP]],
        footprintX       = 2,
        footprintZ       = 2,
        object           = [[hermit_wreck.s3o]],
      },
      HEAP  = {
        blocking         = false,
        footprintX       = 2,
        footprintZ       = 2,
        object           = [[debris2x2c.s3o]],
      },
    },
  } }
