
if not Spring.GetModOptions().custon_units then return end
VFS.Include("LuaRules/Utilities/custom_units/utils.lua")
--[=[
ChooseCUDToBuild + CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS -> CMD_BUILD_CUSTOM_UNIT
--]=]

function widget:GetInfo()
    return{
        name      = "Custom Units handle CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS",
        desc      = "ChooseCUDToBuild + CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS -> CMD_BUILD_CUSTOM_UNIT",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,  --  loaded by default?
		handler   = true,
    }
end


include("LuaRules/Configs/customcmds.h.lua")

local spSetActiveCommand=Spring.SetActiveCommand
local spGetSelectedUnits=Spring.GetSelectedUnits
local spGetUnitDefID=Spring.GetUnitDefID
local spGiveOrderToUnitArray=Spring.GiveOrderToUnitArray



local CustomUnitBuilders=Spring.Utilities.CustomUnits.utils.CustomUnitBuilders
local CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
local utils_CanBuilderBuildCustomUnits=Spring.Utilities.CustomUnits.utils.CanBuilderBuildCustomUnits

--local ChooseCUDPanel=nil

---this + CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS -> BUILD_CUSTOM_UNIT
---@type nil|integer
local cudid_to_build=nil

local CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS_DESC={
    id      = CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS,
    type    = CMDTYPE.ICON_MAP,
    tooltip = 'CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS',
    cursor  = 'Repair',
    action  = 'build_custom_unit',
    texture = 'LuaUI/Images/commands/Bold/upgrade.png',
}

---choose cudid to build, this will activate CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS. 
---then CommandNotify will handle CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS and do build.
local function ChooseCUDToBuild(cudid)
    cudid_to_build=cudid
    local CmdDescIndex=Spring.GetCmdDescIndex(CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS)
    local res=spSetActiveCommand(CmdDescIndex)
end

WG.CustomUnits.ChooseCUDToBuild=ChooseCUDToBuild

function widget:CommandsChanged()
    local selectedunits=spGetSelectedUnits()
    for _, uid in pairs(selectedunits) do
        local CanBuildCustomUnitsDef=CustomUnitBuilders[spGetUnitDefID(uid)]
        if CanBuildCustomUnitsDef then
            --selectedCanBuildUnits[#selectedCanBuildUnits+1] = uid
            local customCommands = widgetHandler.customCommands

            customCommands[#customCommands+1] = CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS_DESC
            break
        end
    end
end

local CMD_OPT_SHIFT=CMD.OPT_SHIFT
local CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS=CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS
local math_bit_and=math.bit_and
function widget:CommandNotify(cmdID, cmdParams, cmdOptions)
    if cmdID==CMD_CHOOSE_BUILD_CUSTOM_UNIT_POS then
        if cudid_to_build~=nil then
            local cud=CustomUnitDefs[cudid_to_build]
            if not cud then
                return true
            end
            local cudcost=cud.cost
            local x,y,z=cmdParams[1],cmdParams[2],cmdParams[3]
            if not ( x and y and z) then
                return true
            end
            local selectedCanBuildUnits={}
            do
                local selectedunits=spGetSelectedUnits()
                for _, uid in pairs(selectedunits) do
                    local udid=spGetUnitDefID(uid)
                    if utils_CanBuilderBuildCustomUnits(uid,udid,cud) then
                        selectedCanBuildUnits[#selectedCanBuildUnits+1] = uid
                    end
                end
            end
            spGiveOrderToUnitArray(selectedCanBuildUnits,CMD_BUILD_CUSTOM_UNIT,{
                cudid_to_build,x,y,z,0
            },0)
            --cudid_to_build=nil
        end
        do
            local opt_shift
            if cmdOptions then
                if type(cmdOptions)=="number" and (math_bit_and(cmdOptions,CMD_OPT_SHIFT)~=0)then
                    opt_shift=true
                end
                if type(cmdOptions)=="table" and cmdOptions.shift then
                    opt_shift=true
                end
            else
            end
            if opt_shift then
                
            else
                cudid_to_build=nil
            end
        end
        return true
        
    end
end

function widget:Initialize()
    CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
end