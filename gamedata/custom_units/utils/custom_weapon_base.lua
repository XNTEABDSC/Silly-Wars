local utils=GameData.CustomUnits.utils


---@class CustomWeaponBaseParams
---@field name string
---@field humanName string
---@field description string
---@field pictrue string
---@field WeaponDef table
---@field Modifies list<CustomModify>
---@field targeter string

---@param params CustomWeaponBaseParams
utils.GenCustomWeaponBase=function (params)
    
    local name = params.name
    local pic = params.pictrue
    local desc = params.description
    local humanName = params.humanName
    local weaponDef = params.WeaponDef

    local custom_weapon_data              = utils.ACustomWeaponData()
    custom_weapon_data.weapon_def_name    = name
    --[=[
    do
        local damageMax=0
        for key, value in pairs(weaponDef.damage) do
            damageMax=math.max(damageMax,value)
            custom_weapon_data.damages_base[key]=value
        end
        custom_weapon_data.damage_default_base=damageMax
    end
    ]=]
    --custom_weapon_data.damage_default_base=weaponDef.damage.default

    --[=[
    custom_weapon_data.projSpeed_base=weaponDef.weaponVelocity
    custom_weapon_data.range_base=weaponDef.range
    custom_weapon_data.reload_time_base=weaponDef.reloadtime
    ]=]

    --[=[
    custom_weapon_data.aoe                = weaponDef.areaOfEffect
    custom_weapon_data.explosionGenerator = weaponDef.explosionGenerator
    custom_weapon_data.explosionSpeed     = weaponDef.explosionSpeed
    custom_weapon_data.edgeEffectiveness  = weaponDef.edgeEffectiveness
    --]=]

    custom_weapon_data.targeter_weapon    = params.targeter

    local modifies                        = params.Modifies

    local modifyfn = utils.UseModifies(modifies)

    ---@type CustomWeaponBaseData
    local res =
    {
        name = name,
        humanName = humanName,
        pic = pic,
        genWeaponDef = function()
            local res={[name]=weaponDef}
            for i = 1, #modifies do
                if modifies[i].moddeffn then
                    res=modifies[i].moddeffn(res)
                end
            end
            --[=[
            for key, value in pairs(res) do
                WeaponDefs[key]=lowerkeys(value)
            end]=]
            return res
            --WeaponDefs[name] = lowerkeys(weaponDef)
        end,
        custom_weapon_data = custom_weapon_data,
        genfn = function(mutate_table)
            return modifyfn(Spring.Utilities.CopyTable(custom_weapon_data, true), mutate_table)
        end,
        modifies = modifies,
        genUIFn = utils.ui.UIPicThen(pic, humanName, desc, utils.ui.StackModifies(modifies,2))
    }
    return res
end

GameData.CustomUnits.utils=utils