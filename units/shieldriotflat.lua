
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
local ud=utils.get_unit_lua("shieldriot")

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

utils.set_morth_mul("silly_morth","shieldriot","shieldriotflat",5)
utils.add_build("silly_build","sillycon","shieldriotflat")

return {["shieldriotflat"]=ud}