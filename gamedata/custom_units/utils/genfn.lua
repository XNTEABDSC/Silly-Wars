local utils=Spring.GameData.CustomUnits.utils
local chassis_defs=Spring.GameData.CustomUnits.chassis_defs


---chassis,param=cudTable[1],cudTable[2];  chassis.genfn(param)
local function GenCustomUnitData(cudTable)
    local cudname,param=cudTable[1],cudTable[2]
    local chassis=chassis_defs[cudname]
    if not chassis then
        error("chassis " .. cudname .. " don't exist")
    end
    return chassis.genfn(param)
end
utils.GenCustomUnitData=GenCustomUnitData
Spring.GameData.CustomUnits.utils=utils