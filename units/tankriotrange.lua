VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorphAuto("tankriot","tankriotrange",function (ud)
    utils.table_replace({
        name="Adv. Targeting Orge",
        description="Orge with 5 Adv. Targeting Systems",
        weaponDefs={
            TAWF_BANISHER={
                range=function (range)
                    return range*(1+0.075*5)
                end
            }
        },
        speed=function (speed)
            return speed*(1-0.03*5)
        end,
        --health=2500,
        metalCost=1100,
        customParams={
            def_scale=1.3,
            tactical_ai_defs_copy="tankriot",
            translations=[=[{
                en={
                    name="Adv. Targeting Orge",
                    description="Orge with 5 Adv. Targeting Systems",
                    helptext="More range Orge can sit behind other assault units while cooking bugs."
                }
            }]=]
            --icontypes_this=1,
            --icontypes_this_copy_ud="tankarty",
            --icontypes_this_copy_scale=2,

        },
    }
    )(ud)
    --utils.set_scale(ud,2)
end)
--