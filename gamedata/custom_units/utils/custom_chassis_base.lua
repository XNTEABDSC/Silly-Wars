VFS.Include("LuaRules/Utilities/wacky_utils.lua")
local wacky_utils = Spring.Utilities.wacky_utils

local utils=GameData.CustomUnits.utils

---@class CustomChassisBaseParams
---@field name string
---@field humanName string
---@field description string
---@field pictrue string
---@field weapons_slots list<list<string>>
---@field modifies list<CustomModify>
---@field unitDef table

---@param params CustomChassisBaseParams
utils.GenCustomChassisBase=function (params)
    
    local modifies = params.modifies

    local ModifyFn=utils.UseModifies(modifies)
    local name = params.name
    local humanName=params.humanName
    local weapons_slots = params.weapons_slots

    local unit_weapons, targeter_name_to_unit_weapon = utils.GenChassisUnitWeapons(weapons_slots)
    local pic=params.pictrue
    local desc=params.description
    local unitDef = params.unitDef

    unitDef.name = unitDef.name or humanName
    unitDef.description = unitDef.description or desc
    unitDef.weapons=unit_weapons
    
    unitDef.health                 = utils.consts.custom_health_const
    unitDef.metalCost              = utils.consts.custom_cost_const

    local speed_base = unitDef.speed
    ---@type CustomChassisData
    return {
        name = name,
        pic=pic,
        description=desc,
        humanName=humanName,
        genUnitDefs = function()
            local res={[name]=unitDef and Spring.Utilities.CopyTable(unitDef,true) or nil}
            for i = 1, #modifies do
                if modifies[i].moddeffn then
                    res=modifies[i].moddeffn(res) or res
                end
            end
            return res
            --[=[
            for key, value in pairs(res) do
                UnitDefs[key]=lowerkeys(value)
            end]=]
        end,
        genfn = function(params_)
            local cud = utils.ACustomUnitDataModify()
            cud.chassis_name = name
            cud.UnitDefName=name
            local res = ModifyFn(cud, params_)
            return res
        end,
        weapon_slots = weapons_slots,
        targeter_name_to_unit_weapon = targeter_name_to_unit_weapon,
        speed_base = speed_base,
        modifies=modifies,
        genUIFn=utils.ui.UIPicThen(pic,humanName,desc,utils.ui.StackModifies(modifies,2))
    }

end

GameData.CustomUnits.utils=utils