---targeters are weapons to be used to aim.
---they will be instantly changed to real projectile by unit_custom_units.lua

local utils = Spring.GameData.CustomUnits.utils

local consts = Spring.GameData.CustomUnits.utils.consts
---@class CustomUnitWeaponTargeter
---@field weapon_defs {[integer]:string}
---@field name string
---@field weapon_def_base table
---@field weapon_unit table

---@type CustomUnitWeaponTargeter
local projectile_targeter = {
    name = "projectile_targeter",
    weapon_def_base = {
        name                    = [[Projectile Targeter]],
        --areaOfEffect            = 32,

        customParams            = {
            bogus = 1,
            fake_weapon = 1,
        },

        damage                  = {
            default = consts.custom_targeter_damage,
        },

        explosionGenerator      = [[custom:INGEBORG]],
        interceptedByShieldType = 1,
        noSelfDamage            = true,
        burst                   = consts.custom_targeter_burst,
        burstRate               = consts.custom_targeter_burstRate,
        projectiles             = consts.custom_targeter_projectiles,
        range                   = consts.custom_targeter_range,
        reloadtime              = consts.custom_targeter_reloadtime,
        weaponVelocity          = consts.custom_targeter_proj_speed,
        turret                  = true,
        weaponType              = [[Cannon]],
        highTrajectory=2,
    },
    weapon_unit = {
        badTargetCategory  = [[FIXEDWING]],
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
    },weapon_defs={}
}
---@type CustomUnitWeaponTargeter
local laser_targeter = {
    name = "beam_targeter",
    weapon_def_base =
    -- [=[
    {
        name                    = [[Beam Targeter]],
        beamTime                = 1 / 30,
        craterBoost             = 0,
        craterMult              = 0,
        projectiles             = consts.custom_targeter_projectiles,

        customParams            = {
            bogus = 1,
            fake_weapon = 1,
        },

        damage                  = {
            default = 0.1, --consts.custom_targeter_damage,
        },
        fireStarter             = 100,
        impactOnly              = true,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        laserFlareSize          = 7.5,
        minIntensity            = 1,
        range                   = consts.custom_targeter_range,
        reloadtime              = consts.custom_targeter_reloadtime,
        rgbColor                = [[1 1 1]],
        thickness               = 5,
        tolerance               = 8192,
        turret                  = true,
        weaponType              = [[BeamLaser]],
    }
    -- ]=]
    --[=[
    {
        name                    = [[Beam Targeter]],
        --areaOfEffect            = 32,
        craterBoost             = 0,
        craterMult              = 0,
        burst=consts.custom_targeter_burst,
        burstRate=consts.custom_targeter_burstRate,
        projectiles=consts.custom_targeter_projectiles,

        customParams        = {
            bogus = 1,
        },

        damage                  = {
          default = consts.custom_targeter_damage,
        },

        explosionGenerator      = [[custom:INGEBORG]],
        impulseBoost            = 0,
        impulseFactor           = 0,
        interceptedByShieldType = 1,
        noSelfDamage            = true,
        range                   = consts.custom_targeter_range,
        reloadtime              = consts.custom_targeter_reloadtime,
        turret                  = true,
        weaponType              = [[Cannon]],
        myGravity =0.00001,
        weaponVelocity          = consts.custom_targeter_proj_speed,
    }
    --]=]
    ,
    weapon_unit = {
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
    },
    is_beam = true
    ,weapon_defs={},
}
---@type CustomUnitWeaponTargeter
local line_targeter = {
    name = "line_targeter",
    weapon_def_base =
    -- [=[
    {
        name           = [[Line Targeter]],
        avoidFeature   = true,
        burst          = consts.custom_targeter_burst,
        burstRate      = consts.custom_targeter_burstRate,
        projectiles    = consts.custom_targeter_projectiles,

        customParams   = {
            light_camera_height = 2000,
            light_radius = 200,
            bogus = 1,
            fake_weapon = 1,
        },

        damage         = {
            default = consts.custom_targeter_damage,
        },

        turret         = true,
        weaponType     = [[MissileLauncher]],
        range          = consts.custom_targeter_range,
        reloadtime     = consts.custom_targeter_reloadtime,
        startVelocity  = consts.custom_targeter_proj_speed,
        weaponVelocity = consts.custom_targeter_proj_speed,
    }
    ,
    weapon_unit = {
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
    },weapon_defs={},
}
---@type CustomUnitWeaponTargeter
local aa_targeter = {
    name = "aa_targeter",
    weapon_def_base = {
        name              = [[AA Targeter]],
        canAttackGround   = false,
        cylinderTargeting = 1,
        burnblow          = true,

        customParams      = {
            --burst = Shared.BURST_RELIABLE,
            --

            isaa        = [[1]],
            burnblow    = true,
            reaim_time  = 1,
            fake_weapon = 1,
            bogus       = 1,
        },

        damage            = {
            default = consts.custom_targeter_damage / 10,
            planes  = consts.custom_targeter_damage,
        },

        noSelfDamage      = true,
        turret            = true,
        weaponType        = [[Cannon]],
        burst             = consts.custom_targeter_burst,
        burstRate         = consts.custom_targeter_burstRate,
        projectiles       = consts.custom_targeter_projectiles,
        range             = consts.custom_targeter_range,
        reloadtime        = consts.custom_targeter_reloadtime,
        startVelocity     = consts.custom_targeter_proj_speed,
        weaponVelocity    = consts.custom_targeter_proj_speed,
    },
    weapon_unit = {
        onlyTargetCategory = [[FIXEDWING GUNSHIP]],
    },weapon_defs={},
}
---@type CustomUnitWeaponTargeter
local starburst_targeter = {
    name = "starburst_targeter",
    weapon_def_base = {
        name                    = [[Starburst Targeter]],
        collideFriendly         = false,

        customParams            = {
            reaim_time = 15, -- Some script bug. It does not need fast aim updates anyway.
            light_camera_height = 2500,
            light_color = [[1 0.8 0.2]],
        },

        damage                  = {
            default = 800.1,
        },

        fireStarter             = 100,
        flightTime              = 10,
        impactOnly              = true,
        interceptedByShieldType = 2,
        model                   = [[wep_merl.s3o]],
        noSelfDamage            = true,
        tolerance               = 4000,
        turnrate                = 16000,
        weaponAcceleration      = 280,
        weaponTimer             = 2.1,
        weaponType              = [[StarburstLauncher]],
        weaponVelocity          = 8000,
    },
    weapon_unit={
        badTargetCategory  = [[MOBILE]],
        onlyTargetCategory = [[SWIM LAND SINK TURRET FLOAT SHIP HOVER]],
    },
    weapon_defs={}
}
local targeters_wpnnum_count = 16
local wacky_utils = Spring.Utilities.wacky_utils
local function SetWDBase_consts(wd)
    wacky_utils.table_replace({
        burst          = consts.custom_targeter_burst,
        burstRate      = consts.custom_targeter_burstRate,
        projectiles    = consts.custom_targeter_projectiles,
        range          = consts.custom_targeter_range,
        reloadtime     = consts.custom_targeter_reloadtime,
        startVelocity  = consts.custom_targeter_proj_speed,
        weaponVelocity = consts.custom_targeter_proj_speed,
        damage         = {
            default = consts.custom_targeter_damage,
        },
        customParams   = {
            fake_weapon = 1,
            bogus = 1,
        }
    })(wd)
end
---count of wd for each targeters. also is the maximum custom_weapons_slots for custom units.
---each targeter wd maps to custom_weapons_slot_num
utils.targeters_wpnnum_count = targeters_wpnnum_count


local targeterweapondefs = {}
-- ---@type {[string]:{name:string,weapon_def:table,weapon_unit:table}}
local targeterweapons = {
    projectile_targeter = projectile_targeter,
    laser_targeter=laser_targeter,
    aa_targeter = aa_targeter,
    line_targeter = line_targeter,
    starburst_targeter = starburst_targeter,
}
--[=[
for key, value in pairs({projectile_targeter,beam_targeter,aa_targeter}) do
    targeterweapons[value.name]=value
end
]=]
for name, value in pairs(targeterweapons) do
    SetWDBase_consts(value.weapon_def_base)
    local wd = Spring.Utilities.CopyTable(value.weapon_def_base, true)
    value.weapon_defs = {}
    for i = 1, targeters_wpnnum_count do
        local wd_name=name .. tostring(i)
        targeterweapondefs[wd_name] = wd
        value.weapon_defs[i] = wd_name
    end
end

utils.targeterweapondefs = targeterweapondefs
utils.targeterweapons = targeterweapons

---to generate unitdef.weapons
---@param weapons_slots {[integer]:list<CustomUnitWeaponTargeter>}
---@return table unitdef.weapons
---@return table targeter_name_to_unit_weapon
local function GenChassisUnitWeapons(weapons_slots)
    local weapons = {}
    local targeter_name_to_unit_weapon = {}
    for wpnnum, possible_targeters in pairs(weapons_slots) do
        for _, targeter in pairs(possible_targeters) do
            --local targeter = targeterweapons[targeter]
            local weapon_unit = Spring.Utilities.CopyTable(targeter.weapon_unit, true)
            weapon_unit.name = targeter.weapon_defs[wpnnum]
            weapons[#weapons + 1] = weapon_unit
            targeter_name_to_unit_weapon[weapon_unit.name] = #weapons
        end
    end
    return weapons, targeter_name_to_unit_weapon
end
utils.GenChassisUnitWeapons = GenChassisUnitWeapons



Spring.GameData.CustomUnits.utils = utils
