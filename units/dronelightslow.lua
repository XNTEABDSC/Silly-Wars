VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
local trnil=utils.None
return utils_op.CopyTweak("dronelight","dronelightslow",utils.table_replace(
    {
        name="Disruptor Firefly",
        description="Disruptor Drone",
        metalCost=30,
        health              = 270,
        acceleration        = 0.6,
        customParams={
            drone_defs_is_drone=1,
        },
        weaponDefs={
            LASER={
                name="Light Disruptor Beam",
                customParams={
                    timeslow_damagefactor = 1.5,
                },
                damage                  = {
                    default = 60,
                },
                range                   = 200,
                reloadtime              = 1,
                rgbColor                = [[0.3 0 0.4]],
            }
        }
    }
))