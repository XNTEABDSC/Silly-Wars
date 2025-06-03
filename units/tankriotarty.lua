VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

--utils_op.MakeSetSillyBuildMorphBig("tankriotrange","tankriotarty")

return utils_op.CopyTweakSillyBuildMorphAuto("tankriotrange","tankriotarty",function (ud)
    utils.table_replace({
        name="Arty Orge",
        description="Orge with just a lot of Adv. Targeting System (expensive)",
        weaponDefs={
            TAWF_BANISHER={
                range=1100
            }
        },
        speed=36,
        metalCost=4000,
        customParams={
            def_scale=2,
            tactical_ai_defs_copy="veharty",
            translations=[=[{
                en={
                    name="Arty Orge",
                    description="Orge with just a lot of Adv. Targeting System (expensive)",
                    helptext="Orge's missile can indeed fly this far, so let it fly! Arty Orge can shot guided missile at even radar dots, which gives Arty Orge strong ability of map control and snipe. But its dps efficiency is very low, and its chispy"
                }
            }]=]
            --icontypes_this=1,
            --icontypes_this_copy_ud="tankarty",
            --icontypes_this_copy_scale=2,
        },
        explodeAs="ATOMIC_BLAST",
        selfDestructAs="ATOMIC_BLAST",
        --movementClass = [[TANK8]],
        iconType="tankriotarty",
    }
    )(ud)
    --utils.set_scale(ud,2)
end)
--