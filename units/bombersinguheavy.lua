VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

return utils_op.CopyTweakSillyBuildMorph("bombersingu","bombersinguheavy",function (ud)
    ud.name="Singu Likho"
    ud.description="Throw SINGULARITY, 4000 stockpile cost"
    ud.metalCost=24000
    ud.health=20000
    ud.speed=ud.speed*0.85
    local wd=ud.weaponDefs.ARM_PIDR
    ud.fireState=0
    Spring.Utilities.CopyTable(utils_op.GetUnitLua("energysingu").weaponDefs.SINGULARITY,true,wd)
    wd.stockpile               = true
    wd.stockpileTime           = 10^5

    ud.customParams.reammoseconds=[[90]]
    ud.customParams.light_radius=7500
    ud.customParams.stockpiletime  = [[90]]
    ud.customParams.stockpilecost  = [[4000]]
    ud.customParams.priority_misc  = 1
    ud.customParams.def_scale=2
end)

