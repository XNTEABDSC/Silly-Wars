VFS.Include("gamedata/custom_units/utils.lua")
local consts=GameData.CustomUnits.utils.consts

local name="fake_projectile_targeter"
local fake_projectile_targeter={
  name                    = [[Light Plasma Cannon]],
  --areaOfEffect            = 32,
  craterBoost             = 0,
  craterMult              = 0,
  burst=consts.custom_targeter_burst,
  burstRate=consts.custom_targeter_burstRate,
  projectiles=consts.custom_targeter_projectiles,

  customParams        = {
    --light_camera_height = 1500,
  },

  damage                  = {
    default = consts.custom_targeter_damage,
  },

  explosionGenerator      = [[custom:INGEBORG]],
  impulseBoost            = 0,
  impulseFactor           = 0,
  interceptedByShieldType = 1,
  noSelfDamage            = true,
  range                   = consts.custom_targeter_range,
  reloadtime              = consts.custom_targeter_reloadtime,
  soundHit                = [[weapon/cannon/cannon_hit2]],
  soundStart              = [[weapon/cannon/medplasma_fire]],
  turret                  = true,
  weaponType              = [[Cannon]],
  weaponVelocity          = consts.custom_targeter_proj_speed,
}
local fake_beam_targeter = {
  name                    = [[Beam Targeter]],
  beamTime                = 1/30,
  craterBoost             = 0,
  craterMult              = 0,

  customParams            = {
  },

  damage                  = {
    default = 1,
  },
  fireStarter             = 100,
  impactOnly              = true,
  impulseFactor           = 0,
  interceptedByShieldType = 1,
  laserFlareSize          = 7.5,
  minIntensity            = 1,
  range                   = 300,
  reloadtime              = 0.3,
  rgbColor                = [[1 1 1]],
  soundStart              = [[weapon/laser/mini_laser]],
  soundStartVolume        = 6,
  thickness               = 5,
  tolerance               = 8192,
  turret                  = true,
  weaponType              = [[BeamLaser]],
}

local weapondefs={}

for i = 1, 8 do
  weapondefs[name.. tostring(i)]=Spring.Utilities.CopyTable(fake_projectile_targeter,true)
end

return weapondefs