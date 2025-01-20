VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
local fname="tankheavyassault"
local tname="tankheavyassaultimpulse"
local ud=utils_op.GetUnitLua(fname)
utils.table_replace({
weaponDefs={COR_GOL={impulseFactor=-2.5}},
metalcost=UnitDefs["tankheavyassault"].metalcost+200,
name="Impulse Cyclops",
description="Very Heavy Tank Buster With Impulse",
customParams={
    tactical_ai_defs_copy="tankheavyassault"
},
})(ud)

utils_op.MakeSetSillyBuildMorphSimple(fname,tname,20)
return {[tname]=ud}
