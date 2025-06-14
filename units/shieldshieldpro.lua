VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things
return utils_op.CopyTweakSillyBuildMorphAuto("shieldshield","shieldshieldpro",function (ud)
    ud.name = "Greater " .. ud.name
    ud.description = "Greater Shield to counter greater silly"
    ud.metalCost=ud.metalCost*5
    ud.health=ud.health*2.5
    ud.customParams.tactical_ai_defs_copy="shieldshield"
    ud.customParams.def_scale=2
    local wd=ud.weaponDefs.COR_SHIELD_SMALL
    wd.shieldPower=wd.shieldPower*3
    wd.shieldPowerRegen=wd.shieldPowerRegen*3
    wd.shieldPowerRegenEnergy=wd.shieldPowerRegenEnergy*3
    wd.shieldRadius=wd.shieldRadius*1.5
    ud.customParams.translations=[=[{
        en={
            name=function(name) return "Greater " .. name end,
            description= "Tougher shield",
            helptext="Greater Shield to counter greater silly"
        }
    }]=]
end)