
if not Spring.GetModOptions().custon_units then return end
--[=[
yay istrolid



]=]
VFS.Include("LuaRules/Configs/custom_units/utils.lua")
include("LuaRules/Configs/customcmds.h.lua")

_G=getfenv()

function widget:GetInfo()
    return{
        name      = "Custom Units Choose Cud Integral Cmd",
        desc      = "Integral Cmd to choose Custom Unit Defs",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = -10,
        enabled   = true,  --  loaded by default?
		handler   = true,
    }
end

local UsingCuds=nil

---@param cuds list<{TryGetCudid:fun(self):integer}>
function WG.CustomUnits.ChooseCUDsIntegralCmd(cuds)
    UsingCuds=cuds
end

local CMDs_CHOOSE_CUSTOM_UNIT_I={}
do
    for i = 1, 12 do
        CMDs_CHOOSE_CUSTOM_UNIT_I[_G["CMD_CHOOSE_CUSTOM_UNIT_" .. i]]=i
    end
end
local utils=Spring.Utilities.CustomUnits.utils
local CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
local utils_GenCustomUnitDefViewStr=utils.GenCustomUnitDefView


local utils_GetOrUploadUnitDef
local utils_ChooseCUDToBuild
if false then
    utils_GetOrUploadUnitDef=WG.CustomUnits.GetOrUploadUnitDef
    utils_ChooseCUDToBuild=WG.CustomUnits.ChooseCUDToBuild
end

--"CMD_CHOOSE_CUSTOM_UNIT_" .. i
local function GenChooseCudCmdDesc(i,cudid)
    local cud=CustomUnitDefs[cudid]
    return {
        id      = _G["CMD_CHOOSE_CUSTOM_UNIT_" .. i],
        type    = CMDTYPE.ICON,
        tooltip = utils_GenCustomUnitDefViewStr(cud),
        cursor  = 'Repair',
        action  = "choose_custom_unit_" .. i,
        
        texture = "unitpics/" .. UnitDefs[cud.unitDef].buildpicname,
    }
end


function widget:Initialize()
    CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
    utils_GetOrUploadUnitDef=WG.CustomUnits.GetOrUploadUnitDef
    utils_ChooseCUDToBuild=WG.CustomUnits.ChooseCUDToBuild
end

local spGetSelectedUnits=Spring.GetSelectedUnits
local spGetUnitDefID=Spring.GetUnitDefID
local CustomUnitBuilders=utils.CustomUnitBuilders
function widget:CommandsChanged()
    if UsingCuds then
        local selectedUnits=spGetSelectedUnits();
        local found=false
        for key, uid in pairs(selectedUnits) do
            local udid=spGetUnitDefID(uid)
            --local ud=UnitDefs[udid]
            if CustomUnitBuilders[udid] then
                found=true
                break
            end
        end
        if found  then
            local customCommands = widgetHandler.customCommands
    
            for i = 1, 12 do
                local cudid=UsingCuds[i]:TryGetCudid()
                if cudid then
                    customCommands[#customCommands+1]=GenChooseCudCmdDesc(i,cudid)
                end
            end
        end
        
    end
end

function widget:CommandNotify(cmdID)
    if UsingCuds then
        local i=CMDs_CHOOSE_CUSTOM_UNIT_I[cmdID]
        if i then
            local cudid=UsingCuds[i]:TryGetCudid()
            if cudid then
                utils_ChooseCUDToBuild(cudid)
            else
                Spring.Echo("game_message: cudid not ready")
            end
        end
        
    end
end