if gadgetHandler:IsSyncedCode() then

function gadget:GetInfo()
    return {
      name      = "Silly Units Handler",
      desc      = "Spam AMove commands",
      author    = "XNTEABSC",
      date      = "",
      license   = "GNU GPL, v2 or later",
      layer     = 0,
      enabled   = true,
    }
end

local handled_units={}
local spGiveOrderToUnit=Spring.GiveOrderToUnit
local spGetUnitAllyTeam=Spring.GetUnitAllyTeam
local spGetUnitCommands=Spring.GetUnitCommands
local spGetUnitViewPosition=Spring.GetUnitViewPosition
local spGetUnitPosition =Spring.GetUnitPosition
local CMD_FIGHT=CMD.FIGHT

local function NewUnitInfo(unitID)
    return {
        wait_until=0
    }
end

local rand=math.random

local function AddSillyUnit(unitID)
    handled_units[unitID]=NewUnitInfo(unitID)
end
local function RemoveSillyUnit(unitID)
    handled_units[unitID]=nil
end

function gadget:UnitDestroyed(unitID)
    RemoveSillyUnit(unitID)
end
GG.AddSillyUnit=AddSillyUnit
GG.RemoveSillyUnit=RemoveSillyUnit
local update_delay=60
local function GiveAMoveOrderToUnit(unitID,unitInfo)

    local target=nil
    
    if GG.AllyTeam2EnemyUnitsInRadar then
        local unitAllyTeam=spGetUnitAllyTeam(unitID)
        local enemiesInRadar=GG.AllyTeam2EnemyUnitsInRadar[unitAllyTeam]
        if enemiesInRadar then
            local tarlist=enemiesInRadar.list
            local tarCount=#tarlist
            if tarCount>0 then
                for tries = 1, 20 do
                    local tarUnitID=enemiesInRadar.list[math.random(#enemiesInRadar.list)]
                    local px,py,pz=spGetUnitPosition(tarUnitID)--spGetUnitViewPosition(tarUnitID)
                    if px then
                        target={px,py,pz}
                        break
                    else
                    end
                end
            else
            end
        else
        end
    end
    
    if target then
        spGiveOrderToUnit(unitID,CMD.FIGHT,target,0)
    end

end

function gadget:GameFrame(frame)
    for unitID, unitInfo in pairs(handled_units) do
        if unitInfo.wait_until<frame then
            local cmdlist=spGetUnitCommands(unitID,-1)
            if #cmdlist<=0 then
                GiveAMoveOrderToUnit(unitID,unitInfo)
            else
                local lastcmd=cmdlist[#cmdlist]
                ---@cast lastcmd Command
                if lastcmd.cmdID~=CMD_FIGHT then
                    GiveAMoveOrderToUnit(unitID,unitInfo)
                end

            end
            unitInfo.wait_until=frame+update_delay
        end
    end
end
    
end