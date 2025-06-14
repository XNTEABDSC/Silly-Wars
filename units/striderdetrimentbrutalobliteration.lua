VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("striderdetriment","striderdetrimentbrutalobliteration",function (ud)
    ud.name="Detriment Obliteration Brutal"
    local wd=ud.weaponDefs.OBLITERATION_BLASTER

    ud.weaponDefs.GAUSS=nil
    ud.weaponDefs.AALASER=nil
    ud.weaponDefs.TRILASER=nil

    wd.commandFire=nil
    wd.burst=3
    wd.burstrate=0.2
    wd.reloadtime=6
    wd.sprayAngle=wd.sprayAngle/2
    wd.waterweapon= true

    local weapon=ud.weapons[3]
    ud.weapons[1]=weapon
    ud.weapons[2]=weapon
    ud.weapons[3]=utils_op.noweapon_weapon
    ud.weapons[4]=utils_op.noweapon_weapon
    ud.weapons[5]=utils_op.noweapon_weapon
    ud.canManualFire=nil
    ud.customParams.translations_copy_from="striderdetriment"
    ud.customParams.translations={
        en={
            name="Detriment Obliteration Brutal",
            description="Obliteration blaster strider",
            helptext="Take good use of obliteration blaster, Detriment uses obliteration blaster as the only weapon, which is fast, accurate, aoe, and good range."
        }
    }
end)