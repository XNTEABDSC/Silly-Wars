VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
--not op enough, i have more op one
if true then
    return {}
end
local ud=utils.GetUnitLua("tacnuke")
ud.metalCost=300
ud.health=600
ud.objectName="wep_m_avalanche.s3o"
ud.name="Artemis Missile"
ud.description="Sniping Missile (can hit ground)"
ud.buildPic="commweapon_slamrocket.png"

ud.customParams.translations=[=[{
    en={
        name="Artemis Missile",
        description="Sniping Missile (can hit ground)",
        helptext="We make artemis' missile buildable, an can target ground"
    }
}]=]

local wd=ud.weaponDefs.WEAPON
utils.table_replace({
    name                    = [[Artemis Missile]],
      areaOfEffect            = 240,
      canAttackGround         = false,
      cegTag                  = [[turretaaheavytrail]],
      craterBoost             = 0.1,
      craterMult              = 0.2,
      cylinderTargeting       = 3.2,

      customParams              = {
        radar_homing_distance = 1800,

        light_color = [[1.5 1.8 1.8]],
        light_radius = 600,
      },

      damage                  = {
        default    = 1601.5,
      },

      edgeEffectiveness       = 0.25,
      energypershot           = 80,
      explosionGenerator      = [[custom:MISSILE_HIT_SPHERE_120]],
      fireStarter             = 90,
      flightTime              = 4,
      groundbounce            = 1,
      impulseBoost            = 0,
      impulseFactor           = 0,
      interceptedByShieldType = 1,
      metalpershot            = 80,
      model                   = [[wep_m_avalanche.s3o]], -- Model radius 180 for QuadField fix.
      noSelfDamage            = true,
      range                   = 2400,
      reloadtime              = 1.8,
      smokeTrail              = false,
      soundHit                = [[weapon/missile/heavy_aa_hit]],
      soundStart              = [[weapon/missile/heavy_aa_fire2]],
      startVelocity           = 1000,
      stockpile               = true,
      stockpileTime           = 10000,
      texture1                = [[flarescale01]],
      tolerance               = 10000,
      tracks                  = true,
      trajectoryHeight        = 0.55,
      turnRate                = 60000,
      turret                  = true,
      weaponTimer=0.5,
      weaponAcceleration      = 600,
      weaponType              = [[StarburstLauncher]],
      weaponVelocity          = 1600,
})(wd)

utils_op.MakeAddBuild("staticmissilesilo","missileturretaaheavy")
return {missileturretaaheavy=ud}