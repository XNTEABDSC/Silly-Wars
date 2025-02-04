
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


local TEST=true

---@type {[integer]:CustomUnitDataFinal}
local CustomUnitDefs={}

VFS.Include("LuaRules/Configs/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal
local spGetGameRulesParam=Spring.GetGameRulesParam
local jsondecode=Spring.Utilities.json.decode
local spSendLuaRulesMsg=Spring.SendLuaRulesMsg

local GenCustomUnitDef=utils.GenCustomUnitDef
local TryGenCustomUnitDef=utils.TryGenCustomUnitDef



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

local function UploadUnitDef(text)
	local suc,res=TryGenCustomUnitDef(text)
	if suc then
		spSendLuaRulesMsg("SyncedAddCustomUnitDef:"..text)
	else
		Spring.Echo("game_message: " .. res)
	end
end
WG.CustomUnits.UploadUnitDef=UploadUnitDef
-- --[=[
function widget:RecvFromSynced(msg)
    if msg=="UpdateCustomUnitDefs" then
        UpdateCustomUnitDefs()
    end
end
---@param cud CustomUnitDataFinal|string
local function GenViewUI(cud,parent)
	--[=[
	local panel=WG.Chili.Panel:New{
		width=100,height=100,
		parent=parent,
		autosize=true,
	}
	local BetterGetChildrenMinimumExtents=WG.Chili.Utils.BetterGetChildrenMinimumExtents
	panel.GetChildrenMinimumExtents=BetterGetChildrenMinimumExtents
	]=]
	local text=""
	if type(cud)=="string" then
		text=cud
	elseif type(cud)=="table" then
		local tabcount=0
		local function TabStr()
			local res=""
			for i = 1, tabcount do
				res=res .. "    "
			end
			return res
		end
		local function PutStrLn(str)
			text=text .. TabStr() .. str .. "\n"
		end
		local cudm=cud.CustomUnitDataModify


		local function PutKV(k,v)
			PutStrLn(tostring(k) .. ": " .. tostring( v ))
		end
		

		local function PutCudParam(key,key_name)
			key_name=key_name or key
			PutStrLn(key .. ": " .. tostring( cud[key]))
		end
		local function PutCudmParam(key,key_name)
			key_name=key_name or key
			PutStrLn(key .. ": " .. tostring(cudm[key]))
		end
		PutCudParam("name")
		PutCudParam("chassis_name","Chassis")
		PutCudParam("cost")
		PutCudParam("health")
		PutKV("speed",cud.speed*Game.gameSpeed)
		PutCudParam("mass")

		for wpn_i = 1, #GameData.CustomUnits.chassis_defs[cud.chassis_name].weapon_slots do
			local cwd=cud.weapons[wpn_i]
			if cwd then
				PutStrLn("Weapon " .. wpn_i)
				tabcount=tabcount+1
				local damage=0
				for damage_i = 0, #cwd.damages do
					damage=math.max(damage,cwd.damages[damage_i])
				end
				PutKV("damage",damage)
				local projCount=1
				if cwd.projectiles then
					projCount=projCount*cwd.projectiles
				end
				if cwd.burst then
					projCount=projCount*cwd.burst
				end
				if projCount>1 then
					PutKV("projectiles",projCount)
				end
				PutKV("reload time",cwd.reload_time .. "s")
				PutKV("dps",projCount*damage/cwd.reload_time)
				PutKV("range",cwd.range)
				PutKV("speed",cwd.projSpeed*Game.gameSpeed)
				if cwd.aoe then
					PutKV("aoe",cwd.aoe)
				end
				tabcount=tabcount-1
			end
		end
	end
	

	local label=WG.Chili.Label:New{
		x=2,y=2,
		caption=text,
		valign="top",
		parent=parent,--panel
		autosize=true
	}
	return label
end
	
local Chili

local Screen0

local ChWindow


local fontSize = 12

local ChLabel

local MainWindow


local WindowScrollPanel

local WindowAutoPanel

local IOPanel

local IOPanel_StrBox

local IOPanel_DesignUI2Str

local IOPanel_Str2DesignUI

local IOPanel_StrBox2CUDView


local IOPanel_StrBox2Net

local CUDView

local jsonencode=Spring.Utilities.json.encode
local jsondecode=Spring.Utilities.json.decode

local function StrBoxToViewUI()
	if CUDView then
		CUDView:Dispose()
		CUDView=nil
	end
	local text=IOPanel_StrBox:GetText()
	local suc,res=TryGenCustomUnitDef(text)
	if suc then
		CUDView=GenViewUI(res,WindowAutoPanel)
	else
		CUDView=GenViewUI(res,WindowAutoPanel)
	end
end

local function ToggleWindow()
	if MainWindow.visible then
		MainWindow:Hide()
	else
		MainWindow:Show()
	end
end

local function TrySetToggleWindowCommandButton()
    if WG.GlobalCommandBar  then
		WG.GlobalCommandBar.AddCommand("LuaUI/Images/commands/bold/build.png", "", ToggleWindow)
	end
end

function widget:Initialize()
	UpdateCustomUnitDefs()
	Chili=WG.Chili
    Screen0=Chili.Screen0
    ChWindow=Chili.Window
    ChLabel=Chili.Label
	MainWindow=ChWindow:New{
		classname = "main_window_small_tall",
		name      = 'CustomUnits',
		x         =  50,
		y         = 150,
		width     = 500,
		height    = 500,
		minWidth  = 150,
		minHeight = 50,
		padding = {16, 8, 16, 8},
		dockable  = true,
		dockableSavePositionOnly = true,
		draggable = true,
		resizable = true,
		tweakResizable = true,
		parent = Screen0,
	}
	WindowScrollPanel=Chili.ScrollPanel:New{
		x         =  2,
		y         = 2,
		right=2,
		bottom=2,
		parent=MainWindow

	}
	WindowAutoPanel=Chili.AutosizeLayoutPanel:New{
		parent=WindowScrollPanel
	}
	DesignerUI=GameData.CustomUnits.utils.ui.ChooseAndModify(GameData.CustomUnits.chassis_defs)(WG,WindowAutoPanel)
	
	IOPanel=Chili.Panel:New{
		parent=WindowAutoPanel,
		width=640,
		x=4,
		height=90,
	}


	IOPanel_StrBox=Chili.EditBox:New{
		parent=IOPanel,
		x=2,right=2,
		y=30,
	}

	IOPanel_DesignUI2Str=Chili.Button:New{
		parent=IOPanel,
		x="5%",width="40%",y=2,
		caption="Designer UI to string",
		OnClick={function ()
			local finalstr
			do
				local get_suc,get_res=pcall(function ()
					return DesignerUI.getValue()
				end)
				if get_suc then
					finalstr=jsonencode(get_res)
					
				else
					finalstr="Error: " .. get_res
				end
			end
			IOPanel_StrBox:SetText(
				finalstr
			)
		end,StrBoxToViewUI}
	}

	IOPanel_Str2DesignUI=Chili.Button:New{
		parent=IOPanel,
		x="55%",width="40%",y=2,
		caption="string to Designer UI",
		OnClick={
			function ()
				local text=IOPanel_StrBox:GetText()
				local decode_suc,decode_res=pcall(jsondecode,text)
				if decode_suc then
					local cud_table=decode_res
					local set_suc,set_res=pcall(DesignerUI.setValue,cud_table)
					if set_suc then
						
					else
						Spring.Echo("game_message: Failed to set string " .. text .. " to ui with error " .. set_res)
						DesignerUI.setValue(nil)
					end
				else
					Spring.Echo("game_message: Failed to decode string " .. text .. " with error " .. decode_res)
				end
			end
			,StrBoxToViewUI
		}
	}

	IOPanel_StrBox2CUDView=Chili.Button:New{
		parent=IOPanel,
		x="5%",width="40%",
		y=60,
		caption="string to View UI",
		OnClick={
			StrBoxToViewUI
		}
	}

	IOPanel_StrBox2Net=Chili.Button:New{
		parent=IOPanel,
		x="55%",width="40%",
		y=60,
		caption="Upload design",
		OnClick={
			function ()
				UploadUnitDef(IOPanel_StrBox:GetText())
			end
		}
	}

	TrySetToggleWindowCommandButton()
end

--[=[
function widget:GameFrame(n)
	if n%15==1 then
		
	end
end
]=]
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

