
local utils=Spring.Utilities.CustomUnits.utils


local spSetUnitWeaponState=Spring.SetUnitWeaponState

---@param customWpnData CustomWeaponDataFinal
utils.SetUnitWeaponToCustom=function (unitID,wpnnum,customWpnData)
    spSetUnitWeaponState(unitID,wpnnum,{
        reloadTime=customWpnData.reload_time,
        sprayAngle=customWpnData.sprayAngle,
        range=customWpnData.range,
        projectileSpeed=customWpnData.speed,
        burst=customWpnData.burst,
        burstRate=customWpnData.burstRate,
        projectiles=customWpnData.projectiles,
    })
end



---@param CustomUnit CustomChassisDataFinal
utils.SetCustomUnit=function (unitID,CustomUnit)
    GG.Attributes.AddEffect(unitID,"custom_unit",{
        healthMult=CustomUnit.health_mut,
        move=CustomUnit.speed_mut,
        turn=CustomUnit.speed_mut,
        accel=CustomUnit.speed_mut,
        cost=CustomUnit.cost_mut,
    })
end


Spring.Utilities.CustomUnits.utils=utils