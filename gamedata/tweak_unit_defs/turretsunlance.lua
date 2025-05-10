--turretsunlance
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

utils_op.MakeSetSillyBuildMorphBig("turretgauss","turretsunlance")

UnitDefs.turretsunlance.metalcost=900