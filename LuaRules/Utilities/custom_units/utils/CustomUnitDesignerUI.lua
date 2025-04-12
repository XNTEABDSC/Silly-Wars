
local utils=Spring.Utilities.CustomUnits.utils

---make a CustomUnitDesignUI
---@type ModifyUIgenfn
local function GenCustomUnitDesignUI(WG,parent)
        
    ---@type {[integer]:CustomUnitDataFinal}
    --local CustomUnitDefs={}

    local gdCustomUnits=Spring.GameData.CustomUnits
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


    --function widget:Initialize()
    Chili=WG.Chili
    WindowAutoPanel=Chili.AutosizeLayoutPanel:New{
        parent=parent,
        orientation="horizontal",
        columns=2,rows=2,
    }
    local DesignerUI=Spring.GameData.CustomUnits.utils.ui.ChooseAndModify(Spring.GameData.CustomUnits.chassis_defs)(WG,WindowAutoPanel)
    
    local CUDView=Chili.Panel:New{
        autosize=true,
        parent=WindowAutoPanel,
    }

    local function StrBoxToViewUI()
        CUDView:ClearChildren()
        local text=IOPanel_StrBox:GetText()
        local suc,res=TryGenCustomUnitDef(text)
        if suc then
            GenViewUI(res,CUDView)
        else
            GenViewUI(res,CUDView)
        end
    end

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
    local function setValue(text)
        local decode_suc,decode_res=pcall(jsondecode,text)
        if decode_suc then
            local cud_table=decode_res
            local set_suc,set_res=pcall(DesignerUI.setValue,cud_table)
            if set_suc then
                
            else
                Spring.Echo("game_message: Failed to set string " .. tostring(text) .. " to ui with error " .. set_res)
                DesignerUI.setValue(nil)
            end
        else
            Spring.Echo("game_message: Failed to decode string " .. tostring(text) .. " with error " .. decode_res)
        end
        IOPanel_StrBox:SetText(text)
    end

    IOPanel_Str2DesignUI=Chili.Button:New{
        parent=IOPanel,
        x="55%",width="40%",y=2,
        caption="string to Designer UI",
        OnClick={
            function ()
                local text=IOPanel_StrBox:GetText()
                setValue(text)
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

    local getValue=function ()
        return IOPanel_StrBox:GetText()
    end

    --end
    return {
        control=WindowAutoPanel,
        getValue=getValue,
        setValue=setValue
    }
end

utils.GenCustomUnitDesignUI=GenCustomUnitDesignUI
Spring.Utilities.CustomUnits.utils=utils