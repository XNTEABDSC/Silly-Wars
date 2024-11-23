VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

return utils_op.CopyTweakSillyBuildMorph("amphlaunch","amphlaunchpro",utils.table_replace({
    name="Lobster Pro",
    customParams={
        thrower_gather=300
    },
    health=4000,
    metalCost=4000,
    speed=24,
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST",
    weaponDefs={
        TELEPORT_GUN={
            range=1200,
            reloadtime=30
        },
        BOGUS_TELEPORTER_GUN={
            range=1200,
            reloadtime=30
        }
    },
}))