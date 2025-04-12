
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_ship_plasma",
    humanName="Ship (Corsair)",
    pictrue=[[unitpics/shipriot.png]],
    description="Ship",
    unitDef=
        utils.GenCustomUnitChassisUnitDef("Custom Ship","Custom Ship","shipriot",utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use())
    ,
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.add_weapon(2),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisSpeedModify(1.2),
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6),
        utils.BasicChassisMutate.hp_check,
    },
    weapons_slots={
        [1]={utils.targeterweapons.projectile_targeter,utils.targeterweapons.line_targeter,utils.targeterweapons.aa_targeter},
        [2]={utils.targeterweapons.projectile_targeter,utils.targeterweapons.line_targeter,utils.targeterweapons.aa_targeter}
    }
}