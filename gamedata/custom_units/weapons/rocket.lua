VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.GameData.CustomUnits.utils

local ammotype
do
    local wds={
      light={
        name="light",humanName="Light",
        WeaponDef={
          name                    = [[Light Missile]],
          --areaOfEffect            = 48,
          avoidFeature            = true,
          cegTag                  = [[missiletrailyellow]],
      
          customParams        = {
            light_camera_height = 2000,
            light_radius = 200,
          },
      
          damage                  = {
            default = utils.consts.custom_weapon_common_damage--3,
          },
      
          --explosionGenerator      = [[custom:FLASH2]],
          flightTime              = 5,
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
        }
      },
      heavy={
        name="heavy",humanName="Heavy",
        WeaponDef={
          name                    = [[Heavy Rocket]],
          cegTag                  = [[rocket_trail_bar_flameboosted]],
    
          customParams        = {
    
            light_camera_height = 1800,
          },
          
          damage                  = {
            default = utils.consts.custom_weapon_common_damage,
          },
    
          flightTime              = 5,
          interceptedByShieldType = 2,
          model                   = [[wep_m_hailstorm.s3o]],
          noSelfDamage            = true,
          smokeTrail              = false,
          soundHit                = [[explosion/ex_med4]],
          soundHitVolume          = 8,
          soundStart              = [[weapon/missile/missile2_fire_bass]],
          soundStartVolume        = 7,
          tracks                  = false,
          turnrate                = 5000,
          turret                  = true,
          weaponType              = [[MissileLauncher]],
          range                   = utils.consts.custom_weapon_common_range,
          weaponVelocity          = utils.consts.custom_weapon_common_projSpeed,
          reloadtime              = utils.consts.custom_weapon_common_reloadtime,
        }
      }
    }
    local choose_wd_mods={}
    for key, value in pairs(wds) do
      choose_wd_mods[#choose_wd_mods+1] = {
        name=value.name,humanName=value.humanName,
        moddeffn=function (ts)
          return value.WeaponDef
        end,
        modfn=nil
      }
    end
    ammotype=utils.genCustomModifyChoose1Modify("ammo","Rocket type","",choose_wd_mods)
end

return utils.GenCustomWeaponBase{
    name="custom_missile",
    pictrue="unitpics/commweapon_missilelauncher.png",
    description="",
    humanName="Rocket/Missile",
    WeaponDef={},
    Modifies={
        utils.weapon_modifies.name,
        ammotype,
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