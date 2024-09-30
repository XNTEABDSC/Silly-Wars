VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local trnil=utils.table_replace_nil
return utils.copy_tweak("droneheavyslow","droneheavy",utils.table_replace(
    {
        name="DPS Viper",
        weaponDefs={
            DISRUPTOR={
                name                    = [[Pulse Beam]],
                customParams={
                    timeslow_damagefactor=trnil,
                    light_color = [[0.25 1 0.25]],
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