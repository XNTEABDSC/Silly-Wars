VFS.Include("LuaRules/Configs/custom_units/utils.lua")
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.Utilities.CustomUnits.utils

local MutateFn=utils.UseMutateTable(
    wacky_utils.mt_union({
        
        ---@param table CustomChassisDataModify
        motor=function (table,factor)
            table.cost=table.cost+factor
            table.thrust=table.thrust+factor*10
        end

    },utils.BasicChassisMutate)
)

local name = "custom_ravager"
return {
    name = name,
    genUnitDefs = function()
        --local name=name
        local unitDefSize=3
        local unitDef = {
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
                bait_level_default = 0,
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
            health                 = 1,
            iconType               = [[vehicleassault]],
            leaveTracks            = true,
            maxSlope               = 18,
            maxWaterDepth          = 22,
            metalCost              = 1,
            movementClass          = [[TANK3]],
            noAutoFire             = false,
            noChaseCategory        = [[TERRAFORM FIXEDWING SATELLITE SUB DRONE]],
            objectName             = [[corraid.s3o]],
            script                 = [[vehassault.lua]],
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
        }
        for i = 1, 6 do
            local newUD=Spring.Utilities.CopyTable(unitDef,true)
            local scale=i/unitDefSize
            newUD.customParams.def_scale= newUD.customParams.def_scale *scale
            UnitDefs[name..i]=lowerkeys( newUD )
        end
    end,
    genfn = function(params)
        
    end
}
