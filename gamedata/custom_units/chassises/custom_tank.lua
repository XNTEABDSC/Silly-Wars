
VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils=Spring.Utilities.wacky_utils
local utils=GameData.CustomUnits.utils

return utils.GenCustomChassisBase{
    name="custom_tank",
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
                cud.motor=cud.motor+(cost^0.6)*1.1*1500
                cud.health=cud.health+cost^utils.bias_factor * 5
                return cud
            end,"number"
        ),
        utils.BasicChassisMutate.armor,
        utils.BasicChassisMutate.genChassisChooseSizeModify(1,6)
    },
    weapons_slots={
        [1]={"projectile_targeter","line_targeter","aa_targeter"}
    }
}