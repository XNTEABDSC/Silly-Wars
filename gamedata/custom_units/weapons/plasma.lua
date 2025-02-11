VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

local custom_weapon_data=utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name="custom_plasma"
custom_weapon_data.aoe=36
custom_weapon_data.explosionGenerator      = [[custom:INGEBORG]]
custom_weapon_data.targeter_weapon="projectile_targeter"

local modifies={
    utils.weapon_modifies.name,
    utils.weapon_modifies.damage,
    utils.weapon_modifies.proj_speed,
    utils.weapon_modifies.proj_range,
    utils.weapon_modifies.reload,
}

local modifyfn=utils.UseModifies(modifies)
--[=[
local MutateFn=utils.UseMutateTable(
    wacky_utils.mt_union(utils.plasma_aoe_mutate,utils.BasicWeaponMutate)
)]=]

local name="custom_plasma"
local pic="unitpics/commweapon_assaultcannon.png"
local desc=""
local humanName="Plasma"
local weaponDef={
    name                    = [[Light Plasma Cannon]],
    craterBoost             = 0,
    craterMult              = 0,
    areaOfEffect=36,
    customParams        = {
        light_camera_height = 1800,
        light_color = [[0.80 0.54 0.23]],
        light_radius = 200,
    },

    damage                  = {
        default = 4,
    },

    explosionGenerator      = [[custom:INGEBORG]],
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 1,
    noSelfDamage            = true,
    range                   = 600,
    reloadtime              = 2.5,
    soundHit                = [[explosion/ex_med5]],
    soundStart              = [[weapon/cannon/cannon_fire5]],
    turret                  = true,
    weaponType              = [[Cannon]],
    weaponVelocity          = 280,
}

---@type CustomWeaponBaseData
local res=
{
    name=name,
    humanName=humanName,
    pic=pic,
    genWeaponDef=function ()
        WeaponDefs[name]=lowerkeys(weaponDef)
    end,
    custom_weapon_data=custom_weapon_data,
    genfn=function (mutate_table)
        return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data,true),mutate_table)
    end,
    modifies=modifies,
    genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies))
}
return res
