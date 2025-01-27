local utils=Spring.Utilities.CustomUnits.utils
---@param CustomChassisDataModify CustomUnitDataModify
function utils.GenCustomChassisDataFinal(CustomChassisDataModify)
    
    local mass=Spring.Utilities.wacky_utils.GetMass(CustomChassisDataModify.health,CustomChassisDataModify.cost)
    ---@class CustomChassisDataFinal
    ---@field unitDef unitDefId
    -- ---@field mass_mut number mass_mut = mass/(GetMass)
    ---@field cost_mut number cost_mut = cost/1000
    ---@field speed_mut number speed_mut = speed/100
    -- ---@field turnspeed_mut number health_mut = hp/1000
    ---@field health_mut number health_mut = hp/1000
    ---@field weapons {[number]:CustomWeaponDataFinal}
    local o={
        health_mut=CustomChassisDataModify.health/1000,
        cost_mut=CustomChassisDataModify.cost/1000,
        speed_mut=CustomChassisDataModify.motor/mass/CustomChassisDataModify.speed_base,
        unitDef=UnitDefNames[CustomChassisDataModify.UnitDefName]
    }
    local weapons={}
    for key, value in pairs(CustomChassisDataModify.weapons) do
        weapons[key]=utils.GetCustomWeaponDataFinal(value)
    end
    o.weapons=weapons
    return o
end

Spring.Utilities.CustomUnits.utils=utils