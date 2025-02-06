
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

local modifies={
    utils.BasicChassisMutate.name,
    utils.BasicChassisMutate.armor,
    utils.BasicChassisMutate.add_weapon_1,
    utils.genChassisSpeedModify(1000)
}
local ModifyFn=utils.UseModifies(modifies)
--[=[
local MutateFn=utils.UseMutateTable(
    wacky_utils.mt_union({
        
        ---@param table CustomUnitDataModify
        motor=function (table,factor)
            table.cost=table.cost+factor
            table.motor=table.motor+factor*75
        end

    },utils.BasicChassisMutate)
)]=]
local speed_base=88.5
--custom_table.speed_base=speed_base
local name = "custom_ravager"
local humanName="Car (Ravager)"--name
local weapons_slots={
    [1]={"projectile_targeter","beam_targeter"}
}

local unit_weapons,targeter_name_to_unit_weapon=utils.GenChassisUnitWeapons(weapons_slots)
local pic=[[unitpics/vehassault.png]]
local desc="car"

---@type CustomChassisData
return {
    name = name,
    pic=pic,
    humanName=humanName,
    description=desc,
    genUnitDefs = function()
        local unitDefSize=3
        local aunitDef = {
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

            weapons=unit_weapons,
        }
        for i = 1, 6 do
            local newUD=Spring.Utilities.CopyTable(aunitDef,true)
            local scale=i/unitDefSize
            newUD.customParams.def_scale= newUD.customParams.def_scale *scale
            UnitDefs[name..i]=lowerkeys( newUD )
        end
    end,
    genfn = function(params)
        local cud=utils.ACustomUnitDataModify()
        cud.chassis_name=name
        local res=ModifyFn(cud,params)
        for key, value in pairs(res.weapons) do
            res.cost=res.cost+value.cost
        end
        local size = utils.GetUnitSize(res)
        if size<1 then
            size=1
        end
        if size>6 then
            size=6
        end
        --res.chassis_name=name
        res.UnitDefName=name .. size
        return res
    end,
    weapon_slots=weapons_slots,
    targeter_name_to_unit_weapon=targeter_name_to_unit_weapon,
    speed_base=speed_base,
    modifies=modifies,
    genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies)),

}
