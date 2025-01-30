if not GameData.CustomUnits.weapons_defs then
    ---@class CustomWeaponBaseData
    ---@field name string
    ---@field genfn fun(params:table):CustomWeaponDataModify
    ---@field weaponDef any
    ---@field pic string
    
    ---@type {[string]:CustomWeaponBaseData}
    local weapons_defs={}
    local luaFiles=VFS.DirList("gamedata/custom_units/weapons", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        weapons_defs[result.name]=result
    end
    GameData.CustomUnits.weapons_defs=weapons_defs
end