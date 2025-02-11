VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

local modifies = {
    utils.BasicChassisMutate.name,
    utils.BasicChassisMutate.armor,
    utils.BasicChassisMutate.add_weapon(1,"left hand"),
    utils.BasicChassisMutate.add_weapon(2,"right hand"),
    utils.BasicChassisMutate.add_weapon(3,"shoulder"),
    utils.BasicChassisMutate.add_weapon(4,"head aa turret"),
    utils.BasicChassisMutate.add_weapon(5,"head beam"),
    utils.genChassisSpeedModify(750)
}

local ModifyFn=utils.UseModifies(modifies)
local speed_base = 36
local name = "custom_detriment"
local humanName="Detriment"
local weapons_slots = {
    [1] = { "projectile_targeter", "beam_targeter" },
    [2] = { "projectile_targeter", "beam_targeter" },
    [3] = { "projectile_targeter", "beam_targeter" },
    [4] = { "aa_targeter" },
    [5] = { "beam_targeter"},
}

local sizeMin=2
local sizeMax=10
local unit_weapons, targeter_name_to_unit_weapon = utils.GenChassisUnitWeapons(weapons_slots)
local pic=[[unitpics/striderdetriment.png]]
local desc="Custom Detriment!"
local unitDef = {
    name                   = humanName,
    description            = desc,
    acceleration           = 0.328,
    activateWhenBuilt      = true,
    autoheal               = 100,
    brakeRate              = 1.435,
    builder                = false,
    buildPic               = [[striderdetriment.png]],
    canGuard               = true,
    canManualFire          = true,
    canMove                = true,
    canPatrol              = true,
    category               = [[LAND]],
    collisionVolumeOffsets = [[0 10 0]],
    collisionVolumeScales  = [[78 140 78]],
    collisionVolumeType    = [[cylY]],
    corpse                 = [[DEAD]],

    customParams           = {
        
        modelradius                = [[95]],
        draw_reload_num            = 3,
        selection_scale            = 1.4,
        decloak_footprint          = 6,

        stats_show_death_explosion = 1,

        outline_x                  = 230,
        outline_y                  = 230,
        outline_yoff               = 70,
    },

    --explodeAs              = [[NUCLEAR_MISSILE]],
    footprintX             = 4,
    footprintZ             = 4,
    iconType               = [[krogoth]],
    leaveTracks            = true,
    maxSlope               = 37,
    maxWaterDepth          = 5000,
    movementClass          = [[AKBOT4]],
    noAutoFire             = false,
    noChaseCategory        = [[TERRAFORM SATELLITE SUB FIXEDWING GUNSHIP]],
    objectName             = [[detriment.s3o]],
    script                 = [[custom_detri.lua]],
    --selfDestructAs         = [[NUCLEAR_MISSILE]],
    selfDestructCountdown  = 10,

    sfxtypes               = {
        explosiongenerators = {
            [[custom:dirtyfootstep]],
            [[custom:WARMUZZLE]],
            [[custom:emg_shells_l]],
            [[custom:extra_large_muzzle_flash_flame]],
            [[custom:extra_large_muzzle_flash_smoke]],
            [[custom:vindiback_large]],
            [[custom:rocketboots_muzzle]],
        },
    },

    sightEmitHeight        = 100,
    sightDistance          = 900,
    sonarDistance          = 900,
    speed                  = 36,
    trackOffset            = 0,
    trackStrength          = 8,
    trackStretch           = 1.4,
    trackType              = [[ComTrack]],
    trackWidth             = 60,
    turnRate               = 350,
    upright                = true,

    weapons                = unit_weapons,


    featureDefs = {

        DEAD = {
            blocking    = true,
            featureDead = [[HEAP]],
            footprintX  = 6,
            footprintZ  = 6,
            object      = [[Detriment_wreck.s3o]],
        },

        HEAP = {
            blocking   = false,
            footprintX = 4,
            footprintZ = 4,
            object     = [[debris4x4b.s3o]],
        },

    },
    health                 = utils.consts.custom_health_const,
    metalCost              = utils.consts.custom_cost_const,

}

---@type CustomChassisData
return {
    name = name,
    pic=pic,
    description=desc,
    humanName=humanName,
    genUnitDefs = function()
        utils.GetChassisUnitDef_DifferentSize(
            unitDef,name,sizeMin,sizeMax
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
