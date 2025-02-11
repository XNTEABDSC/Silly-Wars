VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

local custom_weapon_data = utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name = "custom_particle_beam"
custom_weapon_data.targeter_weapon = "beam_targeter"


local name = "custom_particle_beam"
local pic = "unitpics/commweapon_lparticlebeam.png"
local humanName = "Particle Beam"
local desc = ""

local weaponDef = {
  name                    = humanName,
  areaOfEffect            = 40,
  beamDecay               = 0.85,
  beamTime                = 0.1,
  beamttl                 = 45,
  canattackground         = false,
  coreThickness           = 0.5,
  craterBoost             = 0,
  craterMult              = 0,
  customParams            = {
    light_color = "1 0.0 0.0",
    light_radius = 80,
  },
  damage                  = {
    default = 3,
  },
  explosionGenerator      = "custom:flash1red",
  fireStarter             = 100,
  impactOnly              = false,
  impulseFactor           = 0,
  interceptedByShieldType = 1,
  laserFlareSize          = 7.5,
  minIntensity            = 1,
  range                   = 600,
  reloadtime              = 2.5,
  rgbColor                = "1 0 0",
  soundStart              = "weapon/laser/mini_laser",
  soundStartVolume        = 6,
  thickness               = 5,
  tolerance               = 8192,
  turret                  = true,
  weaponType              = "BeamLaser",
}

local modifies = {
  utils.weapon_modifies.name,
  utils.weapon_modifies.damage,
  utils.weapon_modifies.beam_range,
  utils.weapon_modifies.reload,
  utils.weapon_modifies.into_aa,
}

local modifyfn = utils.UseModifies(modifies)



---@type CustomWeaponBaseData
local res =
{
  name = name,
  pic = pic,
  humanName = humanName,
  genWeaponDef = function()
    WeaponDefs[name] = lowerkeys (weaponDef)
  end,
  custom_weapon_data = custom_weapon_data,
  genfn = function(mutate_table)
    return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data, true), mutate_table)
  end,
  modifies = modifies,
  genUIFn = utils.ui.UIPicThen(pic, humanName, desc, utils.ui.StackModifies(modifies))
}
return res
