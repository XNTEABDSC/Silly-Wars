local utils=GameData.CustomUnits.utils
local chassis_defs=GameData.CustomUnits.chassis_defs

local function GenCUD(cudTable)
    local cudname,param=cudTable[1],cudTable[2]
    local chassis=chassis_defs[cudname]
    if not chassis then
        error("chassis " .. cudname .. " don't exist")
    end
    return chassis.genfn(param)
end
utils.GenCUD=GenCUD
GameData.CustomUnits.utils=utils