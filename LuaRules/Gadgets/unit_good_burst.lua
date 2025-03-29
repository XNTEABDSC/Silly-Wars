if not gadgetHandler:IsSyncedCode() then
	return
end

function gadget:GetInfo()
	return {
		name      = "Good Burst Salvo",
		desc      = "Implement Good Burst Salvo via gadget to avoid script spam",
		author    = "XNTEABDSC",
		date      = "",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true,  --  loaded by default?
	}
end


---@type {[UnitDefId]:{[integer]:{burst:integer,burstRate:integer,reloadPerBurst:integer}}}
local SalvoDataUD={}


---@type {[UnitId]:{[integer]:{burst:integer?,burstRate:integer?,reloadPerBurst:integer?,currentCharge:number}}}
local SalvoData={}

local spGetUnitDefID=Spring.GetUnitDefID

---commented
---@param unitId UnitId
---@param wpnnum integer
---@param unitDefId UnitDefId?
---@return {burst:integer,burstRate:integer,reloadPerBurst:integer,currentCharge:number}|nil
local function GetUnitGoodBurstState(unitId,wpnnum,unitDefId)
    local sdu=SalvoData[unitId]
    if not sdu then
        return nil
    end
    local sduw=sdu[wpnnum]
    if not sduw then
        return nil
    end
    local burst=sduw.burst
    local burstRate=sduw.burstRate
    local currentCharge=sduw.currentCharge
    local reloadPerBurst=sduw.reloadPerBurst
    if burst==nil or burstRate==nil or currentCharge==nil or reloadPerBurst==nil then
        unitDefId=unitDefId or spGetUnitDefID(unitId)
        local sdud=SalvoDataUD[unitDefId]
        if not sdud then
            return nil
        end
        local sdudw=sdud[wpnnum]
        if not sdud then
            return nil
        end
        burst=burst or sduw.burst
        burstRate=burstRate or sduw.burstRate
        currentCharge=currentCharge or sduw.currentCharge
        reloadPerBurst=reloadPerBurst or sduw.reloadPerBurst
    end
    return {burst=burst,burstRate=burstRate,currentCharge=currentCharge,reloadPerBurst=reloadPerBurst}
end

GG.GetUnitGoodBurstState=GetUnitGoodBurstState

for key, value in pairs(UnitDefs) do
    
end