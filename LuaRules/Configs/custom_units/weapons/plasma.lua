VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.Utilities.CustomUnits.utils

local custom_weapon_data=utils.a_custom_weapon_data()
custom_weapon_data.weapon_def_name="custom_plasma"
custom_weapon_data.aoe=36
custom_weapon_data.explosionGenerator      = [[custom:INGEBORG]]

local MutateFn=utils.UseMutateTable(
    wacky_utils.mt_union(utils.plasma_aoe_mutate,utils.BasicWeaponMutate)
)
return {
    name="custom_plasma",
    weapon={
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
            default = 2,
            planes  = 2,
        },

        explosionGenerator      = [[custom:INGEBORG]],
        impulseBoost            = 0,
        impulseFactor           = 0.4,
        interceptedByShieldType = 1,
        noSelfDamage            = true,
        range                   = 350,
        reloadtime              = 2,
        soundHit                = [[explosion/ex_med5]],
        soundStart              = [[weapon/cannon/cannon_fire5]],
        turret                  = true,
        weaponType              = [[Cannon]],
        weaponVelocity          = 280,
    },
    custom_weapon_data=custom_weapon_data,
    genfn=function (mutate_table)
        return MutateFn(Spring.Utilities.CopyTable(custom_weapon_data,true),mutate_table)
    end
}