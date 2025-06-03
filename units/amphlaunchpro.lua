VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("amphlaunch","amphlaunchpro",utils.table_replace({
    name="Greater Lobster",
    customParams={
        thrower_gather=300,
        translations_copy_from="amphlaunch",
        translations=[=[{
            en={
                name = "Greater Lobster",
                description = "Greater Amphibious Launcher Bot",
                helptext = ""
            }
        }]=]
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