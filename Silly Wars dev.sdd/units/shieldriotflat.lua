
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local ud=utils.get_unit_lua("shieldriot")

utils.do_tweak({
    name="Flatty Outlaw",
    description=UnitDefs["shieldriot"].description .. ", and Flat Land",
    metalcost=UnitDefs["shieldriot"].metalcost+20,
    weaponDefs={BLAST={customParams={
        smoothradius     = [[140]],
        smoothmult       = [[0.1]],
    }}}
})(ud)

utils.set_morth_mul("shieldriot","shieldriotflat",5)
utils.add_build("sillycon","shieldriotflat")

return {["shieldriotflat"]=ud}