VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphSimple("energyfusion","energyfusiontanky",utils.table_replace({
    name="Tanky Fusion Reactor",
    description="Stable Energy and Grid",
    customParams={
        pylonrange=600,
        translations=[=[{
            en={
                name = "Tanky Fusion Reactor",
                description="Stable Energy and Grid",
                helptext="Tanky Fusion Reactor is a stable energy source which can provides enough energy and grid for heavy defenses to work, and as efficiency as solar collectors"
            }
        }]=]
    },
    energyMake=50,
    metalCost=1750,
    health=8750,
}))