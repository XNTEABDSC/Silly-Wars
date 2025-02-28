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
--local spSetProjectileCEG=Spring.SetProjectileCEG

local targeterweapons=GameData.CustomUnits.utils.targeterweapons
local is_beam_targeter={}

for _, targeter in pairs(targeterweapons) do
    if targeter.is_beam then
        for _, value in pairs(targeter.weapon_defs) do
            is_beam_targeter[WeaponDefNames[value].id]=true
        end
    end
end
local GG_SetProjectileExplosionGenerator=GG and GG.SetProjectileExplosionGenerator
--- To change targeter into real projectile
---@param targeterProjID ProjectileId
---@param customWpnData CustomWeaponDataFinal
utils.ChangeTargeterToRealProj=function (targeterProjID,targeterwdid,customWpnData)
    
    local wdid=customWpnData.weapon_def

    local px,py,pz=spGetProjectilePosition(targeterProjID)
    local vx,vy,vz=spGetProjectileVelocity(targeterProjID)
    
    local newProjID


    --local ProjTarget
    local ProjTar_a,ProjTar_b=spGetProjectileTarget(targeterProjID)
    --Spring.Echo("DEBUG: ")
    local ProjEnd
    
    do
        --[=[if type(ProjTar_b)=='number' then
            --ProjEnd=ProjTar_b
        else]=]
        if type(ProjTar_b)=="table" then
            --ProjTarget=b
            ProjEnd=ProjTar_b
        elseif type(ProjTar_a)=="number" then
            --ProjEnd=ProjTar_b
        end
        if not ProjEnd then
            --ProjEnd={px+vx,py+vy,pz+vz}
        end
    end

    if is_beam_targeter[targeterwdid] then
        --Spring.Echo("DEBUG: is_beam_targeter")
        newProjID= spSpawnProjectile(wdid,{
            pos = {px,py,pz},
            
            speed = {vx,vy,vz},
            --spread = {number x, number y, number z},
            --error = {number x, number y, number z},
            owner = spGetProjectileOwnerID(targeterProjID),
            team = spGetProjectileTeamID(targeterProjID),
            ttl = 10,--customWpnData.ttl,
            gravity = 0,
            tracking = false,
            maxRange = customWpnData.range,
            --startAlpha = number,
            --endAlpha = number,
            model = customWpnData.model,
            cegTag = customWpnData.cegTag,
            ["end"] = {px+vx,py+vy,pz+vz},
        })
    else
        newProjID= spSpawnProjectile(wdid,{
            pos = {px,py,pz},
            
            speed = {vx,vy,vz},
            --spread = {number x, number y, number z},
            --error = {number x, number y, number z},
            owner = spGetProjectileOwnerID(targeterProjID),
            team = spGetProjectileTeamID(targeterProjID),
            ttl = spGetProjectileTimeToLive(targeterProjID),
            gravity = -customWpnData.gravity,
            tracking = customWpnData.tracks,
            maxRange = customWpnData.range,
            --startAlpha = number,
            --endAlpha = number,
            model = customWpnData.model,
            cegTag = customWpnData.cegTag,
            ["end"] = ProjEnd,
        })
    end

    if newProjID then
        --spSetProjectileCEG(newProjID,customWpnData.explosionGenerator)

        do
            --[=[if type(ProjTar_b)=='number' then
                spSetProjectileTarget(newProjID,ProjTar_b)
            else]=]
            if type(ProjTar_b)=="table" then
                spSetProjectileTarget(newProjID,ProjTar_b[1],ProjTar_b[2],ProjTar_b[3])
            elseif type(ProjTar_a)=="number" and type(ProjTar_b)=="number" then
                spSetProjectileTarget(newProjID,ProjTar_b,ProjTar_a)
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
                damage_table[ tostring( key ) ]=value
            end
            spSetProjectileDamages(newProjID,0,damage_table)
            GG_SetProjectileExplosionGenerator=GG_SetProjectileExplosionGenerator or GG.SetProjectileExplosionGenerator
            GG_SetProjectileExplosionGenerator(newProjID,customWpnData.explosionGeneratorCustom,wdid)
        end
    end
    
    
    spDeleteProjectile(targeterProjID)
end





Spring.Utilities.CustomUnits.utils=utils