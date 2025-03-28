local utils=GameData.CustomUnits.utils
local ui={}

---A picture and thenUI at right
---@param thenUIFn ModifyUIgenfn
local function UIPicThen(pic,name,desc,thenUIFn)
    ---@type ModifyUIgenfn
    return function (WG,parent)
        local panel0=
        WG.Chili.Panel:New{
            parent=parent,
            --x=2,
            width=40,
            --right=2,
			height    = 40,
			minHeight = 40,
			minWidth = 40,
            autosize=true,
        }
        
        local BetterGetChildrenMinimumExtents=WG.Chili.Utils.BetterGetChildrenMinimumExtents
        panel0.GetChildrenMinimumExtents=BetterGetChildrenMinimumExtents
        local picbox=WG.Chili.Image:New{
            x = 0,
            y = 0,
            width=20,
            height=20,
            file = pic,
            parent=panel0,
            tooltip=name .. ": " .. desc,
            --greedyHitTest=true,
            
        }
        picbox.HitTest=WG.Chili.Utils.HitTestSelf
        local thenUI=thenUIFn(WG,panel0)
        thenUI.control:SetPos(22)

        return{
            control=panel0,
            getValue=thenUI.getValue,
            setValue=thenUI.setValue
        }
    end
end
ui.UIPicThen=UIPicThen
---A Box to edit values. can be string, number, boolean
---@param paramtype "string"|"number"|"boolean"
local function AutoEditBoxUI(paramtype)
    return function (WG,parent)
        local panel
        local paramtypenum=({
            string=1,
            number=2,
            boolean=3
        })[paramtype]
        local getValue,setValue
        if not paramtypenum then
            error("missing paramtype")
        end
        if paramtypenum==3 then
            local Checkbox=WG.Chili.Checkbox:New{
                parent=parent,
                checked=false,
                caption=""
            }
            getValue=function ()
                return Checkbox.checked
            end
            setValue=function (v)
                if Checkbox.checked~=v then
                    Checkbox:Toggle()
                end
                --Checkbox:SetToggle(v)
            end
            panel=Checkbox
        else
            local editbox=WG.Chili.EditBox:New{
                parent=parent,
                width=100,
            }
            if paramtypenum==1 then
                getValue=function ()
                    return editbox:GetText()
                end
                setValue=function (v)
                    editbox:SetText(v)
                end
            elseif paramtypenum==2 then
                getValue=function ()
                    ---@type string
                    local t=editbox:GetText()
                    if t==nil or t:len()==0 then
                        return nil
                    end
                    local res=tonumber(t )
                    if not res then
                        error("not a number " .. tostring(t))
                    end
                    return res
                end
                setValue=function (v)
                    editbox:SetText(tostring( v ))
                end
            end
            panel=editbox
        end
    
    
        return{
            control=panel,
            getValue=getValue,
            setValue=setValue
        }
    end
    
end
ui.AutoEditBoxUI=AutoEditBoxUI

---UIPicThen EditBoxUI
function ui.SimpleValueUI(pic,name,desc,paramtype)
    return UIPicThen(pic,name,desc,AutoEditBoxUI(paramtype))
end
---Show Modifies genUIFn
---@param modifies {[integer]:CustomModify}
function ui.StackModifies(modifies,columns)
    columns=columns or 1
    return function (WG,parent)
        local panel=WG.Chili.AutosizeLayoutPanel:New{
            orientation = "horizontal",
            parent=parent,
            x=2,y=2,width=200,height=100,
			padding = {2, 2, 2, 2},
            itemPadding = {0, 0, 0, 0},
            itemMargin  = {5, 5, 5, 5},
            rows=math.huge,
            columns=columns,
            --cols=1,rows=1000
        }
        local BetterGetChildrenMinimumExtents=WG.Chili.Utils.BetterGetChildrenMinimumExtents
        panel.GetChildrenMinimumExtents=BetterGetChildrenMinimumExtents
        ---@type list<ModifyUI>
        local modifyUIs={}
        local modify_name_to_index={}
        for index, modify in pairs(modifies) do
            if modify.genUIFn then
                local modifyUI=modify.genUIFn(WG,panel)
                modifyUIs[index]=modifyUI
                modify_name_to_index[modify.name]=index
            end
        end
        local getValue,setValue
        getValue=function ()
            local res={}
            for index, value in pairs(modifies) do
                if modifyUIs[index] then
                    if modifyUIs[index].getValue == nil then
                        Spring.Echo("DEBUG: CustomUnits: ui no getValue for "..modifies[index].name)
                    else
                        res[value.name]=modifyUIs[index].getValue()
                    end
                end
            end
            return res
        end
        setValue=function (t)
            for key, value in pairs(t) do
                local index=modify_name_to_index[key]
                if index then
                    modifyUIs[index].setValue(value)
                end
            end
        end
        return {
            control=panel,
            getValue=getValue,
            setValue=setValue
        }
    end
