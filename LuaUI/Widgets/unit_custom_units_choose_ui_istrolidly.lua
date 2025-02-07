--[=[
yay istrolid



]=]
VFS.Include("LuaRules/Configs/custom_units/utils.lua")

_G=getfenv()

function widget:GetInfo()
    return{
        name      = "Custom Units Choose Cud UI",
        desc      = "Istrolid UI for save and use Custom Unit Defs",
        author    = "XNTEABDSC",
        date      = "",
        license   = "GNU GPL, v2 or later",
        layer     = 1,
        enabled   = true,  --  loaded by default?
		handler   = true,
    }
end

local utils=Spring.Utilities.CustomUnits.utils

local CanBuildCustomUnitsDefs=WG.CustomUnits.CanBuildCustomUnitsDefs
local CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
local GenCustomUnitDefView=utils.GenCustomUnitDefView


local CustomUnitDefsIstrolidLib=nil

WG.CustomUnits.CustomUnitDefsIstrolidLib=CustomUnitDefsIstrolidLib

local CUBuilderUsingPadLine={}

local CurrentPadLine={}

local DIR_NAME="LuaUI/Configs/CustomUnits/"

local FILE_NAME="CustomUnitsDefs.lua"



--"CMD_CHOOSE_CUSTOM_UNIT_" .. i
local function GenChooseCudCmdDesc(i,cudid)
    local cud=CustomUnitDefs[cudid]
    return {
        id      = _G["CMD_CHOOSE_CUSTOM_UNIT_" .. i],
        type    = CMDTYPE.ICON,
        tooltip = GenCustomUnitDefView(cud),
        cursor  = 'Repair',
        action  = "choose_custom_unit_" .. i,
        
        texture = "unitpics/" .. UnitDefs[cud.unitDef].buildpicname,
    }
end

local function ListUtils(list,OnMoveRaw)
    ---@type fun(any,integer)
    local function MoveRaw(value,indexInsert)
        list[indexInsert]=value
        if OnMoveRaw then
            OnMoveRaw(value,indexInsert)
        end
    end
    --- move all things between indexStart and indexEnd to 
    local function MoveItems(indexStart,indexEnd)
        if indexEnd==indexStart then
            return
        end
        local dir=1
        if indexStart<indexEnd then
            dir=-1
        end
        for i = indexEnd, indexStart-dir, dir do
            MoveRaw(list[i+dir],i)
        end
    end

    --[=[
    --- move all things between indexStart and indexEnd by offset
    local function MoveItems(indexStart,indexEnd,offset)
        if offset>0 then
            for i = indexEnd, indexStart, -1 do
                MoveRaw(list[i+offset],i)
            end
        else
            for i = indexStart, indexEnd, 1 do
                MoveRaw(list[i+offset],i)
            end
        end
        
    end
    ]=]

    local function Move(index,indexInsert)
        local tab=list[index]
        MoveItems(indexInsert,index)
        MoveRaw(tab,indexInsert)
    end

    local function Add(tab,tabIndexInsert)
        local newlen=#list+1
        tabIndexInsert=tabIndexInsert or newlen
        MoveItems(tabIndexInsert,newlen)
        MoveRaw(tab,tabIndexInsert)
    end

    local function Remove(tabIndex)
        local len=#list
        local res=list[tabIndex]
        MoveItems(len,tabIndex)
        list[len]=nil
        return res
    end

    return {
        Add=Add,Remove=Remove,Move=Move,MoveRaw=MoveRaw
    }
end

