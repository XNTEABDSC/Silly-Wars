VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things

utils.set_morth_mul("silly_morth","jumpskirm","jumpskirmburst")
utils.add_build("silly_build","sillycon","jumpskirmburst")

return utils.copy_tweak("jumpskirm","jumpskirmburst",utils.table_replace(
    {
        name                = [[Moderator Bag]],
        description         = [[4x Disruptor Skirmisher Walker]],
        script="jumpskirmburst.lua",
        metalCost=240*2,
        health=480*1.75,
        customParams={
            def_scale=1.2,
            tactical_ai_defs_copy="jumpskirm",
        },
        weaponDefs          = {
            DISRUPTOR_BEAM = {
                customparams={
                    script_reload =  9*4,
                    script_burst = 4,
                },
                reloadtime=0.5,
            }
        },
    }
))