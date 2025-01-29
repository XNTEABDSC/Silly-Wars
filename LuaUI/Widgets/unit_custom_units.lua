
function widget:GetInfo()
    return{
        name      = "Custom Units",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true  --  loaded by default?
    }
end


---@type {[integer]:CustomUnitDataFinal}
local CustomUnitDefs={}

VFS.Include("LuaRules/Configs/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCUD
local jsondecode=Spring.Utilities.json.decode


local function GenCustomUnitDef(cudTable)
    local cud_mod=gdCustomUnits.utils.GenCUD_mod(cudTable)
    local cud=utils.GenCustomChassisDataFinal(cud_mod)
    return cud
end



local spGetGameRulesParam=Spring.GetGameRulesParam

WG.CustomUnits={}

WG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local function UpdateCustomUnitDefs()
    local count=spGetGameRulesParam("CustomUnitDefsCount")
    while #CustomUnitDefs<count do
        Spring.Echo("Debug: CustomUnits: UpdateCustomUnitDefs")
        local cudid=#CustomUnitDefs+1
        local cudStr=spGetGameRulesParam("CustomUnitDefs"..cudid)
        local cudTable=jsondecode(cudStr)
        local cud=GenCustomUnitDef(cudTable)
        CustomUnitDefs[cudid]=cud
    end
end

widgetHandler:RegisterGlobal(widget,"UpdateCustomUnitDefs",UpdateCustomUnitDefs)

-- --[=[
function gadget:RecvFromSynced(msg)
    if msg=="UpdateCustomUnitDefs" then
        UpdateCustomUnitDefs()
    end
end
--]=]

