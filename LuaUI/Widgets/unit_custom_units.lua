
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

--[=[

local UPGRADE_CMD_DESC = {
	id      = CMD_UPGRADE_UNIT,
	type    = CMDTYPE.ICON,
	tooltip = 'Upgrade Commander',
	cursor  = 'Repair',
	action  = 'upgradecomm',
	params  = {},
	texture = 'LuaUI/Images/commands/Bold/upgrade.png',
}

function widget:CommandsChanged()
	local units = cachedSelectedUnits or Spring.GetSelectedUnits()
	if mainWindowShown then
		--Spring.Echo("Upgrade UI Debug - Number of units selected", #units)
		local foundMatchingComm = false
		for i = 1, #units do
			local unitID = units[i]
			local level, chassis, staticLevel = GetCommanderUpgradeAttributes(unitID)
			if level and (not staticLevel) and level == upgradeSignature.level and chassis == upgradeSignature.chassis then
				local alreadyOwned = {}
				local moduleCount = Spring.GetUnitRulesParam(unitID, "comm_module_count")
				for i = 1, moduleCount do
					local module = Spring.GetUnitRulesParam(unitID, "comm_module_" .. i)
					alreadyOwned[#alreadyOwned + 1] = module
				end
				table.sort(alreadyOwned)

				if upgradeUtilities.ModuleSetsAreIdentical(alreadyOwned, upgradeSignature.alreadyOwned) then
					foundMatchingComm = true
					break
				end
			end
		end
		
		if foundMatchingComm then
			local customCommands = widgetHandler.customCommands
			customCommands[#customCommands+1] = UPGRADE_CMD_DESC
		else
			----Spring.Echo("Upgrade UI Debug - Commander Deselected")
			HideMainWindow() -- Hide window if no commander matching the window is selected
		end
	end
	
	if not mainWindowShown then
		local foundRulesParams = false
		for i = 1, #units do
			local unitID = units[i]
			local level, chassis, staticLevel = GetCommanderUpgradeAttributes(unitID, true)
			if level and (not staticLevel) and chassis and (not LEVEL_BOUND or level < LEVEL_BOUND) then
				foundRulesParams = true
				break
			end
		end
		
		if foundRulesParams then
			local customCommands = widgetHandler.customCommands

			customCommands[#customCommands+1] = {
				id      = CMD_UPGRADE_UNIT,
				type    = CMDTYPE.ICON,
				tooltip = 'Upgrade Commander',
				cursor  = 'Repair',
				action  = 'upgradecomm',
				params  = {},
				texture = 'LuaUI/Images/commands/Bold/upgrade.png',
			}
		end
	end
end
]=]