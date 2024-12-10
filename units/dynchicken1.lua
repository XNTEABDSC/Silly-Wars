return { dynchicken1 = {
    name                = [[Potential Chicken]],
    description         = [[Upgradable Chicken]],
    acceleration        = 0.6,
    autoHeal            = 10,
    brakeRate           = 1.23,
    buildDistance       = 240,
    builder             = true,
  
    buildoptions        = {
    },
  
    buildPic            = [[chickenbroodqueen.png]],
    canGuard            = true,
    canMove             = true,
    canPatrol           = true,
    canSubmerge         = true,
    category            = [[LAND]],
  
    customParams        = {
        level = [[1]],
        statsname = [[dynchicken1]],
        commtype = [[1]],
      outline_x = 185,
      outline_y = 185,
      outline_yoff = 27.5,
      dynamic_comm=1,
      shared_energy_gen = 1,
    },
  
    explodeAs           = [[SMALL_UNITEX]],
    footprintX          = 4,
    footprintZ          = 4,
    health              = 3000,
    iconType            = [[chickenc]],
    idleAutoHeal        = 20,
    idleTime            = 300,
    leaveTracks         = true,
    maxSlope            = 72,
    maxWaterDepth       = 22,
    metalCost           = 1200,
    metalStorage        = 500,
    energyStorage       = 500,
    movementClass       = [[TKBOT3]],
    noAutoFire          = false,
    noChaseCategory     = [[TERRAFORM SATELLITE FIXEDWING GUNSHIP HOVER SHIP SWIM SUB LAND FLOAT SINK TURRET]],
    objectName          = [[chickenbroodqueen.s3o]],
    selfDestructAs      = [[SMALL_UNITEX]],
  
    sfxtypes            = {
  
      explosiongenerators = {
        [[custom:blood_spray]],
        [[custom:blood_explode]],
        [[custom:dirt]],
      },
  
    },
  
    showNanoSpray       = false,
    showPlayerName      = true,
    sightDistance       = 1024,
    sonarDistance       = 450,
    speed               = 43,
    trackOffset         = 8,
    trackStrength       = 8,
    trackStretch        = 1,
    trackType           = [[ChickenTrack]],
    trackWidth          = 40,
    turninplace         = 0,
    turnRate            = 687,
    upright             = false,
    workerTime          = 8,
    corpse="DEAD",
    script="dynchicken.lua",
    
    featureDefs         = {
      DEAD  = {
        blocking         = true,
        featureDead      = [[HEAP]],
        footprintX       = 4,
        footprintZ       = 4,
        object           = [[chickeneggblue_huge.s3o]],
      },
  
      HEAP  = {
        blocking         = false,
        footprintX       = 4,
        footprintZ       = 4,
        object           = [[debris3x3c.s3o]],
      },
  
    }
  } }
  --chickeneggblue_huge.s3o