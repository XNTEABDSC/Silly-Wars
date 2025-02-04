VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

local custom_weapon_data=utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name="custom_particle_beam"
custom_weapon_data.targeter_weapon="beam_targeter"

local modifies={
  utils.weapon_modifies.damage,
  utils.weapon_modifies.beam_range,
  utils.weapon_modifies.reload
}

local modifyfn=utils.UseModifies(modifies)

local name="custom_particle_beam"
local pic="unitpics/commweapon_lparticlebeam.png"
local humanName="Particle Beam"
local desc=""
---@type CustomWeaponBaseData
local res=
{
    name=name,
    pic=pic,
    humanName=humanName,
    genWeaponDef=function ()
      WeaponDefs[name]=lowerkeys{
        name                    = [[Auto Particle Beam]],
        beamDecay               = 0.85,
        beamTime                = 1/30,
        beamttl                 = 45,
        coreThickness           = 0.5,
        craterBoost             = 0,
        craterMult              = 0,
  
        customParams            = {
          light_color = [[0.9 0.22 0.22]],
          light_radius = 80,
        },
  
        damage                  = {
          default = 2,
        },
  
        explosionGenerator      = [[custom:flash1red]],
        fireStarter             = 100,
        impactOnly              = true,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        laserFlareSize          = 7.5,
        minIntensity            = 1,
        range                   = 300,
        reloadtime              = 2,
        rgbColor                = [[1 0 0]],
        soundStart              = [[weapon/laser/mini_laser]],
        soundStartVolume        = 6,
        thickness               = 5,
        tolerance               = 8192,
        turret                  = true,
        weaponType              = [[BeamLaser]],
      }
    end,
    custom_weapon_data=custom_weapon_data,
    genfn=function (mutate_table)
        return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data,true),mutate_table)
    end,
    modifies=modifies,
    genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies))
}
return res
