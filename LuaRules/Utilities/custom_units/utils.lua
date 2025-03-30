
if not Spring.GetModOptions().custon_units then return end

VFS.Include("gamedata/custom_units/utils.lua")
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
    --[=[
    local luaFiles=VFS.DirList("LuaRules/Utilities/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include(luaFiles[i])
    end]=]
    local luaFiles={
        "targeters",
        "CanBuilderBuildCustomUnits",
        "CustomWeaponDataFinal",
        "CustomUnitDataFinal",
        "SetCustomUnit",
        "ChangeTargeterToRealProj",
        "GenCustomUnitDef",
        "GenCUDViewText",
        "CustomUnitDesignerUI",
    }--VFS.DirList("LuaRules/Utilities/custom_units/utils", "*.lua") or {}
    for i = 1, #luaFiles do
        VFS.Include("LuaRules/Utilities/custom_units/utils/" .. luaFiles[i] .. ".lua")
    end

end
return Spring.Utilities.CustomUnits.utils