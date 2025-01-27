VFS.Include("gamedata/custom_units/utils.lua")

for key, value in pairs(GameData.CustomUnits.weapons_defs) do
    WeaponDefs[value.name]=lowerkeys(value.weaponDef)
end
