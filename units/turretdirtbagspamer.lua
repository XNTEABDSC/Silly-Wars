VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
--utils_op.MakeSetSillyMorph("turretmissile","turretdronelight")
--utils_op.MakeAddSillyBuild("turretdirtbagspamer")

return { turretdirtbagspamer = {
  name                          = [[Dirtbag Spamer]],
  description                   = [[Spam Dirtbag, with Silly Units Handler]],
  activateWhenBuilt             = true,
  buildPic                      = [[pw_hq.png]],
  category                      = [[FLOAT UNARMED]],
  corpse                        = [[DEAD]],

  customParams                  = {
    soundselect = "building_select1",
  },

  explodeAs                     = [[BIG_UNIT]],
  footprintX                    = 8,
  footprintZ                    = 8,
  health                        = 1000,
  iconType                      = [[turretdronelight]],
  maxSlope                      = 18,
  metalCost                     = 1000,
  objectName                    = [[pw_hq.s3o]],
  script                        = [[turretdirtbagspamer.lua]],
  selfDestructAs                = [[BIG_UNIT]],
  sightDistance                 = 600,
  waterline                     = 10,
  useBuildingGroundDecal        = false,
  workerTime                    = 0,
  --yardMap                       = [[oooooooooooooooooooo]],

  weapons                = {


  },
  
  weaponDefs             = {
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
