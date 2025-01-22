VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local utils=Spring.Utilities.wacky_utils

VFS.Include("LuaRules/Utilities/to_make_op_things.lua")
local utils_op=Spring.Utilities.to_make_op_things

VFS.Include("LuaRules/Utilities/to_make_very_op_things.lua")
local to_make_very_op_things=Spring.Utilities.to_make_very_op_things

return utils_op.CopyTweakSillyBuildMorphAuto("striderbantha","striderbanthabrutalata",function (ud)
    ud.name=ud.name .. " Tachyon Brutal"
    ud.weapons[1].def=nil
    ud.weapons[1].name="NOWEAPON"
    ud.weapons[3].def=nil
    ud.weapons[3].name="NOWEAPON"
    ud.weapons[2].def="ATA"
    --ud.weaponDefs.ATA.projectiles=2
    ud.weaponDefs.ATA.reloadtime=5
    ud.weaponDefs.EMP_MISSILE=nil
    ud.weaponDefs.LIGHTNING=nil
    ud.canManualFire=nil
    ud.sfxtypes.explosiongenerators={}
end)