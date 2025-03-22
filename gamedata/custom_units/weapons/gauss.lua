VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils                     = Spring.Utilities.wacky_utils
local utils                           = GameData.CustomUnits.utils

return utils.GenCustomWeaponBase{
    name="custom_gauss",
    pictrue="unitpics/commweapon_gaussrifle.png",
    description="A fast, piercing gun",
    humanName="Gauss",
    WeaponDef={
        name                    = "Gauss",
        alphaDecay              = 0.12,
        areaOfEffect            = 16,
        avoidfeature            = false,
        bouncerebound           = 0.15,
        bounceslip              = 1,
        cegTag                  = [[gauss_tag_h]],
        craterBoost             = 0,
        craterMult              = 0,
    
        customParams            = {
            single_hit_multi = true,
            reaim_time = 1,
        },
    
        damage                  = {
            default = utils.consts.custom_weapon_common_damage/2-- 2.5,
        },
    
        explosionGenerator      = [[custom:gauss_hit_h]],
        fireTolerance           = 4000,
        groundbounce            = 1,
        heightMod               = 1.2,
        impactOnly              = true,
        impulseBoost            = 0,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        noExplode               = true,
        noSelfDamage            = true,
        numbounce               = 40,
        rgbColor                = [[0.5 1 1]],
        separation              = 0.5,
        soundHit                = [[weapon/gauss_hit]],
        soundStart              = [[weapon/gauss_fire]],
        stages                  = 32,
        tolerance               = 4000,
        turret                  = true,
        waterweapon             = true,
        weaponType              = [[Cannon]],
        range                   = 600,
        --range                   = utils.consts.custom_weapon_common_range,
        weaponVelocity          = utils.consts.custom_weapon_common_projSpeed*3,
        reloadtime              = utils.consts.custom_weapon_common_reloadtime,
    },
    Modifies={
        utils.weapon_modifies.name,
        utils.weapon_modifies.slow_partial,
        utils.weapon_modifies.weapon_def_finish,
        utils.weapon_modifies.damage,
        utils.weapon_modifies.proj_speed,
        -- utils.weapon_modifies.proj_range, wat happened? gauss's range can't be controlled by set range
        utils.weapon_modifies.reload,
        utils.weapon_modifies.projectiles,
        utils.weapon_modifies.burst,
    },
    targeter="projectile_targeter"
}