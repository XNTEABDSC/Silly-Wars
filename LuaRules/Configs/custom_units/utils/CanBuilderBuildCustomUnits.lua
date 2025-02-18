local utils=Spring.Utilities.CustomUnits.utils


--local spGetUnitDefID=Spring.GetUnitDefID

local CustomUnitBuilders={}

for udid, ud in pairs(UnitDefs) do
    if ud.customParams.custom_unit_is_custom_unit_builder then
        CustomUnitBuilders[udid]=true
    end
end

utils.CustomUnitBuilders=CustomUnitBuilders

utils.CanBuilderBuildCustomUnits=function (builderID,builderUdId,cud)
    if not CustomUnitBuilders[builderUdId] then
        return false, "builder is not custom unit builder"
    end
    return true
end

Spring.Utilities.CustomUnits.utils=utils

