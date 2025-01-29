local utils=GameData.CustomUnits.utils

function utils.ACustomUnitDataModify()
    ---@class CustomUnitDataModify
    ---@field UnitDefName string
    ---@field cost number
    -- ---@field mass number
    ---@field health number
    ---@field motor number motor / mass = speed
    ---@field size number
    ---@field weapons {[number]:CustomWeaponDataModify}
    ---@field chassis_name string
    -- ---@field speed_base number
    local o={
        weapons={},
        motor=0,
        health=0,
        size=0,
        cost=0,
        --speed_base=100,
    }
    return o
end

GameData.CustomUnits.utils=utils