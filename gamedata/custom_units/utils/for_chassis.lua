local utils = GameData.CustomUnits.utils
local genCustomModify=utils.genCustomModify
local function add_weapon(custom_weapon_num)
    local name="add_weapon_".. custom_weapon_num
    local desc="add weapon at slot " .. custom_weapon_num
    local pic="unitpics/commweapon_beamlaser.png"
        ---@param cud CustomUnitDataModify
    local modfn=function(cud, t)
        if not t then
            return
        end
        --local custom_weapon_num,weapon=t.weapon_num,t.weapon
        local weapon = t
        if cud.weapons[custom_weapon_num] then
            error("unit already have weapon at slot" .. custom_weapon_num)
            return
        end
        local weaponbase=GameData.CustomUnits.weapons_defs[weapon[1]]
        if not weaponbase then
            error("weapon " .. weapon[1] .. " don't exist")
        end
        local customWeaponDataMod = weaponbase.genfn(weapon[2])
        local need_targeter = customWeaponDataMod.targeter_weapon .. custom_weapon_num
        local chassis = GameData.CustomUnits.chassis_defs[cud.chassis_name]

        if not chassis then
            error("chassis " .. cud.chassis_name .. " don't exist")
            return
        end

        local unit_weapon_num = chassis.targeter_name_to_unit_weapon[need_targeter]
        if not unit_weapon_num then
            error("chassis " ..
            cud.chassis_name .. "'s weapon slot " .. custom_weapon_num .. " can't use targeter " .. need_targeter)
            return
        end


        cud.weapons[custom_weapon_num] = customWeaponDataMod
        cud.custom_weapon_num_to_unit_weapon_num[custom_weapon_num] = unit_weapon_num
        cud.unit_weapon_num_to_custom_weapon_num[unit_weapon_num] = custom_weapon_num
    end
    ---@type ModifyUIGenFn
    local uifn=utils.ui.UIPicThen(pic,name,desc, utils.ui.ChooseAndModify(GameData.CustomUnits.weapons_defs))

    ---@type CustomModify
    return {
        name=name,
        description=desc,
        pic=pic,
        paramType="table",
        modfn=modfn,
        genUIFn=uifn
    }

end
utils.BasicChassisMutate = {
    name=genCustomModify("name","add name","unitpics/terraunit.png",
    ---@param cud CustomUnitDataModify
    ---@param name string
    function(cud, name)
        cud.name=name
        return cud
    end,"string"),
    armor=genCustomModify("armor","add armor","unitpics/module_ablative_armor.png",
    ---@param cud CustomUnitDataModify
    ---@param factor number
    function(cud, factor)
        cud.health = cud.health + factor * 20
        cud.cost = cud.cost + factor
        return cud
    end,"number"),
    
}

--[=[
{
    ---@param cud CustomUnitDataModify
    ---@param factor number
    armor = function(cud, factor)
        cud.health = cud.health + factor * 20
        cud.cost = cud.cost + factor
        return cud
    end,

}]=]
for i = 1, utils.targeters_wpnnum_count do
    utils.BasicChassisMutate["add_weapon_" .. i] = add_weapon(i)
end

utils.genChassisSpeedModify=function (speed_per_cost)
    return genCustomModify("motor","add motor","unitpics/module_high_power_servos.png",
    ---@param cud CustomUnitDataModify
    ---@param cost number
    function (cud,cost)
        cud.cost=cud.cost+cost
        cud.motor=cud.motor+cost*speed_per_cost
        return cud
    end,"number")
end
GameData.CustomUnits.utils = utils
