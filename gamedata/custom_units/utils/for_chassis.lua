VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils

local utils = GameData.CustomUnits.utils
local genCustomModify=utils.genCustomModify
local lowerkeys=lowerkeys or wacky_utils.lowerkeys
---make a modify that can add a weapon at slot
local function add_weapon(custom_weapon_num,slot_name)
    slot_name=slot_name or ("slot " .. custom_weapon_num)
    local name="add_weapon_".. custom_weapon_num
    local desc="add weapon at " .. slot_name
    local pic="unitpics/commweapon_beamlaser.png"
        ---@param cud CustomUnitDataModify
    local modfn=function(cud, t)
        if not t then
            return
        end
        --local custom_weapon_num,weapon=t.weapon_num,t.weapon
        local weapon = t
        if cud.weapons[custom_weapon_num] then
            error("unit already have weapon at " .. slot_name)
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
            cud.chassis_name .. "'s weapon " .. slot_name .. " can't use targeter " .. need_targeter)
            return
        end


        cud.weapons[custom_weapon_num] = customWeaponDataMod
        cud.custom_weapon_num_to_unit_weapon_num[custom_weapon_num] = unit_weapon_num
        cud.unit_weapon_num_to_custom_weapon_num[unit_weapon_num] = custom_weapon_num
        cud.cost=cud.cost+customWeaponDataMod.cost
    end
    ---@type ModifyUIgenfn
    local uifn=utils.ui.UIPicThen(pic,name,desc, utils.ui.ChooseAndModify(GameData.CustomUnits.weapons_defs))

    --[=[
    local moddeffn=function (uds)
        for key, ud in pairs(uds) do
            
        end
    end]=]
    ---@type CustomModify
    return {
        name=name,
        description=desc,
        pic=pic,
        paramType="table",
        modfn=modfn,
        genUIFn=uifn,
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
        cud.health = cud.health + factor^utils.bias_factor * 30
        cud.cost = cud.cost + factor
        return cud
    end,"number"),
    
}
utils.BasicChassisMutate.add_weapon=add_weapon
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

---generate a speed modify for speed_per_cost
utils.BasicChassisMutate.genChassisSpeedModify=function (speed_per_cost)
    return genCustomModify("motor","add motor","unitpics/module_high_power_servos.png",
    ---@param cud CustomUnitDataModify
    ---@param cost number
    function (cud,cost)
        cud.cost=cud.cost+cost
        cud.motor=cud.motor+(cost^0.6)*speed_per_cost*1500
        return cud
    end,"number")
end

utils.BasicChassisMutate.genChassisChooseSizeModify=function (sizeMin,sizeMax)
    return {
        name="size",
        description="select size",
        pic="",
        ---@param cud CustomUnitDataModify
        modfn=function (cud)
            local mass=wacky_utils.GetMass(cud.health,cud.cost)
            local size = utils.GetUnitSize(mass)
            if size < sizeMin then
                error("unit is too small. add things.\nfor the chassis " .. cud.chassis_name ..", mass: " .. mass .. " size: " .. size .. "\nsize should be >=" .. sizeMin)
            end
            if size > sizeMax then
                error("unit is too big. remove things.\nfor the chassis " .. cud.chassis_name ..", mass: " .. mass .. " size: " .. size .. "\nsize should be <=" .. sizeMax)
            end
            cud.UnitDefName =  cud.UnitDefName .. "_size" .. size
        end,
        genUIFn=nil,
        --utils.ui.SimpleValueUI(pic,name,desc,paramType),
        moddeffn=function (unitDefBases)
            local newUDs={}
            for name, unitDefBase in pairs(unitDefBases) do
                local unitDefBaseProxy=wacky_utils.may_lower_key_proxy(unitDefBase,wacky_utils.may_lower_key_proxy_ud_checkkeys)
                if not unitDefBaseProxy.customParams.def_scale then
                    unitDefBaseProxy.customParams.def_scale=1
                end
                local unitDefSize=unitDefBaseProxy.footprintX
                for i = sizeMin, sizeMax do
                    local newUD = Spring.Utilities.CopyTable(unitDefBase, true)
                    local scale = i / unitDefSize
                    local newUDProxy=wacky_utils.may_lower_key_proxy(newUD,wacky_utils.may_lower_key_proxy_ud_checkkeys)
                    newUDProxy.customParams.def_scale = newUDProxy.customParams.def_scale * scale
                    newUDs[name .. "_size" ..i] = lowerkeys(newUD)
                end
            end
            return newUDs
            --return utils.GetChassisUnitDef_DifferentSize_Mult(sizeMin,sizeMax)(uds)
        end,
    }
end
GameData.CustomUnits.utils = utils
