VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils
local utils       = GameData.CustomUnits.utils

local name        = "custom_burst_beam"
local pic         = "unitpics/commweapon_gaussrifle.png"
local desc        = "Burst Beam"
local humanName   = "Tachyon Accelerator"


local weaponDef                       = {
    name                    = humanName,
    areaOfEffect            = 20,
    beamTime                = 1,
    coreThickness           = 0.5,
    craterBoost             = 0,
    craterMult              = 0,

    customParams            = {
        --burst = Shared.BURST_RELIABLE,

        light_color = [[1.25 0.8 1.75]],
        light_radius = 320,
    },
    damage                  = {
        default = 20,
    },

    explosionGenerator      = [[custom:ataalaser]],
    impactOnly              = true,
    impulseBoost            = 0,
    impulseFactor           = 0.4,
    interceptedByShieldType = 1,
    largeBeamLaser          = true,
    laserFlareSize          = 10,
    leadLimit               = 18,
    minIntensity            = 1,
    noSelfDamage            = true,
    range                   = 900,
    reloadtime              = 10,
    rgbColor                = [[0.25 0 1]],
    soundStart              = [[weapon/laser/heavy_laser6]],
    soundStartVolume        = 15,
    texture1                = [[largelaser]],
    texture2                = [[flare]],
    texture3                = [[flare]],
    texture4                = [[smallflare]],
    thickness               = 16.9373846859543,
    tolerance               = 10000,
    turret                  = true,
    weaponType              = [[BeamLaser]],
    weaponVelocity          = 10000,
}

local custom_weapon_data              = utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name    = name
custom_weapon_data.aoe                = weaponDef.areaOfEffect
custom_weapon_data.explosionGenerator = weaponDef.explosionGenerator --[[custom:gauss_hit_h]]
custom_weapon_data.targeter_weapon    = "beam_targeter"
--custom_weapon_data.burst_mut          = 30 -- use burst as beamTime

local modifies                        = {
    utils.weapon_modifies.name,
    utils.weapon_modifies.damage,
    utils.weapon_modifies.beam_range,
    utils.weapon_modifies.reload,
}


local modifyfn = utils.UseModifies(modifies)


---@type CustomWeaponBaseData
local res =
{
    name = name,
    humanName = humanName,
    pic = pic,
    genWeaponDef = function()
        WeaponDefs[name] = lowerkeys(weaponDef)
    end,
    custom_weapon_data = custom_weapon_data,
    genfn = function(mutate_table)
        return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data, true), mutate_table)
    end,
    modifies = modifies,
    genUIFn = utils.ui.UIPicThen(pic, humanName, desc, utils.ui.StackModifies(modifies,2))
}
return res