end

---ComboBox for items to choose and show its genUIFn
---@param items table<string,{name:string,genUIFn:ModifyUIgenfn,humanName:string}>
function ui.ChooseAndModify(items)
    return function (WG,parent)
        ---@type string|nil
        local choosed_item=nil
        ---@type string|nil
        local current_item=nil
        local panel=
        WG.Chili.Panel:New{
            parent=parent,
            --x=2,y=2,
            width=200,
            padding={2,2,2,2},
            autosize=true
        }
        local BetterGetChildrenMinimumExtents=WG.Chili.Utils.BetterGetChildrenMinimumExtents
        panel.GetChildrenMinimumExtents=BetterGetChildrenMinimumExtents

        local item_id_to_name={"empty"}
        local item_id_to_humanName={"Empty"}
        local item_name_to_id={empty=1}
        for key, value in pairs(items) do
            local id=#item_id_to_name+1
            item_id_to_name[id]=value.name
            item_name_to_id[key]=id
            item_id_to_humanName[id]=value.humanName or value.name
        end

        local UpdateUI

        local item_mod_ui_panel=
        panel

        ---@type ModifyUI|nil
        local item_mod_ui=nil
        

        local function Remove_item_mod_ui()
            if item_mod_ui then
                item_mod_ui_panel:RemoveChild(item_mod_ui.control)
                item_mod_ui=nil
            end
        end

        local function Add_item_mod_ui(choosed_weapon_base)
            item_mod_ui=choosed_weapon_base.genUIFn(WG,item_mod_ui_panel)
            --item_mod_ui_panel:AddC
            item_mod_ui.control:SetPos(nil,30)
            --item_mod_ui.control.y=30
        end


        UpdateUI=function ()
            local item_base=nil
            if choosed_item then
                item_base=items[choosed_item]
                
            end
            if not item_base then
                choosed_item=nil
            end
            if current_item~=choosed_item then
                Remove_item_mod_ui()
                if choosed_item~=nil then
                    Add_item_mod_ui(item_base)
                else

                end
                current_item=choosed_item
                
            end
        end
        local choose_item_combobox=WG.Chili.ComboBox:New{
            parent=panel,
            items=item_id_to_humanName,
            x=8,
            right=8,
            y=2,
            height=20,
            minWidth=300,
            width=300,
            OnSelect={function(self, i)
                local item_name=item_id_to_name[i]
                local item=items[item_name]
                if not item then
                    choosed_item=nil
                    UpdateUI()
                else
                    choosed_item=item_name
                    UpdateUI()
                end
            end

            }
        }

        local getValue=function ()
            if item_mod_ui==nil then
                return nil
            end
            --local weapon=items[current_item]
            return {
                current_item,
                item_mod_ui.getValue()
            }
        end

        local setValue=function (table)
            if table~=nil then
                
                local item_name,item_param=table[1],table[2]
                if item_name~=nil and item_param~=nil then
                    local item_base=items[item_name]
                    local item_id=item_name_to_id[item_name]
                    if item_id then
                        choose_item_combobox:Select(item_id)
                        --[=[
                        choosed_item=item_name
                        UpdateUI()
                        ]=]
                        item_mod_ui.setValue(item_param)
                    else
                        table=nil
                    end
                else
                    table=nil
                end
            end
            if table==nil then
                choose_item_combobox:Select(1)
                --[=[
                choosed_item=nil
                UpdateUI()
                ]=]
                return
            end
        end
        
        return{
            control=panel,
            getValue=getValue,
            setValue=setValue
        }
    end
end
function ui.ChooseOneToUse(id_to_name,id_to_humanName,name_to_id)
    return function(WG, parent)
        local choose_item_combobox = WG.Chili.ComboBox:New {
            parent = parent,
            items = id_to_humanName,
            height = 20,
            minWidth = 100,
            width = 100,
        }
        ---@type ModifyUI
        return {
            control = choose_item_combobox,
            getValue = function()
                return id_to_name[choose_item_combobox.selected]
            end,
            setValue = function(v)
                choose_item_combobox:Select(name_to_id[v])
            end
        }
    end
end
utils.ui=ui
GameData.CustomUnits.utils=utils