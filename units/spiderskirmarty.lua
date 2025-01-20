VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things



return utils_op.CopyTweakSillyBuildMorphAuto("spiderskirm","spiderskirmarty",function (ud)
    ud.name="Ranged " .. ud.name
    ud.description="Ranged " .. ud.description
    ud.speed=ud.speed*0.8
    ud.metalCost=ud.metalCost*3.5
    ud.health=ud.health*2
    ud.weaponDefs.ADV_ROCKET.range=1200
    ud.customParams.def_scale=(ud.customParams.def_scale or 1)*2
    ud.customParams.tactical_ai_defs_copy="veharty"
    --ud.movementClass="TKBOT4"
    ud.footprintX=4
    ud.footprintZ=4
    ud.iconType="spiderskirmarty"
    utils_op.set_ded_BIG_UNIT(ud)
end)