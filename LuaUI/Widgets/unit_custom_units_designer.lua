--[=[
Provides ui to design CustomUnitDef

TODO: auto upload cud from local files
]=]



function widget:GetInfo()
    return{
        name      = "Custom Units Designer",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true  --  loaded by default?
    }
end

---@type {[integer]:CustomUnitDataFinal}
--local CustomUnitDefs={}

VFS.Include("LuaRules/Configs/custom_units/utils.lua")
local utils=Spring.Utilities.CustomUnits.utils
local gdCustomUnits=GameData.CustomUnits
local GenCUD_mod=gdCustomUnits.utils.GenCustomUnitData
local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal
local spGetGameRulesParam=Spring.GetGameRulesParam
local jsondecode=Spring.Utilities.json.decode

local GenCustomUnitDef=utils.GenCustomUnitDef
local TryGenCustomUnitDef=utils.TryGenCustomUnitDef

local GenCustomUnitDefView=utils.GenCustomUnitDefView


--WG.CustomUnits={}

--WG.CustomUnits.CustomUnitDefs=CustomUnitDefs

local UploadUnitDef=WG.CustomUnits.GetOrUploadUnitDef

local MainWindow


local WindowScrollPanel


local CUDView

local jsonencode=Spring.Utilities.json.encode
local jsondecode=Spring.Utilities.json.decode


local function ToggleWindow()
	if MainWindow.visible then
		MainWindow:Hide()
	else
		MainWindow:Show()
	end
end

local function TrySetToggleWindowCommandButton()
    if WG.GlobalCommandBar  then
		WG.GlobalCommandBar.AddCommand("LuaUI/Images/commands/bold/build.png", "Toggle Custom Units Design UI", ToggleWindow)
	end
end

function widget:Initialize()
    UploadUnitDef=WG.CustomUnits.GetOrUploadUnitDef
	local Chili=WG.Chili
    local Screen0=Chili.Screen0
    local ChWindow=Chili.Window
    local ChLabel=Chili.Label
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

	local axaxaxa=utils.GenCustomUnitDesignUI(WG,WindowScrollPanel,"Upload",
	function (text)
		UploadUnitDef(text)
	end)

	TrySetToggleWindowCommandButton()
	WG.CustomUnits.DesignerMainWindow=MainWindow
end
