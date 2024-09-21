VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local fname="tankheavyassault"
local tname="tankheavyassaultimpulse"
local ud=utils.get_unit_lua(fname)
utils.table_replace({
weaponDefs={COR_GOL={impulseFactor=-2.5}},
metalcost=UnitDefs["tankheavyassault"].metalcost+200,
name="Impulse Cyclops",
description="Very Heavy Tank Buster With Impulse",
})(ud)

utils.set_morth_mul("silly_morth",fname,tname,20)
utils.add_build("silly_build","sillycon",tname)
return {[tname]=ud}
