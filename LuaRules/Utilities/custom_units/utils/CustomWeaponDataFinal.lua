local utils=Spring.Utilities.CustomUnits.utils
local const=Spring.GameData.CustomUnits.utils.consts
local custom_targeter_proj_speed=500
--local custom_targeter_damage=500
local custom_targeter_reloadtime=2
local custom_targeter_range=600
local custom_targeter_burst=const.custom_targeter_burst
local custom_targeter_burstRate=const.custom_targeter_burstRate
local custom_targeter_projectiles=const.custom_targeter_projectiles
---@param CustomWeaponDataModify CustomWeaponDataModify
---@return CustomWeaponDataFinal
utils.GenCustomWeaponDataFinal=function (CustomWeaponDataModify)
    local wd=WeaponDefNames[CustomWeaponDataModify.weapon_def_name]
    if not wd then
        error("weapon def " .. CustomWeaponDataModify.weapon_def_name .. " dont't exist")
    end
    local projSpeed=wd.projectilespeed*CustomWeaponDataModify.projSpeed_mut
    local range=wd.range*CustomWeaponDataModify.range_mut
    local reload_time=wd.reload *CustomWeaponDataModify.reload_time_mut
    local burst=CustomWeaponDataModify.burst_mut*wd.salvoSize
    local burstRate=CustomWeaponDataModify.burstRate_mut*wd.salvoDelay
    local projectiles=CustomWeaponDataModify.projectiles_mut*wd.projectiles
    local ttl
    if wd.type == "Cannon" and wd.flightTime == 0 then
        ttl = 1500 -- Needed to appease the unspeakable evil: https://github.com/beyond-all-reason/spring/issues/704
    else
        ttl = wd.flightTime or wd.beamTTL or 9000
    end
    local tracks=CustomWeaponDataModify.tracks
    if tracks==nil  then
        tracks=wd.tracks
    end

    local eg=CustomWeaponDataModify.explosionGenerator
    local egcustom
    if eg and eg:find("custom:") then
        egcustom=eg:sub(("custom:"):len()+1)
    end
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
    ---@field sprayAngle number
    ---@field burst number
    ---@field burst_mut number
    ---@field projectiles number
    ---@field projectiles_mut number
    ---@field burstRate number
    ---@field burstRate_mut number
    ---@field craterMult nil|number
    ---@field craterBoost nil|number
    ---@field impulseFactor nil|number
    ---@field impulseBoost nil|number
    ---@field gravity nil|number
    ---@field tracks boolean
    ---@field model string
    ---@field name string|nil
    ---@field ttl number|nil
    ---@field cegTag nil|string
    ---@field soundHit string|nil --TODO
    ---@field soundStart string|nil
    ---@field explosionGeneratorCustom nil|string
    ---@field cost number
    local o={
        projSpeed=projSpeed,
        projSpeed_mut=projSpeed/custom_targeter_proj_speed,
        range=range,
        range_mut=range/custom_targeter_range,
        reload_time=reload_time,
        reload_speed_mut=custom_targeter_reloadtime/reload_time,
        explosionGenerator=
        CustomWeaponDataModify.explosionGenerator or nil,
        aoe=
        CustomWeaponDataModify.aoe or 
        -- wd.damageAreaOfEffect 
        nil, 
        edgeEffectiveness=
        CustomWeaponDataModify.edgeEffectiveness or 
        -- wd.edgeEffectiveness or
        nil ,
        sprayAngle=wd.sprayAngle + (CustomWeaponDataModify.sprayAngle_add or 0),
        burst= burst,
        burst_mut=burst/custom_targeter_burst,
        projectiles=projectiles,
        projectiles_mut=projectiles/custom_targeter_projectiles,
        burstRate= burstRate,
        burstRate_mut=burstRate/custom_targeter_burstRate,
        explosionSpeed=
        CustomWeaponDataModify.explosionSpeed or 
        -- wd.explosionSpeed
        nil, 
        weapon_def=wd.id,
        craterMult=CustomWeaponDataModify.craterMult_add and (CustomWeaponDataModify.craterMult_add+wd.damages.craterMult) or nil,
        craterBoost=CustomWeaponDataModify.craterBoost_add and (CustomWeaponDataModify.craterBoost_add+wd.damages.craterBoost) or nil,
        impulseFactor=CustomWeaponDataModify.impulseFactor_add and (CustomWeaponDataModify.impulseFactor_add+wd.damages.impulseFactor) or nil,
        impulseBoost=CustomWeaponDataModify.impulseBoost_add and (CustomWeaponDataModify.impulseBoost_add+wd.damages.impulseBoost) or nil,
        craterAreaOfEffect=
        CustomWeaponDataModify.craterAreaOfEffect or 
        --wd.craterAreaOfEffect 
        nil,
        gravity=wd.myGravity,
        tracks =tracks,
        model=wd.visuals.modelName,
        name=CustomWeaponDataModify.name,
        ttl=ttl,
        cegTag=CustomWeaponDataModify.cegTag,
        soundHit=CustomWeaponDataModify.soundHit,
        soundStart=CustomWeaponDataModify.soundStart,
        explosionGeneratorCustom=egcustom,
        cost=CustomWeaponDataModify.cost,
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