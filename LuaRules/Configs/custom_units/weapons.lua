if not Spring then
    Spring={}
end
if not Spring.Utilities then
    Spring.Utilities={}
end
if not Spring.Utilities.CustomUnits then
    Spring.Utilities.CustomUnits={}
end
if not Spring.Utilities.CustomUnits.weapons_defs then
    local weapons_defs={}
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/weapons", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        weapons_defs[result.name]=result
    end
    Spring.Utilities.CustomUnits.weapons_defs=weapons_defs
end