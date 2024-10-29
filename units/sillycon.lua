local ud=(VFS.Include("units/vehcon.lua").vehcon)
VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils=Spring.Utilities.to_make_op_things
ud.name="Silly Con"
ud.description="To Make Silly Things"
ud.metalCost=400
ud.speed=90
return {["sillycon"]=ud}