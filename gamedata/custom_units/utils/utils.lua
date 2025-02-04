local utils=GameData.CustomUnits.utils

---use modifies.name to find value in modtable and modfn.
---modify.modfn(data,modtable[modify.name])
---error for unused modifies in modtable
---@param modifies list<CustomModify>
utils.UseModifies=function (modifies)
    return function (data,modtable)
        for index, modify in pairs(modifies) do
            local modv=modtable[modify.name]
            if modv then
                modify.modfn(data,modv)
                modtable[modify.name]=nil
            end
        end
        ---@type string
        local unused=""
        for key, value in pairs(modtable) do
            unused=unused .. tostring( key) .. ":" .. tostring( value) .. ","
        end
        if unused:len()>1 then
            error("unused modifies " .. unused)
        end
        return data
    end
end

local function genCustomModify(name,desc,pic,modfn,paramType)
    ---@type CustomModify
    return {
        name=name,
        description=desc,
        pic=pic,
        modfn=modfn,
        paramType=paramType,
        genUIFn=utils.ui.SimpleValueUI(pic,name,desc,paramType),
    }
end
utils.genCustomModify=genCustomModify
GameData.CustomUnits.utils=utils