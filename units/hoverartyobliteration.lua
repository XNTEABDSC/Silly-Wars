VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("hoverarty","hoverartyobliteration",function (ud)
    
    utils.table_replace({
        name=function (name)
            return "Obliteration ".. name
        end,
        description="Obliteration Blaster Artillery Hovercraft",
        customParams={
            tactical_ai_defs_copy="hoverarty",
            translations=[=[{
                en={
                    name="Obliteration Lance",
                    description="Obliteration Blaster Artillery Hovercraft",
                    helptext="Obliteration Lance is a experimental attemp of using Obliteration Blaster, a fast, accurate, aoe, and good range weapon."
                }
            }]=]
        },
        metalCost=1200,
    })(ud)
    ud.weapons[1].def="OBLITERATION_BLASTER"
    ud.weaponDefs.ATA=nil
    ud.weaponDefs.OBLITERATION_BLASTER={
        name                    = [[Obliteration Blaster]],
        areaOfEffect            = 212,
        avoidFeature            = false,
        avoidGround             = false,
        avoidNeutral            = false,
        coreThickness           = 2.5,
        craterBoost             = 6,
        craterMult              = 14,
        burst=2,
        burstrate=0.4,
        customparams = {
          light_radius = 380,
          light_color = [[0.5 0.95 0]],
          gatherradius = [[192]],
          smoothradius = [[128]],
          smoothmult   = [[0.7]],
          smoothexponent = [[0.8]],
          smoothheightoffset = [[22]],
          -- no `movestructures` because then they can "dodge" via sudden movement
        },
        
        damage                  = {
          default = 1200.1,
        },
  
        duration                = 0.05,
        edgeEffectiveness       = 0.5,
        explosionGenerator      = [[custom:slam]],
        fallOffRate             = 0.1,
        fireStarter             = 10,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        lodDistance             = 10000,
        range                   = 1000,
        reloadtime              = 23,
        rgbColor                = [[0.1 1 0]],
        rgbColor2               = [[0.5 0.1 0.2]],
        soundHit                = [[explosion/mini_nuke]],
        soundStart              = [[PulseLaser]],
        soundTrigger            = false,
        sweepfire               = false,
        texture1                = [[largelaser_long]],
        texture2                = [[flare]],
        texture3                = [[largelaser_long]],
        texture4                = [[largelaser_long]],
        thickness               = 9,
        tolerance               = 2000,
        turret                  = true,
        weaponType              = [[LaserCannon]],
        weaponVelocity          = 1500,
    }
end
)