


if not GameData then
    GameData={}
end
if not GameData.CustomUnits then
    GameData.CustomUnits={}
end
if not GameData.CustomUnits.utils then
    local utils_gamedata={
    }
    GameData.CustomUnits.utils=utils_gamedata
    utils_gamedata.bias_factor=0.9
    local function TableMutate(mutate_table)
        return function (t,factor)
            if factor==nil then
                error("factor==nil")
            end
            for key, value in pairs(mutate_table) do
                if t[key]==nil then
                    error("table["..key.."]==nil")
                end
                t[key]=t[key]*factor^value
            end
        end
    end
    utils_gamedata.TableMutate=TableMutate
    local function UseMutateTable(mutaters)
        ---@generic T
        ---@param t T
        ---@return T
        return function (t,mutate_table)
            for key, value in pairs(mutate_table) do
                mutaters[key](t,value)
            end
            return t
        end
    end
    utils_gamedata.UseMutateTable=UseMutateTable
    --[=[
    local luaFiles=VFS.DirList("LuaRules/Utilities/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include(luaFiles[i])
    end]=]
    local luaFiles={
        "consts",
        "utils",
        "uidefs",
        "targeters",
        "weapon_slot_type",
        "CustomWeaponDataModify",
        "for_weapons",
        "custom_weapon_base",
        "weapons",
        "CustomUnitDataModify",
        "for_chassis",
        "custom_chassis_base",
        "chassises",
        "genfn"
    }--VFS.DirList("LuaRules/Utilities/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include("gamedata/custom_units/utils/" .. luaFiles[i] .. ".lua")
    end
    
end
return GameData.CustomUnits.utils