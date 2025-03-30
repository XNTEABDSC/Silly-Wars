VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils = GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_spider_plasma",
    humanName="Spider (Hermit)",
    pictrue=[[unitpics/spiderassault.png]],
    description="Spider",
    unitDef=
        utils.GenCustomUnitChassisUnitDef("Custom Spider","Custom Spider","spiderassault",utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use())
    ,
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisSpeedModify(0.8),
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6),
        utils.BasicChassisMutate.hp_check,
    },
    weapons_slots={
        [1] = { utils.targeterweapons.projectile_targeter ,utils.targeterweapons.line_targeter},
    }
}