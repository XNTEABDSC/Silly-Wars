local utils=Spring.Utilities.CustomUnits.utils

if Spring.SpawnProjectile then
    local spSpawnProjectile=Spring.SpawnProjectile
    local spDeleteProjectile=Spring.DeleteProjectile
    local spGetProjectileOwnerID =Spring.GetProjectileOwnerID
    local spGetProjectilePosition=Spring.GetProjectilePosition
    local spGetProjectileVelocity=Spring.GetProjectileVelocity
    local spGetProjectileTeamID=Spring.GetProjectileTeamID
    local spGetProjectileTimeToLive=Spring.GetProjectileTimeToLive

    local spSetProjectileTarget=Spring.SetProjectileTarget
    local spGetProjectileTarget=Spring.GetProjectileTarget

    local spSetProjectileDamages=Spring.SetProjectileDamages
    ---@param targeterProjID ProjectileId
    ---@param customWpnData CustomWeaponDataFinal
    utils.ChangeTargeterToRealProj=function (targeterProjID,customWpnData)
        
        local wdid=customWpnData.weapon_def
        
        local newProjID= spSpawnProjectile(wdid,{
            pos = {spGetProjectilePosition(targeterProjID)},
            
            speed = {spGetProjectileVelocity(targeterProjID)},
            --spread = {number x, number y, number z},
            --error = {number x, number y, number z},
            owner = spGetProjectileOwnerID(targeterProjID),
            team = spGetProjectileTeamID(targeterProjID),
            ttl = spGetProjectileTimeToLive(targeterProjID),
            --gravity = number,
            --tracking = number,
            --maxRange = number,
            --startAlpha = number,
            --endAlpha = number,
            --model = string,
            cegTag = customWpnData.explosionGenerator,
            --end = {number x, number y, number z},
        })

        do
            local v1,v2,v3=spGetProjectileTarget(targeterProjID)
            spSetProjectileTarget(newProjID,v1,v2,v3)
        end
        
        do

            local damage_table={
                damageAreaOfEffect=customWpnData.aoe,
                edgeEffectiveness=customWpnData.edgeEffectiveness,
                explosionSpeed=customWpnData.explosionSpeed,
                craterMult=customWpnData.craterMult,
                craterBoost=customWpnData.craterBoost,
                impulseFactor=customWpnData.impulseFactor,
                impulseBoost=customWpnData.impulseBoost,
                craterAreaOfEffect=customWpnData.craterAreaOfEffect
            }

            for key, value in pairs(customWpnData.damages) do
                damage_table[key]=value
            end
            spSetProjectileDamages(newProjID,0,damage_table)-- spring is so mad
        end
        spDeleteProjectile(targeterProjID)
    end

    local spSetUnitWeaponState=Spring.SetUnitWeaponState

    ---@param customWpnData CustomWeaponDataFinal
    utils.SetUnitWeaponToCustom=function (unitID,wpnnum,customWpnData)
        spSetUnitWeaponState(unitID,wpnnum,{
            reloadTime=customWpnData.reload_time,
            sprayAngle=customWpnData.sprayAngle,
            range=customWpnData.range,
            projectileSpeed=customWpnData.speed,
            burst=customWpnData.burst,
            burstRate=customWpnData.burstRate,
            projectiles=customWpnData.projectiles,
        })
    end
end



Spring.Utilities.CustomUnits.utils=utils