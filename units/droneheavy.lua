VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local trnil=utils.None
return utils_op.CopyTweak("droneheavyslow","droneheavy",utils.table_replace(
    {
        name="DPS Viper",
        weaponDefs={
            DISRUPTOR={
                name                    = [[Pulse Beam]],
                customParams={
                    timeslow_damagefactor=trnil,
                    light_color = [[0.25 1 0.25]],
                    drone_defs_is_drone=1
                },
                damage={
                    default=100,
                },
                reloadtime=1,
                rgbColor                = [[0 1 0]],
            }
        }
    }
))