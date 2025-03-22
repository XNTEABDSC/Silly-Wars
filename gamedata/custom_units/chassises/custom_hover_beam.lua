
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_hover_beam",
    humanName="Hovercraft (Mace)",
    pictrue=[[unitpics/hoverriot.png]],
    description="Hovercraft",
    unitDef=
        utils.GenCustomUnitChassisUnitDef("Custom Hovercraft","Custom Hovercraft","hoverriot",utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use())
    ,
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.genChassisSpeedModify(1.2),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6)
    },
    weapons_slots={
        [1]={"projectile_targeter","line_targeter","aa_targeter"}
    }
}