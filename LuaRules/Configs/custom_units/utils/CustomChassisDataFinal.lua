local utils=Spring.Utilities.CustomUnits.utils
---@param CustomChassisDataModify CustomChassisDataModify
function utils.GenCustomChassisDataFinal(CustomChassisDataModify)
    
    ---@class CustomChassisDataFinal
    ---@field unitDef unitDefId
    -- ---@field mass_mut number mass_mut = mass/(GetMass)
    ---@field cost_mut number cost_mut = cost/1000
    ---@field speed_mut number speed_mut = speed/100
    ---@field turnspeed_mut number health_mut = hp/1000
    ---@field health_mut number health_mut = hp/1000
    ---@field Weapons {[number]:CustomWeaponDataFinal}
    local o={
        health_mut=CustomChassisDataModify.health/1000,
        cost_mut=CustomChassisDataModify.cost/1000

    }
    return o
end

Spring.Utilities.CustomUnits.utils=utils