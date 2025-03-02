
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_ravager",
    humanName="Car (Ravager)",
    pictrue=[[unitpics/vehassault.png]],
    description="Car",
    unitDef={
        name                   = [[Custom Ravager]],
        description            = [[Custom Rover]],
        acceleration           = 0.162,
        brakeRate              = 0.462,
        builder                = false,
        buildPic               = [[vehassault.png]],
        canGuard               = true,
        canMove                = true,
        canPatrol              = true,
        category               = [[LAND TOOFAST]],
        collisionVolumeOffsets = [[0 -5 0]],
        collisionVolumeScales  = [[42 42 42]],
        collisionVolumeType    = [[ellipsoid]],
        corpse                 = [[DEAD]],

        customParams           = {
            aimposoffset       = [[0 8 0]],
            midposoffset       = [[0 3 0]],
            modelradius        = [[21]],

            outline_x          = 80,
            outline_y          = 80,
            outline_yoff       = 12.5,
            def_scale=1,
        },

        explodeAs              = [[BIG_UNITEX]],
        footprintX             = 3,
        footprintZ             = 3,
        iconType               = [[vehicleassault]],
        leaveTracks            = true,
        maxSlope               = 18,
        maxWaterDepth          = 22,
        health                 = utils.consts.custom_health_const,
        metalCost              = utils.consts.custom_cost_const,
        movementClass          = [[TANK3]],
        noAutoFire             = false,
        noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE SUB DRONE]],
        objectName             = [[corraid.s3o]],
        script                 = [[custom_ravager.lua]],
        selfDestructAs         = [[BIG_UNITEX]],

        sfxtypes               = {

            explosiongenerators = {
                [[custom:RAIDMUZZLE]],
                [[custom:RAIDDUST]],
            },

        },
        sightDistance          = 385,
        speed                  = 88.5,
        trackOffset            = 6,
        trackStrength          = 5,
        trackStretch           = 1,
        trackType              = [[StdTank]],
        trackWidth             = 38,
        turninplace            = 0,
        turnRate               = 688,
        workerTime             = 0,


        featureDefs = {

            DEAD = {
                blocking               = false,
                featureDead            = [[HEAP]],
                footprintX             = 2,
                footprintZ             = 2,
                collisionVolumeOffsets = [[0 -5 0]],
                collisionVolumeScales  = [[42 42 42]],
                collisionVolumeType    = [[ellipsoid]],
                object                 = [[corraid_dead.s3o]],
            },


            HEAP = {
                blocking   = false,
                footprintX = 2,
                footprintZ = 2,
                object     = [[debris2x2c.s3o]],
            },
        },

    },
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.genChassisSpeedModify(1.2),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6)
    },
    weapons_slots={
        [1]={"projectile_targeter","line_targeter"}
    }
}