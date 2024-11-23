local ud=(VFS.Include("units/vehcon.lua").vehcon)
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

ud.name="Silly Con"
ud.description="To Make Silly Things"
ud.metalCost=400
ud.speed=90
ud.customParams=ud.customParams or {}
return {["sillycon"]=ud}