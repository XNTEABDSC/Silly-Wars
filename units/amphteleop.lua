VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things

local amphteleopud=utils.get_unit_lua("amphtele")
do
    local ud=amphteleopud
    ud.name="OP " .. ud.name
    ud.description="Make Djinn Anywhere"
    ud.metalCost=6000
    ud.customParams.teleporter_throughput=500
    ud.customParams.teleporter_beacon_unit="amphteleopbeacon"
    ud.customParams.teleporter_beacon_spawn_time=10
    ud.health=6000
    ud.speed=45
    --utils.set_scale(ud,2)
    ud.customParams.def_scale=2
    utils.set_ded_ATOMIC_BLAST(ud)
end
local amphteleopbeaconud=utils.get_unit_lua("amphtele")
do
    local ud=amphteleopbeaconud
    utils.set_free_unit(ud)
    ud.name="OP Beacon"
    ud.description="The Djinn"
    ud.speed=25
    ud.customParams.area_cloak = 1
    ud.customParams.area_cloak_upkeep = 15
    ud.customParams.area_cloak_radius = 350
    ud.radarDistancejam       = 350
    ud.customParams.area_cloak_recloak_rate = 800
    ud.minCloakDistance       = 210
    ud.customParams.teleporter_throughput=500
    ud.customParams.teleporter_beacon_spawn_time=10
    ud.customParams.bait_level_default=2
    ud.sightDistance=600
    ud.radarDistance=1200
end
utils.set_morth_mul("silly_morth","amphtele","amphteleop")
utils.add_build("silly_build","bigsillycon","amphteleop")
return{
    amphteleop=amphteleopud,
    amphteleopbeacon=amphteleopbeaconud,
}