VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils                     = Spring.Utilities.wacky_utils
local utils                           = GameData.CustomUnits.utils

local name = "custom_gauss"
local pic = "unitpics/commweapon_gaussrifle.png"
local desc = "A fast, pierce gun"
local humanName = "Gauss"

local custom_weapon_data              = utils.ACustomWeaponData()
custom_weapon_data.weapon_def_name    = name
custom_weapon_data.aoe                = 16
custom_weapon_data.explosionGenerator = [[custom:gauss_hit_h]]
custom_weapon_data.targeter_weapon    = "projectile_targeter"

local modifies                        = {
    utils.weapon_modifies.name,
    utils.weapon_modifies.damage,
    utils.weapon_modifies.proj_speed,
    utils.weapon_modifies.proj_range,
    utils.weapon_modifies.reload,
    --utils.weapon_modifies.into_aa,
}


local modifyfn = utils.UseModifies(modifies)


local weaponDef = {
    name                    = humanName,
    alphaDecay              = 0.12,
    areaOfEffect            = 16,
    avoidfeature            = false,
    bouncerebound           = 0.15,
    bounceslip              = 1,
    cegTag                  = [[gauss_tag_h]],
    craterBoost             = 0,
    craterMult              = 0,

    customParams            = {
        single_hit_multi = true,
        reaim_time = 1,
    },

    damage                  = {
        default = 2,
    },

    explosionGenerator      = [[custom:gauss_hit_h]],
    fireTolerance           = 4000,
    groundbounce            = 1,
    heightMod               = 1.2,
    impactOnly              = true,
    impulseBoost            = 0,
    impulseFactor           = 0,
    interceptedByShieldType = 1,
    noExplode               = true,
    noSelfDamage            = true,
    numbounce               = 40,
    range                   = 600,
    reloadtime              = 2.5,
    rgbColor                = [[0.5 1 1]],
    separation              = 0.5,
    soundHit                = [[weapon/gauss_hit]],
    soundStart              = [[weapon/gauss_fire]],
    stages                  = 32,
    tolerance               = 4000,
    turret                  = true,
    waterweapon             = true,
    weaponType              = [[Cannon]],
    weaponVelocity          = 900,
}

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
    genUIFn = utils.ui.UIPicThen(pic, humanName, desc, utils.ui.StackModifies(modifies))
}
return res
