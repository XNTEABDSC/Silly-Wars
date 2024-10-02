VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
utils.set_morth("silly_morth","turretdronelight","staticbase")
utils.add_build("silly_build","bigsillycon","staticbase")

return { staticbase = {
  name                          = [[Frontline Base]],
  description                   = [[Provides hp, longrange bp and resurrect, radar and los, radar jam and cloak, drones, shield, pylon, and disruptor pulse]],
  activateWhenBuilt             = true,
  buildPic                      = [[pw_hq.png]],
  category                      = [[FLOAT UNARMED]],
  corpse                        = [[DEAD]],
  builder                       = true,
  canGuard                      = true,
  canMove                       = false,
  canPatrol                     = true,
  cantBeTransported             = false,
  autoHeal=100,
  canSelfRepair =true,
  customParams                  = {
    soundselect = "building_select1",
    drone_defs_has_drones=[=[
      {
        spawnPieces = {"drone","drone","drone","drone"},
        {
          drone = UnitDefNames.droneheavyslow.id,
          reloadTime = 10,
          maxDrones = 8,
          spawnSize = 4,
          range = 1500,
          maxChaseRange = 1800,
          buildTime = 1,
          maxBuild = 4,
          offsets = {0, 5, 0, colvolMidX = 0, colvolMidY = 0, colvolMidZ = 0, aimX = 0, aimY = 0, aimZ = 0}
        },
      }
    ]=],
    select_show_eco  = 1,
    area_cloak = 1,
    area_cloak_upkeep = 30,
    area_cloak_radius = 600,
    area_cloak_shift_range = 300,
    area_cloak_recloak_rate = 1200,
    pylonrange = 1000,
  },

  explodeAs                     = [[ATOMIC_BLAST]],
  footprintX                    = 8,
  footprintZ                    = 8,
  health                        = 25000,
  iconType                      = [[pw_assault]],
  maxSlope                      = 18,
  metalCost                     = 6500,
  objectName                    = [[pw_hq.s3o]],
  script                        = [[staticbase.lua]],
  selfDestructAs                = [[ATOMIC_BLAST]],
  sightDistance                 = 1500,
  radarDistance                 = 2400,
  radarDistanceJam              = 900,
  sonarDistance                 = 1000,
  losEmitHeight                 = 100,
  radarEmitHeight               = 100,
  waterline                     = 10,
  useBuildingGroundDecal        = false,
  workerTime                    = 50,
  buildDistance                 = 900,
  resurrectSpeed=25,
  showNanoSpray       = false,

  --yardMap                       = [[oooooooooooooooooooo]],

  weapons                = {

    {
      def                = "BOGUS_FAKE_TARGETER",
      badTargetCategory  = "FIXEDWING",
      onlyTargetCategory = "FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER",
    },
    {
      def                = [[ANTI_MISSILE_SHIELD]],
    },
    {
      def                ="SLOW_BLAST"
    }
  },
  
  weaponDefs             = {
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
    ANTI_MISSILE_SHIELD = {
      name                    = [[Energy Shield]],

      damage                  = {
        default = 10,
      },
      customParams            = {
        unlinked                = true,
      },

      exteriorShield          = true,
      shieldAlpha             = 0.2,
      shieldBadColor          = [[1 0.1 0.1 1]],
      shieldGoodColor         = [[0.1 0.1 1 1]],
      shieldInterceptType     = 3,
      shieldPower             = 11000,
      shieldPowerRegen        = 200,
      shieldPowerRegenEnergy  = 20,
      shieldRadius            = 300,
      shieldRepulser          = false,
      smartShield             = true,
      visibleShield           = false,
      visibleShieldRepulse    = false,
      weaponType              = [[Shield]],
    },
    SLOW_BLAST={
      name                    = [[Disruptor Pulser]],
      areaOfEffect            = 1200,
      craterBoost             = 0,
      craterMult              = 0,
      --collideFeature=false,

      damage                  = {
        default = 300,
        planes  = 300,
      },

      customParams           = {
        light_radius = 0,
        lups_explodespeed = 1,
        lups_explodelife = 0.6,
        nofriendlyfire = 1,
        timeslow_damagefactor = 2.5,
      },

      edgeeffectiveness       = 0.6,
      explosionGenerator      = [[custom:RIOTBALL600]],
      explosionSpeed          = 12,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      myGravity               = 10,
      noSelfDamage            = true,
      range                   = 300,
      reloadtime              = 3,
      soundHitVolume          = 1,
      turret                  = true,
      weaponType              = [[Cannon]],
      weaponVelocity          = 230,
    }
  },
  
  featureDefs                   = {
    DEAD  = {
      blocking         = true,
      resurrectable    = 0,
      featureDead      = [[HEAP]],
      footprintX       = 8,
      footprintZ       = 8,
      object           = [[pw_hq_dead.s3o]],
    },

    HEAP  = {
      blocking         = false,
      footprintX       = 6,
      footprintZ       = 6,
      object           = [[debris4x4b.s3o]],
    },
  },
  --[==[
  sfxtypes               = {

    explosiongenerators = {
      [[custom:RIOTBALL600]],
      [[custom:RAIDMUZZLE]],
      [[custom:LEVLRMUZZLE]],
      [[custom:RIOT_SHELL_L]],
      [[custom:BEAMWEAPON_MUZZLE_RED]],
    },

  },]==]

} }
