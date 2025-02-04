VFS.Include("gamedata/custom_units/utils.lua")

for key, value in pairs(GameData.CustomUnits.weapons_defs) do
    value.genWeaponDef()
    --WeaponDefs[value.name]=lowerkeys()
end

for key, value in pairs(GameData.CustomUnits.utils.targeterweapondefs) do
    WeaponDefs[key]=value
end