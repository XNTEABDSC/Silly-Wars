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


local CustomUnitDefsLib={}

WG.CustomUnits.CustomUnitDefsLib=CustomUnitDefsLib

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

local LibPadWindow=nil

local LibPadTabScroll=nil

local LibPadTabAutoLayout=nil

local CustomUnitDefsLibListUtils={
    Move=function (index,indexInsert)
        ListUtils(CustomUnitDefsLib,function (v,id)
            v.id=id
        end).Move(index,indexInsert)
        ListUtils(LibPadTabAutoLayout.children).Move(index,indexInsert)
    end,
    AddLast=function (tab)
        ListUtils(CustomUnitDefsLib,function (v,id)
            v.id=id
        end).Add(tab)
        LibPadTabAutoLayout:AddChild(tab.control)
    end,
    Remove=function (index)
        local removed= ListUtils(CustomUnitDefsLib,function (v,id)
            v.id=id
        end).Remove(index)
        LibPadTabAutoLayout:RemoveChild(removed.control)
    end
}


local function NewLibPadTabUI(tab)
    local name=tab.name
    local mainPanel=WG.Chili.AutosizeLayoutPanel:New{
        --parent=parent,
        width=320,height=70,
        orientation="horizontal"
    }
    local nameBox
    nameBox=WG.Chili.EditBox:New{
        parent=mainPanel,
        x=2,y=2,height=40,width=100,
        text=tab.name,
        OnTextInput={
            function ()
                tab.name=nameBox:GetText()
            end
        },
        OnClick={

        }
    }
    local moveLeftButton=WG.Chili.Button:New{
        parent=mainPanel,
        width=20,height=20,
        caption="move left",
        OnClick={
            function ()
                if tab.id>1 then
                    CustomUnitDefsLibListUtils.Move(tab.id,tab.id-1)
                end
            end
        }
    }
    local removeButton=WG.Chili.Button:New{
        parent=mainPanel,
        width=20,height=20,
        caption="remove",
        OnClick={
            function ()
                CustomUnitDefsLibListUtils.Remove(tab.id)
            end
        }
    }
    --OnKeyPress
    return mainPanel
end


local function NewCUD(cud)
    return{
        str=cud,
        id=nil,
    }
end

local function NewRow(id,name)
    name=name or ""
    return {
        name=name,
        cuds={},
        id=id
    }
end

local function NewTab(id,name)
    name=name or ""
    local tab={
        name=name,
        rows={},
        id=id
    }
    tab.control=NewLibPadTabUI(tab)
    return tab
end


local function GenDefaultCustomUnitDefsLib()
    return {
        NewTab(1,"default")
    }
end


local function GenTestCustomUnitDefsLib()
    return {
        {
            name="adefault",
            rows={}
        },{
            name="ye",
            rows={}
        },{
            name=nil,
            rows={}
        },{
            name="asdvfb",
            rows={}
        }
    }
end

local function LoadTable(datas)
    for i = 1, #datas do
        local datatab=datas[i]
        local tab=NewTab(i,datatab.name)
        CustomUnitDefsLibListUtils.AddLast(tab)

    end
end

local function LoadLocal()
    if VFS.FileExists(DIR_NAME..FILE_NAME) then
        local table=VFS.Include(DIR_NAME..FILE_NAME)
        CustomUnitDefsLib=table
    else
        CustomUnitDefsLib=GenDefaultCustomUnitDefsLib()
    end

end

local function SaveLocal()
    local res=CustomUnitDefsLib
    table.save(res,DIR_NAME .. FILE_NAME)
end

function widget:Initialize()
    CanBuildCustomUnitsDefs=WG.CustomUnits.CanBuildCustomUnitsDefs
    CustomUnitDefs=WG.CustomUnits.CustomUnitDefs
    LibPadWindow=WG.Chili.Window:New{
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
    LibPadTabScroll=WG.Chili.ScrollPanel:New{
        x=2,y=2,right=2,height=60,
        parent=LibPadWindow,
        verticalScrollbar=false
    }
    LibPadTabAutoLayout=WG.Chili.AutosizeLayoutPanel:New{
        parent=LibPadTabScroll,
        orientation="horizontal",
        preserveChildrenOrder=true
    }


    LoadTable(GenTestCustomUnitDefsLib())
end

function widget:CommandsChanged()
    
end