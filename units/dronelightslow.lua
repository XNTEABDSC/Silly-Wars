VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local trnil=utils.table_replace_nil
return utils.copy_tweak("dronelight","dronelightslow",utils.table_replace(
    {
        name="Disruptor Firefly",
        description="Disruptor Drone",
        metalCost=30,
        health              = 300,
        acceleration        = 0.6,
        weaponDefs={
            LASER={
                name="Light Disruptor Beam",
                customParams={
                    timeslow_damagefactor = 1.5,
                    drone_defs_is_drone=1
                },
                damage                  = {
                    default = 85,
                },
                range                   = 200,
                reloadtime              = 1,
            }
        }
    }
))