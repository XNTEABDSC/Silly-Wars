VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
local ud=utils_op.GetUnitLua("shieldriot")

utils.table_replace({
    name="Flatty Outlaw",
    description=UnitDefs["shieldriot"].description .. ", and Flat Land",
    metalcost=UnitDefs["shieldriot"].metalcost+20,
    weaponDefs={BLAST={customParams={
        smoothradius     = [[140]],
        smoothmult       = [[0.1]],
    }}},
    customParams={
        tactical_ai_defs_copy="shieldriot"
    }
})(ud)

utils_op.MakeSetSillyMorph("shieldriot","shieldriotflat",5)
utils_op.MakeAddSillyBuild("shieldriotflat")

return {["shieldriotflat"]=ud}