
local utils=Spring.Utilities.CustomUnits.utils

local spGetUnitDefID=Spring.GetUnitDefID
--local spSetUnitWeaponState=Spring.SetUnitWeaponState

---set Attributes of Custom Unit Weapon for correct shot
---@param customWpnData CustomWeaponDataFinal
local function SetUnitWeaponToCustom(unitID,targeter_weapon_num,customWpnData)
    local wd=WeaponDefs[UnitDefs[spGetUnitDefID(unitID)].weapons[targeter_weapon_num].weaponDef]
    Spring.Echo("DEBUG: OnAdd: customWpnData.sprayAngle: " .. tostring(customWpnData.sprayAngle))
    GG.Attributes.AddEffect(unitID,"custom_unit_wpn_" .. targeter_weapon_num,{
        weaponNum=targeter_weapon_num,
        reload=1/(customWpnData.reload_time/wd.reload),
        range=customWpnData.range/wd.range,
        burst=customWpnData.burst/wd.salvoSize,
        burstRate=customWpnData.burstRate/wd.salvoDelay,
        projectiles=customWpnData.projectiles/wd.projectiles,
        projSpeed=customWpnData.projSpeed/wd.projectilespeed,
        sprayAngle=customWpnData.sprayAngle
    })
    --[=[
    GG.Attributes.AddEffect(unitID,"custom_unit_wpn_" .. wpnnum,{
        weaponNum=wpnnum,
        reload=customWpnData.reload_speed_mut,
        range=customWpnData.range_mut,
        burst=customWpnData.burst_mut,
        burstRate=customWpnData.burstRate_mut,
        projectiles=customWpnData.projectiles_mut,
        projSpeed=customWpnData.projSpeed_mut,
        sprayAngle=customWpnData.sprayAngle
    })]=]
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


---Set Custom Unit to its state
---@param CustomUnit CustomUnitDataFinal
utils.SetCustomUnit=function (unitID,CustomUnit)
    GG.Attributes.AddEffect(unitID,"custom_unit",{
        healthMult=CustomUnit.health_mut,
        move=CustomUnit.speed_mut,
        turn=CustomUnit.speed_mut,
        accel=CustomUnit.speed_mut,
        cost=CustomUnit.cost_mut,
    })
    for custom_wpn_num, cwd in pairs(CustomUnit.weapons) do
        local targeter_wpn_num=CustomUnit.custom_weapon_num_to_unit_weapon_num[custom_wpn_num]
        SetUnitWeaponToCustom(unitID,targeter_wpn_num,cwd)
    end


    local env_SetCustomUnitScript = Spring.UnitScript.GetScriptEnv(unitID).SetCustomUnitScript
    if not env_SetCustomUnitScript then
        Spring.Echo("Error: CustomUnits: unit's script don't have global function SetCustomUnitScript")
    else
        Spring.UnitScript.CallAsUnit(unitID, env_SetCustomUnitScript)
    end
    

end


Spring.Utilities.CustomUnits.utils=utils