local function Gen(CustomUnitDefsIstrolidLibData)
    local lib={
        tabs={},
        
    }
    local padding=2
    
    local Main_Window=WG.Chili.Window:New{
		classname = "main_window_small_tall",
		name      = 'Custom Units Lib UI',
		x         =  50,
		y         = 150,
		width     = 500,
		height    = 500,
		minWidth  = 150,
		minHeight = 50,
		padding = {8, 8, 8, 8},
		dockable  = true,
		dockableSavePositionOnly = true,
		draggable = true,
		resizable = true,
		tweakResizable = true,
		parent = WG.Chili.Screen0,
	}
    lib.control=Main_Window

    local TabPanelScroll=WG.Chili.ScrollPanel:New{
        x=2,y=2,right=2,height=80,
        parent=Main_Window,
        --verticalScrollbar=false
    }

    local TabPanelAuto=WG.Chili.AutosizeLayoutPanel:New{
        parent=TabPanelScroll,
        autosize=true,
        orientation="vertical",
        preserveChildrenOrder=true,
        itemMargin    = {2, 2, 2, 2},
        itemPadding   = {2, 2, 2, 2},
        rows=1
    }
    lib.tabcontrol=TabPanelAuto

    local function MoveTab1left(lib,ida)
        if ida==1 then
            return
        end
        local idb=ida-1
        local taba=lib.tabs[ida]
        local tabb=lib.tabs[idb]

        lib.tabs[idb]=taba
        taba.id=idb
        lib.tabs[ida]=tabb
        tabb.id=ida

        local mainctrl=lib.tabcontrol
        local tabactrl=taba.tabcontrol
        local tabbctrl=tabb.tabcontrol
        --[=[
        mainctrl.children[tabb]=tabactrl
        mainctrl.children[taba]=tabbctrl]=]
        -- Spring.Echo("DEBUG: tabactrl.name: " .. tabactrl.name .. ", tabbctrl.name: " .. tabbctrl.name)
        -- Spring.Echo("DEBUG: 1 childrenByName[a]: " .. tostring(mainctrl.childrenByName[ tabactrl.name]) .. ", childrenByName[b]: " .. tostring(mainctrl.childrenByName[ tabbctrl.name]) )

        -- Spring.Echo("DEBUG: tabactrl ref: " .. tostring( mainctrl.children[ WG.Chili.UnlinkSafe(tabactrl) ] ))
        local found=mainctrl:RemoveChild(tabactrl)
        Spring.Echo("DEBUG: found: " .. tostring(found))
        --mainctrl:RemoveChild(tabbctrl)
        -- Spring.Echo("DEBUG: 2 childrenByName[a]: " .. tostring(mainctrl.childrenByName[ tabactrl.name]) .. ", childrenByName[b]: " .. tostring(mainctrl.childrenByName[ tabbctrl.name]) )
        --[=[
        mainctrl.childrenByName[ tabactrl.name]=nil
        mainctrl.childrenByName[ tabbctrl.name]=nil
        ]=]
        mainctrl:AddChild(tabactrl,true,idb)
        --mainctrl:AddChild(tabbctrl,true,ida)
    end

    local function RemoveTab(lib,id)
        local tab=lib.tabs[id]

        local mainctrl=lib.tabcontrol
        mainctrl:RemoveChild(tab.tabcontrol)

        local len=#lib.tabs
        for i = id, len do
            lib[i]=lib[i+1]
        end

        tab.id=nil
        --tab.tabcontrol:Dispose()
    end

    ---@param tabdata {name:string|nil,rows:any}
    local function AddTab(lib,tabdata)
        local res={
            name=tabdata.name,
            id=#lib.tabs+1,
            rows={}
        }
        lib.tabs[#lib.tabs+1]=res
        do
            local parent=lib.tabcontrol
            local main_panel=WG.Chili.Panel:New{
                parent=parent,
                width=200,height=35,
            }
            res.tabcontrol=main_panel
            local namePanel=WG.Chili.EditBox:New{
                parent=main_panel,
                text=tabdata.name,
                x=2,y=2,bottom=2,width=140,
            }
            local moveLeftPanel=WG.Chili.Button:New{
                parent=main_panel,
                x=144,y=2,bottom=2,width=30,caption="move left",
                OnClick={
                    function ()
                        MoveTab1left(lib,res.id)
                    end
                }
            }
            local moveLeftPanel=WG.Chili.Button:New{
                parent=main_panel,
                x=174,y=2,bottom=2,width=30,caption="move left",
                OnClick={
                    function ()
                        RemoveTab(lib,res.id)
                        
                    end
                }
            }
            
        end
        lib.tabcontrol:AddChild(res.tabcontrol)
        
        return res
    end

    for i = 1, #CustomUnitDefsIstrolidLibData.tabs do
        AddTab(lib,CustomUnitDefsIstrolidLibData.tabs[i])
    end

    return lib
end

function widget:Initialize()
    CanBuildCustomUnitsDefs=WG.CustomUnits.CanBuildCustomUnitsDefs
    CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
    CustomUnitDefsIstrolidLib=Gen({
        tabs={
            {name="adef"},
            {name="awdefvfb"},
            {name=nil},
            {name="ye"},
            {name="1"},
            {name="2"},
            {name="3"},
            {name="4"},
            {name="5"},
            {name="6"},
            {name="7"},
            {name="8"},
        }
    })
    
    WG.CustomUnits.CustomUnitDefsIstrolidLib=CustomUnitDefsIstrolidLib
end

function widget:CommandsChanged()
    
end