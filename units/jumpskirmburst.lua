-- not op design

VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things


return utils_op.CopyTweakSillyBuildMorphSimple("jumpskirm","jumpskirmburst",utils.table_replace(
    {
        name                = [[Moderator Bag]],
        description         = [[4x Disruptor Skirmisher Walker]],
        script="jumpskirmburst.lua",
        metalCost=240*2,
        health=480*1.75,
        customParams={
            def_scale=1.2,
            tactical_ai_defs_copy="jumpskirm",
            translations=[=[{
                en={
                    name="Moderator Bag",
                    description="4x Disruptor Skirmisher Walker",
                    helptext="Moderator Bag can shot 4 Disruptor beam at once"
                }
            }]=]
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