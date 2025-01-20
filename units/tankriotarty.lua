VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
utils_op.MakeSetSillyMorphBig("tankriot","tankriotarty")
utils_op.MakeAddSillyBuild("tankriotarty")
return utils_op.CopyTweak("tankriot","tankriotarty",function (ud)
    utils.table_replace({
        name="Ranged Orge",
        description="Orge with just Adv. Targeting System (expensive)",
        weaponDefs={
            TAWF_BANISHER={
                range=1100
            }
        },
        metalCost=4000,
        speed=38,
        customParams={
            def_scale=2,
            tactical_ai_defs_copy="veharty",
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