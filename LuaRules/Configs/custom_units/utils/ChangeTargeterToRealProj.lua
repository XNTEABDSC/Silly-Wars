local utils=Spring.Utilities.CustomUnits.utils

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
        gravity = -customWpnData.gravity,
        tracking = customWpnData.tracks,
        --maxRange = number,
        --startAlpha = number,
        --endAlpha = number,
        model = customWpnData.model,
        cegTag = customWpnData.explosionGenerator,
        --end = {number x, number y, number z},
    })

    do
        local v1,v2,v3=spGetProjectileTarget(targeterProjID)
        if v3 then
            spSetProjectileTarget(newProjID,v1,v2,v3)
            
        end
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
            damage_table[ tostring( key )--[=[W T F IS THIS GENIUS]=] ]=value
            --[=[
                SetProjectileDamages, at LuaSyncedCtrl.cpp line 5001
                only do SetSingleDynDamagesKey when key is string
            ]=]
        end
        spSetProjectileDamages(newProjID,0--[=[W T F IS THIS GENIUS]=],damage_table)
        --[=[
            SetProjectileDamages, at LuaSyncedCtrl.cpp line 5001
            op Ctrl C V forgot commet and the second param
        ]=]
    end
    spDeleteProjectile(targeterProjID)
end





Spring.Utilities.CustomUnits.utils=utils