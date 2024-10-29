VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.set_morth("silly_morth","turretmissile","turretdronelight")
utils.add_build("silly_build","sillycon","turretdronelight")

return { turretdronelight = {
  name                          = [[Small Drone Maker]],
  description                   = [[Make 2 Drones]],
  activateWhenBuilt             = true,
  buildPic                      = [[pw_hq.png]],
  category                      = [[FLOAT UNARMED]],
  corpse                        = [[DEAD]],

  customParams                  = {
    soundselect = "building_select1",
    def_scale=0.4,
    drone_defs_has_drones=[=[
      {
        spawnPieces = {"drone"},
        {
          drone = UnitDefNames.dronelightslow.id,
          reloadTime = 1,
          maxDrones = 2,
          spawnSize = 1,
          range = 900,
          maxChaseRange = 1200,
          buildTime = 15,
          maxBuild = 1,
          offsets = {0, 3, 0, colvolMidX = 0, colvolMidY = 0, colvolMidZ = 0, aimX = 0, aimY = 0, aimZ = 0}
        },
      }
    ]=]
    
  },

  explodeAs                     = [[BIG_UNIT]],
  footprintX                    = 8,
  footprintZ                    = 8,
  health                        = 450,
  iconType                      = [[turretdronelight]],
  maxSlope                      = 18,
  metalCost                     = 150,
  objectName                    = [[pw_hq.s3o]],
  script                        = [[pw_hq.lua]],
  selfDestructAs                = [[BIG_UNIT]],
  sightDistance                 = 600,
  waterline                     = 10,
  useBuildingGroundDecal        = false,
  workerTime                    = 0,
  --yardMap                       = [[oooooooooooooooooooo]],

  weapons                = {

    {
      def                = "BOGUS_FAKE_TARGETER",
      badTargetCategory  = "FIXEDWING",
      onlyTargetCategory = "FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER",
    },

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

} }
