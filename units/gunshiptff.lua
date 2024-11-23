VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

utils_op.MakeSetSillyMorph("gunshipkrow","gunshiptff")
utils_op.MakeAddSillyBuild("gunshiptff")

return utils_op.CopyTweak("gunshipkrow","gunshiptff",function (ud)
    for _,i in pairs({1,2,4})do
        ud.weapons[i].def=nil
        ud.weapons[i].name="turretheavy_plasma"
    end
    ud.weaponDefs.KROWLASER=nil
    ud.weapons[3].def=nil
    ud.weapons[3].name="NOWEAPON"
    --[===[
    ud.weaponDefs.CLUSTERBOMB=utils.get_unit_lua("gunshipskirm").weaponDefs.VTOL_ROCKET
    local missilewd=ud.weaponDefs.CLUSTERBOMB
    
    missilewd.range=600
    missilewd.reloadtime=3
    missilewd.damage                  = {
        default = 1200.1,
    }
    missilewd.size=2
    missilewd.weaponVelocity=500
    missilewd.flightTime=5]===]
    ud.script=[[gunshiptff.lua]]
    ud.metalCost=16000
    ud.health=48000
    ud.speed=80
    ud.name="The Flying Fortress"
    ud.description="The Flying Fortress"
    ud.customParams={
        def_scale=2
    }
end)