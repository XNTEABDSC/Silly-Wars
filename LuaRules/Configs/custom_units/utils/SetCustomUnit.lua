
local utils=Spring.Utilities.CustomUnits.utils
---@param CustomUnit CustomChassisDataFinal
utils.SetCustomUnit=function (unitID,CustomUnit)
    GG.Attributes.AddEffect(unitID,"custom_unit",{
        healthMult=CustomUnit.health_mut,
        move=CustomUnit.speed_mut,
        turn=CustomUnit.speed_mut,
        accel=CustomUnit.speed_mut,
        cost=CustomUnit.cost,
        mass=CustomUnit.mass,
    })
end
Spring.Utilities.CustomUnits.utils=utils