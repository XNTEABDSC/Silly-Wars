VFS.Include("gamedata/custom_units/utils.lua")

for key, value in pairs(GameData.CustomUnits.chassis_defs) do
    value.genUnitDefs()
end
