
local utils=Spring.Utilities.CustomUnits.utils

---@param finish_button_action fun(designjson:string)
local function GenCustomUnitDesignUI(WG,parent,finish_button_caption,finish_button_action)
        
    ---@type {[integer]:CustomUnitDataFinal}
    --local CustomUnitDefs={}

    local gdCustomUnits=GameData.CustomUnits
    local GenCUD_mod=gdCustomUnits.utils.GenCustomUnitData
    local GenCustomUnitDataFinal=utils.GenCustomUnitDataFinal
    local spGetGameRulesParam=Spring.GetGameRulesParam
    local jsonencode=Spring.Utilities.json.encode
    local jsondecode=Spring.Utilities.json.decode

    local GenCustomUnitDef=utils.GenCustomUnitDef
    local TryGenCustomUnitDef=utils.TryGenCustomUnitDef

    local GenCustomUnitDefView=utils.GenCustomUnitDefView


    --WG.CustomUnits={}

    --WG.CustomUnits.CustomUnitDefs=CustomUnitDefs

    local UploadUnitDef=WG.CustomUnits.UploadUnitDef
    -- --[=[
    ---@param cud CustomUnitDataFinal|string
    local function GenViewUI(cud,parent)
        local text=GenCustomUnitDefView(cud)
        

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



    local WindowScrollPanel

    local WindowAutoPanel

    local IOPanel

    local IOPanel_StrBox

    local IOPanel_DesignUI2Str

    local IOPanel_Str2DesignUI

    local IOPanel_StrBox2CUDView

    local IOPanel_StrBox2Net

    local CUDView

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

    --function widget:Initialize()
    Chili=WG.Chili
    Screen0=Chili.Screen0
    ChWindow=Chili.Window
    ChLabel=Chili.Label
    --[==[
    MainWindow=Chili.Panel:New{
        parent=parent,
        autosize=true
    }
    MainWindow.GetChildrenMinimumExtents=Chili.Utils.BetterGetChildrenMinimumExtents
    --[=[
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
    }]=]

    WindowScrollPanel=Chili.ScrollPanel:New{
        x         =  2,
        y         = 2,
        right=2,
        bottom=2,
        parent=MainWindow

    }
    ]==]
    WindowAutoPanel=Chili.AutosizeLayoutPanel:New{
        parent=parent
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
        caption=finish_button_caption,
        OnClick={
            function ()
                finish_button_action(IOPanel_StrBox:GetText())
            end
        }
    }

    --end
    return WindowAutoPanel
end

utils.GenCustomUnitDesignUI=GenCustomUnitDesignUI
Spring.Utilities.CustomUnits.utils=utils