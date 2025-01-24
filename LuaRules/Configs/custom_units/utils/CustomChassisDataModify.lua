local utils=Spring.Utilities.CustomUnits.utils

function utils.a_custom_chassis_data()
    ---@class CustomChassisDataModify
    ---@field UnitDefName string
    ---@field cost number
    ---@field mass number
    ---@field health number
    ---@field speed number
    ---@field size number
    ---@field weapons {[number]:CustomWeaponDataModify}
    local o={
        
    }
    return o
end

Spring.Utilities.CustomUnits.utils=utils