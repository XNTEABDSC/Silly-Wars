VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

local modifies={
    utils.BasicChassisMutate.name,
    utils.BasicChassisMutate.armor,
    utils.BasicChassisMutate.add_weapon(1,"left gun"),
    utils.BasicChassisMutate.add_weapon(2,"right gun"),
    utils.genChassisSpeedModify(750)
}

local ModifyFn=utils.UseModifies(modifies)
local speed_base = 54
--custom_table.speed_base=speed_base
local name = "custom_hermit"
local humanName="Spider (Hermit)"
local weapons_slots = {
    [1] = { "projectile_targeter", "beam_targeter" ,"line_targeter"},
    [2] = { "projectile_targeter", "beam_targeter" ,"line_targeter"}
}
local sizeMin=1
local sizeMax=6
local unit_weapons, targeter_name_to_unit_weapon = utils.GenChassisUnitWeapons(weapons_slots)
local pic=[[unitpics/spiderassault.png]]
local desc="spider"
---@type CustomChassisData
return {
    name = name,
    pic=pic,
    description=desc,
    humanName=humanName,
    genUnitDefs = function()
        local aunitDef = {
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

            weapons                = unit_weapons,


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
        }
        utils.GetChassisUnitDef_DifferentSize(
            aunitDef,name,sizeMin,sizeMax
        )
    end,
    genfn = function(params)
        local cud = utils.ACustomUnitDataModify()
        cud.chassis_name = name
        local res = ModifyFn(cud, params)
        for key, value in pairs(res.weapons) do
            res.cost = res.cost + value.cost
        end
        local mass=wacky_utils.GetMass(res.health,res.cost)
        local size = utils.GetUnitSize_ThrowError(mass,humanName,sizeMin,sizeMax)
        res.chassis_name = name
        res.UnitDefName = name .. size
        return res
    end,
    weapon_slots = weapons_slots,
    targeter_name_to_unit_weapon = targeter_name_to_unit_weapon,
    speed_base = speed_base,
    modifies=modifies,
    genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies))
}
