if gadgetHandler:IsSyncedCode() then

    function gadget:GetInfo()
        return{
            name      = "Build Custom Units",
            author    = "XNTEABDSC",
            date      = "",
            license   = "GNU GPL, v2 or later",
            layer     = 1,
            enabled   = true , --  loaded by default?
            desc = "Handle CMD_BUILD_CUSTOM_UNIT"
        }
    end
    
    -- cudid,tx,ty,tz,facing,targetID = cmdParams[1],cmdParams[2],cmdParams[3],cmdParams[4],cmdParams[5],cmdParams[6]
    -- spawned_unit = SpawnCustomUnit(cudid,tx,ty,tz,facing,unitTeam,true,true,nil,builderID)
    -- Spring.Utilities.InsertOrderToUnit(unitID,true,1,CMD_REPAIR,spawned_unit,0)


    include("LuaRules/Configs/customcmds.h.lua")

    local CMD_BUILD_CUSTOM_UNIT=CMD.BUILD_CUSTOM_UNIT or CMD_BUILD_CUSTOM_UNIT
    local CMD_REPAIR=CMD.REPAIR or CMD_REPAIR

    local SpawnCustomUnit
    local CustomUnitDefs

    if GG and GG.CustomUnits and GG.CustomUnits.SpawnCustomUnit then
        SpawnCustomUnit=GG.CustomUnits.SpawnCustomUnit
        CustomUnitDefs=GG.CustomUnits.CustomUnitDefs
    end

    function gadget:Initialize()
        SpawnCustomUnit=GG.CustomUnits.SpawnCustomUnit
        CustomUnitDefs=GG.CustomUnits.CustomUnitDefs
    end

    if not CMD_BUILD_CUSTOM_UNIT then
        Spring.Echo("Error: CustomUnits: CMD.BUILD_CUSTOM_UNIT don't exist")
    end

    local can_build_custom_units_defs={}

    for udid, ud in pairs(UnitDefs) do
        if ud.customParams.custom_unit_buildcost_range then
            can_build_custom_units_defs[udid]={
                range=tonumber(ud.customParams.custom_unit_buildcost_range)
            }
        end
    end

    local spSetUnitMoveGoal=Spring.SetUnitMoveGoal
    local spGetUnitPosition=Spring.GetUnitPosition
    local suInsertOrderToUnit=Spring.Utilities.InsertOrderToUnit
    

    function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag)
        if cmdID~=CMD_BUILD_CUSTOM_UNIT then
            return false
        end
        local cudid,tx,ty,tz,facing,targetID=cmdParams[1],cmdParams[2],cmdParams[3],cmdParams[4],cmdParams[5],cmdParams[6]
        local unitBuildDist=UnitDefs[unitDefID].buildDistance
        local ux,uy,uz=spGetUnitPosition(unitID)
        local unit_tar_offset_x=tx-ux
        local unit_tar_offset_z=tz-uz
        local unit_tar_dist_sq=unit_tar_offset_x*unit_tar_offset_x+unit_tar_offset_z*unit_tar_offset_z
        if unit_tar_dist_sq>unitBuildDist*unitBuildDist then
            spSetUnitMoveGoal(unitID,tx,ty,tz,unitBuildDist)
            --Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command: Unit Moving")
            return true,false
        else
            local spawned_unit=SpawnCustomUnit(cudid,tx,ty,tz,facing,unitTeam,true,true,nil,unitID)
            if spawned_unit then
                --Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command: Unit Spawned")
                --suInsertOrderToUnit(unitID,true,0,CMD_REPAIR,spawned_unit,0)
                return true,true
            else
                --Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command: Failed to create unit")
                return true,false
            end
        end
    end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if cmdID==CMD_BUILD_CUSTOM_UNIT then
            local can_build_custom_units_def=can_build_custom_units_defs[unitDefID]
            if can_build_custom_units_def==nil then
                Spring.Utilities.UnitEcho(unitID,"CustomUnits: CMD_BUILD_CUSTOM_UNIT command blocked because no can_build_custom_units_def")
                return false
            end
            local cudid=cmdParams[1]
            if CustomUnitDefs[cudid]==nil then
                Spring.Utilities.UnitEcho(unitID,"CustomUnits: CMD_BUILD_CUSTOM_UNIT command blocked because no CustomUnitDefs[cudid] cudid:" .. tostring(cudid))
                return false
            end
            Spring.Utilities.UnitEcho(unitID,"DEBUG: CustomUnits: CMD_BUILD_CUSTOM_UNIT command passed")
        end
        return true
    end
end