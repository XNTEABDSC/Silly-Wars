VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("vehheavyarty","vehheavyartyplus",function (ud)
    ud.metalCost=2000
    ud.health=2000
    ud.name="S.L.A.M " .. ud.name
    ud.description="Throws S.L.A.M"
    ud.fireState =0
    local wd=ud.weaponDefs.CORTRUCK_ROCKET
    utils.table_replace({
        name="S.L.A.M",
        areaOfEffect            = 160,
	    cegTag                  = [[slam_trail]],
        collisionSize           = 1,
        craterBoost             = 800,
        craterMult              = 1.0,
        damage={
            default=1500.1*(1+0.15*5)
        },
        range=900*(1+0.075*5),
        edgeEffectiveness       = 1,
        explosionGenerator      = [[custom:slam]],
        flightTime              = 16,
        impactOnly              = false,
        impulseBoost            = 0,
        impulseFactor           = 0.2,
        interceptedByShieldType = 2,
        model                   = [[wep_m_phoenix_nonhax.s3o]],
        reloadtime              = 30,
        smokeTrail              = false,
        soundHit                = [[weapon/bomb_hit]],
        soundStart              = [[weapon/missile/missile_fire2]],
        startVelocity           = 0,
        tolerance               = 4000,
        weaponTimer             = 4.4,
        weaponAcceleration      = 75,
        weaponType              = [[StarburstLauncher]],
        weaponVelocity          = 1125,
        commandfire             = true,
    })(wd)
    ud.speed=50
    ud.customParams.def_scale=1.4

    ud.customParams.translations=[=[
    {
        en={
            name="S.L.A.M Impaler",
            description="Throws S.L.A.M",
            helptext="This car can shot S.L.A.M, a missile with decent damage and aoe, but reloads slow"
        }
    }
    ]=]
    
    --utils.set_scale(ud,1.4)
end)