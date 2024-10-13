--amphlaunch

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
utils.add_build("silly_build","bigsillycon","amphlaunchpro")
utils.set_morth("silly_morth","amphlaunch","amphlaunchpro")

return utils.copy_tweak("amphlaunch","amphlaunchpro",utils.table_replace({
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