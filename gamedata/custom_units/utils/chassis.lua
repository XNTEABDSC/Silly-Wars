if not GameData then
    Spring={}
end
if not GameData.CustomUnits then
    Spring.Utilities.CustomUnits={}
end
if not GameData.CustomUnits.unit_defs then
    local unit_defs={}
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/chassises", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        unit_defs[result.name]=result
    end
    GameData.CustomUnits.unit_defs=unit_defs
end