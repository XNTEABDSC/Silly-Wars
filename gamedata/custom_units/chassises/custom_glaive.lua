VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_glaive",
    humanName="Bot (Glaive)",
    pictrue=[[unitpics/cloakraid.png]],
    description="Bot",
    unitDef={
        name                   = [[Custom Glaive]],
        description            = [[Custom Bot]],
        acceleration           = 1.5,
        brakeRate              = 2.4,
        buildPic               = [[cloakraid.png]],
        canGuard               = true,
        canMove                = true,
        canPatrol              = true,
        category               = [[LAND SMALL TOOFAST]],
        collisionVolumeOffsets = [[0 -2 0]],
        collisionVolumeScales  = [[18 28 18]],
        collisionVolumeType    = [[cylY]],
        corpse                 = [[DEAD]],
      
        customParams           = {
          modelradius        = [[16]],
          cus_noflashlight   = 1,
          aim_lookahead      = 80,
          set_target_range_buffer = 30,
          set_target_speed_buffer = 8,
          -- [=[
          custom_unit_proxy_use_script="cloakraid.lua",
          custom_unit_proxy_use_def_piece="head",
          custom_unit_proxy_use_def_piece_aim_from_weapon="head",
          custom_unit_proxy_use_def_piece_query_weapon="flare"
          --]=]
        },
        script                 =
        --[[custom_glaive.lua]]
        [[custom_unit_proxy_use.lua]]
        ,
      
        explodeAs              = [[SMALL_UNITEX]],
        footprintX             = 2,
        footprintZ             = 2,
        iconType               = [[kbotraider]],
        idleAutoHeal           = 20,
        idleTime               = 150,
        leaveTracks            = true,
        maxSlope               = 36,
        maxWaterDepth          = 22,
        movementClass          = [[KBOT2]],
        noAutoFire             = false,
        noChaseCategory        = [[TERRAFORM FIXEDWING SUB]],
        objectName             = [[spherebot.s3o]],
        selfDestructAs         = [[SMALL_UNITEX]],
      
        sfxtypes               = {
      
          explosiongenerators = {
            [[custom:emg_shells_l]],
            [[custom:flashmuzzle1]],
          },
      
        },
      
        sightDistance          = 560,
        speed                  = 115.5,
        trackOffset            = 0,
        trackStrength          = 8,
        trackStretch           = 1.1,
        trackType              = [[ComTrack]],
        trackWidth             = 14,
        turnRate               = 3000,
        upright                = true,

        featureDefs            = {

            DEAD  = {
              blocking         = false,
              featureDead      = [[HEAP]],
              footprintX       = 2,
              footprintZ       = 2,
              object           = [[spherebot_dead.s3o]],
            },
        
            HEAP  = {
              blocking         = false,
              footprintX       = 2,
              footprintZ       = 2,
              object           = [[debris2x2b.s3o]],
            },
        
        },
        health                 = utils.consts.custom_health_const,
        metalCost              = utils.consts.custom_cost_const,
    },
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.genChassisSpeedModify(1),
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,4)
    },
    weapons_slots={
        [1] = { "projectile_targeter" ,"line_targeter","aa_targeter"},
    }
}