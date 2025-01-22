
if not Spring then
    Spring={}
end
if not Spring.Utilities then
    Spring.Utilities={}
end
if not Spring.Utilities.CustomUnits then
    Spring.Utilities.CustomUnits={}
end
if not Spring.Utilities.CustomUnits.utils then
    local utils={
    }
    Spring.Utilities.CustomUnits.utils=utils
    utils.bias_factor=0.9
    local function TableMutate(mutate_table)
        return function (wpn,factor)
            for key, value in pairs(mutate_table) do
                wpn[key]=wpn[key]*factor^value
            end
        end
    end
    local function MutateCostMassAnd(mutate_table)
        mutate_table.cost=1
        mutate_table.mass=1
        return mutate_table
    end
    utils.TableMutate=TableMutate
    utils.MutateCostMassAnd=MutateCostMassAnd
    local function UseMutateTable(mutaters)

        return function (t,mutate_table)
            for key, value in pairs(mutate_table) do
                mutaters[key](t,value)
            end
            return t
        end
    end
    utils.UseMutateTable=UseMutateTable
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include(luaFiles[i])
    end
end
return Spring.Utilities.CustomUnits.utils