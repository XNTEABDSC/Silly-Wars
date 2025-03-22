VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils                     = Spring.Utilities.wacky_utils
local utils                           = GameData.CustomUnits.utils


local napalm
do
    napalm=utils.genCustomModify("napalm","stronger","unitpics/weaponmod_napalm_warhead.png",
    ---@param tb CustomWeaponDataModify
    function (tb,b)
        tb.cost=tb.cost*40
        if b then
            tb.weapon_def_name=tb.weapon_def_name .. "_napalm"
            tb.cost=tb.cost*3
            tb.explosionGenerator      = [[custom:napalm_firewalker_small]]
            tb.aoe=128
        else
            tb.explosionGenerator      = [[custom:napalm_koda_small]]
            tb.aoe=96

        end
    end,"boolean",
    utils.genSpamDefsFn(function (k,v)
        local res={}
        res[k]=v
        local v2=Spring.Utilities.CopyTable(v,true)
        local v2_proxy=wacky_utils.may_lower_key_proxy(v2,wacky_utils.may_lower_key_proxy_wd_checkkeys)
        local cp=v2_proxy.customParams
        cp.area_damage_radius=tonumber(cp.area_damage_radius)*1.5
        cp.burntime=tonumber(cp.burntime)*2
        cp.area_damage_duration=16
        res[k .. "_napalm"] = v2
        return res
    end)
    )
end

return utils.GenCustomWeaponBase{
    name="custom_fireball",
    pictrue="unitpics/commweapon_napalmgrenade.png",
    description="FireBall",
    humanName="FireBall",
    WeaponDef={
        name                    = "FireBall",
        avoidFeature            = true,
        avoidFriendly           = true,
        burnblow                = true,
        cegTag                  = [[flamer_koda]],

        customParams              = {
            setunitsonfire = "1",
            burnchance     = "1",
            burntime       = 30,
            force_ignore_ground = [[1]],

            area_damage = 1,
            area_damage_radius = 54,
            area_damage_dps = 40,
            area_damage_duration = 2,
            
            light_color = [[1.6 0.8 0.32]],
            light_radius = 320,
        },
        
        damage                  = {
            default = 40,
        },

        fireStarter             = 100,
        flameGfxTime            = 0.1,
        interceptedByShieldType = 1,
        leadLimit               = 90,
        model                   = [[wep_b_fabby.s3o]],
        noSelfDamage            = true,
        soundHit                = [[FireHit]],
        soundHitVolume          = 5,
        soundStart              = [[FireLaunch]],
        soundStartVolume        = 5,
        turret                  = true,
        weaponType              = [[Cannon]],
        range                   = utils.consts.custom_weapon_common_range,
        weaponVelocity          = utils.consts.custom_weapon_common_projSpeed,
        reloadtime              = utils.consts.custom_weapon_common_reloadtime,
    },
    Modifies={
        utils.weapon_modifies.name,
        napalm,
        utils.weapon_modifies.weapon_def_finish,
        utils.weapon_modifies.proj_speed,
        utils.weapon_modifies.proj_range,
        utils.weapon_modifies.reload,
        utils.weapon_modifies.projectiles,
        utils.weapon_modifies.burst,
    },
    targeter="projectile_targeter"
}