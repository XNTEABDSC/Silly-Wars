VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorph("energysingu","energysingutanky",utils.table_replace({
    name="Tanky Singularity Reactor",
    description="Large Powerplant - SAFE",
    customParams={
        --pylonrange=600
    },
    --energyMake=50,
    metalCost=6000,
    health=18000,
    explodeAs="ATOMIC_BLAST",
    selfDestructAs="ATOMIC_BLAST",
}))