local utils=GameData.CustomUnits.utils

local consts=GameData.CustomUnits.utils.consts

local projectile_targeter={
    name="projectile_targeter",
    weapon_def={
        name                    = [[Projectile Targeter]],
        --areaOfEffect            = 32,
        craterBoost             = 0,
        craterMult              = 0,
        burst=consts.custom_targeter_burst,
        burstRate=consts.custom_targeter_burstRate,
        projectiles=consts.custom_targeter_projectiles,
      
        customParams        = {
          --light_camera_height = 1500,
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
        soundHit                = [[weapon/cannon/cannon_hit2]],
        soundStart              = [[weapon/cannon/medplasma_fire]],
        turret                  = true,
        weaponType              = [[Cannon]],
        weaponVelocity          = consts.custom_targeter_proj_speed,
    },
    weapon_unit={
        badTargetCategory  = [[FIXEDWING]],
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
    }
}
local beam_targeter={
    name="beam_targeter",
    weapon_def={
        name                    = [[Beam Targeter]],
        beamTime                = 1/30,
        craterBoost             = 0,
        craterMult              = 0,
        projectiles=consts.custom_targeter_projectiles,
      
        customParams            = {
        },
      
        damage                  = {
          default = consts.custom_targeter_damage,
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
        soundStart              = [[weapon/laser/mini_laser]],
        soundStartVolume        = 6,
        thickness               = 5,
        tolerance               = 8192,
        turret                  = true,
        weaponType              = [[BeamLaser]],
    },
    weapon_unit={
        onlyTargetCategory = [[FIXEDWING LAND SINK TURRET SHIP SWIM FLOAT GUNSHIP HOVER]]
    }
}



local targeterweapondefs={}
local targeterweapons={}
for key, value in pairs({projectile_targeter,beam_targeter}) do
    targeterweapons[value.name]=value
end

for i = 1, 8 do
    for key, value in pairs(targeterweapons) do
        targeterweapondefs[key.. tostring(i)]=Spring.Utilities.CopyTable(value.weapon_def,true)
    end
end

utils.targeterweapondefs=targeterweapondefs
utils.targeterweapons=targeterweapons

---to generate unitdef.weapons
---@param weapons_slots {[integer]:list<string>}
---@return table unitdef.weapons
local function GenChassisWeapons(weapons_slots)
    local weapons={}
    for wpnnum, possible_targeters_name in pairs(weapons_slots) do
        for _, targeter_name in pairs(possible_targeters_name) do
            local targeter=targeterweapons
            local weapon_unit=Spring.Utilities.CopyTable(targeter.weapon_unit,true)
            weapon_unit.name=targeter_name .. wpnnum
            weapons[#weapons+1] = weapon_unit
        end
    end
    return weapons
end
utils.GenChassisWeapons=GenChassisWeapons

GameData.CustomUnits.utils=utils