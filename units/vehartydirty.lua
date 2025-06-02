VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("veharty","vehartydirty",function (ud)
    ud.metalCost=ud.metalCost*3
    ud.health=ud.health*2.5
    local udcp=ud.customParams
    udcp.tactical_ai_defs_copy="veharty"
    udcp.translations=[=[{
        en={
            name="Dirtbag's Badger",
            description="Throw DIRTBAGS!",
            helptext="Mobile dirtbags maker and artillery deployer. To help dirtbags to conquer then world",
        }
    }]=]
    ud.name="Dirtbag's Badger"
    ud.description="Artillery Dirtbag Thrower Rover. Costs 30 per shot"
    ud.customParams.def_scale=1.4
    local wd=ud.weaponDefs.MINE
    local shieldscout=utils.GetUnitLua("shieldscout")
    wd.name=shieldscout.name
    wd.metalPerShot=shieldscout.metalCost
    wd.energyPerShot=shieldscout.metalCost
    wd.areaOfEffect=nil
    wd.model=shieldscout.objectName
    local wdcp=wd.customParams
    wdcp.damage_vs_shield=nil
    wdcp.damage_vs_feature=nil
    wdcp.spawns_name="shieldscout"
    wdcp.spawns_expire=nil
end)