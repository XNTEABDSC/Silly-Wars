VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("energyfusion","energyfusiontanky",utils.table_replace({
    name="Tanky Fusion Reactor",
    description="Stable Energy Grid",
    customParams={
        pylonrange=600
    },
    energyMake=50,
    metalCost=2000,
    health=10000,
}))