local utils=GameData.CustomUnits.utils

VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils

function utils.ACustomUnitDataModify()
    ---Data of a custom unit that can be modified
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

---get the movedef size of a unit
---@param mass number
function utils.GetUnitSize(mass)
    --local mass = wacky_utils.GetMass(CustomUnitDataModify.health, CustomUnitDataModify.cost)
    local mass_3 = math.pow(mass, 1 / 3)
    local size = math.floor(mass_3 / 2)
    return size
end

---@param mass number
---@param sizeMin number
---@param sizeMax number
function utils.GetUnitSize_ThrowError(mass,humanName,sizeMin,sizeMax)
    local size=utils.GetUnitSize(mass)
    if size < sizeMin then
        error("unit is too small. add things.\nfor the chassis " .. humanName ..", mass: " .. mass .. " size: " .. size .. "\nsize should be >=" .. sizeMin)
        --size = 1
    end
    if size > sizeMax then
        error("unit is too big. remove things.\nfor the chassis " .. humanName ..", mass: " .. mass .. " size: " .. size .. "\nsize should be <=" .. sizeMax)
        --size = 6
    end
    return size
end

function utils.GetChassisUnitDef_DifferentSize(unitDefBase,name,sizeMin,sizeMax,otherModFn)
    if not unitDefBase.customParams.def_scale then
        unitDefBase.customParams.def_scale=1
    end
    local unitDefSize=unitDefBase.footprintX
    for i = sizeMin, sizeMax do
        local newUD = Spring.Utilities.CopyTable(unitDefBase, true)
        local scale = i / unitDefSize
        newUD.customParams.def_scale = newUD.customParams.def_scale * scale
        if otherModFn then
            otherModFn(newUD,i)
        end
        UnitDefs[name .. i] = lowerkeys(newUD)
    end
end

GameData.CustomUnits.utils=utils