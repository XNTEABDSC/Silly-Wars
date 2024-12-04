VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

local uds=utils_op.CopyTweakSillyBuildMorph("nebula","nebulanebula",function (ud)
    ud.name=ud.name .. "s' " .. ud.name
    ud.description = ud.description .. " of " .. ud.description
    ud.metalCost=ud.metalCost*11
    ud.customParams.drone_defs_carrier_def=[==[
    {
		spawnPieces = {"pad1", "pad2", "pad3", "pad4"},
		{
			drone = UnitDefNames.nebuladrone.id,
			reloadTime = 10,
			maxDrones = 8,
			spawnSize = 1,
			range = 1800,
			maxChaseRange = 1800,
			buildTime = 50,
			maxBuild = 4,
			offsets = {0, 8*3, 15*3, colvolMidX = 0, colvolMidY = 30*3, colvolMidZ = 0, aimX = 0, aimY = 0, aimZ = 0} --shift colvol to avoid collision.
		},
	}
    ]==]
    ud.health=ud.health*3
    ud.speed=ud.speed*0.6
    ud.customParams.def_scale=3
    for i = 1, 4 do
        ud.weapons[i].def=nil
        ud.weapons[i].name="NOWEAPON"
    end
    local shwd=ud.weaponDefs.SHIELD
    ud.weaponDefs.CANNON=nil
    shwd.shieldPower=shwd.shieldPower*4.5
    shwd.shieldRadius=shwd.shieldRadius*3
    shwd.shieldPowerRegen=shwd.shieldPowerRegen*6
    shwd.shieldPowerRegenEnergy=shwd.shieldPowerRegenEnergy*6
    ud.iconType               = [[nebulanebula]]
	ud.sightDistance=ud.sightDistance*3
	ud.cruiseAltitude=ud.cruiseAltitude+75
end)
local nebuladrone=utils_op.GetUnitLua("nebula")
uds.nebuladrone=nebuladrone
utils_op.set_free_unit(nebuladrone)
utils.table_replace({
	customParams={
		is_drone=1,
		drone_defs_is_drone=1,
		drone_defs_carrier_def=[==[
		{
			spawnPieces = {"pad1", "pad2", "pad3", "pad4"},
			{
				drone = UnitDefNames.dronefighter.id,
				reloadTime = 15,
				maxDrones = 8,
				spawnSize = 2,
				range = 1000,
				maxChaseRange = 1500,
				buildTime = 3,
				maxBuild = 4,
				offsets = {0, 8, 15, colvolMidX = 0, colvolMidY = 30, colvolMidZ = 0, aimX = 0, aimY = 0, aimZ = 0} --shift colvol to avoid collision.
			},
		}
		]==],
	},
	reclaimable=false,
	repairable=false,
	canBeAssisted=false,
})(nebuladrone)
return uds