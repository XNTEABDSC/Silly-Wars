local unitDef=UnitDefs.tiptest
unitDef.metalcost=unitDef.metalcost*1.5
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things
utils_op.MakeAddSillyBuild("tiptest")
utils_op.MakeSetSillyMorphBig("vehassault","tiptest")