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
    ---@field custom_weapon_num_to_unit_weapon_num {[integer]:integer}
    ---@field unit_weapon_num_to_custom_weapon_num {[integer]:integer}
    -- ---@field speed_base number
    local o={
        weapons={},
        motor=0,
        health=0,
        size=0,
        cost=0,
        custom_weapon_num_to_unit_weapon_num={},
        unit_weapon_num_to_custom_weapon_num={},
        --speed_base=100,
    }
    return o
end

GameData.CustomUnits.utils=utils