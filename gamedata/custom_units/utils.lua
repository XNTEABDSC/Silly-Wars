
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
            for key, value in pairs(mutate_table) do
                t[key]=t[key]*factor^value
            end
        end
    end
    local function MutateCostMassAnd(mutate_table)
        mutate_table.cost=1
        mutate_table.mass=1
        return mutate_table
    end
    utils_gamedata.TableMutate=TableMutate
    utils_gamedata.MutateCostMassAnd=MutateCostMassAnd
    local function UseMutateTable(mutaters)

        return function (t,mutate_table)
            for key, value in pairs(mutate_table) do
                mutaters[key](t,value)
            end
            return t
        end
    end
    utils_gamedata.UseMutateTable=UseMutateTable
    --[=[
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include(luaFiles[i])
    end]=]
    local luaFiles={
        "consts",
        "CustomWeaponDataModify",
        "for_weapons",
        "aoe",
        "weapons",
        "CustomUnitDataModify",
        "for_chassis"
    }--VFS.DirList("LuaRules/Configs/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include("gamedata/custom_units/utils/" .. luaFiles[i] .. ".lua")
    end
    
end
return GameData.CustomUnits.utils