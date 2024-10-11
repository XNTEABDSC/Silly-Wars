local ud=(VFS.Include("units/striderfunnelweb.lua").striderfunnelweb)
VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

ud.name="Big Silly Con"
ud.description="Make Big Silly things"
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
return {["bigsillycon"]=ud}