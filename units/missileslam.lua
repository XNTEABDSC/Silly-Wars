VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local ud=utils_op.GetUnitLua("tacnuke")
ud.metalCost=150
ud.health=600
ud.objectName="wep_m_phoenix_nonhax.s3o"
local wd=ud.weaponDefs.WEAPON
utils.table_replace({
    name="S.L.A.M",
    areaOfEffect            = 160,
    cegTag                  = [[slam_trail]],
    collisionSize           = 1,
    craterBoost             = 800,
    craterMult              = 1.0,
    damage={
        default=1500
    },
    customParams={
        def_scale=1.4
    },
    range=2400,
    edgeEffectiveness       = 1,
    explosionGenerator      = [[custom:slam]],
    flightTime              = 16,
    impactOnly              = false,
    impulseBoost            = 0,
    impulseFactor           = 0.2,
    interceptedByShieldType = 2,
    model                   = [[wep_m_phoenix_nonhax.s3o]],
    smokeTrail              = false,
    soundHit                = [[weapon/bomb_hit]],
    soundStart              = [[weapon/missile/missile_fire2]],
    startVelocity           = 0,
    tolerance               = 4000,
    weaponTimer             = 4.4,
    weaponAcceleration      = 75,
    weaponType              = [[StarburstLauncher]],
    weaponVelocity          = 1125,
})(wd)


return {missileslam=ud}