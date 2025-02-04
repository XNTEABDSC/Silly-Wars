local utils=GameData.CustomUnits.utils

VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils

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
    ---@field name string|nil
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

---@param CustomUnitDataModify CustomUnitDataModify
function utils.GetUnitSize(CustomUnitDataModify)
    local mass = wacky_utils.GetMass(CustomUnitDataModify.health, CustomUnitDataModify.cost)
    local mass_3 = math.pow(mass, 1 / 3)
    local size = math.floor(mass_3 / 2)
    return size
end

GameData.CustomUnits.utils=utils