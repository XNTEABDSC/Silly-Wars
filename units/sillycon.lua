local ud=(VFS.Include("units/vehcon.lua").vehcon)
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
ud.name="Silly Con"
ud.description="To Make Silly Things"
ud.metalCost=500
ud.speed=90
return {["sillycon"]=ud}