VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

utils.set_morth("silly_morth","striderartypuppy","striderartycerb")
utils.add_build("silly_build","verybigsillycon","striderartycerb")
--[=[
local ud=utils.get_unit_lua("striderarty")


ud.name="Cerberus' Merlin"
ud.metalCost=16000
ud.health=12000

utils.do_tweak({})(ud.weaponDefs.ROCKET)

]=]

return utils.copy_tweak("striderarty","striderartycerb",function (ud)
    utils.table_replace({
        name="Cerberus' Merlin",
        metalCost=16000,
        health=10000,
        highTrajectory                = 2,
        customParams={
            def_scale=2.4
        },
        weaponDefs={
            ROCKET={
                name                    = [[Long-Range Plasma Battery]],
                areaOfEffect            = 192,
                customParams            = {
                    light_color = [[1.4 0.8 0.3]],
                },
                damage                  = {
                    default = 601,
                    planes  = 601,
                },
                edgeEffectiveness       = 0.5,
                explosionGenerator      = [[custom:330rlexplode]],
                fireStarter             = 120,
                impulseBoost            = 0,
                impulseFactor           = 0.4,
                interceptedByShieldType = 1,
                mygravity               = 0.1,
                soundHit                = [[explosion/ex_large4]],
                soundStart              = [[explosion/ex_large5]],
                sprayangle              = 1024,
                weaponType              = [[Cannon]],
                weaponVelocity          = 400,
                range                   = 1650,
            }
        }
    })(ud)
    ud.speed=ud.speed*0.8
    local wd=ud.weaponDefs.ROCKET
    wd.model=nil
    wd.flightTime=nil
    wd.smokeTrail=nil
    wd.startVelocity=nil
    wd.tolerance=nil
    wd.trajectoryHeight=nil
    wd.turnRate=nil
    wd.weaponAcceleration=nil
    wd.wobble=nil
    wd.cegTag=nil
end)