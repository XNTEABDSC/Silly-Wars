--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Default Change Size",
		desc      = "Change Size By customParams.def_scale",
		author    = "XNTWSAD",
		date      = "2024",
		license   = "GNU GPL, v2 or later",
		layer     = math.huge,
		enabled   = true,  --  loaded by default?
	}
end

local spSetUnitMidAndAimPos    = Spring.SetUnitMidAndAimPos
local UnitScale--=GG.UnitScale
local spSetUnitCollisionVolumeData = Spring.SetUnitCollisionVolumeData
local spGetUnitCollisionVolumeData = Spring.GetUnitCollisionVolumeData

local spGetUnitRadius=Spring.GetUnitRadius
local spGetUnitHeight=Spring.GetUnitHeight
local spSetUnitRadiusAndHeight=Spring.SetUnitRadiusAndHeight


function gadget:Initialize()
    if not GG.UnitScale then
        Spring.Echo("WA TA FA")
    end
    UnitScale=GG.UnitScale
end

function gadget:UnitCreated(unitID, unitDefID, unitTeam)
    if UnitDefs[unitDefID].customParams.def_scale then
        local scale=tonumber(UnitDefs[unitDefID].customParams.def_scale)
        UnitScale(unitID,scale)
        local scaleX, scaleY, scaleZ, offsetX, offsetY, offsetZ,
            volumeType, testType, primaryAxis = spGetUnitCollisionVolumeData(unitID)
        spSetUnitCollisionVolumeData(scaleX*scale,scaleY*scale,scaleZ*scale,offsetX*scale,offsetY*scale,offsetZ*scale,volumeType,testType,primaryAxis)
        local radius,height=spGetUnitRadius(unitID),spGetUnitHeight(unitID)
        spSetUnitRadiusAndHeight(radius,height)
    end
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------