VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("energysingu","energysingutanky",utils.table_replace({
    name="Tanky Singularity Reactor",
    description="Large Powerplant - SAFE",
    customParams={
        --pylonrange=600
        translations=[=[{
            en={
                name="Tanky Singularity Reactor",
                description="Large Powerplant - SAFE",
                helptext="Tanky Singularity Reactor has good hp and wont destroy everything when died."
            }
        }]=]
    },
    --energyMake=50,
    metalCost=6000,
    health=18000,
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST",
}))