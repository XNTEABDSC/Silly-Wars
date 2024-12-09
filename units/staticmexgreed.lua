VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils = Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op = Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things = Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorph("staticmex", "staticmexgreed", utils.table_replace({
    name                   = [[Greed Metal Extractor]],
    description            = [[Produces 4x Metal]],
    metalCost = 4000,
    health = 4000*1.6,
    customParams = {
        metal_extractor_mult = 4,
    },
    sfxtypes = {
        explosiongenerators = {
            [[custom:RAIDMUZZLE]],
            [[custom:VINDIBACK]],
            [[custom:RIOTBALL]],
        },
    },
}
))