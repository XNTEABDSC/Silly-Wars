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
    ---@param customWpnData CustomWeaponDataModify
    utils.set_projectile_be_weapon_data=function (targeterProjID,customWpnData)
        
        local wdid=utils.update_get_custom_weapon_data_weapon_def_id(customWpnData)
        
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
            spSetProjectileDamages()
        end
    end
end



Spring.Utilities.CustomUnits.utils=utils