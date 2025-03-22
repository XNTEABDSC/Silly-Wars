local utils_op=Spring.Utilities.to_make_op_things
local wacky_utils=Spring.Utilities.wacky_utils

local utils = GameData.CustomUnits.utils

---use modifies.name to find value in modtable and modfn.
---modify.modfn(data,modtable[modify.name])
---error for unused modifies in modtable
---@param modifies list<CustomModify>
utils.UseModifies = function(modifies)
    ---@generic T
    ---@param data T
    ---@return T
    return function(data, modtable)
        for index, modify in pairs(modifies) do
            local modv = modtable[modify.name]
            modify.modfn(data, modv)
            modtable[modify.name] = nil
        end
        ---@type string
        local unused = ""
        for key, value in pairs(modtable) do
            unused = unused .. tostring(key) .. " : " .. tostring(value) .. " , "
        end
        if unused:len() > 1 then
            error("unused modifies " .. unused)
        end
        return data
    end
end

---make a `CustomModify`
---@param name string
---@param desc string
---@param pic string
---@param modfn function
---@param UI ModifyUIgenfn|("string"|"number"|"boolean")
---@param moddeffn function|nil
---@return CustomModify
local function genCustomModify(name, desc, pic, modfn, UI, moddeffn)
    if type(UI) == "string" then
        UI = utils.ui.AutoEditBoxUI(UI)
    end
    moddeffn = moddeffn or function(v)
        return v
    end
    ---@type CustomModify
    return {
        name = name,
        description = desc,
        pic = pic,
        modfn = modfn,
        genUIFn =
            utils.ui.UIPicThen(pic, name, desc, UI),
        --utils.ui.SimpleValueUI(pic,name,desc,paramType),
        moddeffn = moddeffn,
    }
end
utils.genCustomModify = genCustomModify

---returns `fn(datas)` run `foreachfn(key, value)` for each data and merge results
---@generic T
---@param foreachfn fun(key:string,value:T):{[string]:T}
---@return fun(datas:{[string]:T}):{[string]:T}
utils.genSpamDefsFn = function(foreachfn)
    return function(datas)
        local newts = {}
        for key, value in pairs(datas) do
            for key_, value_ in pairs(foreachfn(key, value)) do
                newts[key_] = value_
            end
        end
        return newts
    end
end

do
    ---make a `CustomModify` that use one modifie choosed in `modifies`, gen moddef for modifies
    ---@param modifies list<{name:string,humanName:string,moddeffn:fun(wd:table)|nil,modfn:fun(cwd:CustomWeaponDataModify)|nil}>
    local function genCustomModifyChoose1Modify(name,desc,pic,modifies)
        ---@type {[string]:{name:string,humanName:string,moddeffn:fun(wd:table)|nil,modfn:fun(cwd:CustomWeaponDataModify)|nil}}
        local modifies_name = {}
        ---@type {[integer]:string}
        local modifies_id_to_humanName = {}
        ---@type {[integer]:string}
        local modifies_id_to_name = {}
        ---@type {[string]:integer}
        local modifies_name_to_id = {}
        for key, value in pairs(modifies) do
            --[=[
        if value.explosionGenerator:find("custom:") then
            value.explosionGenerator=string.sub( value.explosionGenerator, ("custom:"):len()+1)
        end]=]

            modifies_name[value.name] = value
            modifies_id_to_humanName[key] = value.humanName
            modifies_id_to_name[key] = value.name
            modifies_name_to_id[value.name] = key
        end
        return utils.genCustomModify(
            name,desc,pic,
            ---@param wd CustomWeaponDataModify
            function(wd, choice)
                if choice == nil or choice == false then
                    return
                end

                local aoe = modifies_name[choice]
                if aoe then
                    if aoe.modfn then
                        aoe.modfn(wd)
                    end
                    if aoe.moddeffn then
                        wd.weapon_def_name = wd.weapon_def_name .. "_" .. aoe.name
                    end
                else
                    error("modify " .. tostring(choice) .. " don't exist")
                end
            end,
            utils.ui.ChooseOneToUse(modifies_id_to_name, modifies_id_to_humanName, modifies_name_to_id),
            utils.genSpamDefsFn(function(wdname, wd)
                local res = {}
                for _, value in pairs(modifies) do
                    
                    if value.moddeffn then
                        local key = value.name
                        local newwd = Spring.Utilities.CopyTable(wd, true)
                        local newname
                        newname = wdname .. "_" .. key
                        newwd=value.moddeffn(newwd) or newwd
                        res[newname] = newwd
                    else
                        if not res[wdname] then
                            res[wdname]= Spring.Utilities.CopyTable(wd, true)
                        end
                    end
                end
                return res
            end)
        )
    end
    utils.genCustomModifyChoose1Modify = genCustomModifyChoose1Modify
    utils.genCustomModifyChoose1Modify_Empty={
        name = "empty",
        humanName = "Empty",
        desc = "empty",
    }
end

---gen unit def for CustomChassisBaseParams.<br/>
---set some values
---@param udname string name of ud, uses `GetUnitLua`
---@param thenfn fun(ud:any) fn on ud
---@return any ud
function utils.GenCustomUnitChassisUnitDef(name,desc,udname,thenfn)
    local ud=utils_op.GetUnitLua(udname)
    local ud_proxy=wacky_utils.may_lower_key_proxy(ud,wacky_utils.may_lower_key_proxy_ud_checkkeys)
    ud_proxy.name=name
    ud_proxy.desc=desc
    ud_proxy.health                 = utils.consts.custom_health_const
    ud_proxy.metalCost              = utils.consts.custom_cost_const
    ud_proxy.weaponDefs=nil
    ud_proxy.weapons=nil
    ud_proxy.autoHeal=nil
    ud_proxy.idleAutoHeal=nil
    ud_proxy.idleTime=nil
    ud_proxy.explodeAs=nil
    ud_proxy.selfDestructAs=nil
    ud_proxy.sightDistance=600
    ud_proxy.radarDistance=nil
    ud_proxy.sonarDistance =300

    if thenfn then
        thenfn(ud_proxy)
    end
    return ud
end

---script=[[custom_unit_proxy_use.lua]] and set cp.custom_unit_proxy_use_<br/>
---for `GenCustomUnitChassisUnitDef`
---@param def_piece_weapon_num any
---@return function
function utils.GenCustomUnitChassisUnitDef_custom_unit_proxy_use(def_piece_weapon_num)
    def_piece_weapon_num=(def_piece_weapon_num~=nil and def_piece_weapon_num) or 1
    
    return function (t)
        local script=t.script
        wacky_utils.table_replace({
            script=[[custom_unit_proxy_use.lua]],
            customParams={
              custom_unit_proxy_use_script=script,
              custom_unit_proxy_use_def_piece_weapon_num=def_piece_weapon_num,
            }
          })(t)
    end
end

GameData.CustomUnits.utils = utils
