VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
utils_op.MakeSetSillyMorph("shieldshield","shieldshieldpro")
utils_op.MakeAddSillyBuild("shieldshieldpro")
return utils_op.CopyTweak("shieldshield","shieldshieldpro",function (ud)
    ud.name = "Greater " .. ud.name
    ud.description = "Greater Shield to counter greater silly"
    ud.metalCost=ud.metalCost*4
    ud.health=ud.health*2.5
    ud.customParams.tactical_ai_defs_copy="shieldshield"
    local wd=ud.weaponDefs.COR_SHIELD_SMALL
    wd.shieldPower=wd.shieldPower*3
    wd.shieldPowerRegen=wd.shieldPowerRegen*3
    wd.shieldPowerRegenEnergy=wd.shieldPowerRegenEnergy*3
    wd.shieldRadius=wd.shieldRadius*1.5
end)