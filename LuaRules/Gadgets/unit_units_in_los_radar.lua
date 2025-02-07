if not gadgetHandler:IsSyncedCode() then
    return
end

function gadget:GetInfo()
	return {
		name      = "Enemy Units In AllyTeams Los Radar",
		desc      = "Register Enemy Units In AllyTeams Los Radar",
		author    = "XNTEABSC",
		date      = "",
		license   = "GNU GPL, v2 or later",
		layer     = -1,
		enabled   = true  --  loaded by default?
	}
end


VFS.Include("LuaRules/Utilities/list_map.lua")
local list_map=Spring.Utilities.list_map
---@type {[AllyteamId]:list_map}
local AllyTeam2EnemyUnitsInRadar={}
---@type {[AllyteamId]:list_map}
local AllyTeam2EnemyUnitsInLOS={}

local AllyTeamList
local spGetUnitAllyTeam=Spring.GetUnitAllyTeam

local spIsUnitInLos=Spring.IsUnitInLos
local spIsUnitInRadar=Spring.IsUnitInRadar

GG.AllyTeam2EnemyUnitsInRadar=AllyTeam2EnemyUnitsInRadar
GG.AllyTeam2EnemyUnitsInLOS=AllyTeam2EnemyUnitsInLOS

function gadget:Initialize()
    AllyTeamList=Spring.GetAllyTeamList()
    local all_units=Spring.GetAllUnits()
    
    for key, allyTeamID in pairs(AllyTeamList) do
        local EnemyUnitsInLOS=list_map.new()
        local EnemyUnitsInRadar=list_map.new()
        for key, unitID in pairs(all_units) do
            if spIsUnitInLos(unitID,allyTeamID) then
                EnemyUnitsInLOS.Add(unitID)
            end
            if spIsUnitInRadar(unitID,allyTeamID)then
                EnemyUnitsInRadar.Add(unitID)
            end
        end
        AllyTeam2EnemyUnitsInLOS[allyTeamID]=EnemyUnitsInLOS
        AllyTeam2EnemyUnitsInRadar[allyTeamID]=EnemyUnitsInRadar
    end
    
end

function gadget:UnitEnteredLos(unitID, unitTeam, allyTeam, unitDefID)
    --local unitallyteam=spGetUnitAllyTeam(unitID)
    AllyTeam2EnemyUnitsInLOS[allyTeam].Add(unitID)
end
function gadget:UnitLeftLos(unitID, unitTeam, allyTeam, unitDefID)
    --local unitallyteam=spGetUnitAllyTeam(unitID)
    AllyTeam2EnemyUnitsInLOS[allyTeam].RemoveByIndex(unitID)
end
function gadget:UnitEnteredRadar(unitID, unitTeam, allyTeam, unitDefID)
    --local unitallyteam=spGetUnitAllyTeam(unitID)
    AllyTeam2EnemyUnitsInRadar[allyTeam].Add(unitID)
end
function gadget:UnitLeftRadar(unitID, unitTeam, allyTeam, unitDefID)
    --local unitallyteam=spGetUnitAllyTeam(unitID)
    AllyTeam2EnemyUnitsInRadar[allyTeam].RemoveByIndex(unitID)
end

function gadget:UnitDestroyed(unitID, unitDefID, unitTeam, attackerID, attackerDefID, attackerTeam)
    local unitallyTeam=spGetUnitAllyTeam(unitID)
    for key, ateam in pairs(AllyTeamList) do
        if ateam~=unitallyTeam then
            AllyTeam2EnemyUnitsInRadar[ateam].RemoveByValue(unitID)
            AllyTeam2EnemyUnitsInLOS[ateam].RemoveByValue(unitID)
        end
    end
end