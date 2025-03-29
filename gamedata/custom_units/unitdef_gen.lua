VFS.Include("gamedata/custom_units/utils.lua")

for key, value in pairs(GameData.CustomUnits.chassis_unit_def_raw) do
    UnitDefs[key]=lowerkeys(value)
end
