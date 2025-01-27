
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
    --[=[
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include(luaFiles[i])
    end]=]
    local luaFiles={
        ""
    }--VFS.DirList("LuaRules/Configs/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include("LuaRules/Configs/custom_units/utils/" .. luaFiles[i] .. ".lua")
    end

end
return Spring.Utilities.CustomUnits.utils