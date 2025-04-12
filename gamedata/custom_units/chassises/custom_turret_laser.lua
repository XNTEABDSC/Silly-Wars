
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_turret_laser",
    humanName="Turret (Lotus)",
    pictrue=[[unitpics/turretlaser.png]],
    description="Turret",
    unitDef=
        utils.GenCustomUnitChassisUnitDef("Custom Turret","Custom Turret","turretlaser",utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use())
    ,
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6),
        utils.BasicChassisMutate.hp_check,
    },
    weapons_slots={
        [1]={utils.targeterweapons.projectile_targeter,utils.targeterweapons.line_targeter,utils.targeterweapons.aa_targeter}
    }
}