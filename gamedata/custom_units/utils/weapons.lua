if not GameData then
    Spring={}
end
if not GameData.CustomUnits then
    Spring.Utilities.CustomUnits={}
end
if not GameData.CustomUnits.weapons_defs then
    local weapons_defs={}
    local luaFiles=VFS.DirList("LuaRules/Configs/custom_units/weapons", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        weapons_defs[result.name]=result
    end
    GameData.CustomUnits.weapons_defs=weapons_defs
end