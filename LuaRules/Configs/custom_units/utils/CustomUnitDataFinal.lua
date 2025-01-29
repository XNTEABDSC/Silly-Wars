local utils=Spring.Utilities.CustomUnits.utils
local chassises=GameData.CustomUnits.chassis_defs
---@param CustomChassisDataModify CustomUnitDataModify
function utils.GenCustomChassisDataFinal(CustomChassisDataModify)
    
    local mass=Spring.Utilities.wacky_utils.GetMass(CustomChassisDataModify.health,CustomChassisDataModify.cost)
    ---@class CustomUnitDataFinal
    ---@field unitDef unitDefId
    -- ---@field mass_mut number mass_mut = mass/(GetMass)
    ---@field cost_mut number cost_mut = cost/1000
    ---@field speed_mut number speed_mut = speed/100
    -- ---@field turnspeed_mut number health_mut = hp/1000
    ---@field health_mut number health_mut = hp/1000
    ---@field weapons {[number]:CustomWeaponDataFinal}
    ---@field chassis_name string
    ---@field unit_weapon_num_to_custom_weapon_num {[integer]:integer}
    ---@field custom_weapon_num_to_unit_weapon_num {[integer]:integer}
    local o={
        health_mut=CustomChassisDataModify.health/1000,
        cost_mut=CustomChassisDataModify.cost/1000,
        speed_mut=CustomChassisDataModify.motor/mass/(chassises[CustomChassisDataModify.chassis_name].speed_base),
        unitDef=UnitDefNames[CustomChassisDataModify.UnitDefName].id,
        chassis_name=CustomChassisDataModify.chassis_name,
        unit_weapon_num_to_custom_weapon_num=CustomChassisDataModify.unit_weapon_num_to_custom_weapon_num,
        custom_weapon_num_to_unit_weapon_num=CustomChassisDataModify.custom_weapon_num_to_unit_weapon_num,
    }
    local weapons={}
    for key, value in pairs(CustomChassisDataModify.weapons) do
        weapons[key]=utils.GetCustomWeaponDataFinal(value)
    end
    o.weapons=weapons
    return o
end

Spring.Utilities.CustomUnits.utils=utils