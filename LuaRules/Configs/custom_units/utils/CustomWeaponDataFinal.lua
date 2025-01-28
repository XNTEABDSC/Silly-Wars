local utils=Spring.Utilities.CustomUnits.utils

---@param CustomWeaponDataModify CustomWeaponDataModify
---@return CustomWeaponDataFinal
utils.GetCustomWeaponDataFinal=function (CustomWeaponDataModify)
    local wd=WeaponDefNames[CustomWeaponDataModify.weapon_def_name]

    ---@class CustomWeaponDataFinal
    ---@field damages {[number]:number}
    ---@field projSpeed number
    ---@field projSpeed_mut number
    ---@field range number
    ---@field range_mut number
    ---@field reload_time number
    ---@field reload_speed_mut number
    ---@field weapon_def WeaponDefId
    ---@field aoe nil|number
    ---@field edgeEffectiveness nil|number
    ---@field explosionSpeed nil|number
    ---@field explosionGenerator nil|string
    ---@field sprayAngle nil|number
    ---@field burst nil|number
    ---@field burst_mut nil|number
    ---@field projectiles nil|number
    ---@field projectiles_mut nil|number
    ---@field burstRate nil|number
    ---@field burstRate_mut nil|number
    ---@field craterMult nil|number
    ---@field craterBoost nil|number
    ---@field impulseFactor nil|number
    ---@field impulseBoost nil|number
    local o={
        projSpeed=wd.projectilespeed*CustomWeaponDataModify.projSpeed_mut,
        projSpeed_mut=CustomWeaponDataModify.projSpeed_mut,
        range=wd.range*CustomWeaponDataModify.range_mut,
        range_mut=CustomWeaponDataModify.range_mut,
        reload_time=wd.reload *CustomWeaponDataModify.reload_time_mut,
        reload_speed_mut=1/CustomWeaponDataModify.reload_time_mut,
        explosionGenerator=CustomWeaponDataModify.explosionGenerator or nil,
        aoe=CustomWeaponDataModify.aoe or nil,
        edgeEffectiveness=CustomWeaponDataModify.edgeEffectiveness or nil,
        sprayAngle=CustomWeaponDataModify.sprayAngle_add and (wd.sprayAngle +CustomWeaponDataModify.sprayAngle_add) or nil,
        burst=CustomWeaponDataModify.burst_mut*wd.salvoSize ,
        burst_mut=CustomWeaponDataModify.burst_mut,
        projectiles=CustomWeaponDataModify.projectiles_mut*wd.projectiles,
        projectiles_mut=CustomWeaponDataModify.projectiles_mut,
        burstRate=CustomWeaponDataModify.burstRate_mut*wd.salvoDelay ,
        burstRate_mut=CustomWeaponDataModify.burstRate_mut,
        explosionSpeed=CustomWeaponDataModify.explosionSpeed or nil,
        weapon_def=wd.id,
        craterMult=CustomWeaponDataModify.craterMult_add and (CustomWeaponDataModify.craterMult_add+wd.damages.craterMult) or nil,
        craterBoost=CustomWeaponDataModify.craterBoost_add and (CustomWeaponDataModify.craterBoost_add+wd.damages.craterBoost) or nil,
        impulseFactor=CustomWeaponDataModify.impulseFactor_add and (CustomWeaponDataModify.impulseFactor_add+wd.damages.impulseFactor) or nil,
        impulseBoost=CustomWeaponDataModify.impulseBoost_add and (CustomWeaponDataModify.impulseBoost_add+wd.damages.impulseBoost) or nil,
        craterAreaOfEffect=CustomWeaponDataModify.craterAreaOfEffect or nil
    }

    --local damage_default=wd.damages.default*CustomWeaponDataModify.damage_default_mut

    local damages=Spring.Utilities.CopyTable(wd.damages,true)

    for i=0,#damages do
        damages[i]=damages[i]*CustomWeaponDataModify.damage_default_mut
    end

    for armorType, value in pairs(CustomWeaponDataModify.damages_mut) do
        local armorTypeId=Game.armorTypes[armorType]
        damages[armorTypeId]=damages[armorTypeId]*value
    end

    o.damages=damages

    return o
end

Spring.Utilities.CustomUnits.utils=utils