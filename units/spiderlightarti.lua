VFS.Include("utils/to_make_op_things.lua")
local utils=GG.to_make_op_things
local fleaUD=utils.get_unit_lua("spiderscout")

--UnitDefs["spiderlightarti"]=fleaUD
local lanceUD=utils.get_unit_lua("hoverarty")
local lanceWD=lanceUD.weaponDefs.ATA--Spring.Utilities.CopyTable(lanceUD.weapondefs.ata,true)

fleaUD.weaponDefs.LASER=lanceWD
lanceWD.damage = {
    default = 50,
}
lanceWD.range=750
lanceWD.reloadtime=30
lanceWD.laserFlareSize=3
lanceWD.areaOfEffect=5
lanceWD.beamTime=0.5
lanceWD.soundStartVolume=1
lanceWD.largeBeamLaser = false
lanceWD.customParams.light_radius=5
lanceWD.customParams.nofriendlyfire=1
lanceWD.thickness=3
lanceWD.collideFriendly=false
lanceWD.avoidFriendly=true
fleaUD.speed=60
fleaUD.customParams.grey_goo = 1
fleaUD.customParams.grey_goo_spawn = "spiderlightarti"
fleaUD.customParams.grey_goo_drain = 2
fleaUD.customParams.grey_goo_cost = 25
fleaUD.customParams.grey_goo_range = 120
fleaUD.name="Lancy Flea"
fleaUD.description="Ultralight beam artillery spider (Burrows)"
fleaUD.sightDistance=780
--fleaUD.objectName="lancyFlea"

utils.set_morth_mul("spiderscout","spiderlightarti",1)
utils.add_build("sillycon","spiderlightarti")

return {["spiderlightarti"]=fleaUD}