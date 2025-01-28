
local utils=Spring.Utilities.CustomUnits.utils


local spSetUnitWeaponState=Spring.SetUnitWeaponState
---@param customWpnData CustomWeaponDataFinal
local function SetUnitWeaponToCustom(unitID,wpnnum,customWpnData)
    GG.Attributes.AddEffect(unitID,"custom_unit_wpn_" .. wpnnum,{
        weaponNum=wpnnum,
        reload=1/customWpnData.reload_speed_mut,
        range=customWpnData.range_mut,
        burst=customWpnData.burst_mut,
        burstRate=customWpnData.burstRate_mut,
        projectiles=customWpnData.projectiles_mut,
        projSpeed=customWpnData.projSpeed_mut,
        sprayAngle=customWpnData.sprayAngle
    })
    --[=[
    spSetUnitWeaponState(unitID,wpnnum,{
        reloadTime=customWpnData.reload_time,
        sprayAngle=customWpnData.sprayAngle,
        range=customWpnData.range,
        projectileSpeed=customWpnData.speed,
        burst=customWpnData.burst,
        burstRate=customWpnData.burstRate,
        projectiles=customWpnData.projectiles,
    })]=]
end
utils.SetUnitWeaponToCustom=SetUnitWeaponToCustom



---@param CustomUnit CustomChassisDataFinal
utils.SetCustomUnit=function (unitID,CustomUnit)
    GG.Attributes.AddEffect(unitID,"custom_unit",{
        healthMult=CustomUnit.health_mut,
        move=CustomUnit.speed_mut,
        turn=CustomUnit.speed_mut,
        accel=CustomUnit.speed_mut,
        cost=CustomUnit.cost_mut,
    })
    for key, value in pairs(CustomUnit.weapons) do
        SetUnitWeaponToCustom(unitID,key,value)
    end
end


Spring.Utilities.CustomUnits.utils=utils