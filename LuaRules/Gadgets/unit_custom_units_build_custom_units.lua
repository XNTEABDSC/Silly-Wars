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
    local CMD_BUILD_CUSTOM_UNIT=CMD.BUILD_CUSTOM_UNIT
    local CMD_REPAIR=CMD.REPAIR

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
        if ud.customparam.custom_unit_buildcost_range then
            can_build_custom_units_defs[udid]={
                range=tonumber(ud.customparam.custom_unit_buildcost_range)
            }
        end
    end

    local spSetUnitMoveGoal=Spring.SetUnitMoveGoal
    local spGetUnitPosition=Spring.GetUnitPosition
    

    function gadget:CommandFallback(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag)
        if cmdID~=CMD_BUILD_CUSTOM_UNIT then
            return false
        end
        local cudid,tx,ty,tz,facing=cmdParams[1],cmdParams[2],cmdParams[3],cmdParams[4],cmdParams[5]
        local unitBuildDist=UnitDefs[unitDefID].buildDistance
        local ux,uy,uz=spGetUnitPosition(unitID)
        local unit_tar_offset_x=tx-ux
        local unit_tar_offset_z=tz-uz
        local unit_tar_dist_sq=unit_tar_offset_x*unit_tar_offset_x+unit_tar_offset_z*unit_tar_offset_z
        if unit_tar_dist_sq>unitBuildDist*unitBuildDist then
            spSetUnitMoveGoal(unitID,tx,ty,tz,unitBuildDist)
            return true,false
        else
            local spamed_unit=SpawnCustomUnit(cudid,tx,ty,tz,facing,unitTeam,true,true,unitID)

        end
        --SpawnCustomUnit
    end

    function gadget:AllowCommand(unitID, unitDefID, unitTeam, cmdID, cmdParams, cmdOptions, cmdTag, synced)
        if cmdID==CMD_BUILD_CUSTOM_UNIT then
            local can_build_custom_units_def=can_build_custom_units_defs[unitDefID]
            if can_build_custom_units_def==nil then
                return false
            end
            local cudid=cmdParams[1]
            if CustomUnitDefs[cudid]==nil then
                return false
            end

        end
        return true
    end
end