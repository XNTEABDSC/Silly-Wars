
if not Spring.GetModOptions().custon_units then return end
--[=[

WG.CustomUnits.UploadUnitDef(json) to upload CustomUnitDef

Provides ui to design CustomUnitDef

TODO: auto upload cud from local files
]=]


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

VFS.Include("LuaRules/Utilities/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=Spring.GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal
local spGetGameRulesParam=Spring.GetGameRulesParam
local jsondecode=Spring.Utilities.json.decode
local spSendLuaRulesMsg=Spring.SendLuaRulesMsg

local GenCustomUnitDef=utils.GenCustomUnitDef
local TryGenCustomUnitDef=utils.TryGenCustomUnitDef

local GenCustomUnitDefView=utils.GenCustomUnitDefView


WG.CustomUnits={}

WG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local CustomUnitDefsStringToID={}

WG.CustomUnits.CustomUnitDefsStringToID=CustomUnitDefsStringToID

local function UpdateCustomUnitDefs()
    local count=spGetGameRulesParam("CustomUnitDefsCount")
    if count then
        while #CustomUnitDefs<count do
            --Spring.Echo("Debug: CustomUnits: UpdateCustomUnitDefs")
            local cudid=#CustomUnitDefs+1
            local cudStr=spGetGameRulesParam("CustomUnitDefs"..cudid)
            if cudStr then
                local cudTable=jsondecode(cudStr)
                local cud=GenCustomUnitDef(cudTable)
                CustomUnitDefs[cudid]=cud
                CustomUnitDefsStringToID[cudStr]=cudid-- THE WAY
            end
        end
    end
end


local function GetOrUploadUnitDef(cudStr)
    if cudStr==nil then
        return nil
    end
	local cudid=CustomUnitDefsStringToID[cudStr]
	if cudid then
		return cudid
	end

	local suc,res=TryGenCustomUnitDef(cudStr)
	if suc then
		spSendLuaRulesMsg("SyncedAddCustomUnitDef:"..cudStr)
	else
		Spring.Echo("UploadUnitDef: bad Custom Unit Def with error" .. res)
	end
end
WG.CustomUnits.GetOrUploadUnitDef=GetOrUploadUnitDef
-- --[=[
function widget:RecvFromSynced(msg)
    if msg=="UpdateCustomUnitDefs" then
        UpdateCustomUnitDefs()
    end
end


function widget:Initialize()
	widgetHandler:RegisterGlobal("UpdateCustomUnitDefs",UpdateCustomUnitDefs)
	UpdateCustomUnitDefs()
end

function widget:Shutdown()
	
end