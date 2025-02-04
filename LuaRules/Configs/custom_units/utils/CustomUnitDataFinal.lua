local utils=Spring.Utilities.CustomUnits.utils
local chassises=GameData.CustomUnits.chassis_defs
---@param CustomUnitDataModify CustomUnitDataModify
function utils.GenCustomUnitDataFinal(CustomUnitDataModify)
    
    local mass=Spring.Utilities.wacky_utils.GetMass(CustomUnitDataModify.health,CustomUnitDataModify.cost)
    local speed=CustomUnitDataModify.motor/mass
    ---@class CustomUnitDataFinal
    ---@field CustomUnitDataModify CustomUnitDataModify
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
    ---@field name string|nil
    --
    ---@field cost number
    ---@field health number
    ---@field speed number
    ---@field mass number
    local o={
        health_mut=CustomUnitDataModify.health/1000,
        cost_mut=CustomUnitDataModify.cost/1000,
        speed_mut=speed/(chassises[CustomUnitDataModify.chassis_name].speed_base),
        unitDef=UnitDefNames[CustomUnitDataModify.UnitDefName].id,
        chassis_name=CustomUnitDataModify.chassis_name,
        unit_weapon_num_to_custom_weapon_num=CustomUnitDataModify.unit_weapon_num_to_custom_weapon_num,
        custom_weapon_num_to_unit_weapon_num=CustomUnitDataModify.custom_weapon_num_to_unit_weapon_num,
        name=CustomUnitDataModify.name,
        CustomUnitDataModify=CustomUnitDataModify,
        cost=CustomUnitDataModify.cost,
        health=CustomUnitDataModify.health,
        speed=speed,
        mass=mass,
    }
    local weapons={}
    for key, value in pairs(CustomUnitDataModify.weapons) do
        weapons[key]=utils.GetCustomWeaponDataFinal(value)
    end
    o.weapons=weapons
    return o
end

Spring.Utilities.CustomUnits.utils=utils