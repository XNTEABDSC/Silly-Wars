VFS.Include("gamedata/custom_units/utils.lua")

for key, value in pairs(Spring.GameData.CustomUnits.custom_weapon_defs_raw) do
    WeaponDefs[key]=lowerkeys(value)
end

--[=[
for key, value in pairs(Spring.GameData.CustomUnits.weapons_defs) do
    value.genWeaponDef()
    --WeaponDefs[value.name]=lowerkeys()
end
]=]

for key, value in pairs(Spring.GameData.CustomUnits.utils.targeterweapondefs) do
    WeaponDefs[key]=lowerkeys(value)
end