
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=Spring.GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_tank_plasma",
    humanName="Tank (Minotaur)",
    pictrue=[[unitpics/tankassault.png]],
    description="Tank",
    unitDef=
        utils.GenCustomUnitChassisUnitDef("Custom Tank","Custom Tank","tankassault",utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use())
    ,
    modifies={
        utils.BasicChassisMutate.name,
        utils.BasicChassisMutate.add_weapon(1),
        utils.genCustomModify(
            "motor","add motor","unitpics/module_high_power_servos.png",
            ---@param cud CustomUnitDataModify
            ---@param cost number
            function (cud,cost)
                cud.cost=cud.cost+cost
                cud.motor=cud.motor+(cost^0.6)*1.1*utils.consts.motor
                cud.health=cud.health+cost^utils.bias_factor * 3
                return cud
            end,"number"
        ),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6),
        utils.BasicChassisMutate.hp_check,
    },
    weapons_slots={
        [1]={utils.targeterweapons.projectile_targeter,utils.targeterweapons.line_targeter,utils.targeterweapons.aa_targeter}
    }
}