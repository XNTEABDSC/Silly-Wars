local utils=Spring.Utilities.CustomUnits.utils
---@type CustomWeaponData
local custom_weapon={
    weapon_def_name="custom_plasma_aoe36",
    cost=1,
    mass=1,
    damage=2,
    speed=280,
    reload_time=2,
    range=350,
}
return {
    name="custom_plasma_aoe36",
    weapon={
        name                    = [[Light Plasma Cannon]],
        areaOfEffect            = 36,
        craterBoost             = 0,
        craterMult              = 0,

        customParams        = {
            light_camera_height = 1800,
            light_color = [[0.80 0.54 0.23]],
            light_radius = 200,
        },

        damage                  = {
            default = 2,
            planes  = 2,
        },

        explosionGenerator      = [[custom:MARY_SUE]],
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
    custom_weapon=custom_weapon,
    modifyfn=function (mutate_table)
        local custom_weapon=Spring.Utilities.CopyTable(custom_weapon,true)
        return utils.UseWeaponMutateTable(custom_weapon)
    end
}