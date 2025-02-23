VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils
--[==[

local modifies={
    utils.weapon_modifies.name,
    utils.weapon_modifies.damage,
    utils.weapon_modifies.proj_speed,
    utils.weapon_modifies.proj_range,
    utils.weapon_modifies.reload,
    ---@param tb CustomWeaponDataModify
    utils.genCustomModify("track","allow missile tracks enemy","unitpics/commweapon_missilelauncher.png",function (tb,v)
        if v then
            tb.tracks=true
            tb.damage_default_mut=tb.damage_default_mut*0.5
            tb.weapon_def_name=tb.weapon_def_name .. "_track"
        end
    end,"boolean")
}

local modifyfn=utils.UseModifies(modifies)
--[=[
local MutateFn=utils.UseMutateTable(
    wacky_utils.mt_union(utils.plasma_aoe_mutate,utils.BasicWeaponMutate)
)]=]

local name="custom_missile"
local pic="unitpics/commweapon_missilelauncher.png"
local desc=""
local humanName="Rocket/Missile"
local weaponDef={
    name                    = [[Homing Missiles]],
    areaOfEffect            = 48,
    avoidFeature            = true,
    cegTag                  = [[missiletrailyellow]],
    craterBoost             = 0,
    craterMult              = 0,

    customParams        = {
      light_camera_height = 2000,
      light_radius = 200,
    },

    damage                  = {
      default = 2,
    },

    explosionGenerator      = [[custom:FLASH2]],
    fireStarter             = 70,
    flightTime              = 3,
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 2,
    model                   = [[wep_m_frostshard.s3o]],
    range                   = 600,
    reloadtime              = 2.5,
    smokeTrail              = true,
    soundHit                = [[explosion/ex_med17]],
    soundStart              = [[weapon/missile/missile_fire11]],
    startVelocity           = 450,
    texture2                = [[lightsmoketrail]],
    tolerance               = 8000,
    --tracks                  = true,
    turnRate                = 33000,
    turret                  = true,
    weaponAcceleration      = 109,
    weaponType              = [[MissileLauncher]],
    weaponVelocity          = 545,
}


local custom_weapon_data=utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name=name
custom_weapon_data.targeter_weapon="line_targeter"
custom_weapon_data.aoe=weaponDef.areaOfEffect
custom_weapon_data.explosionGenerator      = weaponDef.explosionGenerator

local function WDOrig()
    return {[name]=Spring.Utilities.CopyTable(weaponDef,true)}
end

local function WDMayTrack(wds)
    local newwds={}
    for key, value in pairs(wds) do
        newwds[key]=value
        newwds[key .. "_track"] = Spring.Utilities.CopyTable(value,true)
        newwds[key .. "_track"].tracks=true
    end
    return newwds
end

---@type CustomWeaponBaseData
local res=
{
    name=name,
    humanName=humanName,
    pic=pic,
    genWeaponDef=function ()
        --[=[
        Spring.Utilities.MergeTable(WeaponDefs,
            WDMayTrack(WDOrig())
        )]=]
        local mwd=WDMayTrack(WDOrig())
        for key, value in pairs(mwd) do
            WeaponDefs[key]=value
            --Spring.Echo("DEBUG: Add weapon " .. key .. " : " .. tostring(value))
        end
        --WeaponDefs[name]=lowerkeys(weaponDef)
    end,
    custom_weapon_data=custom_weapon_data,
    genfn=function (mutate_table)
        return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data,true),mutate_table)
    end,
    modifies=modifies,
    genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies,2))
}
return res

--]==]

return utils.GenCustomWeaponBase{
    name="custom_missile",
    pictrue="unitpics/commweapon_missilelauncher.png",
    description="",
    humanName="Rocket/Missile",
    WeaponDef={
        name                    = [[Homing Missiles]],
        areaOfEffect            = 48,
        avoidFeature            = true,
        cegTag                  = [[missiletrailyellow]],
        craterBoost             = 0,
        craterMult              = 0,
    
        customParams        = {
          light_camera_height = 2000,
          light_radius = 200,
        },
    
        damage                  = {
          default = 2,
        },
    
        explosionGenerator      = [[custom:FLASH2]],
        fireStarter             = 70,
        flightTime              = 3,
        impulseBoost            = 0,
        impulseFactor           = 0.4,
        interceptedByShieldType = 2,
        model                   = [[wep_m_frostshard.s3o]],
        range                   = 600,
        reloadtime              = 2.5,
        smokeTrail              = true,
        soundHit                = [[explosion/ex_med17]],
        soundStart              = [[weapon/missile/missile_fire11]],
        startVelocity           = 450,
        texture2                = [[lightsmoketrail]],
        tolerance               = 8000,
        --tracks                  = true,
        turnRate                = 33000,
        turret                  = true,
        weaponAcceleration      = 109,
        weaponType              = [[MissileLauncher]],
        weaponVelocity          = 545,
    },
    Modifies={
        utils.weapon_modifies.name,
        utils.weapon_modifies.damage,
        utils.weapon_modifies.proj_speed,
        utils.weapon_modifies.proj_range,
        utils.weapon_modifies.reload,
        utils.weapon_modifies.tracks,
        utils.weapon_modifies.slow_partial,
    },
    targeter="line_targeter"
}