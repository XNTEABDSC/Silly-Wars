if not GameData.CustomUnits.weapons_defs then
    ---@class CustomWeaponBaseData
    ---@field name string
    ---@field genfn fun(params:table):CustomWeaponDataModify
    ---@field genWeaponDef fun():table
    ---@field pic string
    ---@field modifies list<CustomModify>
    ---@field genUIFn ModifyUIgenfn
    ---@field humanName string
    
    ---@type {[string]:CustomWeaponBaseData}
    local weapons_defs={}
    local luaFiles=VFS.DirList("gamedata/custom_units/weapons", "*.lua") or {}
    for i = 1, #luaFiles do
        local result=VFS.Include(luaFiles[i])
        weapons_defs[result.name]=result
    end
    GameData.CustomUnits.weapons_defs=weapons_defs

    local custom_weapon_defs_raw={}
    for key, value in pairs(weapons_defs) do
        Spring.Utilities.CopyTable(value.genWeaponDef(),true,custom_weapon_defs_raw)
    end
    GameData.CustomUnits.custom_weapon_defs_raw=custom_weapon_defs_raw
end