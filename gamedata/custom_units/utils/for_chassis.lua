local utils=GameData.CustomUnits.utils
local function add_weapon(custom_weapon_num)
    ---@param cud CustomUnitDataModify
    return function (cud,t)
        --local custom_weapon_num,weapon=t.weapon_num,t.weapon
        local weapon=t
        if cud.weapons[custom_weapon_num] then
            error("unit already have weapon at slot" .. custom_weapon_num)
            return
        end
        local customWeaponDataMod=GameData.CustomUnits.weapons_defs[weapon[1]].genfn(weapon[2])
        local need_targeter=customWeaponDataMod.targeter_weapon .. custom_weapon_num
        local chassis=GameData.CustomUnits.chassis_defs[ cud.chassis_name ]

        if not chassis then
            error("chassis " .. cud.chassis_name .. " don't exist")
            return
        end

        local unit_weapon_num=chassis.targeter_name_to_unit_weapon[need_targeter]
        if not unit_weapon_num then
            error("chassis " .. cud.chassis_name .. "'s weapon slot " .. custom_weapon_num .." can't use targeter " .. need_targeter)
            return
        end


        cud.weapons[custom_weapon_num]=customWeaponDataMod
        cud.custom_weapon_num_to_unit_weapon_num[custom_weapon_num]=unit_weapon_num
        cud.unit_weapon_num_to_custom_weapon_num[unit_weapon_num]=custom_weapon_num

    end
end
utils.BasicChassisMutate={
    ---@param cud CustomUnitDataModify
    ---@param factor number
    armor=function (cud,factor)
        cud.health=cud.health+factor*20
        cud.cost=cud.cost+factor
        return cud
    end,

}
for i = 1, utils.targeters_count do
    utils.BasicChassisMutate["add_weapon_" .. i] = add_weapon(i)
end
GameData.CustomUnits.utils=utils
