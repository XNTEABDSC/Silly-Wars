
if not Spring.GetModOptions().custon_units then return end
--[=[
yay istrolid



]=]
VFS.Include("LuaRules/Configs/custom_units/utils.lua")
include("LuaRules/Configs/customcmds.h.lua")

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

local CMDs_CHOOSE_CUSTOM_UNIT_I={}
do
    for i = 1, 12 do
        CMDs_CHOOSE_CUSTOM_UNIT_I[_G["CMD_CHOOSE_CUSTOM_UNIT_" .. i]]=i
    end
end

local utils=Spring.Utilities.CustomUnits.utils

local CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
local utils_GenCustomUnitDefViewStr=utils.GenCustomUnitDefView
local utils_TryGenCustomUnitDef=utils.TryGenCustomUnitDef


local CustomUnitDefsIstrolidLib=nil

WG.CustomUnits.CustomUnitDefsIstrolidLib=CustomUnitDefsIstrolidLib

local CUBuilderUsingPadLine={}

local CurrentPadLine={}

local DIR_NAME="LuaUI/Configs/CustomUnits/"

local FILE_NAME="CustomUnitsDefs.lua"

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

local LibCudButtonSize=48
local function GenIstrolidLibrary(CustomUnitDefsIstrolidLibData)
    local lib={
        tabs={},
        usingtab=nil,
        usingrow=nil,
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

    local MainTabPanelScroll=WG.Chili.ScrollPanel:New{
        x=2,y=2,right=2,height=60,
        parent=Main_Window,
        
        padding={1,1,1,1}
        --verticalScrollbar=false
    }

    local TabsPanelAuto=WG.Chili.AutosizeLayoutPanel:New{
        parent=MainTabPanelScroll,
        autosize=true,
        orientation="horizontal",
        preserveChildrenOrder=true,
        itemMargin    = {1, 1, 1, 1},
        itemPadding   = {1, 1, 1, 1},
        padding={1,1,1,1},
        rows=1,columns=math.huge,

    }
    lib.tabscontrol=TabsPanelAuto

    local MainRowsPanel=WG.Chili.ScrollPanel:New{
        x=2,right=2,y=62,bottom=2,
        parent=Main_Window,
        padding={1,1,1,1},

    }
    lib.rowscontrol=MainRowsPanel
    lib.usingtab=nil

    local function MoveItemAndControl1Left(idR,list,mainctrl,itemctrl)
        if idR==1 then
            return
        end
        local idL=idR-1
        local itemR=list[idR]
        local itemL=list[idL]

        list[idL]=itemR
        itemR.id=idL
        list[idR]=itemL
        itemL.id=idR

        WG.Chili.Utils.SetChildIndex(mainctrl,itemctrl(itemL),idR)
        WG.Chili.Utils.SetChildIndex(mainctrl,itemctrl(itemR),idL)
        mainctrl:UpdateLayout()
    end
    local function RemoveItemAndControl(id,list,mainctrl,itemctrl)
        local item=list[id]

        mainctrl:RemoveChild(itemctrl(item))

        local len=#list
        for i = id, len do
            list[i]=list[i+1]
            if list[i] then
                list[i].id=i
            end
        end

        item.id=nil

        mainctrl:UpdateLayout()
    end

    function lib.MoveTab1(idR)
        if idR==1 then
            return
        end
        if lib.usingtab==idR then
            lib.usingtab=idR-1
        elseif lib.usingtab==idR-1 then
            lib.usingtab=idR
        end
        MoveItemAndControl1Left(idR,lib.tabs,lib.tabscontrol,function (i)
            return i.tabcontrol
        end)

    end

    function lib.RemoveTab(id)
        if lib.usingtab==id then
            lib.usingtab=nil
        else
            lib.rowscontrol:ShowChild(lib.tabs[id].rowscontrol)
        end
        lib.rowscontrol:RemoveChild(lib.tabs[id].rowscontrol)
        RemoveItemAndControl(id,lib.tabs,lib.tabscontrol,function (i)
            return i.tabcontrol
        end)
    end

    function lib.ChooseTab(id)
        if lib.usingtab then
            lib.rowscontrol:HideChild(lib.tabs[lib.usingtab].rowscontrol)
        end
        lib.usingtab=id
        lib.rowscontrol:ShowChild(lib.tabs[lib.usingtab].rowscontrol)
    end

    local AddTabButton=WG.Chili.Button:New{
        parent=lib.tabscontrol,
        y=2,height=40,width=100,
        caption="Add tab",
        OnClick={
            function ()
                lib.AddTab({name="new"})
            end
        },
        tooltip="Add a new tab"
    }

    ---@param tabdata {name:string|nil,rows:any}
    function lib.AddTab(tabdata)
        local tab={
            name=tabdata.name,
            id=#lib.tabs+1,
            rows={}
        }
        lib.tabs[#lib.tabs+1]=tab
        do
            local parent=lib.tabscontrol
            local main_panel=WG.Chili.Panel:New{
                --parent=parent,
                width=210,height=40,
                padding={1,1,1,1},
            }
            tab.tabcontrol=main_panel
            parent:AddChild(main_panel,true,tab.id)
            local namePanel=WG.Chili.ButtonLabelEdit:New{
                parent=main_panel,
                caption=tabdata.name,
                text=tabdata.name,
                x=2,y=2,bottom=2,width=140,
                tooltip="click to choose tab, double click to change name",
                OnClick={
                    function ()
                        --Spring.Echo("DEBUG: OnClick")
                        lib.ChooseTab(tab.id)
                    end
                },
                OnEdited={
                    function (a,text)
                        tab.name=text
                    end
                }
            }
            local moveLeftPanel=WG.Chili.Button:New{
                parent=main_panel,
                x=144,y=2,bottom=2,width=30,noFont=true,
                OnClick={
                    function ()
                        lib.MoveTab1(tab.id)
                    end
                },
                tooltip="move left"
            }
            WG.Chili.Image:New{
                x = 0,
                y = 0,
                right = 0,
                bottom = 0,
                parent = moveLeftPanel,
                file = 'LuaUI/Images/commands/leftarrow_blank.png',
            }

            local removePanel=WG.Chili.Button:New{
                parent=main_panel,
                x=174,y=2,bottom=2,width=30,noFont=true,
                OnClick={
                    function ()
                        lib.RemoveTab(tab.id)
                        
                    end
                },
                tooltip="delete this tab"
            }
            WG.Chili.Image:New{
                x = 0,
                y = 0,
                right = 0,
                bottom = 0,
                parent = removePanel,
                file = 'LuaUI/Images/cross.png',
            }
            parent:UpdateLayout()
        end
        --lib.tabcontrol:AddChild(tab.tabcontrol)
        
        do
            local RowsPanel=WG.Chili.AutosizeLayoutPanel:New{
                parent=lib.rowscontrol,
                preserveChildrenOrder=true,
                itemMargin    = {2, 2, 2, 2},
                itemPadding   = {2, 2, 2, 2},
                rows=math.huge,columns=1
            }
            tab.rowscontrol=RowsPanel
            lib.rowscontrol:HideChild(tab.rowscontrol)

            
            function tab.MoveRow1(idr)
                if lib.usingtab==tab.id and lib.usingrow then
                    if lib.usingrow==idr then
                        lib.usingrow=idr-1
                    elseif lib.usingrow==idr-1 then
                        lib.usingrow=idr
                    end
                end
                MoveItemAndControl1Left(idr,tab.rows,tab.rowscontrol,function (i)
                    return i.control
                end)
            end

            function tab.RemoveRow(id)
                RemoveItemAndControl(id,tab.rows,tab.rowscontrol,function (i)
                    return i.control
                end)
                if lib.usingtab==tab.id and lib.usingrow then
                    if lib.usingrow==id then
                        lib.usingrow=nil
                    end
                end
            end

            function tab.AddRow(rowdata)
                local row={
                    name=rowdata.name,
                    id=#tab.rows+1,
                    cuds={}
                }
                tab.rows[#tab.rows+1]=row
                local udCount=12

                row.control=WG.Chili.AutosizeLayoutPanel:New{
                    --parent=tab.rowscontrol,
                    preserveChildrenOrder=true,
                    itemMargin    = {2, 2, 2, 2},
                    itemPadding   = {2, 2, 2, 2},
                    rows=1,columns=math.huge
                }
                tab.rowscontrol:AddChild(row.control,row.id)

                local namePanel=WG.Chili.ButtonLabelEdit:New{
                    parent=row.control,
                    caption=row.name,
                    text=row.name,
                    width=140,height=LibCudButtonSize,
                    OnClick={
                        function ()
                            lib.usingtab=tab.id
                            lib.usingrow=row.id
                        end
                    },
                    OnEdited={
                        function (a,text)
                            row.name=text
                        end
                    },
                    tooltip="click to choose row, double click to edit name"
                }

                local function AddCud(cuddata)
                    local cuditem={
                        cudid=nil,
                        cudstr=cuddata
                    }
                    cuditem.control=WG.Chili.Button:New{
                        parent=row.control,
                        width=LibCudButtonSize,height=LibCudButtonSize,noFont=true,
                        OnClick={
                            function ()
                                local DesignerWindow=WG.Chili.Window:New{
                                    classname = "main_window_small_tall",
                                    x         =  50,
                                    y         = 150,
                                    width     = 500,
                                    height    = 500,
                                    minWidth  = 150,
                                    minHeight = 150,
                                    padding = {16, 8, 16, 8},
                                    dockable  = true,
                                    dockableSavePositionOnly = true,
                                    draggable = true,
                                    resizable = true,
                                    tweakResizable = true,
                                    parent = WG.Chili.Screen0,
                                }
                                local Designer
                                local function Save(cudstr)
                                    cuditem.cudstr=cudstr

                                    cuditem.cudid=WG.CustomUnits.CustomUnitDefsStringToID[cudstr]-- upload later

                                    local gen_suc,gen_res=utils_TryGenCustomUnitDef(cudstr)

                                    if gen_suc then
                                        cuditem.imgcontrol.file="unitpics/" .. UnitDefs[gen_res.unitDef].buildpicname
                                        
                                    else
                                        cuditem.imgcontrol.file = 'LuaUI/Images/commshare.png'
                                    end
                                    cuditem.control.tooltip=utils_GenCustomUnitDefViewStr(gen_res)
                                    cuditem.control:Invalidate()
                                    cuditem.imgcontrol:Invalidate()
                                    --cuditem.imgcontrol.file=
                                end
                                local function Close()
                                    WG.Chili.Screen0:RemoveChild(DesignerWindow)
                                end
                                local ButtonsPanel=WG.Chili.AutosizeLayoutPanel:New{
                                    parent=DesignerWindow,
                                    rows=1,columns=2,
                                    width=1000
                                }
                                local SaveButton=WG.Chili.Button:New{
                                    parent=ButtonsPanel,
                                    caption="Save",
                                    autosize=true,
                                    x=2,y=2,
                                    OnClick={function ()
                                        Save(Designer.getValue())
                                    end}
                                }
                                local CloseButton=WG.Chili.Button:New{
                                    parent=ButtonsPanel,
                                    caption="Close",
                                    autosize=true,
                                    x=2,y=2,
                                    OnClick={function ()
                                        Close()
                                    end}
                                }
                                ButtonsPanel:Invalidate()
                                local DesignerScroll=WG.Chili.ScrollPanel:New{
                                    x=2,y=50,right=2,bottom=2,
                                    parent=DesignerWindow,
                                }
                                Designer=utils.GenCustomUnitDesignUI(WG,DesignerScroll)
                                Designer.setValue(cuditem.cudstr)
                            end
                        },
                        tooltip="Click to design"
                    }
                    cuditem.imgcontrol=WG.Chili.Image:New{
                        x = 0,
                        y = 0,
                        right = 0,
                        bottom = 0,
                        parent = cuditem.control,
                        file = 'LuaUI/Images/commshare.png',
                    }

                    cuditem.imgcontrol.tooltip="Click to design"
                    cuditem.imgcontrol:Invalidate()
                    function cuditem:TryGetCudid()
                        local cudid=self.cudid
                        if not cudid then
                            cudid=utils_GetOrUploadUnitDef(self.cudstr)
                            if cudid then
                                self.cudid=cudid
                            end
                        end

                        return cudid
                    end
                    row.cuds[#row.cuds+1] = cuditem
                end
                rowdata.cuds=rowdata.cuds or {}
                for i = 1, udCount do
                    AddCud(rowdata.cuds[i])
                end
                local MoveUpButton=WG.Chili.Button:New{
                    parent=row.control,
                    width=LibCudButtonSize,height=LibCudButtonSize,noFont=true,
                    OnClick={
                        function ()
                            tab.MoveRow1(row.id)
                        end
                    },
                    tooltip="move this row up"
                }
                WG.Chili.Image:New{
                    x = 0,
                    y = 0,
                    right = 0,
                    bottom = 0,
                    parent = MoveUpButton,
                    file = 'LuaUI/Images/commands/load.png',
                }
                local RemoveButton=WG.Chili.Button:New{
                    parent=row.control,
                    width=LibCudButtonSize,height=LibCudButtonSize,noFont=true,
                    OnClick={
                        function ()
                            tab.RemoveRow(row.id)
                        end
                    },
                    tooltip="delete this row"
                }
                WG.Chili.Image:New{
                    x = 0,
                    y = 0,
                    right = 0,
                    bottom = 0,
                    parent = RemoveButton,
                    file = 'LuaUI/Images/cross.png',
                }
                return row
            end

            tabdata.rows=tabdata.rows or {}

            for i=1,#tabdata.rows do
                tab.AddRow(tabdata.rows[i])
            end
            local addRowButton=WG.Chili.Button:New{
                parent=tab.rowscontrol,
                width=200,height=LibCudButtonSize,
                caption="Add a row",
                tooltip="Add a row",
                OnClick={
                    function ()
                        tab.AddRow({name="new"})
                    end
                }
            }
        end
        --lib.rowscontrol:AddChild(tab.rowscontrol)
        
        return tab
    end

    for i = 1, #CustomUnitDefsIstrolidLibData.tabs do
        lib.AddTab(CustomUnitDefsIstrolidLibData.tabs[i])
    end


    return lib
end

local function ToggleWindow()
	if CustomUnitDefsIstrolidLib then
        if CustomUnitDefsIstrolidLib.control.visible then
            CustomUnitDefsIstrolidLib.control:Hide()
        else
            CustomUnitDefsIstrolidLib.control:Show()
        end
    end
end

local function TrySetToggleWindowCommandButton()
    if WG.GlobalCommandBar  then
		local but=WG.GlobalCommandBar.AddCommand("LuaUI/Images/commands/bold/build.png", "Toggle Custom Units Library UI", ToggleWindow)
        but.tooltip="Toggle Custom Units Library UI"
        but:Invalidate()
    end
end

function widget:Initialize()
    CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
    utils_GetOrUploadUnitDef=WG.CustomUnits.GetOrUploadUnitDef
    utils_ChooseCUDToBuild=WG.CustomUnits.ChooseCUDToBuild
    CustomUnitDefsIstrolidLib=GenIstrolidLibrary({
        tabs={
            {name="adef",rows={
                {
                    name="ye"
                },
                {
                    name="aye"
                }
            }},
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
    TrySetToggleWindowCommandButton()
end
local spGetSelectedUnits=Spring.GetSelectedUnits
local spGetUnitDefID=Spring.GetUnitDefID
local CustomUnitBuilders=utils.CustomUnitBuilders
function widget:CommandsChanged()
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
    if found and CustomUnitDefsIstrolidLib.usingtab and CustomUnitDefsIstrolidLib.usingrow then
        local cuds=CustomUnitDefsIstrolidLib.tabs[CustomUnitDefsIstrolidLib.usingtab].rows[CustomUnitDefsIstrolidLib.usingrow].cuds
        local customCommands = widgetHandler.customCommands

        for i = 1, 12 do
            local cudid=cuds[i]:TryGetCudid()
            if cudid then
                customCommands[#customCommands+1]=GenChooseCudCmdDesc(i,cudid)
            end
        end
    end
end

function widget:CommandNotify(cmdID)
    local i=CMDs_CHOOSE_CUSTOM_UNIT_I[cmdID]
    if i then
        if CustomUnitDefsIstrolidLib.usingtab and CustomUnitDefsIstrolidLib.usingrow then
            local cuds=CustomUnitDefsIstrolidLib.tabs[CustomUnitDefsIstrolidLib.usingtab].rows[CustomUnitDefsIstrolidLib.usingrow].cuds
            local cudid=cuds[i]:TryGetCudid()
            if cudid then
                utils_ChooseCUDToBuild(cudid)
            else
                Spring.Echo("game_message: cudid not ready")
            end
        end
        
    end
end