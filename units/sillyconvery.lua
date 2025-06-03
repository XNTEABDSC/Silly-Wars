local ud=(VFS.Include("units/striderfunnelweb.lua").striderfunnelweb)
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

ud.name="Very Silly Con"
ud.description="To Make Very Silly things"
ud.metalCost=1000
ud.health=3000
ud.weapondefs={}
ud.weapons={}
ud.workertime=40


--[===[
ud.buildoptions={
    "chicken_leaper",
    "dynhub_assault_base",
    "dynhub_recon_base",
    "dynhub_strike_base",
    "dynhub_support_base",
    "dynknight0",
    "dronefighter"
}
]===]
return {["sillyconvery"]=ud}