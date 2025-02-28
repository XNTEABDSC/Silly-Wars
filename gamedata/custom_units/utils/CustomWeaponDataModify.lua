local utils=GameData.CustomUnits.utils

utils.ACustomWeaponData=function ()
    ---@class CustomWeaponDataModify
    ---@field cost number
    ---
    ---@field damage_default_mut number
    ---@field damages_mut {[string]:number}
    ---@field damages_base {[string]:number}
    ---@field damage_default_base number
    ---
    ---@field projSpeed_mut number
    ---@field projSpeed_base number
    ---@field range_mut number
    ---@field range_base number
    ---@field reload_time_mut number
    ---@field reload_time_base number
    ---
    ---@field weapon_def_name WeaponDefName
    ---
    ---@field aoe nil|number
    ---@field edgeEffectiveness nil|number
    ---@field explosionSpeed nil|number
    ---@field explosionGenerator nil|string
    ---@field impulseFactor_add nil|number
    ---@field impulseBoost_add nil|number
    ---
    ---@field craterAreaOfEffect nil|number
    ---@field craterMult_add nil|number
    ---@field craterBoost_add nil|number
    ---
    ---@field sprayAngle_add nil|number
    ---@field burst_mut nil|number
    ---@field projectiles_mut nil|number
    ---@field burstRate_mut nil|number
    ---
    ---@field cegTag string|nil
    ---@field soundHit string|nil
    ---@field soundStart string|nil
    ---@field tracks boolean|nil
    ---
    ---@field targeter_weapon string
    ---@field name string|nil
    local o={
        damage_default_mut=1,
        damages_mut={},
        damage_default_base=0,
        damages_base={},
        projSpeed_mut=1,
        projSpeed_base=0,
        range_mut=1,
        range_base=0,
        reload_time_mut=1,
        reload_time_base=0,
        cost=1,
        weapon_def_name="NOWEAPON",
        sprayAngle_add=0,
        burst_mut=1,
        projectiles_mut=1,
        burstRate_mut=1/30,
        aoe=0,
        explosionGenerator=nil,
        targeter_weapon="projectile_targeter"
    }
    return o
end
GameData.CustomUnits.utils=utils