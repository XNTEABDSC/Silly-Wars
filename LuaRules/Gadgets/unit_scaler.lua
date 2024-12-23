--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
if not gadgetHandler:IsSyncedCode() then
	return
end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Size Changer (ULU)",
		desc      = "Changes the sizes of units so their centre of mass may be seen.",
		author    = "GoogleFrog",
		date      = "10 April 2020",
		license   = "GNU GPL, v2 or later",
		layer     = -math.huge,
		enabled   = true,  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local NULL_PIECE = "[null]"
local origPieceTable = {}

VFS.Include("LuaRules/Utilities/tablefunctions.lua")
local suCopyTable = Spring.Utilities.CopyTable

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

local function SetScale(unitID, base, scale)
	local pieceTable = suCopyTable(origPieceTable[unitID])

	pieceTable[1] = pieceTable[1] * scale
	pieceTable[2] = pieceTable[2] * scale
	pieceTable[3] = pieceTable[3] * scale

	pieceTable[5] = pieceTable[5] * scale
	pieceTable[6] = pieceTable[6] * scale
	pieceTable[7] = pieceTable[7] * scale

	pieceTable[9] = pieceTable[9] * scale
	pieceTable[10] = pieceTable[10] * scale
	pieceTable[11] = pieceTable[11] * scale

	pieceTable[13] = pieceTable[13] * scale
	pieceTable[14] = pieceTable[14] * scale
	pieceTable[15] = pieceTable[15] * scale

	Spring.SetUnitPieceMatrix(unitID, base, pieceTable)
end

local function FindBase(unitID)
	local pieces = Spring.GetUnitPieceList(unitID)
	for pieceNum = 1, #pieces do
		if Spring.GetUnitPieceInfo(unitID, pieceNum).parent == NULL_PIECE then
			return pieceNum
		end
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local unitScaleDef={}
local function UnitScale(unitID, scale)
    local base = FindBase(unitID)
	local modelscale=unitScaleDef[unitID]
	if modelscale then
		scale=scale*modelscale
	end
    if base then
		if not origPieceTable[unitID] then
			origPieceTable[unitID] = {Spring.GetUnitPieceMatrix(unitID, base)}
		end

        SetScale(unitID, base, scale)
    end
end

function gadget:UnitCreated(unitID,unitDefID)
	local modelscale=tonumber(UnitDefs[unitDefID].customParams.model_scale)
	if modelscale then
		unitScaleDef[unitID]=modelscale
		UnitScale(unitID,1)
	end
end

function gadget:UnitDestroyed(unitID)
	origPieceTable[unitID] = nil
end

function gadget:Initialize()
	--Spring.Echo("I LOAD IT")
    GG.UnitScale = UnitScale
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------