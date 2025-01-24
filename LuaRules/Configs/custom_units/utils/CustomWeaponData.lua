local utils=Spring.Utilities.CustomUnits.utils

utils.a_custom_weapon_data=function ()
    ---@class CustomWeaponDataModify
    ---@field damage_mut number
    ---@field speed_mut number
    ---@field range_mut number
    ---@field reload_time_mut number
    ---@field cost number
    ---@field mass number
    ---@field weapon_def_name WeaponDefName
    ---@field explosionGenerator nil|string
    ---@field aoe nil|number
    ---@field edgeEffectiveness nil|number
    ---@field sprayAngle_mut nil|number
    ---@field burst_mut nil|number
    ---@field projectiles_mut nil|number
    ---@field burstRate_mut nil|number
    ---@field weapon_def_id nil|WeaponDefId
    local o={
        damage_mut=1,
        speed_mut=1,
        range_mut=1,
        reload_time_mut=1,
        cost=1,
        mass=1,
        weapon_def_name="NOWEAPON",
        sprayAngle_mut=0,
        burst_mut=1,
        projectiles_mut=1,
        burstRate_mut=1/30,
        aoe=0,
        explosionGenerator=nil
    }
    return o
end
---comments
---@param custom_wpn_data CustomWeaponDataModify
utils.update_get_custom_weapon_data_weapon_def_id=function (custom_wpn_data)
    local wdid=custom_wpn_data.weapon_def_id
    if not wdid then
        wdid=WeaponDefNames[custom_wpn_data.weapon_def_name]
        custom_wpn_data.weapon_def_id=wdid
    end
    return wdid
end
Spring.Utilities.CustomUnits.utils=utils