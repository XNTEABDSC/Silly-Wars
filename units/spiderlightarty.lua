VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
local fleaUD=utils.GetUnitLua("spiderscout")

--UnitDefs["spiderlightarti"]=fleaUD
local lanceUD=utils.GetUnitLua("hoverarty")
local lanceWD=lanceUD.weaponDefs.ATA--Spring.Utilities.CopyTable(lanceUD.weapondefs.ata,true)

fleaUD.weaponDefs.LASER=lanceWD
lanceWD.damage = {
    default = 50,
}
lanceWD.range=800
lanceWD.reloadtime=30
lanceWD.laserFlareSize=3
lanceWD.areaOfEffect=5
lanceWD.beamTime=0.25
lanceWD.soundStartVolume=1
lanceWD.largeBeamLaser = false
lanceWD.customParams.light_radius=5
lanceWD.customParams.nofriendlyfire=1
lanceWD.thickness=3
lanceWD.collideFriendly=false
lanceWD.avoidFriendly=false
fleaUD.speed=60
--[=[
fleaUD.customParams.grey_goo = 1
fleaUD.customParams.grey_goo_spawn = "spiderlightarty"
fleaUD.customParams.grey_goo_drain = 2
fleaUD.customParams.grey_goo_cost = 25
fleaUD.customParams.grey_goo_range = 120
]=]
fleaUD.name="Lancing Flea"
fleaUD.description="Ultralight beam artillery spider"
fleaUD.sightDistance=810
fleaUD.customParams.tactical_ai_defs_copy="cloakarty"
fleaUD.iconType="spiderlightarty"
fleaUD.customParams.idle_cloak=nil
fleaUD.minCloakDistance=nil
fleaUD.script="spiderlightarty.lua"
fleaUD.cloakCost           = nil
fleaUD.moveState=nil
--fleaUD.objectName="lancyFlea"

utils_op.MakeSetSillyBuildMorphSimple("spiderscout","spiderlightarty",1)

return {["spiderlightarty"]=fleaUD}