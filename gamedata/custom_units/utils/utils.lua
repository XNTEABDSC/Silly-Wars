local utils=GameData.CustomUnits.utils

---use modifies.name to find value in modtable and modfn.
---modify.modfn(data,modtable[modify.name])
---error for unused modifies in modtable
---@param modifies list<CustomModify>
utils.UseModifies=function (modifies)
    ---@generic T
    ---@param data T
    ---@return T
    return function (data,modtable)
        for index, modify in pairs(modifies) do
            local modv=modtable[modify.name]
            if modv~=nil then
                modify.modfn(data,modv)
                modtable[modify.name]=nil
            end
        end
        ---@type string
        local unused=""
        for key, value in pairs(modtable) do
            unused=unused .. tostring( key) .. " : " .. tostring( value) .. " , "
        end
        if unused:len()>1 then
            error("unused modifies " .. unused)
        end
        return data
    end
end

---comments
---@param name string
---@param desc string
---@param pic string
---@param modfn function
---@param UI ModifyUIgenfn|string
---@param moddeffn function|nil
---@return CustomModify
local function genCustomModify(name,desc,pic,modfn,UI,moddeffn)
    if type(UI) == "string" then
        UI=utils.ui.AutoEditBoxUI(UI)
    end
    moddeffn=moddeffn or function (v)
        return v
    end
    ---@type CustomModify
    return {
        name=name,
        description=desc,
        pic=pic,
        modfn=modfn,
        genUIFn=
        utils.ui.UIPicThen(pic,name,desc,UI),
        --utils.ui.SimpleValueUI(pic,name,desc,paramType),
        moddeffn=moddeffn,
    }
end
utils.genCustomModify=genCustomModify
GameData.CustomUnits.utils=utils