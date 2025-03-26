VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_spider_2plasma",
    humanName="Spider (Hermit)",
    pictrue=[[unitpics/spiderassault.png]],
    description="Spider",
    unitDef={
        name                   = [[Custom Hermit]],
        description            = [[Custom All Terrain Assault Bot]],
        acceleration           = 0.54,
        brakeRate              = 1.32,
        buildPic               = [[spiderassault.png]],
        canGuard               = true,
        canMove                = true,
        canPatrol              = true,
        category               = [[LAND]],
        collisionVolumeOffsets = [[0 -3 0]],
        collisionVolumeScales  = [[24 30 24]],
        collisionVolumeType    = [[cylY]],
        corpse                 = [[DEAD]],

        customParams           = {
            bait_level_default = 0,
            modelradius        = [[12]],
            cus_noflashlight   = 1,
            selection_scale    = 1.05,
            def_scale=1,
        },

        explodeAs              = [[BIG_UNITEX]],
        footprintX             = 2,
        footprintZ             = 2,
        iconType               = [[spiderassault]],
        leaveTracks            = true,
        maxSlope               = 36,
        maxWaterDepth          = 22,
        movementClass          = [[TKBOT3]],
        noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE SUB DRONE]],
        objectName             = [[hermit.s3o]],
        selfDestructAs         = [[BIG_UNITEX]],
        script                 = [[custom_hermit.lua]],

        sfxtypes               = {

            explosiongenerators = {
                [[custom:RAIDMUZZLE]],
                [[custom:RAIDDUST]],
                [[custom:THUDDUST]],
            },

        },

        sightDistance          = 420,
        speed                  = 54,
        trackOffset            = 0,
        trackStrength          = 8,
        trackStretch           = 1,
        trackType              = [[ChickenTrackPointy]],
        trackWidth             = 30,
        turnRate               = 1920,


        featureDefs            = {

            DEAD = {
                blocking    = true,
                featureDead = [[HEAP]],
                footprintX  = 2,
                footprintZ  = 2,
                object      = [[hermit_wreck.s3o]],
            },

            HEAP = {
                blocking   = false,
                footprintX = 2,
                footprintZ = 2,
                object     = [[debris2x2c.s3o]],
            },

        },
        health                 = utils.consts.custom_health_const,
        metalCost              = utils.consts.custom_cost_const,
    },
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.add_weapon(1,"left gun"),
        utils.BasicChassisMutate.add_weapon(2,"right gun"),
        utils.BasicChassisMutate.genChassisSpeedModify(0.8),
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6)
    },
    weapons_slots={
        [1] = { utils.targeterweapons.projectile_targeter ,utils.targeterweapons.line_targeter},
        [2] = { utils.targeterweapons.projectile_targeter ,utils.targeterweapons.line_targeter}
    }
}