VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

local ud=utils_op.GetUnitLua("bomberriot")
ud.metalCost=3000
ud.health=6000
ud.speed=ud.speed*0.9

local wd=ud.weaponDefs.NAPALM
wd.name="Glaives"
wd.areaOfEffect=0
wd.stockpile               = true
wd.stockpileTime           = 10^5
wd.customParams.setunitsonfire=nil
wd.customParams.burntime=nil

local udcp=ud.customParams
udcp.stockpiletime  = 3*19
udcp.stockpilecost  = 65*19
udcp.priority_misc  = 1
udcp.def_scale=2

wd.customParams.spawns_name = "cloakraid"
--wd.customParams.spawns_expire = 10^5
wd.model=utils_op.GetUnitLua("cloakraid").objectName
wd.explosionGenerator      = [[custom:dirt]]
wd.damage={
    default=260
}
--wd.customParams.damage_vs_shield = [[190]]
wd.customParams.spawn_blocked_by_shield=true
wd.soundHit                = [[weapon/cannon/badger_hit]]
wd.soundStart              = [[weapon/cannon/badger_fire]]

utils_op.MakeSetSillyBuildMorphBig("bomberriot","bomberspam")
ud.name="Glaives' " .. ud.name
ud.description="Drop 18 Glaives, " .. 65*19 .. " stockpile"
ud.fireState=0

return {bomberspam=ud}