VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

local ammotype
do
    
end

return utils.GenCustomWeaponBase{
    name="custom_missile",
    pictrue="unitpics/commweapon_missilelauncher.png",
    description="",
    humanName="Rocket/Missile",
    WeaponDef={
        name                    = [[Homing Missiles]],
        --areaOfEffect            = 48,
        avoidFeature            = true,
        cegTag                  = [[missiletrailyellow]],
        craterBoost             = 0,
        craterMult              = 0,
    
        customParams        = {
          light_camera_height = 2000,
          light_radius = 200,
        },
    
        damage                  = {
          default = utils.consts.custom_weapon_common_damage--3,
        },
    
        --explosionGenerator      = [[custom:FLASH2]],
        fireStarter             = 70,
        flightTime              = 3,
        impulseBoost            = 0,
        impulseFactor           = 0.4,
        interceptedByShieldType = 2,
        model                   = [[wep_m_frostshard.s3o]],
        --range                   = 600,
        --reloadtime              = 2.5,
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
        --weaponVelocity          = 545,
        range                   = utils.consts.custom_weapon_common_range,
        weaponVelocity          = utils.consts.custom_weapon_common_projSpeed,
        reloadtime              = utils.consts.custom_weapon_common_reloadtime,
    },
    Modifies={
        utils.weapon_modifies.name,
        utils.weapon_modifies.tracks,
        utils.weapon_modifies.slow_partial,
        utils.weapon_modifies.weapon_def_finish,
        utils.weapon_modifies.damage,
        utils.weapon_modifies.proj_speed,
        utils.weapon_modifies.proj_range,
        utils.weapon_modifies.reload,
        utils.weapon_modifies.projectiles,
        utils.weapon_modifies.burst,
    },
    targeter="line_targeter"
}